<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class FeaturedPlacement extends Model
{
    protected $fillable = [
        'app_id',
        'platform',
        'country',
        'placement_type',
        'placement_id',
        'placement_title',
        'position',
        'first_seen_at',
        'last_seen_at',
    ];

    protected $casts = [
        'position' => 'integer',
        'first_seen_at' => 'date',
        'last_seen_at' => 'date',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    public function scopePlatform($query, string $platform)
    {
        return $query->where('platform', $platform);
    }

    public function scopeCountry($query, string $country)
    {
        return $query->where('country', $country);
    }

    public function scopeActive($query)
    {
        // Featured in the last 7 days
        return $query->where('last_seen_at', '>=', now()->subDays(7));
    }

    public function scopePlacementType($query, string $type)
    {
        return $query->where('placement_type', $type);
    }

    /**
     * Check if still featured (seen today or yesterday)
     */
    public function isCurrentlyFeatured(): bool
    {
        return $this->last_seen_at >= today()->subDay();
    }

    /**
     * Get duration of featuring in days
     */
    public function getDurationDays(): int
    {
        return $this->first_seen_at->diffInDays($this->last_seen_at) + 1;
    }

    /**
     * Get currently featured apps
     */
    public static function getCurrentlyFeatured(string $platform, string $country)
    {
        return static::with('app')
            ->where('platform', $platform)
            ->where('country', $country)
            ->where('last_seen_at', '>=', today()->subDay())
            ->orderBy('placement_type')
            ->orderBy('position')
            ->get();
    }
}
