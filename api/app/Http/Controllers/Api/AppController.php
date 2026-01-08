<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
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
        $apps = $request->user()
            ->apps()
            ->withCount('trackedKeywords')
            ->latest()
            ->get();

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

        // Check for duplicate
        $existing = $user->apps()
            ->where('platform', $platform)
            ->where('store_id', $storeId)
            ->first();

        if ($existing) {
            return response()->json([
                'message' => 'You are already tracking this app',
                'data' => $existing,
            ], 409);
        }

        // Fetch details from appropriate store
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
            'user_id' => $user->id,
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
        // Ensure user owns this app
        if ($app->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $app->load(['trackedKeywords.keyword']);
        $app->loadCount('trackedKeywords');

        return response()->json([
            'data' => $app,
        ]);
    }

    /**
     * Delete a tracked app
     */
    public function destroy(Request $request, App $app): JsonResponse
    {
        // Ensure user owns this app
        if ($app->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $app->delete();

        return response()->json([
            'message' => 'App removed successfully',
        ]);
    }

    /**
     * Refresh app details from store
     */
    public function refresh(Request $request, App $app): JsonResponse
    {
        // Ensure user owns this app
        if ($app->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

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
}
