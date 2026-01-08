# Android Support Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add Google Play Store support enabling users to track both iOS and Android apps in a unified dashboard.

**Architecture:** Node.js micro-service (Crawlee + google-play-scraper) called by Laravel API via HTTP. Unified app model with `apple_id` + `google_play_id`. Platform tabs in Flutter UI.

**Tech Stack:** Node.js, Express, Crawlee, google-play-scraper, Laravel, Flutter/Riverpod

---

## Phase 1: Node.js Micro-service

### Task 1.1: Initialize Node.js Project

**Files:**
- Create: `scraper/package.json`
- Create: `scraper/.gitignore`

**Step 1: Create directory and initialize project**

```bash
mkdir -p scraper && cd scraper
npm init -y
```

**Step 2: Install dependencies**

```bash
npm install express google-play-scraper crawlee dotenv cors
npm install -D typescript @types/node @types/express ts-node nodemon
```

**Step 3: Create package.json scripts**

Edit `scraper/package.json`:
```json
{
  "name": "gplay-scraper",
  "version": "1.0.0",
  "scripts": {
    "dev": "nodemon src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js"
  },
  "dependencies": {
    "cors": "^2.8.5",
    "crawlee": "^3.0.0",
    "dotenv": "^16.0.0",
    "express": "^4.18.0",
    "google-play-scraper": "^9.0.0"
  },
  "devDependencies": {
    "@types/cors": "^2.8.0",
    "@types/express": "^4.17.0",
    "@types/node": "^20.0.0",
    "nodemon": "^3.0.0",
    "ts-node": "^10.0.0",
    "typescript": "^5.0.0"
  }
}
```

**Step 4: Create tsconfig.json**

Create `scraper/tsconfig.json`:
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

**Step 5: Create .gitignore**

Create `scraper/.gitignore`:
```
node_modules/
dist/
.env
```

**Step 6: Commit**

```bash
git add scraper/
git commit -m "feat: initialize Node.js scraper project"
```

---

### Task 1.2: Create Express Server with Health Check

**Files:**
- Create: `scraper/src/index.ts`

**Step 1: Create server entry point**

Create `scraper/src/index.ts`:
```typescript
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.listen(PORT, () => {
  console.log(`Google Play scraper running on port ${PORT}`);
});
```

**Step 2: Test the server**

```bash
cd scraper && npm run dev
# In another terminal:
curl http://localhost:3001/health
```

Expected: `{"status":"ok","timestamp":"..."}`

**Step 3: Commit**

```bash
git add scraper/src/
git commit -m "feat: add Express server with health check"
```

---

### Task 1.3: Implement App Search Endpoint

**Files:**
- Create: `scraper/src/routes/search.ts`
- Modify: `scraper/src/index.ts`

**Step 1: Create search route**

Create `scraper/src/routes/search.ts`:
```typescript
import { Router } from 'express';
import gplay from 'google-play-scraper';

const router = Router();

interface SearchQuery {
  term: string;
  country?: string;
  lang?: string;
  num?: number;
}

router.get('/', async (req, res) => {
  try {
    const { term, country = 'us', lang = 'en', num = 50 } = req.query as unknown as SearchQuery;

    if (!term || term.length < 2) {
      return res.status(400).json({ error: 'Search term must be at least 2 characters' });
    }

    const results = await gplay.search({
      term,
      country,
      lang,
      num: Math.min(Number(num), 250),
    });

    const formatted = results.map((app, index) => ({
      position: index + 1,
      google_play_id: app.appId,
      name: app.title,
      icon_url: app.icon,
      developer: app.developer,
      rating: app.score,
      rating_count: app.ratings,
      price: app.price,
      free: app.free,
    }));

    res.json({ results: formatted });
  } catch (error) {
    console.error('Search error:', error);
    res.status(500).json({ error: 'Failed to search apps' });
  }
});

export default router;
```

**Step 2: Register route in index.ts**

Modify `scraper/src/index.ts` to add:
```typescript
import searchRouter from './routes/search';

// After app.use(express.json());
app.use('/search', searchRouter);
```

**Step 3: Test the endpoint**

```bash
curl "http://localhost:3001/search?term=spotify&country=fr&num=10"
```

Expected: JSON array with apps, each having `position`, `google_play_id`, `name`, etc.

**Step 4: Commit**

```bash
git add scraper/src/
git commit -m "feat: add app search endpoint"
```

---

### Task 1.4: Implement App Details Endpoint

**Files:**
- Create: `scraper/src/routes/app.ts`
- Modify: `scraper/src/index.ts`

**Step 1: Create app route**

