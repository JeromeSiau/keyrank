<?php

namespace Database\Factories;

use App\Models\App;
use App\Models\AppReview;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\AppReview>
 */
class AppReviewFactory extends Factory
{
    protected $model = AppReview::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'app_id' => App::factory(),
            'country' => fake()->randomElement(['US', 'GB', 'FR', 'DE', 'JP']),
            'review_id' => fake()->unique()->uuid(),
            'author' => fake()->name(),
            'title' => fake()->sentence(4),
            'content' => fake()->paragraph(),
            'rating' => fake()->numberBetween(1, 5),
            'version' => fake()->semver(),
            'reviewed_at' => fake()->dateTimeBetween('-30 days', 'now'),
            'sentiment' => fake()->randomElement(['positive', 'neutral', 'negative', null]),
        ];
    }

    /**
     * Configure review as answered.
     */
    public function answered(): static
    {
        return $this->state(fn(array $attributes) => [
            'our_response' => fake()->paragraph(),
            'responded_at' => fake()->dateTimeBetween($attributes['reviewed_at'] ?? '-30 days', 'now'),
            'store_response_id' => fake()->uuid(),
        ]);
    }

    /**
     * Configure review as unanswered.
     */
    public function unanswered(): static
    {
        return $this->state(fn(array $attributes) => [
            'our_response' => null,
            'responded_at' => null,
            'store_response_id' => null,
        ]);
    }

    /**
     * Configure review as negative (1-2 stars).
     */
    public function negative(): static
    {
        return $this->state(fn(array $attributes) => [
            'rating' => fake()->numberBetween(1, 2),
            'sentiment' => 'negative',
        ]);
    }

    /**
     * Configure review as positive (4-5 stars).
     */
    public function positive(): static
    {
        return $this->state(fn(array $attributes) => [
            'rating' => fake()->numberBetween(4, 5),
            'sentiment' => 'positive',
        ]);
    }

    /**
     * Configure review as neutral (3 stars).
     */
    public function neutral(): static
    {
        return $this->state(fn(array $attributes) => [
            'rating' => 3,
            'sentiment' => 'neutral',
        ]);
    }
}
