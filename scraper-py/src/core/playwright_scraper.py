"""Base class for Playwright-based scrapers with stealth support."""

import asyncio
from abc import ABC, abstractmethod
from contextlib import asynccontextmanager
from typing import AsyncGenerator

from playwright.async_api import Browser, BrowserContext, Page, async_playwright
from playwright_stealth import Stealth

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
        timeout: float = 60.0,
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
        self._stealth = Stealth()

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
        await self._stealth.apply_stealth_async(page)
        page.set_default_timeout(self.timeout * 1000)

        try:
            yield page
        finally:
            await page.close()

    async def get_page_html(self, page: Page, url: str, wait_until: str = "domcontentloaded") -> str:
        """Navigate to URL and return page HTML.

        Args:
            page: Playwright page
            url: URL to navigate to
            wait_until: Wait strategy - "domcontentloaded", "load", or "networkidle"

        Returns:
            Page HTML content
        """
        await page.goto(url, wait_until=wait_until)
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
