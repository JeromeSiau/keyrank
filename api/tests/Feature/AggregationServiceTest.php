<?php

namespace Tests\Feature;

use App\Models\App;
use App\Models\AppRanking;
use App\Models\AppRankingAggregate;
use App\Models\Keyword;
use App\Models\KeywordPopularityAggregate;
use App\Models\KeywordPopularityHistory;
use App\Services\AggregationService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AggregationServiceTest extends TestCase
{
    use RefreshDatabase;

    private AggregationService $service;

    protected function setUp(): void
    {
        parent::setUp();
        $this->service = new AggregationService;
    }

    public function test_aggregates_daily_rankings_to_weekly(): void
    {
        $app = App::factory()->create();
        $keyword = Keyword::factory()->create();

        // Create 7 days of rankings starting 100 days ago (> 90 days cutoff)
        $startDate = now()->subDays(100)->startOfWeek();
        for ($i = 0; $i < 7; $i++) {
            AppRanking::create([
                'app_id' => $app->id,
                'keyword_id' => $keyword->id,
                'position' => 10 + $i, // positions 10-16
                'recorded_at' => $startDate->copy()->addDays($i),
            ]);
        }

        $this->service->aggregateDailyToWeekly(90);

        // Verify aggregate was created
        $aggregate = AppRankingAggregate::where('app_id', $app->id)
            ->where('keyword_id', $keyword->id)
            ->where('period_type', 'weekly')
            ->first();

        $this->assertNotNull($aggregate);
        $this->assertEquals(13.0, $aggregate->avg_position); // (10+11+12+13+14+15+16)/7 = 13
        $this->assertEquals(10, $aggregate->min_position);
        $this->assertEquals(16, $aggregate->max_position);
        $this->assertEquals(7, $aggregate->data_points);

        // Verify daily records were deleted
        $this->assertEquals(0, AppRanking::where('app_id', $app->id)->count());
    }

    public function test_does_not_aggregate_recent_daily_rankings(): void
    {
        $app = App::factory()->create();
        $keyword = Keyword::factory()->create();

        // Create ranking within 90 days (should NOT be aggregated)
        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 5,
            'recorded_at' => now()->subDays(30),
        ]);

        $this->service->aggregateDailyToWeekly(90);

        // Verify no aggregate was created
        $this->assertEquals(0, AppRankingAggregate::count());

        // Verify daily record still exists
        $this->assertEquals(1, AppRanking::count());
    }

    public function test_aggregates_weekly_to_monthly(): void
    {
        $app = App::factory()->create();
        $keyword = Keyword::factory()->create();

        // Create 4 weekly aggregates from > 1 year ago
        $monthStart = now()->subMonths(14)->startOfMonth();
        for ($week = 0; $week < 4; $week++) {
            AppRankingAggregate::create([
                'app_id' => $app->id,
                'keyword_id' => $keyword->id,
                'period_type' => 'weekly',
                'period_start' => $monthStart->copy()->addWeeks($week),
                'avg_position' => 10 + $week,
                'min_position' => 8 + $week,
                'max_position' => 12 + $week,
                'data_points' => 7,
            ]);
        }

        $this->service->aggregateWeeklyToMonthly(365);

        // Verify monthly aggregate was created
        $monthly = AppRankingAggregate::where('period_type', 'monthly')->first();

        $this->assertNotNull($monthly);
        $this->assertEquals(11.5, $monthly->avg_position); // (10+11+12+13)/4 = 11.5
        $this->assertEquals(8, $monthly->min_position); // min of all mins
        $this->assertEquals(15, $monthly->max_position); // max of all maxes
        $this->assertEquals(28, $monthly->data_points); // 4 weeks * 7 days

        // Verify weekly records were deleted
        $this->assertEquals(0, AppRankingAggregate::where('period_type', 'weekly')->count());
    }

    public function test_aggregates_popularity_daily_to_weekly(): void
    {
        $keyword = Keyword::factory()->create();

        // Create 7 days of popularity starting 100 days ago
        $startDate = now()->subDays(100)->startOfWeek();
        for ($i = 0; $i < 7; $i++) {
            KeywordPopularityHistory::create([
                'keyword_id' => $keyword->id,
                'popularity' => 50 + $i,
                'recorded_at' => $startDate->copy()->addDays($i),
            ]);
        }

        $this->service->aggregateDailyToWeekly(90);

        $aggregate = KeywordPopularityAggregate::first();

        $this->assertNotNull($aggregate);
        $this->assertEquals(53.0, $aggregate->avg_popularity);
        $this->assertEquals(50, $aggregate->min_popularity);
        $this->assertEquals(56, $aggregate->max_popularity);
        $this->assertEquals(7, $aggregate->data_points);
    }

    public function test_handles_partial_week_data(): void
    {
        $app = App::factory()->create();
        $keyword = Keyword::factory()->create();

        // Create only 3 days of rankings (partial week)
        $startDate = now()->subDays(100)->startOfWeek();
        for ($i = 0; $i < 3; $i++) {
            AppRanking::create([
                'app_id' => $app->id,
                'keyword_id' => $keyword->id,
                'position' => 10 + $i,
                'recorded_at' => $startDate->copy()->addDays($i),
            ]);
        }

        $this->service->aggregateDailyToWeekly(90);

        $aggregate = AppRankingAggregate::first();

        $this->assertNotNull($aggregate);
        $this->assertEquals(3, $aggregate->data_points); // Only 3 days
    }
}
