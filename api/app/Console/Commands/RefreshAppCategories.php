<?php

namespace App\Console\Commands;

use App\Models\App;
use App\Services\GooglePlayService;
use App\Services\iTunesService;
use Illuminate\Console\Command;

class RefreshAppCategories extends Command
{
    protected $signature = 'apps:refresh-categories
                            {--dry-run : Show what would be updated without making changes}
                            {--platform= : Only refresh apps for a specific platform (ios or android)}';

    protected $description = 'Refresh category information for all tracked apps';

    public function handle(): int
    {
        $dryRun = $this->option('dry-run');
        $platform = $this->option('platform');

        $query = App::query();

        if ($platform) {
            $query->where('platform', $platform);
        }

        $apps = $query->get();

        if ($apps->isEmpty()) {
            $this->info('No apps found to refresh.');
            return self::SUCCESS;
        }

        $this->info(sprintf(
            'Refreshing categories for %d %s app(s)%s...',
            $apps->count(),
            $platform ?: 'all',
            $dryRun ? ' (dry run)' : ''
        ));

        $itunesService = new iTunesService();
        $googlePlayService = new GooglePlayService();

        $updated = 0;
        $skipped = 0;
        $errors = 0;

        $bar = $this->output->createProgressBar($apps->count());
        $bar->start();

        foreach ($apps as $app) {
            try {
                $categoryId = null;
                $secondaryCategoryId = null;

                if ($app->platform === 'ios') {
                    $details = $itunesService->getAppDetails($app->store_id, $app->storefront ?? 'us');

                    if ($details) {
                        $categoryId = $details['category_id'] ?? null;
                        $secondaryCategoryId = $details['secondary_category_id'] ?? null;
                    }
                } else {
                    $details = $googlePlayService->getAppDetails($app->store_id, $app->storefront ?? 'us');

                    if ($details) {
                        $categoryId = $details['genre_id'] ?? null;
                    }
                }

                if ($categoryId) {
                    if (!$dryRun) {
                        $app->update([
                            'category_id' => $categoryId,
                            'secondary_category_id' => $secondaryCategoryId,
                        ]);
                    }

                    $this->line(sprintf(
                        "\n  %s: %s -> %s%s",
                        $app->name,
                        $app->category_id ?: '(none)',
                        $categoryId,
                        $secondaryCategoryId ? " + {$secondaryCategoryId}" : ''
                    ));

                    $updated++;
                } else {
                    $skipped++;
                }

                // Rate limiting
                usleep(200000); // 0.2 seconds

            } catch (\Exception $e) {
                $this->error("\n  Error refreshing {$app->name}: {$e->getMessage()}");
                $errors++;
            }

            $bar->advance();
        }

        $bar->finish();
        $this->newLine(2);

        $this->info(sprintf(
            'Done! Updated: %d, Skipped: %d, Errors: %d',
            $updated,
            $skipped,
            $errors
        ));

        if ($dryRun) {
            $this->warn('This was a dry run. No changes were made.');
        }

        return self::SUCCESS;
    }
}
