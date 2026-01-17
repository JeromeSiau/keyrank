<?php

namespace App\Jobs;

use App\Mail\WeeklyDigestMail;
use App\Models\ActionableInsight;
use App\Models\App;
use App\Models\AppRanking;
use App\Models\AppRating;
use App\Models\AppReview;
use App\Models\JobExecution;
use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;

class WeeklyDigestJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public int $timeout = 1800;
    public int $tries = 2;

    private ?JobExecution $execution = null;

    public function __construct()
    {
        $this->onQueue('emails');
    }

    public function handle(): void
    {
        $this->startExecution();

        try {
            // Get users who have teams with apps and have email notifications enabled
            $users = User::whereHas('currentTeam.apps')
                ->where('email_verified_at', '!=', null)
                ->get();

            Log::info('[WeeklyDigestJob] Starting weekly digest', [
                'users_count' => $users->count(),
            ]);

            foreach ($users as $user) {
                try {
                    $digest = $this->buildDigestForUser($user);

                    if ($this->shouldSendDigest($digest)) {
                        Mail::to($user->email)->send(new WeeklyDigestMail($user, $digest));
                        $this->execution->incrementProcessed();
                    }
                } catch (\Exception $e) {
                    Log::warning('[WeeklyDigestJob] Failed to send digest', [
                        'user_id' => $user->id,
                        'error' => $e->getMessage(),
                    ]);
                    $this->execution->incrementFailed();
                }
            }

            $this->completeExecution();

            Log::info('[WeeklyDigestJob] Weekly digest completed', [
                'items_processed' => $this->execution->items_processed,
                'items_failed' => $this->execution->items_failed,
            ]);
        } catch (\Exception $e) {
            $this->failExecution($e->getMessage());
            Log::error('[WeeklyDigestJob] Failed', ['error' => $e->getMessage()]);
            throw $e;
        }
    }

    /**
     * Build digest data for a user
     */
    private function buildDigestForUser(User $user): array
    {
        $weekStart = now()->subDays(7)->startOfDay();
        $weekEnd = now()->endOfDay();

        $team = $user->currentTeam;
        $apps = $team?->apps()->get() ?? collect();
        $appIds = $apps->pluck('id')->toArray();

        // Top insights of the week
        $insights = ActionableInsight::forUser($user->id)
            ->where('generated_at', '>=', $weekStart)
            ->orderByRaw("FIELD(priority, 'high', 'medium', 'low')")
            ->orderByDesc('generated_at')
            ->limit(5)
            ->get();

        // App summaries
        $appSummaries = [];
        foreach ($apps as $app) {
            $summary = $this->buildAppSummary($app, $weekStart, $weekEnd);
            if (!empty($summary)) {
                $appSummaries[] = $summary;
            }
        }

        // Overall stats
        $totalReviews = AppReview::whereIn('app_id', $appIds)
            ->whereBetween('reviewed_at', [$weekStart, $weekEnd])
            ->count();

        $avgSentiment = AppReview::whereIn('app_id', $appIds)
            ->whereBetween('reviewed_at', [$weekStart, $weekEnd])
            ->whereNotNull('sentiment_score')
            ->avg('sentiment_score');

        // Ranking changes
        $keywordsImproved = $this->countKeywordsWithChange($appIds, $weekStart, 'improved');
        $keywordsDeclined = $this->countKeywordsWithChange($appIds, $weekStart, 'declined');

        return [
            'period' => [
                'start' => $weekStart->format('M d'),
                'end' => $weekEnd->format('M d, Y'),
            ],
            'insights' => $insights->map(fn($i) => [
                'type' => $i->type,
                'priority' => $i->priority,
                'title' => $i->title,
                'description' => $i->description,
                'app_name' => $i->app?->name,
            ])->toArray(),
            'app_summaries' => $appSummaries,
            'stats' => [
                'total_apps' => count($apps),
                'total_reviews' => $totalReviews,
                'avg_sentiment' => $avgSentiment ? round($avgSentiment, 2) : null,
                'keywords_improved' => $keywordsImproved,
                'keywords_declined' => $keywordsDeclined,
            ],
        ];
    }

    /**
     * Build summary for a single app
     */
    private function buildAppSummary(App $app, $weekStart, $weekEnd): array
    {
        // Rating change
        $currentRating = AppRating::where('app_id', $app->id)
            ->where('recorded_at', '<=', $weekEnd)
            ->orderByDesc('recorded_at')
            ->value('average_rating');

        $previousRating = AppRating::where('app_id', $app->id)
            ->where('recorded_at', '<=', $weekStart)
            ->orderByDesc('recorded_at')
            ->value('average_rating');

        $ratingChange = $currentRating && $previousRating
            ? round($currentRating - $previousRating, 2)
            : null;

        // Reviews this week
        $reviewsCount = AppReview::where('app_id', $app->id)
            ->whereBetween('reviewed_at', [$weekStart, $weekEnd])
            ->count();

        $avgReviewRating = AppReview::where('app_id', $app->id)
            ->whereBetween('reviewed_at', [$weekStart, $weekEnd])
            ->avg('rating');

        // Unanswered reviews
        $unansweredCount = AppReview::where('app_id', $app->id)
            ->whereNull('responded_at')
            ->where('rating', '<=', 3)
            ->count();

        return [
            'id' => $app->id,
            'name' => $app->name,
            'icon_url' => $app->icon_url,
            'platform' => $app->platform,
            'current_rating' => $currentRating ? round($currentRating, 1) : null,
            'rating_change' => $ratingChange,
            'reviews_count' => $reviewsCount,
            'avg_review_rating' => $avgReviewRating ? round($avgReviewRating, 1) : null,
            'unanswered_count' => $unansweredCount,
        ];
    }

    /**
     * Count keywords with position changes
     */
    private function countKeywordsWithChange(array $appIds, $since, string $direction): int
    {
        $subquery = AppRanking::whereIn('app_id', $appIds)
            ->whereNotNull('position')
            ->select('keyword_id')
            ->selectRaw('MIN(CASE WHEN recorded_at >= ? THEN position END) as current_pos', [$since])
            ->selectRaw('MIN(CASE WHEN recorded_at < ? THEN position END) as previous_pos', [$since])
            ->groupBy('keyword_id')
            ->having('current_pos', '!=', null)
            ->having('previous_pos', '!=', null);

        $results = DB::table(DB::raw("({$subquery->toSql()}) as sub"))
            ->mergeBindings($subquery->getQuery())
            ->get();

        $count = 0;
        foreach ($results as $row) {
            $change = $row->previous_pos - $row->current_pos; // Lower is better

            if ($direction === 'improved' && $change > 0) {
                $count++;
            } elseif ($direction === 'declined' && $change < 0) {
                $count++;
            }
        }

        return $count;
    }

    /**
     * Check if digest has enough content to be worth sending
     */
    private function shouldSendDigest(array $digest): bool
    {
        // Don't send if no apps or no activity
        if (empty($digest['app_summaries'])) {
            return false;
        }

        // Send if there are insights or reviews
        if (!empty($digest['insights']) || $digest['stats']['total_reviews'] > 0) {
            return true;
        }

        return false;
    }

    private function startExecution(): void
    {
        $this->execution = JobExecution::start('WeeklyDigestJob');
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
        return ['digest', 'email'];
    }
}
