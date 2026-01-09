<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\TrackedKeyword;
use App\Services\iTunesService;
use App\Services\GooglePlayService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AppController extends Controller
{
    public function __construct(
        private iTunesService $iTunesService,
        private GooglePlayService $googlePlayService
    ) {}

    /**
     * List user's tracked apps
     */
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();

        $apps = $user
            ->apps()
            ->withCount('trackedKeywords')
            ->get()
            ->map(function ($app) use ($user) {
                $app->is_favorite = (bool) $app->pivot->is_favorite;
                $app->favorited_at = $app->pivot->favorited_at;

                // Get best rank (lowest position) from today's rankings for user's tracked keywords
                $userKeywordIds = $app->trackedKeywords()
                    ->where('user_id', $user->id)
                    ->pluck('keyword_id');

                $app->best_rank = $app->rankings()
                    ->whereIn('keyword_id', $userKeywordIds)
                    ->whereDate('recorded_at', today())
                    ->whereNotNull('position')
                    ->min('position');

                return $app;
            })
            ->sortBy([
                ['is_favorite', 'desc'],
                ['favorited_at', 'desc'],
                ['name', 'asc'],
            ])
            ->values();

        return response()->json([
            'data' => $apps,
        ]);
    }

    /**
     * Search apps on the App Store (iOS)
     */
    public function search(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'q' => 'required|string|min:2',
            'country' => 'nullable|string|size:2',
            'limit' => 'nullable|integer|min:1|max:50',
        ]);

        $results = $this->iTunesService->searchApps(
            $validated['q'],
            $validated['country'] ?? 'us',
            $validated['limit'] ?? 20
        );

        return response()->json([
            'data' => $results,
        ]);
    }

    /**
     * Search apps on Google Play (Android)
     */
    public function searchAndroid(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'q' => 'required|string|min:2',
            'country' => 'nullable|string|size:2',
            'limit' => 'nullable|integer|min:1|max:100',
        ]);

        $results = $this->googlePlayService->searchApps(
            $validated['q'],
            $validated['country'] ?? 'us',
            $validated['limit'] ?? 30
        );

        return response()->json([
            'data' => $results,
        ]);
    }

    /**
     * Add an app to track
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'platform' => 'required|string|in:ios,android',
            'store_id' => 'required|string',
            'country' => 'nullable|string|size:2',
        ]);

        $user = $request->user();
        $platform = $validated['platform'];
        $storeId = $validated['store_id'];
        $country = $validated['country'] ?? 'us';

        // Check if user already follows this app
        $existingForUser = $user->apps()
            ->where('platform', $platform)
            ->where('store_id', $storeId)
            ->first();

        if ($existingForUser) {
            return response()->json([
                'message' => 'You are already tracking this app',
                'data' => $existingForUser,
            ], 409);
        }

        // Check if app exists globally (shared)
        $app = App::where('platform', $platform)
            ->where('store_id', $storeId)
            ->first();

        if ($app) {
            // App exists, just attach user to it
            $app->users()->attach($user->id);

            return response()->json([
                'message' => 'App added successfully',
                'data' => $app,
            ], 201);
        }

        // App doesn't exist, fetch details and create it
        if ($platform === 'ios') {
            $details = $this->iTunesService->getAppDetails($storeId, $country);
            if (!$details) {
                return response()->json([
                    'message' => 'App not found in App Store',
                ], 404);
            }
        } else {
            $details = $this->googlePlayService->getAppDetails($storeId, $country);
            if (!$details) {
                return response()->json([
                    'message' => 'App not found in Play Store',
                ], 404);
            }
        }

        $app = App::create([
            'platform' => $platform,
            'store_id' => $storeId,
            'name' => $details['name'] ?? 'Unknown',
            'bundle_id' => $details['bundle_id'] ?? null,
            'icon_url' => $details['icon_url'] ?? null,
            'developer' => $details['developer'] ?? null,
            'rating' => $details['rating'] ?? null,
            'rating_count' => $details['rating_count'] ?? 0,
            'storefront' => strtoupper($country),
        ]);

        // Attach user to newly created app
        $app->users()->attach($user->id);

        return response()->json([
            'message' => 'App added successfully',
            'data' => $app,
        ], 201);
    }

    /**
     * Get app details
     */
    public function show(Request $request, App $app): JsonResponse
    {
        // Load only this user's tracked keywords for this app
        $user = $request->user();
        $app->load(['trackedKeywords' => function ($query) use ($user) {
            $query->where('user_id', $user->id)->with('keyword');
        }]);
        $app->tracked_keywords_count = $app->trackedKeywords->count();

        return response()->json([
            'data' => $app,
        ]);
    }

    /**
     * Stop tracking an app (detach user)
     */
    public function destroy(Request $request, App $app): JsonResponse
    {
        $user = $request->user();

        // Detach user from app
        $app->users()->detach($user->id);

        // Remove user's tracked keywords for this app
        TrackedKeyword::where('user_id', $user->id)
            ->where('app_id', $app->id)
            ->delete();

        // If no users left tracking this app, delete it entirely
        if ($app->users()->count() === 0) {
            $app->delete();
        }

        return response()->json([
            'message' => 'App removed successfully',
        ]);
    }

    /**
     * Refresh app details from store
     */
    public function refresh(Request $request, App $app): JsonResponse
    {
        // Fetch details from appropriate store based on platform
        if ($app->platform === 'ios') {
            $details = $this->iTunesService->getAppDetails($app->store_id, strtolower($app->storefront ?? 'us'));
        } else {
            $details = $this->googlePlayService->getAppDetails($app->store_id, strtolower($app->storefront ?? 'us'));
        }

        if ($details) {
            $app->update([
                'name' => $details['name'] ?? $app->name,
                'icon_url' => $details['icon_url'] ?? $app->icon_url,
                'developer' => $details['developer'] ?? $app->developer,
                'rating' => $details['rating'] ?? $app->rating,
                'rating_count' => $details['rating_count'] ?? $app->rating_count,
            ]);
        }

        return response()->json([
            'message' => 'App refreshed successfully',
            'data' => $app->fresh(),
        ]);
    }

    /**
     * Toggle app favorite status
     */
    public function toggleFavorite(Request $request, App $app): JsonResponse
    {
        $validated = $request->validate([
            'is_favorite' => 'required|boolean',
        ]);

        $isFavorite = $validated['is_favorite'];

        $request->user()->apps()->updateExistingPivot($app->id, [
            'is_favorite' => $isFavorite,
            'favorited_at' => $isFavorite ? now() : null,
        ]);

        return response()->json([
            'is_favorite' => $isFavorite,
            'favorited_at' => $isFavorite ? now()->toIso8601String() : null,
        ]);
    }
}
