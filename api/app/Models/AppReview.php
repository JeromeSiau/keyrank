<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppReview extends Model
{
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
        'our_response',
        'responded_at',
        'store_response_id',
    ];

    protected $casts = [
        'rating' => 'integer',
        'reviewed_at' => 'datetime',
        'responded_at' => 'datetime',
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
}
