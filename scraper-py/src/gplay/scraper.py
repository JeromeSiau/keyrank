"""Google Play Store scraper with proxy support."""

import asyncio
from typing import Any
from urllib.parse import quote

import httpx

from ..core.proxy import ProxyRouter
from .constants import URLs, COLLECTIONS, REVIEW_SORT, CATEGORIES, PLAY_STORE_BASE
from .parser import (
    parse_app_details,
    parse_search_results,
    parse_suggestions,
    parse_reviews,
    parse_top_charts_batch,
)


class GooglePlayScraper:
    """Async Google Play Store scraper with proxy support."""

    DEFAULT_HEADERS = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.5",
        "Accept-Encoding": "gzip, deflate, br",
        "Connection": "keep-alive",
    }

    def __init__(
        self,
        proxy_router: ProxyRouter | None = None,
        timeout: float = 30.0,
        rate_limit_delay: float = 0.2,
    ):
        self.proxy_router = proxy_router
        self.timeout = timeout
        self.rate_limit_delay = rate_limit_delay
        self._last_request_time = 0

    async def _get_client(self, country: str | None = None) -> httpx.AsyncClient:
        """Get HTTP client with optional proxy for specific country."""
        proxy = None
        if self.proxy_router:
            proxy = self.proxy_router.get_next(country)

        return httpx.AsyncClient(
            proxy=proxy,
            timeout=self.timeout,
            headers=self.DEFAULT_HEADERS,
            follow_redirects=True,
        )

    async def _rate_limit(self):
        """Apply rate limiting between requests."""
        if self.rate_limit_delay > 0:
            await asyncio.sleep(self.rate_limit_delay)

    async def _get(self, url: str, country: str | None = None) -> str:
        """Make GET request with rate limiting."""
        await self._rate_limit()

        async with await self._get_client(country) as client:
            response = await client.get(url)
            response.raise_for_status()
            return response.text

    async def _post(
        self, url: str, data: bytes, headers: dict | None = None, country: str | None = None
    ) -> str:
        """Make POST request with rate limiting."""
        await self._rate_limit()

        post_headers = {
            **self.DEFAULT_HEADERS,
            "Content-Type": "application/x-www-form-urlencoded",
        }
        if headers:
            post_headers.update(headers)

        async with await self._get_client(country) as client:
            response = await client.post(url, content=data, headers=post_headers)
            response.raise_for_status()
            return response.text

    async def app(
        self, app_id: str, lang: str = "en", country: str = "us"
    ) -> dict[str, Any] | None:
        """Get app details."""
        url = URLs.app_details(app_id, lang, country)

        try:
            html = await self._get(url, country)
        except httpx.HTTPStatusError as e:
            if e.response.status_code == 404:
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
            html = await self._get(url, country)
        except httpx.HTTPStatusError:
            return []

        return parse_search_results(html, limit)

    async def suggest(
        self, query: str, lang: str = "en", country: str = "us"
    ) -> list[str]:
        """Get autocomplete suggestions using batchexecute API."""
        import json

        # Build URL with rpcids parameter
        base = f"{PLAY_STORE_BASE}/_/PlayStoreUi/data/batchexecute"
        url = f"{base}?rpcids=IJ4APc&hl={lang}&gl={country}"

        # Build payload: [[["IJ4APc","[[null,[\"term\"],[10],[2],4]]"]]]
        inner = json.dumps([[None, [query], [10], [2], 4]])
        outer = json.dumps([[["IJ4APc", inner]]])
        payload = f"f.req={quote(outer)}"

        try:
            response = await self._post(url, payload.encode(), country=country)
        except httpx.HTTPStatusError:
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

        # Build request payload
        payload = self._build_reviews_payload(app_id, sort_value, count, score_filter, None)

        all_reviews = []
        pagination_token = None

        while len(all_reviews) < count:
            try:
                response = await self._post(url, payload, country=country)
            except httpx.HTTPStatusError:
                break

            reviews, pagination_token = parse_reviews(response)

            if not reviews:
                break

            all_reviews.extend(reviews)

            if not pagination_token or len(all_reviews) >= count:
                break

            # Build next page payload
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
    ) -> bytes:
        """Build reviews API payload."""
        if pagination_token:
            payload = f'f.req=%5B%5B%5B%22oCPfdb%22%2C%22%5Bnull%2C%5B2%2C{sort}%2C%5B{count}%2Cnull%2C%5C%22{pagination_token}%5C%22%5D%2Cnull%2C%5Bnull%2C{score}%5D%5D%2C%5B%5C%22{app_id}%5C%22%2C7%5D%5D%22%2Cnull%2C%22generic%22%5D%5D%5D'
        else:
            payload = f'f.req=%5B%5B%5B%22oCPfdb%22%2C%22%5Bnull%2C%5B2%2C{sort}%2C%5B{count}%5D%2Cnull%2C%5Bnull%2C{score}%5D%5D%2C%5B%5C%22{app_id}%5C%22%2C7%5D%5D%22%2Cnull%2C%22generic%22%5D%5D%5D'

        return payload.encode()

    def _build_top_charts_payload(self, num: int, collection: str, category: str) -> bytes:
        """Build top charts batchexecute payload.

        Uses the exact format from Node.js google-play-scraper library.
        """
        # This is the URL-encoded payload from the Node.js library
        # with collection and category substituted
        payload = f'f.req=%5B%5B%5B%22vyAe2%22%2C%22%5B%5Bnull%2C%5B%5B8%2C%5B20%2C{num}%5D%5D%2Ctrue%2Cnull%2C%5B64%2C1%2C195%2C71%2C8%2C72%2C9%2C10%2C11%2C139%2C12%2C16%2C145%2C148%2C150%2C151%2C152%2C27%2C30%2C31%2C96%2C32%2C34%2C163%2C100%2C165%2C104%2C169%2C108%2C110%2C113%2C55%2C56%2C57%2C122%5D%2C%5Bnull%2Cnull%2C%5B%5B%5Btrue%5D%2Cnull%2C%5B%5Bnull%2C%5B%5D%5D%5D%2Cnull%2Cnull%2Cnull%2Cnull%2C%5Bnull%2C2%5D%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2C%5B1%5D%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2C%5B1%5D%5D%2C%5Bnull%2C%5B%5Bnull%2C%5B%5D%5D%5D%5D%2C%5Bnull%2C%5B%5Bnull%2C%5B%5D%5D%5D%2Cnull%2C%5Btrue%5D%5D%2C%5Bnull%2C%5B%5Bnull%2C%5B%5D%5D%5D%5D%2Cnull%2Cnull%2Cnull%2Cnull%2C%5B%5B%5Bnull%2C%5B%5D%5D%5D%5D%2C%5B%5B%5Bnull%2C%5B%5D%5D%5D%5D%5D%2C%5B%5B%5B%5B7%2C1%5D%2C%5B%5B1%2C73%2C96%2C103%2C97%2C58%2C50%2C92%2C52%2C112%2C69%2C19%2C31%2C101%2C123%2C74%2C49%2C80%2C38%2C20%2C10%2C14%2C79%2C43%2C42%2C139%5D%5D%5D%5D%5D%5D%2Cnull%2Cnull%2C%5B%5B%5B1%2C2%5D%2C%5B10%2C8%2C9%5D%2C%5B%5D%2C%5B%5D%5D%5D%5D%2C%5B2%2C%5C%22{collection}%5C%22%2C%5C%22{category}%5C%22%5D%5D%5D%22%2Cnull%2C%22generic%22%5D%5D%5D'
        return payload.encode()

    async def top_charts(
        self,
        category: str = "APPLICATION",
        collection: str = "top_free",
        lang: str = "en",
        country: str = "us",
        limit: int = 100,
    ) -> list[dict[str, Any]]:
        """Get top charts using batchexecute API."""
        # Map collection names to internal IDs
        collection_map = {
            "top_free": "topselling_free",
            "top_paid": "topselling_paid",
            "top_grossing": "topgrossing",
            "grossing": "topgrossing",
        }
        collection_id = collection_map.get(collection, "topselling_free")

        # Full URL with all parameters like Node.js library
        url = (
            f"{PLAY_STORE_BASE}/_/PlayStoreUi/data/batchexecute"
            f"?rpcids=vyAe2"
            f"&source-path=%2Fstore%2Fapps"
            f"&hl={lang}&gl={country}"
        )

        # Build batchexecute payload
        payload = self._build_top_charts_payload(limit, collection_id, category)

        try:
            response = await self._post(url, payload, country=country)
        except httpx.HTTPStatusError:
            return []

        return parse_top_charts_batch(response, limit)

    async def categories(self) -> list[dict[str, str]]:
        """Get list of categories."""
        # Return static list - Google Play categories don't change often
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


# Singleton instance for simple usage
_default_scraper: GooglePlayScraper | None = None


def get_scraper(proxy_router: ProxyRouter | None = None) -> GooglePlayScraper:
    """Get or create default scraper instance."""
    global _default_scraper
    if _default_scraper is None:
        _default_scraper = GooglePlayScraper(proxy_router=proxy_router)
    return _default_scraper
