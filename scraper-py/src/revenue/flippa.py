"""Scraper for Flippa mobile app listings using LLM extraction."""

import asyncio
import re

import httpx

from ..core.config import settings
from ..core.llm_extractor import LLMExtractor
from ..core.proxy import ProxyRouter
from .models import (
    BusinessModel,
    CredentialType,
    Platform,
    RevenueApp,
)
from .schemas import ExtractedApp


class FlippaScraper:
    """Scraper for Flippa marketplace.

    Flippa is a marketplace for buying and selling online businesses,
    including iOS and Android apps. Uses Turbo Frame pagination and
    LLM extraction for individual listings.
    """

    BASE_URL = "https://flippa.com"
    SEARCH_URL = "https://flippa.com/search"
    DEFAULT_HEADERS = {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.5",
    }

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
- is_mobile_app: TRUE if this is a mobile app (iOS/Android), FALSE otherwise (SaaS, website, etc.)

Convert currency values to numbers:
- "$300,000" -> 300000
- "$1.5M" -> 1500000
- "$50K" -> 50000

IMPORTANT: Many Flippa listings are confidential with limited data. Only extract what is visible.
"""

    def __init__(self, timeout: float = 30.0, max_concurrent: int = 3):
        self.timeout = timeout
        self.max_concurrent = max_concurrent
        self._extractor = LLMExtractor()
        self._proxy = ProxyRouter.from_env(settings.proxy_list)
        if self._proxy.has_proxies:
            print("FlippaScraper: Using proxy rotation")

    async def get_listing_ids(self) -> list[str]:
        """Get all mobile app listing IDs via Turbo Frame pagination."""
        all_ids: set[str] = set()
        page = 1
        consecutive_empty = 0

        async with self._proxy.get_httpx_client(
            timeout=self.timeout,
            headers=self.DEFAULT_HEADERS,
            follow_redirects=True,
        ) as client:
            # First get session cookies
            await client.get(f"{self.BASE_URL}/apps")

            while page <= 500 and consecutive_empty < 3:
                response = await client.get(
                    self.SEARCH_URL,
                    params={
                        "filter[property_type]": "ios_app,android_app",
                        "page": page,
                    },
                    headers={
                        "Accept": "text/vnd.turbo-stream.html, text/html",
                        "Turbo-Frame": "search_results",
                    },
                )

                # Extract listing IDs from HTML
                ids = re.findall(r"flippa\.com/(\d+)", response.text)
                new_ids = set(ids) - all_ids

                if len(new_ids) == 0:
                    consecutive_empty += 1
                else:
                    consecutive_empty = 0
                    all_ids.update(ids)

                if page % 10 == 0:
                    print(f"Flippa: Page {page}, {len(all_ids)} total listings found")

                page += 1

        return list(all_ids)

    async def scrape_listing_page(
        self,
        client: httpx.AsyncClient,
        listing_id: str,
    ) -> tuple[RevenueApp | None, bool]:
        """Scrape a single listing page.

        Returns:
            Tuple of (app, is_skipped) where is_skipped=True means it's not a mobile app.
        """
        url = f"{self.BASE_URL}/{listing_id}"

        try:
            response = await client.get(url)
            response.raise_for_status()
            html = response.text

            # Use LLM to extract data
            extracted = await self._extractor.extract_from_html(
                html=html,
                schema=ExtractedApp,
                instruction=self.EXTRACTION_INSTRUCTION,
            )

            if not extracted:
                return None, False

            app_data = extracted[0]

            # Filter out non-mobile apps
            if not app_data.is_mobile_app:
                print(f"Skipping non-mobile app: {app_data.name}")
                return None, True  # Mark as skipped

            return self._to_revenue_app(app_data, listing_id, url), False

        except Exception as e:
            print(f"Error scraping Flippa {listing_id}: {e}")
            return None, False

    async def scrape_all(
        self,
        limit: int | None = None,
        skip_urls: set[str] | None = None,
    ) -> tuple[list[RevenueApp], list[str]]:
        """Scrape all mobile app listings from Flippa.

        Args:
            limit: Optional limit on number of listings to scrape (for testing)
            skip_urls: Set of URLs to skip (already processed)

        Returns:
            Tuple of (apps, skipped_urls) where skipped_urls are non-mobile-app URLs
        """
        skip_urls = skip_urls or set()

        # Get listing IDs via pagination
        listing_ids = await self.get_listing_ids()
        print(f"Found {len(listing_ids)} mobile app listings on Flippa")

        # Filter out already processed URLs
        ids_to_process = [
            lid for lid in listing_ids
            if f"{self.BASE_URL}/{lid}" not in skip_urls
        ]
        skipped_count = len(listing_ids) - len(ids_to_process)
        if skipped_count > 0:
            print(f"Skipping {skipped_count} already processed URLs")

        if limit:
            ids_to_process = ids_to_process[:limit]
            print(f"Limiting to {limit} listings for this run")

        # Scrape listings sequentially with a single session to avoid rate limiting
        apps: list[RevenueApp] = []
        skipped_urls_list: list[str] = []

        async with self._proxy.get_httpx_client(
            timeout=self.timeout,
            headers=self.DEFAULT_HEADERS,
            follow_redirects=True,
        ) as client:
            # Get session cookies once
            await client.get(f"{self.BASE_URL}/apps")

            for i, listing_id in enumerate(ids_to_process):
                url = f"{self.BASE_URL}/{listing_id}"
                app, is_skipped = await self.scrape_listing_page(client, listing_id)
                if app:
                    apps.append(app)
                elif is_skipped:
                    skipped_urls_list.append(url)

                if (i + 1) % 10 == 0:
                    print(f"Progress: {i + 1}/{len(ids_to_process)} listings scraped, {len(apps)} mobile apps found")

                # Small delay between requests to avoid rate limiting
                await asyncio.sleep(0.5)

        print(f"Completed: {len(apps)} mobile apps, {len(skipped_urls_list)} non-mobile skipped from {len(ids_to_process)} Flippa listings")
        return apps, skipped_urls_list

    def _to_revenue_app(self, extracted: ExtractedApp, listing_id: str, url: str) -> RevenueApp:
        """Convert ExtractedApp to RevenueApp."""
        # Extract Apple ID from URL
        apple_id = None
        if extracted.app_store_url:
            match = re.search(r"/id(\d+)", extracted.app_store_url)
            if match:
                apple_id = match.group(1)

        # Extract bundle ID from Play Store URL
        bundle_id = None
        if extracted.play_store_url:
            match = re.search(r"id=([^&]+)", extracted.play_store_url)
            if match:
                bundle_id = match.group(1)

        # Determine platform
        platform = Platform.IOS
        if extracted.platform == "android":
            platform = Platform.ANDROID
        elif extracted.platform == "both":
            platform = Platform.BOTH
        elif extracted.app_store_url and extracted.play_store_url:
            platform = Platform.BOTH
        elif extracted.play_store_url and not extracted.app_store_url:
            platform = Platform.ANDROID

        # Map business model
        biz_model = None
        if extracted.business_model:
            biz_map = {
                "subscription": BusinessModel.SUBSCRIPTION,
                "freemium": BusinessModel.FREEMIUM,
                "paid": BusinessModel.PAID,
                "ads": BusinessModel.ADS,
            }
            biz_model = biz_map.get(extracted.business_model.lower())

        # Calculate monthly profit from annual if needed
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
            revenue_verified=False,  # Flippa data is self-reported
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
    """Convenience function to scrape Flippa.

    Args:
        limit: Optional limit on number of listings to scrape (for testing)
        skip_urls: Set of URLs to skip (already processed)
    """
    scraper = FlippaScraper()
    return await scraper.scrape_all(limit=limit, skip_urls=skip_urls)
