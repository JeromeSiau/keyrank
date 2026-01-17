<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ReviewInsightMention extends Model
{
    use HasFactory;

    protected $fillable = [
        'review_insight_id',
        'app_review_id',
    ];

    public function insight(): BelongsTo
    {
        return $this->belongsTo(ReviewInsight::class, 'review_insight_id');
    }

    public function review(): BelongsTo
    {
        return $this->belongsTo(AppReview::class, 'app_review_id');
    }
}
