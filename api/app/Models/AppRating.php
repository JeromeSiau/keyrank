<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppRating extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'app_id',
        'platform',
        'country',
        'rating',
        'rating_count',
        'recorded_at',
    ];

    protected $casts = [
        'rating' => 'float',
        'rating_count' => 'integer',
        'recorded_at' => 'datetime',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    public function scopeForPlatform($query, string $platform)
    {
        return $query->where('platform', $platform);
    }
}
