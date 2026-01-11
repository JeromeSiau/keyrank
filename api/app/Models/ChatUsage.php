<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ChatUsage extends Model
{
    use HasFactory;

    protected $table = 'chat_usage';

    protected $fillable = [
        'user_id',
        'month',
        'questions_count',
        'tokens_used',
    ];

    protected $casts = [
        'questions_count' => 'integer',
        'tokens_used' => 'integer',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public static function getCurrentMonth(): string
    {
        return now()->format('Y-m');
    }

    public static function getOrCreateForUser(int $userId): self
    {
        return self::firstOrCreate(
            ['user_id' => $userId, 'month' => self::getCurrentMonth()],
            ['questions_count' => 0, 'tokens_used' => 0]
        );
    }

    public function incrementUsage(int $tokens = 0): void
    {
        $this->increment('questions_count');
        if ($tokens > 0) {
            $this->increment('tokens_used', $tokens);
        }
    }
}
