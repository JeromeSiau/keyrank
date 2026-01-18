"""Revenue scraping API routes."""

from datetime import datetime

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from .appbusinessbrokers import AppBusinessBrokersScraper
from .flippa import FlippaScraper
from .microns import MicronsScraper
from .models import RevenueApp, ScrapeResult
from .whatstheapp import WhatsTheAppScraper

router = APIRouter(prefix="/revenue", tags=["Revenue"])


class ScrapeRequest(BaseModel):
    """Request body for scraping endpoints."""

    skip_urls: list[str] = []
    limit: int | None = None


def serialize_app(app: RevenueApp) -> dict:
    """Serialize a RevenueApp to dict for API response."""
    return {
        "source_id": app.source_id,
        "source_url": app.source_url,
        "name": app.app_name,
        "mrr": app.mrr_cents / 100 if app.mrr_cents else None,
        "monthly_revenue": app.monthly_revenue_cents / 100 if app.monthly_revenue_cents else None,
        "arr": app.annual_revenue_cents / 100 if app.annual_revenue_cents else None,
        "annual_revenue": app.annual_revenue_cents / 100 if app.annual_revenue_cents else None,
        "monthly_profit": app.monthly_profit_cents / 100 if app.monthly_profit_cents else None,
        "asking_price": app.asking_price_cents / 100 if app.asking_price_cents else None,
        "platform": app.platform.value,
        "apple_id": app.apple_id,
        "bundle_id": app.bundle_id,
        "app_store_url": app.app_store_url,
        "play_store_url": app.play_store_url,
        "active_subscribers": app.active_subscribers,
        "active_trials": app.active_trials,
        "active_users": app.active_users,
        "monthly_downloads": app.monthly_downloads,
        "total_downloads": app.total_downloads,
        "new_customers": app.new_customers,
        "ltv": app.ltv_cents / 100 if app.ltv_cents else None,
        "arpu": app.arpu_cents / 100 if app.arpu_cents else None,
        "churn_rate": app.churn_rate,
        "growth_rate_mom": app.growth_rate_mom,
        "revenue_verified": app.revenue_verified,
        "credential_type": app.credential_type.value,
        "business_model": app.business_model.value if app.business_model else None,
        "category": app.category,
        "is_for_sale": app.is_for_sale,
        "ios_rating": app.ios_rating,
        "android_rating": app.android_rating,
        "description": app.description,
    }


