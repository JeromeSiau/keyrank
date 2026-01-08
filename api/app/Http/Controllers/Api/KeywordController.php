<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
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
            'keyword' => [
                'id' => $keywordModel->id,
                'keyword' => $keywordModel->keyword,
                'storefront' => $keywordModel->storefront,
                'popularity' => $keywordModel->popularity,
            ],
            'results' => $apps,
            'total_results' => count($apps),
            'platform' => $platform,
        ]);
    }

    /**
     * Get keywords tracked for a specific app
     */
    public function forApp(Request $request, App $app): JsonResponse
    {
        // Ensure user owns this app
        if ($app->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Not found'], 404);
        }

        $keywords = $app->keywords()
            ->withPivot('created_at')
            ->get()
            ->map(function ($keyword) use ($app) {
                $result = [
                    'id' => $keyword->id,
                    'keyword' => $keyword->keyword,
                    'storefront' => $keyword->storefront,
                    'popularity' => $keyword->popularity,
                    'tracked_since' => $keyword->pivot->created_at,
                ];

                // Get iOS rankings if app has iOS
                if ($app->apple_id) {
                    $latestIos = $app->rankings()
                        ->where('keyword_id', $keyword->id)
                        ->where('platform', 'ios')
                        ->orderByDesc('recorded_at')
                        ->first();

                    $previousIos = $latestIos
                        ? $app->rankings()
                            ->where('keyword_id', $keyword->id)
                            ->where('platform', 'ios')
                            ->where('recorded_at', '<', $latestIos->recorded_at)
                            ->orderByDesc('recorded_at')
                            ->first()
                        : null;

                    $result['ios_position'] = $latestIos?->position;
                    $result['ios_change'] = $latestIos && $previousIos && $latestIos->position && $previousIos->position
                        ? $previousIos->position - $latestIos->position
                        : null;
                }

                // Get Android rankings if app has Android
                if ($app->google_play_id) {
                    $latestAndroid = $app->rankings()
                        ->where('keyword_id', $keyword->id)
                        ->where('platform', 'android')
                        ->orderByDesc('recorded_at')
                        ->first();

                    $previousAndroid = $latestAndroid
                        ? $app->rankings()
                            ->where('keyword_id', $keyword->id)
                            ->where('platform', 'android')
                            ->where('recorded_at', '<', $latestAndroid->recorded_at)
                            ->orderByDesc('recorded_at')
                            ->first()
                        : null;

                    $result['android_position'] = $latestAndroid?->position;
                    $result['android_change'] = $latestAndroid && $previousAndroid && $latestAndroid->position && $previousAndroid->position
                        ? $previousAndroid->position - $latestAndroid->position
                        : null;
                }

                // Get latest overall ranking for last_updated
                $latestRanking = $app->rankings()
                    ->where('keyword_id', $keyword->id)
                    ->orderByDesc('recorded_at')
                    ->first();
                $result['last_updated'] = $latestRanking?->recorded_at;

                return $result;
            });

        return response()->json([
            'data' => $keywords,
        ]);
    }

    /**
     * Add a keyword to track for an app
     */
    public function addToApp(Request $request, App $app): JsonResponse
    {
        // Ensure user owns this app
        if ($app->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Not found'], 404);
        }

        $validated = $request->validate([
            'keyword' => 'required|string|min:2|max:100',
            'storefront' => 'nullable|string|size:2',
        ]);

        $storefront = strtoupper($validated['storefront'] ?? 'US');
        $keywordText = strtolower(trim($validated['keyword']));

        // Find or create keyword
        $keyword = Keyword::findOrCreateKeyword($keywordText, $storefront);

        // Check if already tracking
        $existing = TrackedKeyword::where('app_id', $app->id)
            ->where('keyword_id', $keyword->id)
            ->first();

        if ($existing) {
            return response()->json([
                'message' => 'Keyword is already being tracked for this app',
            ], 409);
        }

        // Create tracking
        TrackedKeyword::create([
            'user_id' => $request->user()->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'created_at' => now(),
        ]);

        $country = strtolower($storefront);
        $iosPosition = null;
        $androidPosition = null;

        // Fetch iOS ranking if app has iOS
        if ($app->apple_id) {
            $iosPosition = $this->iTunesService->getAppRankForKeyword(
                $app->apple_id,
                $keywordText,
                $country
            );

            $app->rankings()->updateOrCreate(
                [
                    'keyword_id' => $keyword->id,
                    'platform' => 'ios',
                    'recorded_at' => today(),
                ],
                ['position' => $iosPosition]
            );
        }

        // Fetch Android ranking if app has Android
        if ($app->google_play_id) {
            $androidPosition = $this->googlePlayService->getAppRankForKeyword(
                $app->google_play_id,
                $keywordText,
                $country
            );

            $app->rankings()->updateOrCreate(
                [
                    'keyword_id' => $keyword->id,
                    'platform' => 'android',
                    'recorded_at' => today(),
                ],
                ['position' => $androidPosition]
            );
        }

        return response()->json([
            'message' => 'Keyword added successfully',
            'data' => [
                'id' => $keyword->id,
                'keyword' => $keyword->keyword,
                'storefront' => $keyword->storefront,
                'ios_position' => $iosPosition,
                'android_position' => $androidPosition,
            ],
        ], 201);
    }

    /**
     * Remove a keyword from tracking
     */
    public function removeFromApp(Request $request, App $app, Keyword $keyword): JsonResponse
    {
        // Ensure user owns this app
        if ($app->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Not found'], 404);
        }

        // Delete tracking
        TrackedKeyword::where('app_id', $app->id)
            ->where('keyword_id', $keyword->id)
            ->delete();

        // Delete associated rankings
        $app->rankings()
            ->where('keyword_id', $keyword->id)
            ->delete();

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
            'keyword' => [
                'id' => $keyword->id,
                'keyword' => $keyword->keyword,
                'storefront' => $keyword->storefront,
                'current_popularity' => $keyword->popularity,
            ],
            'history' => $history,
        ]);
    }
}
