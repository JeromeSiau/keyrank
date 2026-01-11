<?php

namespace App\Console\Commands;

use App\Services\AggregationService;
use Illuminate\Console\Command;

class MigrateToAggregates extends Command
{
    protected $signature = 'aso:migrate-to-aggregates
                            {--days=90 : Daily data retention in days}
                            {--dry-run : Show what would be done without making changes}';

    protected $description = 'One-time migration: aggregate existing historical data';

    public function __construct(private AggregationService $aggregationService)
    {
        parent::__construct();
    }

    public function handle(): int
    {
        $days = (int) $this->option('days');
        $dryRun = $this->option('dry-run');

        if ($dryRun) {
            $this->warn('DRY RUN - No changes will be made.');
        }

        $this->info('Migrating existing historical data to aggregates...');
        $this->info("Daily retention: {$days} days");
        $this->info('Weekly retention: 365 days');
        $this->info('Monthly retention: unlimited');

        if (! $dryRun && ! $this->confirm('This will permanently transform old daily data into aggregates. Continue?')) {
            $this->info('Aborted.');

            return 1;
        }

        if ($dryRun) {
            $this->info('Would aggregate data older than 365 days into monthly aggregates.');
            $this->info("Would aggregate data between {$days} and 365 days into weekly aggregates.");

            return 0;
        }

        // Step 1: Aggregate really old data to monthly first
        $this->info('Step 1: Converting weekly aggregates > 1 year to monthly...');
        $monthlyStats = $this->aggregationService->aggregateWeeklyToMonthly(365);
        $this->info("Created {$monthlyStats['rankings']} monthly ranking aggregates.");
        $this->info("Created {$monthlyStats['popularity']} monthly popularity aggregates.");

        // Step 2: Aggregate old daily data to weekly
        $this->info("Step 2: Converting daily data > {$days} days to weekly...");
        $weeklyStats = $this->aggregationService->aggregateDailyToWeekly($days);
        $this->info("Created {$weeklyStats['rankings']} weekly ranking aggregates.");
        $this->info("Created {$weeklyStats['popularity']} weekly popularity aggregates.");

        $this->info('Migration complete!');

        return 0;
    }
}
