<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Facades\Crypt;

class Integration extends Model
{
    use HasFactory;

    public const TYPE_APP_STORE_CONNECT = 'app_store_connect';
    public const TYPE_GOOGLE_PLAY_CONSOLE = 'google_play_console';
    public const TYPE_APPLE_SEARCH_ADS = 'apple_search_ads';
    public const TYPE_STRIPE = 'stripe';
    public const TYPE_SLACK = 'slack';
    public const TYPE_WEBHOOK = 'webhook';

    public const STATUS_PENDING = 'pending';
    public const STATUS_ACTIVE = 'active';
    public const STATUS_ERROR = 'error';
    public const STATUS_REVOKED = 'revoked';

    protected $fillable = [
        'user_id',
        'type',
        'status',
        'credentials',
        'metadata',
        'last_sync_at',
        'error_message',
    ];

    protected $casts = [
        'metadata' => 'array',
        'last_sync_at' => 'datetime',
    ];

    protected $hidden = ['credentials'];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get apps connected via this integration
     */
    public function apps(): HasMany
    {
        return $this->hasMany(App::class, 'integration_id');
    }

    /**
     * Encrypt credentials before storing
     */
    public function setCredentialsAttribute(array $value): void
    {
        $this->attributes['credentials'] = Crypt::encryptString(json_encode($value));
    }

    /**
     * Decrypt credentials when retrieving
     */
    public function getCredentialsAttribute(?string $value): ?array
    {
        if (!$value) {
            return null;
        }

        return json_decode(Crypt::decryptString($value), true);
    }

    public function isActive(): bool
    {
        return $this->status === self::STATUS_ACTIVE;
    }

    public function isPending(): bool
    {
        return $this->status === self::STATUS_PENDING;
    }

    public function hasError(): bool
    {
        return $this->status === self::STATUS_ERROR;
    }

    public function markAsActive(): void
    {
        $this->update([
            'status' => self::STATUS_ACTIVE,
            'error_message' => null,
        ]);
    }

    public function markAsError(string $message): void
    {
        $this->update([
            'status' => self::STATUS_ERROR,
            'error_message' => $message,
        ]);
    }

    public function markAsRevoked(): void
    {
        $this->update(['status' => self::STATUS_REVOKED]);
    }

    public function updateLastSync(): void
    {
        $this->update(['last_sync_at' => now()]);
    }

    /**
     * Check if this is a store connection (App Store Connect or Google Play)
     */
    public function isStoreConnection(): bool
    {
        return in_array($this->type, [
            self::TYPE_APP_STORE_CONNECT,
            self::TYPE_GOOGLE_PLAY_CONSOLE,
        ]);
    }

    /**
     * Get the platform for store connections
     */
    public function getPlatform(): ?string
    {
        return match ($this->type) {
            self::TYPE_APP_STORE_CONNECT => 'ios',
            self::TYPE_GOOGLE_PLAY_CONSOLE => 'android',
            default => null,
        };
    }
}
