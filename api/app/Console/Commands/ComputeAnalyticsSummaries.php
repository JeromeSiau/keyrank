<?php

namespace App\Console\Commands;

use App\Models\App;
use App\Services\AnalyticsSyncService;
use Illuminate\Console\Command;

class ComputeAnalyticsSummaries extends Command
{
    protected $signature = 'analytics:compute-summaries
                            {--app= : Specific app ID to compute summaries for}';

    protected $description = 'Recompute analytics summaries for all periods (7d, 30d, 90d, ytd, all)';

    public function __construct(
        private AnalyticsSyncService $syncService,
    ) {
        parent::__construct();
    }

    public function handle(): int
    {
        if ($appId = $this->option('app')) {
            $app = App::find($appId);

            if (!$app) {
                $this->error("App with ID {$appId} not found.");
                return 1;
            }

            $this->info("Computing summaries for app: {$app->name}...");
            $this->syncService->computeSummariesForApp($app);
            $this->info('Done.');

            return 0;
        }

        $this->info('Computing analytics summaries for all apps with data...');

        $count = $this->syncService->computeAllSummaries();

        $this->info("Computed summaries for {$count} apps.");

        return 0;
    }
}
