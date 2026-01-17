<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Concerns\AuthorizesTeamActions;
use App\Jobs\GenerateKeywordSuggestionsJob;
use App\Models\App;
use App\Models\AppRanking;
use App\Models\Keyword;
use App\Models\KeywordSuggestion;
use App\Models\Tag;
use App\Models\TrackedKeyword;
use App\Services\iTunesService;
use App\Services\GooglePlayService;
use App\Services\KeywordDiscoveryService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class KeywordController extends Controller
{
    use AuthorizesTeamActions;

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

        // Check if keyword exists (for popularity info) but don't create it
        $existingKeyword = Keyword::where('keyword', $keyword)
            ->where('storefront', strtoupper($country))
            ->first();

        return response()->json([
            'data' => [
                'keyword' => $existingKeyword ? [
                    'id' => $existingKeyword->id,
                    'keyword' => $existingKeyword->keyword,
                    'storefront' => $existingKeyword->storefront,
                    'popularity' => $existingKeyword->popularity,
                ] : null,
                'results' => $apps,
                'total_results' => count($apps),
                'platform' => $platform,
            ],
        ]);
    }

    /**
     * Get keywords tracked for a specific app (scoped to current team)
     */
    public function forApp(Request $request, App $app): JsonResponse
    {
        $team = $this->currentTeam();

        // Get only keywords tracked by this team for this app with tags and note
        $trackedKeywords = TrackedKeyword::where('team_id', $team->id)
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
     * Fetches initial ranking immediately for instant feedback
     */
    public function addToApp(Request $request, App $app): JsonResponse
    {
        $this->authorizeTeamAction('manage_keywords');

        $team = $this->currentTeam();

        $validated = $request->validate([
            'keyword' => 'required|string|min:2|max:100',
            'storefront' => 'nullable|string|size:2',
        ]);

        $storefront = strtoupper($validated['storefront'] ?? 'US');
        $keywordText = strtolower(trim($validated['keyword']));

        // Find or create keyword
        $keyword = Keyword::findOrCreateKeyword($keywordText, $storefront);

        // Check if this team is already tracking this keyword for this app
        $existing = TrackedKeyword::where('team_id', $team->id)
            ->where('app_id', $app->id)
            ->where('keyword_id', $keyword->id)
            ->first();

        if ($existing) {
            return response()->json([
                'message' => 'Keyword is already being tracked for this app',
            ], 409);
        }

        // Create tracking for this team
        TrackedKeyword::create([
            'team_id' => $team->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'created_at' => now(),
        ]);

        // Fetch current ranking immediately
        $position = null;
        $now = now();

        try {
            if ($app->platform === 'android') {
                $results = $this->googlePlayService->searchApps($keywordText, strtolower($storefront), 100);
            } else {
                $results = $this->iTunesService->searchApps($keywordText, strtolower($storefront), 100);
            }

            // Find app position in results
            foreach ($results as $result) {
                $resultId = $app->platform === 'android'
                    ? ($result['google_play_id'] ?? null)
                    : ($result['apple_id'] ?? null);

                if ($resultId === $app->store_id) {
                    $position = $result['position'];
                    break;
                }
            }

            // Save ranking to database
            AppRanking::updateOrCreate(
                [
                    'app_id' => $app->id,
                    'keyword_id' => $keyword->id,
                    'recorded_at' => $now->toDateString(),
                ],
                [
                    'position' => $position,
                ]
            );
        } catch (\Exception $e) {
            // Log error but continue
        }

        return response()->json([
            'message' => 'Keyword added successfully',
            'data' => [
                'id' => $keyword->id,
                'keyword' => $keyword->keyword,
                'storefront' => $keyword->storefront,
                'popularity' => $keyword->popularity,
                'position' => $position,
                'last_updated' => $now->toIso8601String(),
            ],
        ], 201);
    }

    /**
     * Remove a keyword from tracking (for current team only)
     */
    public function removeFromApp(Request $request, App $app, Keyword $keyword): JsonResponse
    {
        $this->authorizeTeamAction('manage_keywords');

        $team = $this->currentTeam();

        // Delete tracking only for this team
        TrackedKeyword::where('team_id', $team->id)
            ->where('app_id', $app->id)
            ->where('keyword_id', $keyword->id)
            ->delete();

        // Do NOT delete rankings - they are shared between teams

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
        $this->authorizeTeamAction('manage_keywords');

        $team = $this->currentTeam();

        $tracked = TrackedKeyword::where('team_id', $team->id)
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
     * Get keyword suggestions for an app (from pre-generated cache)
     * Returns suggestions grouped by category
     */
    public function suggestions(Request $request, App $app): JsonResponse
    {
        $validated = $request->validate([
            'country' => 'nullable|string|size:2',
            'limit' => 'nullable|integer|min:1|max:100',
            'category' => 'nullable|string|in:high_opportunity,competitor,long_tail,trending,related',
        ]);

        $country = strtoupper($validated['country'] ?? 'US');
        $limit = $validated['limit'] ?? 60;
        $categoryFilter = $validated['category'] ?? null;

        // Get cached suggestions from database
        $query = KeywordSuggestion::where('app_id', $app->id)
            ->where('country', $country);

        if ($categoryFilter) {
            $query->forCategory($categoryFilter);
        }

        $suggestions = $query->orderByCategory()
            ->orderByOpportunity()
            ->limit($limit)
            ->get();

        $generatedAt = $suggestions->first()?->generated_at;
        $needsRefresh = $suggestions->isEmpty() || ($generatedAt && $generatedAt->diffInDays(now()) >= 7);

        // If no suggestions or stale, dispatch job to generate them
        if ($needsRefresh) {
            GenerateKeywordSuggestionsJob::dispatch($app->id, $country, 15);
        }

        // Group suggestions by category
        $grouped = $suggestions->groupBy('category')->map(function ($items, $category) {
            return $items->map(fn($s) => [
                'keyword' => $s->keyword,
                'source' => $s->source,
                'category' => $s->category,
                'metrics' => [
                    'position' => $s->position,
                    'popularity' => $s->popularity,
                    'competition' => $s->competition,
                    'difficulty' => $s->difficulty,
                    'difficulty_label' => $s->difficulty_label,
                ],
                'reason' => $s->reason,
                'based_on' => $s->based_on,
                'competitor_name' => $s->competitor_name,
                'top_competitors' => $s->top_competitors ?? [],
            ])->values();
        });

        // Ensure all categories exist (even if empty)
        $allCategories = ['high_opportunity', 'competitor', 'long_tail', 'trending', 'related'];
        foreach ($allCategories as $cat) {
            if (!isset($grouped[$cat])) {
                $grouped[$cat] = collect([]);
            }
        }

        // Also provide flat list for backwards compatibility
        $flatList = $suggestions->map(fn($s) => [
            'keyword' => $s->keyword,
            'source' => $s->source,
            'category' => $s->category,
            'metrics' => [
                'position' => $s->position,
                'popularity' => $s->popularity,
                'competition' => $s->competition,
                'difficulty' => $s->difficulty,
                'difficulty_label' => $s->difficulty_label,
            ],
            'reason' => $s->reason,
            'based_on' => $s->based_on,
            'competitor_name' => $s->competitor_name,
            'top_competitors' => $s->top_competitors ?? [],
        ]);

        return response()->json([
            'data' => $flatList,
            'categories' => $grouped,
            'meta' => [
                'app_id' => $app->store_id,
                'country' => $country,
                'total' => $suggestions->count(),
                'by_category' => $grouped->map->count(),
                'generated_at' => $generatedAt?->toIso8601String(),
                'is_generating' => $needsRefresh,
            ],
        ]);
    }

    /**
     * Bulk delete tracked keywords
     */
    public function bulkDelete(Request $request, App $app): JsonResponse
    {
        $this->authorizeTeamAction('manage_keywords');

        $validated = $request->validate([
            'tracked_keyword_ids' => 'required|array|min:1|max:500',
            'tracked_keyword_ids.*' => 'integer|exists:tracked_keywords,id',
        ]);

        $team = $this->currentTeam();

        $deletedCount = TrackedKeyword::whereIn('id', $validated['tracked_keyword_ids'])
            ->where('team_id', $team->id)
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
        $this->authorizeTeamAction('manage_keywords');

        $validated = $request->validate([
            'tracked_keyword_ids' => 'required|array|min:1|max:500',
            'tracked_keyword_ids.*' => 'integer|exists:tracked_keywords,id',
            'tag_ids' => 'required|array|min:1|max:50',
            'tag_ids.*' => 'integer|exists:tags,id',
        ]);

        $team = $this->currentTeam();

        // Verify all tags belong to team
        $teamTagIds = Tag::where('team_id', $team->id)
            ->whereIn('id', $validated['tag_ids'])
            ->pluck('id')
            ->toArray();

        if (count($teamTagIds) !== count($validated['tag_ids'])) {
            abort(403, 'Some tags do not belong to your team');
        }

        $trackedKeywords = TrackedKeyword::whereIn('id', $validated['tracked_keyword_ids'])
            ->where('team_id', $team->id)
            ->where('app_id', $app->id)
            ->get();

        foreach ($trackedKeywords as $tracked) {
            $tracked->tags()->syncWithoutDetaching($teamTagIds);
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
        $this->authorizeTeamAction('manage_keywords');

        $validated = $request->validate([
            'tracked_keyword_ids' => 'required|array|min:1|max:500',
            'tracked_keyword_ids.*' => 'integer|exists:tracked_keywords,id',
            'is_favorite' => 'required|boolean',
        ]);

        $team = $this->currentTeam();
        $isFavorite = $validated['is_favorite'];

        $updatedCount = TrackedKeyword::whereIn('id', $validated['tracked_keyword_ids'])
            ->where('team_id', $team->id)
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
        $this->authorizeTeamAction('manage_keywords');

        $validated = $request->validate([
            'keywords' => 'required|string',
            'storefront' => 'nullable|string|size:2',
        ]);

        $team = $this->currentTeam();
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
                $existing = TrackedKeyword::where('team_id', $team->id)
                    ->where('app_id', $app->id)
                    ->where('keyword_id', $keyword->id)
                    ->first();

                if ($existing) {
                    $skipped++;
                    continue;
                }

                // Create tracking
                TrackedKeyword::create([
                    'team_id' => $team->id,
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
