<?php

namespace Tests\Feature;

use App\Models\App;
use App\Models\AppReview;
use App\Models\AppVoiceSetting;
use App\Models\StoreConnection;
use App\Models\Team;
use App\Models\User;
use App\Services\AppStoreConnectService;
use App\Services\GooglePlayDeveloperService;
use App\Services\OpenRouterService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Mockery;
use Tests\TestCase;

class ReviewsControllerTest extends TestCase
{
    use RefreshDatabase;

    protected function tearDown(): void
    {
        Mockery::close();
        parent::tearDown();
    }

    // ========================================
    // inbox() tests
    // ========================================

    public function test_inbox_returns_empty_when_user_has_no_apps(): void
    {
        $user = $this->createUserWithTeam();

        $response = $this->actingAs($user)->getJson('/api/reviews/inbox');

        $response->assertOk();
        $response->assertJsonPath('data', []);
        $response->assertJsonPath('meta.total', 0);
    }

    public function test_inbox_returns_reviews_for_all_user_apps(): void
    {
        $user = $this->createUserWithTeam();
        $app1 = App::factory()->ios()->create();
        $app2 = App::factory()->android()->create();
        $user->currentTeam->apps()->attach([$app1->id, $app2->id]);

        AppReview::factory()->create(['app_id' => $app1->id]);
        AppReview::factory()->create(['app_id' => $app2->id]);

        // Create a review for another user's app (should not be included)
        $otherApp = App::factory()->create();
        AppReview::factory()->create(['app_id' => $otherApp->id]);

        $response = $this->actingAs($user)->getJson('/api/reviews/inbox');

        $response->assertOk();
        $response->assertJsonCount(2, 'data');
        $response->assertJsonPath('meta.total', 2);
    }

    public function test_inbox_filters_by_status_unanswered(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);

        AppReview::factory()->unanswered()->create(['app_id' => $app->id]);
        AppReview::factory()->answered()->create(['app_id' => $app->id]);

        $response = $this->actingAs($user)->getJson('/api/reviews/inbox?status=unanswered');

