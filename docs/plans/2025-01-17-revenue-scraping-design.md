# Revenue Data Scraping - Design Document

## Objectif

Collecter des données de revenus réels d'applications mobiles depuis plusieurs sources publiques pour :
1. Entraîner un modèle de corrélation revenus ↔ métriques ASO
2. Alimenter une future feature "Revenue Insights" pour les utilisateurs

## Sources de données (Tier 1)

| Source | Volume estimé | Données clés | Complexité scraping |
|--------|---------------|--------------|---------------------|
| whatsthe.app | ~430 apps | Revenue vérifié RevenueCat | ⭐ Facile (SSR) |
| Flippa | ~1000+ apps | Revenue, profit, traffic | ⭐⭐ Moyen (API) |
| Acquire.com | ~200+ apps | Metrics vérifiées | ⭐⭐ Moyen (auth dispo) |
| AppBusinessBrokers | ~50 apps | Revenue, profit, MRR | ⭐ Facile (HTML) |
| Microns | ~100 apps | Annual revenue | ⭐ Facile (HTML) |

**Volume total estimé : 1800-2500 apps (iOS + Android) avec revenus réels**

---

## Données à collecter

### Données primaires (depuis les sources)

```
IDENTIFICATION
├── source_id          # ID unique sur la source
├── source_name        # "whatstheapp", "flippa", etc.
├── app_name           # Nom de l'app
├── app_store_url      # URL App Store/Play Store (si disponible)
├── apple_id           # ID Apple (extrait de l'URL)
├── bundle_id          # Bundle ID Android (si dispo)
└── platform           # "ios", "android", "both"

FINANCIALS
├── monthly_revenue    # MRR
├── annual_revenue     # ARR
├── monthly_profit     # Profit mensuel
├── annual_profit      # Profit annuel
├── asking_price       # Prix de vente demandé
├── revenue_verified   # Boolean - vérifié par la plateforme
└── currency           # USD par défaut

GROWTH & USERS
├── monthly_downloads  # Downloads/mois
├── total_downloads    # Downloads totaux
├── active_users       # DAU ou MAU
├── subscribers        # Abonnés payants
├── churn_rate         # Taux de churn (si dispo)
└── growth_rate        # Croissance MoM (si dispo)

METADATA
├── category           # Catégorie app store
├── business_model     # "subscription", "freemium", "paid", "ads"
├── age_months         # Âge de l'app en mois
├── listing_date       # Date de mise en vente
└── scraped_at         # Date du scraping
```

### Enrichissement automatique

Quand on matche un `apple_id` ou `bundle_id` :

1. **Vérifier** si l'app existe dans notre table `apps`
2. **Créer l'app** si elle n'existe pas (via iTunes/Play Store lookup)
3. **Linker** `revenue_apps.matched_app_id` → `apps.id`

Les collectors existants (RatingsCollector, ReviewsCollector, RankingsCollector) enrichissent automatiquement l'app liée. Pas besoin de pipeline d'enrichissement custom.

---

## Architecture technique

### Stack scraping

**Approche LLM-first** : Utilisation de LiteLLM + OpenRouter (GPT-5-nano) pour l'extraction structurée.

```
┌─────────────────────────────────────────────────────────┐
│                    SCRAPING LAYER                        │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │                    HTTPX                           │  │
│  │            (fetch HTML pages)                      │  │
│  └──────────────────────┬───────────────────────────┘  │
│                         │                               │
│  ┌──────────────────────▼───────────────────────────┐  │
│  │              LLMExtractor                          │  │
│  │   (LiteLLM + OpenRouter/GPT-5-nano)               │  │
│  │   - Clean HTML (remove scripts/styles)             │  │
│  │   - Extract structured data via LLM               │  │
│  │   - Pydantic schema validation                    │  │
│  └──────────────────────┬───────────────────────────┘  │
│                         │                               │
│              ┌──────────▼──────────┐                   │
│              │   ExtractedApp      │                   │
│              │   (Pydantic model)  │                   │
│              └──────────┬──────────┘                   │
│                         │                               │
└─────────────────────────┼───────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│                   ENRICHMENT LAYER                       │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  iTunes API  │  │  Our DB      │  │  Play Store  │  │
│  │  (ratings)   │  │  (rankings)  │  │  (if needed) │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│                                                          │
└─────────────────────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│                    STORAGE LAYER                         │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Laravel API ──► revenue_benchmarks table               │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### Support Proxy

Configuration centralisée pour tous les scrapers :

```python
# src/core/proxy.py
from dataclasses import dataclass
from itertools import cycle
import httpx

