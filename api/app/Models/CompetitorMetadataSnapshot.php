<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CompetitorMetadataSnapshot extends Model
{
    protected $fillable = [
        'app_id',
        'locale',
        'title',
        'subtitle',
        'short_description',
        'description',
        'keywords',
        'whats_new',
        'version',
        'has_changes',
        'changed_fields',
        'scraped_at',
    ];

    protected $casts = [
        'has_changes' => 'boolean',
        'changed_fields' => 'array',
        'scraped_at' => 'datetime',
    ];

    /**
     * Get the app this snapshot belongs to.
     */
    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    /**
     * Scope to get snapshots with changes only.
     */
    public function scopeWithChanges($query)
    {
        return $query->where('has_changes', true);
    }

    /**
     * Scope to filter by locale.
     */
    public function scopeForLocale($query, string $locale)
    {
        return $query->where('locale', $locale);
    }

    /**
     * Scope to filter by app.
     */
    public function scopeForApp($query, int $appId)
    {
        return $query->where('app_id', $appId);
    }

    /**
     * Scope to get snapshots within a date range.
     */
    public function scopeInPeriod($query, $startDate, $endDate = null)
    {
        $query->where('scraped_at', '>=', $startDate);
        if ($endDate) {
            $query->where('scraped_at', '<=', $endDate);
        }
        return $query;
    }

    /**
     * Get the most recent snapshot for an app/locale.
     */
    public static function getLatest(int $appId, string $locale = 'en-US'): ?self
    {
        return self::forApp($appId)
            ->forLocale($locale)
            ->orderByDesc('scraped_at')
            ->first();
    }

    /**
     * Compare with another snapshot and return changed fields.
     */
    public function compareWith(self $previous): array
    {
        $changedFields = [];
        $comparableFields = ['title', 'subtitle', 'short_description', 'description', 'keywords', 'whats_new'];

        foreach ($comparableFields as $field) {
            $newValue = $this->$field;
            $oldValue = $previous->$field;

            // Normalize empty values
            $newNormalized = empty($newValue) ? null : trim($newValue);
            $oldNormalized = empty($oldValue) ? null : trim($oldValue);

            if ($newNormalized !== $oldNormalized) {
                $changedFields[] = [
                    'field' => $field,
                    'old_value' => $oldValue,
                    'new_value' => $newValue,
                ];
            }
        }

        return $changedFields;
    }

    /**
     * Compute diff for a single text field (word-level).
     */
    public function computeTextDiff(string $field, self $previous): array
    {
        $newText = $this->$field ?? '';
        $oldText = $previous->$field ?? '';

        // Simple diff: compute added/removed content
        $newWords = preg_split('/\s+/', $newText, -1, PREG_SPLIT_NO_EMPTY);
        $oldWords = preg_split('/\s+/', $oldText, -1, PREG_SPLIT_NO_EMPTY);

        $added = array_diff($newWords, $oldWords);
        $removed = array_diff($oldWords, $newWords);

        return [
            'added_words' => count($added),
            'removed_words' => count($removed),
            'char_diff' => strlen($newText) - strlen($oldText),
        ];
    }

    /**
     * Analyze keywords changes.
     */
    public function analyzeKeywordChanges(self $previous): array
    {
        $newKeywords = $this->parseKeywords($this->keywords);
        $oldKeywords = $this->parseKeywords($previous->keywords);

        return [
            'added' => array_values(array_diff($newKeywords, $oldKeywords)),
            'removed' => array_values(array_diff($oldKeywords, $newKeywords)),
            'unchanged' => array_values(array_intersect($newKeywords, $oldKeywords)),
        ];
    }

    /**
     * Parse comma-separated keywords into array.
     */
    private function parseKeywords(?string $keywords): array
    {
        if (empty($keywords)) {
            return [];
        }
        return array_map('trim', explode(',', strtolower($keywords)));
    }

    /**
     * Get a human-readable summary of changes.
     */
    public function getChangeSummary(): string
    {
        if (!$this->has_changes || empty($this->changed_fields)) {
            return 'No changes';
        }

        $count = count($this->changed_fields);
        $fields = implode(', ', $this->changed_fields);

        return "{$count} field(s) changed: {$fields}";
    }
}
