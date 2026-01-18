"""Scraper for Acquire.com mobile app listings with login support."""

import asyncio
import re

from ..core.config import settings
from ..core.playwright_scraper import PlaywrightScraper
from .models import (
    BusinessModel,
    CredentialType,
    Platform,
    RevenueApp,
)
from .schemas import ExtractedApp


class AcquireScraper(PlaywrightScraper):
    """Scraper for Acquire.com marketplace.

    Acquire.com requires login to view listings. Uses Playwright for:
    - Login flow
    - Infinite scroll to load all listings
    - Individual page extraction
    """

    BASE_URL = "https://acquire.com"
    LOGIN_URL = "https://acquire.com/login"
    LISTINGS_URL = "https://acquire.com/all-listings"

    EXTRACTION_INSTRUCTION = """
Extract mobile app listing data from this Acquire.com sale page.

Extract the following (only if explicitly stated, don't guess):
- name: App name or listing title
- platform: 'ios', 'android', or 'both' - look for iOS, Android, iPhone, iPad mentions
- app_store_url: Apple App Store URL if present
- play_store_url: Google Play Store URL if present
- asking_price: The asking/sale price in USD
- mrr: Monthly Recurring Revenue if stated
- arr: Annual Recurring Revenue if stated
- annual_revenue: Yearly revenue/TTM if stated
- monthly_profit: Monthly profit/net income if stated
- total_downloads: Total lifetime downloads
- monthly_downloads: Monthly downloads if stated
- active_subscribers: Number of paying subscribers
- active_users: Active users/MAU if stated
- churn_rate: Monthly churn rate percentage
- growth_rate: Revenue growth rate percentage
- category: App category
- business_model: 'subscription', 'freemium', 'paid', or 'ads'
- description: Brief description of the app
- is_mobile_app: TRUE if this is a mobile app (iOS/Android), FALSE otherwise

Convert currency values to numbers:
- "$300,000" -> 300000
- "$1.5M" -> 1500000
- "$50K" -> 50000

IMPORTANT: Only extract what is visible. Acquire often has confidential listings.
"""

    async def login(self, page) -> bool:
        """Login to Acquire.com."""
        email = settings.acquire_email
        password = settings.acquire_password

        if not email or not password:
            print("Acquire credentials not configured")
            return False

        try:
            await page.goto(self.LOGIN_URL)
            await asyncio.sleep(1)

            # Fill login form
            await page.fill('input[type="email"]', email)
            await page.fill('input[type="password"]', password)

            # Click login button
            await page.click('button[type="submit"]')

            # Wait for redirect to dashboard
            await page.wait_for_url("**/dashboard**", timeout=10000)
            print("Successfully logged in to Acquire.com")
            return True

        except Exception as e:
            print(f"Login failed: {e}")
            return False

    async def get_listing_urls(self, page) -> list[str]:
        """Get all mobile app listing URLs via infinite scroll."""
        await page.goto(self.LISTINGS_URL)
        await asyncio.sleep(2)

        # Filter for mobile apps if filter available
        try:
            # Look for category/type filter
            filter_button = page.locator('text=Mobile App')
            if await filter_button.count() > 0:
                await filter_button.click()
                await asyncio.sleep(1)
        except Exception:
            pass

        # Scroll to load all listings
        await self.scroll_to_bottom(page, max_scrolls=100, scroll_delay=1.5)

        # Extract listing URLs
        html = await page.content()
        urls = re.findall(r'href="(/startup/[^"]+)"', html)
        urls = list(set(f"{self.BASE_URL}{url}" for url in urls))

        return urls

    async def scrape_listing_page(
        self,
        page,
        url: str,
    ) -> tuple[RevenueApp | None, bool]:
        """Scrape a single listing page."""
        try:
            html = await self.get_page_html(page, url)

            # Extract listing ID from URL
            match = re.search(r"/startup/([^/]+)", url)
            listing_id = match.group(1) if match else url.split("/")[-1]

            extracted = await self._extractor.extract_from_html(
                html=html,
                schema=ExtractedApp,
                instruction=self.EXTRACTION_INSTRUCTION,
            )

            if not extracted:
                return None, False

            app_data = extracted[0]

            if not app_data.is_mobile_app:
                print(f"Skipping non-mobile: {app_data.name}")
                return None, True

            return self._to_revenue_app(app_data, listing_id, url), False

        except Exception as e:
            print(f"Error scraping {url}: {e}")
            return None, False

    async def scrape_all(
        self,
        limit: int | None = None,
        skip_urls: set[str] | None = None,
    ) -> tuple[list[RevenueApp], list[str]]:
        """Scrape all mobile app listings from Acquire.com."""
        skip_urls = skip_urls or set()

        apps: list[RevenueApp] = []
        skipped_urls_list: list[str] = []

        async with self.new_context() as context:
            async with self.new_page(context) as page:
                # Login first
                if not await self.login(page):
                    return [], []

                # Get listing URLs
                listing_urls = await self.get_listing_urls(page)
                print(f"Found {len(listing_urls)} listings on Acquire.com")

                # Filter already processed
                urls_to_process = [url for url in listing_urls if url not in skip_urls]
                skipped_count = len(listing_urls) - len(urls_to_process)
                if skipped_count > 0:
                    print(f"Skipping {skipped_count} already processed URLs")

                if limit:
                    urls_to_process = urls_to_process[:limit]
                    print(f"Limiting to {limit} listings")

                for i, url in enumerate(urls_to_process):
                    app, is_skipped = await self.scrape_listing_page(page, url)
                    if app:
                        apps.append(app)
                    elif is_skipped:
                        skipped_urls_list.append(url)

                    if (i + 1) % 10 == 0:
                        print(f"Progress: {i + 1}/{len(urls_to_process)}, {len(apps)} apps")

                    await asyncio.sleep(0.5)

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

        return RevenueApp(
            source="acquire",
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
            monthly_profit_cents=int(extracted.monthly_profit * 100) if extracted.monthly_profit else None,
            asking_price_cents=int(extracted.asking_price * 100) if extracted.asking_price else None,
            currency="USD",
            revenue_verified=False,
            credential_type=CredentialType.SELF_REPORTED,
            total_downloads=extracted.total_downloads,
            monthly_downloads=extracted.monthly_downloads,
            active_subscribers=extracted.active_subscribers,
            active_users=extracted.active_users,
            churn_rate=extracted.churn_rate,
            growth_rate_mom=extracted.growth_rate,
            category=extracted.category,
            business_model=biz_model,
            description=extracted.description,
            is_for_sale=True,
        )


async def scrape_acquire(
    limit: int | None = None,
    skip_urls: set[str] | None = None,
) -> tuple[list[RevenueApp], list[str]]:
    """Convenience function to scrape Acquire.com."""
    async with AcquireScraper() as scraper:
        return await scraper.scrape_all(limit=limit, skip_urls=skip_urls)