@router.post("/whatstheapp")
async def scrape_whatstheapp(request: ScrapeRequest = ScrapeRequest()):
    """Scrape revenue data from whatsthe.app.

    Returns a list of apps with their revenue metrics from RevenueCat.
    """
    started_at = datetime.utcnow()

    try:
        scraper = WhatsTheAppScraper()
        apps, skipped_urls = await scraper.scrape_all(
            limit=request.limit,
            skip_urls=set(request.skip_urls),
        )

        result = ScrapeResult(
            source="whatstheapp",
            success=True,
            apps_found=len(apps),
            started_at=started_at,
            completed_at=datetime.utcnow(),
            apps=apps,
        )

        return {
            "success": True,
            "source": "whatstheapp",
            "count": len(apps),
            "apps": [serialize_app(app) for app in apps],
            "skipped_urls": skipped_urls,
            "scraped_at": result.completed_at.isoformat() if result.completed_at else None,
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Scraping failed: {str(e)}")


@router.get("/whatstheapp/raw")
async def scrape_whatstheapp_raw(limit: int | None = None):
    """Scrape whatsthe.app and return raw data for debugging."""
    try:
        scraper = WhatsTheAppScraper()
        apps, _ = await scraper.scrape_all(limit=limit)

        return {
            "count": len(apps),
            "apps": [app.model_dump() for app in apps],
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Scraping failed: {str(e)}")


@router.post("/appbusinessbrokers")
async def scrape_appbusinessbrokers(request: ScrapeRequest = ScrapeRequest()):
    """Scrape revenue data from appbusinessbrokers.com.

    Returns a list of apps for sale with their revenue metrics.
    Note: Data is self-reported by sellers.
    """
    started_at = datetime.utcnow()

    try:
        scraper = AppBusinessBrokersScraper()
        apps, skipped_urls = await scraper.scrape_all(
            limit=request.limit,
            skip_urls=set(request.skip_urls),
        )

        result = ScrapeResult(
            source="appbusinessbrokers",
            success=True,
            apps_found=len(apps),
            started_at=started_at,
            completed_at=datetime.utcnow(),
            apps=apps,
        )

        return {
            "success": True,
            "source": "appbusinessbrokers",
            "count": len(apps),
            "apps": [serialize_app(app) for app in apps],
            "skipped_urls": skipped_urls,
            "scraped_at": result.completed_at.isoformat() if result.completed_at else None,
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Scraping failed: {str(e)}")


@router.get("/appbusinessbrokers/raw")
async def scrape_appbusinessbrokers_raw(limit: int | None = None):
    """Scrape appbusinessbrokers.com and return raw data for debugging."""
    try:
        scraper = AppBusinessBrokersScraper()
        apps, _ = await scraper.scrape_all(limit=limit)

        return {
            "count": len(apps),
            "apps": [app.model_dump() for app in apps],
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Scraping failed: {str(e)}")


@router.post("/flippa")
async def scrape_flippa(request: ScrapeRequest = ScrapeRequest()):
    """Scrape revenue data from flippa.com.

    Returns a list of mobile apps for sale with their revenue metrics.
    Note: Data is self-reported by sellers.
    """
    started_at = datetime.utcnow()

    try:
        scraper = FlippaScraper()
        apps, skipped_urls = await scraper.scrape_all(
            limit=request.limit,
            skip_urls=set(request.skip_urls),
        )

        result = ScrapeResult(
            source="flippa",
            success=True,
            apps_found=len(apps),
            started_at=started_at,
            completed_at=datetime.utcnow(),
            apps=apps,
        )

        return {
            "success": True,
            "source": "flippa",
            "count": len(apps),
            "apps": [serialize_app(app) for app in apps],
            "skipped_urls": skipped_urls,
            "scraped_at": result.completed_at.isoformat() if result.completed_at else None,
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Scraping failed: {str(e)}")


@router.get("/flippa/raw")
async def scrape_flippa_raw(limit: int | None = None):
    """Scrape flippa.com and return raw data for debugging."""
    try:
        scraper = FlippaScraper()
        apps, _ = await scraper.scrape_all(limit=limit)

        return {
            "count": len(apps),
            "apps": [app.model_dump() for app in apps],
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Scraping failed: {str(e)}")


@router.post("/microns")
async def scrape_microns(request: ScrapeRequest = ScrapeRequest()):
    """Scrape revenue data from microns.io.

    Returns a list of mobile apps for sale with their revenue metrics.
    Note: Data is self-reported by sellers.
    """
    started_at = datetime.utcnow()

    try:
        scraper = MicronsScraper()
        apps, skipped_urls = await scraper.scrape_all(
            limit=request.limit,
            skip_urls=set(request.skip_urls),
        )

        result = ScrapeResult(
            source="microns",
            success=True,
            apps_found=len(apps),
            started_at=started_at,
            completed_at=datetime.utcnow(),
            apps=apps,
        )

        return {
            "success": True,
            "source": "microns",
            "count": len(apps),
            "apps": [serialize_app(app) for app in apps],
            "skipped_urls": skipped_urls,
            "scraped_at": result.completed_at.isoformat() if result.completed_at else None,
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Scraping failed: {str(e)}")


@router.get("/microns/raw")
async def scrape_microns_raw(limit: int | None = None):
    """Scrape microns.io and return raw data for debugging."""
    try:
        scraper = MicronsScraper()
        apps, _ = await scraper.scrape_all(limit=limit)

        return {
            "count": len(apps),
            "apps": [app.model_dump() for app in apps],
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Scraping failed: {str(e)}")
