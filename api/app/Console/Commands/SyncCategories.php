<?php

namespace App\Console\Commands;

use App\Models\Category;
use App\Services\GooglePlayService;
use App\Services\iTunesService;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Http;

class SyncCategories extends Command
{
    protected $signature = 'categories:sync
                            {--platform= : Only sync categories for a specific platform (ios or android)}
                            {--dry-run : Show what would be synced without making changes}';

    protected $description = 'Sync app store categories from external sources';

    public function handle(): int
    {
        $dryRun = $this->option('dry-run');
        $platform = $this->option('platform');

        $this->info($dryRun ? 'Dry run - no changes will be made' : 'Syncing categories...');

        $synced = 0;
        $created = 0;

        if (!$platform || $platform === 'ios') {
            [$s, $c] = $this->syncIosCategories($dryRun);
            $synced += $s;
            $created += $c;
        }

        if (!$platform || $platform === 'android') {
            [$s, $c] = $this->syncAndroidCategories($dryRun);
            $synced += $s;
            $created += $c;
        }

        $this->newLine();
        $this->info("Done! Synced: {$synced}, Created: {$created}");

        return self::SUCCESS;
    }

    private function syncIosCategories(bool $dryRun): array
    {
        $this->info('Syncing iOS categories...');

        // iOS categories from Apple - these rarely change
        // We use the static list as Apple doesn't provide a public API
        $categories = iTunesService::getCategories();

        $synced = 0;
        $created = 0;

        foreach ($categories as $storeId => $name) {
            $existing = Category::where('platform', 'ios')
                ->where('store_id', (string) $storeId)
                ->first();

            if ($existing) {
                if ($existing->name !== $name) {
                    if (!$dryRun) {
                        $existing->update(['name' => $name]);
                    }
                    $this->line("  Updated: {$storeId} -> {$name}");
                }
                $synced++;
            } else {
                if (!$dryRun) {
                    Category::create([
                        'platform' => 'ios',
                        'store_id' => (string) $storeId,
                        'name' => $name,
                    ]);
                }
                $this->line("  Created: {$storeId} -> {$name}");
                $created++;
            }
        }

        $this->info("  iOS: {$synced} synced, {$created} created");

        return [$synced, $created];
    }

    private function syncAndroidCategories(bool $dryRun): array
    {
        $this->info('Syncing Android categories...');

        // Try to fetch from scraper first (dynamic)
        $categories = $this->fetchAndroidCategoriesFromScraper();

        // Fallback to static list
        if (empty($categories)) {
            $this->warn('  Could not fetch from scraper, using static list');
            $categories = [];
            foreach (GooglePlayService::getCategories() as $id => $name) {
                $categories[] = ['id' => $id, 'name' => $name];
            }
        }

        $synced = 0;
        $created = 0;

        foreach ($categories as $category) {
            $storeId = $category['id'];
            $name = $category['name'];

            $existing = Category::where('platform', 'android')
                ->where('store_id', $storeId)
                ->first();

            if ($existing) {
                if ($existing->name !== $name) {
                    if (!$dryRun) {
                        $existing->update(['name' => $name]);
                    }
                    $this->line("  Updated: {$storeId} -> {$name}");
                }
                $synced++;
            } else {
                if (!$dryRun) {
                    Category::create([
                        'platform' => 'android',
                        'store_id' => $storeId,
                        'name' => $name,
                    ]);
                }
                $this->line("  Created: {$storeId} -> {$name}");
                $created++;
            }
        }

        $this->info("  Android: {$synced} synced, {$created} created");

        return [$synced, $created];
    }

    private function fetchAndroidCategoriesFromScraper(): array
    {
        try {
            $scraperUrl = config('services.gplay_scraper.url', 'http://localhost:3001');
            $response = Http::timeout(30)->get("{$scraperUrl}/categories");

            if ($response->successful()) {
                return $response->json('categories', []);
            }
        } catch (\Exception $e) {
            $this->error("  Scraper error: {$e->getMessage()}");
        }

        return [];
    }
}
