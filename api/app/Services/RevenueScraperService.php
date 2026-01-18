<?php

namespace App\Services;

use App\Models\RevenueApp;
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
    public function syncWhatsTheApp(): array
    {
        $result = [
            'synced' => 0,
            'created' => 0,
            'updated' => 0,
            'errors' => [],
        ];

        try {
            $response = Http::timeout(120)->get("{$this->scraperUrl}/revenue/whatstheapp");

            if (!$response->successful()) {
                $result['errors'][] = "HTTP error: {$response->status()}";
                return $result;
            }

            $data = $response->json();

            if (!($data['success'] ?? false)) {
                $result['errors'][] = 'Scraper returned unsuccessful response';
                return $result;
            }

            $apps = $data['apps'] ?? [];

            foreach ($apps as $appData) {
                try {
                    $wasRecentlyCreated = $this->upsertApp('whatstheapp', $appData);

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
        } catch (\Exception $e) {
            $result['errors'][] = "Scraper connection failed: {$e->getMessage()}";
            Log::error('Revenue scraper sync failed', ['error' => $e->getMessage()]);
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
                'app_name' => $data['name'],
                'mrr_cents' => isset($data['mrr']) ? (int) ($data['mrr'] * 100) : null,
                'monthly_revenue_cents' => isset($data['monthly_revenue']) ? (int) ($data['monthly_revenue'] * 100) : null,
                'active_subscribers' => $data['active_subscribers'] ?? null,
                'monthly_downloads' => $data['monthly_downloads'] ?? null,
                'apple_id' => $data['apple_id'] ?? null,
                'bundle_id' => $data['bundle_id'] ?? null,
                'app_store_url' => $data['app_store_url'] ?? null,
                'play_store_url' => $data['play_store_url'] ?? null,
                'platform' => $data['platform'] ?? 'ios',
                'credential_type' => $data['credential_type'] ?? 'unknown',
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
