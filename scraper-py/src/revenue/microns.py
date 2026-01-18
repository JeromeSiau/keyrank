"""Scraper for microns.io revenue data using LLM extraction."""

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


class MicronsScraper:
    """Scraper for microns.io marketplace.

    Microns is a marketplace for micro-startups and SaaS businesses.
    Uses sitemap to discover listings and LLM extraction for individual pages.
    """

    BASE_URL = "https://www.microns.io"
    SITEMAP_URL = "https://www.microns.io/sitemap.xml"
    DEFAULT_HEADERS = {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.5",
    }

    EXTRACTION_INSTRUCTION = """
Extract the startup/business listing data from this Microns.io page.

Extract the following (only if explicitly stated, don't guess):
- name: Business/product name
- platform: 'ios' if iOS app, 'android' if Android app, 'both' if both platforms mentioned
- app_store_url: Apple App Store URL if present (apps.apple.com/...)
- play_store_url: Google Play Store URL if present (play.google.com/...)
- asking_price: The asking/sale price in USD
- mrr: Monthly Recurring Revenue if stated
- annual_revenue: ARR or annual revenue/sales if stated
- monthly_profit: Monthly profit if stated
- annual_profit: Annual profit if stated (divide by 12 for monthly)
- total_downloads: Total downloads/installs if stated
- active_users: Active users, customers, or user base count
- category: Business category (e.g., "Mobile app", "SaaS", "Newsletter")
- business_model: 'subscription', 'freemium', 'paid', or 'ads'
- description: Brief description of the business
- is_mobile_app: TRUE only if this is an actual mobile app (iOS/Android). FALSE for SaaS, web apps, browser extensions, newsletters, agencies, Shopify apps, WordPress plugins, Chrome extensions, etc.

Convert currency values to numbers:
- "$17,500" -> 17500
- "$3.5K" -> 3500
- "$1.2M" -> 1200000

IMPORTANT:
- is_mobile_app should be TRUE only for native iOS or Android mobile applications
- Look for keywords: "iOS app", "Android app", "mobile app", "App Store", "Play Store"
- SaaS products, web apps, and browser extensions are NOT mobile apps
"""

    def __init__(self, timeout: float = 30.0, max_concurrent: int = 3):
        self.timeout = timeout
        self.max_concurrent = max_concurrent
        self._extractor = LLMExtractor()
        self._proxy = ProxyRouter.from_env(settings.proxy_list)
        if self._proxy.has_proxies:
            print("MicronsScraper: Using proxy rotation")

    async def get_listing_urls(self) -> list[str]:
        """Fetch sitemap and extract startup listing URLs."""
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
            # Only get startup listing pages
            if url and "/startup-listings/" in url:
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
        """Scrape all mobile app listings from microns.io.

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
            if (i + 1) % 20 == 0:
                print(f"Progress: {i + 1}/{len(urls_to_process)} listings scraped, {len(apps)} mobile apps found")

        print(f"Completed: {len(apps)} mobile apps, {len(skipped_urls_list)} non-mobile skipped from {len(urls_to_process)} listings")
        return apps, skipped_urls_list

    def _extract_slug(self, url: str) -> str:
        """Extract slug from listing URL."""
        match = re.search(r"/startup-listings/([^/]+)/?$", url)
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
            source="microns",
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
            revenue_verified=False,  # Microns data is self-reported
            credential_type=CredentialType.SELF_REPORTED,
            total_downloads=extracted.total_downloads,
            active_users=extracted.active_users,
            category=extracted.category,
            business_model=biz_model,
            description=extracted.description,
            is_for_sale=True,
            ios_rating=extracted.ios_rating if platform != Platform.ANDROID else extracted.rating,
            android_rating=extracted.android_rating if platform != Platform.IOS else extracted.rating,
        )


async def scrape_microns(
    limit: int | None = None,
    skip_urls: set[str] | None = None,
) -> tuple[list[RevenueApp], list[str]]:
    """Convenience function to scrape microns.io.

    Args:
        limit: Optional limit on number of listings to scrape (for testing)
        skip_urls: Set of URLs to skip (already processed)
    """
    scraper = MicronsScraper()
    return await scraper.scrape_all(limit=limit, skip_urls=skip_urls)
