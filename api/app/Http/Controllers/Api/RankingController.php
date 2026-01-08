<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppRanking;
use App\Services\GooglePlayService;
use App\Services\iTunesService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

class RankingController extends Controller
{
    public function __construct(
        private iTunesService $iTunesService,
        private GooglePlayService $googlePlayService
    ) {}

    /**
     * Get current rankings for an app
     * Auto-fetches from iTunes if data is stale (> 12h)
     */
    public function index(Request $request, App $app): JsonResponse
    {
        // Ensure user owns this app
        if ($app->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // Check if we need to fetch fresh data
        $this->fetchRankingsIfStale($app);

        $keywords = $app->keywords()
            ->get(['keywords.id', 'keywords.keyword', 'keywords.storefront', 'keywords.popularity'])
            ->keyBy('id');

        $rankings = AppRanking::where('app_id', $app->id)
            ->orderByDesc('recorded_at')
            ->get(['id', 'keyword_id', 'position', 'recorded_at']);

        $rankingsByKeyword = [];
        foreach ($rankings as $ranking) {
            $list = $rankingsByKeyword[$ranking->keyword_id] ?? [];
            if (count($list) < 2) {
                $list[] = $ranking;
                $rankingsByKeyword[$ranking->keyword_id] = $list;
            }
        }

        $result = collect();
        foreach ($rankingsByKeyword as $keywordId => $entries) {
            $keyword = $keywords->get($keywordId);
            $latest = $entries[0] ?? null;
            if (!$keyword || !$latest) {
                continue;
            }
            $previous = $entries[1] ?? null;
            $change = $latest->position && $previous?->position
                ? $previous->position - $latest->position
                : null;

            $result->push([
                'id' => $latest->id,
                'keyword_id' => $keywordId,
                'keyword' => $keyword->keyword,
                'storefront' => $keyword->storefront,
                'popularity' => $keyword->popularity,
                'position' => $latest->position,
                'previous_position' => $previous?->position,
                'change' => $change,
                'recorded_at' => $latest->recorded_at,
            ]);
        }

        return response()->json([
            'data' => $result,
        ]);
    }

    /**
     * Fetch rankings from store if data is stale (> 12h)
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

        // Fetch fresh rankings using appropriate service based on platform
        foreach ($trackedKeywords as $keyword) {
            if ($app->platform === 'ios') {
                $position = $this->iTunesService->getAppRankForKeyword(
                    $app->store_id,
                    $keyword->keyword,
                    strtolower($keyword->storefront)
                );
            } else {
                $position = $this->googlePlayService->getAppRankForKeyword(
                    $app->store_id,
                    $keyword->keyword,
                    strtolower($keyword->storefront)
                );
            }

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
            return response()->json(['message' => 'Unauthorized'], 403);
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
            'data' => [
                'gainers' => $gainers,
                'losers' => $losers,
            ],
        ]);
    }
}
