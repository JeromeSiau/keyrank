<?php

namespace App\Console\Commands;

use App\Services\RevenueScraperService;
use Illuminate\Console\Command;

class SyncRevenue extends Command
{
    protected $signature = 'revenue:sync
        {--source=all : Source to sync (whatstheapp, all)}
        {--dry-run : Show what would be synced without saving}';

    protected $description = 'Sync revenue data from marketplace scrapers';

    public function handle(RevenueScraperService $service): int
    {
        $source = $this->option('source');
        $dryRun = $this->option('dry-run');

        if ($dryRun) {
            $this->warn('Dry run mode - no changes will be saved');
        }

        // Check scraper health
        if (!$service->isHealthy()) {
            $this->error('Revenue scraper is not responding. Is it running?');
            $this->line('  Start with: cd scraper-py && python -m src.main');
            return Command::FAILURE;
        }

        $this->info('Revenue scraper is healthy');
        $this->newLine();

        $totalSynced = 0;
        $totalCreated = 0;
        $totalUpdated = 0;
        $allErrors = [];

        // Sync whatsthe.app
        if ($source === 'all' || $source === 'whatstheapp') {
            $this->line('Syncing whatsthe.app...');

            if ($dryRun) {
                $this->info('  Would sync whatsthe.app data');
            } else {
                $result = $service->syncWhatsTheApp();

                $totalSynced += $result['synced'];
                $totalCreated += $result['created'];
                $totalUpdated += $result['updated'];
                $allErrors = array_merge($allErrors, $result['errors']);

                $this->info("  Synced: {$result['synced']} apps ({$result['created']} new, {$result['updated']} updated)");

                if (!empty($result['errors'])) {
                    foreach ($result['errors'] as $error) {
                        $this->warn("  Error: {$error}");
                    }
                }
            }
        }

        $this->newLine();
        $this->info("Total: {$totalSynced} apps synced ({$totalCreated} created, {$totalUpdated} updated)");

        if (!empty($allErrors)) {
            $this->warn('Completed with ' . count($allErrors) . ' error(s)');
            return Command::FAILURE;
        }

        $this->info('Sync completed successfully');
        return Command::SUCCESS;
    }
}
