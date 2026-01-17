<?php

namespace Database\Factories;

use App\Models\App;
use App\Models\AppRanking;
use App\Models\Keyword;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\AppRanking>
 */
class AppRankingFactory extends Factory
{
    protected $model = AppRanking::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'app_id' => App::factory(),
            'keyword_id' => Keyword::factory(),
            'position' => fake()->numberBetween(1, 250),
            'recorded_at' => now()->toDateString(),
        ];
    }

    /**
     * Set position in top 10.
     */
    public function topTen(): static
    {
        return $this->state(fn(array $attributes) => [
            'position' => fake()->numberBetween(1, 10),
        ]);
    }

    /**
     * Set position in top 50.
     */
    public function topFifty(): static
    {
        return $this->state(fn(array $attributes) => [
            'position' => fake()->numberBetween(1, 50),
        ]);
    }

    /**
     * Set position outside top 100.
     */
    public function lowRanking(): static
    {
        return $this->state(fn(array $attributes) => [
            'position' => fake()->numberBetween(100, 250),
        ]);
    }

    /**
     * Set a specific date.
     */
    public function forDate(string $date): static
    {
        return $this->state(fn(array $attributes) => [
            'recorded_at' => $date,
        ]);
    }

    /**
     * Create historical ranking data with realistic position changes.
     */
    public function withHistory(int $days = 30, int $basePosition = 50): array
    {
        $rankings = [];
        $position = $basePosition;

        for ($i = $days; $i >= 0; $i--) {
            // Simulate realistic position changes (-5 to +5)
            $change = fake()->numberBetween(-5, 5);
            $position = max(1, min(250, $position + $change));

            $rankings[] = $this->state([
                'position' => $position,
                'recorded_at' => now()->subDays($i)->toDateString(),
            ])->make()->toArray();
        }

        return $rankings;
    }
}
