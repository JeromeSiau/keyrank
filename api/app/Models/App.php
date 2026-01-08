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
        'platform',
        'store_id',
        'bundle_id',
        'name',
        'icon_url',
        'developer',
        'rating',
        'rating_count',
        'storefront',
        'ratings_fetched_at',
        'reviews_fetched_at',
    ];

    protected $casts = [
        'rating' => 'decimal:1',
        'rating_count' => 'integer',
        'ratings_fetched_at' => 'datetime',
        'reviews_fetched_at' => 'datetime',
    ];

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
                    ->groupBy('country');
            });
    }

    public function reviews(): HasMany
    {
        return $this->hasMany(AppReview::class);
    }
}
