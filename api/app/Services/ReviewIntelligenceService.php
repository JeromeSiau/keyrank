<?php

namespace App\Services;

use App\Models\App;
use App\Models\AppReview;
use App\Models\ReviewInsight;
use App\Models\ReviewInsightMention;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class ReviewIntelligenceService
{
    public function __construct(
        private OpenRouterService $openRouter
    ) {}

    /**
     * Process reviews to extract feature requests and bug reports
     */
    public function processReviews(App $app, Collection $reviews): array
    {
        $stats = ['features_extracted' => 0, 'bugs_extracted' => 0];

        // Filter reviews by type
        $featureReviews = $reviews->filter(fn($r) => $this->isFeatureRequest($r));
        $bugReviews = $reviews->filter(fn($r) => $this->isBugReport($r));

        // Extract feature requests
        if ($featureReviews->isNotEmpty()) {
            $stats['features_extracted'] = $this->extractFeatureRequests($app, $featureReviews);
        }

        // Extract bug reports
        if ($bugReviews->isNotEmpty()) {
            $stats['bugs_extracted'] = $this->extractBugReports($app, $bugReviews);
        }

        return $stats;
    }

    /**
     * Check if a review contains a feature request
     */
    private function isFeatureRequest(AppReview $review): bool
    {
        $themes = $review->themes ?? [];

        // Check if 'features' theme is present
        if (in_array('features', $themes)) {
            return true;
        }

        // Check for feature request patterns in content
        $content = strtolower($review->title . ' ' . $review->content);
        return (bool) preg_match('/\b(add|need|want|wish|please|would be nice|should have|missing|could use|hoping for|would love|feature request)\b/i', $content);
    }

    /**
     * Check if a review contains a bug report
     */
    private function isBugReport(AppReview $review): bool
    {
        $themes = $review->themes ?? [];

        // Check if bug-related themes are present
        if (array_intersect(['bugs', 'crashes', 'performance'], $themes)) {
            return true;
        }

        // Check for bug patterns in content
        $content = strtolower($review->title . ' ' . $review->content);
        return (bool) preg_match('/\b(crash|bug|error|broken|not working|doesn\'t work|fails|stuck|freeze|freezes|frozen|hang|hanging|slow|lag|glitch)\b/i', $content);
    }

    /**
     * Extract and cluster feature requests using AI
     */
    private function extractFeatureRequests(App $app, Collection $reviews): int
    {
        $systemPrompt = <<<PROMPT
You are an expert at analyzing app reviews to extract feature requests. Analyze the provided reviews and group similar feature requests together.

For each distinct feature request, provide:
1. A clear, concise title (max 50 chars)
2. A brief description explaining what users want
3. Keywords that identify this feature request
4. Priority based on frequency and user sentiment (low/medium/high/critical)

Return JSON format:
{
  "features": [
    {
      "title": "Dark mode support",
      "description": "Users want a dark theme option to reduce eye strain",
      "keywords": ["dark mode", "night mode", "dark theme"],
      "priority": "high",
      "review_ids": [1, 3, 7]
    }
  ]
}

Group similar requests together. Review IDs should reference which reviews mention each feature.
PROMPT;

        $reviewsText = $reviews->map(fn($r) => sprintf(
            "[ID:%d] Rating: %d/5\nTitle: %s\nContent: %s",
            $r->id,
            $r->rating,
            $r->title ?? '(no title)',
            $r->content
        ))->implode("\n\n---\n\n");

        $userPrompt = "Analyze these reviews for feature requests:\n\n" . $reviewsText;

        $result = $this->openRouter->chat($systemPrompt, $userPrompt, cacheSystemPrompt: true);

        if (!$result || empty($result['features'])) {
            Log::warning('No features extracted from reviews', ['app_id' => $app->id, 'review_count' => $reviews->count()]);
            return 0;
        }

        return $this->saveInsights($app, 'feature_request', $result['features'], $reviews);
    }

    /**
     * Extract and cluster bug reports using AI
     */
    private function extractBugReports(App $app, Collection $reviews): int
    {
        $systemPrompt = <<<PROMPT
You are an expert at analyzing app reviews to extract bug reports. Analyze the provided reviews and group similar bugs together.

For each distinct bug, provide:
1. A clear, concise title describing the bug (max 50 chars)
2. A brief description of the issue
3. Keywords that identify this bug
4. Priority based on severity and frequency (low/medium/high/critical)
5. Platform affected if mentioned (ios/android/null for both)
6. App version affected if mentioned

Return JSON format:
{
  "bugs": [
    {
      "title": "App crashes on startup",
      "description": "Users report the app crashes immediately after launch on iOS 17",
      "keywords": ["crash", "startup", "launch"],
      "priority": "critical",
      "platform": "ios",
      "affected_version": "2.3.1",
      "review_ids": [2, 5, 8]
    }
  ]
}

Group similar bugs together. Review IDs should reference which reviews mention each bug.
PROMPT;

        $reviewsText = $reviews->map(fn($r) => sprintf(
            "[ID:%d] Rating: %d/5 | Version: %s\nTitle: %s\nContent: %s",
            $r->id,
            $r->rating,
            $r->version ?? 'unknown',
            $r->title ?? '(no title)',
            $r->content
        ))->implode("\n\n---\n\n");

        $userPrompt = "Analyze these reviews for bug reports:\n\n" . $reviewsText;

        $result = $this->openRouter->chat($systemPrompt, $userPrompt, cacheSystemPrompt: true);

        if (!$result || empty($result['bugs'])) {
            Log::warning('No bugs extracted from reviews', ['app_id' => $app->id, 'review_count' => $reviews->count()]);
            return 0;
        }

        return $this->saveInsights($app, 'bug_report', $result['bugs'], $reviews);
    }

    /**
     * Save or update insights from AI extraction
     */
    private function saveInsights(App $app, string $type, array $items, Collection $reviews): int
    {
        $count = 0;
        $reviewsById = $reviews->keyBy('id');

        foreach ($items as $item) {
            $reviewIds = $item['review_ids'] ?? [];
            $matchingReviews = collect($reviewIds)
                ->map(fn($id) => $reviewsById->get($id))
                ->filter();

            if ($matchingReviews->isEmpty()) {
                continue;
            }

            try {
                DB::transaction(function () use ($app, $type, $item, $matchingReviews, &$count) {
                    // Find existing insight with similar keywords or create new
                    $insight = $this->findOrCreateInsight($app, $type, $item, $matchingReviews);

                    // Link reviews to this insight
                    foreach ($matchingReviews as $review) {
                        ReviewInsightMention::firstOrCreate([
                            'review_insight_id' => $insight->id,
                            'app_review_id' => $review->id,
                        ]);
                    }

                    // Update mention count
                    $insight->mention_count = $insight->mentions()->count();
                    $insight->last_mentioned_at = $matchingReviews->max('reviewed_at');
                    $insight->save();

                    $count++;
                });
            } catch (\Exception $e) {
                Log::error('Failed to save insight', [
                    'app_id' => $app->id,
                    'type' => $type,
                    'title' => $item['title'] ?? 'unknown',
                    'error' => $e->getMessage(),
                ]);
            }
        }

        return $count;
    }

    /**
     * Find existing insight with similar keywords or create new one
     */
    private function findOrCreateInsight(App $app, string $type, array $item, Collection $reviews): ReviewInsight
    {
        $keywords = $item['keywords'] ?? [];
        $title = $item['title'] ?? 'Unknown';

        // Try to find existing insight with overlapping keywords
        $existing = ReviewInsight::where('app_id', $app->id)
            ->where('type', $type)
            ->where('status', '!=', 'resolved')
            ->get()
            ->first(function ($insight) use ($keywords) {
                $existingKeywords = $insight->keywords ?? [];
                $overlap = count(array_intersect(
                    array_map('strtolower', $keywords),
                    array_map('strtolower', $existingKeywords)
                ));
                return $overlap >= 1; // At least 1 keyword overlap
            });

        if ($existing) {
            // Merge keywords
            $mergedKeywords = array_unique(array_merge(
                $existing->keywords ?? [],
                $keywords
            ));
            $existing->keywords = array_values($mergedKeywords);

            // Update priority if new one is higher
            $priorityOrder = ['low' => 1, 'medium' => 2, 'high' => 3, 'critical' => 4];
            $newPriority = $item['priority'] ?? 'medium';
            if (($priorityOrder[$newPriority] ?? 0) > ($priorityOrder[$existing->priority] ?? 0)) {
                $existing->priority = $newPriority;
            }

            $existing->save();
            return $existing;
        }

        // Create new insight
        $firstReviewDate = $reviews->min('reviewed_at');

        return ReviewInsight::create([
            'app_id' => $app->id,
            'type' => $type,
            'title' => $title,
            'description' => $item['description'] ?? null,
            'keywords' => $keywords,
            'priority' => $item['priority'] ?? 'medium',
            'status' => 'open',
            'platform' => $item['platform'] ?? null,
            'affected_version' => $item['affected_version'] ?? null,
            'first_mentioned_at' => $firstReviewDate ?? now(),
            'last_mentioned_at' => $firstReviewDate ?? now(),
        ]);
    }

    /**
     * Get version sentiment analysis for an app
     */
    public function getVersionSentiment(App $app, int $limit = 10): array
    {
        return AppReview::where('app_id', $app->id)
            ->whereNotNull('version')
            ->whereNotNull('sentiment')
            ->where('version', '!=', '')
            ->select('version')
            ->selectRaw('COUNT(*) as review_count')
            ->selectRaw('AVG(CASE
                WHEN sentiment = "positive" THEN 100
                WHEN sentiment = "neutral" THEN 50
                WHEN sentiment = "mixed" THEN 50
                ELSE 0
            END) as sentiment_percent')
            ->selectRaw('AVG(rating) as avg_rating')
            ->selectRaw('MIN(reviewed_at) as first_review')
            ->selectRaw('MAX(reviewed_at) as last_review')
            ->groupBy('version')
            ->orderByDesc('last_review')
            ->limit($limit)
            ->get()
            ->map(fn($row) => [
                'version' => $row->version,
                'review_count' => (int) $row->review_count,
                'sentiment_percent' => round((float) $row->sentiment_percent, 1),
                'avg_rating' => round((float) $row->avg_rating, 2),
                'first_review' => $row->first_review,
                'last_review' => $row->last_review,
            ])
            ->toArray();
    }

    /**
     * Generate insight about version sentiment changes
     */
    public function getVersionInsight(array $versionSentiment): ?string
    {
        if (count($versionSentiment) < 2) {
            return null;
        }

        $latest = $versionSentiment[0] ?? null;
        $previous = $versionSentiment[1] ?? null;

        if (!$latest || !$previous) {
            return null;
        }

        $change = $latest['sentiment_percent'] - $previous['sentiment_percent'];

        if (abs($change) < 5) {
            return null;
        }

        if ($change < -10) {
            return sprintf(
                'Version %s caused a significant sentiment drop (%.0f%% → %.0f%%). Check bug reports above.',
                $latest['version'],
                $previous['sentiment_percent'],
                $latest['sentiment_percent']
            );
        }

        if ($change > 10) {
            return sprintf(
                'Version %s improved sentiment significantly (%.0f%% → %.0f%%). Great release!',
                $latest['version'],
                $previous['sentiment_percent'],
                $latest['sentiment_percent']
            );
        }

        return null;
    }
}
