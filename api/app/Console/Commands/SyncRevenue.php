<?php

namespace App\Console\Commands;

use App\Services\RevenueScraperService;
use Illuminate\Console\Command;

class SyncRevenue extends Command
{
    protected $signature = 'revenue:sync
        {--source=all : Source to sync (whatstheapp, appbusinessbrokers, flippa, microns, all)}
        {--limit= : Limit number of apps to scrape per source (for testing)}
        {--dry-run : Show what would be synced without saving}';

    protected $description = 'Sync revenue data from marketplace scrapers';

    public function handle(RevenueScraperService $service): int
    {
        $source = $this->option('source');
        $limit = $this->option('limit') ? (int) $this->option('limit') : null;
        $dryRun = $this->option('dry-run');

        if ($dryRun) {
            $this->warn('Dry run mode - no changes will be saved');
        }

        if ($limit) {
            $this->info("Limiting to {$limit} apps per source");
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
            $this->syncSource($service, 'whatstheapp', 'syncWhatsTheApp', $dryRun, $limit, $totalSynced, $totalCreated, $totalUpdated, $allErrors);
        }

        // Sync appbusinessbrokers.com
        if ($source === 'all' || $source === 'appbusinessbrokers') {
            $this->syncSource($service, 'appbusinessbrokers', 'syncAppBusinessBrokers', $dryRun, $limit, $totalSynced, $totalCreated, $totalUpdated, $allErrors);
        }

        // Sync flippa.com
        if ($source === 'all' || $source === 'flippa') {
            $this->syncSource($service, 'flippa', 'syncFlippa', $dryRun, $limit, $totalSynced, $totalCreated, $totalUpdated, $allErrors);
        }

        // Sync microns.io
        if ($source === 'all' || $source === 'microns') {
            $this->syncSource($service, 'microns', 'syncMicrons', $dryRun, $limit, $totalSynced, $totalCreated, $totalUpdated, $allErrors);
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

    private function syncSource(
        RevenueScraperService $service,
        string $sourceName,
        string $method,
        bool $dryRun,
        ?int $limit,
        int &$totalSynced,
        int &$totalCreated,
        int &$totalUpdated,
        array &$allErrors
    ): void {
        $this->line("Syncing {$sourceName}...");

        if ($dryRun) {
            $this->info("  Would sync {$sourceName} data");
            return;
        }

        $result = $service->$method($limit);

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
