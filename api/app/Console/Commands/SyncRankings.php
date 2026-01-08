<?php

namespace App\Console\Commands;

use App\Models\AppRanking;
use App\Models\TrackedKeyword;
use App\Services\GooglePlayService;
use App\Services\iTunesService;
use Illuminate\Console\Command;

class SyncRankings extends Command
{
    protected $signature = 'aso:sync-rankings {--app= : Specific app ID to sync}';
    protected $description = 'Sync App Store and Play Store rankings for all tracked keywords';

    public function __construct(
        private iTunesService $iTunesService,
        private GooglePlayService $googlePlayService
    ) {
        parent::__construct();
    }

    public function handle(): int
    {
        $query = TrackedKeyword::with(['app', 'keyword']);

        if ($appId = $this->option('app')) {
            $query->where('app_id', $appId);
        }

        $tracked = $query->get();

        if ($tracked->isEmpty()) {
            $this->info('No keywords to sync.');
            return 0;
        }

        $this->info("Syncing rankings for {$tracked->count()} tracked keywords...");
        $bar = $this->output->createProgressBar($tracked->count());

        $synced = 0;
        $errors = 0;

        foreach ($tracked as $item) {
            $country = strtolower($item->keyword->storefront);
            $platform = $item->app->platform;

            try {
                // Use the appropriate service based on app's platform
                $position = $platform === 'ios'
                    ? $this->iTunesService->getAppRankForKeyword(
                        $item->app->store_id,
                        $item->keyword->keyword,
                        $country
                    )
                    : $this->googlePlayService->getAppRankForKeyword(
                        $item->app->store_id,
                        $item->keyword->keyword,
                        $country
                    );

                AppRanking::updateOrCreate(
                    [
                        'app_id' => $item->app_id,
                        'keyword_id' => $item->keyword_id,
                        'recorded_at' => today(),
                    ],
                    ['position' => $position]
                );

                $synced++;
            } catch (\Exception $e) {
                $this->error("\nError syncing {$platform} {$item->keyword->keyword}: {$e->getMessage()}");
                $errors++;
            }

            usleep(300000); // Rate limiting

            $bar->advance();
        }

        $bar->finish();
        $this->newLine(2);

        $this->info("Sync complete: {$synced} rankings synced, {$errors} errors.");

        return $errors > 0 ? 1 : 0;
    }
}
