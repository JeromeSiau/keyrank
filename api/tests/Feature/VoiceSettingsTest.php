<?php

namespace Tests\Feature;

use App\Models\App;
use App\Models\AppVoiceSetting;
use App\Models\Team;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class VoiceSettingsTest extends TestCase
{
    use RefreshDatabase;

    // ========================================
    // show() tests
    // ========================================

    public function test_show_returns_null_when_no_voice_settings_exist(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);

        $response = $this->actingAs($user)->getJson("/api/apps/{$app->id}/voice-settings");

        $response->assertOk();
        $response->assertJsonPath('data', null);
    }

    public function test_show_returns_voice_settings_for_user(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);

        AppVoiceSetting::create([
            'app_id' => $app->id,
            'user_id' => $user->id,
            'tone_description' => 'Friendly and professional',
            'default_language' => 'en',
            'signature' => '- The Support Team',
        ]);

        $response = $this->actingAs($user)->getJson("/api/apps/{$app->id}/voice-settings");

        $response->assertOk();
        $response->assertJsonPath('data.tone_description', 'Friendly and professional');
        $response->assertJsonPath('data.default_language', 'en');
        $response->assertJsonPath('data.signature', '- The Support Team');
    }

    public function test_show_returns_only_current_users_settings(): void
    {
        $user = $this->createUserWithTeam();
        $otherUser = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);
        $otherUser->currentTeam->apps()->attach($app->id);

        AppVoiceSetting::create([
            'app_id' => $app->id,
            'user_id' => $otherUser->id,
            'tone_description' => 'Other user tone',
            'default_language' => 'fr',
            'signature' => '- Other Team',
        ]);

        $response = $this->actingAs($user)->getJson("/api/apps/{$app->id}/voice-settings");

        $response->assertOk();
        $response->assertJsonPath('data', null);
    }

    public function test_show_requires_authentication(): void
    {
        $app = App::factory()->create();

        $response = $this->getJson("/api/apps/{$app->id}/voice-settings");

        $response->assertUnauthorized();
    }

    public function test_show_fails_when_user_does_not_own_app(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();

        $response = $this->actingAs($user)->getJson("/api/apps/{$app->id}/voice-settings");

        $response->assertForbidden();
        $response->assertJsonPath('message', 'Unauthorized');
    }

    // ========================================
    // update() tests
    // ========================================

    public function test_update_creates_new_voice_settings(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);

        $response = $this->actingAs($user)->putJson("/api/apps/{$app->id}/voice-settings", [
            'tone_description' => 'Casual and friendly',
            'default_language' => 'es',
            'signature' => '- Your App Team',
        ]);

        $response->assertOk();
        $response->assertJsonPath('data.tone_description', 'Casual and friendly');
        $response->assertJsonPath('data.default_language', 'es');
        $response->assertJsonPath('data.signature', '- Your App Team');

        $this->assertDatabaseHas('app_voice_settings', [
            'app_id' => $app->id,
            'user_id' => $user->id,
            'tone_description' => 'Casual and friendly',
            'default_language' => 'es',
            'signature' => '- Your App Team',
        ]);
    }

    public function test_update_modifies_existing_voice_settings(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);

        AppVoiceSetting::create([
            'app_id' => $app->id,
            'user_id' => $user->id,
            'tone_description' => 'Original tone',
            'default_language' => 'en',
            'signature' => '- Original',
        ]);

        $response = $this->actingAs($user)->putJson("/api/apps/{$app->id}/voice-settings", [
            'tone_description' => 'Updated tone',
            'default_language' => 'de',
            'signature' => '- Updated',
        ]);

        $response->assertOk();
        $response->assertJsonPath('data.tone_description', 'Updated tone');
        $response->assertJsonPath('data.default_language', 'de');
        $response->assertJsonPath('data.signature', '- Updated');

        $this->assertDatabaseCount('app_voice_settings', 1);
        $this->assertDatabaseHas('app_voice_settings', [
            'app_id' => $app->id,
            'user_id' => $user->id,
            'tone_description' => 'Updated tone',
            'default_language' => 'de',
            'signature' => '- Updated',
        ]);
    }

    public function test_update_allows_partial_update(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);

        AppVoiceSetting::create([
            'app_id' => $app->id,
            'user_id' => $user->id,
            'tone_description' => 'Original tone',
            'default_language' => 'en',
            'signature' => '- Original',
        ]);

        $response = $this->actingAs($user)->putJson("/api/apps/{$app->id}/voice-settings", [
            'tone_description' => 'New tone only',
        ]);

        $response->assertOk();
        $response->assertJsonPath('data.tone_description', 'New tone only');

        $this->assertDatabaseHas('app_voice_settings', [
            'app_id' => $app->id,
            'user_id' => $user->id,
            'tone_description' => 'New tone only',
        ]);
    }

    public function test_update_allows_empty_request(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);

        // Empty request should create record with defaults
        $response = $this->actingAs($user)->putJson("/api/apps/{$app->id}/voice-settings", []);

        $response->assertOk();
        $response->assertJsonPath('data.tone_description', null);
        $response->assertJsonPath('data.default_language', 'auto'); // Database default
        $response->assertJsonPath('data.signature', null);
    }

    public function test_update_allows_null_for_nullable_fields(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);

        // Create initial settings
        AppVoiceSetting::create([
            'app_id' => $app->id,
            'user_id' => $user->id,
            'tone_description' => 'Initial tone',
            'default_language' => 'en',
            'signature' => 'Initial signature',
        ]);

        // Update with null to clear nullable fields
        $response = $this->actingAs($user)->putJson("/api/apps/{$app->id}/voice-settings", [
            'tone_description' => null,
            'signature' => null,
        ]);

        $response->assertOk();
        $response->assertJsonPath('data.tone_description', null);
        $response->assertJsonPath('data.signature', null);
        // default_language should remain unchanged since we didn't pass it
        $response->assertJsonPath('data.default_language', 'en');
    }

    public function test_update_validates_tone_description_max_length(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);

        $response = $this->actingAs($user)->putJson("/api/apps/{$app->id}/voice-settings", [
            'tone_description' => str_repeat('a', 501),
        ]);

        $response->assertUnprocessable();
        $response->assertJsonValidationErrors(['tone_description']);
    }

    public function test_update_validates_default_language_max_length(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);

        $response = $this->actingAs($user)->putJson("/api/apps/{$app->id}/voice-settings", [
            'default_language' => str_repeat('a', 11),
        ]);

        $response->assertUnprocessable();
        $response->assertJsonValidationErrors(['default_language']);
    }

    public function test_update_validates_signature_max_length(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);

        $response = $this->actingAs($user)->putJson("/api/apps/{$app->id}/voice-settings", [
            'signature' => str_repeat('a', 101),
        ]);

        $response->assertUnprocessable();
        $response->assertJsonValidationErrors(['signature']);
    }

    public function test_update_requires_authentication(): void
    {
        $app = App::factory()->create();

        $response = $this->putJson("/api/apps/{$app->id}/voice-settings", [
            'tone_description' => 'Test tone',
        ]);

        $response->assertUnauthorized();
    }

    public function test_update_fails_when_user_does_not_own_app(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();

        $response = $this->actingAs($user)->putJson("/api/apps/{$app->id}/voice-settings", [
            'tone_description' => 'Test tone',
        ]);

        $response->assertForbidden();
        $response->assertJsonPath('message', 'Unauthorized');
    }

    public function test_update_does_not_affect_other_users_settings(): void
    {
        $user = $this->createUserWithTeam();
        $otherUser = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);
        $otherUser->currentTeam->apps()->attach($app->id);

        AppVoiceSetting::create([
            'app_id' => $app->id,
            'user_id' => $otherUser->id,
            'tone_description' => 'Other user tone',
            'default_language' => 'fr',
            'signature' => '- Other',
        ]);

        $response = $this->actingAs($user)->putJson("/api/apps/{$app->id}/voice-settings", [
            'tone_description' => 'My tone',
            'default_language' => 'en',
            'signature' => '- Me',
        ]);

        $response->assertOk();

        // Verify both settings exist separately
        $this->assertDatabaseCount('app_voice_settings', 2);
        $this->assertDatabaseHas('app_voice_settings', [
            'app_id' => $app->id,
            'user_id' => $user->id,
            'tone_description' => 'My tone',
        ]);
        $this->assertDatabaseHas('app_voice_settings', [
            'app_id' => $app->id,
            'user_id' => $otherUser->id,
            'tone_description' => 'Other user tone',
        ]);
    }

    public function test_show_returns_404_for_nonexistent_app(): void
    {
        $user = $this->createUserWithTeam();

        $response = $this->actingAs($user)->getJson('/api/apps/99999/voice-settings');

        $response->assertNotFound();
    }

    public function test_update_returns_404_for_nonexistent_app(): void
    {
        $user = $this->createUserWithTeam();

        $response = $this->actingAs($user)->putJson('/api/apps/99999/voice-settings', [
            'tone_description' => 'Test',
        ]);

        $response->assertNotFound();
    }
}
