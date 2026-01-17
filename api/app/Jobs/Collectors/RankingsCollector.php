<?php

namespace App\Jobs\Collectors;

use App\Models\AppRanking;
use App\Models\TrackedKeyword;
use App\Services\iTunesService;
use App\Services\GooglePlayService;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

class RankingsCollector extends BaseCollector
{
    protected int $rateLimitMs = 300;
    public int $timeout = 21600; // 6 hours
    protected int $batchSize = 100;

    private iTunesService $iTunesService;
    private GooglePlayService $googlePlayService;

    /** @var array Buffer for batch ranking upserts */
    private array $rankingBuffer = [];

    public function __construct()
    {
        $this->iTunesService = app(iTunesService::class);
        $this->googlePlayService = app(GooglePlayService::class);
    }

    public function getCollectorName(): string
    {
        return 'RankingsCollector';
    }

    /**
     * Get all distinct (app_id, keyword_id) pairs that need ranking updates
     */
    public function getItems(): Collection
    {
        // Get all distinct app/keyword combinations that are being tracked
        return DB::table('tracked_keywords')
            ->join('apps', 'apps.id', '=', 'tracked_keywords.app_id')
            ->join('keywords', 'keywords.id', '=', 'tracked_keywords.keyword_id')
            ->select([
                'tracked_keywords.app_id',
                'tracked_keywords.keyword_id',
                'apps.platform',
                'apps.store_id',
                'keywords.keyword',
                'keywords.storefront',
            ])
            ->distinct()
            ->get();
    }

    /**
     * Process a single app/keyword pair
     */
    public function processItem(mixed $item): void
    {
        $appId = $item->app_id;
        $keywordId = $item->keyword_id;
        $platform = $item->platform;
        $storeId = $item->store_id;
        $keyword = $item->keyword;
        $country = strtolower($item->storefront);

        // Fetch ranking based on platform
        if ($platform === 'ios') {
            $position = $this->iTunesService->getAppRankForKeyword($storeId, $keyword, $country);
        } else {
            $position = $this->googlePlayService->getAppRankForKeyword($storeId, $keyword, $country);
        }

        // Buffer the ranking for batch upsert
        $this->rankingBuffer[] = [
            'app_id' => $appId,
            'keyword_id' => $keywordId,
            'recorded_at' => today(),
            'position' => $position,
            'created_at' => now(),
            'updated_at' => now(),
        ];

        // Flush buffer when it reaches batch size
        if (count($this->rankingBuffer) >= $this->batchSize) {
            $this->flushRankingBuffer();
        }

        // Update tracked_keyword metrics if we have a position
        if ($position !== null) {
            $this->updateKeywordMetrics($item, $position);
        }
    }

    /**
     * Flush the ranking buffer using batch upsert
     */
    private function flushRankingBuffer(): void
    {
        if (empty($this->rankingBuffer)) {
            return;
        }

        AppRanking::upsert(
            $this->rankingBuffer,
            ['app_id', 'keyword_id', 'recorded_at'], // Unique keys
            ['position', 'updated_at'] // Columns to update on conflict
        );

        $this->rankingBuffer = [];
    }

    /**
     * Override handle to flush remaining buffer at the end
     */
    public function handle(): void
    {
        parent::handle();

        // Flush any remaining items in the buffer
        $this->flushRankingBuffer();
    }

    /**
     * Update keyword metrics (difficulty, competition, etc.)
     */
    private function updateKeywordMetrics(object $item, int $position): void
    {
        $platform = $item->platform;
        $storeId = $item->store_id;
        $keyword = $item->keyword;
        $country = strtolower($item->storefront);

        // Get search results for competition analysis
        if ($platform === 'ios') {
            $searchResults = $this->iTunesService->searchApps($keyword, $country, 10);
        } else {
            $searchResults = $this->googlePlayService->searchApps($keyword, $country, 10);
        }

        $competition = count($searchResults);
        $topCompetitors = array_slice($searchResults, 0, 3);

        // Calculate difficulty based on:
        // - Position (better position = easier keyword for this app)
        // - Competition (more apps = harder keyword)
        $positionFactor = $position <= 10 ? 0.3 : ($position <= 50 ? 0.5 : 0.7);
        $competitionFactor = min(1.0, $competition / 100);
        $difficulty = ($positionFactor + $competitionFactor) / 2;

        $difficultyLabel = match (true) {
            $difficulty < 0.33 => 'easy',
            $difficulty < 0.66 => 'medium',
            default => 'hard',
        };

        // Update tracked_keyword records for all users tracking this app/keyword
        TrackedKeyword::where('app_id', $item->app_id)
            ->where('keyword_id', $item->keyword_id)
            ->update([
                'difficulty' => round($difficulty, 2),
                'difficulty_label' => $difficultyLabel,
                'competition' => $competition,
                'top_competitors' => json_encode($topCompetitors),
            ]);
    }

    protected function getItemIdentifier(mixed $item): string
    {
        return "app:{$item->app_id}:kw:{$item->keyword_id}";
    }
}
