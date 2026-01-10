<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class AlertRule extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'name',
        'type',
        'scope_type',
        'scope_id',
        'conditions',
        'is_template',
        'is_active',
        'priority',
    ];

    protected $casts = [
        'conditions' => 'array',
        'is_template' => 'boolean',
        'is_active' => 'boolean',
        'priority' => 'integer',
    ];

    public const TYPE_POSITION_CHANGE = 'position_change';
    public const TYPE_RATING_CHANGE = 'rating_change';
    public const TYPE_REVIEW_SPIKE = 'review_spike';
    public const TYPE_REVIEW_KEYWORD = 'review_keyword';
    public const TYPE_NEW_COMPETITOR = 'new_competitor';
    public const TYPE_COMPETITOR_PASSED = 'competitor_passed';
    public const TYPE_MASS_MOVEMENT = 'mass_movement';
    public const TYPE_KEYWORD_POPULARITY = 'keyword_popularity';
    public const TYPE_OPPORTUNITY = 'opportunity';

    public const SCOPE_GLOBAL = 'global';
    public const SCOPE_APP = 'app';
    public const SCOPE_CATEGORY = 'category';
    public const SCOPE_KEYWORD = 'keyword';

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function notifications(): HasMany
    {
        return $this->hasMany(Notification::class);
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function scopeForType($query, string $type)
    {
        return $query->where('type', $type);
    }

    public function scopeForUser($query, int $userId)
    {
        return $query->where('user_id', $userId);
    }
}
