<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppAnalytics extends Model
{
    use HasFactory;

    protected $table = 'app_analytics';

    protected $fillable = [
        'app_id',
        'date',
        'country_code',
        'downloads',
        'updates',
        'revenue',
        'proceeds',
        'refunds',
        'subscribers_new',
        'subscribers_cancelled',
        'subscribers_active',
    ];

    protected $casts = [
        'date' => 'date',
        'downloads' => 'integer',
        'updates' => 'integer',
        'revenue' => 'decimal:2',
        'proceeds' => 'decimal:2',
        'refunds' => 'decimal:2',
        'subscribers_new' => 'integer',
        'subscribers_cancelled' => 'integer',
        'subscribers_active' => 'integer',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    /**
     * Scope to filter by date range
     */
    public function scopeForPeriod($query, string $period)
    {
        return match ($period) {
            '7d' => $query->where('date', '>=', now()->subDays(7)),
            '30d' => $query->where('date', '>=', now()->subDays(30)),
            '90d' => $query->where('date', '>=', now()->subDays(90)),
            'ytd' => $query->whereYear('date', now()->year),
            'all' => $query,
            default => $query->where('date', '>=', now()->subDays(30)),
        };
    }

    /**
     * Scope to aggregate by date (summing across countries)
     */
    public function scopeAggregatedByDate($query)
    {
        return $query->selectRaw('
            date,
            SUM(downloads) as downloads,
            SUM(updates) as updates,
            SUM(revenue) as revenue,
            SUM(proceeds) as proceeds,
            SUM(refunds) as refunds,
            SUM(subscribers_new) as subscribers_new,
            SUM(subscribers_cancelled) as subscribers_cancelled,
            MAX(subscribers_active) as subscribers_active
        ')->groupBy('date');
    }

    /**
     * Scope to aggregate by country
     */
    public function scopeAggregatedByCountry($query)
    {
        return $query->selectRaw('
            country_code,
            SUM(downloads) as downloads,
            SUM(revenue) as revenue,
            SUM(proceeds) as proceeds
        ')->groupBy('country_code');
    }
}
