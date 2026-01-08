<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppRanking extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'app_id',
        'keyword_id',
        'position',
        'recorded_at',
    ];

    protected $casts = [
        'position' => 'integer',
        'recorded_at' => 'date',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    public function keyword(): BelongsTo
    {
        return $this->belongsTo(Keyword::class);
    }

    /**
     * Get the previous day's ranking for comparison
     */
    public function getPreviousRanking(): ?self
    {
        return self::where('app_id', $this->app_id)
            ->where('keyword_id', $this->keyword_id)
            ->where('recorded_at', '<', $this->recorded_at)
            ->orderByDesc('recorded_at')
            ->first();
    }

    /**
     * Calculate position change compared to previous day
     */
    public function getChangeAttribute(): ?int
    {
        $previous = $this->getPreviousRanking();

        if (!$previous || $previous->position === null || $this->position === null) {
            return null;
        }

        return $previous->position - $this->position; // Positive = improved
    }
}
