<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Str;

class Team extends Model
{
    use HasFactory;

    public const ROLE_OWNER = 'owner';
    public const ROLE_ADMIN = 'admin';
    public const ROLE_EDITOR = 'editor';
    public const ROLE_VIEWER = 'viewer';

    public const ROLES = [
        self::ROLE_OWNER,
        self::ROLE_ADMIN,
        self::ROLE_EDITOR,
        self::ROLE_VIEWER,
    ];

    /**
     * Permissions for each role
     */
    public const ROLE_PERMISSIONS = [
        self::ROLE_OWNER => [
            'manage_team',
            'manage_billing',
            'delete_team',
            'manage_apps',
            'manage_keywords',
            'edit_metadata',
            'manage_alerts',
            'manage_competitors',
            'invite_members',
            'remove_members',
            'view_analytics',
            'export_data',
            'use_ai_features',
        ],
        self::ROLE_ADMIN => [
            'manage_apps',
            'manage_keywords',
            'edit_metadata',
            'manage_alerts',
            'manage_competitors',
            'invite_members',
            'remove_members',
            'view_analytics',
            'export_data',
            'use_ai_features',
        ],
        self::ROLE_EDITOR => [
            'manage_apps',
            'manage_keywords',
            'edit_metadata',
            'manage_alerts',
            'view_analytics',
            'export_data',
            'use_ai_features',
        ],
        self::ROLE_VIEWER => [
            'view_apps',
            'view_keywords',
            'view_analytics',
            'export_data',
        ],
    ];

    protected $fillable = [
        'name',
        'slug',
        'description',
        'owner_id',
        'settings',
    ];

    protected $casts = [
        'settings' => 'array',
    ];

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($team) {
            if (empty($team->slug)) {
                $team->slug = Str::slug($team->name) . '-' . Str::random(6);
            }
        });
    }

    /**
     * Get the team owner
     */
    public function owner(): BelongsTo
    {
        return $this->belongsTo(User::class, 'owner_id');
    }

    /**
     * Get all team members through pivot
     */
    public function members(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'team_members')
            ->withPivot('role', 'created_at')
            ->withTimestamps();
    }

    /**
     * Get team members with a specific role
     */
    public function membersWithRole(string $role): BelongsToMany
    {
        return $this->members()->wherePivot('role', $role);
    }

    /**
     * Get team admins (owner + admins)
     */
    public function admins(): BelongsToMany
    {
        return $this->members()->wherePivotIn('role', [self::ROLE_OWNER, self::ROLE_ADMIN]);
    }

    /**
     * Get team apps
     */
    public function apps(): BelongsToMany
    {
        return $this->belongsToMany(App::class, 'team_apps')
            ->withPivot('added_by', 'created_at')
            ->withTimestamps();
    }

    /**
     * Get pending invitations
     */
    public function invitations(): HasMany
    {
        return $this->hasMany(TeamInvitation::class);
    }

    /**
     * Get pending invitations only
     */
    public function pendingInvitations(): HasMany
    {
        return $this->invitations()->where('status', TeamInvitation::STATUS_PENDING);
    }

    /**
     * Check if user is a member
     */
    public function hasMember(User $user): bool
    {
        return $this->members()->where('user_id', $user->id)->exists();
    }

    /**
     * Get user's role in team
     */
    public function getMemberRole(User $user): ?string
    {
        $member = $this->members()->where('user_id', $user->id)->first();
        return $member?->pivot->role;
    }

    /**
     * Check if user has a specific permission
     */
    public function userHasPermission(User $user, string $permission): bool
    {
        $role = $this->getMemberRole($user);
        if (!$role) {
            return false;
        }

        return in_array($permission, self::ROLE_PERMISSIONS[$role] ?? []);
    }

    /**
     * Check if user can manage team (owner or admin)
     */
    public function userCanManage(User $user): bool
    {
        $role = $this->getMemberRole($user);
        return in_array($role, [self::ROLE_OWNER, self::ROLE_ADMIN]);
    }

    /**
     * Check if user is owner
     */
    public function isOwner(User $user): bool
    {
        return $this->owner_id === $user->id;
    }

    /**
     * Add a member to the team
     */
    public function addMember(User $user, string $role = self::ROLE_VIEWER): void
    {
        if (!$this->hasMember($user)) {
            $this->members()->attach($user->id, ['role' => $role]);
        }
    }

    /**
     * Remove a member from the team
     */
    public function removeMember(User $user): void
    {
        $this->members()->detach($user->id);
    }

    /**
     * Update member's role
     */
    public function updateMemberRole(User $user, string $role): void
    {
        $this->members()->updateExistingPivot($user->id, ['role' => $role]);
    }

    /**
     * Add an app to the team
     */
    public function addApp(App $app, User $addedBy = null): void
    {
        if (!$this->apps()->where('app_id', $app->id)->exists()) {
            $this->apps()->attach($app->id, ['added_by' => $addedBy?->id]);
        }
    }

    /**
     * Remove an app from the team
     */
    public function removeApp(App $app): void
    {
        $this->apps()->detach($app->id);
    }

    /**
     * Get permissions for a role
     */
    public static function getPermissionsForRole(string $role): array
    {
        return self::ROLE_PERMISSIONS[$role] ?? [];
    }
}
