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

    /**
     * Get keyword suggestions for an app
     */
    public function getSuggestionsForApp(string $appId, string $country = 'US', int $limit = 50): array
    {
        $country = strtoupper($country);
        $countryLower = strtolower($country);
        $cacheKey = "suggestions_{$appId}_{$country}";

        return Cache::remember($cacheKey, now()->addHours(12), function () use ($appId, $country, $countryLower, $limit) {

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
        });
    }
}
