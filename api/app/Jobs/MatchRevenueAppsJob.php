<?php

namespace App\Jobs;

use App\Models\App;
use App\Models\RevenueApp;
use App\Services\iTunesService;
use App\Services\GooglePlayService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class MatchRevenueAppsJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public function __construct(
        private int $limit = 50
    ) {}

    public function handle(iTunesService $itunes, GooglePlayService $gplay): void
    {
        $revenueApps = RevenueApp::whereNull('matched_app_id')
            ->where(function ($q) {
                $q->whereNotNull('apple_id')
                  ->orWhereNotNull('bundle_id');
            })
            ->limit($this->limit)
            ->get();

        Log::info("MatchRevenueAppsJob: Processing {$revenueApps->count()} revenue apps");

        $matched = 0;
        $created = 0;
        $failed = 0;

        foreach ($revenueApps as $revenueApp) {
            try {
                $app = $this->findOrCreateApp($revenueApp, $itunes, $gplay);

                if ($app) {
                    $revenueApp->update(['matched_app_id' => $app->id]);
                    $matched++;

                    if ($app->wasRecentlyCreated) {
                        $created++;
                    }
                }
            } catch (\Exception $e) {
                $failed++;
                Log::warning("MatchRevenueAppsJob: Failed to match {$revenueApp->app_name}", [
                    'error' => $e->getMessage(),
                ]);
            }

            // Rate limiting
            usleep(200000); // 0.2 sec
        }

        Log::info("MatchRevenueAppsJob: Matched {$matched} apps ({$created} created, {$failed} failed)");
    }

    private function findOrCreateApp(RevenueApp $revenueApp, iTunesService $itunes, GooglePlayService $gplay): ?App
    {
        // Try iOS first
        if ($revenueApp->apple_id) {
            $app = App::where('store_id', $revenueApp->apple_id)
                ->where('platform', 'ios')
                ->first();

            if ($app) {
                return $app;
            }

            // Fetch from iTunes and create
            $data = $itunes->getAppDetails($revenueApp->apple_id);

            if ($data) {
                return App::create([
                    'platform' => 'ios',
                    'store_id' => $data['apple_id'],
                    'bundle_id' => $data['bundle_id'],
                    'name' => $data['name'],
                    'icon_url' => $data['icon_url'],
                    'developer' => $data['developer'],
                    'description' => $data['description'],
                    'screenshots' => $data['screenshots'] ?? [],
                    'version' => $data['version'],
                    'release_date' => $data['release_date'] ? date('Y-m-d', strtotime($data['release_date'])) : null,
                    'updated_date' => $data['updated_date'] ? date('Y-m-d H:i:s', strtotime($data['updated_date'])) : null,
                    'size_bytes' => $data['size_bytes'],
                    'minimum_os' => $data['minimum_os'],
                    'store_url' => $data['store_url'],
                    'price' => $data['price'] ?? 0,
                    'currency' => $data['currency'] ?? 'USD',
                    'rating' => $data['rating'],
                    'rating_count' => $data['rating_count'] ?? 0,
                    'storefront' => 'us',
                    'category_id' => $data['category_id'],
                    'secondary_category_id' => $data['secondary_category_id'],
                    'discovery_source' => 'revenue_scraper',
                ]);
            }
        }

        // Try Android
        if ($revenueApp->bundle_id) {
            $app = App::where('bundle_id', $revenueApp->bundle_id)
                ->where('platform', 'android')
                ->first();

            if ($app) {
                return $app;
            }

            // Fetch from Play Store and create
            $data = $gplay->getAppDetails($revenueApp->bundle_id);

            if ($data) {
                return App::create([
                    'platform' => 'android',
                    'store_id' => $data['google_play_id'] ?? $revenueApp->bundle_id,
                    'bundle_id' => $revenueApp->bundle_id,
                    'name' => $data['name'] ?? $data['title'] ?? $revenueApp->app_name,
                    'icon_url' => $data['icon'] ?? $data['icon_url'] ?? null,
                    'developer' => $data['developer'] ?? null,
                    'description' => $data['description'] ?? null,
                    'screenshots' => $data['screenshots'] ?? [],
                    'version' => $data['version'] ?? null,
                    'store_url' => $revenueApp->play_store_url,
                    'price' => $data['price'] ?? 0,
                    'rating' => $data['score'] ?? $data['rating'] ?? null,
                    'rating_count' => $data['ratings'] ?? $data['rating_count'] ?? 0,
                    'storefront' => 'us',
                    'discovery_source' => 'revenue_scraper',
                ]);
            }
        }

        return null;
    }
}
