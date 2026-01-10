<?php

namespace App\Console\Commands;

use App\Models\App;
use App\Services\GooglePlayService;
use App\Services\iTunesService;
use Illuminate\Console\Command;

class RefreshAllApps extends Command
{
    protected $signature = 'apps:refresh-all {--force : Refresh all apps, not just those missing details}';

    protected $description = 'Refresh all apps to populate description, screenshots, and other details';

    public function handle(iTunesService $iTunesService, GooglePlayService $googlePlayService): int
    {
        $query = App::query();

        if (!$this->option('force')) {
            // Only refresh apps missing description or screenshots
            $query->where(function ($q) {
                $q->whereNull('description')
                    ->orWhereNull('screenshots');
            });
        }

        $apps = $query->get();

        if ($apps->isEmpty()) {
            $this->info('No apps need refreshing.');
            return Command::SUCCESS;
        }

        $this->info("Refreshing {$apps->count()} apps...");
        $bar = $this->output->createProgressBar($apps->count());

        $refreshed = 0;
        $failed = 0;

        foreach ($apps as $app) {
            try {
                if ($app->platform === 'ios') {
                    $details = $iTunesService->getAppDetails($app->store_id, strtolower($app->storefront ?? 'us'));
                } else {
                    $details = $googlePlayService->getAppDetails($app->store_id, strtolower($app->storefront ?? 'us'));
                }

                if ($details) {
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

                    $refreshed++;
                } else {
                    $failed++;
                    $this->newLine();
                    $this->warn("Failed to fetch details for {$app->name} ({$app->store_id})");
                }
            } catch (\Exception $e) {
                $failed++;
                $this->newLine();
                $this->error("Error refreshing {$app->name}: {$e->getMessage()}");
            }

            $bar->advance();

            // Small delay to avoid rate limiting
            usleep(300000); // 0.3 seconds
        }

        $bar->finish();
        $this->newLine(2);

        $this->info("Refreshed: {$refreshed} apps");
        if ($failed > 0) {
            $this->warn("Failed: {$failed} apps");
        }

        return Command::SUCCESS;
    }
}
