<?php

namespace Database\Factories;

use App\Models\App;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\App>
 */
class AppFactory extends Factory
{
    protected $model = App::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'platform' => fake()->randomElement(['ios', 'android']),
            'store_id' => fake()->unique()->numerify('##########'),
            'bundle_id' => fake()->unique()->domainWord() . '.' . fake()->domainWord() . '.' . fake()->domainWord(),
            'name' => fake()->words(3, true),
            'icon_url' => fake()->imageUrl(100, 100),
            'developer' => fake()->company(),
            'rating' => fake()->randomFloat(1, 1, 5),
            'rating_count' => fake()->numberBetween(0, 100000),
            'storefront' => 'US',
        ];
    }

    /**
     * Configure for iOS platform.
     */
    public function ios(): static
    {
        return $this->state(fn(array $attributes) => [
            'platform' => 'ios',
        ]);
    }

    /**
     * Configure for Android platform.
     */
    public function android(): static
    {
        return $this->state(fn(array $attributes) => [
            'platform' => 'android',
        ]);
    }
}
