<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasManyThrough;

class ReviewInsight extends Model
{
    use HasFactory;

    protected $fillable = [
        'app_id',
        'type',
        'title',
        'description',
        'keywords',
        'mention_count',
        'priority',
        'status',
        'platform',
        'affected_version',
        'first_mentioned_at',
        'last_mentioned_at',
    ];

    protected $casts = [
        'keywords' => 'array',
        'mention_count' => 'integer',
        'first_mentioned_at' => 'date',
        'last_mentioned_at' => 'date',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    public function mentions(): HasMany
    {
        return $this->hasMany(ReviewInsightMention::class);
    }

    public function reviews(): HasManyThrough
    {
        return $this->hasManyThrough(
            AppReview::class,
            ReviewInsightMention::class,
            'review_insight_id',
            'id',
            'id',
            'app_review_id'
        );
    }

    public function scopeFeatureRequests($query)
    {
        return $query->where('type', 'feature_request');
    }

    public function scopeBugReports($query)
    {
        return $query->where('type', 'bug_report');
    }

    public function scopeOpen($query)
    {
        return $query->where('status', 'open');
    }

    public function scopePlanned($query)
    {
        return $query->where('status', 'planned');
    }

    public function scopeResolved($query)
    {
        return $query->where('status', 'resolved');
    }

    public function scopeHighPriority($query)
    {
        return $query->whereIn('priority', ['high', 'critical']);
    }

    public function scopeCritical($query)
    {
        return $query->where('priority', 'critical');
    }

    public function scopeByPlatform($query, string $platform)
    {
        return $query->where('platform', $platform);
    }

    public function isOpen(): bool
    {
        return $this->status === 'open';
    }

    public function isHighPriority(): bool
    {
        return in_array($this->priority, ['high', 'critical']);
    }
}
