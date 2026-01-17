<?php

namespace App\Services;

use App\Models\App;
use App\Models\AppCompetitor;
use App\Models\AppRanking;
use App\Models\KeywordSuggestion;
use App\Models\TrackedKeyword;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

/**
 * Enhanced Keyword Suggestion Service
 *
 * Generates categorized keyword suggestions:
 * - high_opportunity: Keywords where app already ranks + low difficulty
 * - competitor: Keywords tracked competitors rank for
 * - long_tail: Extended variations of base keywords
 * - trending: Popular keywords in the category (from top apps)
 * - related: Similar to currently tracked keywords
 */
class KeywordSuggestionService
{
    private const HINTS_URL = 'https://search.itunes.apple.com/WebObjects/MZSearchHints.woa/wa/hints';

    private const STORE_IDS = [
        'US' => '143441', 'GB' => '143444', 'FR' => '143442', 'DE' => '143443',
        'JP' => '143462', 'CN' => '143465', 'AU' => '143460', 'CA' => '143455',
        'IT' => '143450', 'ES' => '143454', 'NL' => '143452', 'BR' => '143503',
        'MX' => '143468', 'KR' => '143466', 'IN' => '143467', 'SE' => '143456',
    ];

    private const LONG_TAIL_MODIFIERS = [
        'best', 'free', 'app', 'top', 'easy', 'simple', 'pro',
        'for beginners', 'for couples', 'for students', 'for business',
        'with widgets', 'offline', 'premium', 'lite', '2024', '2025',
    ];

    public function __construct(
        private iTunesService $iTunesService,
        private GooglePlayService $googlePlayService
    ) {}

    /**
     * Generate all categories of suggestions for an app
     *
     * @param App $app
     * @param string $country
     * @param int $limitPerCategory
     * @param callable|null $progressCallback fn(stage, current, total, detail)
     */
    public function generateSuggestions(
        App $app,
        string $country = 'US',
        int $limitPerCategory = 15,
        ?callable $progressCallback = null
    ): array {
        $country = strtoupper($country);
        $platform = $app->platform;
        $progress = $progressCallback ?? fn() => null;

        Log::info("Generating keyword suggestions for {$app->name} ({$platform}) in {$country}");

        $suggestions = [];
        $totalSteps = 5;
        $currentStep = 0;

        // 1. Get existing tracked keywords for context (from all users tracking this app)
        $trackedKeywords = $this->getTrackedKeywords($app->id);
        Log::info("Found " . count($trackedKeywords) . " tracked keywords");

        // 2. High Opportunity - from app metadata (existing logic enhanced)
        $currentStep++;
        $progress('High Opportunity', $currentStep, $totalSteps, 'Extracting from app metadata...');
        $highOpp = $this->generateHighOpportunity($app, $country, $platform, $limitPerCategory);
        $suggestions = array_merge($suggestions, $highOpp);
        Log::info("Generated " . count($highOpp) . " high opportunity suggestions");

        // 3. Competitor Keywords
        $currentStep++;
        $progress('Competitor', $currentStep, $totalSteps, 'Analyzing competitor rankings...');
        $competitorKws = $this->generateCompetitorKeywords($app, $country, $trackedKeywords, $limitPerCategory);
        $suggestions = array_merge($suggestions, $competitorKws);
        Log::info("Generated " . count($competitorKws) . " competitor suggestions");

        // 4. Long-tail variations
        $currentStep++;
        $progress('Long-tail', $currentStep, $totalSteps, 'Generating variations...');
        $longTail = $this->generateLongTail($trackedKeywords, $country, $platform, $limitPerCategory);
        $suggestions = array_merge($suggestions, $longTail);
        Log::info("Generated " . count($longTail) . " long-tail suggestions");

        // 5. Related to tracked
        $currentStep++;
        $progress('Related', $currentStep, $totalSteps, 'Expanding from tracked keywords...');
        $related = $this->generateRelated($trackedKeywords, $country, $platform, $limitPerCategory);
        $suggestions = array_merge($suggestions, $related);
        Log::info("Generated " . count($related) . " related suggestions");

        // 6. Trending in category
        $currentStep++;
        $progress('Trending', $currentStep, $totalSteps, 'Analyzing category trends...');
        $trending = $this->generateTrending($app, $country, $platform, $limitPerCategory);
        $suggestions = array_merge($suggestions, $trending);
        Log::info("Generated " . count($trending) . " trending suggestions");

        // Deduplicate by keyword
        $seen = [];
        $unique = [];
        foreach ($suggestions as $s) {
            $key = strtolower($s['keyword']);
            if (!isset($seen[$key])) {
                $seen[$key] = true;
                $unique[] = $s;
            }
        }

        Log::info("Total unique suggestions: " . count($unique));

        return $unique;
    }

