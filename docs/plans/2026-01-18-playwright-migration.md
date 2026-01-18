# Playwright Migration: All Scrapers

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Migrate all scrapers (4 revenue + Google Play) from httpx to Playwright with stealth, then add Acquire.com scraper requiring login.

**Architecture:** Create `PlaywrightScraper` base class in `core/` with stealth + proxy support. Each scraper inherits from it and overrides discovery/extraction methods. Login-based scrapers (Acquire) store session cookies.

**Tech Stack:** Playwright, playwright-stealth, existing LLMExtractor for HTML→JSON

---

## Task 1: Update Dependencies

**Files:**
- Modify: `scraper-py/pyproject.toml`

**Step 1: Update pyproject.toml**

Replace the dependencies section:

```toml
[project]
name = "keyrank-scraper"
version = "0.1.0"
description = "Unified scraper for Keyrank - Google Play + Revenue Marketplaces"
requires-python = ">=3.11"
dependencies = [
    "fastapi>=0.109.0",
    "uvicorn[standard]>=0.27.0",
    "httpx>=0.26.0",
    "pydantic>=2.5.0",
    "pydantic-settings>=2.1.0",
    "python-dotenv>=1.0.0",
    "litellm>=1.0.0",
    "crawl4ai>=0.3.0",
    "playwright>=1.41.0",
    "playwright-stealth>=1.0.6",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "pytest-asyncio>=0.23.0",
    "ruff>=0.1.0",
]
```

**Step 2: Install dependencies**

```bash
cd scraper-py && uv sync
```

**Step 3: Install Playwright browsers**

```bash
cd scraper-py && uv run playwright install chromium
```

**Step 4: Verify installation**

```bash
cd scraper-py && uv run python -c "from playwright.async_api import async_playwright; from playwright_stealth import stealth_async; print('OK')"
```

Expected: `OK`

**Step 5: Commit**

```bash
git add scraper-py/pyproject.toml scraper-py/uv.lock
git commit -m "feat(scraper): add playwright and playwright-stealth dependencies"
```

---

## Task 2: Create PlaywrightScraper Base Class

**Files:**
- Create: `scraper-py/src/core/playwright_scraper.py`

**Step 1: Create the base class**

