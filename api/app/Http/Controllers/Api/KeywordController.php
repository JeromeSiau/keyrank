<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppRanking;
use App\Models\Keyword;
use App\Models\Tag;
use App\Models\TrackedKeyword;
use App\Services\iTunesService;
use App\Services\GooglePlayService;
use App\Services\KeywordDiscoveryService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class KeywordController extends Controller
{
    public function __construct(
        private iTunesService $iTunesService,
        private GooglePlayService $googlePlayService,
        private KeywordDiscoveryService $keywordDiscoveryService
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

        // Get only keywords tracked by this user for this app with tags and note
        $trackedKeywords = TrackedKeyword::where('user_id', $user->id)
            ->where('app_id', $app->id)
            ->with(['keyword', 'tags', 'note'])
            ->get();

        $keywordIds = $trackedKeywords->pluck('keyword_id');

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

        $result = $trackedKeywords->map(function ($tracked) use ($rankingsByKeyword) {
            $keyword = $tracked->keyword;
            $entries = $rankingsByKeyword[$keyword->id] ?? [];
            $latest = $entries[0] ?? null;
            $previous = $entries[1] ?? null;
            $change = $latest && $previous && $latest->position && $previous->position
                ? $previous->position - $latest->position
                : null;

            return [
                'id' => $keyword->id,
                'tracked_keyword_id' => $tracked->id,
                'keyword' => $keyword->keyword,
                'storefront' => $keyword->storefront,
                'popularity' => $keyword->popularity,
                'tracked_since' => $tracked->created_at,
                'position' => $latest?->position,
                'change' => $change,
                'last_updated' => $latest?->recorded_at,
                'is_favorite' => $tracked->is_favorite,
                'favorited_at' => $tracked->favorited_at?->toISOString(),
                'tags' => $tracked->tags->map(fn($tag) => [
                    'id' => $tag->id,
                    'name' => $tag->name,
                    'color' => $tag->color,
                ]),
                'note' => $tracked->note?->content,
                'difficulty' => $tracked->difficulty,
                'difficulty_label' => $tracked->difficulty_label,
                'competition' => $tracked->competition,
                'top_competitors' => $tracked->top_competitors,
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

    /**
     * Toggle favorite status for a tracked keyword
     */
    public function toggleFavorite(Request $request, App $app, Keyword $keyword): JsonResponse
    {
        $user = $request->user();

        $tracked = TrackedKeyword::where('user_id', $user->id)
            ->where('app_id', $app->id)
            ->where('keyword_id', $keyword->id)
            ->firstOrFail();

        $newFavorite = !$tracked->is_favorite;

        $tracked->update([
            'is_favorite' => $newFavorite,
            'favorited_at' => $newFavorite ? now() : null,
        ]);

        return response()->json([
            'data' => [
                'is_favorite' => $tracked->is_favorite,
                'favorited_at' => $tracked->favorited_at?->toISOString(),
            ],
        ]);
    }

    /**
     * Get keyword suggestions for an app
     */
    public function suggestions(Request $request, App $app): JsonResponse
    {
        $validated = $request->validate([
            'country' => 'nullable|string|size:2',
            'limit' => 'nullable|integer|min:1|max:50',
        ]);

        $country = strtoupper($validated['country'] ?? 'US');
        $limit = $validated['limit'] ?? 30;

        if ($app->platform === 'android') {
            $response = $this->googlePlayService->getSuggestionsForApp(
                $app->store_id,
                $country,
                $limit
            );

            // Response already has correct format from scraper
            if (empty($response)) {
                return response()->json([
                    'data' => [],
                    'meta' => [
                        'app_id' => $app->store_id,
                        'country' => $country,
                        'total' => 0,
                        'generated_at' => now()->toIso8601String(),
                    ],
                ]);
            }

            return response()->json($response);
        }

        // iOS - use KeywordDiscoveryService
        $suggestions = $this->keywordDiscoveryService->getSuggestionsForApp(
            $app->store_id,
            $country,
            $limit
        );

        return response()->json([
            'data' => $suggestions,
            'meta' => [
                'app_id' => $app->store_id,
                'country' => $country,
                'total' => count($suggestions),
                'generated_at' => now()->toIso8601String(),
            ],
        ]);
    }

    /**
     * Bulk delete tracked keywords
     */
    public function bulkDelete(Request $request, App $app): JsonResponse
    {
        $validated = $request->validate([
            'tracked_keyword_ids' => 'required|array|min:1',
            'tracked_keyword_ids.*' => 'integer|exists:tracked_keywords,id',
        ]);

        $user = $request->user();

        $deletedCount = TrackedKeyword::whereIn('id', $validated['tracked_keyword_ids'])
            ->where('user_id', $user->id)
            ->where('app_id', $app->id)
            ->delete();

        return response()->json([
            'data' => [
                'deleted_count' => $deletedCount,
            ],
        ]);
    }

    /**
     * Bulk add tags to tracked keywords
     */
    public function bulkAddTags(Request $request, App $app): JsonResponse
    {
        $validated = $request->validate([
            'tracked_keyword_ids' => 'required|array|min:1',
            'tracked_keyword_ids.*' => 'integer|exists:tracked_keywords,id',
            'tag_ids' => 'required|array|min:1',
            'tag_ids.*' => 'integer|exists:tags,id',
        ]);

        $user = $request->user();

        // Verify all tags belong to user
        $userTagIds = Tag::where('user_id', $user->id)
            ->whereIn('id', $validated['tag_ids'])
            ->pluck('id')
            ->toArray();

        if (count($userTagIds) !== count($validated['tag_ids'])) {
            abort(403, 'Some tags do not belong to you');
        }

        $trackedKeywords = TrackedKeyword::whereIn('id', $validated['tracked_keyword_ids'])
            ->where('user_id', $user->id)
            ->where('app_id', $app->id)
            ->get();

        foreach ($trackedKeywords as $tracked) {
            $tracked->tags()->syncWithoutDetaching($userTagIds);
        }

        return response()->json([
            'data' => [
                'updated_count' => $trackedKeywords->count(),
            ],
        ]);
    }

    /**
     * Bulk toggle favorite status for tracked keywords
     */
    public function bulkFavorite(Request $request, App $app): JsonResponse
    {
        $validated = $request->validate([
            'tracked_keyword_ids' => 'required|array|min:1',
            'tracked_keyword_ids.*' => 'integer|exists:tracked_keywords,id',
            'is_favorite' => 'required|boolean',
        ]);

        $user = $request->user();
        $isFavorite = $validated['is_favorite'];

        $updatedCount = TrackedKeyword::whereIn('id', $validated['tracked_keyword_ids'])
            ->where('user_id', $user->id)
            ->where('app_id', $app->id)
            ->update([
                'is_favorite' => $isFavorite,
                'favorited_at' => $isFavorite ? now() : null,
            ]);

        return response()->json([
            'data' => [
                'updated_count' => $updatedCount,
            ],
        ]);
    }

    /**
     * Import keywords from text (one keyword per line)
     */
    public function import(Request $request, App $app): JsonResponse
    {
        $validated = $request->validate([
            'keywords' => 'required|string',
            'storefront' => 'nullable|string|size:2',
        ]);

        $user = $request->user();
        $storefront = strtoupper($validated['storefront'] ?? 'US');

        // Parse keywords (one per line, trim whitespace, remove empty lines)
        $lines = array_filter(
            array_map('trim', explode("\n", $validated['keywords'])),
            fn($line) => strlen($line) >= 2 && strlen($line) <= 100
        );

        $imported = 0;
        $skipped = 0;
        $errors = [];

        foreach ($lines as $keywordText) {
            $keywordText = strtolower($keywordText);

            try {
                // Find or create keyword
                $keyword = Keyword::findOrCreateKeyword($keywordText, $storefront);

                // Check if already tracked
                $existing = TrackedKeyword::where('user_id', $user->id)
                    ->where('app_id', $app->id)
                    ->where('keyword_id', $keyword->id)
                    ->first();

                if ($existing) {
                    $skipped++;
                    continue;
                }

                // Create tracking
                TrackedKeyword::create([
                    'user_id' => $user->id,
                    'app_id' => $app->id,
                    'keyword_id' => $keyword->id,
                    'created_at' => now(),
                ]);

                $imported++;
            } catch (\Exception $e) {
                $errors[] = $keywordText;
            }
        }

        return response()->json([
            'data' => [
                'imported' => $imported,
                'skipped' => $skipped,
                'errors' => count($errors),
                'total' => count($lines),
            ],
        ]);
    }
}
