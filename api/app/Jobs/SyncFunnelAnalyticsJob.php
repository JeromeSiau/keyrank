<?php

namespace App\Jobs;

use App\Models\App;
use App\Models\AppFunnelAnalytics;
use App\Models\StoreConnection;
use App\Services\AppStoreConnectService;
use App\Services\GooglePlayDeveloperService;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Log;

class SyncFunnelAnalyticsJob implements ShouldQueue
{
    use Queueable;

    public int $timeout = 3600; // 1 hour max
    public int $tries = 1;

    public function __construct(
        public ?int $appId = null,
        public int $daysBack = 30,
    ) {}

    public function handle(
        AppStoreConnectService $appStoreService,
        GooglePlayDeveloperService $googlePlayService,
    ): void {
        Log::info('SyncFunnelAnalyticsJob started', [
            'app_id' => $this->appId,
            'days_back' => $this->daysBack,
        ]);

        $startDate = now()->subDays($this->daysBack)->format('Y-m-d');
        $endDate = now()->format('Y-m-d');

        if ($this->appId) {
            $app = App::find($this->appId);
            if ($app) {
                $this->syncApp($app, $startDate, $endDate, $appStoreService, $googlePlayService);
            }
        } else {
            // Sync all apps with active store connections
            $this->syncAllApps($startDate, $endDate, $appStoreService, $googlePlayService);
        }

        Log::info('SyncFunnelAnalyticsJob completed');
    }

    /**
     * Sync funnel data for all apps
     */
    private function syncAllApps(
        string $startDate,
        string $endDate,
        AppStoreConnectService $appStoreService,
        GooglePlayDeveloperService $googlePlayService,
    ): void {
        // Get all active store connections
        $connections = StoreConnection::where('status', 'active')->get();

        foreach ($connections as $connection) {
            // Get all apps for this connection's user
            $apps = App::where('user_id', $connection->user_id)
                ->where('platform', $connection->platform)
                ->get();

            foreach ($apps as $app) {
                try {
                    $this->syncApp($app, $startDate, $endDate, $appStoreService, $googlePlayService, $connection);
                } catch (\Exception $e) {
                    Log::error('Failed to sync funnel for app', [
                        'app_id' => $app->id,
                        'error' => $e->getMessage(),
                    ]);
                }
            }
        }
    }

    /**
     * Sync funnel data for a single app
     */
    private function syncApp(
        App $app,
        string $startDate,
        string $endDate,
        AppStoreConnectService $appStoreService,
        GooglePlayDeveloperService $googlePlayService,
        ?StoreConnection $connection = null,
    ): void {
        Log::info('Syncing funnel for app', ['app_id' => $app->id, 'name' => $app->name]);

        // Get connection if not provided
        if (!$connection) {
            $connection = $app->owner->storeConnections()
                ->where('platform', $app->platform)
                ->where('status', 'active')
                ->first();
        }

        if (!$connection) {
            Log::warning('No active store connection for app', ['app_id' => $app->id]);
            return;
        }

        try {
            if ($app->platform === 'ios') {
                $data = $appStoreService->getConversionFunnelData(
                    $connection,
                    $app->store_id,
                    $startDate,
                    $endDate
                );
            } else {
                $data = $googlePlayService->getConversionFunnelData(
                    $connection,
                    $app->store_id,
                    $startDate,
                    $endDate
                );
            }

            if ($data && !empty($data['totals']) && $data['totals']['impressions'] > 0) {
                $this->storeFunnelData($app, $data);
                Log::info('Funnel data synced', [
                    'app_id' => $app->id,
                    'impressions' => $data['totals']['impressions'],
                    'downloads' => $data['totals']['downloads'],
                ]);
            } else {
                Log::info('No funnel data available', ['app_id' => $app->id]);
            }
        } catch (\Exception $e) {
            Log::error('Failed to fetch funnel data', [
                'app_id' => $app->id,
                'error' => $e->getMessage(),
            ]);
        }
    }

    /**
     * Store funnel data in the database
     */
    private function storeFunnelData(App $app, array $data): void
    {
        // Store daily totals
        foreach ($data['by_date'] as $dateData) {
            AppFunnelAnalytics::updateOrCreate(
                [
                    'app_id' => $app->id,
                    'date' => $dateData['date'],
                    'country_code' => 'WW',
                    'source' => AppFunnelAnalytics::SOURCE_TOTAL,
                ],
                [
                    'impressions' => $dateData['impressions'],
                    'impressions_unique' => $dateData['impressions_unique'] ?? $dateData['impressions'],
                    'page_views' => $dateData['page_views'],
                    'page_views_unique' => $dateData['page_views_unique'] ?? $dateData['page_views'],
                    'downloads' => $dateData['downloads'],
                    'first_time_downloads' => $dateData['first_time_downloads'] ?? $dateData['downloads'],
                    'redownloads' => $dateData['redownloads'] ?? 0,
                    'conversion_rate' => $dateData['impressions'] > 0
                        ? round(($dateData['downloads'] / $dateData['impressions']) * 100, 2)
                        : null,
                ]
            );
        }

        // Store by source breakdown (aggregated for the period)
        foreach ($data['by_source'] as $sourceData) {
            // Use latest date for source breakdown
            $latestDate = array_key_last($data['by_date']) ?: now()->format('Y-m-d');

            AppFunnelAnalytics::updateOrCreate(
                [
                    'app_id' => $app->id,
                    'date' => $latestDate,
                    'country_code' => 'WW',
                    'source' => $sourceData['source'],
                ],
                [
                    'impressions' => $sourceData['impressions'],
                    'impressions_unique' => $sourceData['impressions_unique'] ?? $sourceData['impressions'],
                    'page_views' => $sourceData['page_views'],
                    'page_views_unique' => $sourceData['page_views_unique'] ?? $sourceData['page_views'],
                    'downloads' => $sourceData['downloads'],
                    'first_time_downloads' => $sourceData['first_time_downloads'] ?? $sourceData['downloads'],
                    'redownloads' => $sourceData['redownloads'] ?? 0,
                    'conversion_rate' => $sourceData['impressions'] > 0
                        ? round(($sourceData['downloads'] / $sourceData['impressions']) * 100, 2)
                        : null,
                ]
            );
        }
    }

    public function tags(): array
    {
        return ['aso', 'sync', 'funnel', $this->appId ? "app:{$this->appId}" : 'all'];
    }
}
