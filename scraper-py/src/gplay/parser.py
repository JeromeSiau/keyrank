"""Parser for Google Play Store HTML pages."""

import json
import re
from datetime import datetime
from html import unescape
from typing import Any

from .constants import SCRIPT_PATTERN, KEY_PATTERN, DATA_PATTERN


def nested_lookup(source: Any, path: list[int]) -> Any:
    """Navigate through nested data structure using index path."""
    try:
        result = source
        for idx in path:
            result = result[idx]
        return result
    except (IndexError, KeyError, TypeError):
        return None


def extract_datasets(html: str) -> dict[str, Any]:
    """Extract all AF_initDataCallback datasets from HTML."""
    datasets = {}

    # Find all script blocks with data
    matches = SCRIPT_PATTERN.findall(html)

    for match in matches:
        # Extract key (ds:X)
        key_match = KEY_PATTERN.search(match)
        if not key_match:
            continue
        key = key_match.group(1)

        # Extract data
        data_match = DATA_PATTERN.search(match)
        if not data_match:
            continue

        try:
            data = json.loads(data_match.group(1))
            datasets[key] = data
        except json.JSONDecodeError:
            continue

    return datasets


def parse_app_details(html: str, app_id: str, url: str) -> dict[str, Any]:
    """Parse app details from HTML page."""
    datasets = extract_datasets(html)

    if "ds:5" not in datasets:
        return None

    ds5 = datasets["ds:5"]

    def get(path: list[int], default: Any = None) -> Any:
        """Helper to get value from ds:5."""
        result = nested_lookup(ds5, [1, 2] + path)
        return result if result is not None else default

    # Extract price info
    price_raw = get([57, 0, 0, 0, 0, 1, 0, 0], 0)
    price = (price_raw / 1000000) if price_raw else 0

    return {
        "appId": app_id,
        "url": url,
        "title": nested_lookup(ds5, [1, 2, 0, 0]),
        "description": unescape(get([72, 0, 1], "") or get([12, 0, 0, 1], "") or ""),
        "summary": unescape(get([73, 0, 1], "") or ""),
        "installs": get([13, 0]),
        "minInstalls": get([13, 1]),
        "realInstalls": get([13, 2]),
        "score": get([51, 0, 1]),
        "ratings": get([51, 2, 1]),
        "reviews": get([51, 3, 1]),
        "price": price,
        "free": price == 0,
        "currency": get([57, 0, 0, 0, 0, 1, 0, 1], "USD"),
        "developer": get([68, 0]),
        "developerId": _extract_developer_id(get([68, 1, 4, 2])),
        "developerEmail": get([69, 1, 0]),
        "developerWebsite": get([69, 0, 5, 2]),
        "genre": get([79, 0, 0, 0]),
        "genreId": get([79, 0, 0, 2]),
        "icon": get([95, 0, 3, 2]),
        "headerImage": get([96, 0, 3, 2]),
        "screenshots": _extract_screenshots(get([78, 0], [])),
        "video": get([100, 0, 0, 3, 2]),
        "contentRating": get([9, 0]),
        "released": get([10, 0]),
        "updated": get([145, 0, 1, 0]),
        "version": get([140, 0, 0, 0], "Varies with device"),
        "recentChanges": unescape(get([144, 1, 1], "") or ""),
    }


def _extract_developer_id(url: str | None) -> str | None:
    """Extract developer ID from URL."""
    if not url or "id=" not in url:
        return None
    return url.split("id=")[1]


def _extract_screenshots(container: list | None) -> list[str]:
    """Extract screenshot URLs from container."""
    if not container:
        return []
    try:
        return [item[3][2] for item in container if item and len(item) > 3]
    except (IndexError, TypeError):
        return []


def parse_search_results(html: str, limit: int = 50) -> list[dict[str, Any]]:
    """Parse search results from HTML page."""
    datasets = extract_datasets(html)

    if "ds:4" not in datasets:
        return []

    results = []

    # Try to find app data in various locations
    ds4 = datasets["ds:4"]

    # Extract top result if exists
    top_result = nested_lookup(ds4, [0, 1, 0, 23, 16])
    if top_result:
        app = _parse_search_result_top(top_result)
        if app and app.get("appId"):
            results.append(app)

    # Extract main results - try different indices
    app_list = None
    for idx in range(10):
        candidate = nested_lookup(ds4, [0, 1, idx, 22, 0])
        if candidate and isinstance(candidate, list):
            app_list = candidate
            break

    if app_list:
        for item in app_list[:limit - len(results)]:
            app = _parse_search_result(item)
            if app and app.get("appId"):
                results.append(app)

    return results[:limit]