```python
"""Base class for Playwright-based scrapers with stealth support."""

import asyncio
from abc import ABC, abstractmethod
from contextlib import asynccontextmanager
from typing import AsyncGenerator

from playwright.async_api import Browser, BrowserContext, Page, async_playwright
from playwright_stealth import stealth_async

from .config import settings
from .llm_extractor import LLMExtractor
from .proxy import ProxyRouter


class PlaywrightScraper(ABC):
    """Base class for all Playwright-based scrapers.

    Provides:
    - Browser management with stealth mode
    - Proxy rotation support
    - LLM-based extraction
    - Cookie/session management for login-based scrapers
    """

    DEFAULT_HEADERS = {
        "Accept-Language": "en-US,en;q=0.9",
    }

    def __init__(
        self,
        timeout: float = 30.0,
        max_concurrent: int = 3,
        headless: bool = True,
    ):
        self.timeout = timeout
        self.max_concurrent = max_concurrent
        self.headless = headless
        self._extractor = LLMExtractor()
        self._proxy = ProxyRouter.from_env(settings.proxy_list)
        self._browser: Browser | None = None
        self._playwright = None

        if self._proxy.has_proxies:
            print(f"{self.__class__.__name__}: Using proxy rotation")

    async def __aenter__(self):
        """Start browser on context enter."""
        await self.start_browser()
        return self

    async def __aexit__(self, exc_type, exc_val, exc_tb):
        """Close browser on context exit."""
        await self.close_browser()

    async def start_browser(self) -> None:
        """Initialize Playwright and launch browser."""
        self._playwright = await async_playwright().start()

        launch_options = {
            "headless": self.headless,
        }

        # Add proxy if configured
        proxy_config = self._proxy.get_playwright_proxy()
        if proxy_config:
            launch_options["proxy"] = proxy_config

        self._browser = await self._playwright.chromium.launch(**launch_options)

    async def close_browser(self) -> None:
        """Close browser and Playwright."""
        if self._browser:
            await self._browser.close()
            self._browser = None
        if self._playwright:
            await self._playwright.stop()
            self._playwright = None

    @asynccontextmanager
    async def new_context(
        self,
        cookies: list[dict] | None = None,
    ) -> AsyncGenerator[BrowserContext, None]:
        """Create a new browser context with stealth.

        Args:
            cookies: Optional cookies to set (for login persistence)
        """
        if not self._browser:
            raise RuntimeError("Browser not started. Use 'async with' or call start_browser()")

        context = await self._browser.new_context(
            viewport={"width": 1920, "height": 1080},
            user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            extra_http_headers=self.DEFAULT_HEADERS,
        )

        if cookies:
            await context.add_cookies(cookies)

        try:
            yield context
        finally:
            await context.close()

    @asynccontextmanager
    async def new_page(
        self,
        context: BrowserContext,
    ) -> AsyncGenerator[Page, None]:
        """Create a new page with stealth applied.

        Args:
            context: Browser context to create page in
        """
        page = await context.new_page()
        await stealth_async(page)
        page.set_default_timeout(self.timeout * 1000)

        try:
            yield page
        finally:
            await page.close()

    async def get_page_html(self, page: Page, url: str) -> str:
        """Navigate to URL and return page HTML.

        Args:
            page: Playwright page
            url: URL to navigate to

        Returns:
            Page HTML content
        """
        await page.goto(url, wait_until="networkidle")
        return await page.content()

    async def scroll_to_bottom(
        self,
        page: Page,
        max_scrolls: int = 50,
        scroll_delay: float = 1.0,
    ) -> None:
        """Scroll page to load infinite scroll content.

        Args:
            page: Playwright page
            max_scrolls: Maximum number of scroll iterations
            scroll_delay: Delay between scrolls in seconds
        """
        last_height = 0

        for _ in range(max_scrolls):
            # Scroll to bottom
            await page.evaluate("window.scrollTo(0, document.body.scrollHeight)")
            await asyncio.sleep(scroll_delay)

            # Check if we've reached the bottom
            new_height = await page.evaluate("document.body.scrollHeight")
            if new_height == last_height:
                break
            last_height = new_height

    @abstractmethod
    async def scrape_all(
        self,
        limit: int | None = None,
        skip_urls: set[str] | None = None,
    ) -> tuple[list, list]:
        """Scrape all items. Must be implemented by subclasses.

        Args:
            limit: Optional limit on items to scrape
            skip_urls: URLs to skip (already processed)

        Returns:
            Tuple of (items, skipped_urls)
        """
        pass
```

**Step 2: Verify file is valid Python**

```bash
cd scraper-py && uv run python -c "from src.core.playwright_scraper import PlaywrightScraper; print('OK')"
```

Expected: `OK`

**Step 3: Commit**

```bash
git add scraper-py/src/core/playwright_scraper.py
git commit -m "feat(scraper): add PlaywrightScraper base class with stealth support"
```

---

## Task 3: Migrate WhatsTheAppScraper

**Files:**
- Modify: `scraper-py/src/revenue/whatstheapp.py`

**Step 1: Rewrite the scraper**

Replace the entire file with Playwright-based implementation:

