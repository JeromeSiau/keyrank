<?php

namespace App\Console\Commands;

use App\Models\App;
use App\Services\GooglePlayService;
use App\Services\iTunesService;
use Illuminate\Console\Command;

class RefreshUserApps extends Command
{
    protected $signature = 'aso:refresh-user-apps
        {--platform= : Platform to refresh (ios, android, or both if not specified)}
        {--app= : Specific app ID to refresh}
        {--force : Refresh even if recently updated}
        {--dry-run : Preview without saving}';

    protected $description = 'Refresh app details for all user-tracked apps';

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
        $appId = $this->option('app');
        $force = $this->option('force');
        $dryRun = $this->option('dry-run');

        if ($dryRun) {
            $this->warn('DRY RUN - No data will be saved');
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

        // Skip recently updated apps unless forced
        if (!$force) {
            $query->where(function ($q) {
                $q->whereNull('updated_at')
                    ->orWhere('updated_at', '<', now()->subHours(12));
            });
        }

        $apps = $query->get();

        if ($apps->isEmpty()) {
            $this->info('No apps to refresh');
            return Command::SUCCESS;
        }

        $this->info("Refreshing {$apps->count()} apps...\n");

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

        $updated = 0;
        $skipped = 0;
        $errors = 0;

        foreach ($apps as $app) {
            try {
                $details = $this->fetchAppDetails($app);

                if (!$details) {
                    $skipped++;
                    $bar->advance();
                    continue;
                }

                if (!$dryRun) {
                    $this->updateApp($app, $details);
                }

                $updated++;

                // Rate limiting
                $delay = $app->platform === 'android' ? 300_000 : 100_000;
                usleep($delay);

            } catch (\Exception $e) {
                $errors++;
                $this->newLine();
                $this->error("Error refreshing {$app->name}: " . $e->getMessage());
            }

            $bar->advance();
        }

        $bar->finish();
        $this->newLine(2);

        $this->info("Summary:");
        $this->line("  - Updated: {$updated}");
        $this->line("  - Skipped: {$skipped}");
        $this->line("  - Errors: {$errors}");

        if ($skipAndroid) {
            $this->warn("  - Android apps skipped (no proxy)");
        }

        if ($dryRun) {
            $this->warn("DRY RUN - No data was actually saved");
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

    private function fetchAppDetails(App $app): ?array
    {
        if ($app->platform === 'ios') {
            return $this->itunesService->getAppDetails($app->store_id);
        }

        return $this->googlePlayService->getAppDetails($app->store_id, $app->storefront ?? 'us');
    }

    private function updateApp(App $app, array $details): void
    {
        $updateData = [];

        if ($app->platform === 'ios') {
            $updateData = [
                'name' => $details['name'] ?? $app->name,
                'icon_url' => $details['icon_url'] ?? $app->icon_url,
                'developer' => $details['developer'] ?? $app->developer,
                'rating' => $details['rating'] ?? $app->rating,
                'rating_count' => $details['rating_count'] ?? $app->rating_count,
                'category_id' => $details['category_id'] ?? $app->category_id,
                'secondary_category_id' => $details['secondary_category_id'] ?? $app->secondary_category_id,
            ];
        } else {
            $updateData = [
                'name' => $details['title'] ?? $details['name'] ?? $app->name,
                'icon_url' => $details['icon'] ?? $details['icon_url'] ?? $app->icon_url,
                'developer' => $details['developer'] ?? $details['developerName'] ?? $app->developer,
                'rating' => $details['score'] ?? $details['rating'] ?? $app->rating,
                'rating_count' => $details['ratings'] ?? $details['rating_count'] ?? $app->rating_count,
                'category_id' => $details['genreId'] ?? $details['genre_id'] ?? $app->category_id,
            ];
        }

        $app->update(array_filter($updateData, fn($v) => $v !== null));
    }
}
