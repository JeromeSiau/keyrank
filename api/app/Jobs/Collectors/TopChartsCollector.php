<?php

namespace App\Jobs\Collectors;

use App\Models\App;
use App\Models\TopAppEntry;
use App\Services\GooglePlayService;
use App\Services\iTunesService;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Log;

class TopChartsCollector extends BaseCollector
{
    protected int $rateLimitMs = 150; // Faster for RSS feeds
    public int $timeout = 7200; // 2 hours

    private iTunesService $iTunesService;
    private GooglePlayService $googlePlayService;
    private bool $androidHealthy = false;

    public function __construct()
    {
        parent::__construct();
        $this->iTunesService = app(iTunesService::class);
        $this->googlePlayService = app(GooglePlayService::class);
    }

    public function getCollectorName(): string
    {
        return 'TopChartsCollector';
    }

    /**
     * Get all chart combinations to fetch
     * Returns: [platform, country, category_id, collection]
     */
    public function getItems(): Collection
    {
        $items = collect();

        $countries = config('aso.top_apps.countries', ['us']);
        $collections = config('aso.top_apps.collections', ['top_free']);

        // Check Android scraper availability once
        $this->androidHealthy = $this->googlePlayService->isHealthy();

        if (!$this->androidHealthy) {
            Log::warning('[TopChartsCollector] Google Play scraper not available, skipping Android');
        }

        // iOS categories
        foreach (iTunesService::getCategories() as $categoryId => $categoryName) {
            foreach ($countries as $country) {
                foreach ($collections as $collection) {
                    $items->push([
                        'platform' => 'ios',
                        'country' => $country,
                        'category_id' => $categoryId,
                        'category_name' => $categoryName,
                        'collection' => $collection,
                    ]);
                }
            }
        }

        // Android categories (only if scraper is healthy)
        if ($this->androidHealthy) {
            foreach (GooglePlayService::getCategories() as $categoryId => $categoryName) {
                foreach ($countries as $country) {
                    foreach ($collections as $collection) {
                        // Android doesn't have top_grossing in the same way
                        if ($collection === 'top_grossing') {
                            continue;
                        }

                        $items->push([
                            'platform' => 'android',
                            'country' => $country,
                            'category_id' => $categoryId,
                            'category_name' => $categoryName,
                            'collection' => $collection,
                        ]);
                    }
                }
            }
        }

        return $items;
    }

    /**
     * Process a single chart (fetch and save top apps)
     */
    public function processItem(mixed $item): void
    {
        $platform = $item['platform'];
        $country = $item['country'];
        $categoryId = $item['category_id'];
        $collection = $item['collection'];
        $limit = config('aso.top_apps.limit', 100);

        // Fetch top apps
        $apps = $platform === 'ios'
            ? $this->iTunesService->getTopApps($categoryId, $country, $collection, $limit)
            : $this->googlePlayService->getTopApps($categoryId, $country, $collection, $limit);

        if (empty($apps)) {
            return;
        }

        $today = today();

        foreach ($apps as $index => $appData) {
            $this->saveTopApp($platform, $categoryId, $country, $collection, $appData, $index, $today);
        }
    }

    /**
     * Save a single top app entry
     */
    private function saveTopApp(
        string $platform,
        string $categoryId,
        string $country,
        string $collection,
        array $appData,
        int $index,
        $date
    ): void {
        // Extract store ID based on platform
        $storeId = $platform === 'ios'
            ? ($appData['apple_id'] ?? null)
            : ($appData['appId'] ?? $appData['google_play_id'] ?? null);

        if (!$storeId) {
            return;
        }

        $name = $appData['name'] ?? $appData['title'] ?? 'Unknown';
        $developer = $appData['developer'] ?? $appData['developerName'] ?? null;
        $iconUrl = $appData['icon_url'] ?? $appData['icon'] ?? null;
        $rating = $appData['rating'] ?? $appData['score'] ?? null;
        $ratingCount = $appData['rating_count'] ?? $appData['ratings'] ?? null;
        $position = $appData['position'] ?? ($index + 1);

        // 1. Upsert app in apps table
        $app = App::updateOrCreate(
            [
                'platform' => $platform,
                'store_id' => $storeId,
            ],
            [
                'name' => $name,
                'developer' => $developer,
                'icon_url' => $iconUrl,
                'rating' => $rating,
                'rating_count' => $ratingCount ?? 0,
            ]
        );

        // 2. Save ranking to top_app_entries
        TopAppEntry::updateOrCreate(
            [
                'app_id' => $app->id,
                'category_id' => $categoryId,
                'collection' => $collection,
                'country' => $country,
                'recorded_at' => $date,
            ],
            [
                'position' => $position,
            ]
        );
    }

    protected function getItemIdentifier(mixed $item): string
    {
        return "{$item['platform']}:{$item['country']}:{$item['category_id']}:{$item['collection']}";
    }
}
