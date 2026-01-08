<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Cache;

class iTunesService
{
    private const SEARCH_URL = 'https://itunes.apple.com/search';
    private const LOOKUP_URL = 'https://itunes.apple.com/lookup';

    /**
     * Search for apps on the App Store
     *
     * @param string $term Search term
     * @param string $country Country code (us, fr, gb, etc.)
     * @param int $limit Max results (1-200)
     * @return array
     */
    public function searchApps(string $term, string $country = 'us', int $limit = 100): array
    {
        $cacheKey = "itunes_search_{$country}_" . md5($term) . "_{$limit}";

        return Cache::remember($cacheKey, now()->addHour(), function () use ($term, $country, $limit) {
            $response = Http::timeout(30)->get(self::SEARCH_URL, [
                'term' => $term,
                'country' => $country,
                'media' => 'software',
                'limit' => min($limit, 200),
            ]);

            if (!$response->successful()) {
                return [];
            }

            $results = $response->json('results', []);

            return collect($results)->map(fn($app, $index) => $this->formatAppResult($app, $index + 1))->toArray();
        });
    }

    /**
     * Get app details by Apple ID
     *
     * @param string $appleId
     * @param string $country
     * @return array|null
     */
    public function getAppDetails(string $appleId, string $country = 'us'): ?array
    {
        $cacheKey = "itunes_app_{$appleId}_{$country}";

        return Cache::remember($cacheKey, now()->addDay(), function () use ($appleId, $country) {
            $response = Http::timeout(30)->get(self::LOOKUP_URL, [
                'id' => $appleId,
                'country' => $country,
            ]);

            if (!$response->successful()) {
                return null;
            }

            $results = $response->json('results', []);

            if (empty($results)) {
                return null;
            }

            return $this->formatAppDetails($results[0]);
        });
    }

    /**
     * Get multiple apps by their Apple IDs
     *
     * @param array $appleIds
     * @param string $country
     * @return array
     */
    public function getMultipleApps(array $appleIds, string $country = 'us'): array
    {
        if (empty($appleIds)) {
            return [];
        }

        $ids = implode(',', $appleIds);
        $cacheKey = "itunes_apps_" . md5($ids) . "_{$country}";

        return Cache::remember($cacheKey, now()->addDay(), function () use ($ids, $country) {
            $response = Http::timeout(30)->get(self::LOOKUP_URL, [
                'id' => $ids,
                'country' => $country,
            ]);

            if (!$response->successful()) {
                return [];
            }

            $results = $response->json('results', []);

            return collect($results)->map(fn($app) => $this->formatAppDetails($app))->keyBy('apple_id')->toArray();
        });
    }

    /**
     * Find the ranking position of an app for a specific keyword
     *
     * @param string $appleId
     * @param string $keyword
     * @param string $country
     * @return int|null Position (1-200) or null if not found
     */
    public function getAppRankForKeyword(string $appleId, string $keyword, string $country = 'us'): ?int
    {
        $apps = $this->searchApps($keyword, $country, 200);

        foreach ($apps as $app) {
            if ($app['apple_id'] === $appleId) {
                return $app['position'];
            }
        }

        return null; // Not in top 200
    }

    /**
     * Get rankings for multiple keywords for a specific app
     *
     * @param string $appleId
     * @param array $keywords
     * @param string $country
     * @return array [keyword => position|null]
     */
    public function getAppRankingsForKeywords(string $appleId, array $keywords, string $country = 'us'): array
    {
        $rankings = [];

        foreach ($keywords as $keyword) {
            $rankings[$keyword] = $this->getAppRankForKeyword($appleId, $keyword, $country);

            // Small delay to avoid rate limiting
            usleep(200000); // 0.2 seconds
        }

        return $rankings;
    }

    /**
     * Format app result from search
     */
    private function formatAppResult(array $app, int $position): array
    {
        return [
            'position' => $position,
            'apple_id' => (string) $app['trackId'],
            'name' => $app['trackName'],
            'bundle_id' => $app['bundleId'] ?? null,
            'icon_url' => $app['artworkUrl100'] ?? null,
            'developer' => $app['artistName'] ?? null,
            'price' => $app['price'] ?? 0,
            'rating' => $app['averageUserRating'] ?? null,
            'rating_count' => $app['userRatingCount'] ?? 0,
        ];
    }

    /**
     * Format detailed app info
     */
    private function formatAppDetails(array $app): array
    {
        return [
            'apple_id' => (string) $app['trackId'],
            'name' => $app['trackName'],
            'bundle_id' => $app['bundleId'] ?? null,
            'icon_url' => $app['artworkUrl512'] ?? $app['artworkUrl100'] ?? null,
            'developer' => $app['artistName'] ?? null,
            'description' => $app['description'] ?? null,
            'price' => $app['price'] ?? 0,
            'currency' => $app['currency'] ?? 'USD',
            'rating' => $app['averageUserRating'] ?? null,
            'rating_count' => $app['userRatingCount'] ?? 0,
            'version' => $app['version'] ?? null,
            'release_date' => $app['releaseDate'] ?? null,
            'updated_date' => $app['currentVersionReleaseDate'] ?? null,
            'size_bytes' => $app['fileSizeBytes'] ?? null,
            'minimum_os' => $app['minimumOsVersion'] ?? null,
            'genres' => $app['genres'] ?? [],
            'screenshots' => $app['screenshotUrls'] ?? [],
            'store_url' => $app['trackViewUrl'] ?? null,
        ];
    }

