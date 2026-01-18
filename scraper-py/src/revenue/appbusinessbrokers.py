"""Scraper for appbusinessbrokers.com revenue data using LLM extraction."""

import asyncio
import re
import xml.etree.ElementTree as ET

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


class AppBusinessBrokersScraper:
    """Scraper for appbusinessbrokers.com marketplace.

    AppBusinessBrokers is a broker for app and software businesses.
    Uses sitemap to discover listings and LLM extraction for individual pages.
    """

    BASE_URL = "https://www.appbusinessbrokers.com"
    SITEMAP_URL = "https://www.appbusinessbrokers.com/listing-sitemap.xml"
    DEFAULT_HEADERS = {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.5",
    }

    EXTRACTION_INSTRUCTION = """
Extract the mobile app listing data from this page. This is a business-for-sale listing.

Extract:
- App name (from the title)
- Platform: 'ios', 'android', or 'both' - look for mentions of iOS, Android, iPhone, Play Store
- App Store URL if mentioned
- Play Store URL if mentioned
- MRR (Monthly Recurring Revenue) - look for "$XXK MRR" or "MRR: $XX,XXX"
- Annual revenue (TTM revenue, yearly revenue)
- Monthly profit or annual profit
- Asking price (sale price)
- Total downloads and monthly downloads
- Active subscribers
- App Store rating (0-5 stars)
- Category (utilities, health-fitness, games, etc.)
- Business model (subscription, freemium, paid, ads)
- Short description
- is_mobile_app: Set to FALSE if this is NOT a mobile app (e.g., Shopify store, Amazon FBA, SaaS web app, WordPress theme, browser extension). Set to TRUE only for actual iOS/Android mobile apps.

IMPORTANT: Only extract data that is explicitly stated. Don't guess or infer values.
Convert all revenue/price values to numbers (e.g., "$80K" = 80000, "$1.5M" = 1500000).
"""

    def __init__(self, timeout: float = 30.0, max_concurrent: int = 3):
        self.timeout = timeout
        self.max_concurrent = max_concurrent
        self._extractor = LLMExtractor()
        self._proxy = ProxyRouter.from_env(settings.proxy_list)
        if self._proxy.has_proxies:
            print("AppBusinessBrokersScraper: Using proxy rotation")

    async def get_listing_urls(self) -> list[str]:
        """Fetch sitemap and extract listing URLs."""
        async with self._proxy.get_httpx_client(
            timeout=self.timeout,
            headers=self.DEFAULT_HEADERS,
            follow_redirects=True,
        ) as client:
            response = await client.get(self.SITEMAP_URL)
            response.raise_for_status()

        # Parse XML
        root = ET.fromstring(response.text)
        namespace = {"ns": "http://www.sitemaps.org/schemas/sitemap/0.9"}

        urls = []
        for url_elem in root.findall(".//ns:loc", namespace):
            url = url_elem.text
            # Skip the main listing page, only get individual listings
            if url and url != f"{self.BASE_URL}/listing/":
                urls.append(url)

        return urls

    async def scrape_listing_page(
        self,
        client: httpx.AsyncClient,
        url: str,
    ) -> tuple[RevenueApp | None, bool]:
        """Scrape a single listing page.

        Returns:
            Tuple of (app, is_skipped) where is_skipped=True means it's not a mobile app.
        """
        try:
            response = await client.get(url)
            response.raise_for_status()
            html = response.text

            # Extract slug for source_id
            slug = self._extract_slug(url)

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

            return self._to_revenue_app(app_data, slug, url), False

        except Exception as e:
            print(f"Error scraping {url}: {e}")
            return None, False

    async def scrape_all(
        self,
        limit: int | None = None,
        skip_urls: set[str] | None = None,
    ) -> tuple[list[RevenueApp], list[str]]:
        """Scrape all app listings from appbusinessbrokers.com.

        Args:
            limit: Optional limit on number of listings to scrape (for testing)
            skip_urls: Set of URLs to skip (already processed)

        Returns:
            Tuple of (apps, skipped_urls) where skipped_urls are non-mobile-app URLs
        """
        skip_urls = skip_urls or set()

        # Get listing URLs from sitemap
        listing_urls = await self.get_listing_urls()
        print(f"Found {len(listing_urls)} listings in sitemap")

        # Filter out already processed URLs
        urls_to_process = [url for url in listing_urls if url not in skip_urls]
        skipped_count = len(listing_urls) - len(urls_to_process)
        if skipped_count > 0:
            print(f"Skipping {skipped_count} already processed URLs")

        if limit:
            urls_to_process = urls_to_process[:limit]
            print(f"Limiting to {limit} listings for this run")

        # Scrape listings with concurrency limit
        semaphore = asyncio.Semaphore(self.max_concurrent)
        apps: list[RevenueApp] = []
        skipped_urls_list: list[str] = []

        async def scrape_with_url(url: str) -> tuple[str, RevenueApp | None, bool]:
            async with semaphore:
                async with self._proxy.get_httpx_client(
                    timeout=self.timeout,
                    headers=self.DEFAULT_HEADERS,
                    follow_redirects=True,
                ) as client:
                    app, is_skipped = await self.scrape_listing_page(client, url)
                    return url, app, is_skipped

        tasks = [scrape_with_url(url) for url in urls_to_process]

        for i, coro in enumerate(asyncio.as_completed(tasks)):
            url, app, is_skipped = await coro
            if app:
                apps.append(app)
            elif is_skipped:
                skipped_urls_list.append(url)
            if (i + 1) % 10 == 0:
                print(f"Progress: {i + 1}/{len(urls_to_process)} listings scraped, {len(apps)} mobile apps found")

        print(f"Completed: {len(apps)} mobile apps, {len(skipped_urls_list)} non-mobile skipped from {len(urls_to_process)} listings")
        return apps, skipped_urls_list

    def _extract_slug(self, url: str) -> str:
        """Extract slug from listing URL."""
        match = re.search(r"/listing/([^/]+)/", url)
        return match.group(1) if match else ""

    def _to_revenue_app(self, extracted: ExtractedApp, slug: str, url: str) -> RevenueApp:
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
            source="appbusinessbrokers",
            source_id=slug,
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
            category=extracted.category,
            business_model=biz_model,
            description=extracted.description,
            is_for_sale=True,
            ios_rating=extracted.rating if platform != Platform.ANDROID else None,
            android_rating=extracted.rating if platform == Platform.ANDROID else None,
        )


async def scrape_appbusinessbrokers(
    limit: int | None = None,
    skip_urls: set[str] | None = None,
) -> tuple[list[RevenueApp], list[str]]:
    """Convenience function to scrape appbusinessbrokers.com.

    Args:
        limit: Optional limit on number of listings to scrape (for testing)
        skip_urls: Set of URLs to skip (already processed)
    """
    scraper = AppBusinessBrokersScraper()
    return await scraper.scrape_all(limit=limit, skip_urls=skip_urls)
