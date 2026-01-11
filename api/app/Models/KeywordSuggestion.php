<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class KeywordSuggestion extends Model
{
    use HasFactory;

    protected $fillable = [
        'app_id',
        'keyword',
        'source',
        'position',
        'competition',
        'difficulty',
        'difficulty_label',
        'top_competitors',
        'country',
        'generated_at',
    ];

    protected $casts = [
        'position' => 'integer',
        'competition' => 'integer',
        'difficulty' => 'integer',
        'top_competitors' => 'array',
        'generated_at' => 'datetime',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    /**
     * Check if suggestions need refresh (older than 7 days)
     */
    public function needsRefresh(): bool
    {
        if (!$this->generated_at) {
            return true;
        }

        return $this->generated_at->diffInDays(now()) >= 7;
    }

    /**
     * Scope: Filter by country
     */
    public function scopeForCountry($query, string $country)
    {
        return $query->where('country', strtoupper($country));
    }

    /**
     * Scope: Order by opportunity (ranked keywords first, then by difficulty)
     */
    public function scopeOrderByOpportunity($query)
    {
        return $query->orderByRaw('position IS NULL')
                     ->orderBy('difficulty', 'asc');
    }
}
