<?php

namespace App\Services;

use App\Models\RevenueApp;
use App\Models\RevenueScrapeLog;
use App\Models\RevenueSkippedUrl;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class RevenueScraperService
{
    private string $scraperUrl;

    public function __construct()
    {
        $this->scraperUrl = config('services.revenue_scraper.url', 'http://localhost:8001');
    }

    /**
     * Sync revenue data from whatsthe.app
     *
     * @return array{synced: int, created: int, updated: int, errors: array}
     */
    public function syncWhatsTheApp(?int $limit = null): array
    {
        return $this->syncFromEndpoint('whatstheapp', '/revenue/whatstheapp', $limit);
    }

    /**
     * Sync revenue data from AppBusinessBrokers
     *
     * @return array{synced: int, created: int, updated: int, errors: array}
     */
    public function syncAppBusinessBrokers(?int $limit = null): array
    {
        return $this->syncFromEndpoint('appbusinessbrokers', '/revenue/appbusinessbrokers', $limit);
    }

    /**
     * Sync revenue data from Flippa
     *
     * @return array{synced: int, created: int, updated: int, errors: array}
     */
    public function syncFlippa(?int $limit = null): array
    {
        return $this->syncFromEndpoint('flippa', '/revenue/flippa', $limit);
    }

    /**
     * Sync revenue data from Microns
     *
     * @return array{synced: int, created: int, updated: int, errors: array}
     */
    public function syncMicrons(?int $limit = null): array
    {
        return $this->syncFromEndpoint('microns', '/revenue/microns', $limit);
    }

    /**
     * Get all existing URLs for a source (from both apps and skipped)
     */
    private function getExistingUrls(string $source): array
    {
        $appUrls = RevenueApp::where('source', $source)
            ->whereNotNull('source_url')
            ->pluck('source_url')
            ->toArray();

        $skippedUrls = RevenueSkippedUrl::where('source', $source)
            ->pluck('url')
            ->toArray();

        return array_unique(array_merge($appUrls, $skippedUrls));
    }

    /**
     * Generic sync from a scraper endpoint
     */
    private function syncFromEndpoint(string $source, string $endpoint, ?int $limit = null): array
    {
        $result = [
            'synced' => 0,
            'created' => 0,
            'updated' => 0,
            'skipped' => 0,
            'errors' => [],
        ];

        // Start logging
        $scrapeLog = RevenueScrapeLog::start($source);

        try {
            // Get existing URLs to skip
            $skipUrls = $this->getExistingUrls($source);

            // Build request body
            $body = ['skip_urls' => $skipUrls];
            if ($limit !== null) {
                $body['limit'] = $limit;
            }

            // POST with skip_urls and optional limit in body
            $response = Http::timeout(600)->post("{$this->scraperUrl}{$endpoint}", $body);

            if (!$response->successful()) {
                $result['errors'][] = "HTTP error: {$response->status()}";
                $scrapeLog->markFailed("HTTP error: {$response->status()}");
                return $result;
            }

            $data = $response->json();

            if (!($data['success'] ?? false)) {
                $result['errors'][] = 'Scraper returned unsuccessful response';
                $scrapeLog->markFailed('Scraper returned unsuccessful response');
                return $result;
            }

            // Process apps
            $apps = $data['apps'] ?? [];
            foreach ($apps as $appData) {
                try {
                    $wasRecentlyCreated = $this->upsertApp($source, $appData);

                    $result['synced']++;
                    if ($wasRecentlyCreated) {
                        $result['created']++;
                    } else {
                        $result['updated']++;
                    }
                } catch (\Exception $e) {
                    $result['errors'][] = "Failed to sync {$appData['name']}: {$e->getMessage()}";
                }
            }

            // Store skipped URLs (non-mobile apps)
            $skippedUrls = $data['skipped_urls'] ?? [];
            foreach ($skippedUrls as $skippedUrl) {
                RevenueSkippedUrl::updateOrCreate(
                    ['source' => $source, 'url' => $skippedUrl],
                    ['reason' => 'not_mobile_app', 'checked_at' => now()]
                );
                $result['skipped']++;
            }

            // Mark success
            $scrapeLog->markSuccess(
                found: $result['synced'] + $result['skipped'],
                new: $result['created'],
                updated: $result['updated'],
                skipped: $result['skipped']
            );
        } catch (\Exception $e) {
            $result['errors'][] = "Scraper connection failed: {$e->getMessage()}";
            Log::error("Revenue scraper sync failed for {$source}", ['error' => $e->getMessage()]);
            $scrapeLog->markFailed($e->getMessage());
        }

        return $result;
    }

    /**
     * Upsert a revenue app record
     *
     * @return bool True if created, false if updated
     */
    private function upsertApp(string $source, array $data): bool
    {
        $revenueApp = RevenueApp::updateOrCreate(
            [
                'source' => $source,
                'source_id' => $data['source_id'],
            ],
            [
                'source_url' => $data['source_url'] ?? null,
                'app_name' => $data['name'],
                'mrr_cents' => isset($data['mrr']) ? (int) ($data['mrr'] * 100) : null,
                'monthly_revenue_cents' => isset($data['monthly_revenue']) ? (int) ($data['monthly_revenue'] * 100) : null,
                'arr_cents' => isset($data['arr']) ? (int) ($data['arr'] * 100) : null,
                'annual_revenue_cents' => isset($data['annual_revenue']) ? (int) ($data['annual_revenue'] * 100) : null,
                'monthly_profit_cents' => isset($data['monthly_profit']) ? (int) ($data['monthly_profit'] * 100) : null,
                'asking_price_cents' => isset($data['asking_price']) ? (int) ($data['asking_price'] * 100) : null,
                'active_subscribers' => $data['active_subscribers'] ?? null,
                'active_trials' => $data['active_trials'] ?? null,
                'active_users' => $data['active_users'] ?? null,
                'monthly_downloads' => $data['monthly_downloads'] ?? null,
                'total_downloads' => $data['total_downloads'] ?? null,
                'new_customers' => $data['new_customers'] ?? null,
                'ltv_cents' => isset($data['ltv']) ? (int) ($data['ltv'] * 100) : null,
                'arpu_cents' => isset($data['arpu']) ? (int) ($data['arpu'] * 100) : null,
                'churn_rate' => $data['churn_rate'] ?? null,
                'growth_rate_mom' => $data['growth_rate_mom'] ?? null,
                'apple_id' => $data['apple_id'] ?? null,
                'bundle_id' => $data['bundle_id'] ?? null,
                'app_store_url' => $data['app_store_url'] ?? null,
                'play_store_url' => $data['play_store_url'] ?? null,
                'platform' => $data['platform'] ?? 'ios',
                'credential_type' => $data['credential_type'] ?? 'unknown',
                'business_model' => $data['business_model'] ?? 'unknown',
                'category' => $data['category'] ?? null,
                'is_for_sale' => $data['is_for_sale'] ?? false,
                'revenue_verified' => $data['revenue_verified'] ?? false,
                'ios_rating' => $data['ios_rating'] ?? null,
                'android_rating' => $data['android_rating'] ?? null,
                'description' => $data['description'] ?? null,
                'scraped_at' => now(),
            ]
        );

        return $revenueApp->wasRecentlyCreated;
    }

    /**
     * Check if scraper is healthy
     */
    public function isHealthy(): bool
    {
        try {
            $response = Http::timeout(5)->get("{$this->scraperUrl}/health");
            return $response->successful() && $response->json('status') === 'ok';
        } catch (\Exception $e) {
            return false;
        }
    }

    /**
     * Get all revenue apps from database
     */
    public function getApps(string $source = null, int $limit = 100): \Illuminate\Database\Eloquent\Collection
    {
        $query = RevenueApp::query()->orderByDesc('mrr_cents');

        if ($source) {
            $query->where('source', $source);
        }

        return $query->limit($limit)->get();
    }

    /**
     * Get scrape logs for monitoring
     */
    public function getScrapeLogs(string $source = null, int $limit = 50): \Illuminate\Database\Eloquent\Collection
    {
        $query = RevenueScrapeLog::query()->orderByDesc('started_at');

        if ($source) {
            $query->where('source', $source);
        }

        return $query->limit($limit)->get();
    }

    /**
     * Get last successful scrape for a source
     */
    public function getLastSuccessfulScrape(string $source): ?RevenueScrapeLog
    {
        return RevenueScrapeLog::where('source', $source)
            ->where('status', 'success')
            ->orderByDesc('completed_at')
            ->first();
    }

    /**
     * Find apps that match tracked apps by Apple ID or Bundle ID
     */
    public function findMatchingTrackedApps(): array
    {
        $matches = [];

        $revenueApps = RevenueApp::whereNotNull('apple_id')
            ->orWhereNotNull('bundle_id')
            ->get();

        foreach ($revenueApps as $revenueApp) {
            $trackedApp = null;

            if ($revenueApp->apple_id) {
                $trackedApp = \App\Models\App::where('store_id', $revenueApp->apple_id)
                    ->where('platform', 'ios')
                    ->first();
            }

            if (!$trackedApp && $revenueApp->bundle_id) {
                $trackedApp = \App\Models\App::where('bundle_id', $revenueApp->bundle_id)
                    ->where('platform', 'android')
                    ->first();
            }

            if ($trackedApp) {
                $matches[] = [
                    'revenue_app' => $revenueApp,
                    'tracked_app' => $trackedApp,
                ];
            }
        }

        return $matches;
    }
}
