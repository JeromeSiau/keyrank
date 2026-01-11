<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;

class JobExecution extends Model
{
    use HasFactory;

    public $timestamps = false;

    public const STATUS_RUNNING = 'running';
    public const STATUS_COMPLETED = 'completed';
    public const STATUS_FAILED = 'failed';

    protected $fillable = [
        'job_name',
        'status',
        'items_processed',
        'items_failed',
        'error_message',
        'started_at',
        'completed_at',
        'duration_ms',
    ];

    protected $casts = [
        'started_at' => 'datetime',
        'completed_at' => 'datetime',
        'items_processed' => 'integer',
        'items_failed' => 'integer',
        'duration_ms' => 'integer',
    ];

    /**
     * Start a new job execution
     */
    public static function start(string $jobName): self
    {
        return self::create([
            'job_name' => $jobName,
            'status' => self::STATUS_RUNNING,
            'started_at' => now(),
        ]);
    }

    /**
     * Mark job as completed
     */
    public function markCompleted(): void
    {
        $this->update([
            'status' => self::STATUS_COMPLETED,
            'completed_at' => now(),
            'duration_ms' => $this->started_at->diffInMilliseconds(now(), true),
        ]);
    }

    /**
     * Mark job as failed
     */
    public function markFailed(string $errorMessage): void
    {
        $this->update([
            'status' => self::STATUS_FAILED,
            'error_message' => substr($errorMessage, 0, 1000),
            'completed_at' => now(),
            'duration_ms' => $this->started_at->diffInMilliseconds(now(), true),
        ]);
    }

    /**
     * Increment processed items count
     */
    public function incrementProcessed(int $count = 1): void
    {
        $this->increment('items_processed', $count);
    }

    /**
     * Increment failed items count
     */
    public function incrementFailed(int $count = 1): void
    {
        $this->increment('items_failed', $count);
    }

    /**
     * Get the success rate as a percentage
     */
    public function getSuccessRateAttribute(): float
    {
        $total = $this->items_processed + $this->items_failed;
        if ($total === 0) {
            return 100.0;
        }

        return round(($this->items_processed / $total) * 100, 2);
    }

    /**
     * Get human-readable duration
     */
    public function getDurationHumanAttribute(): ?string
    {
        if (!$this->duration_ms) {
            return null;
        }

        $seconds = $this->duration_ms / 1000;
        if ($seconds < 60) {
            return round($seconds, 1) . 's';
        }

        $minutes = floor($seconds / 60);
        $remainingSeconds = $seconds % 60;

        return $minutes . 'm ' . round($remainingSeconds) . 's';
    }

    /**
     * Scope: filter by job name
     */
    public function scopeForJob(Builder $query, string $jobName): Builder
    {
        return $query->where('job_name', $jobName);
    }

    /**
     * Scope: running jobs
     */
    public function scopeRunning(Builder $query): Builder
    {
        return $query->where('status', self::STATUS_RUNNING);
    }

    /**
     * Scope: completed jobs
     */
    public function scopeCompleted(Builder $query): Builder
    {
        return $query->where('status', self::STATUS_COMPLETED);
    }

    /**
     * Scope: failed jobs
     */
    public function scopeFailed(Builder $query): Builder
    {
        return $query->where('status', self::STATUS_FAILED);
    }

    /**
     * Scope: recent executions
     */
    public function scopeRecent(Builder $query, int $days = 7): Builder
    {
        return $query->where('started_at', '>=', now()->subDays($days));
    }

    /**
     * Get the last execution for a specific job
     */
    public static function lastFor(string $jobName): ?self
    {
        return self::forJob($jobName)
            ->latest('started_at')
            ->first();
    }

    /**
     * Get the last successful execution for a specific job
     */
    public static function lastSuccessfulFor(string $jobName): ?self
    {
        return self::forJob($jobName)
            ->completed()
            ->latest('completed_at')
            ->first();
    }
}
