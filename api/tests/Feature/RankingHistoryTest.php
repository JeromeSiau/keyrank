<?php

namespace Tests\Feature;

use App\Models\App;
use App\Models\AppRanking;
use App\Models\AppRankingAggregate;
use App\Models\Keyword;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class RankingHistoryTest extends TestCase
{
    use RefreshDatabase;

    public function test_history_returns_daily_data(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();

        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 5,
            'recorded_at' => now()->subDays(10),
        ]);

        $response = $this->actingAs($user)
            ->getJson("/api/apps/{$app->id}/rankings/history?keyword_id={$keyword->id}&from=" . now()->subDays(30)->toDateString());

        $response->assertOk();
        $response->assertJsonPath('data.0.type', 'daily');
        $response->assertJsonPath('data.0.position', 5);
    }

    public function test_history_includes_weekly_aggregates(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();

        AppRankingAggregate::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'period_type' => 'weekly',
            'period_start' => now()->subDays(120),
            'avg_position' => 8.5,
            'min_position' => 5,
            'max_position' => 12,
            'data_points' => 7,
        ]);

        $response = $this->actingAs($user)
            ->getJson("/api/apps/{$app->id}/rankings/history?keyword_id={$keyword->id}&from=" . now()->subDays(150)->toDateString());

        $response->assertOk();
        $response->assertJsonPath('data.0.type', 'weekly');
        $response->assertJsonPath('data.0.avg', 8.5);
        $response->assertJsonPath('data.0.min', 5);
        $response->assertJsonPath('data.0.max', 12);
    }

    public function test_history_includes_monthly_aggregates(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();

        AppRankingAggregate::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'period_type' => 'monthly',
            'period_start' => now()->subMonths(14)->startOfMonth(),
            'avg_position' => 15.3,
            'min_position' => 8,
            'max_position' => 25,
            'data_points' => 28,
        ]);

        $response = $this->actingAs($user)
            ->getJson("/api/apps/{$app->id}/rankings/history?keyword_id={$keyword->id}&from=" . now()->subMonths(16)->toDateString());

        $response->assertOk();
        $response->assertJsonPath('data.0.type', 'monthly');
    }

    public function test_history_combines_all_data_types_sorted(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();

        // Daily (recent)
        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 5,
            'recorded_at' => now()->subDays(10),
        ]);

        // Weekly (older)
        AppRankingAggregate::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'period_type' => 'weekly',
            'period_start' => now()->subDays(120),
            'avg_position' => 8.5,
            'min_position' => 5,
            'max_position' => 12,
            'data_points' => 7,
        ]);

        // Monthly (oldest)
        AppRankingAggregate::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'period_type' => 'monthly',
            'period_start' => now()->subMonths(14)->startOfMonth(),
            'avg_position' => 15.3,
            'min_position' => 8,
            'max_position' => 25,
            'data_points' => 28,
        ]);

        $response = $this->actingAs($user)
            ->getJson("/api/apps/{$app->id}/rankings/history?keyword_id={$keyword->id}&from=" . now()->subMonths(16)->toDateString());

        $response->assertOk();
        $data = $response->json('data');

        // Should be sorted by date ascending (oldest first)
        $this->assertEquals('monthly', $data[0]['type']);
        $this->assertEquals('weekly', $data[1]['type']);
        $this->assertEquals('daily', $data[2]['type']);
    }
}