def _parse_search_result_top(data: Any) -> dict[str, Any] | None:
    """Parse top search result."""
    if not data:
        return None

    price_raw = nested_lookup(data, [2, 57, 0, 0, 0, 0, 1, 0, 0]) or 0
    price = (price_raw / 1000000) if price_raw else 0

    # Try multiple paths for appId
    app_id = nested_lookup(data, [11, 0, 0])

    # Fallback: extract from URL at [2][41][0][2]
    if not app_id:
        url = nested_lookup(data, [2, 41, 0, 2])
        if url and "id=" in url:
            app_id = url.split("id=")[1].split("&")[0]

    return {
        "appId": app_id,
        "title": nested_lookup(data, [2, 0, 0]),
        "icon": nested_lookup(data, [2, 95, 0, 3, 2]),
        "developer": nested_lookup(data, [2, 68, 0]),
        "score": nested_lookup(data, [2, 51, 0, 1]),
        "price": price,
        "free": price == 0,
        "currency": nested_lookup(data, [2, 57, 0, 0, 0, 0, 1, 0, 1]) or "USD",
        "installs": nested_lookup(data, [2, 13, 0]),
        "genre": nested_lookup(data, [2, 79, 0, 0, 0]),
    }


def _parse_search_result(data: Any) -> dict[str, Any] | None:
    """Parse regular search result."""
    if not data:
        return None

    price_raw = nested_lookup(data, [0, 8, 1, 0, 0]) or 0
    price = (price_raw / 1000000) if price_raw else 0

    return {
        "appId": nested_lookup(data, [0, 0, 0]),
        "title": nested_lookup(data, [0, 3]),
        "icon": nested_lookup(data, [0, 1, 3, 2]),
        "developer": nested_lookup(data, [0, 14]),
        "score": nested_lookup(data, [0, 4, 1]),
        "price": price,
        "free": price == 0,
        "currency": nested_lookup(data, [0, 8, 1, 0, 1]) or "USD",
        "installs": nested_lookup(data, [0, 15]),
        "genre": nested_lookup(data, [0, 5]),
    }


def parse_suggestions(response_text: str) -> list[str]:
    """Parse autocomplete suggestions from batchexecute response."""
    try:
        # Remove batchexecute prefix (similar to reviews)
        clean = response_text
        if clean.startswith(")]}'"):
            clean = clean[4:]

        # Find the main data array
        lines = clean.strip().split("\n")
        for line in lines:
            line = line.strip()
            if line.startswith("[["):
                data = json.loads(line)
                break
        else:
            return []

        # Navigate to suggestions data
        # Structure: [["wrb.fr","IJ4APc","[JSON_STRING]",...]]
        if data and len(data) > 0 and len(data[0]) > 2:
            inner_json = data[0][2]
            if isinstance(inner_json, str):
                suggestions_data = json.loads(inner_json)
                # Extract suggestions from [0][0] array, each item has suggestion at [0]
                if suggestions_data and len(suggestions_data) > 0:
                    suggestions_list = suggestions_data[0]
                    if isinstance(suggestions_list, list) and len(suggestions_list) > 0:
                        return [s[0] for s in suggestions_list[0] if isinstance(s, list) and len(s) > 0]

    except (json.JSONDecodeError, IndexError, TypeError, KeyError):
        pass

    return []


def parse_reviews(response_text: str) -> tuple[list[dict[str, Any]], str | None]:
    """Parse reviews from batch API response."""
    reviews = []
    next_token = None

    # Response format is weird - need to extract JSON from specific format
    # )]}'\n\nXXX\n[["wrb.fr",...
    try:
        # Remove prefix
        clean = response_text
        if clean.startswith(")]}'"):
            clean = clean[4:]

        # Find the main data array
        lines = clean.strip().split("\n")
        for line in lines:
            line = line.strip()
            if line.startswith("[["):
                data = json.loads(line)
                break
        else:
            return [], None

        # Navigate to review data
        # Structure: [["wrb.fr","oCPfdb","[JSON_STRING]",...]]
        if data and len(data) > 0 and len(data[0]) > 2:
            inner_json = data[0][2]
            if isinstance(inner_json, str):
                review_data = json.loads(inner_json)

                # Extract reviews
                review_list = nested_lookup(review_data, [0])
                if review_list:
                    for item in review_list:
                        review = _parse_review(item)
                        if review:
                            reviews.append(review)

                # Extract next page token
                next_token = nested_lookup(review_data, [1, 1])

    except (json.JSONDecodeError, IndexError, TypeError):
        pass

    return reviews, next_token


def _parse_review(data: Any) -> dict[str, Any] | None:
    """Parse a single review."""
    if not data:
        return None

    at_timestamp = nested_lookup(data, [5, 0])
    replied_at_timestamp = nested_lookup(data, [7, 2, 0])

    return {
        "reviewId": nested_lookup(data, [0]),
        "userName": nested_lookup(data, [1, 0]),
        "userImage": nested_lookup(data, [1, 1, 3, 2]),
        "content": nested_lookup(data, [4]),
        "score": nested_lookup(data, [2]),
        "thumbsUpCount": nested_lookup(data, [6]),
        "reviewCreatedVersion": nested_lookup(data, [10]),
        "at": datetime.fromtimestamp(at_timestamp) if at_timestamp else None,
        "replyContent": nested_lookup(data, [7, 1]),
        "repliedAt": datetime.fromtimestamp(replied_at_timestamp) if replied_at_timestamp else None,
    }