Create `scraper/src/routes/app.ts`:
```typescript
import { Router } from 'express';
import gplay from 'google-play-scraper';

const router = Router();

router.get('/:appId', async (req, res) => {
  try {
    const { appId } = req.params;
    const { country = 'us', lang = 'en' } = req.query;

    const app = await gplay.app({
      appId,
      country: country as string,
      lang: lang as string,
    });

    res.json({
      google_play_id: app.appId,
      name: app.title,
      icon_url: app.icon,
      developer: app.developer,
      developer_id: app.developerId,
      description: app.description,
      rating: app.score,
      rating_count: app.ratings,
      reviews_count: app.reviews,
      price: app.price,
      free: app.free,
      currency: app.currency,
      version: app.version,
      updated: app.updated,
      genre: app.genre,
      genre_id: app.genreId,
      screenshots: app.screenshots,
      store_url: app.url,
    });
  } catch (error) {
    console.error('App details error:', error);
    res.status(404).json({ error: 'App not found' });
  }
});

export default router;
```

**Step 2: Register route**

Add to `scraper/src/index.ts`:
```typescript
import appRouter from './routes/app';

app.use('/app', appRouter);
```

**Step 3: Test**

```bash
curl "http://localhost:3001/app/com.spotify.music?country=fr"
```

**Step 4: Commit**

```bash
git add scraper/src/
git commit -m "feat: add app details endpoint"
```

---

### Task 1.5: Implement Reviews Endpoint

**Files:**
- Create: `scraper/src/routes/reviews.ts`
- Modify: `scraper/src/index.ts`

**Step 1: Create reviews route**

Create `scraper/src/routes/reviews.ts`:
```typescript
import { Router } from 'express';
import gplay from 'google-play-scraper';

const router = Router();

router.get('/:appId', async (req, res) => {
  try {
    const { appId } = req.params;
    const { country = 'us', lang = 'en', sort = 'newest', num = 100 } = req.query;

    const sortMap: Record<string, any> = {
      newest: gplay.sort.NEWEST,
      rating: gplay.sort.RATING,
      helpfulness: gplay.sort.HELPFULNESS,
    };

    const reviews = await gplay.reviews({
      appId,
      country: country as string,
      lang: lang as string,
      sort: sortMap[sort as string] || gplay.sort.NEWEST,
      num: Math.min(Number(num), 500),
    });

    const formatted = reviews.data.map((review) => ({
      review_id: review.id,
      author: review.userName,
      rating: review.score,
      title: review.title || null,
      content: review.text,
      version: review.version,
      reviewed_at: review.date,
      thumbs_up: review.thumbsUp,
      reply_date: review.replyDate,
      reply_text: review.replyText,
    }));

    res.json({ reviews: formatted });
  } catch (error) {
    console.error('Reviews error:', error);
    res.status(500).json({ error: 'Failed to fetch reviews' });
  }
});

export default router;
```

**Step 2: Register route**

Add to `scraper/src/index.ts`:
```typescript
import reviewsRouter from './routes/reviews';

app.use('/reviews', reviewsRouter);
```

**Step 3: Test**

```bash
curl "http://localhost:3001/reviews/com.spotify.music?country=fr&num=10"
```

**Step 4: Commit**

```bash
git add scraper/src/
git commit -m "feat: add reviews endpoint"
```

---

### Task 1.6: Implement Batch Rankings Endpoint

**Files:**
- Modify: `scraper/src/routes/search.ts`

**Step 1: Add batch rankings endpoint**

Add to `scraper/src/routes/search.ts`:
```typescript
router.post('/rankings', async (req, res) => {
  try {
    const { app_id, keywords, country = 'us', lang = 'en' } = req.body;

    if (!app_id || !keywords || !Array.isArray(keywords)) {
      return res.status(400).json({ error: 'app_id and keywords array required' });
    }

    const rankings: Record<string, number | null> = {};

    for (const keyword of keywords) {
      try {
        const results = await gplay.search({
          term: keyword,
          country,
          lang,
          num: 250,
        });

        const position = results.findIndex((app) => app.appId === app_id);
        rankings[keyword] = position >= 0 ? position + 1 : null;

        // Rate limiting delay
        await new Promise((resolve) => setTimeout(resolve, 200));
      } catch (error) {
        console.error(`Error searching keyword "${keyword}":`, error);
        rankings[keyword] = null;
      }
    }

    res.json({ app_id, country, rankings });
  } catch (error) {
    console.error('Rankings error:', error);
    res.status(500).json({ error: 'Failed to fetch rankings' });
  }
});
```

**Step 2: Test**

