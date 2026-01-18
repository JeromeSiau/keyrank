"""Integration tests for API endpoints."""

import pytest
from fastapi.testclient import TestClient

from src.main import app


@pytest.fixture
def client():
    """Create test client."""
    return TestClient(app)


class TestHealthEndpoint:
    """Tests for health check endpoint."""

    def test_health_returns_ok(self, client):
        response = client.get("/health")
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "ok"
        assert "timestamp" in data


class TestGPlayEndpoints:
    """Tests for Google Play endpoints."""

    def test_search_requires_term(self, client):
        response = client.get("/search")
        assert response.status_code == 422  # Validation error

    def test_search_with_term(self, client):
        response = client.get("/search?term=spotify&num=3")
        assert response.status_code == 200
        data = response.json()
        assert "results" in data
        assert isinstance(data["results"], list)

    def test_search_results_have_position(self, client):
        response = client.get("/search?term=music&num=3")
        assert response.status_code == 200
        data = response.json()
        if data["results"]:
            first = data["results"][0]
            assert "position" in first
            assert first["position"] == 1

    def test_app_details(self, client):
        response = client.get("/app/com.spotify.music")
        assert response.status_code == 200
        data = response.json()
        assert data["google_play_id"] == "com.spotify.music"
        assert "name" in data
        assert "developer" in data

    def test_app_not_found(self, client):
        response = client.get("/app/com.nonexistent.app.12345")
        assert response.status_code == 404

    def test_suggestions_requires_min_length(self, client):
        response = client.get("/suggestions/term/a")
        assert response.status_code == 400

    def test_suggestions_returns_list(self, client):
        response = client.get("/suggestions/term/fitness")
        assert response.status_code == 200
        data = response.json()
        assert "suggestions" in data
        assert isinstance(data["suggestions"], list)

    def test_top_charts(self, client):
        response = client.get("/top?category=GAME&collection=top_free&num=5")
        assert response.status_code == 200
        data = response.json()
        assert "results" in data
        assert isinstance(data["results"], list)
        if data["results"]:
            first = data["results"][0]
            assert "google_play_id" in first
            assert "position" in first

    def test_categories(self, client):
        response = client.get("/categories")
        assert response.status_code == 200
        data = response.json()
        assert "categories" in data
        assert len(data["categories"]) > 0

    def test_reviews(self, client):
        response = client.get("/reviews/com.spotify.music?num=5")
        assert response.status_code == 200
        data = response.json()
        assert "reviews" in data
        assert isinstance(data["reviews"], list)


class TestRevenueEndpoints:
    """Tests for revenue scraping endpoints."""

    def test_whatstheapp_scrape(self, client):
        response = client.get("/revenue/whatstheapp")
        assert response.status_code == 200
        data = response.json()
        assert data["success"] is True
        assert "count" in data
        assert "apps" in data
        assert isinstance(data["apps"], list)

    def test_whatstheapp_apps_have_required_fields(self, client):
        response = client.get("/revenue/whatstheapp")
        assert response.status_code == 200
        data = response.json()
        if data["apps"]:
            app = data["apps"][0]
            assert "name" in app
            assert "mrr" in app or app["mrr"] is None
            assert "platform" in app
