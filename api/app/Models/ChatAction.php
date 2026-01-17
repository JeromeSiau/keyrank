<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ChatAction extends Model
{
    protected $fillable = [
        'message_id',
        'type',
        'parameters',
        'status',
        'explanation',
        'reversible',
        'result',
    ];

    protected $casts = [
        'parameters' => 'array',
        'result' => 'array',
        'reversible' => 'boolean',
    ];

    // Action types (match tool function names - snake_case)
    public const TYPE_ADD_KEYWORDS = 'add_keywords';
    public const TYPE_REMOVE_KEYWORDS = 'remove_keywords';
    public const TYPE_CREATE_ALERT = 'create_alert';
    public const TYPE_ADD_COMPETITOR = 'add_competitor';
    public const TYPE_EXPORT_DATA = 'export_data';

    // Statuses
    public const STATUS_PROPOSED = 'proposed';
    public const STATUS_CONFIRMED = 'confirmed';
    public const STATUS_CANCELLED = 'cancelled';
    public const STATUS_EXECUTED = 'executed';
    public const STATUS_FAILED = 'failed';

    public static array $validTypes = [
        self::TYPE_ADD_KEYWORDS,
        self::TYPE_REMOVE_KEYWORDS,
        self::TYPE_CREATE_ALERT,
        self::TYPE_ADD_COMPETITOR,
        self::TYPE_EXPORT_DATA,
    ];

    public static array $validStatuses = [
        self::STATUS_PROPOSED,
        self::STATUS_CONFIRMED,
        self::STATUS_CANCELLED,
        self::STATUS_EXECUTED,
        self::STATUS_FAILED,
    ];

    public function message(): BelongsTo
    {
        return $this->belongsTo(ChatMessage::class, 'message_id');
    }

    public function isProposed(): bool
    {
        return $this->status === self::STATUS_PROPOSED;
    }

    public function isExecuted(): bool
    {
        return $this->status === self::STATUS_EXECUTED;
    }

    public function isCancelled(): bool
    {
        return $this->status === self::STATUS_CANCELLED;
    }

    public function isFailed(): bool
    {
        return $this->status === self::STATUS_FAILED;
    }

    public function canExecute(): bool
    {
        return $this->status === self::STATUS_PROPOSED || $this->status === self::STATUS_CONFIRMED;
    }

    public function markAsExecuted(array $result): void
    {
        $this->update([
            'status' => self::STATUS_EXECUTED,
            'result' => $result,
        ]);
    }

    public function markAsFailed(string $error): void
    {
        $this->update([
            'status' => self::STATUS_FAILED,
            'result' => ['error' => $error],
        ]);
    }

    public function markAsCancelled(): void
    {
        $this->update(['status' => self::STATUS_CANCELLED]);
    }

    /**
     * Get display name for the action type
     */
    public function getDisplayName(): string
    {
        return match ($this->type) {
            self::TYPE_ADD_KEYWORDS => 'Add Keywords',
            self::TYPE_REMOVE_KEYWORDS => 'Remove Keywords',
            self::TYPE_CREATE_ALERT => 'Create Alert',
            self::TYPE_ADD_COMPETITOR => 'Add Competitor',
            self::TYPE_EXPORT_DATA => 'Export Data',
            default => ucfirst(str_replace('_', ' ', $this->type)),
        };
    }

    /**
     * Get icon for the action type
     */
    public function getIcon(): string
    {
        return match ($this->type) {
            self::TYPE_ADD_KEYWORDS => '🎯',
            self::TYPE_REMOVE_KEYWORDS => '🗑️',
            self::TYPE_CREATE_ALERT => '🔔',
            self::TYPE_ADD_COMPETITOR => '👀',
            self::TYPE_EXPORT_DATA => '📥',
            default => '⚡',
        };
    }
}