```python
"""Scraper for whatsthe.app revenue data using Playwright + LLM extraction."""

import asyncio
import re
import xml.etree.ElementTree as ET

import httpx

from ..core.config import settings
from ..core.playwright_scraper import PlaywrightScraper
from ..core.proxy import ProxyRouter
from .models import (
    BusinessModel,
    CredentialType,
    Platform,
    RevenueApp,
)
from .schemas import ExtractedApp


class WhatsTheAppScraper(PlaywrightScraper):
    """Scraper for whatsthe.app marketplace.

    whatsthe.app displays RevenueCat-verified revenue data for mobile apps.
    Uses sitemap to discover apps and Playwright + LLM for extraction.
    """

    BASE_URL = "https://whatsthe.app"
    SITEMAP_URL = "https://whatsthe.app/sitemap.xml"

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

    async def get_app_urls(self) -> list[str]:
        """Fetch sitemap and extract app URLs (uses httpx - no JS needed)."""
        proxy = ProxyRouter.from_env(settings.proxy_list)
        async with proxy.get_httpx_client(timeout=30.0, follow_redirects=True) as client:
            response = await client.get(self.SITEMAP_URL)
            response.raise_for_status()

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

    async def scrape_app_page(self, page, url: str) -> RevenueApp | None:
        """Scrape a single app page using Playwright."""
        try:
            html = await self.get_page_html(page, url)
            slug = url.replace(self.BASE_URL, "").strip("/")

            extracted_list = await self._extractor.extract_from_html(
                html=html,
                schema=ExtractedApp,
                instruction=self.EXTRACTION_INSTRUCTION,
            )

            if not extracted_list:
                return None

            return self._to_revenue_app(extracted_list[0], slug, url)

        except Exception as e:
            print(f"Error scraping {url}: {e}")
            return None

    async def scrape_all(
        self,
        limit: int | None = None,
        skip_urls: set[str] | None = None,
    ) -> tuple[list[RevenueApp], list[str]]:
        """Scrape all apps from whatsthe.app using Playwright."""
        skip_urls = skip_urls or set()

        app_urls = await self.get_app_urls()
        print(f"Found {len(app_urls)} app URLs in sitemap")

        urls_to_process = [url for url in app_urls if url not in skip_urls]
        skipped_count = len(app_urls) - len(urls_to_process)
        if skipped_count > 0:
            print(f"Skipping {skipped_count} already processed URLs")

        if limit:
            urls_to_process = urls_to_process[:limit]
            print(f"Limiting to {limit} apps for this run")

        apps: list[RevenueApp] = []

        async with self.new_context() as context:
            async with self.new_page(context) as page:
                for i, url in enumerate(urls_to_process):
                    app = await self.scrape_app_page(page, url)
                    if app:
                        apps.append(app)

                    if (i + 1) % 10 == 0:
                        print(f"Progress: {i + 1}/{len(urls_to_process)} pages, {len(apps)} apps")

                    await asyncio.sleep(0.3)

        print(f"Completed: {len(apps)} apps from {len(urls_to_process)} pages")
        return apps, []

    def _to_revenue_app(self, extracted: ExtractedApp, slug: str, url: str) -> RevenueApp:
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
            revenue_verified=True,
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
    """Convenience function to scrape whatsthe.app."""
    async with WhatsTheAppScraper() as scraper:
        return await scraper.scrape_all(limit=limit, skip_urls=skip_urls)
```

**Step 2: Test the scraper**

```bash
cd scraper-py && uv run python -c "
import asyncio
from src.revenue.whatstheapp import scrape_whatstheapp

async def test():
    apps, _ = await scrape_whatstheapp(limit=1)
    print(f'Got {len(apps)} apps')
    if apps:
        print(f'First app: {apps[0].app_name}')

asyncio.run(test())
"
```

Expected: `Got 1 apps` + app name

**Step 3: Commit**

```bash
git add scraper-py/src/revenue/whatstheapp.py
git commit -m "refactor(scraper): migrate WhatsTheAppScraper to Playwright"
```

---

## Task 4: Migrate FlippaScraper

**Files:**
- Modify: `scraper-py/src/revenue/flippa.py`

**Step 1: Rewrite the scraper**

Replace the entire file:

```python
"""Scraper for Flippa mobile app listings using Playwright + LLM extraction."""

import asyncio
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
        await asyncio.sleep(1)

        page_num = 1
        consecutive_empty = 0

        while page_num <= 500 and consecutive_empty < 3:
            # Wait for listings to load
            await page.wait_for_selector('[data-controller="listing-card"]', timeout=5000)

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
                await asyncio.sleep(1)
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
```

**Step 2: Test the scraper**

```bash
cd scraper-py && uv run python -c "
import asyncio
from src.revenue.flippa import FlippaScraper

async def test():
    async with FlippaScraper() as scraper:
        apps, _ = await scraper.scrape_all(limit=1)
        print(f'Got {len(apps)} apps')

asyncio.run(test())
"
```

Expected: Output showing apps found

**Step 3: Commit**

```bash
git add scraper-py/src/revenue/flippa.py
git commit -m "refactor(scraper): migrate FlippaScraper to Playwright"
```

