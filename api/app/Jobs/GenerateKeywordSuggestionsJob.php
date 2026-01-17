<?php

namespace App\Jobs;

use App\Models\App;
use App\Models\KeywordSuggestion;
use App\Services\KeywordSuggestionService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class GenerateKeywordSuggestionsJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public int $timeout = 900; // 15 minutes max (more time for AI suggestions)
    public int $tries = 2;

    public function __construct(
        public int $appId,
        public string $country = 'US',
        public int $limitPerCategory = 15
    ) {}

    public function handle(KeywordSuggestionService $service): void
    {
        $app = App::find($this->appId);

        if (!$app) {
            Log::warning("GenerateKeywordSuggestionsJob: App {$this->appId} not found");
            return;
        }

        Log::info("Generating keyword suggestions for app {$app->name} ({$app->store_id}) in {$this->country}");

        try {
            // Get categorized suggestions from the service
            $suggestions = $service->generateSuggestions(
                $app,
                $this->country,
                $this->limitPerCategory
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
                    'source' => $suggestion['source'] ?? 'search_hints',
                    'category' => $suggestion['category'] ?? 'high_opportunity',
                    'position' => $suggestion['position'] ?? null,
                    'competition' => $suggestion['competition'] ?? 0,
                    'difficulty' => $suggestion['difficulty'] ?? 0,
                    'difficulty_label' => $suggestion['difficulty_label'] ?? 'easy',
                    'popularity' => $suggestion['popularity'] ?? null,
                    'reason' => $suggestion['reason'] ?? null,
                    'based_on' => $suggestion['based_on'] ?? null,
                    'competitor_name' => $suggestion['competitor_name'] ?? null,
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
