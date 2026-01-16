<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Builder;

class AppCompetitor extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'user_id',
        'owner_app_id',
        'competitor_app_id',
        'source',
    ];

    protected $casts = [
        'created_at' => 'datetime',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function ownerApp(): BelongsTo
    {
        return $this->belongsTo(App::class, 'owner_app_id');
    }

    public function competitorApp(): BelongsTo
    {
        return $this->belongsTo(App::class, 'competitor_app_id');
    }

    /**
     * Scope for global competitors (not linked to any specific app).
     */
    public function scopeGlobal(Builder $query): Builder
    {
        return $query->whereNull('owner_app_id');
    }

    /**
     * Scope for contextual competitors (linked to a specific app).
     */
    public function scopeContextual(Builder $query): Builder
    {
        return $query->whereNotNull('owner_app_id');
    }

    /**
     * Scope for competitors of a specific owner app.
     */
    public function scopeForOwnerApp(Builder $query, int $ownerAppId): Builder
    {
        return $query->where('owner_app_id', $ownerAppId);
    }

    /**
     * Check if this is a global competitor.
     */
    public function isGlobal(): bool
    {
        return $this->owner_app_id === null;
    }
}
