<?php

namespace App\Jobs;

use App\Models\App;
use App\Models\KeywordSuggestion;
use App\Services\KeywordDiscoveryService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class GenerateKeywordSuggestionsJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public int $timeout = 600; // 10 minutes max
    public int $tries = 2;

    public function __construct(
        public int $appId,
        public string $country = 'US',
        public int $limit = 50
    ) {}

    public function handle(KeywordDiscoveryService $service): void
    {
        $app = App::find($this->appId);

        if (!$app) {
            Log::warning("GenerateKeywordSuggestionsJob: App {$this->appId} not found");
            return;
        }

        Log::info("Generating keyword suggestions for app {$app->name} ({$app->store_id}) in {$this->country}");

        try {
            // Get suggestions from the discovery service
            $suggestions = $service->getSuggestionsForApp(
                $app->store_id,
                $this->country,
                $this->limit
            );

            // Delete old suggestions for this app/country
            KeywordSuggestion::where('app_id', $this->appId)
                ->where('country', $this->country)
                ->delete();

            // Insert new suggestions
            $now = now();
            foreach ($suggestions as $suggestion) {
                KeywordSuggestion::create([
                    'app_id' => $this->appId,
                    'keyword' => $suggestion['keyword'],
                    'source' => $suggestion['source'] ?? 'app_name',
                    'position' => $suggestion['metrics']['position'] ?? null,
                    'competition' => $suggestion['metrics']['competition'] ?? 0,
                    'difficulty' => $suggestion['metrics']['difficulty'] ?? 0,
                    'difficulty_label' => $suggestion['metrics']['difficulty_label'] ?? 'easy',
                    'top_competitors' => $suggestion['top_competitors'] ?? [],
                    'country' => $this->country,
                    'generated_at' => $now,
                ]);
            }

            Log::info("Generated " . count($suggestions) . " keyword suggestions for app {$app->name}");

        } catch (\Exception $e) {
            Log::error("Failed to generate keyword suggestions for app {$this->appId}: " . $e->getMessage());
            throw $e;
        }
    }
}
