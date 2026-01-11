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
     * Get keyword suggestions for an app
     */
    public function getSuggestionsForApp(string $appId, string $country = 'US', int $limit = 50): array
    {
        $country = strtoupper($country);
        $cacheKey = "gplay_suggestions_{$appId}_{$country}";

        return Cache::remember($cacheKey, now()->addHours(12), function () use ($appId, $country, $limit) {
            $response = Http::timeout(180)->get("{$this->scraperUrl}/suggestions/app/{$appId}", [
                'country' => strtolower($country),
                'limit' => min($limit, 100),
            ]);

            if (!$response->successful()) {
                return [];
            }

            return $response->json();
        });
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

    /**
     * Get top apps for a category
     *
     * @param string $categoryId Category ID (e.g., "GAME", "BUSINESS")
     * @param string $country Country code
     * @param string $collection "top_free" or "top_paid"
     * @param int $limit Max results
     * @return array
     */
    public function getTopApps(string $categoryId, string $country = 'us', string $collection = 'top_free', int $limit = 100): array
    {
        $cacheKey = "gplay_top_{$collection}_{$categoryId}_{$country}_{$limit}";

        return Cache::remember($cacheKey, now()->addHour(), function () use ($categoryId, $country, $collection, $limit) {
            $response = Http::timeout(60)->get("{$this->scraperUrl}/top", [
                'category' => $categoryId,
                'country' => $country,
                'collection' => $collection,
                'num' => min($limit, 200),
            ]);

            if (!$response->successful()) {
                return [];
            }

            return $response->json('results', []);
        });
    }

    /**
     * Get list of supported country codes for Google Play
     * Google Play supports most countries, using same ISO codes as App Store
     */
    public static function getSupportedCountries(): array
    {
        return [
            'us' => 'United States',
            'gb' => 'United Kingdom',
            'fr' => 'France',
            'de' => 'Germany',
            'jp' => 'Japan',
            'kr' => 'South Korea',
            'au' => 'Australia',
            'ca' => 'Canada',
            'it' => 'Italy',
            'es' => 'Spain',
            'nl' => 'Netherlands',
            'br' => 'Brazil',
            'mx' => 'Mexico',
            'ru' => 'Russia',
            'in' => 'India',
            'se' => 'Sweden',
            'no' => 'Norway',
            'dk' => 'Denmark',
            'fi' => 'Finland',
            'ch' => 'Switzerland',
            'at' => 'Austria',
            'be' => 'Belgium',
            'pt' => 'Portugal',
            'pl' => 'Poland',
            'sg' => 'Singapore',
            'hk' => 'Hong Kong',
            'tw' => 'Taiwan',
            'th' => 'Thailand',
            'id' => 'Indonesia',
            'my' => 'Malaysia',
            'ph' => 'Philippines',
            'vn' => 'Vietnam',
            'za' => 'South Africa',
            'ae' => 'United Arab Emirates',
            'sa' => 'Saudi Arabia',
            'tr' => 'Turkey',
            'il' => 'Israel',
            'eg' => 'Egypt',
            'ar' => 'Argentina',
            'cl' => 'Chile',
            'co' => 'Colombia',
            'pe' => 'Peru',
            'nz' => 'New Zealand',
        ];
    }

    /**
     * Get available Android app categories
     *
     * @return array
     */
    public static function getCategories(): array
    {
        return [
            'APPLICATION' => 'All Apps',
            'ART_AND_DESIGN' => 'Art & Design',
            'AUTO_AND_VEHICLES' => 'Auto & Vehicles',
            'BEAUTY' => 'Beauty',
            'BOOKS_AND_REFERENCE' => 'Books & Reference',
            'BUSINESS' => 'Business',
            'COMICS' => 'Comics',
            'COMMUNICATION' => 'Communication',
            'DATING' => 'Dating',
            'EDUCATION' => 'Education',
            'ENTERTAINMENT' => 'Entertainment',
            'EVENTS' => 'Events',
            'FINANCE' => 'Finance',
            'FOOD_AND_DRINK' => 'Food & Drink',
            'GAME' => 'Games',
            'HEALTH_AND_FITNESS' => 'Health & Fitness',
            'HOUSE_AND_HOME' => 'House & Home',
            'LIBRARIES_AND_DEMO' => 'Libraries & Demo',
            'LIFESTYLE' => 'Lifestyle',
            'MAPS_AND_NAVIGATION' => 'Maps & Navigation',
            'MEDICAL' => 'Medical',
            'MUSIC_AND_AUDIO' => 'Music & Audio',
            'NEWS_AND_MAGAZINES' => 'News & Magazines',
            'PARENTING' => 'Parenting',
            'PERSONALIZATION' => 'Personalization',
            'PHOTOGRAPHY' => 'Photography',
            'PRODUCTIVITY' => 'Productivity',
            'SHOPPING' => 'Shopping',
            'SOCIAL' => 'Social',
            'SPORTS' => 'Sports',
            'TOOLS' => 'Tools',
            'TRAVEL_AND_LOCAL' => 'Travel & Local',
            'VIDEO_PLAYERS' => 'Video Players & Editors',
            'WEATHER' => 'Weather',
        ];
    }
}