def parse_top_charts(html: str, limit: int = 100) -> list[dict[str, Any]]:
    """Parse top charts from HTML page.

    Google Play now returns app IDs in a JSON array format.
    We extract these and return minimal app info.
    """
    results = []

    # New format: app IDs are in a JSON array like ["com.app1","com.app2",...]
    pattern = r'(\["com\.[a-zA-Z0-9._]+\"(?:,\"com\.[a-zA-Z0-9._]+\")*\])'
    match = re.search(pattern, html)

    if match:
        try:
            app_ids = json.loads(match.group(1))
            for app_id in app_ids[:limit]:
                results.append({
                    "appId": app_id,
                    "title": None,
                    "icon": None,
                    "developer": None,
                    "score": None,
                    "price": 0,
                    "free": True,
                })
        except json.JSONDecodeError:
            pass

    # Fallback: try old dataset format
    if not results:
        datasets = extract_datasets(html)
        for ds_key in ["ds:3", "ds:4", "ds:5"]:
            if ds_key not in datasets:
                continue

            ds = datasets[ds_key]
            for path in [[0, 1, 0, 0, 0], [0, 1, 0, 21, 0], [0, 1, 0, 22, 0]]:
                app_list = nested_lookup(ds, path)
                if app_list and isinstance(app_list, list):
                    for item in app_list[:limit]:
                        app = _parse_chart_app(item)
                        if app and app.get("appId"):
                            results.append(app)
                    if results:
                        break
            if results:
                break

    return results[:limit]


def _parse_chart_app(data: Any) -> dict[str, Any] | None:
    """Parse app from top charts (old format)."""
    if not data:
        return None

    app_id = nested_lookup(data, [0, 0, 0]) or nested_lookup(data, [12, 0])

    if not app_id:
        return None

    return {
        "appId": app_id,
        "title": nested_lookup(data, [0, 3]) or nested_lookup(data, [3]),
        "icon": nested_lookup(data, [0, 1, 3, 2]) or nested_lookup(data, [1, 3, 2]),
        "developer": nested_lookup(data, [0, 14]) or nested_lookup(data, [14]),
        "score": nested_lookup(data, [0, 4, 1]) or nested_lookup(data, [4, 1]),
        "price": 0,  # Top charts usually show free apps
        "free": True,
    }


def parse_top_charts_batch(response_text: str, limit: int = 100) -> list[dict[str, Any]]:
    """Parse top charts from batchexecute API response."""
    results = []

    try:
        # Remove batchexecute prefix
        clean = response_text
        if clean.startswith(")]}'"):
            clean = clean[4:]

        # Find the data line (usually 4th line, index 3)
        lines = clean.strip().split("\n")
        data_line = None
        for line in lines:
            line = line.strip()
            if line.startswith("[["):
                data_line = line
                break

        if not data_line:
            return []

        # Parse outer response
        outer = json.loads(data_line)

        # Navigate to inner JSON string
        if not outer or len(outer) == 0 or len(outer[0]) < 3:
            return []

        inner_json = outer[0][2]
        if not isinstance(inner_json, str):
            return []

        inner = json.loads(inner_json)

        # Find apps list - try multiple paths
        apps_list = None
        for path in [[0, 1, 0, 28, 0], [0, 1, 0, 21, 0], [0, 1, 0, 22, 0], [0, 0, 0]]:
            candidate = nested_lookup(inner, path)
            if candidate and isinstance(candidate, list) and len(candidate) > 0:
                apps_list = candidate
                break

        if not apps_list:
            return []

        # Parse each app
        for item in apps_list[:limit]:
            app = _parse_batch_app(item)
            if app and app.get("appId"):
                results.append(app)

    except (json.JSONDecodeError, IndexError, TypeError, KeyError):
        pass

    return results[:limit]


def _parse_batch_app(data: Any) -> dict[str, Any] | None:
    """Parse app from batchexecute response."""
    if not data:
        return None

    # Try different paths for appId
    app_id = nested_lookup(data, [0, 0, 0])
    if not app_id:
        app_id = nested_lookup(data, [12, 0])

    if not app_id:
        return None

    # Extract price
    price_raw = nested_lookup(data, [0, 8, 1, 0, 0]) or 0
    price = (price_raw / 1000000) if price_raw else 0

    return {
        "appId": app_id,
        "title": nested_lookup(data, [0, 3]),
        "icon": nested_lookup(data, [0, 1, 3, 2]),
        "developer": nested_lookup(data, [0, 14]),
        "score": nested_lookup(data, [0, 4, 1]),
        "ratings": nested_lookup(data, [0, 4, 2]),
        "price": price,
        "free": price == 0,
        "installs": nested_lookup(data, [0, 15]),
    }
