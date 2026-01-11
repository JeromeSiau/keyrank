<?php

namespace App\Console\Commands;

use App\Services\AggregationService;
use Illuminate\Console\Command;

class CleanupHistory extends Command
{
    protected $signature = 'aso:cleanup {--days=90 : Keep daily history for this many days}';

    protected $description = 'Aggregate old data and clean up history';

    public function __construct(private AggregationService $aggregationService)
    {
        parent::__construct();
    }

    public function handle(): int
    {
        $days = (int) $this->option('days');

        $this->info("Processing history older than {$days} days...");

        // Step 1: Weekly → Monthly (data older than 1 year)
        $this->info('Aggregating weekly to monthly (> 1 year)...');
        $monthlyStats = $this->aggregationService->aggregateWeeklyToMonthly(365);
        $this->info("Created {$monthlyStats['rankings']} monthly ranking aggregates.");
        $this->info("Created {$monthlyStats['popularity']} monthly popularity aggregates.");

        // Step 2: Daily → Weekly (data older than $days)
        $this->info("Aggregating daily to weekly (> {$days} days)...");
        $weeklyStats = $this->aggregationService->aggregateDailyToWeekly($days);
        $this->info("Created {$weeklyStats['rankings']} weekly ranking aggregates.");
        $this->info("Created {$weeklyStats['popularity']} weekly popularity aggregates.");

        $this->info('Cleanup complete.');

        return 0;
    }
}
