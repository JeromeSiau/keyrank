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
        // Count only keywords tracked by this user (not all users)
        $keywordsCount = $user->trackedKeywords()->count();

        // Get rankings with improvements today
        $today = today();
        $yesterday = today()->subDay();

        $appIds = $user->apps()->pluck('id');

        $improvements = 0;
        $declines = 0;

        if ($appIds->isNotEmpty()) {
            $stats = \DB::table('app_rankings as today')
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

        return response()->json([
            'data' => [
                'apps_count' => $appsCount,
                'keywords_count' => $keywordsCount,
                'improvements_today' => $improvements,
                'declines_today' => $declines,
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
}
