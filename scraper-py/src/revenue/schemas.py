"""Pydantic schemas for LLM extraction."""

from pydantic import BaseModel, Field


class ExtractedApp(BaseModel):
    """Schema for LLM to extract app data from web pages.

    This is a simplified schema that the LLM can easily understand.
    It will be mapped to RevenueApp after extraction.
    """

    name: str = Field(description="App name")
    platform: str = Field(
        default="ios",
        description="Platform: 'ios', 'android', or 'both'"
    )

    # Store URLs
    app_store_url: str | None = Field(
        default=None,
        description="Apple App Store URL (apps.apple.com/...)"
    )
    play_store_url: str | None = Field(
        default=None,
        description="Google Play Store URL (play.google.com/...)"
    )

    # Financial data (in dollars, not cents)
    mrr: float | None = Field(
        default=None,
        description="Monthly Recurring Revenue in USD"
    )
    annual_revenue: float | None = Field(
        default=None,
        description="Annual/TTM revenue in USD"
    )
    monthly_profit: float | None = Field(
        default=None,
        description="Monthly profit in USD"
    )
    annual_profit: float | None = Field(
        default=None,
        description="Annual/TTM profit in USD"
    )
    monthly_revenue: float | None = Field(
        default=None,
        description="Monthly revenue in USD (if different from MRR)"
    )
    asking_price: float | None = Field(
        default=None,
        description="Asking/sale price in USD"
    )

    # Usage metrics
    monthly_downloads: int | None = Field(
        default=None,
        description="Downloads per month"
    )
    total_downloads: int | None = Field(
        default=None,
        description="Total lifetime downloads"
    )
    active_subscribers: int | None = Field(
        default=None,
        description="Number of active paying subscribers"
    )
    active_trials: int | None = Field(
        default=None,
        description="Number of active trials"
    )
    active_users: int | None = Field(
        default=None,
        description="Monthly active users (MAU)"
    )
    new_customers: int | None = Field(
        default=None,
        description="New customers in last 28 days"
    )

    # Unit economics
    ltv: float | None = Field(
        default=None,
        description="Customer Lifetime Value in USD"
    )
    arpu: float | None = Field(
        default=None,
        description="Average Revenue Per User in USD"
    )
    churn_rate: float | None = Field(
        default=None,
        description="Monthly churn rate as percentage (e.g., 0.85 for 0.85%)"
    )
    mrr_growth: float | None = Field(
        default=None,
        description="MRR growth rate as percentage"
    )

    # Ratings
    rating: float | None = Field(
        default=None,
        description="App store rating (0-5)"
    )
    ios_rating: float | None = Field(
        default=None,
        description="iOS App Store rating (0-5)"
    )
    android_rating: float | None = Field(
        default=None,
        description="Android Play Store rating (0-5)"
    )

    # Metadata
    category: str | None = Field(
        default=None,
        description="App category (e.g., 'utilities', 'health-fitness')"
    )
    business_model: str | None = Field(
        default=None,
        description="Business model: 'subscription', 'freemium', 'paid', 'ads'"
    )
    description: str | None = Field(
        default=None,
        description="Short app description"
    )
    is_mobile_app: bool = Field(
        default=True,
        description="True if this is a mobile app (not SaaS, e-commerce, etc.)"
    )