---

## Task 5: Migrate AppBusinessBrokersScraper

**Files:**
- Modify: `scraper-py/src/revenue/appbusinessbrokers.py`

**Step 1: Read current implementation**

Read the file to understand the current structure before migrating.

**Step 2: Rewrite with Playwright**

Follow the same pattern as WhatsTheAppScraper - sitemap discovery with httpx, page scraping with Playwright.

**Step 3: Test**

```bash
cd scraper-py && uv run python -c "
import asyncio
from src.revenue.appbusinessbrokers import scrape_appbusinessbrokers

async def test():
    apps, _ = await scrape_appbusinessbrokers(limit=1)
    print(f'Got {len(apps)} apps')

asyncio.run(test())
"
```

**Step 4: Commit**

```bash
git add scraper-py/src/revenue/appbusinessbrokers.py
git commit -m "refactor(scraper): migrate AppBusinessBrokersScraper to Playwright"
```

---

## Task 6: Migrate MicronsScraper

**Files:**
- Modify: `scraper-py/src/revenue/microns.py`

**Step 1: Read current implementation**

Read the file to understand the structure.

**Step 2: Rewrite with Playwright**

Follow the same pattern - sitemap discovery, Playwright page scraping.

**Step 3: Test**

```bash
cd scraper-py && uv run python -c "
import asyncio
from src.revenue.microns import scrape_microns

async def test():
    apps, _ = await scrape_microns(limit=1)
    print(f'Got {len(apps)} apps')

asyncio.run(test())
"
```

**Step 4: Commit**

```bash
git add scraper-py/src/revenue/microns.py
git commit -m "refactor(scraper): migrate MicronsScraper to Playwright"
```

---

## Task 7: Create AcquireScraper (Login-Based)

**Files:**
- Create: `scraper-py/src/revenue/acquire.py`
- Modify: `scraper-py/src/revenue/router.py`
- Modify: `scraper-py/src/core/config.py`

**Step 1: Add Acquire credentials to config**

In `scraper-py/src/core/config.py`, add:

```python
# Add to Settings class
acquire_email: str = ""
acquire_password: str = ""
```

**Step 2: Create AcquireScraper**

```python
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
```

**Step 3: Add router endpoints**

In `scraper-py/src/revenue/router.py`, add:

```python
from .acquire import scrape_acquire

@router.post("/acquire")
async def scrape_acquire_endpoint(request: ScrapeRequest):
    """Scrape mobile apps from Acquire.com."""
    apps, skipped = await scrape_acquire(
        limit=request.limit,
        skip_urls=set(request.skip_urls) if request.skip_urls else None,
    )
    return {
        "success": True,
        "count": len(apps),
        "apps": [app.model_dump() for app in apps],
        "skipped_urls": skipped,
    }

@router.get("/acquire/raw")
async def scrape_acquire_raw(limit: int | None = None):
    """Scrape Acquire.com and return raw Pydantic models."""
    apps, skipped = await scrape_acquire(limit=limit)
    return {"apps": apps, "skipped_urls": skipped}
```

**Step 4: Test login flow**

```bash
cd scraper-py && uv run python -c "
import asyncio
from src.revenue.acquire import AcquireScraper

async def test():
    async with AcquireScraper(headless=False) as scraper:
        # Use headless=False to debug login
        apps, _ = await scraper.scrape_all(limit=1)
        print(f'Got {len(apps)} apps')

asyncio.run(test())
"
```

**Step 5: Commit**

```bash
git add scraper-py/src/revenue/acquire.py scraper-py/src/revenue/router.py scraper-py/src/core/config.py
git commit -m "feat(scraper): add AcquireScraper with login support"
```

---

## Task 8: Update Laravel Integration

**Files:**
- Modify: `api/app/Services/RevenueScraperService.php`
- Modify: `api/app/Console/Commands/SyncRevenue.php`
- Modify: `api/routes/console.php`

**Step 1: Add Acquire sync method to service**

In `RevenueScraperService.php`:

```php
/**
 * Sync revenue data from Acquire.com
 */
public function syncAcquire(?int $limit = null): array
{
    return $this->syncFromEndpoint('acquire', '/revenue/acquire', $limit);
}
```

