<?php

namespace App\Jobs;

use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Log;

class RefreshUserAppsJob implements ShouldQueue
{
    use Queueable;

    public int $timeout = 1800; // 30 min max
    public int $tries = 1;

    public function __construct(
        public ?string $platform = null,
    ) {}

    public function handle(): void
    {
        Log::info('RefreshUserAppsJob started', ['platform' => $this->platform]);

        $options = [];

        if ($this->platform) {
            $options['--platform'] = $this->platform;
        }

        $exitCode = Artisan::call('aso:refresh-user-apps', $options);

        Log::info('RefreshUserAppsJob completed', ['exit_code' => $exitCode]);

        if ($exitCode !== 0) {
            throw new \Exception('RefreshUserApps failed with exit code: ' . $exitCode);
        }
    }

    public function tags(): array
    {
        return ['aso', 'refresh', 'user-apps', $this->platform ?? 'all'];
    }
}
