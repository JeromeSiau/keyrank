<?php

namespace App\Jobs;

use App\Models\AppReview;
use App\Models\JobExecution;
use App\Services\OpenRouterService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Log;

class EnrichmentJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    /**
     * Number of reviews to process per batch for LLM call
     */
    private const BATCH_SIZE = 20;

    /**
     * Maximum reviews to process per job run
     */
    private const MAX_REVIEWS_PER_RUN = 500;

    /**
     * Rate limit between LLM calls in milliseconds
     */
    private const RATE_LIMIT_MS = 500;

    /**
     * Job timeout in seconds
     */
    public int $timeout = 3600;

    /**
     * Number of retry attempts
     */
    public int $tries = 3;

    private ?JobExecution $execution = null;

    public function __construct()
    {
        $this->onQueue('enrichment');
    }

    public function handle(OpenRouterService $openRouter): void
    {
        $this->startExecution();

        try {
            $reviews = $this->getUnenrichedReviews();

            if ($reviews->isEmpty()) {
                Log::info('[EnrichmentJob] No reviews to enrich');
                $this->completeExecution();
                return;
            }

            Log::info('[EnrichmentJob] Starting enrichment', [
                'reviews_count' => $reviews->count(),
            ]);

            // Process in batches
            $reviews->chunk(self::BATCH_SIZE)->each(function (Collection $batch) use ($openRouter) {
                $this->processBatch($batch, $openRouter);
                usleep(self::RATE_LIMIT_MS * 1000);
            });

            $this->completeExecution();

            Log::info('[EnrichmentJob] Enrichment completed', [
                'items_processed' => $this->execution->items_processed,
                'items_failed' => $this->execution->items_failed,
            ]);
        } catch (\Exception $e) {
            $this->failExecution($e->getMessage());
            Log::error('[EnrichmentJob] Enrichment failed', [
                'error' => $e->getMessage(),
            ]);
            throw $e;
        }
    }

    private function getUnenrichedReviews(): Collection
    {
        return AppReview::unenriched()
            ->whereNotNull('content')
            ->where('content', '!=', '')
            ->orderByDesc('reviewed_at')
            ->limit(self::MAX_REVIEWS_PER_RUN)
            ->get();
    }

    private function processBatch(Collection $reviews, OpenRouterService $openRouter): void
    {
        $systemPrompt = $this->buildSystemPrompt();
        $userPrompt = $this->buildUserPrompt($reviews);

        $result = $openRouter->chat($systemPrompt, $userPrompt);

        if (!$result || !isset($result['reviews'])) {
            Log::warning('[EnrichmentJob] Failed to get LLM response for batch');
            foreach ($reviews as $review) {
                $this->execution->incrementFailed();
            }
            return;
        }

        // Map results back to reviews
        foreach ($result['reviews'] as $enrichment) {
            $reviewId = $enrichment['id'] ?? null;
            if (!$reviewId) {
                continue;
            }

            $review = $reviews->firstWhere('id', $reviewId);
            if (!$review) {
                continue;
            }

            try {
                $review->update([
                    'sentiment' => $enrichment['sentiment'] ?? null,
                    'sentiment_score' => $enrichment['sentiment_score'] ?? null,
                    'themes' => $enrichment['themes'] ?? [],
                    'language' => $enrichment['language'] ?? null,
                    'enriched_at' => now(),
                ]);
                $this->execution->incrementProcessed();
            } catch (\Exception $e) {
                Log::warning('[EnrichmentJob] Failed to update review', [
                    'review_id' => $review->id,
                    'error' => $e->getMessage(),
                ]);
                $this->execution->incrementFailed();
            }
        }
    }

    private function buildSystemPrompt(): string
    {
        return <<<'PROMPT'
You are an expert at analyzing mobile app reviews. For each review, determine:
1. Sentiment: "positive", "negative", "neutral", or "mixed"
2. Sentiment score: a number from -1.00 (very negative) to 1.00 (very positive)
3. Themes: an array of relevant themes (max 5). Use these standard themes when applicable:
   - "bugs", "crashes", "performance", "ui_ux", "features", "pricing", "subscription",
   - "customer_support", "onboarding", "updates", "ads", "privacy", "battery",
   - "notifications", "sync", "login", "data_loss", "localization"
   You may add custom themes if none of the standard ones apply.
4. Language: ISO 639-1 code (e.g., "en", "fr", "de", "es")

Respond with a JSON object containing an array of reviews:
{
  "reviews": [
    {
      "id": <review_id>,
      "sentiment": "positive|negative|neutral|mixed",
      "sentiment_score": <-1.00 to 1.00>,
      "themes": ["theme1", "theme2"],
      "language": "en"
    }
  ]
}

Be accurate and consistent. Short positive reviews like "Great app!" should get high sentiment scores.
PROMPT;
    }

    private function buildUserPrompt(Collection $reviews): string
    {
        $prompt = "Analyze these app reviews:\n\n";

        foreach ($reviews as $review) {
            $prompt .= "---\n";
            $prompt .= "ID: {$review->id}\n";
            $prompt .= "Rating: {$review->rating}/5\n";
            if ($review->title) {
                $prompt .= "Title: {$review->title}\n";
            }
            $prompt .= "Content: {$review->content}\n";
        }

        return $prompt;
    }

    private function startExecution(): void
    {
        $this->execution = JobExecution::start('EnrichmentJob');
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
        return ['enrichment', 'ai'];
    }
}
