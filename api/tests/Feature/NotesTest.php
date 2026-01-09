<?php

namespace Tests\Feature;

use App\Models\App;
use App\Models\AppInsight;
use App\Models\Keyword;
use App\Models\Note;
use App\Models\TrackedKeyword;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class NotesTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_create_note_for_keyword(): void
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

        $response = $this->actingAs($user)->postJson('/api/notes', [
            'tracked_keyword_id' => $tracked->id,
            'content' => 'This keyword performs well in Q1',
        ]);

        $response->assertCreated();
        $this->assertDatabaseHas('notes', [
            'user_id' => $user->id,
            'tracked_keyword_id' => $tracked->id,
            'content' => 'This keyword performs well in Q1',
        ]);
    }

    public function test_user_can_update_existing_note(): void
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

        // Create initial note
        $this->actingAs($user)->postJson('/api/notes', [
            'tracked_keyword_id' => $tracked->id,
            'content' => 'Initial note',
        ]);

        // Update note
        $response = $this->actingAs($user)->postJson('/api/notes', [
            'tracked_keyword_id' => $tracked->id,
            'content' => 'Updated note',
        ]);

        $response->assertOk();
        $this->assertDatabaseCount('notes', 1);
        $this->assertDatabaseHas('notes', [
            'tracked_keyword_id' => $tracked->id,
            'content' => 'Updated note',
        ]);
    }

    public function test_user_can_get_note_for_keyword(): void
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

        Note::create([
            'user_id' => $user->id,
            'tracked_keyword_id' => $tracked->id,
            'content' => 'My note',
        ]);

        $response = $this->actingAs($user)->getJson("/api/notes/keyword?tracked_keyword_id={$tracked->id}");

        $response->assertOk();
        $response->assertJsonPath('data.content', 'My note');
    }

    public function test_user_can_delete_note(): void
    {
        $user = User::factory()->create();
        $note = Note::create([
            'user_id' => $user->id,
            'content' => 'To delete',
        ]);

        $response = $this->actingAs($user)->deleteJson("/api/notes/{$note->id}");

        $response->assertNoContent();
        $this->assertDatabaseMissing('notes', ['id' => $note->id]);
    }

    public function test_user_cannot_delete_another_users_note(): void
    {
        $user = User::factory()->create();
        $otherUser = User::factory()->create();
        $note = Note::create([
            'user_id' => $otherUser->id,
            'content' => 'Other user note',
        ]);

        $response = $this->actingAs($user)->deleteJson("/api/notes/{$note->id}");

        $response->assertForbidden();
    }
}