**Step 2: Add Acquire to command**

In `SyncRevenue.php`, update signature:

```php
protected $signature = 'revenue:sync
    {--source=all : Source to sync (whatstheapp, appbusinessbrokers, flippa, microns, acquire, all)}
    {--limit= : Limit number of apps to scrape per source (for testing)}
    {--dry-run : Show what would be synced without saving}';
```

Add sync call in handle():

```php
// Sync acquire.com
if ($source === 'all' || $source === 'acquire') {
    $this->syncSource($service, 'acquire', 'syncAcquire', $dryRun, $limit, $totalSynced, $totalCreated, $totalUpdated, $allErrors);
}
```

**Step 3: Test**

```bash
cd api && php artisan revenue:sync --source=acquire --limit=2
```

**Step 4: Commit**

```bash
git add api/app/Services/RevenueScraperService.php api/app/Console/Commands/SyncRevenue.php
git commit -m "feat(api): add Acquire.com revenue sync integration"
```

---

## Task 9: Integration Testing

**Step 1: Start scraper service**

```bash
cd scraper-py && uv run python -m src.main
```

**Step 2: Test all scrapers via API**

```bash
# WhatsTheApp
curl -X POST http://localhost:8001/revenue/whatstheapp -H "Content-Type: application/json" -d '{"limit": 1}'

# Flippa
curl -X POST http://localhost:8001/revenue/flippa -H "Content-Type: application/json" -d '{"limit": 1}'

# AppBusinessBrokers
curl -X POST http://localhost:8001/revenue/appbusinessbrokers -H "Content-Type: application/json" -d '{"limit": 1}'

# Microns
curl -X POST http://localhost:8001/revenue/microns -H "Content-Type: application/json" -d '{"limit": 1}'

# Acquire
curl -X POST http://localhost:8001/revenue/acquire -H "Content-Type: application/json" -d '{"limit": 1}'
```

**Step 3: Test via Laravel**

```bash
cd api && php artisan revenue:sync --limit=1
```

**Step 4: Final commit**

```bash
git add -A
git commit -m "test: verify all Playwright scrapers working"
```

---

## Task 10: Migrate GooglePlayScraper

**Files:**
- Modify: `scraper-py/src/gplay/scraper.py`
- Modify: `scraper-py/src/gplay/router.py`

The Google Play scraper is different from revenue scrapers - it scrapes app data directly from Google Play Store (rankings, reviews, search, suggestions, top charts). Google is known for aggressive bot detection, so Playwright+stealth is essential.

**Step 1: Create PlaywrightGooglePlayScraper**

The Google Play scraper needs special handling because:
- Uses batchexecute API for some endpoints (reviews, suggestions, top charts)
- Direct HTML scraping for app details and search
- Must maintain session cookies across requests

Rewrite `scraper-py/src/gplay/scraper.py` to use Playwright:

