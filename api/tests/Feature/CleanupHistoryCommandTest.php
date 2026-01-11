<?php

namespace Tests\Feature;

use App\Models\App;
use App\Models\AppRanking;
use App\Models\AppRankingAggregate;
use App\Models\Keyword;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class CleanupHistoryCommandTest extends TestCase
{
    use RefreshDatabase;

    public function test_cleanup_aggregates_before_deleting(): void
    {
        $app = App::factory()->create();
        $keyword = Keyword::factory()->create();

        // Create old rankings (> 90 days)
        for ($i = 0; $i < 7; $i++) {
            AppRanking::create([
                'app_id' => $app->id,
                'keyword_id' => $keyword->id,
                'position' => 10 + $i,
                'recorded_at' => now()->subDays(100)->startOfWeek()->addDays($i),
            ]);
        }

        // Create recent ranking (should be kept)
        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 5,
            'recorded_at' => now()->subDays(30),
        ]);

        $this->artisan('aso:cleanup', ['--days' => 90])
            ->assertSuccessful();

        // Old rankings should be aggregated then deleted
        $this->assertEquals(1, AppRanking::count()); // Only recent one remains

        // Aggregate should be created
        $aggregate = AppRankingAggregate::first();
        $this->assertNotNull($aggregate);
        $this->assertEquals('weekly', $aggregate->period_type);
    }
}
