<?php

namespace App\Jobs\Collectors;

use App\Models\App;
use App\Models\AppReview;
use App\Services\iTunesService;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Http;
use Carbon\Carbon;

class ReviewsCollector extends BaseCollector
{
    protected int $rateLimitMs = 300;
    public int $timeout = 10800; // 3 hours

    private iTunesService $iTunesService;

    public function __construct()
    {
        parent::__construct();
        $this->iTunesService = app(iTunesService::class);
    }

    public function getCollectorName(): string
    {
        return 'ReviewsCollector';
    }

    /**
     * Get all apps that need review updates
     */
    public function getItems(): Collection
    {
        return App::select(['id', 'platform', 'store_id'])
            ->whereHas('teams')
            ->get();
    }

    /**
     * Process a single app - fetch reviews for known countries
     * Uses countries already in DB, with weekly full rescan to discover new countries
     */
    public function processItem(mixed $item): void
    {
        $app = $item;

        // Check if we need a full rescan (weekly, or no data yet)
        $lastFullScan = AppReview::where('app_id', $app->id)
            ->max('reviewed_at');

        $needsFullScan = !$lastFullScan || $lastFullScan < now()->subWeek();

        if ($needsFullScan) {
            // Full scan: query all countries to discover new availability
            $countries = config('countries');
        } else {
            // Use countries we already have data for
            $countries = AppReview::where('app_id', $app->id)
                ->distinct()
                ->pluck('country')
                ->map(fn($c) => strtolower($c))
                ->toArray();
        }

        foreach ($countries as $country) {
            if ($app->platform === 'ios') {
                $this->fetchIosReviews($app, $country);
            } else {
                $this->fetchAndroidReviews($app, $country);
            }

            // Rate limit between countries
            usleep($this->rateLimitMs * 1000);
        }
    }

    /**
     * Fetch iOS reviews from iTunes RSS
     */
    private function fetchIosReviews(App $app, string $country): void
    {
        $reviews = $this->iTunesService->getAllAppReviews($app->store_id, strtolower($country), 5);

        if (empty($reviews)) {
            return;
        }

        $now = now();
        $rows = [];

        foreach ($reviews as $review) {
            $rows[] = [
                'app_id' => $app->id,
                'country' => strtoupper($country),
                'review_id' => $review['review_id'],
                'author' => $review['author'],
                'title' => $review['title'],
                'content' => $review['content'],
                'rating' => $review['rating'],
                'version' => $review['version'],
                'reviewed_at' => $review['reviewed_at'],
                'created_at' => $now,
                'updated_at' => $now,
            ];
        }

        AppReview::upsert(
            $rows,
            ['app_id', 'country', 'review_id'],
            ['author', 'title', 'content', 'rating', 'version', 'reviewed_at', 'updated_at']
        );
    }

    /**
     * Fetch Android reviews from Google Play scraper
     */
    private function fetchAndroidReviews(App $app, string $country): void
    {
        $scraperUrl = config('services.gplay_scraper.url', 'http://localhost:3001');

        try {
            $response = Http::timeout(20)
                ->get("{$scraperUrl}/reviews/{$app->store_id}", [
                    'country' => strtolower($country),
                    'num' => 100,
                ]);

            if (!$response->successful()) {
                return;
            }

            $reviews = $response->json('reviews', []);

            if (empty($reviews)) {
                return;
            }

            $now = now();
            $rows = [];

            foreach ($reviews as $review) {
                $reviewId = $review['review_id'] ?? $review['id'] ?? sha1(implode('|', [
                    $app->store_id,
                    $country,
                    $review['author'] ?? '',
                    $review['rating'] ?? '',
                    $review['reviewed_at'] ?? $review['date'] ?? '',
                    substr($review['content'] ?? $review['text'] ?? '', 0, 100),
                ]));

                $rows[] = [
                    'app_id' => $app->id,
                    'country' => strtoupper($country),
                    'review_id' => $reviewId,
                    'author' => $review['author'] ?? $review['userName'] ?? 'Anonymous',
                    'title' => $review['title'] ?? null,
                    'content' => $review['content'] ?? $review['text'] ?? '',
                    'rating' => $review['rating'] ?? $review['score'] ?? 0,
                    'version' => $review['version'] ?? $review['appVersion'] ?? null,
                    'reviewed_at' => isset($review['reviewed_at'])
                        ? Carbon::parse($review['reviewed_at'])
                        : (isset($review['date']) ? Carbon::parse($review['date']) : $now),
                    'created_at' => $now,
                    'updated_at' => $now,
                ];
            }

            AppReview::upsert(
                $rows,
                ['app_id', 'country', 'review_id'],
                ['author', 'title', 'content', 'rating', 'version', 'reviewed_at', 'updated_at']
            );
        } catch (\Exception $e) {
            \Log::warning("Failed to fetch Android reviews for app {$app->id}: " . $e->getMessage());
        }
    }

    protected function getItemIdentifier(mixed $item): string
    {
        return "app:{$item->id}";
    }
}
