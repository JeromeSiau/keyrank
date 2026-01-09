<?php

namespace Tests\Feature;

use App\Models\Tag;
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
    }
}
