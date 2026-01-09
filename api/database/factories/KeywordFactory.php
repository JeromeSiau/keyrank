<?php

namespace Database\Factories;

use App\Models\Keyword;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Keyword>
 */
class KeywordFactory extends Factory
{
    protected $model = Keyword::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'keyword' => fake()->unique()->words(fake()->numberBetween(1, 3), true),
            'storefront' => 'US',
            'popularity' => fake()->optional()->numberBetween(1, 100),
            'popularity_updated_at' => fake()->optional()->dateTime(),
            'created_at' => now(),
        ];
    }
}