```bash
curl -X POST http://localhost:3001/search/rankings \
  -H "Content-Type: application/json" \
  -d '{"app_id":"com.spotify.music","keywords":["music","streaming"],"country":"fr"}'
```

**Step 3: Commit**

```bash
git add scraper/src/
git commit -m "feat: add batch rankings endpoint"
```

---

### Task 1.7: Add Dockerfile

**Files:**
- Create: `scraper/Dockerfile`
- Create: `scraper/.dockerignore`

**Step 1: Create Dockerfile**

Create `scraper/Dockerfile`:
```dockerfile
FROM node:20-slim

# Install Chromium for Crawlee (if needed later)
RUN apt-get update && apt-get install -y \
    chromium \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY dist/ ./dist/

ENV PORT=3001
EXPOSE 3001

CMD ["node", "dist/index.js"]
```

**Step 2: Create .dockerignore**

Create `scraper/.dockerignore`:
```
node_modules
src
*.ts
.env
```

**Step 3: Build and test**

```bash
cd scraper
npm run build
docker build -t gplay-scraper .
docker run -p 3001:3001 gplay-scraper
```

**Step 4: Commit**

```bash
git add scraper/
git commit -m "feat: add Docker support for scraper"
```

---

## Phase 2: Database Migrations

### Task 2.1: Add Google Play Fields to Apps Table

**Files:**
- Create: `api/database/migrations/2026_01_08_100001_add_google_play_to_apps_table.php`

**Step 1: Create migration**

```bash
cd api && php artisan make:migration add_google_play_to_apps_table
```

**Step 2: Edit migration**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('apps', function (Blueprint $table) {
            $table->string('google_play_id', 150)->nullable()->after('apple_id');
            $table->string('google_icon_url', 500)->nullable()->after('icon_url');
            $table->decimal('google_rating', 2, 1)->nullable()->after('rating_count');
            $table->unsignedInteger('google_rating_count')->default(0)->after('google_rating');
            $table->timestamp('google_ratings_fetched_at')->nullable()->after('ratings_fetched_at');
            $table->timestamp('google_reviews_fetched_at')->nullable()->after('reviews_fetched_at');

            // Make apple_id nullable (app can be Android-only)
            $table->string('apple_id', 20)->nullable()->change();

            // Update unique constraint
            $table->unique(['user_id', 'google_play_id'], 'apps_user_google_unique');
        });
    }

    public function down(): void
    {
        Schema::table('apps', function (Blueprint $table) {
            $table->dropUnique('apps_user_google_unique');
            $table->dropColumn([
                'google_play_id',
                'google_icon_url',
                'google_rating',
                'google_rating_count',
                'google_ratings_fetched_at',
                'google_reviews_fetched_at',
            ]);
            $table->string('apple_id', 20)->nullable(false)->change();
        });
    }
};
```

**Step 3: Run migration**

```bash
php artisan migrate
```

**Step 4: Commit**

```bash
git add api/database/migrations/
git commit -m "feat: add Google Play fields to apps table"
```

---

### Task 2.2: Add Platform Column to Ratings Table

**Files:**
- Create: `api/database/migrations/2026_01_08_100002_add_platform_to_app_ratings_table.php`

**Step 1: Create migration**

```bash
php artisan make:migration add_platform_to_app_ratings_table
```

**Step 2: Edit migration**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('app_ratings', function (Blueprint $table) {
            $table->enum('platform', ['ios', 'android'])->default('ios')->after('app_id');

            // Update unique constraint to include platform
            $table->dropUnique(['app_id', 'country', 'recorded_at']);
            $table->unique(['app_id', 'platform', 'country', 'recorded_at']);
        });
    }

    public function down(): void
    {
        Schema::table('app_ratings', function (Blueprint $table) {
            $table->dropUnique(['app_id', 'platform', 'country', 'recorded_at']);
            $table->unique(['app_id', 'country', 'recorded_at']);
            $table->dropColumn('platform');
        });
    }
};
```

**Step 3: Run migration**

```bash
php artisan migrate
```

**Step 4: Commit**

```bash
git add api/database/migrations/
git commit -m "feat: add platform column to app_ratings"
```

---

### Task 2.3: Add Platform Column to Reviews Table

**Files:**
- Create: `api/database/migrations/2026_01_08_100003_add_platform_to_app_reviews_table.php`

**Step 1: Create migration**

```bash
php artisan make:migration add_platform_to_app_reviews_table
```