```python
"""Google Play Store scraper with Playwright + stealth support."""

import asyncio
import json
from typing import Any
from urllib.parse import quote

from playwright.async_api import Page, BrowserContext
from playwright_stealth import stealth_async

from ..core.config import settings
from ..core.playwright_scraper import PlaywrightScraper
from ..core.proxy import ProxyRouter
from .constants import URLs, COLLECTIONS, REVIEW_SORT, CATEGORIES, PLAY_STORE_BASE
from .parser import (
    parse_app_details,
    parse_search_results,
    parse_suggestions,
    parse_reviews,
    parse_top_charts_batch,
)


class GooglePlayScraper(PlaywrightScraper):
    """Async Google Play Store scraper with Playwright + stealth."""

    def __init__(
        self,
        proxy_router: ProxyRouter | None = None,
        timeout: float = 30.0,
        rate_limit_delay: float = 0.2,
        headless: bool = True,
    ):
        super().__init__(timeout=timeout, headless=headless)
        if proxy_router:
            self._proxy = proxy_router
        self.rate_limit_delay = rate_limit_delay
        self._context: BrowserContext | None = None
        self._page: Page | None = None

    async def _ensure_page(self) -> Page:
        """Get or create a page for requests."""
        if self._page is None or self._page.is_closed():
            if self._context is None:
                self._context = await self._browser.new_context(
                    viewport={"width": 1920, "height": 1080},
                    user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
                )
            self._page = await self._context.new_page()
            await stealth_async(self._page)
            self._page.set_default_timeout(self.timeout * 1000)
        return self._page

    async def _rate_limit(self):
        """Apply rate limiting between requests."""
        if self.rate_limit_delay > 0:
            await asyncio.sleep(self.rate_limit_delay)

    async def _get(self, url: str) -> str:
        """Make GET request via Playwright."""
        await self._rate_limit()
        page = await self._ensure_page()
        await page.goto(url, wait_until="networkidle")
        return await page.content()

    async def _post_batchexecute(self, url: str, payload: str) -> str:
        """Make POST request to batchexecute API via Playwright."""
        await self._rate_limit()
        page = await self._ensure_page()

        # Use page.evaluate to make fetch request
        response = await page.evaluate("""
            async ([url, payload]) => {
                const resp = await fetch(url, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: payload,
                });
                return await resp.text();
            }
        """, [url, payload])

        return response

    async def app(
        self, app_id: str, lang: str = "en", country: str = "us"
    ) -> dict[str, Any] | None:
        """Get app details."""
        url = URLs.app_details(app_id, lang, country)

        try:
            html = await self._get(url)
        except Exception as e:
            if "404" in str(e):
                return None
            raise

        return parse_app_details(html, app_id, url)

    async def search(
        self,
        query: str,
        lang: str = "en",
        country: str = "us",
        limit: int = 50,
    ) -> list[dict[str, Any]]:
        """Search for apps."""
        url = URLs.search(query, lang, country)

        try:
            html = await self._get(url)
        except Exception:
            return []

        return parse_search_results(html, limit)

    async def suggest(
        self, query: str, lang: str = "en", country: str = "us"
    ) -> list[str]:
        """Get autocomplete suggestions using batchexecute API."""
        base = f"{PLAY_STORE_BASE}/_/PlayStoreUi/data/batchexecute"
        url = f"{base}?rpcids=IJ4APc&hl={lang}&gl={country}"

        inner = json.dumps([[None, [query], [10], [2], 4]])
        outer = json.dumps([[["IJ4APc", inner]]])
        payload = f"f.req={quote(outer)}"

        try:
            response = await self._post_batchexecute(url, payload)
        except Exception:
            return []

        return parse_suggestions(response)

    async def reviews(
        self,
        app_id: str,
        lang: str = "en",
        country: str = "us",
        sort: str = "newest",
        count: int = 100,
        filter_score: int | None = None,
    ) -> list[dict[str, Any]]:
        """Get app reviews."""
        url = URLs.reviews_api(lang, country)
        sort_value = REVIEW_SORT.get(sort, 2)
        score_filter = filter_score if filter_score in range(1, 6) else 0

        payload = self._build_reviews_payload(app_id, sort_value, count, score_filter, None)
        all_reviews = []
        pagination_token = None

        while len(all_reviews) < count:
            try:
                response = await self._post_batchexecute(url, payload)
            except Exception:
                break

            reviews, pagination_token = parse_reviews(response)

            if not reviews:
                break

            all_reviews.extend(reviews)

            if not pagination_token or len(all_reviews) >= count:
                break

            remaining = count - len(all_reviews)
            payload = self._build_reviews_payload(
                app_id, sort_value, min(remaining, 100), score_filter, pagination_token
            )

        return all_reviews[:count]

    def _build_reviews_payload(
        self,
        app_id: str,
        sort: int,
        count: int,
        score: int,
        pagination_token: str | None,
    ) -> str:
        """Build reviews API payload."""
        if pagination_token:
            return f'f.req=%5B%5B%5B%22oCPfdb%22%2C%22%5Bnull%2C%5B2%2C{sort}%2C%5B{count}%2Cnull%2C%5C%22{pagination_token}%5C%22%5D%2Cnull%2C%5Bnull%2C{score}%5D%5D%2C%5B%5C%22{app_id}%5C%22%2C7%5D%5D%22%2Cnull%2C%22generic%22%5D%5D%5D'
        return f'f.req=%5B%5B%5B%22oCPfdb%22%2C%22%5Bnull%2C%5B2%2C{sort}%2C%5B{count}%5D%2Cnull%2C%5Bnull%2C{score}%5D%5D%2C%5B%5C%22{app_id}%5C%22%2C7%5D%5D%22%2Cnull%2C%22generic%22%5D%5D%5D'

    def _build_top_charts_payload(self, num: int, collection: str, category: str) -> str:
        """Build top charts batchexecute payload."""
        return f'f.req=%5B%5B%5B%22vyAe2%22%2C%22%5B%5Bnull%2C%5B%5B8%2C%5B20%2C{num}%5D%5D%2Ctrue%2Cnull%2C%5B64%2C1%2C195%2C71%2C8%2C72%2C9%2C10%2C11%2C139%2C12%2C16%2C145%2C148%2C150%2C151%2C152%2C27%2C30%2C31%2C96%2C32%2C34%2C163%2C100%2C165%2C104%2C169%2C108%2C110%2C113%2C55%2C56%2C57%2C122%5D%2C%5Bnull%2Cnull%2C%5B%5B%5Btrue%5D%2Cnull%2C%5B%5Bnull%2C%5B%5D%5D%5D%2Cnull%2Cnull%2Cnull%2Cnull%2C%5Bnull%2C2%5D%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2C%5B1%5D%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2C%5B1%5D%5D%2C%5Bnull%2C%5B%5Bnull%2C%5B%5D%5D%5D%5D%2C%5Bnull%2C%5B%5Bnull%2C%5B%5D%5D%5D%2Cnull%2C%5Btrue%5D%5D%2C%5Bnull%2C%5B%5Bnull%2C%5B%5D%5D%5D%5D%2Cnull%2Cnull%2Cnull%2Cnull%2C%5B%5B%5Bnull%2C%5B%5D%5D%5D%5D%2C%5B%5B%5Bnull%2C%5B%5D%5D%5D%5D%5D%2C%5B%5B%5B%5B7%2C1%5D%2C%5B%5B1%2C73%2C96%2C103%2C97%2C58%2C50%2C92%2C52%2C112%2C69%2C19%2C31%2C101%2C123%2C74%2C49%2C80%2C38%2C20%2C10%2C14%2C79%2C43%2C42%2C139%5D%5D%5D%5D%5D%5D%2Cnull%2Cnull%2C%5B%5B%5B1%2C2%5D%2C%5B10%2C8%2C9%5D%2C%5B%5D%2C%5B%5D%5D%5D%5D%2C%5B2%2C%5C%22{collection}%5C%22%2C%5C%22{category}%5C%22%5D%5D%5D%22%2Cnull%2C%22generic%22%5D%5D%5D'

    async def top_charts(
        self,
        category: str = "APPLICATION",
        collection: str = "top_free",
        lang: str = "en",
        country: str = "us",
        limit: int = 100,
    ) -> list[dict[str, Any]]:
        """Get top charts using batchexecute API."""
        collection_map = {
            "top_free": "topselling_free",
            "top_paid": "topselling_paid",
            "top_grossing": "topgrossing",
            "grossing": "topgrossing",
        }
        collection_id = collection_map.get(collection, "topselling_free")

        url = (
            f"{PLAY_STORE_BASE}/_/PlayStoreUi/data/batchexecute"
            f"?rpcids=vyAe2&source-path=%2Fstore%2Fapps&hl={lang}&gl={country}"
        )

        payload = self._build_top_charts_payload(limit, collection_id, category)

        try:
            response = await self._post_batchexecute(url, payload)
        except Exception:
            return []

        return parse_top_charts_batch(response, limit)

    async def categories(self) -> list[dict[str, str]]:
        """Get list of categories."""
        return [{"id": k, "name": v} for k, v in CATEGORIES.items()]

    async def get_app_rank(
        self,
        app_id: str,
        keyword: str,
        lang: str = "en",
        country: str = "us",
        limit: int = 250,
    ) -> int | None:
        """Get app rank for a specific keyword."""
        results = await self.search(keyword, lang, country, limit)

        for idx, app in enumerate(results):
            if app.get("appId") == app_id:
                return idx + 1

        return None

    async def get_rankings_batch(
        self,
        app_id: str,
        keywords: list[str],
        lang: str = "en",
        country: str = "us",
    ) -> dict[str, int | None]:
        """Get rankings for multiple keywords."""
        rankings = {}

        for keyword in keywords:
            rank = await self.get_app_rank(app_id, keyword, lang, country)
            rankings[keyword] = rank

        return rankings

    async def close_browser(self) -> None:
        """Close browser and clean up."""
        if self._page and not self._page.is_closed():
            await self._page.close()
        if self._context:
            await self._context.close()
        await super().close_browser()

    # Required abstract method - not used for gplay
    async def scrape_all(self, limit=None, skip_urls=None):
        """Not applicable for Google Play scraper."""
        raise NotImplementedError("Use specific methods like search(), app(), reviews()")


# Singleton for simple usage
_default_scraper: GooglePlayScraper | None = None


def get_scraper(proxy_router: ProxyRouter | None = None) -> GooglePlayScraper:
    """Get or create default scraper instance."""
    global _default_scraper
    if _default_scraper is None:
        _default_scraper = GooglePlayScraper(proxy_router=proxy_router)
    return _default_scraper
```