    /**
     * Get all tracked keywords for this app (across all users)
     */
    private function getTrackedKeywords(int $appId): array
    {
        return TrackedKeyword::where('app_id', $appId)
            ->with('keyword')
            ->get()
            ->pluck('keyword.keyword')
            ->filter()
            ->unique()
            ->values()
            ->toArray();
    }

    /**
     * Generate high opportunity suggestions from app metadata
     */
    private function generateHighOpportunity(
        App $app,
        string $country,
        string $platform,
        int $limit
    ): array {
        $appDetails = $this->getAppDetails($app->store_id, $country, $platform);
        if (!$appDetails) {
            return [];
        }

        // Extract seed terms from app name and description
        $seeds = $this->extractSeedTerms($appDetails);

        // Get search hints for each seed
        $candidates = [];
        foreach ($seeds as $seed) {
            $hints = $this->getSearchHints($seed, $country, $platform);
            foreach ($hints as $hint) {
                $candidates[$hint] = 'app_metadata';
            }
        }

        // Validate and enrich with metrics
        return $this->validateAndEnrich(
            array_keys($candidates),
            $app->store_id,
            $country,
            $platform,
            'high_opportunity',
            $limit
        );
    }

    /**
     * Generate competitor keyword suggestions
     */
    private function generateCompetitorKeywords(
        App $app,
        string $country,
        array $trackedKeywords,
        int $limit
    ): array {
        // Get tracked competitors for this app (contextual) or global competitors
        $competitors = AppCompetitor::where(function ($q) use ($app) {
                $q->where('owner_app_id', $app->id)
                  ->orWhereNull('owner_app_id'); // Include global competitors
            })
            ->with('competitorApp')
            ->get();

        if ($competitors->isEmpty()) {
            return [];
        }

        $competitorKeywords = [];

        foreach ($competitors as $competitor) {
            $competitorApp = $competitor->competitorApp;
            if (!$competitorApp) continue;

            // Get keywords where competitor ranks
            $rankings = AppRanking::where('app_id', $competitorApp->id)
                ->whereNotNull('position')
                ->where('position', '<=', 50)
                ->with('keyword')
                ->orderBy('position')
                ->limit(30)
                ->get();

            foreach ($rankings as $ranking) {
                $kw = strtolower($ranking->keyword->keyword ?? '');
                if (!$kw) continue;

                // Skip if user already tracks this keyword
                if (in_array($kw, array_map('strtolower', $trackedKeywords))) continue;

                if (!isset($competitorKeywords[$kw])) {
                    $competitorKeywords[$kw] = [
                        'keyword' => $kw,
                        'competitors' => [],
                    ];
                }
                $competitorKeywords[$kw]['competitors'][] = [
                    'name' => $competitorApp->name,
                    'position' => $ranking->position,
                ];
            }
        }

        // Sort by number of competitors ranking for this keyword
        uasort($competitorKeywords, fn($a, $b) => count($b['competitors']) <=> count($a['competitors']));

        // Take top keywords and enrich
        $topKeywords = array_slice(array_keys($competitorKeywords), 0, $limit * 2);

        $suggestions = $this->validateAndEnrich(
            $topKeywords,
            $app->store_id,
            $country,
            $app->platform,
            'competitor',
            $limit
        );

        // Add competitor info to suggestions
        foreach ($suggestions as &$s) {
            $kw = strtolower($s['keyword']);
            if (isset($competitorKeywords[$kw])) {
                $topComp = $competitorKeywords[$kw]['competitors'][0] ?? null;
                if ($topComp) {
                    $s['competitor_name'] = $topComp['name'];
                    $s['reason'] = "{$topComp['name']} ranks #{$topComp['position']} for this keyword";
                }
            }
        }

        return $suggestions;
    }