**Step 2: Edit migration**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('app_reviews', function (Blueprint $table) {
            $table->enum('platform', ['ios', 'android'])->default('ios')->after('app_id');

            $table->index(['app_id', 'platform', 'country']);
        });
    }

    public function down(): void
    {
        Schema::table('app_reviews', function (Blueprint $table) {
            $table->dropIndex(['app_id', 'platform', 'country']);
            $table->dropColumn('platform');
        });
    }
};
```

**Step 3: Run migration**

```bash
php artisan migrate
```

**Step 4: Commit**

```bash
git add api/database/migrations/
git commit -m "feat: add platform column to app_reviews"
```

---

### Task 2.4: Add Platform Column to Rankings Table

**Files:**
- Create: `api/database/migrations/2026_01_08_100004_add_platform_to_app_rankings_table.php`

**Step 1: Create migration**

```bash
php artisan make:migration add_platform_to_app_rankings_table
```

**Step 2: Edit migration**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('app_rankings', function (Blueprint $table) {
            $table->enum('platform', ['ios', 'android'])->default('ios')->after('app_id');

            // Update unique constraint
            $table->dropUnique(['app_id', 'keyword_id', 'recorded_at']);
            $table->unique(['app_id', 'platform', 'keyword_id', 'recorded_at']);
        });
    }

    public function down(): void
    {
        Schema::table('app_rankings', function (Blueprint $table) {
            $table->dropUnique(['app_id', 'platform', 'keyword_id', 'recorded_at']);
            $table->unique(['app_id', 'keyword_id', 'recorded_at']);
            $table->dropColumn('platform');
        });
    }
};
```

**Step 3: Run migration**

```bash
php artisan migrate
```

**Step 4: Commit**

```bash
git add api/database/migrations/
git commit -m "feat: add platform column to app_rankings"
```

---

## Phase 3: Laravel Backend Integration

### Task 3.1: Create GooglePlayService

**Files:**
- Create: `api/app/Services/GooglePlayService.php`

**Step 1: Create service**

Create `api/app/Services/GooglePlayService.php`:
```php
<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Cache;

class GooglePlayService
{
    private string $scraperUrl;

    public function __construct()
    {
        $this->scraperUrl = config('services.gplay_scraper.url', 'http://localhost:3001');
    }

    /**
     * Search for apps on Google Play
     */
    public function searchApps(string $term, string $country = 'us', int $limit = 50): array
    {
        $cacheKey = "gplay_search_{$country}_" . md5($term) . "_{$limit}";

        return Cache::remember($cacheKey, now()->addHour(), function () use ($term, $country, $limit) {
            $response = Http::timeout(30)->get("{$this->scraperUrl}/search", [
                'term' => $term,
                'country' => $country,
                'num' => min($limit, 250),
            ]);

            if (!$response->successful()) {
                return [];
            }

            return $response->json('results', []);
        });
    }

    /**
     * Get app details
     */
    public function getAppDetails(string $appId, string $country = 'us'): ?array
    {
        $cacheKey = "gplay_app_{$appId}_{$country}";

        return Cache::remember($cacheKey, now()->addDay(), function () use ($appId, $country) {
            $response = Http::timeout(30)->get("{$this->scraperUrl}/app/{$appId}", [
                'country' => $country,
            ]);

            if (!$response->successful()) {
                return null;
            }

            return $response->json();
        });
    }

    /**
     * Get app reviews
     */
    public function getAppReviews(string $appId, string $country = 'us', int $limit = 100): array
    {
        $cacheKey = "gplay_reviews_{$appId}_{$country}_{$limit}";

        return Cache::remember($cacheKey, now()->addHours(6), function () use ($appId, $country, $limit) {
            $response = Http::timeout(30)->get("{$this->scraperUrl}/reviews/{$appId}", [
                'country' => $country,
                'num' => min($limit, 500),
            ]);

            if (!$response->successful()) {
                return [];
            }

            return $response->json('reviews', []);
        });
    }

    /**
     * Get rankings for keywords
     */
    public function getRankingsForKeywords(string $appId, array $keywords, string $country = 'us'): array
    {
        $response = Http::timeout(120)->post("{$this->scraperUrl}/search/rankings", [
            'app_id' => $appId,
            'keywords' => $keywords,
            'country' => $country,
        ]);

        if (!$response->successful()) {
            return [];
        }

        return $response->json('rankings', []);
    }

    /**
     * Check if scraper is healthy
     */
    public function isHealthy(): bool
    {
        try {
            $response = Http::timeout(5)->get("{$this->scraperUrl}/health");
            return $response->successful() && $response->json('status') === 'ok';
        } catch (\Exception $e) {
            return false;
        }
    }
}
```

**Step 2: Add config**

