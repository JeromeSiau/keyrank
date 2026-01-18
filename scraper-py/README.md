# Keyrank Scraper (Python)

Unified scraper for Google Play data and revenue marketplaces. Replaces the Node.js google-play-scraper with a custom Python implementation.

## Features

- **Google Play Scraper**: Search, app details, suggestions, top charts, categories, reviews
- **Revenue Scrapers**: whatsthe.app (RevenueCat-verified data)
- **FastAPI**: Async HTTP endpoints with automatic OpenAPI docs
- **No external dependencies**: Custom batchexecute parser (no google-play-scraper lib)

## Requirements

- Python 3.11+
- pip or uv

## Installation

```bash
cd scraper-py

# Using pip
pip install -e ".[dev]"

# Using uv (faster)
uv pip install -e ".[dev]"
```

## Running

```bash
# Development (with auto-reload)
python -m src.main

# Or with uvicorn directly
uvicorn src.main:app --host 0.0.0.0 --port 8001 --reload
```

The API runs on `http://localhost:8001` by default.

## Configuration

Create a `.env` file:

```bash
HOST=0.0.0.0
PORT=8001
DEBUG=true
```

## API Endpoints

### Health Check

```
GET /health
```

### Google Play

| Endpoint | Description |
|----------|-------------|
| `GET /search?term=spotify&num=10` | Search apps |
| `GET /app/{id}` | App details (e.g., `/app/com.spotify.music`) |
| `GET /suggestions/term/{term}` | Search suggestions (min 2 chars) |
| `GET /top?category=GAME&collection=top_free&num=50` | Top charts |
| `GET /categories` | List all categories |
| `GET /reviews/{id}?num=100` | App reviews |

### Revenue

| Endpoint | Description |
|----------|-------------|
| `GET /revenue/whatstheapp` | Scrape whatsthe.app revenue data |
| `GET /revenue/whatstheapp/raw` | Raw data (for debugging) |

## Running Tests

```bash
# Run all tests
pytest

# Run with verbose output
pytest -v

# Run specific test file
pytest tests/test_api.py

# Run specific test class
pytest tests/test_revenue.py::TestWhatsTheAppScraper
```

## Laravel Integration

The Laravel API already supports switching scrapers via environment variable.

### Switch from Node.js to Python

1. Stop the Node.js scraper (port 3001)
2. Start the Python scraper (port 8001)
3. Update `.env` in the Laravel `api/` directory:

```bash
# Before (Node.js)
GPLAY_SCRAPER_URL=http://localhost:3001

# After (Python)
GPLAY_SCRAPER_URL=http://localhost:8001
```

The API format is compatible - no code changes needed in Laravel.

### Verify Integration

```bash
# Test the scraper directly
curl http://localhost:8001/health
curl http://localhost:8001/search?term=spotify&num=3

# Test via Laravel
curl http://localhost:8000/api/gplay/search?term=spotify&num=3
```

## API Response Format

### Search Results

```json
{
  "term": "spotify",
  "results": [
    {
      "google_play_id": "com.spotify.music",
      "position": 1,
      "name": "Spotify: Music and Podcasts",
      "icon": "https://...",
      "developer": "Spotify AB",
      "score": 4.3,
      "free": true,
      "price": 0
    }
  ]
}
```

### Revenue Data

```json
{
  "success": true,
  "count": 50,
  "apps": [
    {
      "source_id": "app-name",
      "name": "App Name",
      "mrr": 10000,
      "monthly_revenue": 8000,
      "platform": "both",
      "apple_id": "123456789",
      "bundle_id": "com.example.app",
      "active_subscribers": 500,
      "revenue_verified": true,
      "credential_type": "revenuecat-verified"
    }
  ]
}
```

## Production Deployment

### Option 1: Systemd (recommended)

```bash
# Copy service file
sudo cp deploy/keyrank-scraper.service /etc/systemd/system/

# Reload systemd
sudo systemctl daemon-reload

# Enable and start
sudo systemctl enable keyrank-scraper
sudo systemctl start keyrank-scraper

# Check status
sudo systemctl status keyrank-scraper

# View logs
sudo journalctl -u keyrank-scraper -f
```

### Option 2: Supervisor

```bash
# Copy config
sudo cp deploy/supervisor.conf /etc/supervisor/conf.d/keyrank-scraper.conf

# Reload and start
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start keyrank-scraper

# Check status
sudo supervisorctl status keyrank-scraper
```

### Production Setup

```bash
# 1. Clone and setup on server
cd /var/www/keyrank
git clone <repo> scraper-py
cd scraper-py

# 2. Create virtual environment
python3.11 -m venv .venv
source .venv/bin/activate
pip install -e .

# 3. Create .env for production
cat > .env << EOF
HOST=0.0.0.0
PORT=8001
DEBUG=false
EOF

# 4. Test it works
uvicorn src.main:app --host 0.0.0.0 --port 8001

# 5. Install as service (see above)
```

### Nginx Reverse Proxy (optional)

```nginx
location /scraper/ {
    proxy_pass http://127.0.0.1:8001/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

### Revenue Sync CRON

Add to Laravel scheduler (`app/Console/Kernel.php`):

```php
$schedule->command('revenue:sync')->dailyAt('06:00');
```

Or use crontab directly:

```cron
0 6 * * * cd /var/www/keyrank/api && php artisan revenue:sync >> /var/log/keyrank-revenue.log 2>&1
```

## Project Structure

```
scraper-py/
├── src/
│   ├── core/           # Configuration
│   ├── gplay/          # Google Play scraper
│   │   ├── parser.py   # Batchexecute response parser
│   │   ├── router.py   # API endpoints
│   │   └── scraper.py  # HTTP client + data extraction
│   ├── revenue/        # Revenue scrapers
│   │   ├── models.py   # RevenueApp, Platform enums
│   │   ├── router.py   # API endpoints
│   │   └── whatstheapp.py  # whatsthe.app scraper
│   └── main.py         # FastAPI app entry point
├── tests/
│   ├── test_api.py         # Integration tests
│   ├── test_gplay_parser.py # Parser unit tests
│   └── test_revenue.py     # Revenue scraper tests
├── deploy/
│   ├── keyrank-scraper.service  # Systemd unit file
│   └── supervisor.conf          # Supervisor config
├── pyproject.toml
└── README.md
```
