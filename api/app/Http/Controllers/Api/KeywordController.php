<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppRanking;
use App\Models\Keyword;
use App\Models\TrackedKeyword;
use App\Services\iTunesService;
use App\Services\GooglePlayService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class KeywordController extends Controller
{
    public function __construct(
        private iTunesService $iTunesService,
        private GooglePlayService $googlePlayService
    ) {}

    /**
     * Search for a keyword and get its current rankings
     */
    public function search(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'q' => 'required|string|min:2',
            'country' => 'nullable|string|size:2',
            'platform' => 'nullable|string|in:ios,android',
            'limit' => 'nullable|integer|min:1|max:100',
        ]);

        $country = strtolower($validated['country'] ?? 'us');
        $keyword = strtolower(trim($validated['q']));
        $platform = $validated['platform'] ?? 'ios';
        $limit = $validated['limit'] ?? 50;

        // Get apps ranking for this keyword based on platform
        if ($platform === 'android') {
            $apps = $this->googlePlayService->searchApps($keyword, $country, $limit);
        } else {
            $apps = $this->iTunesService->searchApps($keyword, $country, $limit);
        }

        // Find or create keyword in database
        $keywordModel = Keyword::findOrCreateKeyword($keyword, $country);

        return response()->json([
            'data' => [
                'keyword' => [
                    'id' => $keywordModel->id,
                    'keyword' => $keywordModel->keyword,
                    'storefront' => $keywordModel->storefront,
                    'popularity' => $keywordModel->popularity,
                ],
                'results' => $apps,
                'total_results' => count($apps),
                'platform' => $platform,
            ],
        ]);
    }

    /**
     * Get keywords tracked for a specific app (scoped to current user)
     */
    public function forApp(Request $request, App $app): JsonResponse
    {
        $user = $request->user();

        // Get only keywords tracked by this user for this app
        $trackedKeywords = TrackedKeyword::where('user_id', $user->id)
            ->where('app_id', $app->id)
            ->with('keyword')
            ->get();

        $keywordIds = $trackedKeywords->pluck('keyword_id');
        $keywords = $trackedKeywords->map(fn($tk) => $tk->keyword);

        // Get rankings for user's tracked keywords only
        $rankings = AppRanking::where('app_id', $app->id)
            ->whereIn('keyword_id', $keywordIds)
            ->orderByDesc('recorded_at')
            ->get(['keyword_id', 'position', 'recorded_at']);

        $rankingsByKeyword = [];
        foreach ($rankings as $ranking) {
            $list = $rankingsByKeyword[$ranking->keyword_id] ?? [];
            if (count($list) < 2) {
                $list[] = $ranking;
                $rankingsByKeyword[$ranking->keyword_id] = $list;
            }
        }

        // Map keyword_id to tracked_since date
        $trackedSince = $trackedKeywords->pluck('created_at', 'keyword_id');

        $result = $keywords->map(function ($keyword) use ($rankingsByKeyword, $trackedSince) {
            $entries = $rankingsByKeyword[$keyword->id] ?? [];
            $latest = $entries[0] ?? null;
            $previous = $entries[1] ?? null;
            $change = $latest && $previous && $latest->position && $previous->position
                ? $previous->position - $latest->position
                : null;

            return [
                'id' => $keyword->id,
                'keyword' => $keyword->keyword,
                'storefront' => $keyword->storefront,
                'popularity' => $keyword->popularity,
                'tracked_since' => $trackedSince[$keyword->id] ?? null,
                'position' => $latest?->position,
                'change' => $change,
                'last_updated' => $latest?->recorded_at,
            ];
        });

        return response()->json([
            'data' => $result,
        ]);
    }

    /**
     * Add a keyword to track for an app
     */
    public function addToApp(Request $request, App $app): JsonResponse
    {
        $user = $request->user();

        $validated = $request->validate([
            'keyword' => 'required|string|min:2|max:100',
            'storefront' => 'nullable|string|size:2',
        ]);

        $storefront = strtoupper($validated['storefront'] ?? 'US');
        $keywordText = strtolower(trim($validated['keyword']));

        // Find or create keyword
        $keyword = Keyword::findOrCreateKeyword($keywordText, $storefront);

        // Check if this user is already tracking this keyword for this app
        $existing = TrackedKeyword::where('user_id', $user->id)
            ->where('app_id', $app->id)
            ->where('keyword_id', $keyword->id)
            ->first();

        if ($existing) {
            return response()->json([
                'message' => 'Keyword is already being tracked for this app',
            ], 409);
        }

        // Create tracking for this user
        TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'created_at' => now(),
        ]);

        $country = strtolower($storefront);

        // Check if ranking already exists for today (from another user)
        $existingRanking = $app->rankings()
            ->where('keyword_id', $keyword->id)
            ->where('recorded_at', today())
            ->first();

        if ($existingRanking) {
            // Ranking already exists (shared), use it
            $position = $existingRanking->position;
        } else {
            // Fetch ranking based on app's platform
            $service = $app->platform === 'ios' ? $this->iTunesService : $this->googlePlayService;
            $position = $service->getAppRankForKeyword(
                $app->store_id,
                $keywordText,
                $country
            );

            $app->rankings()->create([
                'keyword_id' => $keyword->id,
                'recorded_at' => today(),
                'position' => $position,
            ]);
        }

        return response()->json([
            'message' => 'Keyword added successfully',
            'data' => [
                'id' => $keyword->id,
                'keyword' => $keyword->keyword,
                'storefront' => $keyword->storefront,
                'position' => $position,
            ],
        ], 201);
    }

    /**
     * Remove a keyword from tracking (for current user only)
     */
    public function removeFromApp(Request $request, App $app, Keyword $keyword): JsonResponse
    {
        $user = $request->user();

        // Delete tracking only for this user
        TrackedKeyword::where('user_id', $user->id)
            ->where('app_id', $app->id)
            ->where('keyword_id', $keyword->id)
            ->delete();

        // Do NOT delete rankings - they are shared between users

        return response()->json([
            'message' => 'Keyword removed successfully',
        ]);
    }

    /**
     * Get keyword popularity history
     */
    public function history(Keyword $keyword): JsonResponse
    {
        $history = $keyword->popularityHistory()
            ->orderBy('recorded_at')
            ->limit(90)
            ->get(['popularity', 'recorded_at']);

        return response()->json([
            'data' => [
                'keyword' => [
                    'id' => $keyword->id,
                    'keyword' => $keyword->keyword,
                    'storefront' => $keyword->storefront,
                    'current_popularity' => $keyword->popularity,
                ],
                'history' => $history,
            ],
        ]);
    }
}
