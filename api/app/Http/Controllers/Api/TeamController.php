<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Team;
use App\Models\TeamInvitation;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

class TeamController extends Controller
{
    /**
     * List all teams the user belongs to.
     */
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();

        $teams = $user->teams()
            ->withCount('members')
            ->withPivot('role')
            ->get()
            ->map(fn($team) => $this->formatTeam($team, $team->pivot->role));

        return response()->json([
            'teams' => $teams,
        ]);
    }

    /**
     * Create a new team.
     */
    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string|max:1000',
        ]);

        $user = $request->user();

        // Create team
        $team = Team::create([
            'name' => $request->input('name'),
            'slug' => Str::slug($request->input('name')) . '-' . Str::random(6),
            'description' => $request->input('description'),
            'owner_id' => $user->id,
        ]);

        // Add creator as owner member
        $team->addMember($user, Team::ROLE_OWNER);

        // Set as current team if user doesn't have one
        if (!$user->current_team_id) {
            $user->update(['current_team_id' => $team->id]);
        }

        return response()->json([
            'team' => $this->formatTeam($team, Team::ROLE_OWNER),
        ], 201);
    }

    /**
     * Get team details.
     */
    public function show(Request $request, Team $team): JsonResponse
    {
        $user = $request->user();

        if (!$team->hasMember($user)) {
            return response()->json(['error' => 'You are not a member of this team'], 403);
        }

        $team->loadCount('members');
        $role = $team->getMemberRole($user);

        return response()->json([
            'team' => $this->formatTeam($team, $role),
        ]);
    }

    /**
     * Update team details.
     */
    public function update(Request $request, Team $team): JsonResponse
    {
        $user = $request->user();

        if (!$team->userCanManage($user)) {
            return response()->json(['error' => 'You do not have permission to update this team'], 403);
        }

        $request->validate([
            'name' => 'sometimes|string|max:255',
            'description' => 'nullable|string|max:1000',
        ]);

        $team->update($request->only(['name', 'description']));

        return response()->json([
            'team' => $this->formatTeam($team, $team->getMemberRole($user)),
        ]);
    }

    /**
     * Delete team.
     */
    public function destroy(Request $request, Team $team): JsonResponse
    {
        $user = $request->user();

        if (!$team->isOwner($user)) {
            return response()->json(['error' => 'Only the team owner can delete the team'], 403);
        }

        // Clear current_team_id for all members
        User::where('current_team_id', $team->id)->update(['current_team_id' => null]);

        $team->delete();

        return response()->json(['success' => true]);
    }

    /**
     * List team members.
     */
    public function members(Request $request, Team $team): JsonResponse
    {
        $user = $request->user();

        if (!$team->hasMember($user)) {
            return response()->json(['error' => 'You are not a member of this team'], 403);
        }

        $members = $team->members()
            ->get()
            ->map(fn($member) => $this->formatMember($member));

        return response()->json([
            'members' => $members,
        ]);
    }

    /**
     * Invite a user to the team.
     */
    public function invite(Request $request, Team $team): JsonResponse
    {
        $user = $request->user();

        if (!$team->userHasPermission($user, 'invite_members')) {
            return response()->json(['error' => 'You do not have permission to invite members'], 403);
        }

        $request->validate([
            'email' => 'required|email',
            'role' => ['required', Rule::in([Team::ROLE_ADMIN, Team::ROLE_EDITOR, Team::ROLE_VIEWER])],
        ]);

        $email = strtolower($request->input('email'));
        $role = $request->input('role');

        // Check if user is already a member
        $existingUser = User::where('email', $email)->first();
        if ($existingUser && $team->hasMember($existingUser)) {
            return response()->json(['error' => 'This user is already a team member'], 409);
        }

        // Check for existing pending invitation
        $existingInvitation = $team->pendingInvitations()
            ->where('email', $email)
            ->first();

        if ($existingInvitation) {
            // Update existing invitation
            $existingInvitation->update([
                'role' => $role,
                'inviter_id' => $user->id,
                'expires_at' => now()->addDays(TeamInvitation::EXPIRES_IN_DAYS),
            ]);
            $invitation = $existingInvitation;
        } else {
            // Create new invitation
            $invitation = TeamInvitation::create([
                'team_id' => $team->id,
                'inviter_id' => $user->id,
                'email' => $email,
                'role' => $role,
            ]);
        }

        // TODO: Send invitation email
        // Mail::to($email)->send(new TeamInvitationMail($invitation));

        return response()->json([
            'invitation' => $this->formatInvitation($invitation),
        ], 201);
    }

    /**
     * Cancel/revoke an invitation.
     */
    public function cancelInvitation(Request $request, Team $team, TeamInvitation $invitation): JsonResponse
    {
        $user = $request->user();

        if ($invitation->team_id !== $team->id) {
            return response()->json(['error' => 'Invitation does not belong to this team'], 404);
        }

        if (!$team->userHasPermission($user, 'invite_members')) {
            return response()->json(['error' => 'You do not have permission to cancel invitations'], 403);
        }

        $invitation->delete();

        return response()->json(['success' => true]);
    }

    /**
     * List pending invitations for team.
     */
    public function invitations(Request $request, Team $team): JsonResponse
    {
        $user = $request->user();

        if (!$team->userCanManage($user)) {
            return response()->json(['error' => 'You do not have permission to view invitations'], 403);
        }

        $invitations = $team->pendingInvitations()
            ->with('inviter')
            ->get()
            ->map(fn($inv) => $this->formatInvitation($inv));

        return response()->json([
            'invitations' => $invitations,
        ]);
    }

    /**
     * Remove a member from the team.
     */
    public function removeMember(Request $request, Team $team, User $member): JsonResponse
    {
        $user = $request->user();

        if (!$team->userHasPermission($user, 'remove_members')) {
            return response()->json(['error' => 'You do not have permission to remove members'], 403);
        }

        // Cannot remove owner
        if ($team->isOwner($member)) {
            return response()->json(['error' => 'Cannot remove the team owner'], 400);
        }

        // Cannot remove yourself (use leave instead)
        if ($member->id === $user->id) {
            return response()->json(['error' => 'Use leave endpoint to remove yourself'], 400);
        }

        // Admins cannot remove other admins unless they are the owner
        $memberRole = $team->getMemberRole($member);
        $userRole = $team->getMemberRole($user);
        if ($memberRole === Team::ROLE_ADMIN && $userRole !== Team::ROLE_OWNER) {
            return response()->json(['error' => 'Only the owner can remove admins'], 403);
        }

        // Clear current_team_id if this was their current team
        if ($member->current_team_id === $team->id) {
            $member->update(['current_team_id' => null]);
        }

        $team->removeMember($member);

        return response()->json(['success' => true]);
    }

    /**
     * Update a member's role.
     */
    public function updateMemberRole(Request $request, Team $team, User $member): JsonResponse
    {
        $user = $request->user();

        if (!$team->userCanManage($user)) {
            return response()->json(['error' => 'You do not have permission to update member roles'], 403);
        }

        $request->validate([
            'role' => ['required', Rule::in([Team::ROLE_ADMIN, Team::ROLE_EDITOR, Team::ROLE_VIEWER])],
        ]);

        // Cannot change owner's role
        if ($team->isOwner($member)) {
            return response()->json(['error' => 'Cannot change the team owner\'s role'], 400);
        }

        // Only owner can promote to admin
        $newRole = $request->input('role');
        $currentRole = $team->getMemberRole($member);
        if ($newRole === Team::ROLE_ADMIN && !$team->isOwner($user)) {
            return response()->json(['error' => 'Only the owner can promote members to admin'], 403);
        }

        // Only owner can demote admins
        if ($currentRole === Team::ROLE_ADMIN && !$team->isOwner($user)) {
            return response()->json(['error' => 'Only the owner can change admin roles'], 403);
        }

        $team->updateMemberRole($member, $newRole);

        return response()->json([
            'member' => $this->formatMember($member->fresh()),
        ]);
    }

    /**
     * Leave the team.
     */
    public function leave(Request $request, Team $team): JsonResponse
    {
        $user = $request->user();

        if (!$team->hasMember($user)) {
            return response()->json(['error' => 'You are not a member of this team'], 403);
        }

        // Owner cannot leave - must transfer ownership or delete team
        if ($team->isOwner($user)) {
            return response()->json(['error' => 'Team owner cannot leave. Transfer ownership or delete the team.'], 400);
        }

        // Clear current_team_id if this was their current team
        if ($user->current_team_id === $team->id) {
            $user->update(['current_team_id' => null]);
        }

        $team->removeMember($user);

        return response()->json(['success' => true]);
    }

    /**
     * Transfer team ownership to another member.
     */
    public function transferOwnership(Request $request, Team $team): JsonResponse
    {
        $user = $request->user();

        if (!$team->isOwner($user)) {
            return response()->json(['error' => 'Only the team owner can transfer ownership'], 403);
        }

        $request->validate([
            'user_id' => 'required|exists:users,id',
        ]);

        $newOwner = User::findOrFail($request->input('user_id'));

        if (!$team->hasMember($newOwner)) {
            return response()->json(['error' => 'New owner must be a team member'], 400);
        }

        // Update team owner
        $team->update(['owner_id' => $newOwner->id]);

        // Update roles
        $team->updateMemberRole($newOwner, Team::ROLE_OWNER);
        $team->updateMemberRole($user, Team::ROLE_ADMIN);

        return response()->json([
            'team' => $this->formatTeam($team->fresh(), Team::ROLE_ADMIN),
        ]);
    }

    /**
     * Switch current team.
     */
    public function switchTeam(Request $request, Team $team): JsonResponse
    {
        $user = $request->user();

        if (!$team->hasMember($user)) {
            return response()->json(['error' => 'You are not a member of this team'], 403);
        }

        $user->update(['current_team_id' => $team->id]);

        return response()->json([
            'current_team' => $this->formatTeam($team, $team->getMemberRole($user)),
        ]);
    }

    /**
     * Get pending invitations for the current user.
     */
    public function myInvitations(Request $request): JsonResponse
    {
        $user = $request->user();

        $invitations = TeamInvitation::pending()
            ->forEmail($user->email)
            ->with(['team', 'inviter'])
            ->get()
            ->map(fn($inv) => $this->formatInvitation($inv, true));

        return response()->json([
            'invitations' => $invitations,
        ]);
    }

    /**
     * Accept an invitation.
     */
    public function acceptInvitation(Request $request, string $token): JsonResponse
    {
        $user = $request->user();

        $invitation = TeamInvitation::findValidByToken($token);

        if (!$invitation) {
            return response()->json(['error' => 'Invalid or expired invitation'], 404);
        }

        // Verify email matches
        if (strtolower($invitation->email) !== strtolower($user->email)) {
            return response()->json(['error' => 'This invitation was sent to a different email address'], 403);
        }

        // Accept invitation
        if (!$invitation->accept($user)) {
            return response()->json(['error' => 'Could not accept invitation'], 400);
        }

        // Set as current team if user doesn't have one
        if (!$user->current_team_id) {
            $user->update(['current_team_id' => $invitation->team_id]);
        }

        $team = $invitation->team;
        $team->loadCount('members');

        return response()->json([
            'team' => $this->formatTeam($team, $invitation->role),
        ]);
    }

    /**
     * Decline an invitation.
     */
    public function declineInvitation(Request $request, string $token): JsonResponse
    {
        $user = $request->user();

        $invitation = TeamInvitation::findValidByToken($token);

        if (!$invitation) {
            return response()->json(['error' => 'Invalid or expired invitation'], 404);
        }

        // Verify email matches
        if (strtolower($invitation->email) !== strtolower($user->email)) {
            return response()->json(['error' => 'This invitation was sent to a different email address'], 403);
        }

        $invitation->decline();

        return response()->json(['success' => true]);
    }

    /**
     * Format team for API response.
     */
    private function formatTeam(Team $team, string $role): array
    {
        return [
            'id' => $team->id,
            'name' => $team->name,
            'slug' => $team->slug,
            'description' => $team->description,
            'owner_id' => $team->owner_id,
            'members_count' => $team->members_count ?? $team->members()->count(),
            'my_role' => $role,
            'permissions' => Team::getPermissionsForRole($role),
            'created_at' => $team->created_at->toIso8601String(),
        ];
    }

    /**
     * Format member for API response.
     */
    private function formatMember(User $member): array
    {
        return [
            'id' => $member->id,
            'name' => $member->name,
            'email' => $member->email,
            'role' => $member->pivot->role ?? null,
            'joined_at' => $member->pivot->created_at?->toIso8601String(),
        ];
    }

    /**
     * Format invitation for API response.
     */
    private function formatInvitation(TeamInvitation $invitation, bool $includeTeam = false): array
    {
        $data = [
            'id' => $invitation->id,
            'email' => $invitation->email,
            'role' => $invitation->role,
            'status' => $invitation->status,
            'token' => $invitation->token,
            'expires_at' => $invitation->expires_at->toIso8601String(),
            'inviter' => [
                'id' => $invitation->inviter->id,
                'name' => $invitation->inviter->name,
            ],
            'created_at' => $invitation->created_at->toIso8601String(),
        ];

        if ($includeTeam) {
            $data['team'] = [
                'id' => $invitation->team->id,
                'name' => $invitation->team->name,
                'description' => $invitation->team->description,
            ];
        }

        return $data;
    }
}
