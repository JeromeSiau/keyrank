<?php

namespace App\Jobs\Collectors;

use App\Models\App;
use App\Models\AppCategoryRanking;
use App\Models\TopAppEntry;
use App\Services\GooglePlayService;
use App\Services\iTunesService;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Log;

class CategoryRankingCollector extends BaseCollector
{
    protected int $rateLimitMs = 100;
    public int $timeout = 3600; // 1 hour

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
        return 'CategoryRankingCollector';
    }

    /**
     * Get all tracked apps that have a category
     */
    public function getItems(): Collection
    {
        // Get apps that teams are tracking (have entries in team_apps)
        return App::select('id', 'platform', 'store_id', 'name', 'category_id')
            ->whereNotNull('category_id')
            ->whereHas('teams')
            ->get();
    }

    /**
     * Find category ranking for a tracked app
     */
    public function processItem(mixed $item): void
    {
        $app = $item;
        $countries = config('aso.top_apps.countries', ['us']);
        $collections = config('aso.top_apps.collections', ['top_free', 'top_paid', 'top_grossing']);
        $today = today();

        foreach ($countries as $country) {
            foreach ($collections as $collection) {
                // Skip top_grossing for Android
                if ($app->platform === 'android' && $collection === 'top_grossing') {
                    continue;
                }

                // First check if we already have this from TopAppEntry
                $existingEntry = TopAppEntry::where('app_id', $app->id)
                    ->where('category_id', $app->category_id)
                    ->where('country', $country)
                    ->where('collection', $collection)
                    ->whereDate('recorded_at', $today)
                    ->first();

                if ($existingEntry) {
                    // Use existing data
                    $this->saveRanking($app->id, $country, $collection, $existingEntry->position, $today);
                    continue;
                }

                // Otherwise, search in top charts (app might have dropped out)
                $position = $this->findPositionInCategory($app, $country, $collection);
                $this->saveRanking($app->id, $country, $collection, $position, $today);

                usleep(50000); // 50ms between API calls
            }
        }
    }

    /**
     * Find app position in category top charts
     */
    private function findPositionInCategory(App $app, string $country, string $collection): ?int
    {
        $limit = 200; // Search deeper than normal top 100

        if ($app->platform === 'ios') {
            $topApps = $this->iTunesService->getTopApps($app->category_id, $country, $collection, min($limit, 100));
        } else {
            $topApps = $this->googlePlayService->getTopApps($app->category_id, $country, $collection, $limit);
        }

        foreach ($topApps as $index => $topApp) {
            $topAppId = $app->platform === 'ios'
                ? ($topApp['apple_id'] ?? null)
                : ($topApp['appId'] ?? $topApp['google_play_id'] ?? null);

            if ($topAppId === $app->store_id) {
                return $index + 1;
            }
        }

        return null; // Not in top charts
    }

    /**
     * Save category ranking
     */
    private function saveRanking(int $appId, string $country, string $collection, ?int $position, $date): void
    {
        AppCategoryRanking::updateOrCreate(
            [
                'app_id' => $appId,
                'country' => $country,
                'collection' => $collection,
                'recorded_at' => $date,
            ],
            [
                'position' => $position,
            ]
        );
    }

    protected function getItemIdentifier(mixed $item): string
    {
        return "{$item->platform}:{$item->store_id}";
    }
}