    /**
     * Generate long-tail keyword variations
     */
    private function generateLongTail(
        array $trackedKeywords,
        string $country,
        string $platform,
        int $limit
    ): array {
        if (empty($trackedKeywords)) {
            return [];
        }

        // Take top 5 tracked keywords as base
        $baseKeywords = array_slice($trackedKeywords, 0, 5);
        $candidates = [];

        foreach ($baseKeywords as $base) {
            foreach (self::LONG_TAIL_MODIFIERS as $mod) {
                // Prefix: "best budget tracker"
                $candidates["{$mod} {$base}"] = $base;
                // Suffix: "budget tracker app"
                $candidates["{$base} {$mod}"] = $base;
            }
        }

        // Validate with Search Hints - only keep those that appear in autocomplete
        $validated = [];
        foreach ($candidates as $candidate => $basedOn) {
            $hints = $this->getSearchHints($candidate, $country, $platform);
            // Check if the exact candidate or very similar appears in hints
            foreach ($hints as $hint) {
                if (strtolower($hint) === strtolower($candidate) ||
                    str_contains(strtolower($hint), strtolower($candidate))) {
                    $validated[$hint] = $basedOn;
                    break;
                }
            }
        }

        if (empty($validated)) {
            return [];
        }

        // Enrich validated candidates
        $suggestions = [];
        $processed = 0;

        foreach ($validated as $keyword => $basedOn) {
            if ($processed >= $limit) break;

            $metrics = $this->getKeywordMetrics($keyword, $country, $platform, null);

            $suggestions[] = [
                'keyword' => $keyword,
                'source' => 'long_tail_generation',
                'category' => 'long_tail',
                'position' => null,
                'competition' => $metrics['competition'],
                'difficulty' => $metrics['difficulty'],
                'difficulty_label' => $metrics['difficulty_label'],
                'popularity' => null,
                'reason' => "Long-tail variation of \"{$basedOn}\"",
                'based_on' => $basedOn,
                'competitor_name' => null,
                'top_competitors' => $metrics['top_competitors'],
            ];

            $processed++;
        }

        return $suggestions;
    }

    /**
     * Generate related keyword suggestions
     */
    private function generateRelated(
        array $trackedKeywords,
        string $country,
        string $platform,
        int $limit
    ): array {
        if (empty($trackedKeywords)) {
            return [];
        }

        $related = [];

        // For each tracked keyword, get search hints (autocomplete suggestions)
        foreach (array_slice($trackedKeywords, 0, 8) as $kw) {
            $hints = $this->getSearchHints($kw, $country, $platform);
            foreach ($hints as $hint) {
                // Skip if same as original or already tracked
                if (strtolower($hint) === strtolower($kw)) continue;
                if (in_array(strtolower($hint), array_map('strtolower', $trackedKeywords))) continue;

                $related[$hint] = $kw;
            }
        }

        if (empty($related)) {
            return [];
        }

        // Enrich top related keywords
        $suggestions = [];
        $processed = 0;

        foreach ($related as $keyword => $basedOn) {
            if ($processed >= $limit) break;

            $metrics = $this->getKeywordMetrics($keyword, $country, $platform, null);

            $suggestions[] = [
                'keyword' => $keyword,
                'source' => 'related_expansion',
                'category' => 'related',
                'position' => null,
                'competition' => $metrics['competition'],
                'difficulty' => $metrics['difficulty'],
                'difficulty_label' => $metrics['difficulty_label'],
                'popularity' => null,
                'reason' => "Related to \"{$basedOn}\"",
                'based_on' => $basedOn,
                'competitor_name' => null,
                'top_competitors' => $metrics['top_competitors'],
            ];

            $processed++;
        }

        return $suggestions;
    }

