<?php

namespace Tests\Feature;

use App\Models\App;
use App\Models\Keyword;
use App\Models\Tag;
use App\Models\TrackedKeyword;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class TagsTest extends TestCase
{
    use RefreshDatabase;

    public function test_tag_belongs_to_user(): void
    {
        $user = User::factory()->create();

        $tag = Tag::create([
            'user_id' => $user->id,
            'name' => 'Important',
            'color' => '#ef4444',
        ]);

        $this->assertEquals($user->id, $tag->user_id);
        $this->assertEquals('Important', $tag->name);
        $this->assertEquals('#ef4444', $tag->color);

        // Verify Eloquent relationship
        $this->assertInstanceOf(User::class, $tag->user);
        $this->assertTrue($tag->user->is($user));
    }

    public function test_tag_can_be_attached_to_tracked_keyword(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();

        $tracked = TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
        ]);

        $tag = Tag::create([
            'user_id' => $user->id,
            'name' => 'Important',
            'color' => '#ef4444',
        ]);

        $tracked->tags()->attach($tag->id);

        $this->assertCount(1, $tracked->tags);
        $this->assertEquals('Important', $tracked->tags->first()->name);
    }

    public function test_user_can_list_their_tags(): void
    {
        $user = User::factory()->create();
        Tag::factory()->count(3)->create(['user_id' => $user->id]);
        Tag::factory()->create(); // Another user's tag

        $response = $this->actingAs($user)->getJson('/api/tags');

        $response->assertOk();
        $response->assertJsonCount(3, 'data');
    }

    public function test_user_can_create_tag(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)->postJson('/api/tags', [
            'name' => 'High Priority',
            'color' => '#ef4444',
        ]);

        $response->assertCreated();
        $response->assertJsonPath('data.name', 'High Priority');
        $this->assertDatabaseHas('tags', [
            'user_id' => $user->id,
            'name' => 'High Priority',
        ]);
    }

    public function test_user_cannot_create_duplicate_tag_name(): void
    {
        $user = User::factory()->create();
        Tag::create(['user_id' => $user->id, 'name' => 'Important', 'color' => '#000']);

        $response = $this->actingAs($user)->postJson('/api/tags', [
            'name' => 'Important',
            'color' => '#ef4444',
        ]);

        $response->assertStatus(422);
    }

    public function test_user_can_delete_their_tag(): void
    {
        $user = User::factory()->create();
        $tag = Tag::create(['user_id' => $user->id, 'name' => 'ToDelete', 'color' => '#000']);

        $response = $this->actingAs($user)->deleteJson("/api/tags/{$tag->id}");

        $response->assertNoContent();
        $this->assertDatabaseMissing('tags', ['id' => $tag->id]);
    }

    public function test_user_cannot_delete_another_users_tag(): void
    {
        $user = User::factory()->create();
        $otherUser = User::factory()->create();
        $tag = Tag::create(['user_id' => $otherUser->id, 'name' => 'OtherTag', 'color' => '#000']);

        $response = $this->actingAs($user)->deleteJson("/api/tags/{$tag->id}");

        $response->assertForbidden();
        $this->assertDatabaseHas('tags', ['id' => $tag->id]);
    }

    public function test_user_can_add_tag_to_keyword(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();
        $tracked = TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
        ]);
        $tag = Tag::create(['user_id' => $user->id, 'name' => 'Test', 'color' => '#000']);

        $response = $this->actingAs($user)->postJson('/api/tags/add-to-keyword', [
            'tag_id' => $tag->id,
            'tracked_keyword_id' => $tracked->id,
        ]);

        $response->assertOk();
        $this->assertTrue($tracked->tags->contains($tag));
    }

    public function test_user_can_remove_tag_from_keyword(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();
        $tracked = TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
        ]);
        $tag = Tag::create(['user_id' => $user->id, 'name' => 'Test', 'color' => '#000']);
        $tracked->tags()->attach($tag->id);

        $response = $this->actingAs($user)->postJson('/api/tags/remove-from-keyword', [
            'tag_id' => $tag->id,
            'tracked_keyword_id' => $tracked->id,
        ]);

        $response->assertOk();
        $this->assertFalse($tracked->fresh()->tags->contains($tag));
    }
}
