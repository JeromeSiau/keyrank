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
     * Get app rank for a single keyword
     */
    public function getAppRankForKeyword(string $appId, string $keyword, string $country = 'us'): ?int
    {
        $rankings = $this->getRankingsForKeywords($appId, [$keyword], $country);

        return $rankings[$keyword] ?? null;
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