@dataclass
class ProxyConfig:
    url: str
    country: str | None = None  # Pour geo-targeting
    weight: int = 1  # Pour rotation pondérée

class ProxyRouter:
    def __init__(self, proxies: list[ProxyConfig]):
        self.proxies = proxies
        self._cycle = cycle(proxies)

    def get_next(self, country: str | None = None) -> str | None:
        """Retourne le prochain proxy, filtré par pays si spécifié"""
        if not self.proxies:
            return None

        if country:
            matching = [p for p in self.proxies if p.country == country]
            if matching:
                return next(cycle(matching)).url

        return next(self._cycle).url

    def get_httpx_client(self, country: str | None = None) -> httpx.AsyncClient:
        """Client HTTPX avec proxy configuré"""
        proxy = self.get_next(country)
        return httpx.AsyncClient(proxy=proxy, timeout=30.0)

    def get_playwright_proxy(self, country: str | None = None) -> dict | None:
        """Config proxy pour Playwright"""
        proxy = self.get_next(country)
        if not proxy:
            return None
        return {"server": proxy}
```

**Configuration via .env :**

```env
# Format: url|country (country optionnel)
PROXY_LIST=http://user:pass@proxy1.example.com:8080|us,http://user:pass@proxy2.example.com:8080|fr,http://user:pass@proxy3.example.com:8080
```

**Utilisation avec Playwright :**

```python
async def scrape_with_proxy(proxy_router: ProxyRouter):
    async with async_playwright() as p:
        browser = await p.chromium.launch(
            proxy=proxy_router.get_playwright_proxy()
        )
        # ...
```

**Utilisation avec Crawl4AI :**

```python
from crawl4ai import AsyncWebCrawler, BrowserConfig

browser_config = BrowserConfig(
    proxy=proxy_router.get_next(),
    headless=True
)

async with AsyncWebCrawler(config=browser_config) as crawler:
    # ...
```

**Providers recommandés :**
- [Bright Data](https://brightdata.com/) - Résidentiel, datacenter, mobile
- [Oxylabs](https://oxylabs.io/) - Bon pour e-commerce/marketplaces
- [ScraperAPI](https://www.scraperapi.com/) - Simple, rotation auto

---

### Migration Google Play Scraper

Le scraper Node.js existant (`scraper/`) sera migré en Python pour unifier le stack.

**Mapping des routes :**

| Route Node | Route Python | Librairie |
|------------|--------------|-----------|
| GET /app/:appId | GET /gplay/app/{app_id} | google-play-scraper |
| GET /search | GET /gplay/search | google-play-scraper |
| POST /search/rankings | POST /gplay/rankings | google-play-scraper |
| GET /reviews/:appId | GET /gplay/reviews/{app_id} | google-play-scraper |
| GET /suggestions | GET /gplay/suggestions | google-play-scraper |
| GET /top | GET /gplay/top | google-play-scraper |
| GET /categories | GET /gplay/categories | google-play-scraper |

**Structure Python :**

```python
# src/gplay/router.py
from fastapi import APIRouter
from google_play_scraper import app, search, reviews, Sort

router = APIRouter(prefix="/gplay", tags=["Google Play"])

@router.get("/app/{app_id}")
async def get_app(app_id: str, country: str = "us", lang: str = "en"):
    result = app(app_id, country=country, lang=lang)
    return {
        "google_play_id": result["appId"],
        "name": result["title"],
        "icon_url": result["icon"],
        "developer": result["developer"],
        "rating": result["score"],
        "rating_count": result["ratings"],
        # ...
    }

