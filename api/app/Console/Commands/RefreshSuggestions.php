<?php

namespace App\Console\Commands;

use App\Models\App;
use App\Services\GooglePlayService;
use App\Services\KeywordDiscoveryService;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Cache;

class RefreshSuggestions extends Command
{
    protected $signature = 'aso:refresh-suggestions
        {--platform= : Platform to refresh (ios, android, or both if not specified)}
        {--app= : Specific app ID to refresh}
        {--expired-only : Only refresh expired cache entries}
        {--dry-run : Preview without executing}';

    protected $description = 'Refresh keyword suggestions for user-tracked apps';

    private KeywordDiscoveryService $keywordService;
    private GooglePlayService $googlePlayService;

    public function __construct(KeywordDiscoveryService $keywordService, GooglePlayService $googlePlayService)
    {
        parent::__construct();
        $this->keywordService = $keywordService;
        $this->googlePlayService = $googlePlayService;
    }

    public function handle(): int
    {
        $platform = $this->option('platform');
        $appId = $this->option('app');
        $expiredOnly = $this->option('expired-only');
        $dryRun = $this->option('dry-run');

        if ($dryRun) {
            $this->warn('DRY RUN - No suggestions will be generated');
        }

        // Get apps that have at least one user tracking them
        $query = App::query()
            ->whereHas('users');

        if ($platform) {
            $query->where('platform', $platform);
        }

        if ($appId) {
            $query->where('id', $appId);
        }

        $apps = $query->get();

        if ($apps->isEmpty()) {
            $this->info('No apps to process');
            return Command::SUCCESS;
        }

        // Filter to expired cache only if requested
        if ($expiredOnly) {
            $apps = $apps->filter(function ($app) {
                $cacheKey = $this->getSuggestionsCacheKey($app);
                return !Cache::has($cacheKey);
            });

            if ($apps->isEmpty()) {
                $this->info('No expired suggestions to refresh');
                return Command::SUCCESS;
            }
        }

        $this->info("Processing {$apps->count()} apps...\n");

        // Check Android readiness
        $androidApps = $apps->where('platform', 'android');
        $skipAndroid = false;

        if ($androidApps->isNotEmpty() && !$this->checkAndroidReadiness()) {
            $skipAndroid = true;
            $apps = $apps->where('platform', '!=', 'android');
            if ($apps->isEmpty()) {
                return Command::SUCCESS;
            }
        }

        $bar = $this->output->createProgressBar($apps->count());
        $bar->start();

        $refreshed = 0;
        $skipped = 0;
        $errors = 0;

        foreach ($apps as $app) {
            try {
                if ($dryRun) {
                    $refreshed++;
                    $bar->advance();
                    continue;
                }

                $suggestions = $this->refreshSuggestions($app);

                if ($suggestions === null) {
                    $skipped++;
                } else {
                    $refreshed++;
                }

                // Rate limiting - suggestions are expensive
                $delay = $app->platform === 'android' ? 2_000_000 : 500_000;
                usleep($delay);

            } catch (\Exception $e) {
                $errors++;
                $this->newLine();
                $this->error("Error for {$app->name}: " . $e->getMessage());
            }

            $bar->advance();
        }

        $bar->finish();
        $this->newLine(2);

        $this->info("Summary:");
        $this->line("  - Refreshed: {$refreshed}");
        $this->line("  - Skipped: {$skipped}");
        $this->line("  - Errors: {$errors}");

        if ($skipAndroid) {
            $this->warn("  - Android apps skipped (no proxy)");
        }

        if ($dryRun) {
            $this->warn("DRY RUN - No suggestions were generated");
        }

        return $errors > 0 ? Command::FAILURE : Command::SUCCESS;
    }

    private function checkAndroidReadiness(): bool
    {
        $proxyEnabled = config('services.proxy.enabled', false);

        if (!$proxyEnabled) {
            $this->warn("⚠️  Proxy not configured for Android");

            if (!$this->confirm('Continue without proxy?', false)) {
                $this->info("Skipping Android apps.");
                return false;
            }
        }

        if (!$this->googlePlayService->isHealthy()) {
            $this->error("Google Play scraper not available");
            return false;
        }

        return true;
    }

    private function getSuggestionsCacheKey(App $app): string
    {
        $storefront = strtoupper($app->storefront ?? 'US');

        if ($app->platform === 'ios') {
            return "suggestions_{$app->store_id}_{$storefront}";
        }

        return "gplay_suggestions_{$app->store_id}_{$storefront}";
    }

    private function refreshSuggestions(App $app): ?array
    {
        $storefront = $app->storefront ?? 'us';

        if ($app->platform === 'ios') {
            // For iOS, we need to get app details first to extract seeds
            $details = app(\App\Services\iTunesService::class)->getAppDetails($app->store_id);

            if (!$details) {
                return null;
            }

            // This will cache the results internally
            return $this->keywordService->getSuggestionsForApp(
                $app->store_id,
                strtoupper($storefront)
            );
        }

        // For Android, use the scraper's suggestion endpoint
        return $this->googlePlayService->getSuggestionsForApp(
            $app->store_id,
            $storefront
        );
    }
}
