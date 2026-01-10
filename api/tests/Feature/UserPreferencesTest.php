<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class UserPreferencesTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_update_fcm_token(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)->putJson('/api/user/fcm-token', [
            'fcm_token' => 'test-fcm-token-123',
        ]);

        $response->assertOk();
        $this->assertEquals('test-fcm-token-123', $user->fresh()->fcm_token);
    }

    public function test_fcm_token_is_required(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)->putJson('/api/user/fcm-token', []);

        $response->assertStatus(422);
        $response->assertJsonValidationErrors(['fcm_token']);
    }

    public function test_user_can_update_alert_settings(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)->putJson('/api/user/preferences', [
            'timezone' => 'Europe/Paris',
            'quiet_hours_start' => '23:00:00',
            'quiet_hours_end' => '07:00:00',
        ]);

        $response->assertOk();
        $this->assertEquals('Europe/Paris', $user->fresh()->timezone);
        $this->assertEquals('23:00:00', $user->fresh()->quiet_hours_start->format('H:i:s'));
        $this->assertEquals('07:00:00', $user->fresh()->quiet_hours_end->format('H:i:s'));
    }

    public function test_user_can_update_locale(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)->putJson('/api/user/preferences', [
            'locale' => 'fr',
        ]);

        $response->assertOk();
        $this->assertEquals('fr', $user->fresh()->locale);
    }

    public function test_user_can_get_preferences(): void
    {
        $user = User::factory()->create([
            'locale' => 'de',
            'timezone' => 'America/New_York',
            'quiet_hours_start' => '22:00:00',
            'quiet_hours_end' => '08:00:00',
        ]);

        $response = $this->actingAs($user)->getJson('/api/user/preferences');

        $response->assertOk();
        $response->assertJsonPath('data.locale', 'de');
        $response->assertJsonPath('data.timezone', 'America/New_York');
        $response->assertJsonPath('data.quiet_hours_start', '22:00:00');
        $response->assertJsonPath('data.quiet_hours_end', '08:00:00');
    }

    public function test_timezone_must_be_valid(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)->putJson('/api/user/preferences', [
            'timezone' => 'Invalid/Timezone',
        ]);

        $response->assertStatus(422);
        $response->assertJsonValidationErrors(['timezone']);
    }

    public function test_unauthenticated_user_cannot_update_fcm_token(): void
    {
        $response = $this->putJson('/api/user/fcm-token', [
            'fcm_token' => 'test-fcm-token-123',
        ]);

        $response->assertUnauthorized();
    }

    public function test_unauthenticated_user_cannot_update_preferences(): void
    {
        $response = $this->putJson('/api/user/preferences', [
            'timezone' => 'Europe/Paris',
        ]);

        $response->assertUnauthorized();
    }
}
