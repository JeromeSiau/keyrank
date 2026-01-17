<?php

namespace Tests;

use App\Models\Team;
use App\Models\User;
use Illuminate\Foundation\Testing\TestCase as BaseTestCase;

abstract class TestCase extends BaseTestCase
{
    /**
     * Create a user with a personal team.
     * Returns the user with current_team_id set.
     */
    protected function createUserWithTeam(array $userAttributes = []): User
    {
        $user = User::factory()->create($userAttributes);
        $team = Team::factory()->personal($user)->create();

        return $user->fresh();
    }

    /**
     * Get the user's current team (shorthand).
     */
    protected function getTeam(User $user): Team
    {
        return $user->currentTeam;
    }
}
