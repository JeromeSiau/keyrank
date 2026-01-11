<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\CacheService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    /**
     * Get dashboard overview stats
     */
    public function overview(Request $request): JsonResponse
    {
        $user = $request->user();

        $data = CacheService::getDashboardOverview($user->id, function () use ($user) {
            $appsCount = $user->apps()->count();
            // Count only keywords tracked by this user (not all users)
            $keywordsCount = $user->trackedKeywords()->count();

            // Get rankings with improvements today
            $today = today();
            $yesterday = today()->subDay();

            $appIds = $user->apps()->pluck('id');

            $improvements = 0;
            $declines = 0;

            if ($appIds->isNotEmpty()) {
                $stats = DB::table('app_rankings as today')
                    ->join('app_rankings as yesterday', function ($join) use ($yesterday) {
                        $join->on('today.app_id', '=', 'yesterday.app_id')
                            ->on('today.keyword_id', '=', 'yesterday.keyword_id')
                            ->where('yesterday.recorded_at', '=', $yesterday);
                    })
                    ->whereIn('today.app_id', $appIds)
                    ->where('today.recorded_at', $today)
                    ->whereNotNull('today.position')
                    ->whereNotNull('yesterday.position')
                    ->selectRaw('SUM(CASE WHEN (yesterday.position - today.position) > 0 THEN 1 ELSE 0 END) as improvements')
                    ->selectRaw('SUM(CASE WHEN (yesterday.position - today.position) < 0 THEN 1 ELSE 0 END) as declines')
                    ->first();

                $improvements = (int) ($stats->improvements ?? 0);
                $declines = (int) ($stats->declines ?? 0);
            }

            return [
                'apps_count' => $appsCount,
                'keywords_count' => $keywordsCount,
                'improvements_today' => $improvements,
                'declines_today' => $declines,
            ];
        });

        return response()->json(['data' => $data]);
    }

    /**
     * Get hero metrics for the dashboard
     */
    public function metrics(Request $request): JsonResponse
    {
        $user = $request->user();
        $appIds = $user->apps()->pluck('apps.id');

        // Basic counts
        $totalApps = $appIds->count();
        $totalKeywords = $user->trackedKeywords()->count();

        // Calculate average rating across all apps
        $ratingStats = DB::table('apps')
            ->whereIn('id', $appIds)
            ->whereNotNull('rating')
            ->selectRaw('AVG(rating) as avg_rating, SUM(rating_count) as total_reviews')
            ->first();

        $avgRating = round((float) ($ratingStats->avg_rating ?? 0), 2);
        $totalReviews = (int) ($ratingStats->total_reviews ?? 0);

        // Keywords in top 10
        $keywordsInTop10 = DB::table('app_rankings')
            ->whereIn('app_id', $appIds)
            ->where('recorded_at', '>=', now()->subDay())
            ->whereNotNull('position')
            ->where('position', '<=', 10)
            ->distinct('keyword_id')
            ->count('keyword_id');

        // Rating history (last 7 days) - simplified, using app ratings
        $ratingHistory = $this->getRatingHistory($appIds, 7);

        // Calculate rating change (compare to 7 days ago)
        $ratingChange = 0;
        if (count($ratingHistory) >= 2) {
            $oldRating = $ratingHistory[0];
            $newRating = $ratingHistory[count($ratingHistory) - 1];
            if ($oldRating > 0) {
                $ratingChange = round($newRating - $oldRating, 2);
            }
        }

        // Reviews needing reply (simplified - count recent negative reviews)
        $reviewsNeedReply = DB::table('app_reviews')
            ->whereIn('app_id', $appIds)
            ->where('rating', '<=', 3)
            ->whereNull('our_response')
            ->where('reviewed_at', '>=', now()->subDays(30))
            ->count();

        return response()->json([
            'data' => [
                'total_apps' => $totalApps,
                'new_apps_this_month' => $this->getNewAppsThisMonth($user),
                'avg_rating' => $avgRating,
                'rating_change' => $ratingChange,
                'rating_history' => $ratingHistory,
                'total_keywords' => $totalKeywords,
                'keywords_in_top_10' => $keywordsInTop10,
                'total_reviews' => $totalReviews,
                'reviews_need_reply' => $reviewsNeedReply,
            ],
        ]);
    }

    /**
     * Get ranking movers (improving and declining keywords)
     */
    public function movers(Request $request): JsonResponse
    {
        $period = $request->input('period', '7d');
        $limit = min((int) $request->input('limit', 10), 50);

        $days = match ($period) {
            '24h' => 1,
            '7d' => 7,
            '30d' => 30,
            default => 7,
        };

        $user = $request->user();
        $appIds = $user->apps()->pluck('apps.id');

        if ($appIds->isEmpty()) {
            return response()->json([
                'data' => [
                    'improving' => [],
                    'declining' => [],
                    'period' => $period,
                ],
            ]);
        }

        $startDate = now()->subDays($days)->startOfDay();
        $endDate = now();

        // Get rankings at start and end of period
        $movers = DB::table('app_rankings as current')
            ->join('app_rankings as previous', function ($join) use ($startDate) {
                $join->on('current.app_id', '=', 'previous.app_id')
                    ->on('current.keyword_id', '=', 'previous.keyword_id')
                    ->whereRaw('DATE(previous.recorded_at) = ?', [$startDate->toDateString()]);
            })
            ->join('keywords', 'current.keyword_id', '=', 'keywords.id')
            ->join('apps', 'current.app_id', '=', 'apps.id')
            ->whereIn('current.app_id', $appIds)
            ->whereRaw('DATE(current.recorded_at) = ?', [now()->toDateString()])
            ->whereNotNull('current.position')
            ->whereNotNull('previous.position')
            ->selectRaw('
                keywords.keyword as keyword,
                keywords.id as keyword_id,
                apps.name as app_name,
                apps.id as app_id,
                apps.icon_url as app_icon,
                previous.position as old_position,
                current.position as new_position,
                (previous.position - current.position) as position_change
            ')
            ->orderByRaw('ABS(previous.position - current.position) DESC')
            ->limit($limit * 2)
            ->get();

        $improving = $movers->filter(fn($m) => $m->position_change > 0)
            ->take($limit)
            ->map(fn($m) => [
                'keyword' => $m->keyword,
                'keyword_id' => $m->keyword_id,
                'app_name' => $m->app_name,
                'app_id' => $m->app_id,
                'app_icon' => $m->app_icon,
                'old_position' => $m->old_position,
                'new_position' => $m->new_position,
                'change' => $m->position_change,
            ])
            ->values();

        $declining = $movers->filter(fn($m) => $m->position_change < 0)
            ->take($limit)
            ->map(fn($m) => [
                'keyword' => $m->keyword,
                'keyword_id' => $m->keyword_id,
                'app_name' => $m->app_name,
                'app_id' => $m->app_id,
                'app_icon' => $m->app_icon,
                'old_position' => $m->old_position,
                'new_position' => $m->new_position,
                'change' => abs($m->position_change),
            ])
            ->values();

        return response()->json([
            'data' => [
                'improving' => $improving,
                'declining' => $declining,
                'period' => $period,
            ],
        ]);
    }

    /**
     * Get list of supported countries
     */
    public function countries(): JsonResponse
    {
        return response()->json([
            'data' => \App\Services\iTunesService::getSupportedCountries(),
        ]);
    }

    /**
     * Get rating history for the last N days
     */
    private function getRatingHistory(mixed $appIds, int $days): array
    {
        if ($appIds->isEmpty()) {
            return [];
        }

        // Get daily average ratings from app_ratings table if available
        $history = DB::table('app_ratings')
            ->whereIn('app_id', $appIds)
            ->where('recorded_at', '>=', now()->subDays($days))
            ->groupBy('date')
            ->selectRaw('DATE(recorded_at) as date, AVG(rating) as avg_rating')
            ->orderBy('date')
            ->pluck('avg_rating')
            ->map(fn($r) => round((float) $r, 2))
            ->toArray();

        // Fallback to current app ratings if no history
        if (empty($history)) {
            $currentRating = DB::table('apps')
                ->whereIn('id', $appIds)
                ->whereNotNull('rating')
                ->avg('rating');

            if ($currentRating) {
                return array_fill(0, $days, round((float) $currentRating, 2));
            }
        }

        return $history;
    }

    /**
     * Get count of apps added this month
     */
    private function getNewAppsThisMonth($user): int
    {
        return $user->apps()
            ->wherePivot('created_at', '>=', now()->startOfMonth())
            ->count();
    }
}
