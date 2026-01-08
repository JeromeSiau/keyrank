<?php

namespace App\Console\Commands;

use App\Models\AppRanking;
use App\Models\KeywordPopularityHistory;
use Illuminate\Console\Command;

class CleanupHistory extends Command
{
    protected $signature = 'aso:cleanup {--days=90 : Keep history for this many days}';
    protected $description = 'Clean up old ranking and popularity history data';

    public function handle(): int
    {
        $days = (int) $this->option('days');
        $cutoff = now()->subDays($days);

        $this->info("Cleaning up history older than {$days} days...");

        // Clean ranking history
        $rankingsDeleted = AppRanking::where('recorded_at', '<', $cutoff)->delete();
        $this->info("Deleted {$rankingsDeleted} old ranking records.");

        // Clean popularity history
        $popularityDeleted = KeywordPopularityHistory::where('recorded_at', '<', $cutoff)->delete();
        $this->info("Deleted {$popularityDeleted} old popularity records.");

        $this->info('Cleanup complete.');

        return 0;
    }
}
