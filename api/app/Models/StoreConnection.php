<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Facades\Crypt;

class StoreConnection extends Model
{
    protected $fillable = [
        'user_id',
        'platform',
        'credentials',
        'connected_at',
        'last_sync_at',
        'status',
    ];

    protected $casts = [
        'connected_at' => 'datetime',
        'last_sync_at' => 'datetime',
    ];

    protected $hidden = ['credentials'];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function setCredentialsAttribute(array $value): void
    {
        $this->attributes['credentials'] = Crypt::encryptString(json_encode($value));
    }

    public function getCredentialsAttribute(?string $value): ?array
    {
        if (!$value) return null;
        return json_decode(Crypt::decryptString($value), true);
    }

    public function isActive(): bool
    {
        return $this->status === 'active';
    }

    public function markAsExpired(): void
    {
        $this->update(['status' => 'expired']);
    }

    public function updateLastSync(): void
    {
        $this->update(['last_sync_at' => now()]);
    }
}