    /**
     * Generate trending keywords in the app's category
     */
    private function generateTrending(
        App $app,
        string $country,
        string $platform,
        int $limit
    ): array {
        // Get top apps in the same category
        $categoryId = $app->category_id;
        if (!$categoryId) {
            return [];
        }

        $topApps = $platform === 'ios'
            ? $this->iTunesService->getTopApps($categoryId, strtolower($country), 'top_free', 20)
            : $this->googlePlayService->getTopApps($categoryId, strtolower($country), 'top_free', 20);

        if (empty($topApps)) {
            return [];
        }

        // Extract keywords from top app names
        $categoryKeywords = [];
        foreach ($topApps as $topApp) {
            $name = $topApp['name'] ?? '';
            $terms = $this->tokenize($name);
            foreach ($terms as $term) {
                if (strlen($term) >= 3) {
                    $categoryKeywords[$term] = ($categoryKeywords[$term] ?? 0) + 1;
                }
            }
        }

        // Sort by frequency
        arsort($categoryKeywords);
        $topTerms = array_slice(array_keys($categoryKeywords), 0, $limit * 2);

        // Get search hints for top terms
        $candidates = [];
        foreach ($topTerms as $term) {
            $hints = $this->getSearchHints($term, $country, $platform);
            foreach (array_slice($hints, 0, 3) as $hint) {
                $candidates[$hint] = $term;
            }
        }

        // Enrich
        $suggestions = [];
        $processed = 0;

        foreach ($candidates as $keyword => $basedOn) {
            if ($processed >= $limit) break;

            $metrics = $this->getKeywordMetrics($keyword, $country, $platform, $app->store_id);

            $suggestions[] = [
                'keyword' => $keyword,
                'source' => 'category_trending',
                'category' => 'trending',
                'position' => $metrics['position'],
                'competition' => $metrics['competition'],
                'difficulty' => $metrics['difficulty'],
                'difficulty_label' => $metrics['difficulty_label'],
                'popularity' => null,
                'reason' => "Trending in {$app->category_name}",
                'based_on' => null,
                'competitor_name' => null,
                'top_competitors' => $metrics['top_competitors'],
            ];

            $processed++;
        }

        return $suggestions;
    }

    /**
     * Validate keywords exist in search hints and enrich with metrics
     */
    private function validateAndEnrich(
        array $keywords,
        string $appStoreId,
        string $country,
        string $platform,
        string $category,
        int $limit
    ): array {
        $suggestions = [];
        $processed = 0;

        foreach ($keywords as $keyword) {
            if ($processed >= $limit) break;

            $metrics = $this->getKeywordMetrics($keyword, $country, $platform, $appStoreId);

            // Skip if no results (likely not a valid keyword)
            if ($metrics['competition'] === 0) continue;

            $reason = $metrics['position']
                ? "You rank #{$metrics['position']}, difficulty {$metrics['difficulty']}/100"
                : "Difficulty {$metrics['difficulty']}/100, untapped opportunity";

            $suggestions[] = [
                'keyword' => $keyword,
                'source' => 'search_hints',
                'category' => $category,
                'position' => $metrics['position'],
                'competition' => $metrics['competition'],
                'difficulty' => $metrics['difficulty'],
                'difficulty_label' => $metrics['difficulty_label'],
                'popularity' => null,
                'reason' => $reason,
                'based_on' => null,
                'competitor_name' => null,
                'top_competitors' => $metrics['top_competitors'],
            ];

            $processed++;
            usleep(100000); // 100ms delay
        }

        return $suggestions;
    }

    /**
     * Get keyword metrics from search results
     */
    private function getKeywordMetrics(
        string $keyword,
        string $country,
        string $platform,
        ?string $appStoreId
    ): array {
        $results = $platform === 'ios'
            ? $this->iTunesService->searchApps($keyword, strtolower($country), 50)
            : $this->googlePlayService->searchApps($keyword, strtolower($country), 50);

        // Find app position
        $position = null;
        if ($appStoreId) {
            foreach ($results as $result) {
                $resultId = $platform === 'ios'
                    ? ($result['apple_id'] ?? null)
                    : ($result['google_play_id'] ?? null);
                if ($resultId === $appStoreId) {
                    $position = $result['position'];
                    break;
                }
            }
        }

        // Calculate difficulty
        $difficulty = $this->calculateDifficulty($results);

        // Get top 3 competitors
        $topCompetitors = array_slice(array_map(fn($r) => [
            'name' => $r['name'],
            'position' => $r['position'],
            'rating' => $r['rating'] ?? null,
        ], $results), 0, 3);

        return [
            'position' => $position,
            'competition' => count($results),
            'difficulty' => $difficulty['score'],
            'difficulty_label' => $difficulty['label'],
            'top_competitors' => $topCompetitors,
        ];
    }

