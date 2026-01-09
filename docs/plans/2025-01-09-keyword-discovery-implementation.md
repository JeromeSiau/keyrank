# Keyword Discovery Service - Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create a keyword discovery service that suggests relevant keywords to track for any iOS app, based on app metadata and competitor analysis.

**Architecture:** New `KeywordDiscoveryService` that uses iTunes hints endpoint for suggestions, extracts seed terms from app metadata, analyzes category competitors, and calculates difficulty scores. Replaces the non-functional `AppleSearchAdsService`.

**Tech Stack:** Laravel 12, PHP 8.2, iTunes API (hints endpoint), Http facade for parallel requests

---

## Task 1: Create KeywordDiscoveryService with iTunes Hints

**Files:**
- Create: `api/app/Services/KeywordDiscoveryService.php`

**Step 1: Create the service file with store IDs and hints method**

```php
<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Cache;

class KeywordDiscoveryService
{
    private const HINTS_URL = 'https://search.itunes.apple.com/WebObjects/MZSearchHints.woa/wa/hints';

    private const STORE_IDS = [
        'US' => '143441',
        'GB' => '143444',
        'FR' => '143442',
        'DE' => '143443',
        'JP' => '143462',
        'CN' => '143465',
        'AU' => '143460',
        'CA' => '143455',
        'IT' => '143450',
        'ES' => '143454',
        'NL' => '143452',
        'BR' => '143503',
        'MX' => '143468',
        'KR' => '143466',
        'RU' => '143469',
        'IN' => '143467',
        'SE' => '143456',
        'NO' => '143457',
        'DK' => '143458',
        'FI' => '143447',
        'CH' => '143459',
        'AT' => '143445',
        'BE' => '143446',
        'PT' => '143453',
        'PL' => '143478',
        'SG' => '143464',
        'HK' => '143463',
        'TW' => '143470',
        'NZ' => '143461',
    ];

    public function __construct(
        private iTunesService $iTunesService
    ) {}

    /**
     * Get search hints/suggestions for a term
     */
    public function getSearchHints(string $term, string $country = 'US'): array
    {
        $country = strtoupper($country);
        $storeId = self::STORE_IDS[$country] ?? self::STORE_IDS['US'];
        $cacheKey = "hints_{$country}_" . md5($term);

        return Cache::remember($cacheKey, now()->addDay(), function () use ($term, $storeId) {
            $response = Http::timeout(10)
                ->withHeaders([
                    'X-Apple-Store-Front' => "{$storeId}-1,29",
                ])
                ->get(self::HINTS_URL, [
                    'clientApplication' => 'Software',
                    'term' => $term,
                ]);

            if (!$response->successful()) {
                return [];
            }

            $body = $response->body();

            // Parse plist XML response
            preg_match_all('/<key>term<\/key>\s*<string>([^<]+)<\/string>/', $body, $matches);

            return $matches[1] ?? [];
        });
    }
}
```

**Step 2: Verify file was created**

Run: `php -l api/app/Services/KeywordDiscoveryService.php`
Expected: No syntax errors

**Step 3: Commit**

```bash
git add api/app/Services/KeywordDiscoveryService.php
git commit -m "feat: add KeywordDiscoveryService with iTunes hints"
```

---

## Task 2: Add Seed Term Extraction

**Files:**
- Modify: `api/app/Services/KeywordDiscoveryService.php`

**Step 1: Add method to extract seed terms from app metadata**

Add after `getSearchHints` method:

```php
    /**
     * Extract seed terms from app metadata
     */
    public function extractSeedTerms(array $appDetails): array
    {
        $seeds = [];

        // From app name
        if (!empty($appDetails['name'])) {
            $nameTerms = $this->tokenize($appDetails['name']);
            $seeds = array_merge($seeds, $nameTerms);
        }

        // From description (first 500 chars)
        if (!empty($appDetails['description'])) {
            $desc = substr($appDetails['description'], 0, 500);
            $descTerms = $this->tokenize($desc);
            // Only keep longer, meaningful terms from description
            $descTerms = array_filter($descTerms, fn($t) => strlen($t) >= 4);
            $seeds = array_merge($seeds, array_slice($descTerms, 0, 5));
        }

        // Deduplicate and limit
        $seeds = array_unique(array_map('strtolower', $seeds));
        return array_slice($seeds, 0, 10);
    }

    /**
     * Tokenize text into meaningful terms
     */
    private function tokenize(string $text): array
    {
        // Remove special characters, keep letters and spaces
        $text = preg_replace('/[^a-zA-Z\s]/', ' ', $text);
        $text = strtolower(trim($text));

        // Split into words
        $words = preg_split('/\s+/', $text, -1, PREG_SPLIT_NO_EMPTY);

        // Filter stop words and short words
        $stopWords = ['the', 'and', 'for', 'with', 'your', 'you', 'from', 'that', 'this', 'are', 'was', 'have', 'has', 'will', 'can', 'app', 'new'];
        $words = array_filter($words, fn($w) => strlen($w) >= 3 && !in_array($w, $stopWords));

        return array_values($words);
    }
```

