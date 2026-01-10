<?php

namespace Tests\Feature;

use App\Models\AlertRule;
use App\Models\App;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AlertRulesTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_list_their_alert_rules(): void
    {
        $user = User::factory()->create();
        AlertRule::factory()->count(3)->create(['user_id' => $user->id]);
        AlertRule::factory()->create(); // Another user's rule

        $response = $this->actingAs($user)->getJson('/api/alerts/rules');

        $response->assertOk();
        $response->assertJsonCount(3, 'data');
    }

    public function test_user_can_create_alert_rule(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)->postJson('/api/alerts/rules', [
            'name' => 'Position drop alert',
            'type' => 'position_change',
            'scope_type' => 'global',
            'conditions' => ['direction' => 'down', 'threshold' => 10],
        ]);

        $response->assertCreated();
        $response->assertJsonPath('data.name', 'Position drop alert');
        $this->assertDatabaseHas('alert_rules', [
            'user_id' => $user->id,
            'name' => 'Position drop alert',
        ]);
    }

    public function test_user_can_create_app_scoped_rule(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);

        $response = $this->actingAs($user)->postJson('/api/alerts/rules', [
            'name' => 'My app alert',
            'type' => 'position_change',
            'scope_type' => 'app',
            'scope_id' => $app->id,
            'conditions' => ['direction' => 'any', 'threshold' => 1],
        ]);

        $response->assertCreated();
        $response->assertJsonPath('data.scope_type', 'app');
        $response->assertJsonPath('data.scope_id', $app->id);
    }

    public function test_user_can_update_their_rule(): void
    {
        $user = User::factory()->create();
        $rule = AlertRule::factory()->create(['user_id' => $user->id, 'name' => 'Old name']);

        $response = $this->actingAs($user)->putJson("/api/alerts/rules/{$rule->id}", [
            'name' => 'New name',
            'conditions' => ['direction' => 'up', 'threshold' => 5],
        ]);

        $response->assertOk();
        $response->assertJsonPath('data.name', 'New name');
    }

    public function test_user_cannot_update_another_users_rule(): void
    {
        $user = User::factory()->create();
        $otherUser = User::factory()->create();
        $rule = AlertRule::factory()->create(['user_id' => $otherUser->id]);

        $response = $this->actingAs($user)->putJson("/api/alerts/rules/{$rule->id}", [
            'name' => 'Hacked',
        ]);

        $response->assertForbidden();
    }

    public function test_user_can_delete_their_rule(): void
    {
        $user = User::factory()->create();
        $rule = AlertRule::factory()->create(['user_id' => $user->id]);

        $response = $this->actingAs($user)->deleteJson("/api/alerts/rules/{$rule->id}");

        $response->assertNoContent();
        $this->assertDatabaseMissing('alert_rules', ['id' => $rule->id]);
    }

    public function test_user_can_toggle_rule_active_status(): void
    {
        $user = User::factory()->create();
        $rule = AlertRule::factory()->create(['user_id' => $user->id, 'is_active' => true]);

        $response = $this->actingAs($user)->patchJson("/api/alerts/rules/{$rule->id}/toggle");

        $response->assertOk();
        $response->assertJsonPath('data.is_active', false);
    }

    public function test_list_templates_returns_preset_rules(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)->getJson('/api/alerts/templates');

        $response->assertOk();
        $response->assertJsonStructure(['data' => [['name', 'type', 'conditions']]]);
    }
}
