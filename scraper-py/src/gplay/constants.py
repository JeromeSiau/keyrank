"""Google Play Store constants and URL builders."""

import re
from urllib.parse import quote

# Base URLs
PLAY_STORE_BASE = "https://play.google.com"

# Regex patterns for parsing
SCRIPT_PATTERN = re.compile(r"AF_initDataCallback\(({key:\s*'ds:.*?)\);</script>", re.DOTALL)
KEY_PATTERN = re.compile(r"key:\s*'(ds:\d+)'")
DATA_PATTERN = re.compile(r"data:([\s\S]*?), sideChannel:", re.DOTALL)


class URLs:
    """URL builders for Google Play endpoints."""

    @staticmethod
    def search(query: str, lang: str = "en", country: str = "us") -> str:
        """Build search results URL."""
        return f"{PLAY_STORE_BASE}/store/search?q={quote(query)}&c=apps&hl={lang}&gl={country}"

    @staticmethod
    def app_details(app_id: str, lang: str = "en", country: str = "us") -> str:
        """Build app details URL."""
        return f"{PLAY_STORE_BASE}/store/apps/details?id={app_id}&hl={lang}&gl={country}"

    @staticmethod
    def suggest(query: str, lang: str = "en", country: str = "us") -> str:
        """Build autocomplete suggestions URL."""
        return f"{PLAY_STORE_BASE}/store/suggest?q={quote(query)}&c=apps&hl={lang}&gl={country}"

    @staticmethod
    def top_charts(
        category: str = "APPLICATION",
        collection: str = "topselling_free",
        lang: str = "en",
        country: str = "us",
    ) -> str:
        """Build top charts URL."""
        return f"{PLAY_STORE_BASE}/store/apps/collection/{collection}?cat={category}&hl={lang}&gl={country}"

    @staticmethod
    def category_list(lang: str = "en", country: str = "us") -> str:
        """Build categories list URL."""
        return f"{PLAY_STORE_BASE}/store/apps?hl={lang}&gl={country}"

    @staticmethod
    def reviews_api(lang: str = "en", country: str = "us") -> str:
        """Build reviews batch API URL."""
        return f"{PLAY_STORE_BASE}/_/PlayStoreUi/data/batchexecute?hl={lang}&gl={country}"


# Collection mappings
COLLECTIONS = {
    "top_free": "topselling_free",
    "top_paid": "topselling_paid",
    "top_grossing": "topgrossing",
    "grossing": "topgrossing",
    "trending": "movers_shakers",
}

# Sort options for reviews
REVIEW_SORT = {
    "newest": 2,
    "rating": 3,
    "helpfulness": 1,
}

# Category mappings
CATEGORIES = {
    "APPLICATION": "All Apps",
    "ART_AND_DESIGN": "Art & Design",
    "AUTO_AND_VEHICLES": "Auto & Vehicles",
    "BEAUTY": "Beauty",
    "BOOKS_AND_REFERENCE": "Books & Reference",
    "BUSINESS": "Business",
    "COMICS": "Comics",
    "COMMUNICATION": "Communication",
    "DATING": "Dating",
    "EDUCATION": "Education",
    "ENTERTAINMENT": "Entertainment",
    "EVENTS": "Events",
    "FINANCE": "Finance",
    "FOOD_AND_DRINK": "Food & Drink",
    "GAME": "Games",
    "HEALTH_AND_FITNESS": "Health & Fitness",
    "HOUSE_AND_HOME": "House & Home",
    "LIBRARIES_AND_DEMO": "Libraries & Demo",
    "LIFESTYLE": "Lifestyle",
    "MAPS_AND_NAVIGATION": "Maps & Navigation",
    "MEDICAL": "Medical",
    "MUSIC_AND_AUDIO": "Music & Audio",
    "NEWS_AND_MAGAZINES": "News & Magazines",
    "PARENTING": "Parenting",
    "PERSONALIZATION": "Personalization",
    "PHOTOGRAPHY": "Photography",
    "PRODUCTIVITY": "Productivity",
    "SHOPPING": "Shopping",
    "SOCIAL": "Social",
    "SPORTS": "Sports",
    "TOOLS": "Tools",
    "TRAVEL_AND_LOCAL": "Travel & Local",
    "VIDEO_PLAYERS": "Video Players & Editors",
    "WEATHER": "Weather",
    # Game subcategories
    "GAME_ACTION": "Action Games",
    "GAME_ADVENTURE": "Adventure Games",
    "GAME_ARCADE": "Arcade Games",
    "GAME_BOARD": "Board Games",
    "GAME_CARD": "Card Games",
    "GAME_CASINO": "Casino Games",
    "GAME_CASUAL": "Casual Games",
    "GAME_EDUCATIONAL": "Educational Games",
    "GAME_MUSIC": "Music Games",
    "GAME_PUZZLE": "Puzzle Games",
    "GAME_RACING": "Racing Games",
    "GAME_ROLE_PLAYING": "Role Playing Games",
    "GAME_SIMULATION": "Simulation Games",
    "GAME_SPORTS": "Sports Games",
    "GAME_STRATEGY": "Strategy Games",
    "GAME_TRIVIA": "Trivia Games",
    "GAME_WORD": "Word Games",
}