**Step 2: Verify syntax**

Run: `php -l api/app/Services/KeywordDiscoveryService.php`
Expected: No syntax errors

**Step 3: Commit**

```bash
git add api/app/Services/KeywordDiscoveryService.php
git commit -m "feat: add seed term extraction from app metadata"
```

---

## Task 3: Add Difficulty Calculation

**Files:**
- Modify: `api/app/Services/KeywordDiscoveryService.php`

**Step 1: Add difficulty calculation method**

Add after `tokenize` method:

```php
    /**
     * Calculate keyword difficulty score (0-100)
     */
    public function calculateDifficulty(array $searchResults): array
    {
        $resultCount = count($searchResults);

        if ($resultCount === 0) {
            return ['score' => 0, 'label' => 'easy'];
        }

        // Score based on number of results (0-40)
        $resultScore = min(40, $resultCount / 5);

        // Score based on top 10 strength (0-60)
        $top10 = array_slice($searchResults, 0, 10);
        $strengthScore = 0;

        foreach ($top10 as $app) {
            $rating = $app['rating'] ?? 0;
            $reviews = $app['rating_count'] ?? 1;
            $strengthScore += $rating * log10(max(1, $reviews));
        }
        $strengthScore = min(60, ($strengthScore / 10) * 6);

        $score = (int) round($resultScore + $strengthScore);
        $score = max(0, min(100, $score));

        $label = match (true) {
            $score <= 25 => 'easy',
            $score <= 50 => 'medium',
            $score <= 75 => 'hard',
            default => 'very_hard',
        };

        return ['score' => $score, 'label' => $label];
    }
```

**Step 2: Verify syntax**

Run: `php -l api/app/Services/KeywordDiscoveryService.php`
Expected: No syntax errors

**Step 3: Commit**

```bash
git add api/app/Services/KeywordDiscoveryService.php
git commit -m "feat: add keyword difficulty calculation"
```

---

## Task 4: Add Get Suggestions Method

**Files:**
- Modify: `api/app/Services/KeywordDiscoveryService.php`

**Step 1: Add main suggestions method**

Add after `calculateDifficulty` method:

```php
    /**
     * Get keyword suggestions for an app
     */
    public function getSuggestionsForApp(string $appId, string $country = 'US', int $limit = 50): array
    {
        $country = strtoupper($country);
        $countryLower = strtolower($country);

        // Get app details
        $appDetails = $this->iTunesService->getAppDetails($appId, $countryLower);
        if (!$appDetails) {
            return [];
        }

        // Extract seed terms
        $seeds = $this->extractSeedTerms($appDetails);

        // Get hints for each seed (parallel)
        $allHints = [];
        $responses = Http::pool(fn ($pool) =>
            collect($seeds)->map(fn ($seed) =>
                $pool->as($seed)
                    ->timeout(10)
                    ->withHeaders(['X-Apple-Store-Front' => (self::STORE_IDS[$country] ?? self::STORE_IDS['US']) . '-1,29'])
                    ->get(self::HINTS_URL, ['clientApplication' => 'Software', 'term' => $seed])
            )->toArray()
        );

        foreach ($seeds as $seed) {
            $response = $responses[$seed] ?? null;
            if ($response && $response->successful()) {
                preg_match_all('/<key>term<\/key>\s*<string>([^<]+)<\/string>/', $response->body(), $matches);
                foreach ($matches[1] ?? [] as $hint) {
                    $source = in_array($seed, $this->tokenize($appDetails['name'] ?? '')) ? 'app_name' : 'app_description';
                    $allHints[$hint] = $source;
                }
            }
            usleep(50000); // 50ms delay
        }

        // Build suggestions with metrics
        $suggestions = [];
        $processed = 0;

        foreach ($allHints as $keyword => $source) {
            if ($processed >= $limit) break;

            // Get search results for this keyword
            $results = $this->iTunesService->searchApps($keyword, $countryLower, 50);

            // Find app position
            $position = null;
            foreach ($results as $result) {
                if ($result['apple_id'] === $appId) {
                    $position = $result['position'];
                    break;
                }
            }

            // Calculate difficulty
            $difficulty = $this->calculateDifficulty($results);

            // Get top 3 competitors
            $topCompetitors = array_slice(array_map(fn($r) => [
                'name' => $r['name'],
                'position' => $r['position'],
                'rating' => $r['rating'],
            ], $results), 0, 3);

            $suggestions[] = [
                'keyword' => $keyword,
                'source' => $source,
                'metrics' => [
                    'position' => $position,
                    'competition' => count($results),
                    'difficulty' => $difficulty['score'],
                    'difficulty_label' => $difficulty['label'],
                ],
                'top_competitors' => $topCompetitors,
            ];

            $processed++;
            usleep(100000); // 100ms delay between searches
        }

        // Sort by opportunity (has position or low difficulty)
        usort($suggestions, function ($a, $b) {
            // Prioritize where app already ranks
            if ($a['metrics']['position'] !== null && $b['metrics']['position'] === null) return -1;
            if ($a['metrics']['position'] === null && $b['metrics']['position'] !== null) return 1;

            // Then by difficulty (easier first)
            return $a['metrics']['difficulty'] <=> $b['metrics']['difficulty'];
        });

        return $suggestions;
    }
```

