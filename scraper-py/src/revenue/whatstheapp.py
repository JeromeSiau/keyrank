"""Scraper for whatsthe.app revenue data."""

import re
from typing import Any

import httpx

from .models import RevenueApp


class WhatsTheAppScraper:
    """Scraper for whatsthe.app marketplace.

    whatsthe.app displays RevenueCat-verified revenue data for mobile apps.
    Data is rendered in HTML tables, parsed from the DOM structure.
    """

    BASE_URL = "https://whatsthe.app"
    DEFAULT_HEADERS = {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.5",
    }

    def __init__(self, timeout: float = 30.0):
        self.timeout = timeout

    async def scrape_all(self) -> list[RevenueApp]:
        """Scrape all apps from whatsthe.app homepage."""
        async with httpx.AsyncClient(
            timeout=self.timeout,
            headers=self.DEFAULT_HEADERS,
            follow_redirects=True,
        ) as client:
            response = await client.get(self.BASE_URL)
            response.raise_for_status()

            apps_data = self._extract_apps_from_html(response.text)
            return [RevenueApp.from_whatstheapp(app) for app in apps_data]

    def _extract_apps_from_html(self, html: str) -> list[dict[str, Any]]:
        """Extract app data from HTML table rows.

        The page structure has table rows with:
        - icon + name + store links + description
        - revenue, mrr, subscriptions, downloads in cells
        """
        apps = []

        # Find all table rows with app data
        # Rows with cursor-pointer class contain app data
        row_pattern = re.compile(
            r'<tr[^>]*class="[^"]*cursor-pointer[^"]*"[^>]*>(.*?)</tr>',
            re.DOTALL
        )

        for row_match in row_pattern.finditer(html):
            row_html = row_match.group(1)
            app_data = self._parse_table_row(row_html)
            if app_data and app_data.get("name"):
                apps.append(app_data)

        return apps

    def _parse_table_row(self, row_html: str) -> dict[str, Any] | None:
        """Parse a single table row to extract app data."""
        app = {}

        # Extract app name - in a div with font-medium class followed by text
        name_match = re.search(
            r'<div[^>]*class="[^"]*font-medium[^"]*"[^>]*>([^<]+)',
            row_html
        )
        if name_match:
            app["name"] = name_match.group(1).strip()

        # Extract App Store URL and Apple ID
        appstore_match = re.search(
            r'href="(https://apps\.apple\.com/[^"]+)"',
            row_html
        )
        if appstore_match:
            app["appStoreUrl"] = appstore_match.group(1)
            # Extract Apple ID
            id_match = re.search(r'/id(\d+)', app["appStoreUrl"])
            if id_match:
                app["apple_id"] = id_match.group(1)

        # Extract Play Store URL and bundle ID
        playstore_match = re.search(
            r'href="(https://play\.google\.com/store/apps/details\?id=[^"]+)"',
            row_html
        )
        if playstore_match:
            app["googlePlayUrl"] = playstore_match.group(1)
            # Extract bundle ID
            id_match = re.search(r'id=([^&"]+)', app["googlePlayUrl"])
            if id_match:
                app["bundle_id"] = id_match.group(1)

        # Extract description
        desc_match = re.search(
            r'<div[^>]*class="[^"]*text-xs[^"]*text-gray[^"]*"[^>]*>([^<]+)',
            row_html
        )
        if desc_match:
            app["description"] = desc_match.group(1).strip()

        # Extract icon/logo URL
        icon_match = re.search(
            r'<img[^>]*alt="[^"]*icon"[^>]*src="([^"]+)"',
            row_html
        )
        if icon_match:
            app["logo"] = icon_match.group(1)

        # Extract all td cells with their content
        cells = re.findall(r'<td[^>]*>(.*?)</td>', row_html, re.DOTALL)

        # Parse numeric values from cells
        # Look for patterns like $123,456 or 123,456
        numeric_values = []
        for cell in cells:
            # Find dollar amounts
            money_match = re.search(r'\$([0-9,]+)', cell)
            if money_match:
                numeric_values.append(("money", self._parse_number(money_match.group(1))))
            else:
                # Find plain numbers
                num_match = re.search(r'>([0-9,]+)<', cell)
                if num_match:
                    numeric_values.append(("number", self._parse_number(num_match.group(1))))

        # Assign values based on position
        # Typically: [rank], [app_info], [founder], [revenue], [mrr], [subs], [downloads]
        money_idx = 0
        number_idx = 0
        for val_type, val in numeric_values:
            if val_type == "money":
                if money_idx == 0:
                    app["revenue"] = val
                elif money_idx == 1:
                    app["mrr"] = val
                money_idx += 1
            elif val_type == "number" and val > 100:  # Skip small numbers (likely rank)
                if number_idx == 0:
                    app["active_subscriptions"] = val
                elif number_idx == 1:
                    app["downloads_28d"] = val
                number_idx += 1

        # Generate a unique ID from name
        if app.get("name"):
            app["id"] = re.sub(r'[^a-z0-9]+', '-', app["name"].lower()).strip('-')

        # Mark as RevenueCat verified (whatsthe.app only shows RevenueCat data)
        app["credential_type"] = "revenuecat-verified"

        return app if app.get("name") else None

    def _parse_number(self, value: str) -> int:
        """Parse a number string like '123,456' to int."""
        try:
            return int(value.replace(",", "").replace("$", ""))
        except (ValueError, AttributeError):
            return 0


async def scrape_whatstheapp() -> list[RevenueApp]:
    """Convenience function to scrape whatsthe.app."""
    scraper = WhatsTheAppScraper()
    return await scraper.scrape_all()
