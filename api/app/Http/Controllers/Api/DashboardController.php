<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    /**
     * Get dashboard overview stats
     */
    public function overview(Request $request): JsonResponse
    {
        $user = $request->user();

        $appsCount = $user->apps()->count();
        $keywordsCount = $user->apps()
            ->withCount('trackedKeywords')
            ->get()
            ->sum('tracked_keywords_count');

        // Get rankings with improvements today
        $today = today();
        $yesterday = today()->subDay();

        $appIds = $user->apps()->pluck('id');

        $improvements = 0;
        $declines = 0;

        if ($appIds->isNotEmpty()) {
            $todayRankings = \DB::table('app_rankings')
                ->whereIn('app_id', $appIds)
                ->where('recorded_at', $today)
                ->get()
                ->keyBy(fn($r) => "{$r->app_id}_{$r->keyword_id}");

            $yesterdayRankings = \DB::table('app_rankings')
                ->whereIn('app_id', $appIds)
                ->where('recorded_at', $yesterday)
                ->get()
                ->keyBy(fn($r) => "{$r->app_id}_{$r->keyword_id}");

            foreach ($todayRankings as $key => $todayRank) {
                if (isset($yesterdayRankings[$key])) {
                    $yesterdayRank = $yesterdayRankings[$key];
                    if ($todayRank->position && $yesterdayRank->position) {
                        $change = $yesterdayRank->position - $todayRank->position;
                        if ($change > 0) {
                            $improvements++;
                        } elseif ($change < 0) {
                            $declines++;
                        }
                    }
                }
            }
        }

        return response()->json([
            'apps_count' => $appsCount,
            'keywords_count' => $keywordsCount,
            'improvements_today' => $improvements,
            'declines_today' => $declines,
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
}