**Step 2: Verify syntax**

Run: `php -l api/app/Services/KeywordDiscoveryService.php`
Expected: No syntax errors

**Step 3: Commit**

```bash
git add api/app/Services/KeywordDiscoveryService.php
git commit -m "feat: add getSuggestionsForApp with metrics"
```

---

## Task 5: Update KeywordController

**Files:**
- Modify: `api/app/Http/Controllers/Api/KeywordController.php`

**Step 1: Replace AppleSearchAdsService with KeywordDiscoveryService**

Replace line 12:
```php
use App\Services\AppleSearchAdsService;
```
With:
```php
use App\Services\KeywordDiscoveryService;
```

Replace constructor (lines 18-22):
```php
    public function __construct(
        private iTunesService $iTunesService,
        private GooglePlayService $googlePlayService,
        private KeywordDiscoveryService $keywordDiscoveryService
    ) {}
```

**Step 2: Update suggestions method**

Replace the entire `suggestions` method (lines 242-283):
```php
    /**
     * Get keyword suggestions for an app
     */
    public function suggestions(Request $request, App $app): JsonResponse
    {
        if ($app->platform !== 'ios') {
            return response()->json([
                'message' => 'Keyword suggestions are only available for iOS apps',
                'data' => [],
            ]);
        }

        $validated = $request->validate([
            'country' => 'nullable|string|size:2',
            'limit' => 'nullable|integer|min:1|max:50',
        ]);

        $country = strtoupper($validated['country'] ?? 'US');
        $limit = $validated['limit'] ?? 30;

        $suggestions = $this->keywordDiscoveryService->getSuggestionsForApp(
            $app->store_id,
            $country,
            $limit
        );

        return response()->json([
            'data' => $suggestions,
            'meta' => [
                'app_id' => $app->store_id,
                'country' => $country,
                'total' => count($suggestions),
                'generated_at' => now()->toIso8601String(),
            ],
        ]);
    }
```

**Step 3: Verify syntax**

Run: `php -l api/app/Http/Controllers/Api/KeywordController.php`
Expected: No syntax errors

**Step 4: Commit**

```bash
git add api/app/Http/Controllers/Api/KeywordController.php
git commit -m "feat: use KeywordDiscoveryService in controller"
```

---

## Task 6: Test the Endpoint

**Step 1: Clear config cache**

Run: `cd api && php artisan config:clear`
Expected: Configuration cache cleared successfully

**Step 2: Test with tinker**

Run:
```bash
php artisan tinker --execute="
use App\Services\KeywordDiscoveryService;
use App\Services\iTunesService;

\$itunes = app(iTunesService::class);
\$service = new KeywordDiscoveryService(\$itunes);

// Test hints
\$hints = \$service->getSearchHints('photo', 'US');
echo 'Hints for photo: ' . count(\$hints) . PHP_EOL;
print_r(array_slice(\$hints, 0, 5));
"
```
Expected: Should show ~10 hints for "photo"

**Step 3: Test full suggestions (with real app)**

Run:
```bash
php artisan tinker --execute="
use App\Services\KeywordDiscoveryService;
use App\Services\iTunesService;

\$itunes = app(iTunesService::class);
\$service = new KeywordDiscoveryService(\$itunes);

// Test with Instagram
\$suggestions = \$service->getSuggestionsForApp('389801252', 'US', 5);
echo 'Suggestions: ' . count(\$suggestions) . PHP_EOL;
if (!empty(\$suggestions)) {
    print_r(\$suggestions[0]);
}
"
```
Expected: Should return suggestions with metrics

**Step 4: Commit if all tests pass**

```bash
git add -A
git commit -m "test: verify KeywordDiscoveryService works"
```

---

## Task 7: Cleanup - Remove AppleSearchAdsService

**Files:**
- Delete: `api/app/Services/AppleSearchAdsService.php`
- Modify: `api/config/services.php` (optional cleanup)
- Modify: `api/.env.example` (optional cleanup)

**Step 1: Delete unused service**

Run: `rm api/app/Services/AppleSearchAdsService.php`

**Step 2: Commit**

```bash
git add -A
git commit -m "chore: remove unused AppleSearchAdsService"
```

---

## Summary

After completing all tasks, you will have:
- `KeywordDiscoveryService` with iTunes hints integration
- Seed term extraction from app metadata
- Difficulty scoring algorithm
- Updated `KeywordController` using the new service
- Cleaned up unused `AppleSearchAdsService`

Test the full flow by calling:
```
GET /api/apps/{app_id}/keywords/suggestions?country=US&limit=20
```
