<?php

namespace App\Jobs\Collectors;

use App\Models\App;
use App\Services\GooglePlayService;
use App\Services\iTunesService;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class AppDiscoveryCollector extends BaseCollector
{
    protected int $rateLimitMs = 300;
    public int $timeout = 7200; // 2 hours

    private iTunesService $iTunesService;
    private GooglePlayService $googlePlayService;

    public function __construct()
    {
        parent::__construct();
        $this->iTunesService = app(iTunesService::class);
        $this->googlePlayService = app(GooglePlayService::class);
    }

    public function getCollectorName(): string
    {
        return 'AppDiscoveryCollector';
    }

    /**
     * Get apps to discover related apps from
     * Focus on apps with high rating counts (popular apps)
     */
    public function getItems(): Collection
    {
        // Get all tracked apps that have been updated recently
        return App::select('id', 'platform', 'store_id', 'developer', 'name')
            ->where('rating_count', '>', 1000) // Focus on popular apps
            ->orderByDesc('rating_count')
            ->limit(500) // Process top 500 apps
            ->get();
    }

    /**
     * Discover apps related to this one
     */
    public function processItem(mixed $item): void
    {
        $app = $item;

        // 1. Discover apps by same developer
        $this->discoverByDeveloper($app);

        // 2. Discover similar/related apps (iOS only via iTunes)
        if ($app->platform === 'ios') {
            $this->discoverRelatedIos($app);
        }
    }

    /**
     * Discover all apps by the same developer
     */
    private function discoverByDeveloper(App $app): void
    {
        if (empty($app->developer)) {
            return;
        }

        if ($app->platform === 'ios') {
            $this->discoverIosDeveloperApps($app);
        } else {
            $this->discoverAndroidDeveloperApps($app);
        }
    }

    /**
     * Get all iOS apps from a developer
     */
    private function discoverIosDeveloperApps(App $app): void
    {
        try {
            // Search by developer name to find their other apps
            $response = Http::timeout(15)->get('https://itunes.apple.com/lookup', [
                'id' => $app->store_id,
                'entity' => 'software',
            ]);

            if (!$response->successful()) {
                return;
            }

            $results = $response->json('results', []);

            // First result is the app itself, rest are developer's other apps
            foreach (array_slice($results, 1, 20) as $appData) {
                $this->saveDiscoveredApp('ios', $appData, 'same_developer', $app->id);
            }
        } catch (\Exception $e) {
            Log::debug("[AppDiscoveryCollector] iOS developer lookup failed for {$app->store_id}: " . $e->getMessage());
        }
    }

    /**
     * Get all Android apps from a developer
     */
    private function discoverAndroidDeveloperApps(App $app): void
    {
        try {
            $scraperUrl = config('services.gplay_scraper.url', 'http://localhost:3001');

            $response = Http::timeout(30)->get("{$scraperUrl}/developer/{$app->developer}", [
                'num' => 50,
            ]);

            if (!$response->successful()) {
                return;
            }

            $apps = $response->json('results', []);

            foreach ($apps as $appData) {
                $this->saveDiscoveredApp('android', $appData, 'same_developer', $app->id);
            }
        } catch (\Exception $e) {
            Log::debug("[AppDiscoveryCollector] Android developer lookup failed for {$app->developer}: " . $e->getMessage());
        }
    }

    /**
     * Discover related/similar iOS apps
     */
    private function discoverRelatedIos(App $app): void
    {
        try {
            // Use the app's store URL to find related apps via iTunes
            $response = Http::timeout(15)->get('https://itunes.apple.com/lookup', [
                'id' => $app->store_id,
                'entity' => 'software',
                'limit' => 25,
            ]);

            if (!$response->successful()) {
                return;
            }

            $results = $response->json('results', []);

            foreach (array_slice($results, 1) as $appData) {
                $storeId = (string) ($appData['trackId'] ?? '');
                if ($storeId && $storeId !== $app->store_id) {
                    $this->saveDiscoveredApp('ios', $appData, 'related', $app->id);
                }
            }
        } catch (\Exception $e) {
            Log::debug("[AppDiscoveryCollector] iOS related apps failed for {$app->store_id}: " . $e->getMessage());
        }
    }

    /**
     * Save a discovered app to the database
     */
    private function saveDiscoveredApp(string $platform, array $appData, string $source, int $discoveredFromAppId): void
    {
        $storeId = $platform === 'ios'
            ? (string) ($appData['trackId'] ?? '')
            : ($appData['appId'] ?? $appData['google_play_id'] ?? '');

        if (empty($storeId)) {
            return;
        }

        $name = $platform === 'ios'
            ? ($appData['trackName'] ?? 'Unknown')
            : ($appData['title'] ?? $appData['name'] ?? 'Unknown');

        $developer = $platform === 'ios'
            ? ($appData['artistName'] ?? null)
            : ($appData['developer'] ?? $appData['developerName'] ?? null);

        $iconUrl = $platform === 'ios'
            ? ($appData['artworkUrl100'] ?? null)
            : ($appData['icon'] ?? $appData['icon_url'] ?? null);

        $rating = $platform === 'ios'
            ? ($appData['averageUserRating'] ?? null)
            : ($appData['score'] ?? $appData['rating'] ?? null);

        $ratingCount = $platform === 'ios'
            ? ($appData['userRatingCount'] ?? 0)
            : ($appData['ratings'] ?? $appData['rating_count'] ?? 0);

        // Upsert the app
        App::updateOrCreate(
            [
                'platform' => $platform,
                'store_id' => $storeId,
            ],
            [
                'name' => $name,
                'developer' => $developer,
                'icon_url' => $iconUrl,
                'rating' => $rating,
                'rating_count' => $ratingCount,
                'discovered_from_app_id' => $discoveredFromAppId,
                'discovery_source' => $source,
            ]
        );
    }

    protected function getItemIdentifier(mixed $item): string
    {
        return "{$item->platform}:{$item->store_id}";
    }
}
