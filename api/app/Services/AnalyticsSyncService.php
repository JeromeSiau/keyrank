<?php

namespace App\Services;

use App\Models\App;
use App\Models\AppAnalytics;
use App\Models\AppAnalyticsSummary;
use App\Models\StoreConnection;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class AnalyticsSyncService
{
    public function __construct(
        private AppStoreConnectService $appStoreService,
        private GooglePlayDeveloperService $googlePlayService,
    ) {}

    /**
     * Sync analytics for all apps with active store connections
     */
    public function syncAll(string $date): array
    {
        $results = [
            'synced' => 0,
            'failed' => 0,
            'errors' => [],
        ];

        $connections = StoreConnection::where('status', 'active')->get();

        foreach ($connections as $connection) {
            try {
                $count = $this->syncConnection($connection, $date);
                $results['synced'] += $count;
            } catch (\Exception $e) {
                $results['failed']++;
                $results['errors'][] = "Connection {$connection->id}: {$e->getMessage()}";
                Log::error('Analytics sync failed', [
                    'connection_id' => $connection->id,
                    'error' => $e->getMessage(),
                ]);
            }
        }

        return $results;
    }

    /**
     * Sync analytics for a specific store connection
     */
    public function syncConnection(StoreConnection $connection, string $date): int
    {
        return match ($connection->store_type) {
            'app_store_connect' => $this->syncAppStoreConnect($connection, $date),
            'google_play' => $this->syncGooglePlay($connection, $date),
            default => 0,
        };
    }

    /**
     * Sync App Store Connect data
     */
    private function syncAppStoreConnect(StoreConnection $connection, string $date): int
    {
        $salesData = $this->appStoreService->getSalesReport($connection, $date);
        $subscriptionData = $this->appStoreService->getSubscriptionReport($connection, $date);

        if ($salesData === null && $subscriptionData === null) {
            throw new \RuntimeException('Failed to fetch App Store Connect reports');
        }

        // Merge sales and subscription data by store_id and country
        $mergedData = $this->mergeAppleData($salesData ?? [], $subscriptionData ?? []);

        if (empty($mergedData)) {
            return 0;
        }

        // Batch lookup: Get all iOS apps by store_id in a single query
        $storeIds = array_unique(array_column($mergedData, 'store_id'));
        $appsLookup = App::whereIn('store_id', $storeIds)
            ->where('platform', 'ios')
            ->pluck('id', 'store_id')
            ->toArray();

        // Build batch upsert data
        $upsertData = [];
        foreach ($mergedData as $data) {
            $appId = $appsLookup[$data['store_id']] ?? null;
            if (!$appId) {
                continue;
            }

            $upsertData[] = [
                'app_id' => $appId,
                'date' => $date,
                'country_code' => $data['country_code'],
                'downloads' => $data['downloads'] ?? 0,
                'updates' => $data['updates'] ?? 0,
                'revenue' => $data['revenue'] ?? 0,
                'proceeds' => $data['proceeds'] ?? 0,
                'refunds' => $data['refunds'] ?? 0,
                'subscribers_new' => $data['subscribers_new'] ?? 0,
                'subscribers_cancelled' => $data['subscribers_cancelled'] ?? 0,
                'subscribers_active' => $data['subscribers_active'] ?? 0,
                'created_at' => now(),
                'updated_at' => now(),
            ];
        }

        if (!empty($upsertData)) {
            AppAnalytics::upsert(
                $upsertData,
                ['app_id', 'date', 'country_code'],
                ['downloads', 'updates', 'revenue', 'proceeds', 'refunds', 'subscribers_new', 'subscribers_cancelled', 'subscribers_active', 'updated_at']
            );
        }

        return count($upsertData);
    }

    /**
     * Sync Google Play data
     */
    private function syncGooglePlay(StoreConnection $connection, string $date): int
    {
        $carbonDate = Carbon::parse($date);
        $year = $carbonDate->year;
        $month = $carbonDate->month;

        $installsData = $this->googlePlayService->getSalesReport($connection, $year, $month);
        $earningsData = $this->googlePlayService->getEarningsReport($connection, $year, $month);
        $subscriptionData = $this->googlePlayService->getSubscriptionReport($connection, $year, $month);

        if ($installsData === null && $earningsData === null) {
            throw new \RuntimeException('Failed to fetch Google Play reports');
        }

        // Merge all data by package_name and country
        $mergedData = $this->mergeGoogleData(
            $installsData ?? [],
            $earningsData ?? [],
            $subscriptionData ?? [],
            $date
        );

        if (empty($mergedData)) {
            return 0;
        }

        // Batch lookup: Get all Android apps by bundle_id in a single query
        $packageNames = array_unique(array_column($mergedData, 'package_name'));
        $appsLookup = App::whereIn('bundle_id', $packageNames)
            ->where('platform', 'android')
            ->pluck('id', 'bundle_id')
            ->toArray();

        // Build batch upsert data
        $upsertData = [];
        foreach ($mergedData as $data) {
            $appId = $appsLookup[$data['package_name']] ?? null;
            if (!$appId) {
                continue;
            }

            $upsertData[] = [
                'app_id' => $appId,
                'date' => $data['date'],
                'country_code' => $data['country_code'],
                'downloads' => $data['downloads'] ?? 0,
                'updates' => $data['updates'] ?? 0,
                'revenue' => $data['revenue'] ?? 0,
                'proceeds' => $data['proceeds'] ?? 0,
                'refunds' => $data['refunds'] ?? 0,
                'subscribers_new' => $data['subscribers_new'] ?? 0,
                'subscribers_cancelled' => $data['subscribers_cancelled'] ?? 0,
                'subscribers_active' => $data['subscribers_active'] ?? 0,
                'created_at' => now(),
                'updated_at' => now(),
            ];
        }

        if (!empty($upsertData)) {
            AppAnalytics::upsert(
                $upsertData,
                ['app_id', 'date', 'country_code'],
                ['downloads', 'updates', 'revenue', 'proceeds', 'refunds', 'subscribers_new', 'subscribers_cancelled', 'subscribers_active', 'updated_at']
            );
        }

        return count($upsertData);
    }

    /**
     * Merge Apple sales and subscription data
     */
    private function mergeAppleData(array $salesData, array $subscriptionData): array
    {
        $merged = [];

        foreach ($salesData as $sale) {
            $key = "{$sale['store_id']}_{$sale['country_code']}";
            $merged[$key] = $sale;
        }

        foreach ($subscriptionData as $sub) {
            $key = "{$sub['store_id']}_{$sub['country_code']}";
            if (isset($merged[$key])) {
                $merged[$key] = array_merge($merged[$key], $sub);
            } else {
                $merged[$key] = $sub;
            }
        }

        return array_values($merged);
    }

    /**
     * Merge Google Play installs, earnings, and subscription data
     */
    private function mergeGoogleData(array $installsData, array $earningsData, array $subscriptionData, string $fallbackDate): array
    {
        $merged = [];

        foreach ($installsData as $install) {
            $date = $install['date'] ?? $fallbackDate;
            $key = "{$install['package_name']}_{$install['country_code']}_{$date}";
            $merged[$key] = array_merge($install, ['date' => $date]);
        }

        foreach ($earningsData as $earning) {
            // Earnings don't have date granularity, distribute to all dates
            $key = "{$earning['package_name']}_{$earning['country_code']}_{$fallbackDate}";
            if (isset($merged[$key])) {
                $merged[$key] = array_merge($merged[$key], $earning);
            } else {
                $merged[$key] = array_merge($earning, ['date' => $fallbackDate]);
            }
        }

        foreach ($subscriptionData as $sub) {
            $key = "{$sub['package_name']}_{$sub['country_code']}_{$fallbackDate}";
            if (isset($merged[$key])) {
                $merged[$key] = array_merge($merged[$key], $sub);
            } else {
                $merged[$key] = array_merge($sub, ['date' => $fallbackDate]);
            }
        }

        return array_values($merged);
    }

    /**
     * Compute summaries for all apps
     */
    public function computeAllSummaries(): int
    {
        $apps = App::whereHas('analytics')->get();
        $count = 0;

        foreach ($apps as $app) {
            $this->computeSummariesForApp($app);
            $count++;
        }

        return $count;
    }

    /**
     * Compute summaries for a specific app
     */
    public function computeSummariesForApp(App $app): void
    {
        $periods = ['7d', '30d', '90d', 'ytd', 'all'];

        foreach ($periods as $period) {
            $this->computeSummary($app, $period);
        }
    }

    /**
     * Compute a single summary
     */
    private function computeSummary(App $app, string $period): void
    {
        $query = AppAnalytics::where('app_id', $app->id);
        $compareQuery = AppAnalytics::where('app_id', $app->id);

        // Define date ranges
        $now = now();
        $periodDays = match ($period) {
            '7d' => 7,
            '30d' => 30,
            '90d' => 90,
            'ytd' => $now->dayOfYear,
            'all' => null,
            default => 30,
        };

        if ($periodDays !== null) {
            $startDate = $now->copy()->subDays($periodDays);
            $compareStartDate = $startDate->copy()->subDays($periodDays);
            $compareEndDate = $startDate->copy()->subDay();

            $query->where('date', '>=', $startDate);
            $compareQuery->whereBetween('date', [$compareStartDate, $compareEndDate]);
        }

        // Calculate current period stats
        $current = $query->selectRaw('
            SUM(downloads) as total_downloads,
            SUM(revenue) as total_revenue,
            SUM(proceeds) as total_proceeds,
            MAX(subscribers_active) as active_subscribers
        ')->first();

        // Calculate previous period stats for comparison
        $previous = $compareQuery->selectRaw('
            SUM(downloads) as total_downloads,
            SUM(revenue) as total_revenue,
            MAX(subscribers_active) as active_subscribers
        ')->first();

        // Calculate percentage changes
        $downloadsChange = $this->calculatePercentChange(
            $previous->total_downloads ?? 0,
            $current->total_downloads ?? 0
        );

        $revenueChange = $this->calculatePercentChange(
            $previous->total_revenue ?? 0,
            $current->total_revenue ?? 0
        );

        $subscribersChange = $this->calculatePercentChange(
            $previous->active_subscribers ?? 0,
            $current->active_subscribers ?? 0
        );

        AppAnalyticsSummary::updateOrCreate(
            [
                'app_id' => $app->id,
                'period' => $period,
            ],
            [
                'total_downloads' => $current->total_downloads ?? 0,
                'total_revenue' => $current->total_revenue ?? 0,
                'total_proceeds' => $current->total_proceeds ?? 0,
                'active_subscribers' => $current->active_subscribers ?? 0,
                'downloads_change_pct' => $downloadsChange,
                'revenue_change_pct' => $revenueChange,
                'subscribers_change_pct' => $subscribersChange,
                'computed_at' => now(),
            ]
        );
    }

    /**
     * Calculate percentage change between two values
     */
    private function calculatePercentChange(float $previous, float $current): ?float
    {
        if ($previous == 0) {
            return $current > 0 ? 100.0 : null;
        }

        return round((($current - $previous) / $previous) * 100, 2);
    }
}
