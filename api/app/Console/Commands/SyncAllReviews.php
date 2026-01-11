<?php

namespace App\Console\Commands;

use App\Models\App;
use App\Models\AppRating;
use App\Models\AppReview;
use App\Services\iTunesService;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class SyncAllReviews extends Command
{
    protected $signature = 'reviews:sync-all
        {--app= : Sync for specific app ID}
        {--platform= : Sync only ios or android}
        {--limit= : Limit number of apps to process}';

    protected $description = 'Sync reviews from iTunes/Google Play for all apps and their tracked countries';

    private const RATE_LIMIT_MS = 500;

    public function __construct(
        private iTunesService $iTunesService
    ) {
        parent::__construct();
    }

    public function handle(): int
    {
        $appId = $this->option('app');
        $platform = $this->option('platform');
        $limit = $this->option('limit');

        // Build query
        $query = App::query();

        if ($appId) {
            $query->where('id', $appId);
        }

        if ($platform) {
            $query->where('platform', $platform);
        }

        if ($limit) {
            $query->limit((int) $limit);
        }

        $apps = $query->get();

        if ($apps->isEmpty()) {
            $this->info('No apps found.');
            return Command::SUCCESS;
        }

        $this->info("Syncing reviews for {$apps->count()} apps...");

        $totalSynced = 0;
        $totalErrors = 0;

        $defaultCountries = config('app.priority_countries', ['us', 'gb', 'fr', 'de', 'au', 'br', 'mx', 'jp', 'cn', 'kr']);

        foreach ($apps as $app) {
            $this->newLine();

            // Get tracked countries for this app from ratings table
            $trackedCountries = AppRating::where('app_id', $app->id)
                ->distinct()
                ->pluck('country')
                ->map(fn($c) => strtolower($c))
                ->toArray();

            // Fallback to default countries if no ratings exist yet
            if (empty($trackedCountries)) {
                $trackedCountries = $defaultCountries;
            }

            $this->line("Processing: {$app->name} ({$app->platform}) - " . count($trackedCountries) . " countries");

            try {
                $synced = $this->syncAppReviews($app, $trackedCountries);
                $totalSynced += $synced;
                $this->info("  Synced {$synced} reviews");

                // Update fetch timestamp
                $app->update(['reviews_fetched_at' => now()]);
            } catch (\Exception $e) {
                $totalErrors++;
                $this->error("  Error: {$e->getMessage()}");
                Log::error('Review sync failed', [
                    'app_id' => $app->id,
                    'app_name' => $app->name,
                    'error' => $e->getMessage(),
                ]);
            }

            // Rate limiting between apps
            usleep(self::RATE_LIMIT_MS * 1000);
        }

        $this->newLine();
        $this->info("Sync complete: {$totalSynced} reviews synced, {$totalErrors} errors.");

        return $totalErrors > 0 ? Command::FAILURE : Command::SUCCESS;
    }

    private function syncAppReviews(App $app, array $countries): int
    {
        $synced = 0;

        foreach ($countries as $country) {
            try {
                $this->line("  Fetching {$country}...", null, 'v');

                $count = $app->platform === 'ios'
                    ? $this->fetchIosReviews($app, $country)
                    : $this->fetchAndroidReviews($app, $country);

                $synced += $count;

                // Rate limiting between countries
                usleep(200 * 1000);
            } catch (\Exception $e) {
                Log::warning("Failed to fetch reviews for {$app->name} in {$country}", [
                    'error' => $e->getMessage(),
                ]);
                continue;
            }
        }

        return $synced;
    }

    private function fetchIosReviews(App $app, string $country): int
    {
        $countryLower = strtolower($country);
        $reviews = $this->iTunesService->getAllAppReviews($app->store_id, $countryLower, 5);

        if (!$reviews || empty($reviews)) {
            return 0;
        }

        $now = now();
        $rows = array_map(function ($review) use ($app, $country, $now) {
            return [
                'app_id' => $app->id,
                'country' => strtoupper($country),
                'review_id' => $review['review_id'],
                'author' => $review['author'] ?? 'Anonymous',
                'title' => $review['title'] ?? null,
                'content' => $review['content'] ?? '',
                'rating' => $review['rating'] ?? 0,
                'version' => $review['version'] ?? null,
                'reviewed_at' => $review['reviewed_at'] ?? $now,
                'created_at' => $now,
                'updated_at' => $now,
            ];
        }, $reviews);

        AppReview::upsert(
            $rows,
            ['app_id', 'country', 'review_id'],
            ['author', 'title', 'content', 'rating', 'version', 'reviewed_at', 'updated_at']
        );

        return count($reviews);
    }

    private function fetchAndroidReviews(App $app, string $country): int
    {
        $countryLower = strtolower($country);
        $scraperUrl = config('services.gplay_scraper.url', 'http://localhost:3001');

        $response = Http::timeout(15)
            ->get("{$scraperUrl}/reviews/{$app->store_id}", [
                'country' => $countryLower,
                'num' => 100,
            ]);

        if (!$response->successful()) {
            return 0;
        }

        $reviews = $response->json('reviews', []);

        if (!$reviews || empty($reviews)) {
            return 0;
        }

        $now = now();
        $rows = [];

        foreach ($reviews as $review) {
            $reviewId = $review['review_id'] ?? sha1(implode('|', [
                $app->store_id,
                $countryLower,
                $review['author'] ?? '',
                $review['rating'] ?? '',
                $review['reviewed_at'] ?? '',
                $review['content'] ?? '',
            ]));

            $rows[] = [
                'app_id' => $app->id,
                'country' => strtoupper($country),
                'review_id' => $reviewId,
                'author' => $review['author'] ?? 'Anonymous',
                'title' => $review['title'] ?? null,
                'content' => $review['content'] ?? '',
                'rating' => $review['rating'] ?? 0,
                'version' => $review['version'] ?? null,
                'reviewed_at' => isset($review['reviewed_at']) ? \Carbon\Carbon::parse($review['reviewed_at']) : $now,
                'created_at' => $now,
                'updated_at' => $now,
            ];
        }

        AppReview::upsert(
            $rows,
            ['app_id', 'country', 'review_id'],
            ['author', 'title', 'content', 'rating', 'version', 'reviewed_at', 'updated_at']
        );

        return count($reviews);
    }
}
