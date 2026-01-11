<?php

namespace App\Models;

use App\Models\AlertRule;
use App\Models\Notification;
use Illuminate\Database\Eloquent\Factories\HasFactory;
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
        'onboarding_step',
        'onboarding_completed_at',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
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
            'onboarding_completed_at' => 'datetime',
        ];
    }

    /**
     * Get user's followed apps
     */
    public function apps(): BelongsToMany
    {
        return $this->belongsToMany(App::class, 'user_apps')
            ->withPivot('is_owner', 'ownership_type', 'integration_id', 'tag', 'is_favorite', 'favorited_at', 'created_at');
    }

    /**
     * Get user's owned apps (via store connection)
     */
    public function ownedApps(): BelongsToMany
    {
        return $this->apps()->wherePivot('ownership_type', 'owned');
    }

    /**
     * Get user's watched apps (competitors, inspiration, etc.)
     */
    public function watchedApps(): BelongsToMany
    {
        return $this->apps()->wherePivot('ownership_type', 'watched');
    }

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

    /**
     * Get user's tracked keywords
     */
    public function trackedKeywords(): HasMany
    {
        return $this->hasMany(TrackedKeyword::class);
    }

    /**
     * Get user's tags
     */
    public function tags(): HasMany
    {
        return $this->hasMany(Tag::class);
    }

    /**
     * Get user's alert rules
     */
    public function alertRules(): HasMany
    {
        return $this->hasMany(AlertRule::class);
    }

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
}
