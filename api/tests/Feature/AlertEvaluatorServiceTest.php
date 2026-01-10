<?php

namespace Tests\Feature;

use App\Models\AlertRule;
use App\Models\App;
use App\Models\AppRanking;
use App\Models\Keyword;
use App\Models\TrackedKeyword;
use App\Models\User;
use App\Services\AlertEvaluatorService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AlertEvaluatorServiceTest extends TestCase
{
    use RefreshDatabase;

    private AlertEvaluatorService $service;

    protected function setUp(): void
    {
        parent::setUp();
        $this->service = new AlertEvaluatorService();
    }

    public function test_detects_position_drop_exceeding_threshold(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();
        TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
        ]);

        // Create ranking history: was #10 yesterday, now #25 (dropped 15)
        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 10,
            'recorded_at' => now()->subDay(),
        ]);
        $currentRanking = AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 25,
            'recorded_at' => now(),
        ]);

        // Create rule: alert if drops >= 10 positions
        AlertRule::factory()->create([
            'user_id' => $user->id,
            'type' => AlertRule::TYPE_POSITION_CHANGE,
            'conditions' => ['direction' => 'down', 'threshold' => 10],
        ]);

        $alerts = $this->service->evaluatePositionChange($currentRanking);

        $this->assertCount(1, $alerts);
        $this->assertEquals('position_change', $alerts->first()['type']);
    }

    public function test_does_not_alert_when_below_threshold(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();
        TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
        ]);

        // Create ranking history: was #10 yesterday, now #15 (dropped 5)
        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 10,
            'recorded_at' => now()->subDay(),
        ]);
        $currentRanking = AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 15,
            'recorded_at' => now(),
        ]);

        // Create rule: alert if drops >= 10 positions
        AlertRule::factory()->create([
            'user_id' => $user->id,
            'type' => AlertRule::TYPE_POSITION_CHANGE,
            'conditions' => ['direction' => 'down', 'threshold' => 10],
        ]);

        $alerts = $this->service->evaluatePositionChange($currentRanking);

        $this->assertCount(0, $alerts);
    }

    public function test_respects_app_specific_rule_over_global(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();
        TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
        ]);

        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 10,
            'recorded_at' => now()->subDay(),
        ]);
        $currentRanking = AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 15,
            'recorded_at' => now(),
        ]);

        // Global rule: threshold 10 (would NOT alert)
        AlertRule::factory()->create([
            'user_id' => $user->id,
            'type' => AlertRule::TYPE_POSITION_CHANGE,
            'scope_type' => AlertRule::SCOPE_GLOBAL,
            'conditions' => ['direction' => 'down', 'threshold' => 10],
            'priority' => 0,
        ]);

        // App-specific rule: threshold 3 (WOULD alert)
        AlertRule::factory()->create([
            'user_id' => $user->id,
            'type' => AlertRule::TYPE_POSITION_CHANGE,
            'scope_type' => AlertRule::SCOPE_APP,
            'scope_id' => $app->id,
            'conditions' => ['direction' => 'down', 'threshold' => 3],
            'priority' => 10,
        ]);

        $alerts = $this->service->evaluatePositionChange($currentRanking);

        $this->assertCount(1, $alerts);
    }

    public function test_detects_entered_top_n(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();
        TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
        ]);

        // Was #15, now #8 (entered top 10)
        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 15,
            'recorded_at' => now()->subDay(),
        ]);
        $currentRanking = AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 8,
            'recorded_at' => now(),
        ]);

        AlertRule::factory()->create([
            'user_id' => $user->id,
            'type' => AlertRule::TYPE_POSITION_CHANGE,
            'conditions' => ['entered_top' => 10],
        ]);

        $alerts = $this->service->evaluatePositionChange($currentRanking);

        $this->assertCount(1, $alerts);
    }
}