@router.get("/search")
async def search_apps(term: str, country: str = "us", lang: str = "en", num: int = 50):
    results = search(term, country=country, lang=lang, n_hits=min(num, 250))
    return {"results": [format_app(app) for app in results]}
```

---

### Approche par source

#### 1. whatsthe.app (Crawl4AI)

- **Méthode** : HTML parsing avec LLM extraction
- **Particularité** : Next.js SSR, données dans le HTML initial
- **Fréquence** : Hebdomadaire (données mises à jour "hourly" sur le site)

```python
schema = {
    "app_name": "string",
    "category": "string",
    "monthly_revenue": "number",
    "mrr": "number",
    "asking_price": "number",
    "app_store_url": "string"
}
```

#### 2. Flippa (Playwright + API intercept)

- **Méthode** : Intercepter les requêtes XHR vers l'API interne
- **Particularité** : Rails + Turbo, données chargées dynamiquement
- **Filtres** : `property_type=app` pour n'avoir que les apps
- **Pagination** : Gérer la pagination API

```python
async def intercept_flippa():
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        page = await browser.new_page()

        listings = []

        async def handle_response(response):
            if "/api/listings" in response.url:
                data = await response.json()
                listings.extend(data["listings"])

        page.on("response", handle_response)
        await page.goto("https://flippa.com/search?filter[property_type]=app")
        # Scroll pour charger plus
```

#### 3. Acquire.com (Playwright + Auth)

- **Méthode** : Login requis, puis scraping SPA
- **Particularité** : Données vérifiées, haute qualité
- **Risque** : ToS potentiellement restrictifs
- **Alternative** : Scraper uniquement les listings publics (preview)

#### 4. AppBusinessBrokers (Requests + BeautifulSoup)

- **Méthode** : Simple HTML parsing
- **Particularité** : Site statique, structure simple
- **Volume** : Faible mais haute qualité

```python
def scrape_appbusinessbrokers():
    response = requests.get("https://www.appbusinessbrokers.com/")
    soup = BeautifulSoup(response.text, "html.parser")

    for listing in soup.select(".listing-card"):
        yield {
            "app_name": listing.select_one(".title").text,
            "revenue": parse_money(listing.select_one(".revenue").text),
            "profit": parse_money(listing.select_one(".profit").text),
            "price": parse_money(listing.select_one(".price").text),
        }
```

#### 5. Microns (Crawl4AI)

- **Méthode** : HTML parsing
- **Particularité** : Structure simple, 2 métriques seulement
- **Filtre** : Catégories "Mobile app" uniquement

#### 6. Acquire.com (Playwright + Auth)

- **Méthode** : Session authentifiée + scraping SPA
- **Particularité** : Données vérifiées, haute qualité, métriques détaillées
- **Auth** : Login initial, cookies persistés pour runs suivants
- **Rate limit** : 2-3 sec entre requêtes (préserver le compte)

```python
async def scrape_acquire(email: str, password: str):
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        context = await browser.new_context()

        # Charger cookies si existants
        if Path("acquire_cookies.json").exists():
            cookies = json.loads(Path("acquire_cookies.json").read_text())
            await context.add_cookies(cookies)

        page = await context.new_page()
        await page.goto("https://app.acquire.com/")

        # Login si nécessaire
        if "login" in page.url:
            await page.fill('input[name="email"]', email)
            await page.fill('input[name="password"]', password)
            await page.click('button[type="submit"]')
            await page.wait_for_url("**/dashboard**")

            # Sauvegarder cookies
            cookies = await context.cookies()
            Path("acquire_cookies.json").write_text(json.dumps(cookies))

        # Navigate to mobile apps listings
        await page.goto("https://app.acquire.com/search?category=mobile-apps")
        # ... extract listings
