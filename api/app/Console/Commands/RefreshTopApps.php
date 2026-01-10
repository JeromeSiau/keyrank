<?php

namespace App\Console\Commands;

use App\Models\App;
use App\Models\TopAppEntry;
use App\Services\GooglePlayService;
use App\Services\iTunesService;
use Illuminate\Console\Command;

class RefreshTopApps extends Command
{
    protected $signature = 'aso:refresh-top-apps
        {--platform= : Platform to refresh (ios, android, or both if not specified)}
        {--category= : Specific category ID to refresh}
        {--country= : Specific country code (overrides config)}
        {--collection= : Specific collection type (overrides config)}
        {--limit= : Number of apps per category (default from config)}
        {--dry-run : Preview without saving}';

    protected $description = 'Refresh top apps for all categories across configured countries and collections';

    private iTunesService $itunesService;
    private GooglePlayService $googlePlayService;

    public function __construct(iTunesService $itunesService, GooglePlayService $googlePlayService)
    {
        parent::__construct();
        $this->itunesService = $itunesService;
        $this->googlePlayService = $googlePlayService;
    }

    public function handle(): int
    {
        $platform = $this->option('platform');
        $category = $this->option('category');
        $dryRun = $this->option('dry-run');

        // Get config values with CLI overrides
        $countries = $this->option('country')
            ? [$this->option('country')]
            : config('aso.top_apps.countries', ['us']);

        $collections = $this->option('collection')
            ? [$this->option('collection')]
            : config('aso.top_apps.collections', ['top_free']);

        $limit = (int) ($this->option('limit') ?? config('aso.top_apps.limit', 100));

        $platforms = $platform ? [$platform] : ['ios', 'android'];

        if ($dryRun) {
            $this->warn('DRY RUN - No data will be saved');
        }

        $this->info('Configuration:');
        $this->line('  Countries: ' . implode(', ', $countries));
        $this->line('  Collections: ' . implode(', ', $collections));
        $this->line('  Limit: ' . $limit);
        $this->newLine();

        $today = today();
        $totalSaved = 0;
        $totalErrors = 0;

        foreach ($platforms as $plt) {
            $this->info("\n" . strtoupper($plt) . " Platform");
            $this->line(str_repeat('-', 40));

            if ($plt === 'android' && !$this->checkAndroidReadiness()) {
                continue;
            }

            $categories = $this->getCategoriesForPlatform($plt, $category);

            if (empty($categories)) {
                $this->warn("No categories found for {$plt}");
                continue;
            }

            // Calculate total iterations
            $totalIterations = count($categories) * count($countries) * count($collections);
            $this->info("Refreshing {$totalIterations} combinations (categories x countries x collections)...\n");
            $bar = $this->output->createProgressBar($totalIterations);
            $bar->start();

            foreach ($countries as $country) {
                foreach ($collections as $collection) {
                    foreach ($categories as $categoryId => $categoryName) {
                        try {
                            $apps = $this->fetchTopApps($plt, $categoryId, $country, $collection, $limit);

                            if (empty($apps)) {
                                $bar->advance();
                                continue;
                            }

                            if (!$dryRun) {
                                $saved = $this->saveTopApps($plt, $categoryId, $country, $collection, $apps, $today);
                                $totalSaved += $saved;
                            } else {
                                $totalSaved += count($apps);
                            }

                            // Rate limiting
                            $delay = config("aso.rate_limits.{$plt}", 100);
                            usleep($delay * 1000);

                        } catch (\Exception $e) {
                            $totalErrors++;
                            $this->newLine();
                            $this->error("Error [{$country}/{$collection}] {$categoryName}: " . $e->getMessage());
                        }

                        $bar->advance();
                    }
                }
            }

            $bar->finish();
            $this->newLine();
        }

        $this->newLine();
        $this->info("Summary:");
        $this->line("  - Entries saved: {$totalSaved}");
        $this->line("  - Errors: {$totalErrors}");

        if ($dryRun) {
            $this->warn("DRY RUN - No data was actually saved");
        }

        // Only fail if > 10% errors
        $totalCombinations = count($platforms) * count($countries) * count($collections) * 25;
        $errorThreshold = max(3, $totalCombinations * 0.1);

        return $totalErrors > $errorThreshold ? Command::FAILURE : Command::SUCCESS;
    }

    private function checkAndroidReadiness(): bool
    {
        $proxyEnabled = config('services.proxy.enabled', false);

        if (!$proxyEnabled) {
            $this->warn("Proxy not configured for Android scraping");
            $this->line("   Android requests will use your IP directly.");
            $this->line("   This may result in rate limiting or blocks.");
            $this->newLine();

            if (!$this->confirm('Continue without proxy?', false)) {
                $this->info("Skipping Android. Configure PROXY_ENABLED=true in .env for production.");
                return false;
            }
        }

        // Check if scraper is available
        if (!$this->googlePlayService->isHealthy()) {
            $this->error("Google Play scraper is not available at " . config('services.gplay_scraper.url'));
            $this->line("Make sure the scraper is running: cd scraper && npm start");
            return false;
        }

        return true;
    }

    private function getCategoriesForPlatform(string $platform, ?string $specificCategory): array
    {
        $allCategories = $platform === 'ios'
            ? iTunesService::getCategories()
            : GooglePlayService::getCategories();

        if ($specificCategory) {
            if (isset($allCategories[$specificCategory])) {
                return [$specificCategory => $allCategories[$specificCategory]];
            }
            $this->warn("Category {$specificCategory} not found for {$platform}");
            return [];
        }

        return $allCategories;
    }

    private function fetchTopApps(string $platform, string $categoryId, string $country, string $collection, int $limit): array
    {
        if ($platform === 'ios') {
            return $this->itunesService->getTopApps($categoryId, $country, $collection, $limit);
        }

        return $this->googlePlayService->getTopApps($categoryId, $country, $collection, $limit);
    }

    private function saveTopApps(string $platform, string $categoryId, string $country, string $collection, array $apps, $date): int
    {
        $saved = 0;

        foreach ($apps as $index => $appData) {
            $storeId = $platform === 'ios'
                ? ($appData['apple_id'] ?? null)
                : ($appData['google_play_id'] ?? $appData['appId'] ?? null);

            if (!$storeId) {
                continue;
            }

            $name = $appData['name'] ?? $appData['title'] ?? 'Unknown';
            $developer = $appData['developer'] ?? $appData['developerName'] ?? null;
            $iconUrl = $appData['icon_url'] ?? $appData['icon'] ?? null;
            $rating = $appData['rating'] ?? $appData['score'] ?? null;
            $ratingCount = $appData['rating_count'] ?? $appData['ratings'] ?? null;
            $position = $appData['position'] ?? ($index + 1);

            // 1. Create/update in apps table (source of truth for app metadata)
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

            // 2. Save to top_app_entries (ranking history, references app_id)
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

            $saved++;
        }

        return $saved;
    }
}
