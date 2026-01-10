<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

class App extends Model
{
    use HasFactory;

    protected $fillable = [
        'platform',
        'store_id',
        'bundle_id',
        'name',
        'icon_url',
        'developer',
        'description',
        'screenshots',
        'version',
        'release_date',
        'updated_date',
        'size_bytes',
        'minimum_os',
        'store_url',
        'price',
        'currency',
        'rating',
        'rating_count',
        'storefront',
        'category_id',
        'secondary_category_id',
        'ratings_fetched_at',
        'reviews_fetched_at',
    ];

    protected $casts = [
        'rating' => 'decimal:1',
        'rating_count' => 'integer',
        'screenshots' => 'array',
        'release_date' => 'date',
        'updated_date' => 'datetime',
        'size_bytes' => 'integer',
        'price' => 'decimal:2',
        'ratings_fetched_at' => 'datetime',
        'reviews_fetched_at' => 'datetime',
    ];

    public function users(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'user_apps')
            ->withPivot('is_favorite', 'favorited_at', 'created_at');
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

    public function insights(): HasMany
    {
        return $this->hasMany(AppInsight::class);
    }

    public function latestInsight(): HasOne
    {
        return $this->hasOne(AppInsight::class)->latestOfMany();
    }
}
