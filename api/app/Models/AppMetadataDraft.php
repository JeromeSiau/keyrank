<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppMetadataDraft extends Model
{
    protected $fillable = [
        'app_id',
        'user_id',
        'locale',
        'title',
        'subtitle',
        'keywords',
        'description',
        'promotional_text',
        'whats_new',
        'status',
        'last_published_at',
        'submitted_at',
        'changed_fields',
    ];

    protected $casts = [
        'last_published_at' => 'datetime',
        'submitted_at' => 'datetime',
        'changed_fields' => 'array',
    ];

    // Character limits per platform
    public const LIMITS = [
        'ios' => [
            'title' => 30,
            'subtitle' => 30,
            'keywords' => 100,
            'description' => 4000,
            'promotional_text' => 170,
            'whats_new' => 4000,
        ],
        'android' => [
            'title' => 30, // Google Play title limit
            'subtitle' => 80, // Short description
            'keywords' => 0, // Google Play doesn't have keywords
            'description' => 4000,
            'promotional_text' => 0, // Google Play doesn't have promotional text
            'whats_new' => 500, // Release notes limit
        ],
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the live metadata for comparison
     */
    public function liveMetadata(): ?AppMetadataLocale
    {
        return AppMetadataLocale::where('app_id', $this->app_id)
            ->where('locale', $this->locale)
            ->first();
    }

    /**
     * Calculate which fields have changed from live
     */
    public function calculateChangedFields(): array
    {
        $live = $this->liveMetadata();
        if (!$live) {
            return ['title', 'subtitle', 'keywords', 'description', 'promotional_text', 'whats_new'];
        }

        $changed = [];
        $fields = ['title', 'subtitle', 'keywords', 'description', 'promotional_text', 'whats_new'];

        foreach ($fields as $field) {
            if ($this->$field !== null && $this->$field !== $live->$field) {
                $changed[] = $field;
            }
        }

        return $changed;
    }

    /**
     * Check if draft has unsaved changes compared to live
     */
    public function hasDraftChanges(): bool
    {
        return !empty($this->calculateChangedFields());
    }

    /**
     * Get character limits for this app's platform
     */
    public function getLimits(): array
    {
        $platform = $this->app?->platform ?? 'ios';
        return self::LIMITS[$platform] ?? self::LIMITS['ios'];
    }

    /**
     * Validate metadata against character limits
     */
    public function validate(): array
    {
        $errors = [];
        $limits = $this->getLimits();

        foreach ($limits as $field => $limit) {
            if ($this->$field && mb_strlen($this->$field) > $limit) {
                $errors[$field] = "Exceeds {$limit} character limit";
            }
        }

        return $errors;
    }

    // Scopes
    public function scopeForApp($query, int $appId)
    {
        return $query->where('app_id', $appId);
    }

    public function scopeForUser($query, int $userId)
    {
        return $query->where('user_id', $userId);
    }

    public function scopeForLocale($query, string $locale)
    {
        return $query->where('locale', $locale);
    }

    public function scopeDrafts($query)
    {
        return $query->where('status', 'draft');
    }

    public function scopePendingReview($query)
    {
        return $query->where('status', 'pending_review');
    }
}
