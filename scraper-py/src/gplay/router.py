"""Google Play Store API routes."""

import hashlib
import re
from datetime import datetime
from functools import lru_cache

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel

from ..core.config import settings
from ..core.proxy import ProxyRouter
from .scraper import GooglePlayScraper


router = APIRouter(tags=["Google Play"])


# Pydantic models for request bodies
class RankingsRequest(BaseModel):
    app_id: str
    keywords: list[str]
    country: str = "us"
    lang: str = "en"


# Dependency injection
@lru_cache()
def get_proxy_router() -> ProxyRouter | None:
    """Get proxy router from environment."""
    import os
    proxy_list = os.getenv("PROXY_LIST", "")
    if not proxy_list:
        return None
    return ProxyRouter.from_env(proxy_list)


def get_scraper(proxy_router: ProxyRouter | None = Depends(get_proxy_router)) -> GooglePlayScraper:
    """Get scraper instance with proxy support."""
    return GooglePlayScraper(
        proxy_router=proxy_router,
        rate_limit_delay=settings.rate_limit_delay_ms / 1000,
    )


# Helper functions
def format_app(app_data: dict, position: int | None = None) -> dict:
    """Format app data to match Node.js scraper output."""
    result = {
        "google_play_id": app_data.get("appId", ""),
        "name": app_data.get("title", ""),
        "icon_url": app_data.get("icon", ""),
        "developer": app_data.get("developer", ""),
        "rating": app_data.get("score"),
        "rating_count": app_data.get("ratings", 0),
        "price": app_data.get("price", 0),
        "free": app_data.get("free", True),
    }
    if position is not None:
        result["position"] = position
    return result


def format_app_details(app_data: dict) -> dict:
    """Format full app details."""
    return {
        "google_play_id": app_data.get("appId", ""),
        "name": app_data.get("title", ""),
        "icon_url": app_data.get("icon", ""),
        "developer": app_data.get("developer", ""),
        "developer_id": app_data.get("developerId", ""),
        "description": app_data.get("description", ""),
        "summary": app_data.get("summary", ""),
        "rating": app_data.get("score"),
        "rating_count": app_data.get("ratings", 0),
        "reviews_count": app_data.get("reviews", 0),
        "price": app_data.get("price", 0),
        "free": app_data.get("free", True),
        "currency": app_data.get("currency", "USD"),
        "version": app_data.get("version"),
        "updated": app_data.get("updated"),
        "recent_changes": app_data.get("recentChanges", ""),
        "genre": app_data.get("genre"),
        "genre_id": app_data.get("genreId"),
        "content_rating": app_data.get("contentRating"),
        "installs": app_data.get("installs"),
        "min_installs": app_data.get("minInstalls"),
        "real_installs": app_data.get("realInstalls"),
        "screenshots": app_data.get("screenshots", []),
        "video": app_data.get("video"),
        "header_image": app_data.get("headerImage"),
        "store_url": app_data.get("url", ""),
    }


# Routes
@router.get("/app/{app_id}")
async def get_app(
    app_id: str,
    country: str = Query(default="us"),
    lang: str = Query(default="en"),
    scraper: GooglePlayScraper = Depends(get_scraper),
):
    """Get details for a specific app."""
    app_data = await scraper.app(app_id, lang=lang, country=country)

    if not app_data:
        # Try search fallback
        results = await scraper.search(app_id, lang=lang, country=country, limit=50)
        matched = next((a for a in results if a.get("appId") == app_id), None)

        if matched:
            return {
                "google_play_id": matched.get("appId", ""),
                "name": matched.get("title", ""),
                "icon_url": matched.get("icon", ""),
                "developer": matched.get("developer", ""),
                "developer_id": None,
                "description": "",
                "summary": "",
                "rating": matched.get("score"),
                "rating_count": 0,
                "reviews_count": 0,
                "price": matched.get("price", 0),
                "free": matched.get("free", True),
                "currency": matched.get("currency", "USD"),
                "version": None,
                "updated": None,
                "recent_changes": "",
                "genre": matched.get("genre"),
                "genre_id": None,
                "content_rating": None,
                "installs": matched.get("installs"),
                "min_installs": None,
                "real_installs": None,
                "screenshots": [],
                "video": None,
                "header_image": None,
                "store_url": "",
            }

        raise HTTPException(status_code=404, detail="App not found")

    return format_app_details(app_data)


