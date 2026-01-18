"""Revenue scraping API routes."""

from datetime import datetime

from fastapi import APIRouter, HTTPException

from .models import ScrapeResult
from .whatstheapp import WhatsTheAppScraper

router = APIRouter(prefix="/revenue", tags=["Revenue"])


@router.get("/whatstheapp")
async def scrape_whatstheapp():
    """Scrape revenue data from whatsthe.app.

    Returns a list of apps with their revenue metrics from RevenueCat.
    """
    started_at = datetime.utcnow()

    try:
        scraper = WhatsTheAppScraper()
        apps = await scraper.scrape_all()

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
            "apps": [
                {
                    "source_id": app.source_id,
                    "name": app.app_name,
                    "mrr": app.mrr_cents / 100 if app.mrr_cents else None,
                    "monthly_revenue": app.monthly_revenue_cents / 100 if app.monthly_revenue_cents else None,
                    "platform": app.platform.value,
                    "apple_id": app.apple_id,
                    "bundle_id": app.bundle_id,
                    "app_store_url": app.app_store_url,
                    "play_store_url": app.play_store_url,
                    "active_subscribers": app.active_subscribers,
                    "monthly_downloads": app.monthly_downloads,
                    "revenue_verified": app.revenue_verified,
                    "credential_type": app.credential_type.value,
                    "is_for_sale": app.is_for_sale,
                    "ios_rating": app.ios_rating,
                    "android_rating": app.android_rating,
                    "description": app.description,
                }
                for app in apps
            ],
            "scraped_at": result.completed_at.isoformat() if result.completed_at else None,
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Scraping failed: {str(e)}")


@router.get("/whatstheapp/raw")
async def scrape_whatstheapp_raw():
    """Scrape whatsthe.app and return raw data for debugging."""
    try:
        scraper = WhatsTheAppScraper()
        apps = await scraper.scrape_all()

        return {
            "count": len(apps),
            "apps": [app.model_dump() for app in apps],
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Scraping failed: {str(e)}")
