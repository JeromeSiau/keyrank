"""Pydantic models for revenue data."""

from datetime import datetime
from enum import Enum
from typing import Any

from pydantic import BaseModel, Field


class Platform(str, Enum):
    IOS = "ios"
    ANDROID = "android"
    BOTH = "both"


class BusinessModel(str, Enum):
    SUBSCRIPTION = "subscription"
    FREEMIUM = "freemium"
    PAID = "paid"
    ADS = "ads"
    HYBRID = "hybrid"


class CredentialType(str, Enum):
    REVENUECAT_VERIFIED = "revenuecat-verified"
    SELF_REPORTED = "self-reported"
    PLATFORM_VERIFIED = "platform-verified"
    UNKNOWN = "unknown"


class RevenueApp(BaseModel):
    """Revenue data for a single app."""

    # Identification
    source: str = Field(description="Source platform: whatstheapp, flippa, etc.")
    source_id: str = Field(description="Unique ID on the source platform")
    source_url: str | None = Field(default=None, description="Full URL of the scraped page")
    app_name: str
    app_store_url: str | None = None
    play_store_url: str | None = None
    apple_id: str | None = None
    bundle_id: str | None = None
    platform: Platform = Platform.IOS

    # Financials (in cents for precision)
    monthly_revenue_cents: int | None = None
    annual_revenue_cents: int | None = None
    mrr_cents: int | None = None
    monthly_profit_cents: int | None = None
    asking_price_cents: int | None = None
    currency: str = "USD"
    revenue_verified: bool = False
    credential_type: CredentialType = CredentialType.UNKNOWN

    # Users & Growth
    monthly_downloads: int | None = None
    total_downloads: int | None = None
    active_users: int | None = None
    active_subscribers: int | None = None
    active_trials: int | None = None
    new_customers: int | None = None
    churn_rate: float | None = None
    growth_rate_mom: float | None = None

    # Unit Economics (in cents for precision)
    ltv_cents: int | None = None
    arpu_cents: int | None = None

    # Metadata
    category: str | None = None
    business_model: BusinessModel | None = None
    description: str | None = None
    logo_url: str | None = None
    is_for_sale: bool = False
    listing_date: datetime | None = None

    # Ratings (from marketplace data)
    ios_rating: float | None = None
    android_rating: float | None = None

    # Scraping metadata
    scraped_at: datetime = Field(default_factory=datetime.utcnow)
    raw_data: dict[str, Any] | None = None

    @classmethod
    def from_whatstheapp(cls, data: dict[str, Any]) -> "RevenueApp":
        """Create RevenueApp from whatsthe.app JSON data."""
        # Extract Apple ID from URL
        apple_id = None
        app_store_url = data.get("appStoreUrl")
        if app_store_url and "/id" in app_store_url:
            try:
                apple_id = app_store_url.split("/id")[-1].split("?")[0]
            except (IndexError, ValueError):
                pass

        # Extract bundle ID from Play Store URL
        bundle_id = None
        play_store_url = data.get("googlePlayUrl")
        if play_store_url and "id=" in play_store_url:
            try:
                bundle_id = play_store_url.split("id=")[-1].split("&")[0]
            except (IndexError, ValueError):
                pass

        # Determine platform
        platform = Platform.BOTH
        if app_store_url and not play_store_url:
            platform = Platform.IOS
        elif play_store_url and not app_store_url:
            platform = Platform.ANDROID

        # Map credential type
        cred_type = CredentialType.UNKNOWN
        raw_cred = data.get("credential_type", "")
        if "revenuecat" in raw_cred.lower():
            cred_type = CredentialType.REVENUECAT_VERIFIED
        elif "verified" in raw_cred.lower():
            cred_type = CredentialType.PLATFORM_VERIFIED

        # Convert dollars to cents
        mrr = data.get("mrr")
        revenue = data.get("revenue")

        return cls(
            source="whatstheapp",
            source_id=data.get("id", data.get("url_identifier", "")),
            app_name=data.get("name", ""),
            app_store_url=app_store_url,
            play_store_url=play_store_url,
            apple_id=apple_id,
            bundle_id=bundle_id,
            platform=platform,
            mrr_cents=int(mrr * 100) if mrr else None,
            monthly_revenue_cents=int(revenue * 100) if revenue else None,
            currency="USD",
            revenue_verified=cred_type == CredentialType.REVENUECAT_VERIFIED,
            credential_type=cred_type,
            monthly_downloads=data.get("downloads_28d"),
            active_subscribers=data.get("active_subscriptions"),
            active_trials=data.get("active_trials"),
            active_users=data.get("active_customers") or data.get("active_users"),
            new_customers=data.get("new_customers"),
            growth_rate_mom=data.get("mrr_growth_mom"),
            description=data.get("description"),
            logo_url=data.get("logo"),
            is_for_sale=data.get("is_for_sale", False),
            ios_rating=data.get("ios_rating"),
            android_rating=data.get("android_rating"),
            business_model=BusinessModel.SUBSCRIPTION,  # whatsthe.app is RevenueCat focused
            raw_data=data,
        )

    @classmethod
    def from_appbusinessbrokers(cls, data: dict[str, Any]) -> "RevenueApp":
        """Create RevenueApp from appbusinessbrokers.com data."""
        # Determine platform
        platform_str = data.get("platform", "ios")
        if platform_str == "both":
            platform = Platform.BOTH
        elif platform_str == "android":
            platform = Platform.ANDROID
        else:
            platform = Platform.IOS

        # Map business model
        biz_model = None
        raw_biz = data.get("business_model", "")
        if raw_biz == "subscription":
            biz_model = BusinessModel.SUBSCRIPTION
        elif raw_biz == "freemium":
            biz_model = BusinessModel.FREEMIUM
        elif raw_biz == "paid":
            biz_model = BusinessModel.PAID
        elif raw_biz == "ads":
            biz_model = BusinessModel.ADS

        # Convert dollars to cents
        mrr = data.get("mrr")
        annual_revenue = data.get("annual_revenue")
        annual_profit = data.get("annual_profit")
        asking_price = data.get("asking_price")

        return cls(
            source="appbusinessbrokers",
            source_id=data.get("source_id", ""),
            app_name=data.get("name", ""),
            app_store_url=data.get("app_store_url"),
            play_store_url=data.get("play_store_url"),
            apple_id=data.get("apple_id"),
            bundle_id=data.get("bundle_id"),
            platform=platform,
            mrr_cents=int(mrr * 100) if mrr else None,
            annual_revenue_cents=int(annual_revenue * 100) if annual_revenue else None,
            monthly_profit_cents=int(annual_profit / 12 * 100) if annual_profit else None,
            asking_price_cents=int(asking_price * 100) if asking_price else None,
            currency="USD",
            revenue_verified=False,  # Self-reported data
            credential_type=CredentialType.SELF_REPORTED,
            total_downloads=data.get("total_downloads"),
            monthly_downloads=data.get("monthly_downloads"),
            active_subscribers=data.get("active_subscribers"),
            category=data.get("category"),
            business_model=biz_model,
            description=data.get("description"),
            is_for_sale=True,  # All listings are for sale
            ios_rating=data.get("rating") if platform != Platform.ANDROID else None,
            android_rating=data.get("rating") if platform == Platform.ANDROID else None,
            raw_data=data,
        )


class ScrapeResult(BaseModel):
    """Result of a scraping operation."""

    source: str
    success: bool
    apps_found: int = 0
    apps_new: int = 0
    apps_updated: int = 0
    error_message: str | None = None
    started_at: datetime
    completed_at: datetime | None = None
    apps: list[RevenueApp] = []
