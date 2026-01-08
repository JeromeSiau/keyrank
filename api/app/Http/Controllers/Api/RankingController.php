<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppRanking;
use App\Services\iTunesService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

class RankingController extends Controller
{
    public function __construct(
        private iTunesService $iTunesService
    ) {}

    /**
     * Get current rankings for an app
     * Auto-fetches from iTunes if data is stale (> 12h)
     */
    public function index(Request $request, App $app): JsonResponse
    {
        // Ensure user owns this app
        if ($app->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Not found'], 404);
        }

        // Check if we need to fetch fresh data
        $this->fetchRankingsIfStale($app);

        // Get latest ranking for each keyword
        $rankings = DB::table('app_rankings as r1')
            ->join('keywords', 'keywords.id', '=', 'r1.keyword_id')
            ->leftJoin('app_rankings as r2', function ($join) {
                $join->on('r1.app_id', '=', 'r2.app_id')
                    ->on('r1.keyword_id', '=', 'r2.keyword_id')
                    ->on('r1.recorded_at', '<', 'r2.recorded_at');
            })
            ->whereNull('r2.id')
            ->where('r1.app_id', $app->id)
            ->select([
                'r1.id',
                'r1.keyword_id',
                'keywords.keyword',
                'keywords.storefront',
                'keywords.popularity',
                'r1.position',
                'r1.recorded_at',
            ])
            ->get();

        // Get previous rankings for comparison
        $result = $rankings->map(function ($ranking) use ($app) {
            $previous = AppRanking::where('app_id', $app->id)
                ->where('keyword_id', $ranking->keyword_id)
                ->where('recorded_at', '<', $ranking->recorded_at)
                ->orderByDesc('recorded_at')
                ->first();

            $change = null;
            if ($ranking->position && $previous?->position) {
                $change = $previous->position - $ranking->position;
            }

            return [
                'id' => $ranking->id,
                'keyword_id' => $ranking->keyword_id,
                'keyword' => $ranking->keyword,
                'storefront' => $ranking->storefront,
                'popularity' => $ranking->popularity,
                'position' => $ranking->position,
                'previous_position' => $previous?->position,
                'change' => $change,
                'recorded_at' => $ranking->recorded_at,
            ];
        });

        return response()->json([
            'data' => $result,
        ]);
    }

    /**
     * Fetch rankings from iTunes if data is stale (> 12h)
     */
    private function fetchRankingsIfStale(App $app): void
    {
        $trackedKeywords = $app->keywords;

        if ($trackedKeywords->isEmpty()) {
            return;
        }

        // Check cache to see if we've fetched recently
        $cacheKey = "rankings_fetched_{$app->id}";
        $lastFetched = Cache::get($cacheKey);

        if ($lastFetched) {
            return; // Already fetched within cache duration
        }

        // Check if we have fresh rankings (within 12 hours)
        $latestRanking = $app->rankings()
            ->where('recorded_at', '>=', now()->subHours(12))
            ->first();

        if ($latestRanking) {
            // Data is fresh, set cache and return
            Cache::put($cacheKey, now(), now()->addHours(12));
            return;
        }

        // Fetch fresh rankings
        foreach ($trackedKeywords as $keyword) {
            $position = $this->iTunesService->getAppRankForKeyword(
                $app->apple_id,
                $keyword->keyword,
                strtolower($keyword->storefront)
            );

            $app->rankings()->updateOrCreate(
                [
                    'keyword_id' => $keyword->id,
                    'recorded_at' => today(),
                ],
                ['position' => $position]
            );

            // Small delay to avoid rate limiting
            usleep(300000); // 0.3 seconds
        }

        // Cache that we've fetched
        Cache::put($cacheKey, now(), now()->addHours(12));
    }

    /**
     * Get ranking history for a keyword
     */
    public function history(Request $request, App $app): JsonResponse
    {
        // Ensure user owns this app
        if ($app->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Not found'], 404);
        }

        $validated = $request->validate([
            'keyword_id' => 'required|integer|exists:keywords,id',
            'days' => 'nullable|integer|min:7|max:365',
        ]);

        $days = $validated['days'] ?? 30;

        $history = $app->rankings()
            ->where('keyword_id', $validated['keyword_id'])
            ->where('recorded_at', '>=', now()->subDays($days))
            ->orderBy('recorded_at')
            ->get(['position', 'recorded_at']);

        return response()->json([
            'data' => $history,
        ]);
    }

    /**
     * Get movers (keywords with biggest position changes)
     */
    public function movers(Request $request): JsonResponse
    {
        $user = $request->user();

        // Get all apps for user
        $appIds = $user->apps()->pluck('id');

        if ($appIds->isEmpty()) {
            return response()->json([
                'gainers' => [],
                'losers' => [],
            ]);
        }

        // Get today's and yesterday's rankings
        $today = today();
        $yesterday = today()->subDay();

        $rankings = DB::table('app_rankings as today')
            ->join('app_rankings as yesterday', function ($join) use ($yesterday) {
                $join->on('today.app_id', '=', 'yesterday.app_id')
                    ->on('today.keyword_id', '=', 'yesterday.keyword_id')
                    ->where('yesterday.recorded_at', '=', $yesterday);
            })
            ->join('apps', 'apps.id', '=', 'today.app_id')
            ->join('keywords', 'keywords.id', '=', 'today.keyword_id')
            ->whereIn('today.app_id', $appIds)
            ->where('today.recorded_at', '=', $today)
            ->whereNotNull('today.position')
            ->whereNotNull('yesterday.position')
            ->select([
                'apps.name as app_name',
                'apps.icon_url as app_icon',
                'keywords.keyword',
                'keywords.storefront',
                'today.position as current_position',
                'yesterday.position as previous_position',
                DB::raw('(yesterday.position - today.position) as change'),
            ])
            ->get();

        $gainers = $rankings->where('change', '>', 0)->sortByDesc('change')->take(10)->values();
        $losers = $rankings->where('change', '<', 0)->sortBy('change')->take(10)->values();

        return response()->json([
            'gainers' => $gainers,
            'losers' => $losers,
        ]);
    }
}
