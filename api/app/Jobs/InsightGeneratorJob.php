<?php

namespace App\Jobs;

use App\Models\ActionableInsight;
use App\Models\App;
use App\Models\AppReview;
use App\Models\JobExecution;
use App\Models\User;
use App\Services\AnomalyDetectionService;
use App\Services\OpenRouterService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class InsightGeneratorJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    /**
     * Maximum insights to generate per user per run
     */
    private const MAX_INSIGHTS_PER_USER = 10;

    /**
     * Minimum days between similar insights
     */
    private const INSIGHT_COOLDOWN_DAYS = 3;

    public int $timeout = 3600;
    public int $tries = 2;

    private ?JobExecution $execution = null;
    private AnomalyDetectionService $anomalyService;
    private OpenRouterService $openRouter;

    public function __construct()
    {
        $this->onQueue('insights');
    }

    public function handle(
        AnomalyDetectionService $anomalyService,
        OpenRouterService $openRouter,
    ): void {
        $this->anomalyService = $anomalyService;
        $this->openRouter = $openRouter;
        $this->startExecution();

        try {
            // Get all users with apps
            $users = User::has('apps')->get();

            Log::info('[InsightGeneratorJob] Starting insight generation', [
                'users_count' => $users->count(),
            ]);

            foreach ($users as $user) {
                $this->generateInsightsForUser($user);
            }

            $this->completeExecution();

            Log::info('[InsightGeneratorJob] Insight generation completed', [
                'items_processed' => $this->execution->items_processed,
                'items_failed' => $this->execution->items_failed,
            ]);
        } catch (\Exception $e) {
            $this->failExecution($e->getMessage());
            Log::error('[InsightGeneratorJob] Failed', ['error' => $e->getMessage()]);
            throw $e;
        }
    }

    private function generateInsightsForUser(User $user): void
    {
        $insightsGenerated = 0;

        // Get user's apps
        $apps = $user->apps()->get();

        foreach ($apps as $app) {
            if ($insightsGenerated >= self::MAX_INSIGHTS_PER_USER) {
                break;
            }

            try {
                // 1. Generate anomaly-based insights
                $anomalyInsights = $this->generateAnomalyInsights($user, $app);
                $insightsGenerated += count($anomalyInsights);

                // 2. Generate theme-based insights from reviews
                if ($insightsGenerated < self::MAX_INSIGHTS_PER_USER) {
                    $themeInsights = $this->generateThemeInsights($user, $app);
                    $insightsGenerated += count($themeInsights);
                }

                // 3. Generate AI suggestions
                if ($insightsGenerated < self::MAX_INSIGHTS_PER_USER) {
                    $suggestions = $this->generateAISuggestions($user, $app);
                    $insightsGenerated += count($suggestions);
                }

                $this->execution->incrementProcessed();
            } catch (\Exception $e) {
                Log::warning('[InsightGeneratorJob] Failed to generate insights for app', [
                    'app_id' => $app->id,
                    'error' => $e->getMessage(),
                ]);
                $this->execution->incrementFailed();
            }
        }
    }

    /**
     * Generate insights from detected anomalies
     */
    private function generateAnomalyInsights(User $user, App $app): array
    {
        $insights = [];
        $anomalies = $this->anomalyService->detectAnomalies($app);

        foreach ($anomalies as $anomaly) {
            // Check cooldown - avoid duplicate insights
            if ($this->hasSimilarRecentInsight($user->id, $app->id, $anomaly['type'])) {
                continue;
            }

            $type = $this->mapAnomalyTypeToInsightType($anomaly['type']);
            $priority = $anomaly['severity'];

            $insight = ActionableInsight::create([
                'user_id' => $user->id,
                'app_id' => $app->id,
                'type' => $type,
                'priority' => $priority,
                'title' => $this->generateAnomalyTitle($anomaly),
                'description' => $anomaly['description'],
                'data_refs' => [
                    'anomaly_type' => $anomaly['type'],
                    'entity_type' => $anomaly['entity_type'],
                    'entity_id' => $anomaly['entity_id'],
                    'z_score' => $anomaly['z_score'],
                    'value' => $anomaly['value'],
                ],
                'generated_at' => now(),
                'expires_at' => now()->addDays(7),
            ]);

            $insights[] = $insight;
        }

        return $insights;
    }

    /**
     * Generate insights from review themes
     */
    private function generateThemeInsights(User $user, App $app): array
    {
        $insights = [];

        // Get recent reviews with themes
        $recentReviews = AppReview::where('app_id', $app->id)
            ->whereNotNull('themes')
            ->where('reviewed_at', '>=', now()->subDays(7))
            ->get();

        if ($recentReviews->isEmpty()) {
            return [];
        }

        // Count theme occurrences
        $themeCounts = [];
        foreach ($recentReviews as $review) {
            foreach ($review->themes ?? [] as $theme) {
                $themeCounts[$theme] = ($themeCounts[$theme] ?? 0) + 1;
            }
        }

        // Find emerging themes (mentioned 3+ times in negative reviews)
        $negativeThemes = [];
        foreach ($recentReviews->where('rating', '<=', 2) as $review) {
            foreach ($review->themes ?? [] as $theme) {
                $negativeThemes[$theme] = ($negativeThemes[$theme] ?? 0) + 1;
            }
        }

        arsort($negativeThemes);

        // Create insight for top negative theme
        $topNegativeTheme = array_key_first($negativeThemes);
        if ($topNegativeTheme && $negativeThemes[$topNegativeTheme] >= 3) {
            if (!$this->hasSimilarRecentInsight($user->id, $app->id, 'theme_' . $topNegativeTheme)) {
                $insight = ActionableInsight::create([
                    'user_id' => $user->id,
                    'app_id' => $app->id,
                    'type' => ActionableInsight::TYPE_THEME,
                    'priority' => ActionableInsight::PRIORITY_MEDIUM,
                    'title' => "Users are complaining about: " . str_replace('_', ' ', $topNegativeTheme),
                    'description' => "{$negativeThemes[$topNegativeTheme]} negative reviews mention {$topNegativeTheme} issues in the last 7 days.",
                    'action_text' => 'View reviews',
                    'action_url' => "/apps/{$app->id}/reviews?theme={$topNegativeTheme}",
                    'data_refs' => [
                        'theme' => $topNegativeTheme,
                        'count' => $negativeThemes[$topNegativeTheme],
                    ],
                    'generated_at' => now(),
                    'expires_at' => now()->addDays(7),
                ]);

                $insights[] = $insight;
            }
        }

        return $insights;
    }

    /**
     * Generate AI-powered suggestions
     */
    private function generateAISuggestions(User $user, App $app): array
    {
        // Check if we should generate suggestions (not too frequently)
        $lastSuggestion = ActionableInsight::forUser($user->id)
            ->forApp($app->id)
            ->ofType(ActionableInsight::TYPE_SUGGESTION)
            ->latest('generated_at')
            ->first();

        if ($lastSuggestion && $lastSuggestion->generated_at->isAfter(now()->subDays(7))) {
            return [];
        }

        // Gather context for AI
        $context = $this->gatherAppContext($app);

        if (empty($context)) {
            return [];
        }

        $systemPrompt = <<<'PROMPT'
You are an ASO (App Store Optimization) expert. Based on the app data provided, generate ONE actionable insight or suggestion that could help improve the app's visibility or ratings.

Respond with a JSON object:
{
  "title": "<short, attention-grabbing title>",
  "description": "<2-3 sentence explanation with specific, actionable advice>",
  "priority": "high|medium|low"
}

Focus on:
- Keyword opportunities
- Rating improvement strategies
- Review response recommendations
- Competitive positioning

Be specific and actionable, not generic.
PROMPT;

        $userPrompt = "App: {$app->name}\nPlatform: {$app->platform}\n\n" . json_encode($context, JSON_PRETTY_PRINT);

        $result = $this->openRouter->chat($systemPrompt, $userPrompt);

        if (!$result || !isset($result['title'])) {
            return [];
        }

        $insight = ActionableInsight::createSuggestion(
            userId: $user->id,
            title: $result['title'],
            description: $result['description'],
            appId: $app->id,
            priority: $result['priority'] ?? ActionableInsight::PRIORITY_MEDIUM,
        );

        return [$insight];
    }

    /**
     * Gather context about an app for AI suggestions
     */
    private function gatherAppContext(App $app): array
    {
        $context = [];

        // Recent rating trend
        $avgRating = $app->ratings()
            ->where('recorded_at', '>=', now()->subDays(30))
            ->avg('average_rating');

        if ($avgRating) {
            $context['current_rating'] = round($avgRating, 2);
        }

        // Review themes
        $themes = AppReview::where('app_id', $app->id)
            ->whereNotNull('themes')
            ->where('reviewed_at', '>=', now()->subDays(30))
            ->pluck('themes')
            ->flatten()
            ->countBy()
            ->sortDesc()
            ->take(5)
            ->toArray();

        if (!empty($themes)) {
            $context['top_review_themes'] = $themes;
        }

        // Sentiment distribution
        $sentiments = AppReview::where('app_id', $app->id)
            ->whereNotNull('sentiment')
            ->where('reviewed_at', '>=', now()->subDays(30))
            ->select('sentiment', DB::raw('count(*) as count'))
            ->groupBy('sentiment')
            ->pluck('count', 'sentiment')
            ->toArray();

        if (!empty($sentiments)) {
            $context['sentiment_distribution'] = $sentiments;
        }

        // Unanswered negative reviews count
        $unansweredNegative = AppReview::where('app_id', $app->id)
            ->where('rating', '<=', 2)
            ->whereNull('responded_at')
            ->where('reviewed_at', '>=', now()->subDays(30))
            ->count();

        $context['unanswered_negative_reviews'] = $unansweredNegative;

        return $context;
    }

    private function hasSimilarRecentInsight(int $userId, int $appId, string $typeKey): bool
    {
        return ActionableInsight::forUser($userId)
            ->forApp($appId)
            ->where('generated_at', '>=', now()->subDays(self::INSIGHT_COOLDOWN_DAYS))
            ->where(function ($query) use ($typeKey) {
                $query->whereJsonContains('data_refs->anomaly_type', $typeKey)
                    ->orWhereJsonContains('data_refs->theme', $typeKey);
            })
            ->exists();
    }

    private function mapAnomalyTypeToInsightType(string $anomalyType): string
    {
        return match (true) {
            str_contains($anomalyType, 'improvement') => ActionableInsight::TYPE_WIN,
            str_contains($anomalyType, 'increase') => ActionableInsight::TYPE_WIN,
            str_contains($anomalyType, 'decline') => ActionableInsight::TYPE_WARNING,
            str_contains($anomalyType, 'decrease') => ActionableInsight::TYPE_WARNING,
            str_contains($anomalyType, 'spike') => ActionableInsight::TYPE_OPPORTUNITY,
            str_contains($anomalyType, 'competitor') => ActionableInsight::TYPE_COMPETITOR_MOVE,
            default => ActionableInsight::TYPE_WARNING,
        };
    }

    private function generateAnomalyTitle(array $anomaly): string
    {
        return match ($anomaly['type']) {
            'ranking_improvement' => "Ranking boost for \"{$anomaly['entity_name']}\"",
            'ranking_decline' => "Ranking alert for \"{$anomaly['entity_name']}\"",
            'rating_increase' => "Rating improvement detected",
            'rating_decrease' => "Rating drop detected",
            'review_spike' => "Review volume spike",
            'review_drought' => "Fewer reviews than usual",
            'sentiment_improvement' => "User sentiment improving",
            'sentiment_decline' => "User sentiment declining",
            default => "Anomaly detected: {$anomaly['type']}",
        };
    }

    private function startExecution(): void
    {
        $this->execution = JobExecution::start('InsightGeneratorJob');
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
        return ['insights', 'ai'];
    }
}
