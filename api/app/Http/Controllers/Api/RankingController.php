<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppRanking;
use App\Models\AppRankingAggregate;
use App\Services\GooglePlayService;
use App\Services\iTunesService;
use Carbon\Carbon;
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
            if (! $keyword || ! $latest) {
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
     * Get ranking history for a keyword (combines daily + weekly + monthly)
     */
    public function history(Request $request, App $app): JsonResponse
    {
        $validated = $request->validate([
            'keyword_id' => 'required|integer|exists:keywords,id',
            'from' => 'nullable|date',
            'to' => 'nullable|date',
        ]);

        $keywordId = $validated['keyword_id'];
        $from = isset($validated['from']) ? Carbon::parse($validated['from']) : now()->subDays(30);
        $to = isset($validated['to']) ? Carbon::parse($validated['to']) : now();

        $result = collect();

        // Get daily data
        $daily = $app->rankings()
            ->where('keyword_id', $keywordId)
            ->whereBetween('recorded_at', [$from, $to])
            ->orderBy('recorded_at')
            ->get(['position', 'recorded_at'])
            ->map(fn ($r) => [
                'date' => $r->recorded_at->toDateString(),
                'position' => $r->position,
                'type' => 'daily',
            ]);
        $result = $result->concat($daily);

        // Get weekly aggregates
        $weekly = AppRankingAggregate::where('app_id', $app->id)
            ->where('keyword_id', $keywordId)
            ->where('period_type', 'weekly')
            ->whereBetween('period_start', [$from, $to])
            ->orderBy('period_start')
            ->get()
            ->map(fn ($a) => [
                'period_start' => $a->period_start->toDateString(),
                'avg' => $a->avg_position,
                'min' => $a->min_position,
                'max' => $a->max_position,
                'data_points' => $a->data_points,
                'type' => 'weekly',
            ]);
        $result = $result->concat($weekly);

        // Get monthly aggregates
        $monthly = AppRankingAggregate::where('app_id', $app->id)
            ->where('keyword_id', $keywordId)
            ->where('period_type', 'monthly')
            ->whereBetween('period_start', [$from, $to])
            ->orderBy('period_start')
            ->get()
            ->map(fn ($a) => [
                'period_start' => $a->period_start->toDateString(),
                'avg' => $a->avg_position,
                'min' => $a->min_position,
                'max' => $a->max_position,
                'data_points' => $a->data_points,
                'type' => 'monthly',
            ]);
        $result = $result->concat($monthly);

        // Sort by date (use 'date' for daily, 'period_start' for aggregates)
        $sorted = $result->sortBy(fn ($item) => $item['date'] ?? $item['period_start'])->values();

        return response()->json([
            'data' => $sorted,
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
