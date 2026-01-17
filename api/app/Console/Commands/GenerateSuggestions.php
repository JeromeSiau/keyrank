<?php

namespace App\Console\Commands;

use App\Jobs\GenerateKeywordSuggestionsJob;
use App\Models\App;
use App\Models\KeywordSuggestion;
use App\Services\KeywordSuggestionService;
use Illuminate\Console\Command;

class GenerateSuggestions extends Command
{
    protected $signature = 'aso:generate-suggestions
        {--app= : Specific app ID to generate suggestions for}
        {--country= : Country code (default: app\'s storefront)}
        {--limit=15 : Max suggestions per category (default: 15)}
        {--sync : Run synchronously instead of dispatching to queue}
        {--force : Force regeneration even if recent suggestions exist}
        {--verbose : Show detailed progress}';

    protected $description = 'Generate AI keyword suggestions for apps (categorized: high opportunity, competitor, long-tail, trending, related)';

    public function handle(): int
    {
        $appId = $this->option('app');
        $countryOption = $this->option('country');
        $limit = (int) $this->option('limit');
        $sync = $this->option('sync');
        $force = $this->option('force');
        $verbose = $this->option('verbose');

        if ($appId) {
            return $this->processApp($appId, $countryOption, $limit, $sync, $verbose);
        }

        return $this->processAllApps($countryOption, $limit, $sync, $force, $verbose);
    }

    private function processApp(int $appId, ?string $countryOption, int $limit, bool $sync, bool $verbose): int
    {
        $app = App::find($appId);

        if (!$app) {
            $this->error("App not found: {$appId}");
            return Command::FAILURE;
        }

        // Use app's storefront if no country specified
        $country = $countryOption ? strtoupper($countryOption) : strtoupper($app->storefront ?? 'US');

        $this->info("Generating suggestions for: {$app->name} ({$app->store_id})");
        $this->line("  Country: {$country}" . ($countryOption ? '' : ' (from app storefront)'));
        $this->line("  Limit per category: {$limit}");

        if ($sync) {
            $this->line("  Mode: synchronous" . ($verbose ? ' (verbose)' : ''));
            $this->newLine();

            try {
                if ($verbose) {
                    $this->generateWithProgress($app, $country, $limit);
                } else {
                    $job = new GenerateKeywordSuggestionsJob($appId, $country, $limit);
                    $job->handle(app(KeywordSuggestionService::class));
                }
                $this->info("✅ Suggestions generated successfully");
            } catch (\Exception $e) {
                $this->error("❌ Failed: " . $e->getMessage());
                return Command::FAILURE;
            }
        } else {
            GenerateKeywordSuggestionsJob::dispatch($appId, $country, $limit);
            $this->info("✅ Job dispatched to queue");
            $this->line("   Run: php artisan queue:work");
        }

        return Command::SUCCESS;
    }

    private function generateWithProgress(App $app, string $country, int $limit): void
    {
        $service = app(KeywordSuggestionService::class);

        $progressCallback = function (string $stage, int $current, int $total, ?string $detail = null) {
            $percent = $total > 0 ? round(($current / $total) * 100) : 0;
            $bar = str_repeat('█', (int)($percent / 5)) . str_repeat('░', 20 - (int)($percent / 5));
            $this->output->write("\r  [{$bar}] {$percent}% - {$stage}" . ($detail ? ": {$detail}" : '') . str_repeat(' ', 20));
        };

        $suggestions = $service->generateSuggestions($app, $country, $limit, $progressCallback);

        $this->newLine();
        $this->line("  Generated " . count($suggestions) . " suggestions");

        // Save to DB
        $this->line("  Saving to database...");
        KeywordSuggestion::where('app_id', $app->id)
            ->where('country', $country)
            ->delete();

        $now = now();
        foreach ($suggestions as $suggestion) {
            KeywordSuggestion::create([
                'app_id' => $app->id,
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
                'country' => $country,
                'generated_at' => $now,
            ]);
        }
        $this->newLine();
    }

    private function processAllApps(?string $countryOption, int $limit, bool $sync, bool $force, bool $verbose): int
    {
        $query = App::whereHas('users');

        $apps = $query->get();

        if ($apps->isEmpty()) {
            $this->warn("No apps with tracked users found");
            return Command::SUCCESS;
        }

        $this->info("Processing {$apps->count()} apps...");
        $this->line("  Country: " . ($countryOption ? strtoupper($countryOption) : 'each app\'s storefront'));
        $this->line("  Limit per category: {$limit}");
        $this->line("  Mode: " . ($sync ? 'synchronous' : 'queue') . ($verbose ? ' (verbose)' : ''));
        $this->newLine();

        $processed = 0;
        $skipped = 0;
        $errors = 0;

        foreach ($apps as $index => $app) {
            // Use app's storefront if no country override
            $country = $countryOption ? strtoupper($countryOption) : strtoupper($app->storefront ?? 'US');

            // Check if recent suggestions exist (unless --force)
            if (!$force) {
                $hasRecent = $app->keywordSuggestions()
                    ->where('country', $country)
                    ->where('generated_at', '>', now()->subDays(1))
                    ->exists();

                if ($hasRecent) {
                    $skipped++;
                    if ($verbose) {
                        $this->line("[" . ($index + 1) . "/{$apps->count()}] {$app->name} - skipped (recent)");
                    }
                    continue;
                }
            }

            if ($verbose) {
                $this->info("[" . ($index + 1) . "/{$apps->count()}] {$app->name} ({$country})");
            }

            try {
                if ($sync) {
                    if ($verbose) {
                        $this->generateWithProgress($app, $country, $limit);
                    } else {
                        $job = new GenerateKeywordSuggestionsJob($app->id, $country, $limit);
                        $job->handle(app(KeywordSuggestionService::class));
                    }
                } else {
                    GenerateKeywordSuggestionsJob::dispatch($app->id, $country, $limit)
                        ->delay(now()->addSeconds($processed * 10)); // Stagger by 10s
                }
                $processed++;
            } catch (\Exception $e) {
                $errors++;
                $this->error("  ❌ Error: " . $e->getMessage());
            }
        }

        $this->newLine();
        $this->info("Summary:");
        $this->line("  - Processed: {$processed}");
        $this->line("  - Skipped (recent): {$skipped}");
        $this->line("  - Errors: {$errors}");

        if (!$sync && $processed > 0) {
            $this->newLine();
            $this->line("Jobs dispatched. Run: php artisan queue:work");
        }

        return $errors > 0 ? Command::FAILURE : Command::SUCCESS;
    }
}