    /**
     * Calculate keyword difficulty score (0-100)
     */
    private function calculateDifficulty(array $searchResults): array
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

    /**
     * Get search hints (autocomplete) for a term
     */
    private function getSearchHints(string $term, string $country, string $platform): array
    {
        if ($platform === 'android') {
            // For Android, use Google Play suggestions via scraper
            return $this->getGooglePlayHints($term, $country);
        }

        // iOS: Apple Search Hints API
        $storeId = self::STORE_IDS[$country] ?? self::STORE_IDS['US'];
        $cacheKey = "hints_{$country}_" . md5($term);

        return Cache::remember($cacheKey, now()->addDay(), function () use ($term, $storeId) {
            try {
                $response = Http::timeout(10)
                    ->withHeaders(['X-Apple-Store-Front' => "{$storeId}-1,29"])
                    ->get(self::HINTS_URL, [
                        'clientApplication' => 'Software',
                        'term' => $term,
                    ]);

                if (!$response->successful()) {
                    return [];
                }

                preg_match_all('/<key>term<\/key>\s*<string>([^<]+)<\/string>/', $response->body(), $matches);
                return $matches[1] ?? [];
            } catch (\Exception $e) {
                return [];
            }
        });
    }

    /**
     * Get Google Play autocomplete suggestions
     */
    private function getGooglePlayHints(string $term, string $country): array
    {
        $cacheKey = "gplay_hints_{$country}_" . md5($term);

        return Cache::remember($cacheKey, now()->addDay(), function () use ($term, $country) {
            try {
                // Google Play autocomplete API
                $response = Http::timeout(10)->get('https://market.android.com/suggest/SuggRequest', [
                    'json' => 1,
                    'c' => 3, // Apps
                    'query' => $term,
                    'hl' => $country,
                ]);

                if (!$response->successful()) {
                    return [];
                }

                $data = $response->json();
                return collect($data)->pluck('s')->filter()->values()->toArray();
            } catch (\Exception $e) {
                return [];
            }
        });
    }

    /**
     * Get app details
     */
    private function getAppDetails(string $storeId, string $country, string $platform): ?array
    {
        return $platform === 'ios'
            ? $this->iTunesService->getAppDetails($storeId, strtolower($country))
            : $this->googlePlayService->getAppDetails($storeId, strtolower($country));
    }

    /**
     * Extract seed terms from app metadata
     */
    private function extractSeedTerms(array $appDetails): array
    {
        $seeds = [];

        // From app name
        if (!empty($appDetails['name'])) {
            $seeds = array_merge($seeds, $this->tokenize($appDetails['name']));
        }

        // From description (first 500 chars)
        if (!empty($appDetails['description'])) {
            $desc = substr($appDetails['description'], 0, 500);
            $descTerms = array_filter($this->tokenize($desc), fn($t) => strlen($t) >= 4);
            $seeds = array_merge($seeds, array_slice($descTerms, 0, 5));
        }

        return array_unique(array_map('strtolower', array_slice($seeds, 0, 10)));
    }

    /**
     * Tokenize text into meaningful terms
     */
    private function tokenize(string $text): array
    {
        $text = preg_replace('/[^a-zA-Z\s]/', ' ', $text);
        $text = strtolower(trim($text));
        $words = preg_split('/\s+/', $text, -1, PREG_SPLIT_NO_EMPTY);

        $stopWords = ['the', 'and', 'for', 'with', 'your', 'you', 'from', 'that', 'this', 'are', 'was', 'have', 'has', 'will', 'can', 'app', 'new'];

        return array_values(array_filter($words, fn($w) => strlen($w) >= 3 && !in_array($w, $stopWords)));
    }
}
