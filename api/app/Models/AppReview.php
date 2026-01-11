<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppReview extends Model
{
    use HasFactory;
    protected $fillable = [
        'app_id',
        'country',
        'review_id',
        'author',
        'title',
        'content',
        'rating',
        'version',
        'reviewed_at',
        'sentiment',
        'sentiment_score',
        'themes',
        'language',
        'enriched_at',
        'our_response',
        'responded_at',
        'store_response_id',
    ];

    protected $casts = [
        'rating' => 'integer',
        'reviewed_at' => 'datetime',
        'responded_at' => 'datetime',
        'enriched_at' => 'datetime',
        'sentiment_score' => 'decimal:2',
        'themes' => 'array',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    public function isAnswered(): bool
    {
        return $this->responded_at !== null;
    }

    public function scopeUnanswered($query)
    {
        return $query->whereNull('responded_at');
    }

    public function scopeAnswered($query)
    {
        return $query->whereNotNull('responded_at');
    }

    public function scopeNegative($query)
    {
        return $query->where('rating', '<=', 2);
    }

    public function scopeBySentiment($query, string $sentiment)
    {
        return $query->where('sentiment', $sentiment);
    }

    public function scopeUnenriched($query)
    {
        return $query->whereNull('enriched_at');
    }

    public function scopeEnriched($query)
    {
        return $query->whereNotNull('enriched_at');
    }

    public function scopeWithTheme($query, string $theme)
    {
        return $query->whereJsonContains('themes', $theme);
    }

    public function isEnriched(): bool
    {
        return $this->enriched_at !== null;
    }
}
