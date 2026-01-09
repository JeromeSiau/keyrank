<?php

namespace Tests\Feature;

use App\Models\App;
use App\Models\Keyword;
use App\Models\Tag;
use App\Models\TrackedKeyword;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class BulkActionsTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_bulk_delete_keywords(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);

        $keywords = Keyword::factory()->count(5)->create();
        $trackedIds = [];

        foreach ($keywords as $keyword) {
            $tracked = TrackedKeyword::create([
                'user_id' => $user->id,
                'app_id' => $app->id,
                'keyword_id' => $keyword->id,
            ]);
            $trackedIds[] = $tracked->id;
        }

        $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/keywords/bulk-delete", [
            'tracked_keyword_ids' => array_slice($trackedIds, 0, 3),
        ]);

        $response->assertOk();
        $response->assertJsonPath('data.deleted_count', 3);
        $this->assertDatabaseCount('tracked_keywords', 2);
    }

    public function test_user_can_bulk_add_tags_to_keywords(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);

        $tag = Tag::create(['user_id' => $user->id, 'name' => 'Priority', 'color' => '#ef4444']);

        $keywords = Keyword::factory()->count(3)->create();
        $trackedIds = [];

        foreach ($keywords as $keyword) {
            $tracked = TrackedKeyword::create([
                'user_id' => $user->id,
                'app_id' => $app->id,
                'keyword_id' => $keyword->id,
            ]);
            $trackedIds[] = $tracked->id;
        }

        $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/keywords/bulk-add-tags", [
            'tracked_keyword_ids' => $trackedIds,
            'tag_ids' => [$tag->id],
        ]);

        $response->assertOk();
        $response->assertJsonPath('data.updated_count', 3);

        foreach ($trackedIds as $id) {
            $this->assertTrue(TrackedKeyword::find($id)->tags->contains($tag));
        }
    }

    public function test_user_can_bulk_toggle_favorites(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);

        $keywords = Keyword::factory()->count(3)->create();
        $trackedIds = [];

        foreach ($keywords as $keyword) {
            $tracked = TrackedKeyword::create([
                'user_id' => $user->id,
                'app_id' => $app->id,
                'keyword_id' => $keyword->id,
                'is_favorite' => false,
            ]);
            $trackedIds[] = $tracked->id;
        }

        $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/keywords/bulk-favorite", [
            'tracked_keyword_ids' => $trackedIds,
            'is_favorite' => true,
        ]);

        $response->assertOk();
        $response->assertJsonPath('data.updated_count', 3);

        foreach ($trackedIds as $id) {
            $this->assertTrue(TrackedKeyword::find($id)->is_favorite);
        }
    }
}
