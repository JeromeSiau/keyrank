<?php

namespace App\Jobs;

use App\Models\App;
use App\Models\AppReview;
use App\Models\JobExecution;
use App\Services\ReviewIntelligenceService;
use Carbon\Carbon;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class ExtractReviewInsightsJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    /**
     * Maximum reviews to process per app per run
     */
    private const MAX_REVIEWS_PER_APP = 100;

    /**
     * Rate limit between app processing in milliseconds
     */
    private const RATE_LIMIT_MS = 1000;

    /**
     * Job timeout in seconds
     */
    public int $timeout = 3600;

    /**
     * Number of retry attempts
     */
    public int $tries = 3;

    private ?JobExecution $execution = null;

    /**
     * Optional: specific app to process
     */
    public function __construct(
        public ?App $app = null,
        public ?Carbon $since = null
    ) {
        $this->onQueue('ai');
    }

    public function handle(ReviewIntelligenceService $service): void
    {
        $this->startExecution();

        try {
            if ($this->app) {
                // Process specific app
                $this->processApp($this->app, $service);
            } else {
                // Process all apps with recent enriched reviews
                $this->processAllApps($service);
            }

            $this->completeExecution();

            Log::info('[ExtractReviewInsightsJob] Completed', [
                'items_processed' => $this->execution->items_processed,
                'items_failed' => $this->execution->items_failed,
            ]);
        } catch (\Exception $e) {
            $this->failExecution($e->getMessage());
            Log::error('[ExtractReviewInsightsJob] Failed', [
                'error' => $e->getMessage(),
            ]);
            throw $e;
        }
    }

    private function processAllApps(ReviewIntelligenceService $service): void
    {
        // Get apps with recently enriched reviews that haven't been processed
        $since = $this->since ?? now()->subDays(7);

        $appIds = AppReview::whereNotNull('enriched_at')
            ->where('enriched_at', '>=', $since)
            ->distinct()
            ->pluck('app_id');

        Log::info('[ExtractReviewInsightsJob] Processing apps', [
            'app_count' => $appIds->count(),
            'since' => $since->toDateTimeString(),
        ]);

        foreach ($appIds as $appId) {
            $app = App::find($appId);
            if (!$app) {
                continue;
            }

            $this->processApp($app, $service);
            usleep(self::RATE_LIMIT_MS * 1000);
        }
    }

    private function processApp(App $app, ReviewIntelligenceService $service): void
    {
        $since = $this->since ?? now()->subDays(7);

        // Get enriched reviews that haven't been processed for insights yet
        $reviews = AppReview::where('app_id', $app->id)
            ->whereNotNull('enriched_at')
            ->whereNull('insights_extracted_at')
            ->whereNotNull('content')
            ->where('content', '!=', '')
            ->orderByDesc('reviewed_at')
            ->limit(self::MAX_REVIEWS_PER_APP)
            ->get();

        if ($reviews->isEmpty()) {
            Log::debug('[ExtractReviewInsightsJob] No reviews to process', [
                'app_id' => $app->id,
                'app_name' => $app->name,
            ]);
            return;
        }

        Log::info('[ExtractReviewInsightsJob] Processing app reviews', [
            'app_id' => $app->id,
            'app_name' => $app->name,
            'review_count' => $reviews->count(),
        ]);

        try {
            $stats = $service->processReviews($app, $reviews);

            Log::info('[ExtractReviewInsightsJob] App processed', [
                'app_id' => $app->id,
                'features_extracted' => $stats['features_extracted'],
                'bugs_extracted' => $stats['bugs_extracted'],
            ]);

            $this->execution->incrementProcessed($stats['features_extracted'] + $stats['bugs_extracted']);
        } catch (\Exception $e) {
            Log::error('[ExtractReviewInsightsJob] Failed to process app', [
                'app_id' => $app->id,
                'error' => $e->getMessage(),
            ]);
            $this->execution->incrementFailed();
        }
    }

    private function startExecution(): void
    {
        $this->execution = JobExecution::start('ExtractReviewInsightsJob');
    }

    private function completeExecution(): void
    {
        $this->execution->markCompleted();
    }

    private function failExecution(string $errorMessage): void
    {
        $this->execution->markFailed($errorMessage);
    }

    public function tags(): array
    {
        $tags = ['review-insights', 'ai'];

        if ($this->app) {
            $tags[] = 'app:' . $this->app->id;
        }

        return $tags;
    }
}
