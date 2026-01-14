<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppCompetitor;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CompetitorController extends Controller
{
    /**
     * List all competitors (global + contextual) for the authenticated user.
     */
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();
        $ownerAppId = $request->query('app_id');

        // Global competitors
        $globalCompetitors = App::competitorsFor($user->id)
            ->with(['latestRankings', 'latestRatings'])
            ->get()
            ->map(fn($app) => $this->formatCompetitor($app, 'global'));

        // Contextual competitors (if app_id provided)
        $contextualCompetitors = collect();
        if ($ownerAppId) {
            $contextualCompetitors = AppCompetitor::where('user_id', $user->id)
                ->where('owner_app_id', $ownerAppId)
                ->with(['competitorApp.latestRankings', 'competitorApp.latestRatings'])
                ->get()
                ->map(fn($link) => $this->formatCompetitor($link->competitorApp, 'contextual', $link));
        }

        // Merge and deduplicate (contextual takes precedence)
        $contextualIds = $contextualCompetitors->pluck('id')->toArray();
        $merged = $contextualCompetitors->merge(
            $globalCompetitors->filter(fn($c) => !in_array($c['id'], $contextualIds))
        );

        return response()->json([
            'competitors' => $merged->values(),
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

        // Check if already tracked
        $existing = $user->apps()->where('apps.id', $appId)->first();
        if ($existing) {
            // Update to mark as competitor if not already
            $user->apps()->updateExistingPivot($appId, ['is_competitor' => true]);
        } else {
            // Attach as competitor
            $user->apps()->attach($appId, ['is_competitor' => true]);
        }

        $app = App::with(['latestRankings', 'latestRatings'])->find($appId);

        return response()->json([
            'competitor' => $this->formatCompetitor($app, 'global'),
        ], 201);
    }

    /**
     * Remove a global competitor.
     */
    public function destroy(Request $request, int $appId): JsonResponse
    {
        $user = $request->user();

        // Remove competitor flag (keep app if is_owner)
        $pivot = $user->apps()->where('apps.id', $appId)->first();
        if ($pivot) {
            if ($pivot->pivot->is_owner) {
                // Just remove competitor flag
                $user->apps()->updateExistingPivot($appId, ['is_competitor' => false]);
            } else {
                // Remove completely
                $user->apps()->detach($appId);
            }
        }

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

        // Ensure competitor app is tracked
        $existing = $user->apps()->where('apps.id', $competitorAppId)->first();
        if (!$existing) {
            $user->apps()->attach($competitorAppId, ['is_competitor' => true]);
        }

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

        // Contextual competitors for this app
        $contextual = AppCompetitor::where('user_id', $user->id)
            ->where('owner_app_id', $appId)
            ->with(['competitorApp.latestRankings', 'competitorApp.latestRatings'])
            ->get()
            ->map(fn($link) => $this->formatCompetitor($link->competitorApp, 'contextual', $link));

        // Global competitors
        $global = App::competitorsFor($user->id)
            ->with(['latestRankings', 'latestRatings'])
            ->get()
            ->map(fn($app) => $this->formatCompetitor($app, 'global'));

        // Merge (contextual first, then global excluding duplicates)
        $contextualIds = $contextual->pluck('id')->toArray();
        $merged = $contextual->merge(
            $global->filter(fn($c) => !in_array($c['id'], $contextualIds))
        );

        return response()->json([
            'competitors' => $merged->values(),
        ]);
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
}