```

---

## Schéma base de données

### Table `revenue_apps` ✅ (implémentée)

```sql
CREATE TABLE revenue_apps (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    -- Identification
    source VARCHAR(50) NOT NULL,           -- 'whatstheapp', 'flippa', etc.
    source_id VARCHAR(255) NOT NULL,       -- ID unique sur la source
    app_name VARCHAR(255) NOT NULL,

    -- App Store matching
    apple_id VARCHAR(50) NULL,             -- Pour matcher avec notre DB
    bundle_id VARCHAR(255) NULL,           -- Android bundle
    app_store_url VARCHAR(500) NULL,
    play_store_url VARCHAR(500) NULL,
    platform ENUM('ios', 'android', 'both') DEFAULT 'ios',

    -- Financials (stockés en cents pour précision)
    mrr_cents BIGINT NULL,
    monthly_revenue_cents BIGINT NULL,
    arr_cents BIGINT NULL,
    asking_price_cents BIGINT NULL,
    revenue_verified BOOLEAN DEFAULT FALSE,
    credential_type VARCHAR(50) DEFAULT 'unknown',

    -- Users & Growth
    monthly_downloads INT NULL,
    active_subscribers INT NULL,
    active_trials INT NULL,
    new_customers INT NULL,

    -- Metadata
    business_model ENUM('subscription', 'one_time', 'freemium', 'free', 'unknown') NULL,
    is_for_sale BOOLEAN DEFAULT FALSE,
    description TEXT NULL,
    logo_url VARCHAR(500) NULL,

    -- Linking (enrichissement via apps liée)
    matched_app_id BIGINT NULL,            -- FK vers notre table apps

    -- Timestamps
    scraped_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Indexes
    UNIQUE KEY unique_source_listing (source, source_id),
    INDEX idx_apple_id (apple_id),
    INDEX idx_bundle_id (bundle_id),
    INDEX idx_mrr (mrr_cents),
    INDEX idx_matched_app (matched_app_id)
);
```

> **Note:** Les données ASO (rating, reviews, rankings) viennent de l'app liée via `matched_app_id`. Pas de duplication.

### Table `revenue_scrape_logs` (optionnel, future)

Pour le monitoring des runs de scraping. Pas prioritaire.

```sql
CREATE TABLE revenue_scrape_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    source VARCHAR(50) NOT NULL,
    started_at TIMESTAMP NOT NULL,
    completed_at TIMESTAMP NULL,
    status ENUM('running', 'success', 'failed') DEFAULT 'running',
    listings_found INT DEFAULT 0,
    listings_new INT DEFAULT 0,
    listings_updated INT DEFAULT 0,
    error_message TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## Pipeline de matching

### Extraction App Store ID

```python
def extract_apple_id(url: str) -> str | None:
    """Extrait l'Apple ID depuis une URL App Store"""
    # https://apps.apple.com/us/app/app-name/id123456789
    match = re.search(r'/id(\d+)', url)
    return match.group(1) if match else None
```

### Auto-création et linking

Après chaque sync, un job Laravel :

1. Cherche les `revenue_apps` sans `matched_app_id`
2. Pour chaque app avec `apple_id` ou `bundle_id` :
   - Vérifie si l'app existe dans `apps`
   - Si non, la crée via iTunes/Play Store lookup
   - Met à jour `matched_app_id`

Les collectors existants enrichissent automatiquement les apps liées.

---

## Modèle de corrélation (future)

### Variables features

| Variable | Source | Type |
|----------|--------|------|
| `rating` | iTunes/enriched | Continuous |
| `rating_count` | iTunes/enriched | Continuous (log) |
| `category_rank` | Our DB | Continuous (log) |
| `category` | Scraped/enriched | Categorical |
| `platform` | Scraped | Categorical |
| `app_age_months` | Scraped | Continuous |
| `business_model` | Scraped | Categorical |

### Target variable

- `monthly_revenue` (log-transformed for normalization)

### Approches ML envisagées

1. **Régression linéaire** - Baseline simple
2. **Random Forest** - Capture non-linéarités
3. **Gradient Boosting** - Meilleure performance attendue
4. **Formules par catégorie** - Différents coefficients par vertical

---

## Considérations légales & éthiques

### Ce qu'on fait

- Collecte de données **publiquement accessibles**
- Pas de contournement de protection (pas de login sauf Acquire)
- Pas de surcharge des serveurs (rate limiting)
- Usage interne pour R&D

