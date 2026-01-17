<?php

namespace Database\Factories;

use App\Models\Team;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Team>
 */
class TeamFactory extends Factory
{
    protected $model = Team::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $name = fake()->company();

        return [
            'name' => $name,
            'slug' => Str::slug($name) . '-' . Str::random(6),
            'description' => fake()->optional()->sentence(),
        ];
    }

    /**
     * Configure the team with an owner.
     */
    public function withOwner(?User $owner = null): static
    {
        return $this->state(function (array $attributes) use ($owner) {
            $owner = $owner ?? User::factory()->create();

            return [
                'owner_id' => $owner->id,
            ];
        })->afterCreating(function (Team $team) {
            // Add owner as a member with owner role
            $team->members()->attach($team->owner_id, ['role' => Team::ROLE_OWNER]);

            // Set as user's current team
            User::where('id', $team->owner_id)->update(['current_team_id' => $team->id]);
        });
    }

    /**
     * Create a personal team for a user (used in tests).
     */
    public function personal(User $user): static
    {
        return $this->state([
            'name' => "{$user->name}'s Team",
            'owner_id' => $user->id,
        ])->afterCreating(function (Team $team) use ($user) {
            // Add owner as a member with owner role
            $team->members()->attach($user->id, ['role' => Team::ROLE_OWNER]);

            // Set as user's current team
            $user->update(['current_team_id' => $team->id]);
        });
    }
}
