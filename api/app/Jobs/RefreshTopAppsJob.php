<?php

namespace App\Jobs;

use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Log;

class RefreshTopAppsJob implements ShouldQueue
{
    use Queueable;

    // Increased timeout for multiple countries/collections
    // 5 countries × 3 collections × 25 categories × 0.1s = ~37 min per platform
    public int $timeout = 7200; // 2 hours max
    public int $tries = 1;

    public function __construct(
        public ?string $platform = null,
    ) {}

    public function handle(): void
    {
        $countries = config('aso.top_apps.countries', ['us']);
        $collections = config('aso.top_apps.collections', ['top_free']);

        Log::info('RefreshTopAppsJob started', [
            'platform' => $this->platform ?? 'all',
            'countries' => $countries,
            'collections' => $collections,
        ]);

        $options = [];

        if ($this->platform) {
            $options['--platform'] = $this->platform;
        }

        // Command reads countries/collections from config by default
        $exitCode = Artisan::call('aso:refresh-top-apps', $options);

        Log::info('RefreshTopAppsJob completed', [
            'exit_code' => $exitCode,
        ]);

        if ($exitCode !== 0) {
            throw new \Exception('RefreshTopApps failed with exit code: ' . $exitCode);
        }
    }

    public function tags(): array
    {
        return ['aso', 'refresh', 'top-apps', $this->platform ?? 'all'];
    }
}