        $response->assertOk();
        $response->assertJsonCount(1, 'data');
        $response->assertJsonPath('data.0.our_response', null);
    }

    public function test_inbox_filters_by_status_answered(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);

        AppReview::factory()->unanswered()->create(['app_id' => $app->id]);
        AppReview::factory()->answered()->create(['app_id' => $app->id]);

        $response = $this->actingAs($user)->getJson('/api/reviews/inbox?status=answered');

        $response->assertOk();
        $response->assertJsonCount(1, 'data');
        $this->assertNotNull($response->json('data.0.our_response'));
    }

    public function test_inbox_filters_by_rating(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);

        AppReview::factory()->create(['app_id' => $app->id, 'rating' => 5]);
        AppReview::factory()->create(['app_id' => $app->id, 'rating' => 1]);

        $response = $this->actingAs($user)->getJson('/api/reviews/inbox?rating=5');

        $response->assertOk();
        $response->assertJsonCount(1, 'data');
        $response->assertJsonPath('data.0.rating', 5);
    }

    public function test_inbox_filters_by_sentiment(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);

        AppReview::factory()->positive()->create(['app_id' => $app->id]);
        AppReview::factory()->negative()->create(['app_id' => $app->id]);

        $response = $this->actingAs($user)->getJson('/api/reviews/inbox?sentiment=negative');

        $response->assertOk();
        $response->assertJsonCount(1, 'data');
        $response->assertJsonPath('data.0.sentiment', 'negative');
    }

    public function test_inbox_filters_by_app_id(): void
    {
        $user = $this->createUserWithTeam();
        $app1 = App::factory()->create();
        $app2 = App::factory()->create();
        $user->currentTeam->apps()->attach([$app1->id, $app2->id]);

        AppReview::factory()->create(['app_id' => $app1->id]);
        AppReview::factory()->create(['app_id' => $app2->id]);

        $response = $this->actingAs($user)->getJson("/api/reviews/inbox?app_id={$app1->id}");

        $response->assertOk();
        $response->assertJsonCount(1, 'data');
        $response->assertJsonPath('data.0.app.id', $app1->id);
    }

    public function test_inbox_filters_by_country(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);

        AppReview::factory()->create(['app_id' => $app->id, 'country' => 'US']);
        AppReview::factory()->create(['app_id' => $app->id, 'country' => 'FR']);

        $response = $this->actingAs($user)->getJson('/api/reviews/inbox?country=US');

        $response->assertOk();
        $response->assertJsonCount(1, 'data');
        $response->assertJsonPath('data.0.country', 'US');
    }

    public function test_inbox_search_works(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);

        AppReview::factory()->create(['app_id' => $app->id, 'content' => 'This app is amazing!']);
        AppReview::factory()->create(['app_id' => $app->id, 'content' => 'Terrible experience']);

        $response = $this->actingAs($user)->getJson('/api/reviews/inbox?search=amazing');

        $response->assertOk();
        $response->assertJsonCount(1, 'data');
        $this->assertStringContainsString('amazing', $response->json('data.0.content'));
    }

    public function test_inbox_paginates_correctly(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);

        AppReview::factory()->count(25)->create(['app_id' => $app->id]);

        $response = $this->actingAs($user)->getJson('/api/reviews/inbox?per_page=10');

        $response->assertOk();
        $response->assertJsonCount(10, 'data');
        $response->assertJsonPath('meta.per_page', 10);
        $response->assertJsonPath('meta.total', 25);
        $response->assertJsonPath('meta.last_page', 3);
    }

    public function test_inbox_returns_correct_structure(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->ios()->create(['name' => 'Test App', 'icon_url' => 'https://example.com/icon.png']);
        $user->currentTeam->apps()->attach($app->id);

        $review = AppReview::factory()->answered()->create([
            'app_id' => $app->id,
            'author' => 'John Doe',
            'title' => 'Great app',
            'content' => 'Love this app!',
            'rating' => 5,
            'country' => 'US',
            'sentiment' => 'positive',
        ]);

        $response = $this->actingAs($user)->getJson('/api/reviews/inbox');

        $response->assertOk();
        $response->assertJsonStructure([
            'data' => [
                '*' => [
                    'id',
                    'app' => ['id', 'name', 'icon_url', 'platform'],
                    'author',
                    'title',
                    'content',
                    'rating',
                    'country',
                    'sentiment',
                    'reviewed_at',
                    'our_response',
                    'responded_at',
                ],
            ],
            'meta' => ['current_page', 'last_page', 'per_page', 'total'],
        ]);
    }

    // ========================================
    // reply() tests
    // ========================================

    public function test_reply_requires_authentication(): void
    {
        $app = App::factory()->create();
        $review = AppReview::factory()->create(['app_id' => $app->id]);

        $response = $this->postJson("/api/apps/{$app->id}/reviews/{$review->id}/reply", [
            'response' => 'Thank you!',
        ]);

        $response->assertUnauthorized();
    }

    public function test_reply_fails_when_user_does_not_own_app(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->ios()->create();
        $review = AppReview::factory()->create(['app_id' => $app->id]);

        $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/reviews/{$review->id}/reply", [
            'response' => 'Thank you!',
        ]);

        // The owns.app middleware handles this check
        $response->assertForbidden();
        $response->assertJsonPath('message', 'Unauthorized');
    }

    public function test_reply_fails_when_review_does_not_belong_to_app(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->ios()->create();
        $otherApp = App::factory()->ios()->create();
        $user->currentTeam->apps()->attach($app->id);
        $review = AppReview::factory()->create(['app_id' => $otherApp->id]);

        $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/reviews/{$review->id}/reply", [
            'response' => 'Thank you!',
        ]);

        $response->assertNotFound();
        $response->assertJsonPath('error', 'Review does not belong to this app.');
    }

    public function test_reply_validates_response_is_required(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->ios()->create();
        $user->currentTeam->apps()->attach($app->id);
        $review = AppReview::factory()->create(['app_id' => $app->id]);

        $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/reviews/{$review->id}/reply", []);

        $response->assertUnprocessable();
        $response->assertJsonValidationErrors(['response']);
    }

    public function test_reply_validates_response_max_length(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->ios()->create();
        $user->currentTeam->apps()->attach($app->id);
        $review = AppReview::factory()->create(['app_id' => $app->id]);

        $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/reviews/{$review->id}/reply", [
            'response' => str_repeat('a', 5971), // Over 5970 chars
        ]);

        $response->assertUnprocessable();
        $response->assertJsonValidationErrors(['response']);
    }

    public function test_reply_fails_without_store_connection(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->ios()->create();
        $user->currentTeam->apps()->attach($app->id);
        $review = AppReview::factory()->create(['app_id' => $app->id]);

        $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/reviews/{$review->id}/reply", [
            'response' => 'Thank you for your feedback!',
        ]);

        $response->assertStatus(422);
        $this->assertStringContainsString('No active ios store connection found', $response->json('error'));
    }

    public function test_reply_sends_to_app_store_connect_for_ios_app(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->ios()->create();
        $user->currentTeam->apps()->attach($app->id);
        StoreConnection::factory()->ios()->create(['user_id' => $user->id, 'status' => 'active']);
        $review = AppReview::factory()->create(['app_id' => $app->id]);

        $this->mock(AppStoreConnectService::class, function ($mock) {
            $mock->shouldReceive('replyToReview')
                ->once()
                ->andReturn(['data' => ['id' => 'response-123']]);
        });

        $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/reviews/{$review->id}/reply", [
            'response' => 'Thank you for your feedback!',
        ]);

        $response->assertOk();
        $response->assertJsonPath('data.our_response', 'Thank you for your feedback!');
        $response->assertJsonPath('data.store_response_id', 'response-123');

        $this->assertDatabaseHas('app_reviews', [
            'id' => $review->id,
            'our_response' => 'Thank you for your feedback!',
            'store_response_id' => 'response-123',
        ]);
    }

    public function test_reply_sends_to_google_play_for_android_app(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->android()->create();
        $user->currentTeam->apps()->attach($app->id);
        StoreConnection::factory()->android()->create(['user_id' => $user->id, 'status' => 'active']);
        $review = AppReview::factory()->create(['app_id' => $app->id]);

        $this->mock(GooglePlayDeveloperService::class, function ($mock) {
            $mock->shouldReceive('replyToReview')
                ->once()
                ->andReturn(['result' => ['replyText' => 'Thank you!']]);
        });

        $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/reviews/{$review->id}/reply", [
            'response' => 'Thank you for your feedback!',
        ]);

        $response->assertOk();
        $response->assertJsonPath('data.our_response', 'Thank you for your feedback!');

        $this->assertDatabaseHas('app_reviews', [
            'id' => $review->id,
            'our_response' => 'Thank you for your feedback!',
        ]);
    }

    public function test_reply_fails_when_store_api_returns_null(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->ios()->create();
        $user->currentTeam->apps()->attach($app->id);
        StoreConnection::factory()->ios()->create(['user_id' => $user->id, 'status' => 'active']);
        $review = AppReview::factory()->create(['app_id' => $app->id]);

        $this->mock(AppStoreConnectService::class, function ($mock) {
            $mock->shouldReceive('replyToReview')
                ->once()
                ->andReturn(null);
        });

        $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/reviews/{$review->id}/reply", [
            'response' => 'Thank you for your feedback!',
        ]);

        $response->assertStatus(500);
        $response->assertJsonPath('error', 'Failed to send reply to the store. Please try again.');
    }

    // ========================================
    // suggestReply() tests
    // ========================================

    public function test_suggest_reply_requires_authentication(): void
    {
        $app = App::factory()->create();
        $review = AppReview::factory()->create(['app_id' => $app->id]);

        $response = $this->postJson("/api/apps/{$app->id}/reviews/{$review->id}/suggest");

        $response->assertUnauthorized();
    }

    public function test_suggest_reply_fails_when_user_does_not_own_app(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $review = AppReview::factory()->create(['app_id' => $app->id]);

        $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/reviews/{$review->id}/suggest");

        // The owns.app middleware handles this check
        $response->assertForbidden();
        $response->assertJsonPath('message', 'Unauthorized');
    }

    public function test_suggest_reply_fails_when_review_does_not_belong_to_app(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $otherApp = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);
        $review = AppReview::factory()->create(['app_id' => $otherApp->id]);

        $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/reviews/{$review->id}/suggest");

        $response->assertNotFound();
        $response->assertJsonPath('error', 'Review does not belong to this app.');
    }

    public function test_suggest_reply_returns_ai_suggestion(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);
        $review = AppReview::factory()->create(['app_id' => $app->id]);

        $this->mock(OpenRouterService::class, function ($mock) {
            $mock->shouldReceive('chat')
                ->once()
                ->andReturn(['reply' => 'Thank you for your wonderful feedback!']);
        });

        $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/reviews/{$review->id}/suggest");

        $response->assertOk();
        $response->assertJsonPath('data.suggestion', 'Thank you for your wonderful feedback!');
    }

    public function test_suggest_reply_uses_voice_settings(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);
        $review = AppReview::factory()->create(['app_id' => $app->id]);

        AppVoiceSetting::create([
            'app_id' => $app->id,
            'user_id' => $user->id,
            'tone_description' => 'Friendly and casual',
            'signature' => '- The Team',
        ]);

        $this->mock(OpenRouterService::class, function ($mock) {
            $mock->shouldReceive('chat')
                ->once()
                ->withArgs(function ($systemPrompt, $userPrompt, $jsonMode) {
                    return str_contains($systemPrompt, 'Friendly and casual');
                })
                ->andReturn(['reply' => 'Hey there! Thanks for the awesome review!']);
        });

        $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/reviews/{$review->id}/suggest");

        $response->assertOk();
        $this->assertStringContainsString('- The Team', $response->json('data.suggestion'));
    }

    public function test_suggest_reply_fails_when_openrouter_returns_null(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);
        $review = AppReview::factory()->create(['app_id' => $app->id]);

        $this->mock(OpenRouterService::class, function ($mock) {
            $mock->shouldReceive('chat')
                ->once()
                ->andReturn(null);
        });

        $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/reviews/{$review->id}/suggest");

        $response->assertStatus(500);
        $response->assertJsonPath('error', 'Failed to generate suggestion. Please try again.');
    }

    public function test_suggest_reply_fails_when_ai_response_has_no_reply(): void
    {
        $user = $this->createUserWithTeam();
        $app = App::factory()->create();
        $user->currentTeam->apps()->attach($app->id);
        $review = AppReview::factory()->create(['app_id' => $app->id]);

        $this->mock(OpenRouterService::class, function ($mock) {
            $mock->shouldReceive('chat')
                ->once()
                ->andReturn(['some_other_field' => 'value']);
        });

        $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/reviews/{$review->id}/suggest");

        $response->assertStatus(500);
        $response->assertJsonPath('error', 'Failed to parse AI response. Please try again.');
    }

    public function test_unauthenticated_user_cannot_access_inbox(): void
    {
        $response = $this->getJson('/api/reviews/inbox');

        $response->assertUnauthorized();
    }
}
