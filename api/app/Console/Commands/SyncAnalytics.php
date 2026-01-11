<?php

namespace App\Console\Commands;

use App\Services\AnalyticsSyncService;
use Carbon\Carbon;
use Illuminate\Console\Command;

class SyncAnalytics extends Command
{
    protected $signature = 'analytics:sync-daily
                            {--date= : Specific date to sync (YYYY-MM-DD), defaults to yesterday}
                            {--days=1 : Number of days to sync backwards from date}';

    protected $description = 'Sync analytics data from App Store Connect and Google Play';

    public function __construct(
        private AnalyticsSyncService $syncService,
    ) {
        parent::__construct();
    }

    public function handle(): int
    {
        $startDate = $this->option('date')
            ? Carbon::parse($this->option('date'))
            : Carbon::yesterday();

        $days = (int) $this->option('days');

        $this->info("Syncing analytics for {$days} day(s) starting from {$startDate->toDateString()}...");

        $totalSynced = 0;
        $totalFailed = 0;
        $allErrors = [];

        for ($i = 0; $i < $days; $i++) {
            $date = $startDate->copy()->subDays($i)->toDateString();
            $this->line("  Processing {$date}...");

            $results = $this->syncService->syncAll($date);

            $totalSynced += $results['synced'];
            $totalFailed += $results['failed'];
            $allErrors = array_merge($allErrors, $results['errors']);

            if ($results['synced'] > 0) {
                $this->info("    Synced {$results['synced']} records");
            }

            if ($results['failed'] > 0) {
                $this->warn("    Failed {$results['failed']} connections");
            }
        }

        $this->newLine();
        $this->info("Sync complete: {$totalSynced} records synced, {$totalFailed} connections failed.");

        if (!empty($allErrors)) {
            $this->newLine();
            $this->warn('Errors:');
            foreach ($allErrors as $error) {
                $this->error("  - {$error}");
            }
        }

        return $totalFailed > 0 ? 1 : 0;
    }
}