@router.get("/search")
async def search_apps(
    term: str = Query(..., min_length=2),
    country: str = Query(default="us"),
    lang: str = Query(default="en"),
    num: int = Query(default=50, le=250),
    scraper: GooglePlayScraper = Depends(get_scraper),
):
    """Search for apps by term."""
    results = await scraper.search(term, lang=lang, country=country, limit=min(num, 250))
    formatted = [format_app(app, idx + 1) for idx, app in enumerate(results)]
    return {"results": formatted}


@router.post("/search/rankings")
async def get_rankings(
    body: RankingsRequest,
    scraper: GooglePlayScraper = Depends(get_scraper),
):
    """Get keyword rankings for an app."""
    if not body.keywords:
        raise HTTPException(status_code=400, detail="keywords array required")

    rankings = await scraper.get_rankings_batch(
        body.app_id,
        body.keywords,
        lang=body.lang,
        country=body.country,
    )

    return {"app_id": body.app_id, "country": body.country, "rankings": rankings}


@router.get("/reviews/{app_id}")
async def get_reviews(
    app_id: str,
    country: str = Query(default="us"),
    lang: str = Query(default="en"),
    sort: str = Query(default="newest"),
    num: int = Query(default=100, le=500),
    scraper: GooglePlayScraper = Depends(get_scraper),
):
    """Get reviews for an app."""
    reviews = await scraper.reviews(
        app_id,
        lang=lang,
        country=country,
        sort=sort,
        count=min(num, 500),
    )

    formatted = []
    for review in reviews:
        # Generate fallback ID if needed
        fallback_id = hashlib.sha1(
            f"{app_id}|{review.get('userName', '')}|{review.get('score', '')}|{review.get('at', '')}|{review.get('content', '')}".encode()
        ).hexdigest()

        formatted.append({
            "review_id": review.get("reviewId") or fallback_id,
            "author": review.get("userName"),
            "rating": review.get("score"),
            "title": None,  # Google Play reviews don't have titles
            "content": review.get("content"),
            "version": review.get("reviewCreatedVersion"),
            "reviewed_at": review.get("at").isoformat() if review.get("at") else None,
            "thumbs_up": review.get("thumbsUpCount"),
            "reply_date": review.get("repliedAt").isoformat() if review.get("repliedAt") else None,
            "reply_text": review.get("replyContent"),
        })

    return {"reviews": formatted}


@router.get("/suggestions/term/{term}")
async def get_suggestions(
    term: str,
    country: str = Query(default="us"),
    lang: str = Query(default="en"),
    scraper: GooglePlayScraper = Depends(get_scraper),
):
    """Get autocomplete suggestions for a search term."""
    if len(term) < 2:
        raise HTTPException(status_code=400, detail="Term must be at least 2 characters")

    suggestions = await scraper.suggest(term, lang=lang, country=country)
    return {"suggestions": suggestions}


