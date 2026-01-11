<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SearchSuggestion extends Model
{
    protected $fillable = [
        'platform',
        'country',
        'seed_keyword',
        'suggestion',
        'position',
        'last_seen_at',
    ];

    protected $casts = [
        'position' => 'integer',
        'last_seen_at' => 'date',
    ];

    public function scopePlatform($query, string $platform)
    {
        return $query->where('platform', $platform);
    }

    public function scopeCountry($query, string $country)
    {
        return $query->where('country', $country);
    }

    public function scopeForSeed($query, string $keyword)
    {
        return $query->where('seed_keyword', $keyword);
    }

    public function scopeRecent($query, int $days = 7)
    {
        return $query->where('last_seen_at', '>=', now()->subDays($days));
    }

    /**
     * Get trending suggestions (seen recently, sorted by frequency)
     */
    public function scopeTrending($query)
    {
        return $query->recent()
            ->select('suggestion', 'platform', 'country')
            ->selectRaw('COUNT(*) as occurrence_count')
            ->groupBy('suggestion', 'platform', 'country')
            ->orderByDesc('occurrence_count');
    }
}
