<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppAsoSnapshot extends Model
{
    protected $fillable = [
        'app_id',
        'country',
        'title',
        'subtitle',
        'description',
        'whats_new',
        'promotional_text',
        'title_length',
        'subtitle_length',
        'description_length',
        'keyword_density',
        'snapshot_at',
    ];

    protected $casts = [
        'title_length' => 'integer',
        'subtitle_length' => 'integer',
        'description_length' => 'integer',
        'keyword_density' => 'array',
        'snapshot_at' => 'datetime',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    public function scopeCountry($query, string $country)
    {
        return $query->where('country', $country);
    }

    public function scopeLatest($query)
    {
        return $query->orderByDesc('snapshot_at');
    }

    /**
     * Get the latest snapshot for an app in a country
     */
    public static function getLatest(int $appId, string $country = 'us'): ?self
    {
        return static::where('app_id', $appId)
            ->where('country', $country)
            ->orderByDesc('snapshot_at')
            ->first();
    }

    /**
     * Detect changes between two snapshots
     */
    public function diffFrom(AppAsoSnapshot $previous): array
    {
        $changes = [];

        if ($this->title !== $previous->title) {
            $changes['title'] = ['old' => $previous->title, 'new' => $this->title];
        }

        if ($this->subtitle !== $previous->subtitle) {
            $changes['subtitle'] = ['old' => $previous->subtitle, 'new' => $this->subtitle];
        }

        if ($this->description !== $previous->description) {
            $changes['description'] = true; // Just flag it changed, don't store full diff
        }

        if ($this->whats_new !== $previous->whats_new) {
            $changes['whats_new'] = ['old' => $previous->whats_new, 'new' => $this->whats_new];
        }

        return $changes;
    }
}