Add to `api/config/services.php`:
```php
'gplay_scraper' => [
    'url' => env('GPLAY_SCRAPER_URL', 'http://localhost:3001'),
],
```

**Step 3: Commit**

```bash
git add api/app/Services/ api/config/services.php
git commit -m "feat: add GooglePlayService for scraper integration"
```

---

### Task 3.2: Update App Model

**Files:**
- Modify: `api/app/Models/App.php`

**Step 1: Update fillable and casts**

Update `api/app/Models/App.php`:
```php
protected $fillable = [
    'user_id',
    'apple_id',
    'google_play_id',
    'bundle_id',
    'name',
    'icon_url',
    'google_icon_url',
    'developer',
    'rating',
    'rating_count',
    'google_rating',
    'google_rating_count',
    'ratings_fetched_at',
    'reviews_fetched_at',
    'google_ratings_fetched_at',
    'google_reviews_fetched_at',
];

protected $casts = [
    'rating' => 'decimal:1',
    'rating_count' => 'integer',
    'google_rating' => 'decimal:1',
    'google_rating_count' => 'integer',
    'ratings_fetched_at' => 'datetime',
    'reviews_fetched_at' => 'datetime',
    'google_ratings_fetched_at' => 'datetime',
    'google_reviews_fetched_at' => 'datetime',
];
```

**Step 2: Add helper methods**

Add to `api/app/Models/App.php`:
```php
public function hasIos(): bool
{
    return !empty($this->apple_id);
}

public function hasAndroid(): bool
{
    return !empty($this->google_play_id);
}

public function platforms(): array
{
    $platforms = [];
    if ($this->hasIos()) $platforms[] = 'ios';
    if ($this->hasAndroid()) $platforms[] = 'android';
    return $platforms;
}
```

**Step 3: Commit**

```bash
git add api/app/Models/App.php
git commit -m "feat: update App model with Google Play fields"
```

---

### Task 3.3: Update AppRating Model

**Files:**
- Modify: `api/app/Models/AppRating.php`

**Step 1: Update model**

Add to fillable in `api/app/Models/AppRating.php`:
```php
protected $fillable = [
    'app_id',
    'platform',
    'country',
    'rating',
    'rating_count',
    'recorded_at',
];
```

**Step 2: Add scope**

```php
public function scopeForPlatform($query, string $platform)
{
    return $query->where('platform', $platform);
}
```

**Step 3: Commit**

```bash
git add api/app/Models/AppRating.php
git commit -m "feat: update AppRating model with platform"
```

---

### Task 3.4: Create Android Search Endpoint

**Files:**
- Modify: `api/app/Http/Controllers/Api/AppController.php`

**Step 1: Add search Android method**

Add to `api/app/Http/Controllers/Api/AppController.php`:
```php
use App\Services\GooglePlayService;

public function searchAndroid(Request $request, GooglePlayService $gplayService)
{
    $request->validate([
        'query' => 'required|string|min:2',
        'country' => 'nullable|string|size:2',
        'limit' => 'nullable|integer|min:1|max:100',
    ]);

    $results = $gplayService->searchApps(
        $request->query('query'),
        $request->query('country', 'us'),
        $request->query('limit', 30)
    );

    return response()->json($results);
}
```

**Step 2: Add route**

Add to `api/routes/api.php`:
```php
Route::get('/apps/search/android', [AppController::class, 'searchAndroid']);
```

**Step 3: Commit**

```bash
git add api/app/Http/Controllers/Api/AppController.php api/routes/api.php
git commit -m "feat: add Android app search endpoint"
```

---

### Task 3.5: Update Add App to Support Android

**Files:**
- Modify: `api/app/Http/Controllers/Api/AppController.php`

**Step 1: Update store method**

