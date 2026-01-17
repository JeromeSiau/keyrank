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
        // Discovery tracking
        'discovered_from_app_id',
        'discovery_source',
        // Metadata tracking
        'current_version',
        'current_price',
        'current_size_bytes',
        'current_screenshots',
        'metadata_checked_at',
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
        'current_price' => 'decimal:2',
        'current_size_bytes' => 'integer',
        'current_screenshots' => 'array',
        'metadata_checked_at' => 'datetime',
    ];

    public function users(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'user_apps')
            ->withPivot('is_owner', 'is_favorite', 'favorited_at', 'created_at');
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

    public function voiceSettings(): HasMany
    {
        return $this->hasMany(AppVoiceSetting::class);
    }

    public function getVoiceSettingForUser(int $userId): ?AppVoiceSetting
    {
        return $this->voiceSettings()->where('user_id', $userId)->first();
    }

    public function analytics(): HasMany
    {
        return $this->hasMany(AppAnalytics::class);
    }

    public function analyticsSummaries(): HasMany
    {
        return $this->hasMany(AppAnalyticsSummary::class);
    }

    public function getAnalyticsSummary(string $period = '30d'): ?AppAnalyticsSummary
    {
        return $this->analyticsSummaries()->where('period', $period)->first();
    }

    public function keywordSuggestions(): HasMany
    {
        return $this->hasMany(KeywordSuggestion::class);
    }

    public function metadataHistory(): HasMany
    {
        return $this->hasMany(AppMetadataHistory::class);
    }

    public function metadataLocales(): HasMany
    {
        return $this->hasMany(AppMetadataLocale::class);
    }

    public function metadataDrafts(): HasMany
    {
        return $this->hasMany(AppMetadataDraft::class);
    }

    public function getMetadataForLocale(string $locale): ?AppMetadataLocale
    {
        return $this->metadataLocales()->where('locale', $locale)->first();
    }

    public function topChartEntries(): HasMany
    {
        return $this->hasMany(TopAppEntry::class);
    }

    public function discoveredFrom(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(App::class, 'discovered_from_app_id');
    }

    public function discoveredApps(): HasMany
    {
        return $this->hasMany(App::class, 'discovered_from_app_id');
    }

    public function competitorLinks(): HasMany
    {
        return $this->hasMany(AppCompetitor::class, 'owner_app_id');
    }

    public function competitorOf(): HasMany
    {
        return $this->hasMany(AppCompetitor::class, 'competitor_app_id');
    }

    public function scopeOwnedBy($query, int $userId)
    {
        return $query->whereHas('users', function ($q) use ($userId) {
            $q->where('users.id', $userId)
              ->where('user_apps.is_owner', true);
        });
    }


    public function scopeDiscoveredVia($query, string $source)
    {
        return $query->where('discovery_source', $source);
    }

    public function scopeWithRecentVersionChange($query, int $days = 7)
    {
        return $query->whereHas('metadataHistory', function ($q) use ($days) {
            $q->where('field', 'version')
                ->where('changed_at', '>=', now()->subDays($days));
        });
    }
}
