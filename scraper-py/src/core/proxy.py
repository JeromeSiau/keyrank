from dataclasses import dataclass
from itertools import cycle
from typing import Iterator

import httpx


@dataclass
class ProxyConfig:
    """Configuration for a single proxy."""

    url: str
    country: str | None = None
    weight: int = 1


class ProxyRouter:
    """Manages proxy rotation with optional geo-targeting."""

    def __init__(self, proxies: list[ProxyConfig] | None = None):
        self.proxies = proxies or []
        self._cycle: Iterator[ProxyConfig] | None = None
        if self.proxies:
            self._cycle = cycle(self.proxies)

    @classmethod
    def from_env(cls, proxy_list: str) -> "ProxyRouter":
        """
        Create ProxyRouter from environment variable string.

        Format: url|country,url|country (country optional)
        Example: http://user:pass@proxy1.com:8080|us,http://proxy2.com:8080
        """
        if not proxy_list.strip():
            return cls([])

        proxies = []
        for entry in proxy_list.split(","):
            entry = entry.strip()
            if not entry:
                continue

            if "|" in entry:
                url, country = entry.rsplit("|", 1)
                proxies.append(ProxyConfig(url=url.strip(), country=country.strip().lower()))
            else:
                proxies.append(ProxyConfig(url=entry))

        return cls(proxies)

    def get_next(self, country: str | None = None) -> str | None:
        """
        Get the next proxy URL, optionally filtered by country.

        Args:
            country: Optional country code to filter proxies

        Returns:
            Proxy URL or None if no proxies configured
        """
        if not self.proxies:
            return None

        if country:
            matching = [p for p in self.proxies if p.country == country.lower()]
            if matching:
                return next(cycle(matching)).url

        if self._cycle:
            return next(self._cycle).url

        return None

    def get_httpx_client(self, country: str | None = None, **kwargs) -> httpx.AsyncClient:
        """
        Create an HTTPX async client with proxy configured.

        Args:
            country: Optional country code for geo-targeting
            **kwargs: Additional arguments passed to AsyncClient

        Returns:
            Configured AsyncClient instance
        """
        proxy = self.get_next(country)
        defaults = {"timeout": 30.0}
        defaults.update(kwargs)
        if proxy:
            defaults["proxy"] = proxy
        return httpx.AsyncClient(**defaults)

    def get_playwright_proxy(self, country: str | None = None) -> dict | None:
        """
        Get proxy configuration dict for Playwright.

        Args:
            country: Optional country code for geo-targeting

        Returns:
            Proxy config dict or None if no proxies configured
        """
        proxy = self.get_next(country)
        if not proxy:
            return None
        return {"server": proxy}

    @property
    def has_proxies(self) -> bool:
        """Check if any proxies are configured."""
        return len(self.proxies) > 0
