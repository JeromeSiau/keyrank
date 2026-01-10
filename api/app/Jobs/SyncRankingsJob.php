<?php

namespace App\Jobs;

use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Log;

class SyncRankingsJob implements ShouldQueue
{
    use Queueable;

    public int $timeout = 21600; // 6 hours max (rankings can be slow)
    public int $tries = 1;

    public function __construct(
        public ?int $appId = null,
    ) {}

    public function handle(): void
    {
        Log::info('SyncRankingsJob started', ['app_id' => $this->appId]);

        $options = [];

        if ($this->appId) {
            $options['--app'] = $this->appId;
        }

        $exitCode = Artisan::call('aso:sync-rankings', $options);

        Log::info('SyncRankingsJob completed', ['exit_code' => $exitCode]);

        // Don't throw on failure for rankings - some failures are expected
        if ($exitCode !== 0) {
            Log::warning('SyncRankings had errors', ['exit_code' => $exitCode]);
        }
    }

    public function tags(): array
    {
        return ['aso', 'sync', 'rankings', $this->appId ? "app:{$this->appId}" : 'all'];
    }
}
