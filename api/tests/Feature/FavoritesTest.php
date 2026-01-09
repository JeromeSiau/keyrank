<?php

namespace Tests\Feature;

use App\Models\App;
use App\Models\Keyword;
use App\Models\TrackedKeyword;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FavoritesTest extends TestCase
{
    use RefreshDatabase;

    public function test_tracked_keyword_has_favorite_columns(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();

        $tracked = TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'is_favorite' => true,
            'favorited_at' => now(),
        ]);

        $this->assertTrue($tracked->is_favorite);
        $this->assertNotNull($tracked->favorited_at);
    }
}