**Step 2: Update router to use async context manager**

In `scraper-py/src/gplay/router.py`, update the `get_scraper` dependency to properly manage browser lifecycle:

```python
# At the top of the file, add startup/shutdown events
from contextlib import asynccontextmanager

_scraper_instance: GooglePlayScraper | None = None

async def get_scraper_instance() -> GooglePlayScraper:
    """Get the shared scraper instance."""
    global _scraper_instance
    if _scraper_instance is None:
        proxy_router = get_proxy_router()
        _scraper_instance = GooglePlayScraper(
            proxy_router=proxy_router,
            rate_limit_delay=settings.rate_limit_delay_ms / 1000,
        )
        await _scraper_instance.start_browser()
    return _scraper_instance

async def shutdown_scraper():
    """Shutdown the scraper on app exit."""
    global _scraper_instance
    if _scraper_instance:
        await _scraper_instance.close_browser()
        _scraper_instance = None
```

Then register shutdown in main.py:

```python
@app.on_event("shutdown")
async def shutdown():
    from .gplay.router import shutdown_scraper
    await shutdown_scraper()
```

**Step 3: Test Google Play scraper**

```bash
cd scraper-py && uv run python -c "
import asyncio
from src.gplay.scraper import GooglePlayScraper

async def test():
    async with GooglePlayScraper() as scraper:
        # Test app details
        app = await scraper.app('com.spotify.music')
        print(f'App: {app[\"title\"] if app else \"Not found\"}')

        # Test search
        results = await scraper.search('music player', limit=5)
        print(f'Search: {len(results)} results')

        # Test suggestions
        suggestions = await scraper.suggest('mus')
        print(f'Suggestions: {suggestions[:3]}')

asyncio.run(test())
"
```

**Step 4: Commit**

```bash
git add scraper-py/src/gplay/scraper.py scraper-py/src/gplay/router.py scraper-py/src/main.py
git commit -m "refactor(scraper): migrate GooglePlayScraper to Playwright with stealth"
```

---

## Summary

| Task | Description | Est. Size |
|------|-------------|-----------|
| 1 | Update dependencies | Small |
| 2 | Create PlaywrightScraper base | Medium |
| 3 | Migrate WhatsTheAppScraper | Medium |
| 4 | Migrate FlippaScraper | Medium |
| 5 | Migrate AppBusinessBrokersScraper | Medium |
| 6 | Migrate MicronsScraper | Medium |
| 7 | Create AcquireScraper (new) | Large |
| 8 | Update Laravel integration | Small |
| 9 | Integration testing (revenue) | Small |
| 10 | Migrate GooglePlayScraper | Large |

**Total: 10 tasks**

Key benefits after migration:
- Stealth mode avoids bot detection (essential for Google Play)
- Consistent browser-based scraping
- Login support for protected sites (Acquire.com)
- Proxy rotation via Playwright
- Infinite scroll support
- Better session/cookie handling
