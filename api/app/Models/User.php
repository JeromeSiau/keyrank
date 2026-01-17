<?php

namespace App\Models;

use App\Models\AlertRule;
use App\Models\Notification;
use App\Models\Team;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Cashier\Billable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasFactory, Notifiable, HasApiTokens, Billable;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'locale',
        'timezone',
        'fcm_token',
        'quiet_hours_start',
        'quiet_hours_end',
        'alert_delivery_preferences',
        'digest_time',
        'weekly_digest_day',
        'email_notifications_enabled',
        'onboarding_step',
        'onboarding_completed_at',
        'current_team_id',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
        'fcm_token',
        'stripe_id',
        'pm_type',
        'pm_last_four',
        'trial_ends_at',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'quiet_hours_start' => 'datetime:H:i:s',
            'quiet_hours_end' => 'datetime:H:i:s',
            'alert_delivery_preferences' => 'array',
            'email_notifications_enabled' => 'boolean',
            'onboarding_completed_at' => 'datetime',
        ];
    }

    /**
     * Get default alert delivery preferences for all alert types
     */
    public static function getDefaultAlertDeliveryPreferences(): array
    {
        $alertTypes = [
            'position_change',
            'rating_change',
            'review_spike',
            'review_keyword',
            'new_competitor',
            'competitor_passed',
            'mass_movement',
            'keyword_popularity',
            'opportunity',
        ];

        $defaults = [];
        foreach ($alertTypes as $type) {
            // Critical alerts get email by default, others go to digest
            $isCritical = in_array($type, ['rating_change', 'review_spike']);
            $defaults[$type] = [
                'push' => true,
                'email' => $isCritical,
                'digest' => !$isCritical,
            ];
        }

        return $defaults;
    }

    /**
     * Get alert delivery preferences with defaults filled in
     */
    public function getAlertDeliveryPreferencesAttribute($value): array
    {
        $decoded = is_string($value) ? json_decode($value, true) : $value;
        $defaults = self::getDefaultAlertDeliveryPreferences();

        if (empty($decoded)) {
            return $defaults;
        }

        // Merge with defaults to ensure all types are present
        return array_merge($defaults, $decoded);
    }

    // Note: Apps are now team-based. Use $user->currentTeam->apps() instead.

    /**
     * Get user's integrations
     */
    public function integrations(): HasMany
    {
        return $this->hasMany(Integration::class);
    }

    /**
     * Get active integration for a specific type
     */
    public function getIntegration(string $type): ?Integration
    {
        return $this->integrations()
            ->where('type', $type)
            ->where('status', Integration::STATUS_ACTIVE)
            ->first();
    }

    /**
     * Check if user has an active integration of a specific type
     */
    public function hasIntegration(string $type): bool
    {
        return $this->getIntegration($type) !== null;
    }

    // Note: TrackedKeywords are now team-based. Use $user->currentTeam->trackedKeywords() instead.

    // Note: Tags are now team-based. Use $user->currentTeam->tags() instead.

    // Note: AlertRules are now team-based. Access via team relationship instead.

    /**
     * Get user's notifications
     */
    public function notifications(): HasMany
    {
        return $this->hasMany(Notification::class);
    }

    /**
     * Get count of unread notifications
     */
    public function unreadNotificationsCount(): int
    {
        return $this->notifications()->unread()->count();
    }

    /**
     * Get user's store connections
     */
    public function storeConnections(): HasMany
    {
        return $this->hasMany(StoreConnection::class);
    }

    /**
     * Get active store connection for a platform
     */
    public function getStoreConnection(string $platform): ?StoreConnection
    {
        return $this->storeConnections()->where('platform', $platform)->where('status', 'active')->first();
    }

    /**
     * Check if user has an active store connection for a platform
     */
    public function hasStoreConnection(string $platform): bool
    {
        return $this->getStoreConnection($platform) !== null;
    }

    /**
     * Get user's teams
     */
    public function teams(): BelongsToMany
    {
        return $this->belongsToMany(Team::class, 'team_members')
            ->withPivot('role', 'created_at')
            ->withTimestamps();
    }

    /**
     * Get user's owned teams
     */
    public function ownedTeams(): HasMany
    {
        return $this->hasMany(Team::class, 'owner_id');
    }

    /**
     * Get user's current team
     */
    public function currentTeam(): BelongsTo
    {
        return $this->belongsTo(Team::class, 'current_team_id');
    }

    /**
     * Check if user belongs to a team
     */
    public function belongsToTeam(Team $team): bool
    {
        return $this->teams()->where('team_id', $team->id)->exists();
    }

    /**
     * Get user's role in a team
     */
    public function roleInTeam(Team $team): ?string
    {
        $membership = $this->teams()->where('team_id', $team->id)->first();
        return $membership?->pivot->role;
    }
}
