<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppMetadataHistory extends Model
{
    protected $table = 'app_metadata_history';

    protected $fillable = [
        'app_id',
        'field',
        'old_value',
        'new_value',
        'changed_at',
    ];

    protected $casts = [
        'changed_at' => 'datetime',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    public function scopeField($query, string $field)
    {
        return $query->where('field', $field);
    }

    public function scopeVersionChanges($query)
    {
        return $query->field('version');
    }

    public function scopePriceChanges($query)
    {
        return $query->field('price');
    }

    public function scopeRecent($query, int $days = 30)
    {
        return $query->where('changed_at', '>=', now()->subDays($days));
    }

    public function scopeForApp($query, int $appId)
    {
        return $query->where('app_id', $appId);
    }

    /**
     * Get apps with version updates in the last X days
     */
    public static function appsWithRecentVersionUpdates(int $days = 7)
    {
        return static::versionChanges()
            ->recent($days)
            ->with('app')
            ->orderByDesc('changed_at')
            ->get()
            ->pluck('app')
            ->unique('id');
    }

    /**
     * Get apps with price drops
     */
    public static function appsWithPriceDrops(int $days = 7)
    {
        return static::priceChanges()
            ->recent($days)
            ->whereRaw('CAST(new_value AS DECIMAL(10,2)) < CAST(old_value AS DECIMAL(10,2))')
            ->with('app')
            ->orderByDesc('changed_at')
            ->get();
    }
}
