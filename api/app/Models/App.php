<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class App extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'apple_id',
        'google_play_id',
        'bundle_id',
        'name',
        'icon_url',
        'google_icon_url',
        'developer',
        'rating',
        'rating_count',
        'google_rating',
        'google_rating_count',
        'storefront',
        'ratings_fetched_at',
        'reviews_fetched_at',
        'google_ratings_fetched_at',
        'google_reviews_fetched_at',
    ];

    protected $casts = [
        'rating' => 'decimal:1',
        'rating_count' => 'integer',
        'google_rating' => 'decimal:1',
        'google_rating_count' => 'integer',
        'ratings_fetched_at' => 'datetime',
        'reviews_fetched_at' => 'datetime',
        'google_ratings_fetched_at' => 'datetime',
        'google_reviews_fetched_at' => 'datetime',
    ];

    public function hasIos(): bool
    {
        return !empty($this->apple_id);
    }

    public function hasAndroid(): bool
    {
        return !empty($this->google_play_id);
    }

    public function platforms(): array
    {
        $platforms = [];
        if ($this->hasIos()) $platforms[] = 'ios';
        if ($this->hasAndroid()) $platforms[] = 'android';
        return $platforms;
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function keywords(): BelongsToMany
    {
        return $this->belongsToMany(Keyword::class, 'tracked_keywords')
            ->withPivot('created_at');
    }

    public function trackedKeywords(): HasMany
    {
        return $this->hasMany(TrackedKeyword::class);
    }

    public function rankings(): HasMany
    {
        return $this->hasMany(AppRanking::class);
    }

    public function latestRankings(): HasMany
    {
        return $this->hasMany(AppRanking::class)
            ->whereDate('recorded_at', today());
    }

    public function ratings(): HasMany
    {
        return $this->hasMany(AppRating::class);
    }

    public function latestRatings(): HasMany
    {
        return $this->hasMany(AppRating::class)
            ->whereIn('id', function ($query) {
                $query->selectRaw('MAX(id)')
                    ->from('app_ratings')
                    ->where('app_id', $this->id)
                    ->groupBy('country', 'platform');
            });
    }

    public function reviews(): HasMany
    {
        return $this->hasMany(AppReview::class);
    }
}
