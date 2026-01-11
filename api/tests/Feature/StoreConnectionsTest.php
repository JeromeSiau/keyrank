<?php

namespace Tests\Feature;

use App\Models\StoreConnection;
use App\Models\User;
use App\Services\AppStoreConnectService;
use App\Services\GooglePlayDeveloperService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Mockery;
use Tests\TestCase;

class StoreConnectionsTest extends TestCase
{
    use RefreshDatabase;

    protected function tearDown(): void
    {
        Mockery::close();
        parent::tearDown();
    }

    public function test_user_can_list_their_store_connections(): void
    {
        $user = User::factory()->create();
        StoreConnection::factory()->ios()->create(['user_id' => $user->id]);
        StoreConnection::factory()->android()->create(['user_id' => $user->id]);
        StoreConnection::factory()->create(); // Another user's connection

        $response = $this->actingAs($user)->getJson('/api/store-connections');

        $response->assertOk();
        $response->assertJsonCount(2, 'data');
    }

    public function test_user_can_create_ios_connection(): void
    {
        $user = User::factory()->create();

        $this->mock(AppStoreConnectService::class, function ($mock) {
            $mock->shouldReceive('validateCredentials')->once()->andReturn(true);
        });

        $response = $this->actingAs($user)->postJson('/api/store-connections', [
            'platform' => 'ios',
            'name' => 'My iOS Connection',
            'key_id' => 'ABC1234567',
            'issuer_id' => '12345678-1234-1234-1234-123456789012',
            'private_key' => "-----BEGIN PRIVATE KEY-----\nTEST_KEY\n-----END PRIVATE KEY-----",
        ]);

        $response->assertCreated();
        $response->assertJsonPath('data.platform', 'ios');
        $response->assertJsonPath('data.status', 'active');
        $this->assertDatabaseHas('store_connections', [
            'user_id' => $user->id,
            'platform' => 'ios',
        ]);
    }

    public function test_user_can_create_android_connection(): void
    {
        $user = User::factory()->create();

        $this->mock(GooglePlayDeveloperService::class, function ($mock) {
            $mock->shouldReceive('validateCredentials')->once()->andReturn(true);
        });

        $response = $this->actingAs($user)->postJson('/api/store-connections', [
            'platform' => 'android',
            'name' => 'My Android Connection',
            'client_id' => '123456789012.apps.googleusercontent.com',
            'client_secret' => 'GOCSPX-test-secret',
            'refresh_token' => 'test-refresh-token',
        ]);

        $response->assertCreated();
        $response->assertJsonPath('data.platform', 'android');
        $this->assertDatabaseHas('store_connections', [
            'user_id' => $user->id,
            'platform' => 'android',
        ]);
    }

    public function test_create_connection_fails_with_invalid_ios_credentials(): void
    {
        $user = User::factory()->create();

        $this->mock(AppStoreConnectService::class, function ($mock) {
            $mock->shouldReceive('validateCredentials')->once()->andReturn(false);
        });

        $response = $this->actingAs($user)->postJson('/api/store-connections', [
            'platform' => 'ios',
            'name' => 'My iOS Connection',
            'key_id' => 'ABC1234567',
            'issuer_id' => '12345678-1234-1234-1234-123456789012',
            'private_key' => "-----BEGIN PRIVATE KEY-----\nINVALID_KEY\n-----END PRIVATE KEY-----",
        ]);

        $response->assertStatus(422);
        $response->assertJsonPath('message', 'Invalid credentials. Please verify your App Store Connect API key.');
    }

    public function test_create_connection_fails_with_invalid_android_credentials(): void
    {
        $user = User::factory()->create();

        $this->mock(GooglePlayDeveloperService::class, function ($mock) {
            $mock->shouldReceive('validateCredentials')->once()->andReturn(false);
        });

        $response = $this->actingAs($user)->postJson('/api/store-connections', [
            'platform' => 'android',
            'name' => 'My Android Connection',
            'client_id' => '123456789012.apps.googleusercontent.com',
            'client_secret' => 'invalid-secret',
            'refresh_token' => 'invalid-token',
        ]);

        $response->assertStatus(422);
        $response->assertJsonPath('message', 'Invalid credentials. Please verify your Google Play Console OAuth credentials.');
    }

    public function test_ios_connection_requires_ios_credentials(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)->postJson('/api/store-connections', [
            'platform' => 'ios',
            'name' => 'My iOS Connection',
            // Missing key_id, issuer_id, private_key
        ]);