@router.get("/suggestions/app/{app_id}")
async def get_app_keyword_suggestions(
    app_id: str,
    country: str = Query(default="us"),
    lang: str = Query(default="en"),
    limit: int = Query(default=50, le=100),
    scraper: GooglePlayScraper = Depends(get_scraper),
):
    """Get keyword suggestions based on an app's name and description."""
    # Get app details first
    app_data = await scraper.app(app_id, lang=lang, country=country)

    if not app_data:
        raise HTTPException(status_code=404, detail="App not found")

    # Extract seed terms
    seeds = _extract_seed_terms(app_data.get("title", ""), app_data.get("description", ""))

    # Get suggestions for each seed
    all_suggestions: dict[str, str] = {}

    for seed in seeds:
        hints = await scraper.suggest(seed["term"], lang=lang, country=country)
        for hint in hints:
            if hint not in all_suggestions:
                all_suggestions[hint] = seed["source"]

    # Build suggestions with metrics
    suggestions = []
    processed = 0

    for keyword, source in all_suggestions.items():
        if processed >= limit:
            break

        results = await scraper.search(keyword, lang=lang, country=country, limit=50)

        # Find app position
        position = next(
            (idx + 1 for idx, app in enumerate(results) if app.get("appId") == app_id),
            None,
        )

        # Calculate difficulty
        difficulty = _calculate_difficulty(results)

        # Top competitors
        top_competitors = [
            {"name": app.get("title"), "position": idx + 1, "rating": app.get("score")}
            for idx, app in enumerate(results[:3])
        ]

        suggestions.append({
            "keyword": keyword,
            "source": source,
            "metrics": {
                "position": position,
                "competition": len(results),
                "difficulty": difficulty["score"],
                "difficulty_label": difficulty["label"],
            },
            "top_competitors": top_competitors,
        })

        processed += 1

    # Sort by opportunity
    suggestions.sort(
        key=lambda x: (
            x["metrics"]["position"] is None,
            x["metrics"]["difficulty"],
        )
    )

    return {
        "data": suggestions,
        "meta": {
            "app_id": app_id,
            "country": country.upper(),
            "total": len(suggestions),
            "generated_at": datetime.utcnow().isoformat(),
        },
    }


@router.get("/top")
async def get_top_charts(
    category: str = Query(default="APPLICATION"),
    country: str = Query(default="us"),
    collection: str = Query(default="top_free"),
    num: int = Query(default=100, le=200),
    scraper: GooglePlayScraper = Depends(get_scraper),
):
    """Get top charts for a category."""
    results = await scraper.top_charts(
        category=category,
        collection=collection,
        lang="en",
        country=country,
        limit=min(num, 200),
    )

    formatted = [format_app(app, idx + 1) for idx, app in enumerate(results)]
    return {"results": formatted}


@router.get("/categories")
async def get_categories(
    scraper: GooglePlayScraper = Depends(get_scraper),
):
    """Get list of available categories."""
    categories = await scraper.categories()
    return {"categories": categories}


# Helper functions
def _extract_seed_terms(name: str, description: str) -> list[dict]:
    """Extract seed terms from app name and description."""
    stop_words = {
        "the", "and", "for", "with", "your", "you", "from", "that", "this",
        "are", "was", "have", "has", "will", "can", "app", "new", "free",
    }

    seeds = []

    # Tokenize name
    name_words = re.sub(r"[^a-z\s]", " ", name.lower()).split()
    name_words = [w for w in name_words if len(w) >= 3 and w not in stop_words]

    for word in name_words[:5]:
        seeds.append({"term": word, "source": "app_name"})

    # Tokenize description (first 500 chars)
    desc_words = re.sub(r"[^a-z\s]", " ", description[:500].lower()).split()
    desc_words = [w for w in desc_words if len(w) >= 4 and w not in stop_words]

    for word in desc_words[:5]:
        if not any(s["term"] == word for s in seeds):
            seeds.append({"term": word, "source": "app_description"})

    return seeds[:10]


def _calculate_difficulty(results: list) -> dict:
    """Calculate keyword difficulty based on competition."""
    import math

    count = len(results)

    if count == 0:
        return {"score": 0, "label": "easy"}

    # Score based on result count (0-40)
    result_score = min(40, count / 1.25)

    # Score based on top 10 strength (0-60)
    top_10 = results[:10]
    strength_score = 0

    for app in top_10:
        rating = app.get("score") or 0
        reviews = app.get("ratings") or 1
        strength_score += rating * math.log10(max(1, reviews))

    strength_score = min(60, (strength_score / 10) * 6)

    score = round(result_score + strength_score)
    score = max(0, min(100, score))

    if score <= 25:
        label = "easy"
    elif score <= 50:
        label = "medium"
    elif score <= 75:
        label = "hard"
    else:
        label = "very_hard"

    return {"score": score, "label": label}
