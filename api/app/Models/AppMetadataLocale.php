<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppMetadataLocale extends Model
{
    protected $fillable = [
        'app_id',
        'locale',
        'title',
        'subtitle',
        'keywords',
        'description',
        'promotional_text',
        'whats_new',
        'asc_app_info_id',
        'asc_localization_id',
        'fetched_at',
    ];

    protected $casts = [
        'fetched_at' => 'datetime',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    /**
     * Get draft for this locale if exists
     */
    public function getDraftForUser(int $userId): ?AppMetadataDraft
    {
        return AppMetadataDraft::where('app_id', $this->app_id)
            ->where('locale', $this->locale)
            ->where('user_id', $userId)
            ->first();
    }

    /**
     * Check if this locale has complete metadata
     */
    public function isComplete(): bool
    {
        return !empty($this->title) && !empty($this->description);
    }

    /**
     * Get completion percentage
     */
    public function getCompletionPercentage(): int
    {
        $fields = ['title', 'subtitle', 'keywords', 'description'];
        $filled = 0;

        foreach ($fields as $field) {
            if (!empty($this->$field)) {
                $filled++;
            }
        }

        return (int) (($filled / count($fields)) * 100);
    }

    /**
     * Analyze keyword presence in metadata
     */
    public function analyzeKeywords(array $trackedKeywords): array
    {
        $analysis = [];
        $searchableText = strtolower(
            ($this->title ?? '') . ' ' .
            ($this->subtitle ?? '') . ' ' .
            ($this->keywords ?? '') . ' ' .
            ($this->description ?? '')
        );

        foreach ($trackedKeywords as $keyword) {
            $kw = strtolower($keyword['keyword'] ?? $keyword);
            $analysis[] = [
                'keyword' => $kw,
                'in_title' => str_contains(strtolower($this->title ?? ''), $kw),
                'in_subtitle' => str_contains(strtolower($this->subtitle ?? ''), $kw),
                'in_keywords' => str_contains(strtolower($this->keywords ?? ''), $kw),
                'in_description' => str_contains(strtolower($this->description ?? ''), $kw),
                'present' => str_contains($searchableText, $kw),
            ];
        }

        return $analysis;
    }

    // Scopes
    public function scopeForApp($query, int $appId)
    {
        return $query->where('app_id', $appId);
    }

    public function scopeForLocale($query, string $locale)
    {
        return $query->where('locale', $locale);
    }

    public function scopeComplete($query)
    {
        return $query->whereNotNull('title')->whereNotNull('description');
    }

    public function scopeIncomplete($query)
    {
        return $query->where(function ($q) {
            $q->whereNull('title')->orWhereNull('description');
        });
    }
}
