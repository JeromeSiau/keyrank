<?php

namespace App\Console\Commands;

use App\Events\RankingsSynced;
use App\Models\App;
use App\Models\AppRanking;
use App\Models\TrackedKeyword;
use App\Services\GooglePlayService;
use App\Services\iTunesService;
use App\Services\KeywordDiscoveryService;
use Illuminate\Console\Command;

class SyncRankings extends Command
{
    protected $signature = 'aso:sync-rankings {--app= : Specific app ID to sync}';
    protected $description = 'Sync App Store and Play Store rankings for all tracked keywords';

    public function __construct(
        private iTunesService $iTunesService,
        private GooglePlayService $googlePlayService,
        private KeywordDiscoveryService $keywordDiscoveryService
    ) {
        parent::__construct();
    }

    public function handle(): int
    {
        // Get distinct (app_id, keyword_id) pairs to avoid fetching same ranking multiple times
        // when multiple users track the same keyword for the same app
        $query = TrackedKeyword::query()
            ->select('app_id', 'keyword_id')
            ->with(['app', 'keyword'])
            ->distinct();

        if ($appId = $this->option('app')) {
            $query->where('app_id', $appId);
        }

        $pairs = $query->get();

        if ($pairs->isEmpty()) {
            $this->info('No keywords to sync.');
            return 0;
        }

        $this->info("Syncing rankings for {$pairs->count()} unique app-keyword pairs...");
        $bar = $this->output->createProgressBar($pairs->count());

        $synced = 0;
        $errors = 0;
        $syncedRankings = collect();

        foreach ($pairs as $item) {
            $country = strtolower($item->keyword->storefront);
            $platform = $item->app->platform;

            try {
                // Get search results (we need them for both position and metrics)
                $service = $platform === 'ios' ? $this->iTunesService : $this->googlePlayService;
                $searchResults = $service->searchApps($item->keyword->keyword, $country, 50);

                // Find position
                $position = null;
                $appStoreId = $item->app->store_id;
                $idField = $platform === 'ios' ? 'apple_id' : 'google_play_id';

                foreach ($searchResults as $result) {
                    if (($result[$idField] ?? null) === $appStoreId) {
                        $position = $result['position'];
                        break;
                    }
                }

                // Calculate difficulty
                $difficulty = $this->keywordDiscoveryService->calculateDifficulty($searchResults);

                // Get top 3 competitors
                $topCompetitors = array_slice(array_map(fn($r) => [
                    'name' => $r['name'],
                    'position' => $r['position'],
                    'icon_url' => $r['icon_url'] ?? null,
                ], $searchResults), 0, 3);

                // Save ranking for the user's app
                $ranking = AppRanking::updateOrCreate(
                    [
                        'app_id' => $item->app_id,
                        'keyword_id' => $item->keyword_id,
                        'recorded_at' => today(),
                    ],
                    ['position' => $position]
                );
                $syncedRankings->push($ranking);

                // Also save rankings for any known apps (competitors) that appear in search results
                $knownStoreIds = App::where('platform', $platform)
                    ->pluck('store_id', 'id')
                    ->toArray();

                foreach ($searchResults as $result) {
                    $resultStoreId = $result[$idField] ?? null;
                    if (!$resultStoreId || $resultStoreId === $appStoreId) {
                        continue; // Skip if no store_id or if it's the user's app (already saved)
                    }

                    // Find the app ID for this store_id
                    $matchedAppId = array_search($resultStoreId, $knownStoreIds);
                    if ($matchedAppId !== false) {
                        AppRanking::updateOrCreate(
                            [
                                'app_id' => $matchedAppId,
                                'keyword_id' => $item->keyword_id,
                                'recorded_at' => today(),
                            ],
                            ['position' => $result['position']]
                        );
                    }
                }

                // Update tracked_keywords metrics for all users tracking this keyword/app pair
                TrackedKeyword::where('app_id', $item->app_id)
                    ->where('keyword_id', $item->keyword_id)
                    ->update([
                        'difficulty' => $difficulty['score'],
                        'difficulty_label' => $difficulty['label'],
                        'competition' => count($searchResults),
                        'top_competitors' => $topCompetitors,
                    ]);

                $synced++;
            } catch (\Exception $e) {
                $this->error("\nError syncing {$platform} {$item->keyword->keyword}: {$e->getMessage()}");
                $errors++;
            }

            usleep(300000); // Rate limiting

            $bar->advance();
        }

        $bar->finish();
        $this->newLine(2);

        $this->info("Sync complete: {$synced} rankings synced, {$errors} errors.");

        // Dispatch event to evaluate alerts for synced rankings
        if ($syncedRankings->isNotEmpty()) {
            RankingsSynced::dispatch($syncedRankings);
        }

        return $errors > 0 ? 1 : 0;
    }
}
