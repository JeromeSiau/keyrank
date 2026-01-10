<?php

namespace App\Jobs;

use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Log;

class RefreshSuggestionsJob implements ShouldQueue
{
    use Queueable;

    public int $timeout = 3600; // 1 hour max
    public int $tries = 1;

    public function __construct(
        public ?string $platform = null,
        public bool $expiredOnly = true,
    ) {}

    public function handle(): void
    {
        Log::info('RefreshSuggestionsJob started', [
            'platform' => $this->platform,
            'expired_only' => $this->expiredOnly,
        ]);

        $options = [];

        if ($this->platform) {
            $options['--platform'] = $this->platform;
        }

        if ($this->expiredOnly) {
            $options['--expired-only'] = true;
        }

        $exitCode = Artisan::call('aso:refresh-suggestions', $options);

        Log::info('RefreshSuggestionsJob completed', ['exit_code' => $exitCode]);

        if ($exitCode !== 0) {
            Log::warning('RefreshSuggestions had errors', ['exit_code' => $exitCode]);
        }
    }

    public function tags(): array
    {
        return ['aso', 'refresh', 'suggestions', $this->platform ?? 'all'];
    }
}
