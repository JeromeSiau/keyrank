"""Tests for revenue scrapers."""

import pytest

from src.revenue.models import RevenueApp, Platform, CredentialType
from src.revenue.whatstheapp import WhatsTheAppScraper


class TestRevenueAppModel:
    """Tests for RevenueApp model."""

    def test_from_whatstheapp_basic(self):
        data = {
            "id": "test-app",
            "name": "Test App",
            "mrr": 10000,
            "revenue": 8000,
            "appStoreUrl": "https://apps.apple.com/app/id123456789",
            "googlePlayUrl": "https://play.google.com/store/apps/details?id=com.test.app",
            "credential_type": "revenuecat-verified",
        }
        app = RevenueApp.from_whatstheapp(data)

        assert app.source == "whatstheapp"
        assert app.source_id == "test-app"
        assert app.app_name == "Test App"
        assert app.mrr_cents == 1000000  # 10000 * 100
        assert app.monthly_revenue_cents == 800000
        assert app.apple_id == "123456789"
        assert app.bundle_id == "com.test.app"
        assert app.platform == Platform.BOTH
        assert app.credential_type == CredentialType.REVENUECAT_VERIFIED

    def test_from_whatstheapp_ios_only(self):
        data = {
            "id": "ios-app",
            "name": "iOS App",
            "mrr": 5000,
            "revenue": 4000,
            "appStoreUrl": "https://apps.apple.com/app/id999999",
        }
        app = RevenueApp.from_whatstheapp(data)

        assert app.platform == Platform.IOS
        assert app.apple_id == "999999"
        assert app.bundle_id is None

    def test_from_whatstheapp_android_only(self):
        data = {
            "id": "android-app",
            "name": "Android App",
            "mrr": 3000,
            "revenue": 2500,
            "googlePlayUrl": "https://play.google.com/store/apps/details?id=com.android.app",
        }
        app = RevenueApp.from_whatstheapp(data)

        assert app.platform == Platform.ANDROID
        assert app.apple_id is None
        assert app.bundle_id == "com.android.app"

    def test_from_whatstheapp_with_subscribers(self):
        data = {
            "id": "sub-app",
            "name": "Sub App",
            "mrr": 20000,
            "revenue": 18000,
            "active_subscriptions": 500,
            "active_trials": 50,
            "downloads_28d": 1000,
            "new_customers": 200,
        }
        app = RevenueApp.from_whatstheapp(data)

        assert app.active_subscribers == 500
        assert app.active_trials == 50
        assert app.monthly_downloads == 1000
        assert app.new_customers == 200


class TestWhatsTheAppScraper:
    """Tests for WhatsTheApp scraper."""

    def test_parse_number(self):
        scraper = WhatsTheAppScraper()
        assert scraper._parse_number("123,456") == 123456
        assert scraper._parse_number("$1,000") == 1000
        assert scraper._parse_number("500") == 500
        assert scraper._parse_number("") == 0

    def test_parse_table_row_extracts_name(self):
        scraper = WhatsTheAppScraper()
        row_html = '''
        <td><div class="font-medium text-primary">Test App Name</div></td>
        <td><span>$10,000</span></td>
        <td><span>$12,000</span></td>
        '''
        result = scraper._parse_table_row(row_html)
        assert result["name"] == "Test App Name"

    def test_parse_table_row_extracts_store_urls(self):
        scraper = WhatsTheAppScraper()
        row_html = '''
        <td>
            <div class="font-medium">App</div>
            <a href="https://apps.apple.com/app/id123456">iOS</a>
            <a href="https://play.google.com/store/apps/details?id=com.test">Android</a>
        </td>
        '''
        result = scraper._parse_table_row(row_html)
        assert result["appStoreUrl"] == "https://apps.apple.com/app/id123456"
        assert result["apple_id"] == "123456"
        assert result["googlePlayUrl"] == "https://play.google.com/store/apps/details?id=com.test"
        assert result["bundle_id"] == "com.test"

    def test_parse_table_row_extracts_money(self):
        scraper = WhatsTheAppScraper()
        row_html = '''
        <td><div class="font-medium">App</div></td>
        <td><span>$50,000</span></td>
        <td><span>$60,000</span></td>
        '''
        result = scraper._parse_table_row(row_html)
        assert result["revenue"] == 50000
        assert result["mrr"] == 60000


class TestWhatsTheAppIntegration:
    """Integration tests for WhatsTheApp scraper."""

    @pytest.mark.asyncio
    async def test_scrape_all_returns_apps(self):
        scraper = WhatsTheAppScraper()
        apps = await scraper.scrape_all()

        assert len(apps) > 0
        assert all(isinstance(app, RevenueApp) for app in apps)

    @pytest.mark.asyncio
    async def test_scraped_apps_have_revenue_data(self):
        scraper = WhatsTheAppScraper()
        apps = await scraper.scrape_all()

        # At least some apps should have MRR data
        apps_with_mrr = [a for a in apps if a.mrr_cents and a.mrr_cents > 0]
        assert len(apps_with_mrr) > 0

    @pytest.mark.asyncio
    async def test_scraped_apps_have_names(self):
        scraper = WhatsTheAppScraper()
        apps = await scraper.scrape_all()

        assert all(app.app_name for app in apps)
