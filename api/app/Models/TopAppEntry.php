<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class TopAppEntry extends Model
{
    protected $fillable = [
        'app_id',
        'category_id',
        'collection',
        'country',
        'position',
        'recorded_at',
    ];

    protected $casts = [
        'recorded_at' => 'date',
        'position' => 'integer',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    public function scopePlatform($query, string $platform)
    {
        return $query->whereHas('app', fn($q) => $q->where('platform', $platform));
    }

    public function scopeIos($query)
    {
        return $query->whereHas('app', fn($q) => $q->where('platform', 'ios'));
    }

    public function scopeAndroid($query)
    {
        return $query->whereHas('app', fn($q) => $q->where('platform', 'android'));
    }

    public function scopeCategory($query, string $categoryId)
    {
        return $query->where('category_id', $categoryId);
    }

    public function scopeCollection($query, string $collection)
    {
        return $query->where('collection', $collection);
    }

    public function scopeCountry($query, string $country)
    {
        return $query->where('country', $country);
    }

    public function scopeDate($query, $date)
    {
        return $query->whereDate('recorded_at', $date);
    }

    public function scopeToday($query)
    {
        return $query->whereDate('recorded_at', today());
    }

    public function scopeYesterday($query)
    {
        return $query->whereDate('recorded_at', today()->subDay());
    }
}
