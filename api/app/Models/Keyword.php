<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Keyword extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'keyword',
        'storefront',
        'popularity',
        'popularity_updated_at',
        'created_at',
    ];

    protected $casts = [
        'popularity' => 'integer',
        'popularity_updated_at' => 'datetime',
        'created_at' => 'datetime',
    ];

    public function apps(): BelongsToMany
    {
        return $this->belongsToMany(App::class, 'tracked_keywords')
            ->withPivot('created_at');
    }

    public function rankings(): HasMany
    {
        return $this->hasMany(AppRanking::class);
    }

    public function popularityHistory(): HasMany
    {
        return $this->hasMany(KeywordPopularityHistory::class);
    }

    /**
     * Find or create a keyword for a given storefront
     */
    public static function findOrCreateKeyword(string $keyword, string $storefront = 'US'): self
    {
        return self::firstOrCreate(
            ['keyword' => strtolower(trim($keyword)), 'storefront' => strtoupper($storefront)],
            ['created_at' => now()]
        );
    }
}
