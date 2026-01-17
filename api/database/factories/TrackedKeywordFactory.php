<?php

namespace Database\Factories;

use App\Models\App;
use App\Models\Keyword;
use App\Models\Team;
use App\Models\TrackedKeyword;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\TrackedKeyword>
 */
class TrackedKeywordFactory extends Factory
{
    protected $model = TrackedKeyword::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'team_id' => Team::factory(),
            'app_id' => App::factory(),
            'keyword_id' => Keyword::factory(),
            'is_favorite' => fake()->boolean(20),
            'favorited_at' => fn(array $attributes) => $attributes['is_favorite'] ? now() : null,
            'created_at' => now(),
            'difficulty' => fake()->optional(0.7)->numberBetween(1, 100),
            'difficulty_label' => fake()->optional(0.7)->randomElement(['Easy', 'Medium', 'Hard', 'Very Hard']),
            'competition' => fake()->optional(0.7)->numberBetween(1, 100),
            'top_competitors' => null,
        ];
    }

    /**
     * Mark as favorite.
     */
    public function favorite(): static
    {
        return $this->state(fn(array $attributes) => [
            'is_favorite' => true,
            'favorited_at' => now(),
        ]);
    }

    /**
     * Set difficulty metrics.
     */
    public function withDifficulty(int $difficulty, string $label): static
    {
        return $this->state(fn(array $attributes) => [
            'difficulty' => $difficulty,
            'difficulty_label' => $label,
        ]);
    }

    /**
     * Set competition data.
     */
    public function withCompetitors(array $competitors): static
    {
        return $this->state(fn(array $attributes) => [
            'top_competitors' => $competitors,
            'competition' => count($competitors) * 10,
        ]);
    }
}
