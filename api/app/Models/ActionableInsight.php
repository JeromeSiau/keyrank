<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ActionableInsight extends Model
{
    public const TYPE_OPPORTUNITY = 'opportunity';
    public const TYPE_WARNING = 'warning';
    public const TYPE_WIN = 'win';
    public const TYPE_COMPETITOR_MOVE = 'competitor_move';
    public const TYPE_THEME = 'theme';
    public const TYPE_SUGGESTION = 'suggestion';

    public const PRIORITY_HIGH = 'high';
    public const PRIORITY_MEDIUM = 'medium';
    public const PRIORITY_LOW = 'low';

    protected $fillable = [
        'user_id',
        'app_id',
        'type',
        'priority',
        'title',
        'description',
        'action_text',
        'action_url',
        'data_refs',
        'is_read',
        'is_dismissed',
        'generated_at',
        'expires_at',
    ];

    protected $casts = [
        'data_refs' => 'array',
        'is_read' => 'boolean',
        'is_dismissed' => 'boolean',
        'generated_at' => 'datetime',
        'expires_at' => 'datetime',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    // Scopes

    public function scopeUnread(Builder $query): Builder
    {
        return $query->where('is_read', false);
    }

    public function scopeUndismissed(Builder $query): Builder
    {
        return $query->where('is_dismissed', false);
    }

    public function scopeActive(Builder $query): Builder
    {
        return $query->undismissed()
            ->where(function ($q) {
                $q->whereNull('expires_at')
                    ->orWhere('expires_at', '>', now());
            });
    }

    public function scopeOfType(Builder $query, string $type): Builder
    {
        return $query->where('type', $type);
    }

    public function scopeHighPriority(Builder $query): Builder
    {
        return $query->where('priority', self::PRIORITY_HIGH);
    }

    public function scopeForUser(Builder $query, int $userId): Builder
    {
        return $query->where('user_id', $userId);
    }

    public function scopeForApp(Builder $query, int $appId): Builder
    {
        return $query->where('app_id', $appId);
    }

    public function scopeRecent(Builder $query, int $days = 7): Builder
    {
        return $query->where('generated_at', '>=', now()->subDays($days));
    }

    // Methods

    public function markAsRead(): void
    {
        $this->update(['is_read' => true]);
    }

    public function dismiss(): void
    {
        $this->update(['is_dismissed' => true]);
    }

    public function isExpired(): bool
    {
        return $this->expires_at !== null && $this->expires_at->isPast();
    }

    public function isActionable(): bool
    {
        return $this->action_url !== null;
    }

    /**
     * Create an opportunity insight
     */
    public static function createOpportunity(
        int $userId,
        string $title,
        string $description,
        ?int $appId = null,
        string $priority = self::PRIORITY_MEDIUM,
        ?string $actionText = null,
        ?string $actionUrl = null,
        ?array $dataRefs = null,
    ): self {
        return self::create([
            'user_id' => $userId,
            'app_id' => $appId,
            'type' => self::TYPE_OPPORTUNITY,
            'priority' => $priority,
            'title' => $title,
            'description' => $description,
            'action_text' => $actionText,
            'action_url' => $actionUrl,
            'data_refs' => $dataRefs,
            'generated_at' => now(),
        ]);
    }

    /**
     * Create a warning insight
     */
    public static function createWarning(
        int $userId,
        string $title,
        string $description,
        ?int $appId = null,
        string $priority = self::PRIORITY_HIGH,
        ?string $actionText = null,
        ?string $actionUrl = null,
        ?array $dataRefs = null,
    ): self {
        return self::create([
            'user_id' => $userId,
            'app_id' => $appId,
            'type' => self::TYPE_WARNING,
            'priority' => $priority,
            'title' => $title,
            'description' => $description,
            'action_text' => $actionText,
            'action_url' => $actionUrl,
            'data_refs' => $dataRefs,
            'generated_at' => now(),
        ]);
    }

    /**
     * Create a win insight
     */
    public static function createWin(
        int $userId,
        string $title,
        string $description,
        ?int $appId = null,
        ?string $actionText = null,
        ?string $actionUrl = null,
        ?array $dataRefs = null,
    ): self {
        return self::create([
            'user_id' => $userId,
            'app_id' => $appId,
            'type' => self::TYPE_WIN,
            'priority' => self::PRIORITY_MEDIUM,
            'title' => $title,
            'description' => $description,
            'action_text' => $actionText,
            'action_url' => $actionUrl,
            'data_refs' => $dataRefs,
            'generated_at' => now(),
        ]);
    }

    /**
     * Create a suggestion insight
     */
    public static function createSuggestion(
        int $userId,
        string $title,
        string $description,
        ?int $appId = null,
        string $priority = self::PRIORITY_MEDIUM,
        ?string $actionText = null,
        ?string $actionUrl = null,
        ?array $dataRefs = null,
    ): self {
        return self::create([
            'user_id' => $userId,
            'app_id' => $appId,
            'type' => self::TYPE_SUGGESTION,
            'priority' => $priority,
            'title' => $title,
            'description' => $description,
            'action_text' => $actionText,
            'action_url' => $actionUrl,
            'data_refs' => $dataRefs,
            'generated_at' => now(),
        ]);
    }
}
