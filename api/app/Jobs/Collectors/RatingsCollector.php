<?php

namespace App\Jobs\Collectors;

use App\Models\App;
use App\Models\AppRating;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class RatingsCollector extends BaseCollector
{
    protected int $rateLimitMs = 200;
    public int $timeout = 7200; // 2 hours

    public function getCollectorName(): string
    {
        return 'RatingsCollector';
    }

    /**
     * Get all apps that need rating updates
     */
    public function getItems(): Collection
    {
        return App::select(['id', 'platform', 'store_id'])
            ->whereHas('users') // Only apps that are being tracked by at least one user
            ->get();
    }

    /**
     * Process a single app - fetch ratings for known countries
     * Uses countries already in DB, with weekly full rescan to discover new countries
     */
    public function processItem(mixed $item): void
    {
        $app = $item;

        // Check if we need a full rescan (weekly, or no data yet)
        $lastFullScan = AppRating::where('app_id', $app->id)
            ->max('recorded_at');

        $needsFullScan = !$lastFullScan || $lastFullScan < now()->subWeek();

        if ($needsFullScan) {
            // Full scan: query all countries to discover new availability
            $countries = config('countries');
        } else {
            // Use countries we already have data for
            $countries = AppRating::where('app_id', $app->id)
                ->distinct()
                ->pluck('country')
                ->map(fn($c) => strtolower($c))
                ->toArray();
        }

        if ($app->platform === 'ios') {
            $this->fetchIosRatings($app, $countries);
        } else {
            $this->fetchAndroidRatings($app, $countries);
        }
    }

    /**
     * Fetch iOS ratings from iTunes API
     */
    private function fetchIosRatings(App $app, array $countries): void
    {
        $now = now();

        // Fetch all countries in parallel using Http::pool
        $responses = Http::pool(fn ($pool) =>
            collect($countries)->map(fn ($country) =>
                $pool->as($country)
                    ->timeout(10)
                    ->get('https://itunes.apple.com/lookup', [
                        'id' => $app->store_id,
                        'country' => $country,
                    ])
            )->toArray()
        );

        $ratings = [];

        foreach ($countries as $country) {
            $response = $responses[$country] ?? null;

            if ($response && $response->successful()) {
                $results = $response->json('results', []);

                if (!empty($results)) {
                    $appData = $results[0];
                    $ratingCount = $appData['userRatingCount'] ?? 0;

                    if ($ratingCount > 0) {
                        $ratings[] = [
                            'app_id' => $app->id,
                            'country' => strtoupper($country),
                            'rating' => $appData['averageUserRating'] ?? null,
                            'rating_count' => $ratingCount,
                            'recorded_at' => $now,
                        ];
                    }
                }
            }
        }

        if (!empty($ratings)) {
            AppRating::upsert(
                $ratings,
                ['app_id', 'country', 'recorded_at'],
                ['rating', 'rating_count']
            );
        }
    }

    /**
     * Fetch Android ratings from Google Play scraper
     */
    private function fetchAndroidRatings(App $app, array $countries): void
    {
        $now = now();
        $scraperUrl = config('services.gplay_scraper.url', 'http://localhost:3001');

        // Fetch all countries in parallel using Http::pool
        $responses = Http::pool(fn ($pool) =>
            collect($countries)->map(fn ($country) =>
                $pool->as($country)
                    ->timeout(15)
                    ->get("{$scraperUrl}/app/{$app->store_id}", [
                        'country' => $country,
                    ])
            )->toArray()
        );

        $ratings = [];

        foreach ($countries as $country) {
            $response = $responses[$country] ?? null;

            if ($response && $response->successful()) {
                $appData = $response->json();

                if ($appData) {
                    $ratingCount = $appData['rating_count'] ?? $appData['ratings'] ?? 0;

                    if ($ratingCount > 0) {
                        $ratings[] = [
                            'app_id' => $app->id,
                            'country' => strtoupper($country),
                            'rating' => $appData['rating'] ?? $appData['score'] ?? null,
                            'rating_count' => $ratingCount,
                            'recorded_at' => $now,
                        ];
                    }
                }
            }
        }

        if (!empty($ratings)) {
            AppRating::upsert(
                $ratings,
                ['app_id', 'country', 'recorded_at'],
                ['rating', 'rating_count']
            );
        }
    }

    protected function getItemIdentifier(mixed $item): string
    {
        return "app:{$item->id}";
    }
}