        $response->assertStatus(422);
        $response->assertJsonValidationErrors(['key_id', 'issuer_id', 'private_key']);
    }

    public function test_android_connection_requires_android_credentials(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)->postJson('/api/store-connections', [
            'platform' => 'android',
            'name' => 'My Android Connection',
            // Missing client_id, client_secret, refresh_token
        ]);

        $response->assertStatus(422);
        $response->assertJsonValidationErrors(['client_id', 'client_secret', 'refresh_token']);
    }

    public function test_user_can_view_their_connection(): void
    {
        $user = User::factory()->create();
        $connection = StoreConnection::factory()->ios()->create(['user_id' => $user->id]);

        $response = $this->actingAs($user)->getJson("/api/store-connections/{$connection->id}");

        $response->assertOk();
        $response->assertJsonPath('data.id', $connection->id);
        $response->assertJsonPath('data.platform', 'ios');
    }

    public function test_user_cannot_view_another_users_connection(): void
    {
        $user = User::factory()->create();
        $otherUser = User::factory()->create();
        $connection = StoreConnection::factory()->create(['user_id' => $otherUser->id]);

        $response = $this->actingAs($user)->getJson("/api/store-connections/{$connection->id}");

        $response->assertForbidden();
    }

    public function test_user_can_update_their_connection(): void
    {
        $user = User::factory()->create();
        $connection = StoreConnection::factory()->ios()->create(['user_id' => $user->id]);

        $this->mock(AppStoreConnectService::class, function ($mock) {
            $mock->shouldReceive('validateCredentials')->once()->andReturn(true);
        });

        $response = $this->actingAs($user)->patchJson("/api/store-connections/{$connection->id}", [
            'name' => 'Updated Connection Name',
            'key_id' => 'NEW1234567',
            'issuer_id' => '98765432-1234-1234-1234-123456789012',
            'private_key' => "-----BEGIN PRIVATE KEY-----\nNEW_KEY\n-----END PRIVATE KEY-----",
        ]);

        $response->assertOk();
        $this->assertDatabaseHas('store_connections', [
            'id' => $connection->id,
        ]);
        // Verify credentials were updated by checking the name in decrypted credentials
        $connection->refresh();
        $this->assertEquals('Updated Connection Name', $connection->credentials['name']);
    }

    public function test_user_cannot_update_another_users_connection(): void
    {
        $user = User::factory()->create();
        $otherUser = User::factory()->create();
        $connection = StoreConnection::factory()->create(['user_id' => $otherUser->id]);

        $response = $this->actingAs($user)->patchJson("/api/store-connections/{$connection->id}", [
            'name' => 'Hacked',
        ]);

        $response->assertForbidden();
    }

    public function test_user_can_delete_their_connection(): void
    {
        $user = User::factory()->create();
        $connection = StoreConnection::factory()->create(['user_id' => $user->id]);

        $response = $this->actingAs($user)->deleteJson("/api/store-connections/{$connection->id}");

        $response->assertNoContent();
        $this->assertDatabaseMissing('store_connections', ['id' => $connection->id]);
    }

    public function test_user_cannot_delete_another_users_connection(): void
    {
        $user = User::factory()->create();
        $otherUser = User::factory()->create();
        $connection = StoreConnection::factory()->create(['user_id' => $otherUser->id]);

        $response = $this->actingAs($user)->deleteJson("/api/store-connections/{$connection->id}");

        $response->assertForbidden();
        $this->assertDatabaseHas('store_connections', ['id' => $connection->id]);
    }

    public function test_user_can_validate_ios_connection(): void
    {
        $user = User::factory()->create();
        $connection = StoreConnection::factory()->ios()->create(['user_id' => $user->id]);

        $this->mock(AppStoreConnectService::class, function ($mock) {
            $mock->shouldReceive('validateCredentials')->once()->andReturn(true);
        });

        $response = $this->actingAs($user)->postJson("/api/store-connections/{$connection->id}/validate");

        $response->assertOk();
        $response->assertJsonPath('valid', true);
    }

    public function test_user_can_validate_android_connection(): void
    {
        $user = User::factory()->create();
        $connection = StoreConnection::factory()->android()->create(['user_id' => $user->id]);

        $this->mock(GooglePlayDeveloperService::class, function ($mock) {
            $mock->shouldReceive('validateCredentials')->once()->andReturn(true);
        });

        $response = $this->actingAs($user)->postJson("/api/store-connections/{$connection->id}/validate");

        $response->assertOk();
        $response->assertJsonPath('valid', true);
    }

    public function test_validate_returns_false_for_invalid_credentials(): void
    {
        $user = User::factory()->create();
        $connection = StoreConnection::factory()->ios()->create(['user_id' => $user->id]);

        $this->mock(AppStoreConnectService::class, function ($mock) {
            $mock->shouldReceive('validateCredentials')->once()->andReturn(false);
        });

        $response = $this->actingAs($user)->postJson("/api/store-connections/{$connection->id}/validate");

        $response->assertOk();
        $response->assertJsonPath('valid', false);
    }

    public function test_user_cannot_validate_another_users_connection(): void
    {
        $user = User::factory()->create();
        $otherUser = User::factory()->create();
        $connection = StoreConnection::factory()->create(['user_id' => $otherUser->id]);

        $response = $this->actingAs($user)->postJson("/api/store-connections/{$connection->id}/validate");

        $response->assertForbidden();
    }

    public function test_user_cannot_create_duplicate_platform_connection(): void
    {
        $user = User::factory()->create();
        StoreConnection::factory()->ios()->create(['user_id' => $user->id]);

        $this->mock(AppStoreConnectService::class, function ($mock) {
            $mock->shouldReceive('validateCredentials')->never();
        });

        $response = $this->actingAs($user)->postJson('/api/store-connections', [
            'platform' => 'ios',
            'name' => 'Another iOS Connection',
            'key_id' => 'ABC1234567',
            'issuer_id' => '12345678-1234-1234-1234-123456789012',
            'private_key' => "-----BEGIN PRIVATE KEY-----\nTEST_KEY\n-----END PRIVATE KEY-----",
        ]);

        $response->assertStatus(422);
        $response->assertJsonValidationErrors(['platform']);
    }

    public function test_unauthenticated_user_cannot_access_connections(): void
    {
        $response = $this->getJson('/api/store-connections');

        $response->assertUnauthorized();
    }
}
