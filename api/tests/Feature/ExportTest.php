<?php

namespace Tests\Feature;

use App\Models\App;
use App\Models\AppRanking;
use App\Models\Keyword;
use App\Models\TrackedKeyword;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ExportTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_export_rankings_csv(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create(['storefront' => 'US']);
        $app->users()->attach($user->id);

        $keyword = Keyword::factory()->create(['keyword' => 'test keyword']);
        TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
        ]);

        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'platform' => 'ios',
            'position' => 5,
            'recorded_at' => now(),
        ]);

        $response = $this->actingAs($user)->getJson("/api/apps/{$app->id}/export/rankings");

        $response->assertOk();
        $response->assertHeader('Content-Type', 'text/csv; charset=UTF-8');
        $this->assertStringContainsString('test keyword', $response->streamedContent());
    }
}
