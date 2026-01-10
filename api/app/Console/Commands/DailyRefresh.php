<?php

namespace App\Console\Commands;

use App\Jobs\RefreshSuggestionsJob;
use App\Jobs\RefreshTopAppsJob;
use App\Jobs\RefreshUserAppsJob;
use App\Jobs\SyncRankingsJob;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Bus;

class DailyRefresh extends Command
{
    protected $signature = 'aso:daily-refresh
        {--platform= : Platform to refresh (ios, android, or both)}
        {--skip-top : Skip top apps refresh}
        {--skip-user-apps : Skip user apps refresh}
        {--skip-rankings : Skip rankings sync}
        {--skip-suggestions : Skip suggestions refresh}
        {--sync : Run synchronously instead of dispatching to queue}';

    protected $description = 'Run all daily ASO refresh tasks (dispatches jobs to queue)';

    public function handle(): int
    {
        $platform = $this->option('platform');
        $sync = $this->option('sync');

        $jobs = [];

        // Build job chain
        if (!$this->option('skip-top')) {
            $jobs[] = new RefreshTopAppsJob($platform);
            $this->line("📊 Top Apps refresh" . ($sync ? '' : ' queued'));
        }

        if (!$this->option('skip-user-apps')) {
            $jobs[] = new RefreshUserAppsJob($platform);
            $this->line("📱 User Apps refresh" . ($sync ? '' : ' queued'));
        }

        if (!$this->option('skip-rankings')) {
            $jobs[] = new SyncRankingsJob();
            $this->line("📈 Rankings sync" . ($sync ? '' : ' queued'));
        }

        if (!$this->option('skip-suggestions')) {
            $jobs[] = new RefreshSuggestionsJob($platform, expiredOnly: true);
            $this->line("💡 Suggestions refresh" . ($sync ? '' : ' queued'));
        }

        if (empty($jobs)) {
            $this->warn('No jobs to run (all skipped)');
            return Command::SUCCESS;
        }

        $this->newLine();

        if ($sync) {
            // Run synchronously (for testing/debugging)
            $this->info("Running {" . count($jobs) . "} jobs synchronously...");

            foreach ($jobs as $job) {
                $this->line("→ " . class_basename($job));
                $job->handle();
            }

            $this->info('✅ All jobs completed');
        } else {
            // Dispatch to queue as a chain
            Bus::chain($jobs)
                ->onQueue('aso-refresh')
                ->dispatch();

            $this->info("✅ Dispatched " . count($jobs) . " jobs to queue 'aso-refresh'");
            $this->line("   Run: php artisan queue:work --queue=aso-refresh");
        }

        return Command::SUCCESS;
    }
}
