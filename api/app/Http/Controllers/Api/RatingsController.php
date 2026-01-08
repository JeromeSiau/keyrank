<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppRating;
use App\Services\iTunesService;
use App\Services\GooglePlayService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class RatingsController extends Controller
{
    public function __construct(
        private iTunesService $iTunesService,
        private GooglePlayService $googlePlayService
    ) {}

    /**
     * Get ratings for an app across all countries
     * Auto-fetches from stores if data is stale (> 24h)
     */
    public function forApp(Request $request, App $app): JsonResponse
    {
        // Check ownership
        if ($app->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // Auto-fetch if stale
        $this->fetchRatingsIfStale($app);

        // Get latest ratings from database
        $latestRatings = $app->latestRatings()
            ->orderByDesc('rating_count')
            ->get();

        // Calculate totals
        $totalRatings = $latestRatings->sum('rating_count');
        $weightedSum = $latestRatings->sum(fn($r) => ($r->rating ?? 0) * $r->rating_count);
        $averageRating = $totalRatings > 0 ? round($weightedSum / $totalRatings, 2) : null;

        return response()->json([
            'app_id' => $app->id,
            'platform' => $app->platform,
            'total_ratings' => $totalRatings,
            'average_rating' => $averageRating,
            'ratings' => $latestRatings->map(fn($r) => [
                'country' => $r->country,
                'rating' => $r->rating,
                'rating_count' => $r->rating_count,
                'recorded_at' => $r->recorded_at->toIso8601String(),
            ])->values(),
            'last_updated' => $latestRatings->max('recorded_at')?->toIso8601String(),
        ]);
    }

    /**
     * Fetch ratings if data is stale (> 24h)
     */
    private function fetchRatingsIfStale(App $app): void
    {
        // Check if we've fetched within the last 24 hours
        if ($app->ratings_fetched_at && $app->ratings_fetched_at->gt(now()->subHours(24))) {
            return;
        }

        // Fetch fresh ratings based on app's platform
        if ($app->platform === 'ios') {
            $this->fetchAndStoreIosRatings($app);
        } else {
            $this->fetchAndStoreAndroidRatings($app);
        }

        // Update fetch timestamp
        $app->update(['ratings_fetched_at' => now()]);
    }

    /**
     * Fetch ratings from iTunes and store in database
     */
    private function fetchAndStoreIosRatings(App $app): void
    {
        // Priority countries from config
        $priorityCountries = config('app.priority_countries');

        $now = now();
        $storeId = $app->store_id;

        // Fetch all countries in parallel using Http::pool
        $responses = Http::pool(fn ($pool) =>
            collect($priorityCountries)->map(fn ($country) =>
                $pool->as($country)
                    ->timeout(5)
                    ->get('https://itunes.apple.com/lookup', [
                        'id' => $storeId,
                        'country' => $country,
                    ])
            )->toArray()
        );

        // Process responses
        foreach ($priorityCountries as $country) {
            $response = $responses[$country] ?? null;

            if ($response && $response->successful()) {
                $results = $response->json('results', []);

                if (!empty($results)) {
                    $appData = $results[0];
                    $ratingCount = $appData['userRatingCount'] ?? 0;

                    if ($ratingCount > 0) {
                        AppRating::create([
                            'app_id' => $app->id,
                            'country' => strtoupper($country),
                            'rating' => $appData['averageUserRating'] ?? null,
                            'rating_count' => $ratingCount,
                            'recorded_at' => $now,
                        ]);
                    }
                }
            }
        }
    }

    /**
     * Fetch ratings from Google Play and store in database
     */
    private function fetchAndStoreAndroidRatings(App $app): void
    {
        // Priority countries from config
        $priorityCountries = config('app.priority_countries');

        $now = now();
        $storeId = $app->store_id;
        $scraperUrl = config('services.gplay_scraper.url', 'http://localhost:3001');

        // Fetch all countries in parallel using Http::pool
        $responses = Http::pool(fn ($pool) =>
            collect($priorityCountries)->map(fn ($country) =>
                $pool->as($country)
                    ->timeout(10)
                    ->get("{$scraperUrl}/app/{$storeId}", [
                        'country' => $country,
                    ])
            )->toArray()
        );

        // Process responses
        foreach ($priorityCountries as $country) {
            $response = $responses[$country] ?? null;

            if ($response && $response->successful()) {
                $appData = $response->json();

                if ($appData) {
                    $ratingCount = $appData['rating_count'] ?? 0;

                    if ($ratingCount > 0) {
                        AppRating::create([
                            'app_id' => $app->id,
                            'country' => strtoupper($country),
                            'rating' => $appData['rating'] ?? null,
                            'rating_count' => $ratingCount,
                            'recorded_at' => $now,
                        ]);
                    }
                }
            }
        }
    }

    /**
     * Get rating history for a specific country
     */
    public function history(Request $request, App $app): JsonResponse
    {
        // Check ownership
        if ($app->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $validated = $request->validate([
            'country' => 'required|string|size:2',
            'days' => 'nullable|integer|min:1|max:365',
        ]);

        $country = strtoupper($validated['country']);
        $days = $validated['days'] ?? 30;

        $history = $app->ratings()
            ->where('country', $country)
            ->where('recorded_at', '>=', now()->subDays($days))
            ->orderBy('recorded_at')
            ->get();

        return response()->json([
            'app_id' => $app->id,
            'country' => $country,
            'platform' => $app->platform,
            'history' => $history->map(fn($r) => [
                'rating' => $r->rating,
                'rating_count' => $r->rating_count,
                'recorded_at' => $r->recorded_at->toIso8601String(),
            ]),
        ]);
    }
}
