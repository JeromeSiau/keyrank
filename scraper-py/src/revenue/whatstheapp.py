"""Scraper for whatsthe.app revenue data using LLM extraction."""

import asyncio
import re
import xml.etree.ElementTree as ET
from typing import Any

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


class WhatsTheAppScraper:
    """Scraper for whatsthe.app marketplace.

    whatsthe.app displays RevenueCat-verified revenue data for mobile apps.
    Uses sitemap to discover apps and LLM extraction for individual pages.
    """

    BASE_URL = "https://whatsthe.app"
    SITEMAP_URL = "https://whatsthe.app/sitemap.xml"
    DEFAULT_HEADERS = {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.5",
    }

    # URLs to exclude (not app pages)
    EXCLUDED_PATTERNS = [
        r"^https://whatsthe\.app$",
        r"/apps-for-sale",
        r"/looking-for-cofounder",
        r"/leaderboard",
        r"/blogs",
        r"/recent$",
        r"/search$",
        r"/statistics",
        r"/categories$",
        r"/hall-of-shame",
        r"/docs/",
        r"/privacy$",
        r"/terms$",
        r"/founder/",
        r"/category/",
        r"/games$",
    ]

    EXTRACTION_INSTRUCTION = """
Extract app metrics from this individual app page on whatsthe.app.

This page shows detailed RevenueCat-verified revenue data for a mobile app.

Extract the following metrics (convert values to numbers):
- name: The app name
- mrr: Monthly Recurring Revenue (e.g., "$381K" = 381000)
- annual_revenue: ARR - Annual Recurring Revenue (e.g., "$4.572M" = 4572000)
- monthly_revenue: Last 28 days revenue if shown
- active_subscribers: Number of active subscriptions
- active_trials: Number of active trials
- active_users: Total active customers
- new_customers: New customers in last 28 days
- monthly_downloads: Downloads shown (may be total Android downloads)
- ltv: Customer Lifetime Value (e.g., "$642" = 642)
- arpu: Average Revenue Per User (e.g., "$5" = 5)
- churn_rate: Monthly churn rate percentage (e.g., "0.85%" = 0.85)
- mrr_growth: MRR growth percentage (e.g., "-0.6%" = -0.6)
- ios_rating: iOS App Store rating (0-5)
- android_rating: Android Play Store rating (0-5)
- app_store_url: Apple App Store URL (apps.apple.com/...)
- play_store_url: Google Play Store URL (play.google.com/...)
- platform: "ios" if only App Store, "android" if only Play Store, "both" if both
- description: Short app description if available
- category: App category if shown

Convert:
- "$381K" -> 381000
- "$4.572M" -> 4572000
- "$1,234" -> 1234
- "0.85%" -> 0.85
- "-0.6%" -> -0.6

Return a single object (not an array) since this is a single app page.
"""

    def __init__(self, timeout: float = 30.0, max_concurrent: int = 5):
        self.timeout = timeout
        self.max_concurrent = max_concurrent
        self._extractor = LLMExtractor()
        self._proxy = ProxyRouter.from_env(settings.proxy_list)
        if self._proxy.has_proxies:
            print("WhatsTheAppScraper: Using proxy rotation")

    async def get_app_urls(self) -> list[str]:
        """Fetch sitemap and extract app URLs."""
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
            if url and not self._is_excluded(url):
                urls.append(url)

        return urls

    def _is_excluded(self, url: str) -> bool:
        """Check if URL should be excluded (not an app page)."""
        for pattern in self.EXCLUDED_PATTERNS:
            if re.search(pattern, url):
                return True
        return False

    async def scrape_app_page(
        self,
        client: httpx.AsyncClient,
        url: str,
    ) -> RevenueApp | None:
        """Scrape a single app page."""
        try:
            response = await client.get(url)
            response.raise_for_status()
            html = response.text

            # Extract app slug from URL for source_id
            slug = url.replace(self.BASE_URL, "").strip("/")

            # Use LLM to extract data
            extracted_list = await self._extractor.extract_from_html(
                html=html,
                schema=ExtractedApp,
                instruction=self.EXTRACTION_INSTRUCTION,
            )

            if not extracted_list:
                return None

            extracted = extracted_list[0]
            return self._to_revenue_app(extracted, slug, url)

        except Exception as e:
            print(f"Error scraping {url}: {e}")
            return None

    async def scrape_all(
        self,
        limit: int | None = None,
        skip_urls: set[str] | None = None,
    ) -> tuple[list[RevenueApp], list[str]]:
        """Scrape all apps from whatsthe.app using sitemap.

        Args:
            limit: Optional limit on number of apps to scrape (for testing)
            skip_urls: Set of URLs to skip (already processed)

        Returns:
            Tuple of (apps, skipped_urls) where skipped_urls are non-mobile-app URLs
        """
        skip_urls = skip_urls or set()

        # Get app URLs from sitemap
        app_urls = await self.get_app_urls()
        print(f"Found {len(app_urls)} app URLs in sitemap")

        # Filter out already processed URLs
        urls_to_process = [url for url in app_urls if url not in skip_urls]
        skipped_count = len(app_urls) - len(urls_to_process)
        if skipped_count > 0:
            print(f"Skipping {skipped_count} already processed URLs")

        if limit:
            urls_to_process = urls_to_process[:limit]
            print(f"Limiting to {limit} apps for this run")

        # Scrape apps with concurrency limit
        semaphore = asyncio.Semaphore(self.max_concurrent)
        apps: list[RevenueApp] = []

        async def scrape_with_semaphore(url: str) -> RevenueApp | None:
            async with semaphore:
                async with self._proxy.get_httpx_client(
                    timeout=self.timeout,
                    headers=self.DEFAULT_HEADERS,
                    follow_redirects=True,
                ) as client:
                    return await self.scrape_app_page(client, url)

        tasks = [scrape_with_semaphore(url) for url in urls_to_process]

        for i, coro in enumerate(asyncio.as_completed(tasks)):
            result = await coro
            if result:
                apps.append(result)
            if (i + 1) % 10 == 0:
                print(f"Progress: {i + 1}/{len(urls_to_process)} pages scraped, {len(apps)} apps found")

        print(f"Completed: {len(apps)} apps extracted from {len(urls_to_process)} pages")
        # whatsthe.app is all mobile apps (RevenueCat), no skipped URLs
        return apps, []

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

        return RevenueApp(
            source="whatstheapp",
            source_id=slug,
            source_url=url,
            app_name=extracted.name,
            app_store_url=extracted.app_store_url,
            play_store_url=extracted.play_store_url,
            apple_id=apple_id,
            bundle_id=bundle_id,
            platform=platform,
            mrr_cents=int(extracted.mrr * 100) if extracted.mrr else None,
            monthly_revenue_cents=int(extracted.monthly_revenue * 100) if extracted.monthly_revenue else None,
            annual_revenue_cents=int(extracted.annual_revenue * 100) if extracted.annual_revenue else None,
            currency="USD",
            revenue_verified=True,  # whatsthe.app is RevenueCat verified
            credential_type=CredentialType.REVENUECAT_VERIFIED,
            monthly_downloads=extracted.monthly_downloads,
            total_downloads=extracted.total_downloads,
            active_subscribers=extracted.active_subscribers,
            active_trials=extracted.active_trials,
            active_users=extracted.active_users,
            new_customers=extracted.new_customers,
            churn_rate=extracted.churn_rate,
            growth_rate_mom=extracted.mrr_growth,
            ltv_cents=int(extracted.ltv * 100) if extracted.ltv else None,
            arpu_cents=int(extracted.arpu * 100) if extracted.arpu else None,
            ios_rating=extracted.ios_rating,
            android_rating=extracted.android_rating,
            description=extracted.description,
            category=extracted.category,
            business_model=BusinessModel.SUBSCRIPTION,
        )


async def scrape_whatstheapp(
    limit: int | None = None,
    skip_urls: set[str] | None = None,
) -> tuple[list[RevenueApp], list[str]]:
    """Convenience function to scrape whatsthe.app.

    Args:
        limit: Optional limit on number of apps to scrape (for testing)
        skip_urls: Set of URLs to skip (already processed)
    """
    scraper = WhatsTheAppScraper()
    return await scraper.scrape_all(limit=limit, skip_urls=skip_urls)
