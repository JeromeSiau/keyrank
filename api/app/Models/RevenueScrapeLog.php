<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RevenueScrapeLog extends Model
{
    protected $fillable = [
        'source',
        'started_at',
        'completed_at',
        'status',
        'listings_found',
        'listings_new',
        'listings_updated',
        'listings_skipped',
        'error_message',
    ];

    protected $casts = [
        'started_at' => 'datetime',
        'completed_at' => 'datetime',
        'listings_found' => 'integer',
        'listings_new' => 'integer',
        'listings_updated' => 'integer',
        'listings_skipped' => 'integer',
    ];

    /**
     * Scope for a specific source
     */
    public function scopeForSource($query, string $source)
    {
        return $query->where('source', $source);
    }

    /**
     * Scope for successful runs
     */
    public function scopeSuccessful($query)
    {
        return $query->where('status', 'success');
    }

    /**
     * Scope for failed runs
     */
    public function scopeFailed($query)
    {
        return $query->where('status', 'failed');
    }

    /**
     * Scope for running jobs
     */
    public function scopeRunning($query)
    {
        return $query->where('status', 'running');
    }

    /**
     * Get duration in seconds
     */
    public function getDurationAttribute(): ?int
    {
        if (!$this->completed_at) {
            return null;
        }

        return $this->completed_at->diffInSeconds($this->started_at);
    }

    /**
     * Mark as completed with success
     */
    public function markSuccess(int $found, int $new, int $updated, int $skipped = 0): void
    {
        $this->update([
            'status' => 'success',
            'completed_at' => now(),
            'listings_found' => $found,
            'listings_new' => $new,
            'listings_updated' => $updated,
            'listings_skipped' => $skipped,
        ]);
    }

    /**
     * Mark as failed
     */
    public function markFailed(string $error): void
    {
        $this->update([
            'status' => 'failed',
            'completed_at' => now(),
            'error_message' => $error,
        ]);
    }

    /**
     * Start a new scrape log
     */
    public static function start(string $source): self
    {
        return self::create([
            'source' => $source,
            'started_at' => now(),
            'status' => 'running',
        ]);
    }
}
