"""Scraper for Flippa mobile app listings using Playwright + LLM extraction."""

import re

from ..core.playwright_scraper import PlaywrightScraper
from .models import (
    BusinessModel,
    CredentialType,
    Platform,
    RevenueApp,
)
from .schemas import ExtractedApp


class FlippaScraper(PlaywrightScraper):
    """Scraper for Flippa marketplace.

    Flippa is a marketplace for buying and selling online businesses,
    including iOS and Android apps. Uses Playwright for Turbo Frame pagination.
    """

    BASE_URL = "https://flippa.com"
    SEARCH_URL = "https://flippa.com/search"

    EXTRACTION_INSTRUCTION = """
Extract mobile app listing data from this Flippa sale page.

Extract the following (only if explicitly stated, don't guess):
- name: App name or listing title
- platform: 'ios', 'android', or 'both' - look for iOS, Android, iPhone, iPad mentions
- app_store_url: Apple App Store URL if present
- play_store_url: Google Play Store URL if present
- asking_price: The asking/sale price in USD (e.g., "$300,000" = 300000)
- mrr: Monthly Recurring Revenue if stated
- annual_revenue: Yearly/TTM revenue if stated
- monthly_profit: Monthly profit/net income if stated
- total_downloads: Total lifetime downloads/installs
- monthly_downloads: Monthly downloads if stated
- active_subscribers: Number of paying subscribers if stated
- active_users: Active users/MAU if stated
- rating: App store rating (0-5)
- category: App category
- business_model: 'subscription', 'freemium', 'paid', or 'ads'
- description: Brief description of the app
- is_mobile_app: TRUE if this is a mobile app (iOS/Android), FALSE otherwise

Convert currency values to numbers:
- "$300,000" -> 300000
- "$1.5M" -> 1500000
- "$50K" -> 50000

IMPORTANT: Many Flippa listings are confidential with limited data. Only extract what is visible.
"""

    async def get_listing_ids(self, page) -> list[str]:
        """Get all mobile app listing IDs via pagination."""
        all_ids: set[str] = set()

        # Navigate to search page
        await page.goto(f"{self.SEARCH_URL}?filter[property_type]=ios_app,android_app")
        await self.page_delay()

        page_num = 1
        consecutive_empty = 0

        while page_num <= 500 and consecutive_empty < 3:
            # Wait for listings to load
            try:
                await page.wait_for_selector('[data-controller="listing-card"]', timeout=5000)
            except Exception:
                # No listings found, might be end of results
                pass

            # Extract listing IDs from current page
            html = await page.content()
            ids = re.findall(r"flippa\.com/(\d+)", html)
            new_ids = set(ids) - all_ids

            if len(new_ids) == 0:
                consecutive_empty += 1
            else:
                consecutive_empty = 0
                all_ids.update(ids)

            if page_num % 10 == 0:
                print(f"Flippa: Page {page_num}, {len(all_ids)} total listings")

            # Try to click next page
            try:
                next_button = page.locator('a[rel="next"]')
                if await next_button.count() == 0:
                    break
                await next_button.click()
                await self.medium_delay()
            except Exception:
                break

            page_num += 1

        return list(all_ids)

    async def scrape_listing_page(
        self,
        page,
        listing_id: str,
    ) -> tuple[RevenueApp | None, bool]:
        """Scrape a single listing page."""
        url = f"{self.BASE_URL}/{listing_id}"

        try:
            html = await self.get_page_html(page, url)

            extracted = await self._extractor.extract_from_html(
                html=html,
                schema=ExtractedApp,
                instruction=self.EXTRACTION_INSTRUCTION,
            )

            if not extracted:
                return None, False

            app_data = extracted[0]

            if not app_data.is_mobile_app:
                print(f"Skipping non-mobile app: {app_data.name}")
                return None, True

            return self._to_revenue_app(app_data, listing_id, url), False

        except Exception as e:
            print(f"Error scraping Flippa {listing_id}: {e}")
            return None, False

    async def scrape_all(
        self,
        limit: int | None = None,
        skip_urls: set[str] | None = None,
    ) -> tuple[list[RevenueApp], list[str]]:
        """Scrape all mobile app listings from Flippa."""
        skip_urls = skip_urls or set()

        apps: list[RevenueApp] = []
        skipped_urls_list: list[str] = []

        async with self.new_context() as context:
            async with self.new_page(context) as page:
                # Get listing IDs
                listing_ids = await self.get_listing_ids(page)
                print(f"Found {len(listing_ids)} mobile app listings on Flippa")

                # Filter already processed
                ids_to_process = [
                    lid for lid in listing_ids
                    if f"{self.BASE_URL}/{lid}" not in skip_urls
                ]
                skipped_count = len(listing_ids) - len(ids_to_process)
                if skipped_count > 0:
                    print(f"Skipping {skipped_count} already processed URLs")

                if limit:
                    ids_to_process = ids_to_process[:limit]
                    print(f"Limiting to {limit} listings")

                for i, listing_id in enumerate(ids_to_process):
                    url = f"{self.BASE_URL}/{listing_id}"
                    app, is_skipped = await self.scrape_listing_page(page, listing_id)
                    if app:
                        apps.append(app)
                    elif is_skipped:
                        skipped_urls_list.append(url)

                    if (i + 1) % 10 == 0:
                        print(f"Progress: {i + 1}/{len(ids_to_process)}, {len(apps)} apps")

                    # Random delay between pages to avoid detection
                    await self.long_delay()

        print(f"Completed: {len(apps)} apps, {len(skipped_urls_list)} skipped")
        return apps, skipped_urls_list

    def _to_revenue_app(self, extracted: ExtractedApp, listing_id: str, url: str) -> RevenueApp:
        """Convert ExtractedApp to RevenueApp."""
        apple_id = None
        if extracted.app_store_url:
            match = re.search(r"/id(\d+)", extracted.app_store_url)
            if match:
                apple_id = match.group(1)

        bundle_id = None
        if extracted.play_store_url:
            match = re.search(r"id=([^&]+)", extracted.play_store_url)
            if match:
                bundle_id = match.group(1)

        platform = Platform.IOS
        if extracted.platform == "android":
            platform = Platform.ANDROID
        elif extracted.platform == "both":
            platform = Platform.BOTH
        elif extracted.app_store_url and extracted.play_store_url:
            platform = Platform.BOTH
        elif extracted.play_store_url and not extracted.app_store_url:
            platform = Platform.ANDROID

        biz_model = None
        if extracted.business_model:
            biz_map = {
                "subscription": BusinessModel.SUBSCRIPTION,
                "freemium": BusinessModel.FREEMIUM,
                "paid": BusinessModel.PAID,
                "ads": BusinessModel.ADS,
            }
            biz_model = biz_map.get(extracted.business_model.lower())

        monthly_profit = extracted.monthly_profit
        if not monthly_profit and extracted.annual_profit:
            monthly_profit = extracted.annual_profit / 12

        return RevenueApp(
            source="flippa",
            source_id=listing_id,
            source_url=url,
            app_name=extracted.name,
            app_store_url=extracted.app_store_url,
            play_store_url=extracted.play_store_url,
            apple_id=apple_id,
            bundle_id=bundle_id,
            platform=platform,
            mrr_cents=int(extracted.mrr * 100) if extracted.mrr else None,
            annual_revenue_cents=int(extracted.annual_revenue * 100) if extracted.annual_revenue else None,
            monthly_profit_cents=int(monthly_profit * 100) if monthly_profit else None,
            asking_price_cents=int(extracted.asking_price * 100) if extracted.asking_price else None,
            currency="USD",
            revenue_verified=False,
            credential_type=CredentialType.SELF_REPORTED,
            total_downloads=extracted.total_downloads,
            monthly_downloads=extracted.monthly_downloads,
            active_subscribers=extracted.active_subscribers,
            active_users=extracted.active_users,
            category=extracted.category,
            business_model=biz_model,
            description=extracted.description,
            is_for_sale=True,
            ios_rating=extracted.ios_rating if platform != Platform.ANDROID else extracted.rating,
            android_rating=extracted.android_rating if platform != Platform.IOS else extracted.rating,
        )


async def scrape_flippa(
    limit: int | None = None,
    skip_urls: set[str] | None = None,
) -> tuple[list[RevenueApp], list[str]]:
    """Convenience function to scrape Flippa."""
    async with FlippaScraper() as scraper:
        return await scraper.scrape_all(limit=limit, skip_urls=skip_urls)
