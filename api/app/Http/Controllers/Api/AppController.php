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
            'apple_id' => 'nullable|string|required_without:google_play_id',
            'google_play_id' => 'nullable|string|required_without:apple_id',
            'country' => 'nullable|string|size:2',
        ]);

        $user = $request->user();
        $country = $validated['country'] ?? 'us';
        $appData = [
            'user_id' => $user->id,
            'storefront' => strtoupper($country),
        ];

        // Fetch iOS details if apple_id provided
        if (!empty($validated['apple_id'])) {
            $appleId = $validated['apple_id'];

            // Check if already tracking this iOS app
            $existing = $user->apps()->where('apple_id', $appleId)->first();
            if ($existing) {
                return response()->json([
                    'message' => 'You are already tracking this iOS app',
                    'data' => $existing,
                ], 409);
            }

            $iosDetails = $this->iTunesService->getAppDetails($appleId, $country);
            if (!$iosDetails) {
                return response()->json([
                    'message' => 'iOS app not found in App Store',
                ], 404);
            }

            $appData['apple_id'] = $appleId;
            $appData['name'] = $iosDetails['name'];
            $appData['bundle_id'] = $iosDetails['bundle_id'];
            $appData['icon_url'] = $iosDetails['icon_url'];
            $appData['developer'] = $iosDetails['developer'];
            $appData['rating'] = $iosDetails['rating'];
            $appData['rating_count'] = $iosDetails['rating_count'];
        }

        // Fetch Android details if google_play_id provided
        if (!empty($validated['google_play_id'])) {
            $googlePlayId = $validated['google_play_id'];

            // Check if already tracking this Android app
            $existing = $user->apps()->where('google_play_id', $googlePlayId)->first();
            if ($existing) {
                return response()->json([
                    'message' => 'You are already tracking this Android app',
                    'data' => $existing,
                ], 409);
            }

            $androidDetails = $this->googlePlayService->getAppDetails($googlePlayId, $country);
            if (!$androidDetails) {
                return response()->json([
                    'message' => 'Android app not found in Play Store',
                ], 404);
            }

            $appData['google_play_id'] = $googlePlayId;
            // Use Android name if no iOS
            if (empty($validated['apple_id'])) {
                $appData['name'] = $androidDetails['name'] ?? 'Unknown';
                $appData['developer'] = $androidDetails['developer'] ?? null;
            }
            $appData['google_icon_url'] = $androidDetails['icon_url'] ?? null;
            $appData['google_rating'] = $androidDetails['rating'] ?? null;
            $appData['google_rating_count'] = $androidDetails['rating_count'] ?? 0;
        }

        $app = App::create($appData);

        return response()->json([
            'message' => 'App added successfully',
            'data' => $app,
        ], 201);
    }

    /**
     * Link an Android app to an existing iOS app
     */
    public function linkAndroid(Request $request, App $app): JsonResponse
    {
        // Ensure user owns this app
        if ($app->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Not found'], 404);
        }

        $validated = $request->validate([
            'google_play_id' => 'required|string',
            'country' => 'nullable|string|size:2',
        ]);

        if ($app->google_play_id) {
            return response()->json([
                'message' => 'App already has Android linked',
            ], 422);
        }

        $googlePlayId = $validated['google_play_id'];
        $country = $validated['country'] ?? 'us';

        $androidDetails = $this->googlePlayService->getAppDetails($googlePlayId, $country);
        if (!$androidDetails) {
            return response()->json([
                'message' => 'Android app not found',
            ], 404);
        }

        $updateData = [
            'google_play_id' => $googlePlayId,
            'google_icon_url' => $androidDetails['icon_url'] ?? null,
            'google_rating' => $androidDetails['rating'] ?? null,
            'google_rating_count' => $androidDetails['rating_count'] ?? 0,
        ];

        // Set storefront if not already set
        if (!$app->storefront) {
            $updateData['storefront'] = strtoupper($country);
        }

        $app->update($updateData);

        return response()->json([
            'message' => 'Android app linked successfully',
            'data' => $app->fresh(),
        ]);
    }

    /**
     * Get app details
     */
    public function show(Request $request, App $app): JsonResponse
    {
        // Ensure user owns this app
        if ($app->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Not found'], 404);
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
            return response()->json(['message' => 'Not found'], 404);
        }

        $app->delete();

        return response()->json([
            'message' => 'App removed successfully',
        ]);
    }

    /**
     * Refresh app details from App Store
     */
    public function refresh(Request $request, App $app): JsonResponse
    {
        // Ensure user owns this app
        if ($app->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Not found'], 404);
        }

        $appDetails = $this->iTunesService->getAppDetails($app->apple_id);

        if ($appDetails) {
            $app->update([
                'name' => $appDetails['name'],
                'icon_url' => $appDetails['icon_url'],
                'developer' => $appDetails['developer'],
                'rating' => $appDetails['rating'],
                'rating_count' => $appDetails['rating_count'],
            ]);
        }

        return response()->json([
            'message' => 'App refreshed successfully',
            'data' => $app->fresh(),
        ]);
    }
}
