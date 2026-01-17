<?php

namespace App\Http\Controllers\Concerns;

use App\Models\Team;
use Illuminate\Http\JsonResponse;

trait AuthorizesTeamActions
{
    /**
     * Get the current team for the authenticated user.
     */
    protected function currentTeam(): Team
    {
        $user = auth()->user();
        $team = $user->currentTeam;

        if (!$team) {
            abort(403, 'No team selected. Please select a team first.');
        }

        return $team;
    }

    /**
     * Authorize an action based on team permissions.
     *
     * @throws \Symfony\Component\HttpKernel\Exception\HttpException
     */
    protected function authorizeTeamAction(string $permission): void
    {
        $user = auth()->user();
        $team = $this->currentTeam();

        if (!$team->userHasPermission($user, $permission)) {
            abort(403, "You do not have permission to: {$permission}");
        }
    }

    /**
     * Check if user can perform action (without aborting).
     */
    protected function canPerformTeamAction(string $permission): bool
    {
        $user = auth()->user();
        $team = $user->currentTeam;

        if (!$team) {
            return false;
        }

        return $team->userHasPermission($user, $permission);
    }
}
