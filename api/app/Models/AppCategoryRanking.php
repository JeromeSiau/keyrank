<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppCategoryRanking extends Model
{
    protected $fillable = [
        'app_id',
        'country',
        'collection',
        'position',
        'recorded_at',
    ];

    protected $casts = [
        'position' => 'integer',
        'recorded_at' => 'date',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    public function scopeCountry($query, string $country)
    {
        return $query->where('country', $country);
    }

    public function scopeCollection($query, string $collection)
    {
        return $query->where('collection', $collection);
    }

    public function scopeRecent($query, int $days = 30)
    {
        return $query->where('recorded_at', '>=', now()->subDays($days));
    }

    /**
     * Get ranking history for graphing
     */
    public static function getHistory(int $appId, string $country, string $collection, int $days = 30)
    {
        return static::where('app_id', $appId)
            ->where('country', $country)
            ->where('collection', $collection)
            ->where('recorded_at', '>=', now()->subDays($days))
            ->orderBy('recorded_at')
            ->get(['position', 'recorded_at']);
    }
}