    /**
     * Get ratings for an app across multiple countries
     *
     * @param string $appleId
     * @param array|null $countries List of country codes, or null for all supported countries
     * @return array [country => ['rating' => float|null, 'rating_count' => int]]
     */
    public function getAppRatingsForCountries(string $appleId, ?array $countries = null): array
    {
        $countries = $countries ?? array_keys(self::getSupportedCountries());
        $ratings = [];

        foreach ($countries as $country) {
            $cacheKey = "itunes_rating_{$appleId}_{$country}";

            $data = Cache::remember($cacheKey, now()->addHours(6), function () use ($appleId, $country) {
                $response = Http::timeout(10)->get(self::LOOKUP_URL, [
                    'id' => $appleId,
                    'country' => $country,
                ]);

                if (!$response->successful()) {
                    return null;
                }

                $results = $response->json('results', []);

                if (empty($results)) {
                    return null;
                }

                $app = $results[0];

                return [
                    'rating' => $app['averageUserRating'] ?? null,
                    'rating_count' => $app['userRatingCount'] ?? 0,
                ];
            });

            if ($data !== null && $data['rating_count'] > 0) {
                $ratings[$country] = $data;
            }

            // Small delay to avoid rate limiting
            usleep(100000); // 0.1 seconds
        }

        return $ratings;
    }

    /**
     * Get customer reviews for an app from a specific country
     *
     * @param string $appleId
     * @param string $country
     * @param int $page (1-10, max 50 reviews per page)
     * @return array
     */
    public function getAppReviews(string $appleId, string $country = 'us', int $page = 1): array
    {
        $page = max(1, min(10, $page)); // Apple limits to pages 1-10
        $cacheKey = "itunes_reviews_{$appleId}_{$country}_{$page}";

        return Cache::remember($cacheKey, now()->addHours(6), function () use ($appleId, $country, $page) {
            $url = "https://itunes.apple.com/{$country}/rss/customerreviews/page={$page}/id={$appleId}/sortby=mostrecent/json";

            $response = Http::timeout(15)->get($url);

            if (!$response->successful()) {
                return [];
            }

            $feed = $response->json('feed', []);
            $entries = $feed['entry'] ?? [];

            // iTunes returns object instead of array when there's only one entry
            // Normalize to always be an array of entries
            if (!empty($entries) && !isset($entries[0])) {
                $entries = [$entries];
            }

            // First entry is app info, skip it
            if (!empty($entries) && isset($entries[0]['im:name'])) {
                array_shift($entries);
            }

            return collect($entries)->map(fn($entry) => $this->formatReview($entry, $country))->filter()->values()->toArray();
        });
    }

    /**
     * Get all reviews for an app from a specific country (up to 500)
     *
     * @param string $appleId
     * @param string $country
     * @param int $maxPages (1-10)
     * @return array
     */
    public function getAllAppReviews(string $appleId, string $country = 'us', int $maxPages = 5): array
    {
        $allReviews = [];

        for ($page = 1; $page <= min(10, $maxPages); $page++) {
            $reviews = $this->getAppReviews($appleId, $country, $page);

            if (empty($reviews)) {
                break; // No more reviews
            }

            $allReviews = array_merge($allReviews, $reviews);

            // Small delay to avoid rate limiting
            usleep(100000); // 0.1 seconds
        }

        return $allReviews;
    }

    /**
     * Format a review entry from RSS feed
     */
    private function formatReview(array $entry, string $country): ?array
    {
        if (!isset($entry['author']['name']['label'])) {
            return null;
        }

        return [
            'review_id' => $entry['id']['label'] ?? null,
            'author' => $entry['author']['name']['label'],
            'title' => $entry['title']['label'] ?? null,
            'content' => $entry['content']['label'] ?? '',
            'rating' => (int) ($entry['im:rating']['label'] ?? 0),
            'version' => $entry['im:version']['label'] ?? null,
            'reviewed_at' => isset($entry['updated']['label'])
                ? date('Y-m-d H:i:s', strtotime($entry['updated']['label']))
                : null,
            'country' => strtoupper($country),
        ];
    }

    /**
     * Get list of supported country codes
     */
    public static function getSupportedCountries(): array
    {
        return [
            'us' => 'United States',
            'gb' => 'United Kingdom',
            'fr' => 'France',
            'de' => 'Germany',
            'jp' => 'Japan',
            'cn' => 'China',
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
}
