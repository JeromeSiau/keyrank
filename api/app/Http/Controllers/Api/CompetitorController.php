<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppCompetitor;
use App\Models\AppRanking;
use App\Models\Keyword;
use App\Models\TrackedKeyword;
use App\Services\GooglePlayService;
use App\Services\iTunesService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CompetitorController extends Controller
{
    public function __construct(
        private iTunesService $iTunesService,
        private GooglePlayService $googlePlayService
    ) {}

    /**
     * List all competitors (global + contextual) for the authenticated user.
     */
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();
        $ownerAppId = $request->query('app_id');

        $query = AppCompetitor::where('user_id', $user->id)
            ->with(['competitorApp.latestRankings', 'competitorApp.latestRatings']);

        if ($ownerAppId) {
            // Get both global and contextual for this app
            $query->where(function ($q) use ($ownerAppId) {
                $q->whereNull('owner_app_id')
                  ->orWhere('owner_app_id', $ownerAppId);
            });
        }

        $competitors = $query->get()
            ->map(fn($link) => $this->formatCompetitor(
                $link->competitorApp,
                $link->isGlobal() ? 'global' : 'contextual',
                $link
            ));

        // Deduplicate: if same competitor is both global and contextual, keep contextual
        $deduplicated = $competitors->groupBy('id')
            ->map(fn($group) => $group->firstWhere('competitor_type', 'contextual') ?? $group->first())
            ->values();

        return response()->json([
            'competitors' => $deduplicated,
        ]);
    }

    /**
     * Add a global competitor.
     */
    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'app_id' => 'required|exists:apps,id',
        ]);

        $user = $request->user();
        $appId = $request->input('app_id');

        // Check if already exists as global competitor
        $existing = AppCompetitor::where('user_id', $user->id)
            ->whereNull('owner_app_id')
            ->where('competitor_app_id', $appId)
            ->first();

        if ($existing) {
            $app = App::with(['latestRankings', 'latestRatings'])->find($appId);
            return response()->json([
                'competitor' => $this->formatCompetitor($app, 'global', $existing),
            ], 200);
        }

        // Create global competitor
        $link = AppCompetitor::create([
            'user_id' => $user->id,
            'owner_app_id' => null,
            'competitor_app_id' => $appId,
            'source' => 'manual',
        ]);

        $app = App::with(['latestRankings', 'latestRatings'])->find($appId);

        return response()->json([
            'competitor' => $this->formatCompetitor($app, 'global', $link),
        ], 201);
    }

    /**
     * Remove a global competitor.
     */
    public function destroy(Request $request, int $appId): JsonResponse
    {
        $user = $request->user();

        // Remove global competitor entry
        AppCompetitor::where('user_id', $user->id)
            ->whereNull('owner_app_id')
            ->where('competitor_app_id', $appId)
            ->delete();

        // Also remove any contextual links
        AppCompetitor::where('user_id', $user->id)
            ->where('competitor_app_id', $appId)
            ->delete();

        return response()->json(['success' => true]);
    }

    /**
     * Link a competitor to a specific app (contextual).
     */
    public function linkToApp(Request $request, int $ownerAppId): JsonResponse
    {
        $request->validate([
            'competitor_app_id' => 'required|exists:apps,id',
            'source' => 'sometimes|in:manual,auto_discovered,keyword_overlap',
        ]);

        $user = $request->user();
        $competitorAppId = $request->input('competitor_app_id');

        // Verify user owns the owner app
        $ownerApp = App::ownedBy($user->id)->find($ownerAppId);
        if (!$ownerApp) {
            return response()->json(['error' => 'App not found or not owned'], 404);
        }

        // Create or update link
        $link = AppCompetitor::updateOrCreate(
            [
                'user_id' => $user->id,
                'owner_app_id' => $ownerAppId,
                'competitor_app_id' => $competitorAppId,
            ],
            [
                'source' => $request->input('source', 'manual'),
            ]
        );

        $competitorApp = App::with(['latestRankings', 'latestRatings'])->find($competitorAppId);

        return response()->json([
            'competitor' => $this->formatCompetitor($competitorApp, 'contextual', $link),
        ], 201);
    }

    /**
     * Unlink a competitor from a specific app.
     */
    public function unlinkFromApp(Request $request, int $ownerAppId, int $competitorAppId): JsonResponse
    {
        $user = $request->user();

        AppCompetitor::where('user_id', $user->id)
            ->where('owner_app_id', $ownerAppId)
            ->where('competitor_app_id', $competitorAppId)
            ->delete();

        return response()->json(['success' => true]);
    }

    /**
     * Get competitors for a specific app.
     */
    public function forApp(Request $request, int $appId): JsonResponse
    {
        $user = $request->user();

        // Get both global and contextual competitors
        $competitors = AppCompetitor::where('user_id', $user->id)
            ->where(function ($q) use ($appId) {
                $q->whereNull('owner_app_id')
                  ->orWhere('owner_app_id', $appId);
            })
            ->with(['competitorApp.latestRankings', 'competitorApp.latestRatings'])
            ->get()
            ->map(fn($link) => $this->formatCompetitor(
                $link->competitorApp,
                $link->isGlobal() ? 'global' : 'contextual',
                $link
            ));

        // Deduplicate: contextual takes precedence
        $deduplicated = $competitors->groupBy('id')
            ->map(fn($group) => $group->firstWhere('competitor_type', 'contextual') ?? $group->first())
            ->values();

        return response()->json([
            'competitors' => $deduplicated,
        ]);
    }

    /**
     * Get keywords for a competitor with comparison to user's app.
     */
    public function keywords(Request $request, int $competitorId): JsonResponse
    {
        $request->validate([
            'app_id' => 'required|integer|exists:apps,id',
            'country' => 'sometimes|string|max:5',
        ]);

        $user = $request->user();
        $userAppId = $request->query('app_id');
        $country = strtoupper($request->query('country', 'US'));

        // Verify user owns the app
        $userApp = App::ownedBy($user->id)->find($userAppId);
        if (!$userApp) {
            return response()->json(['error' => 'App not found'], 404);
        }

        // Get competitor app
        $competitorApp = App::find($competitorId);
        if (!$competitorApp) {
            return response()->json(['error' => 'Competitor not found'], 404);
        }

        // Get competitor's keywords from tracked_keywords (user-added)
        // Left join with app_rankings to get positions
        $competitorKeywords = \DB::table('tracked_keywords')
            ->join('keywords', 'tracked_keywords.keyword_id', '=', 'keywords.id')
            ->leftJoin('app_rankings', function ($join) use ($competitorId) {
                $join->on('app_rankings.keyword_id', '=', 'keywords.id')
                    ->where('app_rankings.app_id', '=', $competitorId)
                    ->whereRaw('app_rankings.recorded_at = (SELECT MAX(recorded_at) FROM app_rankings ar2 WHERE ar2.app_id = app_rankings.app_id AND ar2.keyword_id = app_rankings.keyword_id)');
            })
            ->where('tracked_keywords.app_id', $competitorId)
            ->where('tracked_keywords.user_id', $user->id)
            ->where('keywords.storefront', $country)
            ->select([
                'keywords.id as keyword_id',
                'keywords.keyword',
                'keywords.popularity',
                'app_rankings.position as competitor_position',
            ])
            ->orderByRaw('COALESCE(app_rankings.position, 999)')
            ->get();

        // Get user's rankings for same keywords
        $userKeywordIds = $competitorKeywords->pluck('keyword_id')->toArray();
        $userRankings = \DB::table('app_rankings')
            ->where('app_id', $userAppId)
            ->whereIn('keyword_id', $userKeywordIds)
            ->pluck('position', 'keyword_id');

        // Check which keywords user is tracking
        $trackedKeywords = \DB::table('tracked_keywords')
            ->where('app_id', $userAppId)
            ->whereIn('keyword_id', $userKeywordIds)
            ->pluck('keyword_id')
            ->toArray();

        // Build comparison data
        $keywords = $competitorKeywords->map(function ($kw) use ($userRankings, $trackedKeywords) {
            $yourPosition = $userRankings[$kw->keyword_id] ?? null;
            $competitorPosition = $kw->competitor_position;

            $gap = null;
            if ($yourPosition !== null && $competitorPosition !== null) {
                $gap = $competitorPosition - $yourPosition; // positive = you win
            }

            return [
                'keyword_id' => $kw->keyword_id,
                'keyword' => $kw->keyword,
                'your_position' => $yourPosition,
                'competitor_position' => $competitorPosition,
                'gap' => $gap,
                'popularity' => $kw->popularity,
                'is_tracking' => in_array($kw->keyword_id, $trackedKeywords),
            ];
        });

        // Calculate summary
        $youWin = $keywords->filter(fn($k) => $k['gap'] !== null && $k['gap'] > 0)->count();
        $theyWin = $keywords->filter(fn($k) => $k['gap'] !== null && $k['gap'] < 0)->count();
        $gaps = $keywords->filter(fn($k) => $k['your_position'] === null)->count();
        $tied = $keywords->filter(fn($k) => $k['gap'] === 0)->count();

        return response()->json([
            'competitor' => [
                'id' => $competitorApp->id,
                'name' => $competitorApp->name,
                'icon_url' => $competitorApp->icon_url,
            ],
            'summary' => [
                'total_keywords' => $keywords->count(),
                'you_win' => $youWin,
                'they_win' => $theyWin,
                'tied' => $tied,
                'gaps' => $gaps,
            ],
            'keywords' => $keywords->values(),
        ]);
    }

    /**
     * Add a keyword to track for a competitor.
     * Fetches initial ranking immediately for instant feedback.
     */
    public function addKeyword(Request $request, int $competitorId): JsonResponse
    {
        $request->validate([
            'keyword' => 'required|string|max:255',
            'storefront' => 'sometimes|string|max:5',
        ]);

        $user = $request->user();
        $keywordText = strtolower(trim($request->input('keyword')));
        $storefront = strtoupper($request->input('storefront', 'US'));

        // Verify competitor exists
        $competitorApp = App::find($competitorId);
        if (!$competitorApp) {
            return response()->json(['error' => 'Competitor not found'], 404);
        }

        // Get or create keyword
        $keyword = Keyword::firstOrCreate(
            ['keyword' => $keywordText, 'storefront' => $storefront],
            ['keyword' => $keywordText, 'storefront' => $storefront]
        );

        // Check if already tracked
        $existing = TrackedKeyword::where('user_id', $user->id)
            ->where('app_id', $competitorId)
            ->where('keyword_id', $keyword->id)
            ->first();

        if ($existing) {
            return response()->json(['error' => 'Keyword already tracked for this competitor'], 409);
        }

        // Create tracked keyword
        $tracked = TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $competitorId,
            'keyword_id' => $keyword->id,
        ]);

        // Fetch current ranking immediately
        $position = $this->fetchAndSaveRanking($competitorApp, $keyword, $storefront);

        return response()->json([
            'tracked_keyword' => [
                'id' => $tracked->id,
                'keyword_id' => $keyword->id,
                'keyword' => $keyword->keyword,
                'storefront' => $keyword->storefront,
                'position' => $position,
            ],
        ], 201);
    }

    /**
     * Add multiple keywords to track for a competitor (bulk).
     */
    public function addKeywords(Request $request, int $competitorId): JsonResponse
    {
        $request->validate([
            'keywords' => 'required|array|min:1',
            'keywords.*' => 'string|max:255',
            'storefront' => 'sometimes|string|max:5',
        ]);

        $user = $request->user();
        $storefront = strtoupper($request->input('storefront', 'US'));

        // Verify competitor exists
        $competitorApp = App::find($competitorId);
        if (!$competitorApp) {
            return response()->json(['error' => 'Competitor not found'], 404);
        }

        $added = 0;
        $skipped = 0;

        foreach ($request->input('keywords') as $keywordText) {
            $keywordText = strtolower(trim($keywordText));
            if (empty($keywordText)) continue;

            // Get or create keyword
            $keyword = Keyword::firstOrCreate(
                ['keyword' => $keywordText, 'storefront' => $storefront],
                ['keyword' => $keywordText, 'storefront' => $storefront]
            );

            // Check if already tracked
            $existing = TrackedKeyword::where('user_id', $user->id)
                ->where('app_id', $competitorId)
                ->where('keyword_id', $keyword->id)
                ->exists();

            if ($existing) {
                $skipped++;
                continue;
            }

            // Create tracked keyword
            TrackedKeyword::create([
                'user_id' => $user->id,
                'app_id' => $competitorId,
                'keyword_id' => $keyword->id,
            ]);

            // Fetch ranking immediately
            $this->fetchAndSaveRanking($competitorApp, $keyword, $storefront);

            $added++;
        }

        return response()->json([
            'added' => $added,
            'skipped' => $skipped,
        ], 201);
    }

    private function formatCompetitor(App $app, string $type, ?AppCompetitor $link = null): array
    {
        return [
            'id' => $app->id,
            'platform' => $app->platform,
            'store_id' => $app->store_id,
            'name' => $app->name,
            'icon_url' => $app->icon_url,
            'developer' => $app->developer,
            'rating' => $app->rating,
            'rating_count' => $app->rating_count,
            'competitor_type' => $type,
            'source' => $link?->source,
            'linked_at' => $link?->created_at?->toIso8601String(),
        ];
    }

    /**
     * Fetch and save ranking for an app/keyword pair.
     */
    private function fetchAndSaveRanking(App $app, Keyword $keyword, string $storefront): ?int
    {
        $country = strtolower($storefront);
        $platform = $app->platform;

        try {
            $service = $platform === 'ios' ? $this->iTunesService : $this->googlePlayService;
            $searchResults = $service->searchApps($keyword->keyword, $country, 50);

            // Find position
            $position = null;
            $appStoreId = $app->store_id;
            $idField = $platform === 'ios' ? 'apple_id' : 'google_play_id';

            foreach ($searchResults as $result) {
                if (($result[$idField] ?? null) === $appStoreId) {
                    $position = $result['position'];
                    break;
                }
            }

            // Save ranking
            AppRanking::updateOrCreate(
                [
                    'app_id' => $app->id,
                    'keyword_id' => $keyword->id,
                    'recorded_at' => today(),
                ],
                ['position' => $position]
            );

            return $position;
        } catch (\Exception $e) {
            \Log::error("Failed to fetch ranking for {$app->name} / {$keyword->keyword}: {$e->getMessage()}");
            return null;
        }
    }
}
