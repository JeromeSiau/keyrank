<?php

namespace App\Console\Commands;

use App\Models\App;
use App\Models\AppReview;
use App\Models\StoreConnection;
use App\Models\User;
use App\Services\AppStoreConnectService;
use App\Services\GooglePlayDeveloperService;
use App\Services\OpenRouterService;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;

class SyncConnectedReviews extends Command
{
    protected $signature = 'reviews:sync-connected {--user= : Sync for specific user}';
    protected $description = 'Sync reviews from connected App Store Connect and Google Play accounts';

    public function __construct(
        private AppStoreConnectService $appStoreConnect,
        private GooglePlayDeveloperService $googlePlay,
        private OpenRouterService $openRouter
    ) {
        parent::__construct();
    }

    public function handle(): int
    {
        $userId = $this->option('user');

        // Get active store connections
        $query = StoreConnection::where('status', 'active');
        if ($userId) {
            $query->where('user_id', $userId);
        }

        $connections = $query->with('user')->get();

        if ($connections->isEmpty()) {
            $this->info('No active store connections found.');
            return Command::SUCCESS;
        }

        $this->info("Syncing reviews for {$connections->count()} active connections...");

        $totalSynced = 0;
        $totalErrors = 0;

        foreach ($connections as $connection) {
            $this->newLine();
            $this->line("Processing {$connection->platform} connection for user #{$connection->user_id}...");

            try {
                $synced = $this->syncConnectionReviews($connection);
                $totalSynced += $synced;
                $this->info("  Synced {$synced} reviews");

                // Update last sync timestamp
                $connection->updateLastSync();
            } catch (\Exception $e) {
                $totalErrors++;
                $this->error("  Error: {$e->getMessage()}");
                Log::error('Review sync failed', [
                    'connection_id' => $connection->id,
                    'platform' => $connection->platform,
                    'error' => $e->getMessage(),
                ]);
            }
        }

        $this->newLine();
        $this->info("Sync complete: {$totalSynced} reviews synced, {$totalErrors} errors.");

        return $totalErrors > 0 ? Command::FAILURE : Command::SUCCESS;
    }

    private function syncConnectionReviews(StoreConnection $connection): int
    {
        // Get user's apps for this platform
        $apps = $connection->user->apps()
            ->where('platform', $connection->platform)
            ->get();

        if ($apps->isEmpty()) {
            $this->line("  No {$connection->platform} apps found for this user");
            return 0;
        }

        $synced = 0;

        foreach ($apps as $app) {
            $this->line("  Fetching reviews for: {$app->name}");

            $reviews = $connection->platform === 'ios'
                ? $this->fetchIOSReviews($connection, $app)
                : $this->fetchAndroidReviews($connection, $app);

            if ($reviews === null) {
                continue;
            }

            foreach ($reviews as $reviewData) {
                $review = $this->saveReview($app, $reviewData);
                if ($review->wasRecentlyCreated) {
                    $synced++;
                }
            }

            // Update app's reviews_fetched_at
            $app->update(['reviews_fetched_at' => now()]);

            // Rate limiting
            usleep(300000);
        }

        return $synced;
    }

    private function fetchIOSReviews(StoreConnection $connection, App $app): ?array
    {
        $response = $this->appStoreConnect->getReviews($connection, $app->store_id);

        if (!$response || !isset($response['data'])) {
            return null;
        }

        $reviews = [];
        foreach ($response['data'] as $item) {
            $attrs = $item['attributes'] ?? [];
            $reviews[] = [
                'review_id' => $item['id'],
                'author' => $attrs['reviewerNickname'] ?? 'Anonymous',
                'title' => $attrs['title'] ?? null,
                'content' => $attrs['body'] ?? '',
                'rating' => (int) ($attrs['rating'] ?? 0),
                'country' => $attrs['territory'] ?? 'US',
                'reviewed_at' => isset($attrs['createdDate'])
                    ? Carbon::parse($attrs['createdDate'])
                    : now(),
            ];
        }

        return $reviews;
    }

    private function fetchAndroidReviews(StoreConnection $connection, App $app): ?array
    {
        // Use bundle_id for Android package name
        $packageName = $app->bundle_id ?? $app->store_id;
        $response = $this->googlePlay->getReviews($connection, $packageName);

        if (!$response || !isset($response['reviews'])) {
            return null;
        }

        $reviews = [];
        foreach ($response['reviews'] as $item) {
            $comment = $item['comments'][0]['userComment'] ?? [];
            $lastModified = $comment['lastModified'] ?? [];

            $reviews[] = [
                'review_id' => $item['reviewId'],
                'author' => $item['authorName'] ?? 'Anonymous',
                'title' => null, // Android reviews don't have titles
                'content' => $comment['text'] ?? '',
                'rating' => (int) ($comment['starRating'] ?? 0),
                'country' => $comment['reviewerLanguage'] ?? 'en',
                'reviewed_at' => isset($lastModified['seconds'])
                    ? Carbon::createFromTimestamp($lastModified['seconds'])
                    : now(),
            ];
        }

        return $reviews;
    }

    private function saveReview(App $app, array $data): AppReview
    {
        // Determine sentiment based on rating
        $sentiment = $this->determineSentiment($data['rating'], $data['content']);

        return AppReview::updateOrCreate(
            [
                'app_id' => $app->id,
                'review_id' => $data['review_id'],
            ],
            [
                'author' => $data['author'],
                'title' => $data['title'],
                'content' => $data['content'],
                'rating' => $data['rating'],
                'country' => $data['country'],
                'reviewed_at' => $data['reviewed_at'],
                'sentiment' => $sentiment,
            ]
        );
    }

    private function determineSentiment(int $rating, string $content): string
    {
        // Rating 1-2: negative (no AI needed)
        if ($rating <= 2) {
            return 'negative';
        }

        // Rating 4-5: positive (no AI needed)
        if ($rating >= 4) {
            return 'positive';
        }

        // Rating 3: Use AI to determine sentiment
        return $this->analyzeSentimentWithAI($content);
    }

    private function analyzeSentimentWithAI(string $content): string
    {
        if (empty(trim($content))) {
            return 'neutral';
        }

        try {
            $prompt = "Analyze the sentiment of this review and respond with ONLY one word: 'positive', 'negative', or 'neutral'.\n\nReview: {$content}";

            $result = $this->openRouter->chat(
                'You are a sentiment analyzer. Respond with only one word.',
                $prompt,
                false
            );

            $sentiment = strtolower(trim($result['content'] ?? 'neutral'));

            if (!in_array($sentiment, ['positive', 'negative', 'neutral'])) {
                return 'neutral';
            }

            return $sentiment;
        } catch (\Exception $e) {
            Log::warning('AI sentiment analysis failed', [
                'error' => $e->getMessage(),
            ]);
            return 'neutral';
        }
    }
}