Modify the `store` method in `AppController.php` to handle both platforms:
```php
public function store(Request $request, iTunesService $itunesService, GooglePlayService $gplayService)
{
    $request->validate([
        'apple_id' => 'nullable|string|required_without:google_play_id',
        'google_play_id' => 'nullable|string|required_without:apple_id',
        'country' => 'nullable|string|size:2',
    ]);

    $user = $request->user();
    $country = $request->input('country', 'us');

    $appData = [
        'user_id' => $user->id,
        'name' => 'Unknown',
    ];

    // Fetch iOS details if apple_id provided
    if ($request->filled('apple_id')) {
        $appleId = $request->input('apple_id');

        // Check if already tracking this iOS app
        $existing = App::where('user_id', $user->id)
            ->where('apple_id', $appleId)
            ->first();
        if ($existing) {
            return response()->json(['message' => 'You are already tracking this iOS app'], 422);
        }

        $iosDetails = $itunesService->getAppDetails($appleId, $country);
        if (!$iosDetails) {
            return response()->json(['message' => 'iOS app not found in App Store'], 404);
        }

        $appData['apple_id'] = $appleId;
        $appData['name'] = $iosDetails['name'];
        $appData['bundle_id'] = $iosDetails['bundle_id'];
        $appData['icon_url'] = $iosDetails['icon_url'];
        $appData['developer'] = $iosDetails['developer'];
        $appData['rating'] = $iosDetails['rating'];
        $appData['rating_count'] = $iosDetails['rating_count'];
    }

    // Fetch Android details if google_play_id provided
    if ($request->filled('google_play_id')) {
        $googlePlayId = $request->input('google_play_id');

        // Check if already tracking this Android app
        $existing = App::where('user_id', $user->id)
            ->where('google_play_id', $googlePlayId)
            ->first();
        if ($existing) {
            return response()->json(['message' => 'You are already tracking this Android app'], 422);
        }

        $androidDetails = $gplayService->getAppDetails($googlePlayId, $country);
        if (!$androidDetails) {
            return response()->json(['message' => 'Android app not found in Play Store'], 404);
        }

        $appData['google_play_id'] = $googlePlayId;
        // Use Android name if no iOS
        if (empty($appData['apple_id'])) {
            $appData['name'] = $androidDetails['name'];
            $appData['developer'] = $androidDetails['developer'];
        }
        $appData['google_icon_url'] = $androidDetails['icon_url'];
        $appData['google_rating'] = $androidDetails['rating'];
        $appData['google_rating_count'] = $androidDetails['rating_count'];
    }

    $app = App::create($appData);

    return response()->json($app, 201);
}
```

**Step 2: Commit**

```bash
git add api/app/Http/Controllers/Api/AppController.php
git commit -m "feat: update app store to support iOS and Android"
```

---

### Task 3.6: Add Link Android to Existing App Endpoint

**Files:**
- Modify: `api/app/Http/Controllers/Api/AppController.php`
- Modify: `api/routes/api.php`

**Step 1: Add linkAndroid method**

Add to `AppController.php`:
```php
public function linkAndroid(Request $request, App $app, GooglePlayService $gplayService)
{
    $this->authorize('update', $app);

    $request->validate([
        'google_play_id' => 'required|string',
        'country' => 'nullable|string|size:2',
    ]);

    if ($app->google_play_id) {
        return response()->json(['message' => 'App already has Android linked'], 422);
    }

    $googlePlayId = $request->input('google_play_id');
    $country = $request->input('country', 'us');

    $androidDetails = $gplayService->getAppDetails($googlePlayId, $country);
    if (!$androidDetails) {
        return response()->json(['message' => 'Android app not found'], 404);
    }

    $app->update([
        'google_play_id' => $googlePlayId,
        'google_icon_url' => $androidDetails['icon_url'],
        'google_rating' => $androidDetails['rating'],
        'google_rating_count' => $androidDetails['rating_count'],
    ]);

    return response()->json($app);
}
```

**Step 2: Add route**

Add to `api/routes/api.php`:
```php
Route::post('/apps/{app}/link-android', [AppController::class, 'linkAndroid']);
```

**Step 3: Commit**

```bash
git add api/app/Http/Controllers/Api/AppController.php api/routes/api.php
git commit -m "feat: add endpoint to link Android app to existing iOS app"
```

---

## Phase 4: Flutter UI Updates

### Task 4.1: Update AppModel for Android

**Files:**
- Modify: `app/lib/features/apps/domain/app_model.dart`

**Step 1: Update AppModel**

```dart
class AppModel {
  final int id;
  final int userId;
  final String? appleId;
  final String? googlePlayId;
  final String? bundleId;
  final String name;
  final String? iconUrl;
  final String? googleIconUrl;
  final String? developer;
  final double? rating;
  final int ratingCount;
  final double? googleRating;
  final int googleRatingCount;
  final int? trackedKeywordsCount;
  final DateTime createdAt;

  AppModel({
    required this.id,
    required this.userId,
    this.appleId,
    this.googlePlayId,
    this.bundleId,
    required this.name,
    this.iconUrl,
    this.googleIconUrl,
    this.developer,
    this.rating,
    required this.ratingCount,
    this.googleRating,
    required this.googleRatingCount,
    this.trackedKeywordsCount,
    required this.createdAt,
  });

  bool get hasIos => appleId != null && appleId!.isNotEmpty;
  bool get hasAndroid => googlePlayId != null && googlePlayId!.isNotEmpty;

  List<String> get platforms {
    final list = <String>[];
    if (hasIos) list.add('ios');
    if (hasAndroid) list.add('android');
    return list;
  }

  factory AppModel.fromJson(Map<String, dynamic> json) {
    return AppModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      appleId: json['apple_id'] as String?,
      googlePlayId: json['google_play_id'] as String?,
      bundleId: json['bundle_id'] as String?,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      googleIconUrl: json['google_icon_url'] as String?,
      developer: json['developer'] as String?,
      rating: _parseDouble(json['rating']),
      ratingCount: _parseInt(json['rating_count']) ?? 0,
      googleRating: _parseDouble(json['google_rating']),
      googleRatingCount: _parseInt(json['google_rating_count']) ?? 0,
      trackedKeywordsCount: _parseInt(json['tracked_keywords_count']),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // ... keep existing _parseDouble and _parseInt methods
}
```

