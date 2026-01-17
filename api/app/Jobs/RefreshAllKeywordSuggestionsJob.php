<?php

namespace App\Jobs;

use App\Models\App;
use App\Models\KeywordSuggestion;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

/**
 * Weekly job to refresh keyword suggestions for all apps.
 * Dispatches individual GenerateKeywordSuggestionsJob for each app.
 * Uses each app's storefront for country-specific suggestions.
 */
class RefreshAllKeywordSuggestionsJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public int $timeout = 60; // Just dispatches jobs, shouldn't take long

    public function __construct(
        public ?string $countryOverride = null // If null, use each app's storefront
    ) {}

    public function handle(): void
    {
        Log::info("Starting weekly keyword suggestions refresh" .
            ($this->countryOverride ? " for country: {$this->countryOverride}" : " using each app's storefront"));

        // Get all apps that have users tracking them (iOS + Android)
        $apps = App::whereHas('users')
            ->select('id', 'name', 'storefront', 'platform')
            ->get();

        $count = 0;

        foreach ($apps as $app) {
            // Use override or app's storefront
            $country = $this->countryOverride ?? strtoupper($app->storefront ?? 'US');

            // Check if suggestions need refresh (older than 7 days or don't exist)
            $latestSuggestion = KeywordSuggestion::where('app_id', $app->id)
                ->where('country', $country)
                ->orderByDesc('generated_at')
                ->first();

            $needsRefresh = !$latestSuggestion ||
                           !$latestSuggestion->generated_at ||
                           $latestSuggestion->generated_at->diffInDays(now()) >= 7;

            if ($needsRefresh) {
                GenerateKeywordSuggestionsJob::dispatch($app->id, $country, 50)
                    ->delay(now()->addMinutes($count * 2)); // Stagger jobs to avoid rate limits

                $count++;
            }
        }

        Log::info("Dispatched {$count} keyword suggestion generation jobs");
    }
}
