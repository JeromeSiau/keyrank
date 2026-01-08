<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppReview;
use App\Services\iTunesService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class ReviewsController extends Controller
{
    public function __construct(
        private iTunesService $iTunesService
    ) {}

    /**
     * Get reviews for an app from a specific country
     * Auto-fetches from store if data is stale (> 24h) or missing
     */
    public function forCountry(Request $request, App $app, string $country): JsonResponse
    {
        // Check ownership
        if ($app->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $country = strtoupper($country);
        $platform = $app->platform;

        if (!$platform) {
            return response()->json(['message' => 'App has no platform'], 400);
        }

        // Get stored reviews for this country
        $reviews = $app->reviews()
            ->where('country', $country)
            ->orderByDesc('reviewed_at')
            ->limit(100)
            ->get();

        // Check if data is stale
        $lastFetch = $app->reviews_fetched_at;
        $isStale = !$lastFetch || $lastFetch->lt(now()->subHours(24));
        $hasAnyReviews = $app->reviews()->exists();
        $hasReviewsForCountry = $reviews->isNotEmpty();

        // Fetch if:
        // 1. Never fetched OR stale (> 24h) → always fetch
        // 2. We have reviews for OTHER countries but not this one → fetch this country
        $shouldFetch = $isStale || ($hasAnyReviews && !$hasReviewsForCountry);

        if ($shouldFetch) {
            if ($platform === 'ios') {
                $this->fetchAndStoreIosReviews($app, $country);
            } else {
                $this->fetchAndStoreAndroidReviews($app, $country);
            }

            // Only update timestamp on stale refresh (not per-country fills)
            if ($isStale) {
                $app->update(['reviews_fetched_at' => now()]);
            }

            // Re-fetch reviews after storing
            $reviews = $app->reviews()
                ->where('country', $country)
                ->orderByDesc('reviewed_at')
                ->limit(100)
                ->get();
        }

        return response()->json([
            'app_id' => $app->id,
            'platform' => $platform,
            'country' => $country,
            'reviews' => $reviews->map(fn($r) => [
                'id' => $r->id,
                'author' => $r->author,
                'title' => $r->title,
                'content' => $r->content,
                'rating' => $r->rating,
                'version' => $r->version,
                'reviewed_at' => $r->reviewed_at->toIso8601String(),
            ]),
            'total' => $reviews->count(),
        ]);
    }

    /**
     * Fetch reviews from iTunes and store in database
     */
    private function fetchAndStoreIosReviews(App $app, string $country): void
    {
        $countryLower = strtolower($country);
        $reviews = $this->iTunesService->getAllAppReviews($app->store_id, $countryLower, 5);

        foreach ($reviews as $review) {
            AppReview::updateOrCreate(
                [
                    'app_id' => $app->id,
                    'country' => strtoupper($country),
                    'review_id' => $review['review_id'],
                ],
                [
                    'author' => $review['author'],
                    'title' => $review['title'],
                    'content' => $review['content'],
                    'rating' => $review['rating'],
                    'version' => $review['version'],
                    'reviewed_at' => $review['reviewed_at'],
                ]
            );
        }
    }

    /**
     * Fetch reviews from Google Play and store in database
     */
    private function fetchAndStoreAndroidReviews(App $app, string $country): void
    {
        $countryLower = strtolower($country);
        $scraperUrl = config('services.gplay_scraper.url', 'http://localhost:3001');

        try {
            $response = Http::timeout(15)
                ->get("{$scraperUrl}/reviews/{$app->store_id}", [
                    'country' => $countryLower,
                    'num' => 100,
                ]);

            if ($response->successful()) {
                $reviews = $response->json('reviews', []);

                foreach ($reviews as $review) {
                    AppReview::updateOrCreate(
                        [
                            'app_id' => $app->id,
                            'country' => strtoupper($country),
                            'review_id' => $review['review_id'] ?? uniqid(),
                        ],
                        [
                            'author' => $review['author'] ?? 'Anonymous',
                            'title' => $review['title'] ?? null,
                            'content' => $review['content'] ?? '',
                            'rating' => $review['rating'] ?? 0,
                            'version' => $review['version'] ?? null,
                            'reviewed_at' => isset($review['reviewed_at']) ? \Carbon\Carbon::parse($review['reviewed_at']) : now(),
                        ]
                    );
                }
            }
        } catch (\Exception $e) {
            \Log::warning("Failed to fetch Android reviews for app {$app->id}: " . $e->getMessage());
        }
    }

    /**
     * Get review counts summary for all countries
     */
    public function summary(Request $request, App $app): JsonResponse
    {
        // Check ownership
        if ($app->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $platform = $app->platform;

        if (!$platform) {
            return response()->json(['message' => 'App has no platform'], 400);
        }

        $summary = $app->reviews()
            ->selectRaw('country, COUNT(*) as review_count, AVG(rating) as avg_rating, MAX(reviewed_at) as latest_review')
            ->groupBy('country')
            ->orderByDesc('review_count')
            ->get();

        return response()->json([
            'app_id' => $app->id,
            'platform' => $platform,
            'countries' => $summary->map(fn($s) => [
                'country' => $s->country,
                'review_count' => (int) $s->review_count,
                'avg_rating' => round((float) $s->avg_rating, 2),
                'latest_review' => $s->latest_review,
            ]),
        ]);
    }
}