**Step 2: Add AndroidSearchResult**

Add to same file:
```dart
class AndroidSearchResult {
  final int position;
  final String googlePlayId;
  final String name;
  final String? iconUrl;
  final String? developer;
  final double? rating;
  final int ratingCount;
  final bool free;

  AndroidSearchResult({
    required this.position,
    required this.googlePlayId,
    required this.name,
    this.iconUrl,
    this.developer,
    this.rating,
    required this.ratingCount,
    required this.free,
  });

  factory AndroidSearchResult.fromJson(Map<String, dynamic> json) {
    return AndroidSearchResult(
      position: json['position'] as int,
      googlePlayId: json['google_play_id'] as String,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      developer: json['developer'] as String?,
      rating: AppModel._parseDouble(json['rating']),
      ratingCount: AppModel._parseInt(json['rating_count']) ?? 0,
      free: json['free'] as bool? ?? true,
    );
  }
}
```

**Step 3: Commit**

```bash
git add app/lib/features/apps/domain/app_model.dart
git commit -m "feat: update AppModel with Android support"
```

---

### Task 4.2: Update Apps Repository

**Files:**
- Modify: `app/lib/features/apps/data/apps_repository.dart`

**Step 1: Add Android search method**

Add to `AppsRepository`:
```dart
Future<List<AndroidSearchResult>> searchAndroidApps({
  required String query,
  String country = 'us',
  int limit = 30,
}) async {
  final response = await _client.get(
    '/apps/search/android',
    queryParameters: {
      'query': query,
      'country': country,
      'limit': limit,
    },
  );
  return (response.data as List)
      .map((json) => AndroidSearchResult.fromJson(json))
      .toList();
}

Future<AppModel> linkAndroid({
  required int appId,
  required String googlePlayId,
  String country = 'us',
}) async {
  final response = await _client.post(
    '/apps/$appId/link-android',
    data: {
      'google_play_id': googlePlayId,
      'country': country,
    },
  );
  return AppModel.fromJson(response.data);
}
```

**Step 2: Update addApp method**

```dart
Future<AppModel> addApp({
  String? appleId,
  String? googlePlayId,
  String country = 'us',
}) async {
  final response = await _client.post(
    '/apps',
    data: {
      if (appleId != null) 'apple_id': appleId,
      if (googlePlayId != null) 'google_play_id': googlePlayId,
      'country': country,
    },
  );
  return AppModel.fromJson(response.data);
}
```

**Step 3: Commit**

```bash
git add app/lib/features/apps/data/apps_repository.dart
git commit -m "feat: add Android methods to apps repository"
```

---

### Task 4.3: Create Platform Tabs Widget

**Files:**
- Create: `app/lib/core/widgets/platform_tabs.dart`

**Step 1: Create widget**

Create `app/lib/core/widgets/platform_tabs.dart`:
```dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PlatformTabs extends StatelessWidget {
  final String selectedPlatform;
  final List<String> availablePlatforms;
  final ValueChanged<String> onPlatformChanged;

  const PlatformTabs({
    super.key,
    required this.selectedPlatform,
    required this.availablePlatforms,
    required this.onPlatformChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgActive,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: availablePlatforms.map((platform) {
          final isSelected = platform == selectedPlatform;
          return GestureDetector(
            onTap: () => onPlatformChanged(platform),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.glassPanel : Colors.transparent,
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    platform == 'ios' ? '🍎' : '🤖',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    platform == 'ios' ? 'iOS' : 'Android',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/core/widgets/platform_tabs.dart
git commit -m "feat: create PlatformTabs widget"
```

---

### Task 4.4: Update Add App Screen with Platform Selection

**Files:**
- Modify: `app/lib/features/apps/presentation/add_app_screen.dart`