### Précautions

- [ ] Vérifier les ToS de chaque source
- [ ] Implémenter un rate limiter (1 req/sec min)
- [ ] User-Agent honnête identifiant notre bot
- [ ] Respecter robots.txt
- [ ] Ne pas redistribuer les données brutes

### Acquire.com

Acquire requiert un login → **credentials disponibles**, on l'inclut dans le scraping.

Approche :
1. Playwright avec session authentifiée
2. Stocker les cookies pour éviter re-login à chaque run
3. Rate limiting strict (compte à préserver)

---

## Plan d'implémentation

### Phase 0 : Migration Google Play Scraper ✅

- [x] Créer projet Python `scraper-py/` avec FastAPI
- [x] Custom batchexecute parser (pas de lib externe)
- [x] Migrer les 7 routes existantes
- [x] Tester la parité avec le scraper Node
- [x] Mettre à jour les appels depuis Laravel
- [x] Archiver `scraper/` (Node)

### Phase 1 : Infrastructure ✅

- [x] Créer migration Laravel `revenue_apps`
- [x] Setup proxy router avec rotation (`src/core/proxy.py`)
- [x] Créer les modèles Pydantic de validation
- [x] Configurer .env avec proxies
- [x] CRON `revenue:sync` dans Laravel scheduler

### Phase 2 : Scrapers Marketplaces (en cours)

**Approche LLM** : Extraction via GPT-5-nano (OpenRouter) au lieu de regex.
Coût estimé : ~$0.04 pour 100 pages.

- [x] Scraper whatsthe.app (~430 apps, RevenueCat verified) - **LLM + sitemap**
- [x] Scraper AppBusinessBrokers (~60 apps) - **LLM + sitemap**
- [x] Scraper Flippa (~350 apps) - **LLM + Turbo Frame pagination**
- [x] Scraper Microns (~410 listings, ~20 mobile apps) - **LLM + sitemap**
- [ ] Scraper Acquire.com (~200 apps, auth + SPA)

### Phase 3 : Pipeline ✅

- [x] Job d'import des données scrapées vers Laravel
- [x] Extraction des Apple IDs depuis URLs
- [x] Auto-création des apps dans `apps` si matchées (`MatchRevenueAppsJob`)
- [x] Linking `revenue_apps.matched_app_id` → `apps.id`
- [x] **URL Skip Optimization** : éviter de retraiter les pages déjà scrappées
  - `source_url` ajouté à `revenue_apps` pour tracker les pages traitées
  - Table `revenue_skipped_urls` pour les pages non-mobile (SaaS, web apps, etc.)
  - Laravel envoie `skip_urls` au scraper Python (POST body)
  - Scrapers filtrent les URLs déjà connues avant l'extraction LLM
- [x] Table `revenue_scrape_logs` pour monitoring des runs de scraping

### Phase 4 : Analyse (future)

- [ ] Export dataset pour analyse
- [ ] Exploration corrélations
- [ ] Training modèle baseline
- [ ] Validation et itération

---

## Métriques de succès

| Métrique | Target |
|----------|--------|
| Apps collectées | > 1000 |
| Apps avec Apple ID | > 70% |
| Apps matchées avec notre DB | > 30% |
| Apps avec revenue + rating | > 500 |
| Corrélation R² baseline | > 0.3 |

---

## Décisions

| Question | Décision |
|----------|----------|
| Fréquence de scraping | **Hebdomadaire** - Les listings changent peu |
| Historisation | **Snapshot simple** - Dernier état uniquement, suffisant pour ML |
| Acquire.com | **Inclus** - Auth disponible |
| Scope platform | **iOS + Android** - Les deux dès le début |
| Stack | **Python** - Unifier avec migration du scraper Node existant |
| Proxies | **Oui** - Rotation avec support geo-targeting |
| Extraction | **LLM-first** - GPT-5-nano via OpenRouter (~$0.04/100 pages) |
| Provider LLM | **OpenRouter** - Accès unifié aux modèles, même clé que Laravel |
