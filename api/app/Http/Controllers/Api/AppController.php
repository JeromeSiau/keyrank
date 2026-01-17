<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Concerns\AuthorizesTeamActions;
use App\Jobs\GenerateKeywordSuggestionsJob;
use App\Models\App;
use App\Models\AppCompetitor;
use App\Models\AppRating;
use App\Models\AppReview;
use App\Models\TrackedKeyword;
use App\Services\iTunesService;
use App\Services\GooglePlayService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class AppController extends Controller
{
    use AuthorizesTeamActions;

    public function __construct(
        private iTunesService $iTunesService,
        private GooglePlayService $googlePlayService
    ) {}

    /**
     * List team's tracked apps
     */
    public function index(Request $request): JsonResponse
    {
        $team = $this->currentTeam();
        $teamId = $team->id;

        // Get all team's tracked keyword IDs (single query)
        $trackedKeywordIds = TrackedKeyword::where('team_id', $teamId)
            ->pluck('keyword_id')
            ->unique()
            ->values();

        // Get best ranks for all apps in a single query
        $bestRanks = [];
        if ($trackedKeywordIds->isNotEmpty()) {
            $bestRanks = \DB::table('app_rankings')
                ->select('app_id', \DB::raw('MIN(position) as best_rank'))
                ->whereIn('keyword_id', $trackedKeywordIds)
                ->whereDate('recorded_at', today())
                ->whereNotNull('position')
                ->groupBy('app_id')
                ->pluck('best_rank', 'app_id')
                ->toArray();
        }

        // Get competitor app IDs for this team
        $competitorAppIds = AppCompetitor::where('team_id', $teamId)
            ->pluck('competitor_app_id')
            ->unique()
            ->toArray();

        // Get apps with tracked keywords count for this team
        $apps = $team
            ->apps()
            ->withCount(['trackedKeywords' => fn($q) => $q->where('team_id', $teamId)])
            ->get()
            ->map(function ($app) use ($bestRanks, $competitorAppIds) {
                $app->is_favorite = (bool) ($app->pivot->is_favorite ?? false);
                $app->favorited_at = $app->pivot->favorited_at ?? null;
                $app->is_owner = (bool) ($app->pivot->is_owner ?? false);
                $app->is_competitor = in_array($app->id, $competitorAppIds);
                $app->best_rank = $bestRanks[$app->id] ?? null;

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
        $this->authorizeTeamAction('manage_apps');

        $validated = $request->validate([
            'platform' => 'required|string|in:ios,android',
            'store_id' => 'required|string',
            'country' => 'nullable|string|size:2',
        ]);

        $team = $this->currentTeam();
        $platform = $validated['platform'];
        $storeId = $validated['store_id'];
        $country = $validated['country'] ?? 'us';

        // Check if team already tracks this app
        $existingForTeam = $team->apps()
            ->where('platform', $platform)
            ->where('store_id', $storeId)
            ->first();

        if ($existingForTeam) {
            return response()->json([
                'message' => 'This app is already being tracked by your team',
                'data' => $existingForTeam,
            ], 409);
        }

        // Check if app exists globally (shared)
        $app = App::where('platform', $platform)
            ->where('store_id', $storeId)
            ->first();

        if ($app) {
            // App exists, attach team to it
            $team->addApp($app, auth()->user());

            // If app is missing details (description), refresh them
            if (empty($app->description)) {
                if ($platform === 'ios') {
                    $details = $this->iTunesService->getAppDetails($storeId, $country);
                } else {
                    $details = $this->googlePlayService->getAppDetails($storeId, $country);
                }

                if ($details) {
                    $categoryId = $platform === 'ios'
                        ? ($details['category_id'] ?? null)
                        : ($details['genre_id'] ?? null);
                    $secondaryCategoryId = $platform === 'ios'
                        ? ($details['secondary_category_id'] ?? null)
                        : null;

                    $app->update([
                        'name' => $details['name'] ?? $app->name,
                        'icon_url' => $details['icon_url'] ?? $app->icon_url,
                        'developer' => $details['developer'] ?? $app->developer,
                        'description' => $details['description'] ?? null,
                        'screenshots' => $details['screenshots'] ?? null,
                        'version' => $details['version'] ?? null,
                        'release_date' => isset($details['release_date']) ? date('Y-m-d', strtotime($details['release_date'])) : null,
                        'updated_date' => isset($details['updated_date']) ? date('Y-m-d H:i:s', strtotime($details['updated_date'])) : null,
                        'size_bytes' => $details['size_bytes'] ?? null,
                        'minimum_os' => $details['minimum_os'] ?? null,
                        'store_url' => $details['store_url'] ?? null,
                        'price' => $details['price'] ?? $app->price,
                        'currency' => $details['currency'] ?? $app->currency,
                        'rating' => $details['rating'] ?? $app->rating,
                        'rating_count' => $details['rating_count'] ?? $app->rating_count,
                        'category_id' => $categoryId ?? $app->category_id,
                        'secondary_category_id' => $secondaryCategoryId ?? $app->secondary_category_id,
                    ]);
                    $app->refresh();
                }
            }

            // Fetch initial ratings and reviews immediately
            $this->fetchInitialData($app);

            // Generate keyword suggestions in background
            GenerateKeywordSuggestionsJob::dispatch($app->id, strtoupper($country));

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

        // Extract category_id based on platform
        $categoryId = null;
        $secondaryCategoryId = null;
        if ($platform === 'ios') {
            $categoryId = $details['category_id'] ?? null;
            $secondaryCategoryId = $details['secondary_category_id'] ?? null;
        } else {
            // Android uses genre_id
            $categoryId = $details['genre_id'] ?? null;
        }

        $app = App::create([
            'platform' => $platform,
            'store_id' => $storeId,
            'name' => $details['name'] ?? 'Unknown',
            'bundle_id' => $details['bundle_id'] ?? null,
            'icon_url' => $details['icon_url'] ?? null,
            'developer' => $details['developer'] ?? null,
            'description' => $details['description'] ?? null,
            'screenshots' => $details['screenshots'] ?? null,
            'version' => $details['version'] ?? null,
            'release_date' => isset($details['release_date']) ? date('Y-m-d', strtotime($details['release_date'])) : null,
            'updated_date' => isset($details['updated_date']) ? date('Y-m-d H:i:s', strtotime($details['updated_date'])) : null,
            'size_bytes' => $details['size_bytes'] ?? null,
            'minimum_os' => $details['minimum_os'] ?? null,
            'store_url' => $details['store_url'] ?? null,
            'price' => $details['price'] ?? null,
            'currency' => $details['currency'] ?? null,
            'rating' => $details['rating'] ?? null,
            'rating_count' => $details['rating_count'] ?? 0,
            'storefront' => strtoupper($country),
            'category_id' => $categoryId,
            'secondary_category_id' => $secondaryCategoryId,
        ]);

        // Attach team to newly created app
        $team->addApp($app, auth()->user());

        // Fetch initial ratings and reviews immediately
        $this->fetchInitialData($app);

        // Generate keyword suggestions in background
        GenerateKeywordSuggestionsJob::dispatch($app->id, strtoupper($country));

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
        $team = $this->currentTeam();

        // Verify team owns this app
        if (!$app->teams()->where('teams.id', $team->id)->exists()) {
            abort(404, 'App not found');
        }

        // Load only this team's tracked keywords for this app
        $app->load(['trackedKeywords' => function ($query) use ($team) {
            $query->where('team_id', $team->id)->with('keyword');
        }]);
        $app->tracked_keywords_count = $app->trackedKeywords->count();

        // Get pivot data for the current team
        $pivot = $team->apps()->where('app_id', $app->id)->first()?->pivot;
        $app->is_owner = (bool) ($pivot->is_owner ?? false);
        $app->is_competitor = AppCompetitor::where('team_id', $team->id)
            ->where('competitor_app_id', $app->id)
            ->exists();

        return response()->json([
            'data' => $app,
        ]);
    }

    /**
     * Stop tracking an app (detach team)
     */
    public function destroy(Request $request, App $app): JsonResponse
    {
        $this->authorizeTeamAction('manage_apps');

        $team = $this->currentTeam();

        // Detach team from app
        $team->removeApp($app);

        // Remove team's tracked keywords for this app
        TrackedKeyword::where('team_id', $team->id)
            ->where('app_id', $app->id)
            ->delete();

        // Also remove team's competitors for this app
        AppCompetitor::where('team_id', $team->id)
            ->where('owner_app_id', $app->id)
            ->delete();

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
            // Extract category_id based on platform
            $categoryId = null;
            $secondaryCategoryId = null;
            if ($app->platform === 'ios') {
                $categoryId = $details['category_id'] ?? null;
                $secondaryCategoryId = $details['secondary_category_id'] ?? null;
            } else {
                $categoryId = $details['genre_id'] ?? null;
            }

            $app->update([
                'name' => $details['name'] ?? $app->name,
                'icon_url' => $details['icon_url'] ?? $app->icon_url,
                'developer' => $details['developer'] ?? $app->developer,
                'description' => $details['description'] ?? $app->description,
                'screenshots' => $details['screenshots'] ?? $app->screenshots,
                'version' => $details['version'] ?? $app->version,
                'release_date' => isset($details['release_date']) ? date('Y-m-d', strtotime($details['release_date'])) : $app->release_date,
                'updated_date' => isset($details['updated_date']) ? date('Y-m-d H:i:s', strtotime($details['updated_date'])) : $app->updated_date,
                'size_bytes' => $details['size_bytes'] ?? $app->size_bytes,
                'minimum_os' => $details['minimum_os'] ?? $app->minimum_os,
                'store_url' => $details['store_url'] ?? $app->store_url,
                'price' => $details['price'] ?? $app->price,
                'currency' => $details['currency'] ?? $app->currency,
                'rating' => $details['rating'] ?? $app->rating,
                'rating_count' => $details['rating_count'] ?? $app->rating_count,
                'category_id' => $categoryId ?? $app->category_id,
                'secondary_category_id' => $secondaryCategoryId ?? $app->secondary_category_id,
            ]);
        }

        return response()->json([
            'message' => 'App refreshed successfully',
            'data' => $app->fresh(),
        ]);
    }

    /**
     * Refresh ratings and reviews data for an app
     */
    public function refreshData(Request $request, App $app): JsonResponse
    {
        $this->fetchInitialData($app);

        return response()->json([
            'message' => 'App data refreshed successfully',
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

        $this->currentTeam()->apps()->updateExistingPivot($app->id, [
            'is_favorite' => $isFavorite,
            'favorited_at' => $isFavorite ? now() : null,
        ]);

        return response()->json([
            'is_favorite' => $isFavorite,
            'favorited_at' => $isFavorite ? now()->toIso8601String() : null,
        ]);
    }

    /**
     * Get apps from the same developer
     */
    public function developerApps(Request $request, App $app): JsonResponse
    {
        if (empty($app->developer)) {
            return response()->json([
                'data' => [],
                'message' => 'Developer information not available',
            ]);
        }

        // Get apps from the same developer (from our database)
        $apps = App::where('developer', $app->developer)
            ->where('platform', $app->platform)
            ->where('id', '!=', $app->id)
            ->orderByDesc('rating_count')
            ->limit(50)
            ->get([
                'id',
                'platform',
                'store_id',
                'name',
                'icon_url',
                'developer',
                'rating',
                'rating_count',
                'category_id',
            ]);

        // If we don't have many apps, try to fetch from store
        if ($apps->count() < 5) {
            $this->discoverDeveloperApps($app);

            // Re-query after discovery
            $apps = App::where('developer', $app->developer)
                ->where('platform', $app->platform)
                ->where('id', '!=', $app->id)
                ->orderByDesc('rating_count')
                ->limit(50)
                ->get([
                    'id',
                    'platform',
                    'store_id',
                    'name',
                    'icon_url',
                    'developer',
                    'rating',
                    'rating_count',
                    'category_id',
                ]);
        }

        return response()->json([
            'data' => $apps,
            'developer' => $app->developer,
            'total' => $apps->count(),
        ]);
    }

    /**
     * Discover apps from the same developer
     */
    private function discoverDeveloperApps(App $app): void
    {
        if ($app->platform === 'ios') {
            // iTunes lookup with entity=software returns all apps by developer
            $response = Http::timeout(15)->get('https://itunes.apple.com/lookup', [
                'id' => $app->store_id,
                'entity' => 'software',
                'limit' => 50,
            ]);

            if ($response->successful()) {
                $results = $response->json('results', []);

                foreach (array_slice($results, 1) as $appData) {
                    $storeId = (string) ($appData['trackId'] ?? '');
                    if (empty($storeId) || $storeId === $app->store_id) continue;

                    App::updateOrCreate(
                        ['platform' => 'ios', 'store_id' => $storeId],
                        [
                            'name' => $appData['trackName'] ?? 'Unknown',
                            'developer' => $appData['artistName'] ?? $app->developer,
                            'icon_url' => $appData['artworkUrl100'] ?? null,
                            'rating' => $appData['averageUserRating'] ?? null,
                            'rating_count' => $appData['userRatingCount'] ?? 0,
                            'category_id' => $appData['primaryGenreId'] ?? null,
                            'discovered_from_app_id' => $app->id,
                            'discovery_source' => 'same_developer',
                        ]
                    );
                }
            }
        } else {
            // Try Google Play scraper
            $scraperUrl = config('services.gplay_scraper.url', 'http://localhost:3001');

            try {
                $response = Http::timeout(30)->get("{$scraperUrl}/developer", [
                    'devId' => $app->developer,
                    'num' => 50,
                ]);

                if ($response->successful()) {
                    $results = $response->json('results', $response->json());

                    foreach ($results as $appData) {
                        $storeId = $appData['appId'] ?? $appData['google_play_id'] ?? null;
                        if (empty($storeId) || $storeId === $app->store_id) continue;

                        App::updateOrCreate(
                            ['platform' => 'android', 'store_id' => $storeId],
                            [
                                'name' => $appData['title'] ?? $appData['name'] ?? 'Unknown',
                                'developer' => $appData['developer'] ?? $app->developer,
                                'icon_url' => $appData['icon'] ?? $appData['icon_url'] ?? null,
                                'rating' => $appData['score'] ?? $appData['rating'] ?? null,
                                'rating_count' => $appData['ratings'] ?? $appData['rating_count'] ?? 0,
                                'discovered_from_app_id' => $app->id,
                                'discovery_source' => 'same_developer',
                            ]
                        );
                    }
                }
            } catch (\Exception $e) {
                \Log::debug("Failed to fetch developer apps: " . $e->getMessage());
            }
        }
    }

    /**
     * Preview app details without tracking
     */
    public function preview(Request $request, string $platform, string $storeId): JsonResponse
    {
        $validated = $request->validate([
            'country' => 'nullable|string|size:2',
        ]);

        $country = $validated['country'] ?? 'us';

        // First check if we already have this app in our database (faster)
        $app = App::where('platform', $platform)
            ->where('store_id', $storeId)
            ->first();

        if ($app) {
            // If app is missing detailed info (screenshots, description), fetch from store
            if (empty($app->screenshots) || empty($app->description)) {
                if ($platform === 'ios') {
                    $details = $this->iTunesService->getAppDetails($storeId, $country);
                } else {
                    $details = $this->googlePlayService->getAppDetails($storeId, $country);
                }

                if ($details) {
                    // Parse dates safely (avoid 1970-01-01 from invalid timestamps)
                    $releaseDate = null;
                    if (!empty($details['release_date'])) {
                        $ts = strtotime($details['release_date']);
                        if ($ts && $ts > 0) {
                            $releaseDate = date('Y-m-d', $ts);
                        }
                    }

                    $updatedDate = null;
                    $updatedRaw = $details['updated_date'] ?? $details['updated'] ?? null;
                    if (!empty($updatedRaw)) {
                        $ts = is_numeric($updatedRaw) ? (int) ($updatedRaw / 1000) : strtotime($updatedRaw);
                        if ($ts && $ts > 86400) { // After 1970-01-02
                            $updatedDate = date('Y-m-d H:i:s', $ts);
                        }
                    }

                    $app->update([
                        'description' => $app->description ?? ($details['description'] ?? null),
                        'screenshots' => $app->screenshots ?? ($details['screenshots'] ?? null),
                        'version' => $app->version ?? ($details['version'] ?? null),
                        'release_date' => $app->release_date ?? $releaseDate,
                        'updated_date' => $app->updated_date ?? $updatedDate,
                        'size_bytes' => $app->size_bytes ?? ($details['size_bytes'] ?? null),
                        'minimum_os' => $app->minimum_os ?? ($details['minimum_os'] ?? null),
                        'store_url' => $app->store_url ?? ($details['store_url'] ?? null),
                        'category_id' => $app->category_id ?? ($details['category_id'] ?? $details['genre_id'] ?? null),
                    ]);
                    $app->refresh();
                }
            }

            // Get category name from ID
            $categoryName = $this->getCategoryName($app->platform, $app->category_id);

            // Return data from our database
            return response()->json([
                'data' => [
                    'platform' => $app->platform,
                    'store_id' => $app->store_id,
                    'name' => $app->name,
                    'icon_url' => $app->icon_url,
                    'developer' => $app->developer,
                    'description' => $app->description,
                    'screenshots' => $app->screenshots ?? [],
                    'version' => $app->version,
                    'release_date' => $app->release_date?->toDateString(),
                    'updated_date' => $app->updated_date?->toIso8601String(),
                    'size_bytes' => $app->size_bytes,
                    'minimum_os' => $app->minimum_os,
                    'store_url' => $app->store_url,
                    'price' => $app->price,
                    'currency' => $app->currency,
                    'rating' => $app->rating,
                    'rating_count' => $app->rating_count ?? 0,
                    'category_id' => $app->category_id,
                    'category_name' => $categoryName,
                ],
            ]);
        }

        // App not in DB, fetch from external API (for preview before adding)
        if ($platform === 'ios') {
            $details = $this->iTunesService->getAppDetails($storeId, $country);
        } else {
            $details = $this->googlePlayService->getAppDetails($storeId, $country);
        }

        if (!$details) {
            return response()->json([
                'message' => 'App not found',
            ], 404);
        }

        // Normalize the response format from external API
        return response()->json([
            'data' => [
                'platform' => $platform,
                'store_id' => $platform === 'ios' ? ($details['apple_id'] ?? $storeId) : ($details['google_play_id'] ?? $storeId),
                'name' => $details['name'] ?? null,
                'icon_url' => $details['icon_url'] ?? null,
                'developer' => $details['developer'] ?? null,
                'description' => $details['description'] ?? null,
                'screenshots' => $details['screenshots'] ?? [],
                'version' => $details['version'] ?? null,
                'release_date' => $details['release_date'] ?? null,
                'updated_date' => $details['updated_date'] ?? $details['updated'] ?? null,
                'size_bytes' => $details['size_bytes'] ?? null,
                'minimum_os' => $details['minimum_os'] ?? null,
                'store_url' => $details['store_url'] ?? null,
                'price' => $details['price'] ?? null,
                'currency' => $details['currency'] ?? null,
                'rating' => $details['rating'] ?? null,
                'rating_count' => $details['rating_count'] ?? 0,
                'category_id' => $details['category_id'] ?? $details['genre_id'] ?? null,
                'category_name' => $this->getCategoryName($platform, $details['category_id'] ?? $details['genre_id'] ?? null),
            ],
        ]);
    }

    /**
     * Get category name from category ID
     */
    private function getCategoryName(string $platform, ?string $categoryId): ?string
    {
        if (!$categoryId) {
            return null;
        }

        $categories = $platform === 'ios'
            ? iTunesService::getCategories()
            : GooglePlayService::getCategories();

        return $categories[$categoryId] ?? $categoryId;
    }

    /**
     * Fetch initial ratings and reviews for a newly tracked app.
     * Called immediately when an app is added to provide instant data.
     * Automatically detects all countries where the app is available.
     */
    private function fetchInitialData(App $app): void
    {
        // Use all supported countries - we'll only store data for countries where the app exists
        $countries = config('countries');
        $now = now();

        if ($app->platform === 'ios') {
            $this->fetchIosRatings($app, $countries, $now);
            $this->fetchIosReviews($app, $countries, $now);
        } else {
            $this->fetchAndroidRatings($app, $countries, $now);
            $this->fetchAndroidReviews($app, $countries, $now);
        }
    }

    /**
     * Fetch iOS ratings from iTunes API
     */
    private function fetchIosRatings(App $app, array $countries, $now): void
    {
        // Fetch all countries in parallel
        $responses = Http::pool(fn ($pool) =>
            collect($countries)->map(fn ($country) =>
                $pool->as($country)
                    ->timeout(10)
                    ->get('https://itunes.apple.com/lookup', [
                        'id' => $app->store_id,
                        'country' => $country,
                    ])
            )->toArray()
        );

        $ratings = [];

        foreach ($countries as $country) {
            $response = $responses[$country] ?? null;

            if ($response && $response->successful()) {
                $results = $response->json('results', []);

                if (!empty($results)) {
                    $appData = $results[0];
                    $ratingCount = $appData['userRatingCount'] ?? 0;

                    if ($ratingCount > 0) {
                        $ratings[] = [
                            'app_id' => $app->id,
                            'country' => strtoupper($country),
                            'rating' => $appData['averageUserRating'] ?? null,
                            'rating_count' => $ratingCount,
                            'recorded_at' => $now,
                        ];
                    }
                }
            }
        }

        if (!empty($ratings)) {
            AppRating::upsert(
                $ratings,
                ['app_id', 'country', 'recorded_at'],
                ['rating', 'rating_count']
            );
        }
    }

    /**
     * Fetch Android ratings from Google Play scraper
     */
    private function fetchAndroidRatings(App $app, array $countries, $now): void
    {
        $scraperUrl = config('services.gplay_scraper.url', 'http://localhost:3001');

        $responses = Http::pool(fn ($pool) =>
            collect($countries)->map(fn ($country) =>
                $pool->as($country)
                    ->timeout(15)
                    ->get("{$scraperUrl}/app/{$app->store_id}", [
                        'country' => $country,
                    ])
            )->toArray()
        );

        $ratings = [];

        foreach ($countries as $country) {
            $response = $responses[$country] ?? null;

            if ($response && $response->successful()) {
                $appData = $response->json();

                if ($appData) {
                    $ratingCount = $appData['rating_count'] ?? $appData['ratings'] ?? 0;

                    if ($ratingCount > 0) {
                        $ratings[] = [
                            'app_id' => $app->id,
                            'country' => strtoupper($country),
                            'rating' => $appData['rating'] ?? $appData['score'] ?? null,
                            'rating_count' => $ratingCount,
                            'recorded_at' => $now,
                        ];
                    }
                }
            }
        }

        if (!empty($ratings)) {
            AppRating::upsert(
                $ratings,
                ['app_id', 'country', 'recorded_at'],
                ['rating', 'rating_count']
            );
        }
    }

    /**
     * Fetch iOS reviews from iTunes RSS
     */
    private function fetchIosReviews(App $app, array $countries, $now): void
    {
        foreach ($countries as $country) {
            $reviews = $this->iTunesService->getAllAppReviews($app->store_id, strtolower($country), 3);

            if (empty($reviews)) {
                continue;
            }

            $rows = [];

            foreach ($reviews as $review) {
                $rows[] = [
                    'app_id' => $app->id,
                    'country' => strtoupper($country),
                    'review_id' => $review['review_id'],
                    'author' => $review['author'],
                    'title' => $review['title'],
                    'content' => $review['content'],
                    'rating' => $review['rating'],
                    'version' => $review['version'],
                    'reviewed_at' => $review['reviewed_at'],
                    'created_at' => $now,
                    'updated_at' => $now,
                ];
            }

            AppReview::upsert(
                $rows,
                ['app_id', 'country', 'review_id'],
                ['author', 'title', 'content', 'rating', 'version', 'reviewed_at', 'updated_at']
            );

            usleep(100000); // 0.1s delay between countries
        }
    }

    /**
     * Fetch Android reviews from Google Play scraper
     */
    private function fetchAndroidReviews(App $app, array $countries, $now): void
    {
        $scraperUrl = config('services.gplay_scraper.url', 'http://localhost:3001');

        foreach ($countries as $country) {
            try {
                $response = Http::timeout(20)
                    ->get("{$scraperUrl}/reviews/{$app->store_id}", [
                        'country' => strtolower($country),
                        'num' => 50,
                    ]);

                if (!$response->successful()) {
                    continue;
                }

                $reviews = $response->json('reviews', []);

                if (empty($reviews)) {
                    continue;
                }

                $rows = [];

                foreach ($reviews as $review) {
                    $reviewId = $review['review_id'] ?? $review['id'] ?? sha1(implode('|', [
                        $app->store_id,
                        $country,
                        $review['author'] ?? '',
                        $review['rating'] ?? '',
                        $review['reviewed_at'] ?? $review['date'] ?? '',
                        substr($review['content'] ?? $review['text'] ?? '', 0, 100),
                    ]));

                    $rows[] = [
                        'app_id' => $app->id,
                        'country' => strtoupper($country),
                        'review_id' => $reviewId,
                        'author' => $review['author'] ?? $review['userName'] ?? 'Anonymous',
                        'title' => $review['title'] ?? null,
                        'content' => $review['content'] ?? $review['text'] ?? '',
                        'rating' => $review['rating'] ?? $review['score'] ?? 0,
                        'version' => $review['version'] ?? $review['appVersion'] ?? null,
                        'reviewed_at' => isset($review['reviewed_at'])
                            ? \Carbon\Carbon::parse($review['reviewed_at'])
                            : (isset($review['date']) ? \Carbon\Carbon::parse($review['date']) : $now),
                        'created_at' => $now,
                        'updated_at' => $now,
                    ];
                }

                AppReview::upsert(
                    $rows,
                    ['app_id', 'country', 'review_id'],
                    ['author', 'title', 'content', 'rating', 'version', 'reviewed_at', 'updated_at']
                );

                usleep(200000); // 0.2s delay between countries
            } catch (\Exception $e) {
                \Log::warning("Failed to fetch Android reviews for app {$app->id}: " . $e->getMessage());
            }
        }
    }
}