**Step 1: Add platform state**

Add to top of file after imports:
```dart
enum AppPlatform { ios, android }

final _selectedPlatformProvider = StateProvider<AppPlatform>((ref) => AppPlatform.ios);
```

**Step 2: Update search provider**

Replace `_searchResultsProvider`:
```dart
final _iosSearchResultsProvider = FutureProvider<List<AppSearchResult>>((ref) async {
  final query = ref.watch(_searchQueryProvider);
  final country = ref.watch(selectedCountryProvider);
  if (query.length < 2) return [];
  final repository = ref.watch(appsRepositoryProvider);
  return repository.searchApps(query: query, country: country.code, limit: 30);
});

final _androidSearchResultsProvider = FutureProvider<List<AndroidSearchResult>>((ref) async {
  final query = ref.watch(_searchQueryProvider);
  final country = ref.watch(selectedCountryProvider);
  if (query.length < 2) return [];
  final repository = ref.watch(appsRepositoryProvider);
  return repository.searchAndroidApps(query: query, country: country.code, limit: 30);
});
```

**Step 3: Add platform toggle to build method**

Add after country selector in the search bar area:
```dart
// Platform toggle
const SizedBox(width: 12),
Container(
  decoration: BoxDecoration(
    color: AppColors.bgActive,
    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
    border: Border.all(color: AppColors.glassBorder),
  ),
  padding: const EdgeInsets.all(4),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _PlatformTab(
        label: '🍎 iOS',
        isSelected: ref.watch(_selectedPlatformProvider) == AppPlatform.ios,
        onTap: () => ref.read(_selectedPlatformProvider.notifier).state = AppPlatform.ios,
      ),
      _PlatformTab(
        label: '🤖 Android',
        isSelected: ref.watch(_selectedPlatformProvider) == AppPlatform.android,
        onTap: () => ref.read(_selectedPlatformProvider.notifier).state = AppPlatform.android,
      ),
    ],
  ),
),
```

**Step 4: Create _PlatformTab widget**

Add at bottom of file:
```dart
class _PlatformTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlatformTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.glassPanel : Colors.transparent,
          borderRadius: BorderRadius.circular(AppColors.radiusSmall - 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
```

**Step 5: Update results display**

Update the Expanded results section to show platform-specific results:
```dart
Expanded(
  child: Consumer(
    builder: (context, ref, _) {
      final platform = ref.watch(_selectedPlatformProvider);

      if (platform == AppPlatform.ios) {
        return ref.watch(_iosSearchResultsProvider).when(
          loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          error: (e, _) => _buildError(e.toString()),
          data: (apps) => _buildIosResults(apps),
        );
      } else {
        return ref.watch(_androidSearchResultsProvider).when(
          loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          error: (e, _) => _buildError(e.toString()),
          data: (apps) => _buildAndroidResults(apps),
        );
      }
    },
  ),
),
```

**Step 6: Commit**

```bash
git add app/lib/features/apps/presentation/add_app_screen.dart
git commit -m "feat: add platform selection to Add App screen"
```

---

## Phase 5: Final Integration

### Task 5.1: Update App Detail Screen with Platform Tabs

**Files:**
- Modify: `app/lib/features/apps/presentation/app_detail_screen.dart`

Add platform tabs and conditional display of iOS vs Android data.

### Task 5.2: Update Ratings Screen with Platform Filter

**Files:**
- Modify: `app/lib/features/ratings/presentation/app_ratings_screen.dart`

Filter ratings by platform based on selected tab.

### Task 5.3: Update Rankings with Platform Support

**Files:**
- Modify: `app/lib/features/rankings/` screens

Add platform parameter to ranking queries.

### Task 5.4: Add Environment Variables

**Files:**
- Modify: `api/.env.example`
- Create: `scraper/.env.example`

```
# api/.env
GPLAY_SCRAPER_URL=http://localhost:3001

# scraper/.env
PORT=3001
```

### Task 5.5: Create docker-compose.yml

**Files:**
- Create: `docker-compose.yml`

```yaml
version: '3.8'
services:
  scraper:
    build: ./scraper
    ports:
      - "3001:3001"
    environment:
      - PORT=3001
    restart: unless-stopped
```

---

## Checklist Summary

- [ ] Phase 1: Node.js micro-service (7 tasks)
- [ ] Phase 2: Database migrations (4 tasks)
- [ ] Phase 3: Laravel backend (6 tasks)
- [ ] Phase 4: Flutter UI (4 tasks)
- [ ] Phase 5: Final integration (5 tasks)

**Total: ~26 tasks**
