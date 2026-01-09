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
}
