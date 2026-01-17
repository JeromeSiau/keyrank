<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppFunnelAnalytics extends Model
{
    use HasFactory;

    protected $table = 'app_funnel_analytics';

    protected $fillable = [
        'app_id',
        'date',
        'country_code',
        'source',
        'impressions',
        'impressions_unique',
        'page_views',
        'page_views_unique',
        'downloads',
        'first_time_downloads',
        'redownloads',
        'conversion_rate',
    ];

    protected $casts = [
        'date' => 'date',
        'impressions' => 'integer',
        'impressions_unique' => 'integer',
        'page_views' => 'integer',
        'page_views_unique' => 'integer',
        'downloads' => 'integer',
        'first_time_downloads' => 'integer',
        'redownloads' => 'integer',
        'conversion_rate' => 'decimal:2',
    ];

    /**
     * Source type constants
     */
    public const SOURCE_TOTAL = 'total';
    public const SOURCE_SEARCH = 'search';
    public const SOURCE_BROWSE = 'browse';
    public const SOURCE_REFERRAL = 'referral';
    public const SOURCE_APP_REFERRER = 'app_referrer';
    public const SOURCE_WEB_REFERRER = 'web_referrer';

    /**
     * Source labels for display
     */
    public static function sourceLabels(): array
    {
        return [
            self::SOURCE_SEARCH => 'App Store Search',
            self::SOURCE_BROWSE => 'Browse',
            self::SOURCE_REFERRAL => 'Referrals',
            self::SOURCE_APP_REFERRER => 'App Referrer',
            self::SOURCE_WEB_REFERRER => 'Web Referrer',
            self::SOURCE_TOTAL => 'All Sources',
        ];
    }

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
     * Scope to filter by date range with explicit dates
     */
    public function scopeForDateRange($query, string $startDate, string $endDate)
    {
        return $query->whereBetween('date', [$startDate, $endDate]);
    }

    /**
     * Scope to filter by source
     */
    public function scopeBySource($query, ?string $source)
    {
        if ($source && $source !== 'all') {
            return $query->where('source', $source);
        }
        return $query;
    }

    /**
     * Scope to filter by country
     */
    public function scopeByCountry($query, ?string $country)
    {
        if ($country && $country !== 'all') {
            return $query->where('country_code', $country);
        }
        return $query;
    }

    /**
     * Scope to get only total (aggregated) records
     */
    public function scopeTotalsOnly($query)
    {
        return $query->where('source', self::SOURCE_TOTAL);
    }

    /**
     * Scope to get by source breakdown (excluding total)
     */
    public function scopeBySourceBreakdown($query)
    {
        return $query->where('source', '!=', self::SOURCE_TOTAL);
    }

    /**
     * Scope to aggregate by date (summing across countries)
     */
    public function scopeAggregatedByDate($query)
    {
        return $query->selectRaw('
            date,
            SUM(impressions) as impressions,
            SUM(impressions_unique) as impressions_unique,
            SUM(page_views) as page_views,
            SUM(page_views_unique) as page_views_unique,
            SUM(downloads) as downloads,
            SUM(first_time_downloads) as first_time_downloads,
            SUM(redownloads) as redownloads
        ')->groupBy('date');
    }

    /**
     * Scope to aggregate by source
     */
    public function scopeAggregatedBySource($query)
    {
        return $query->selectRaw('
            source,
            SUM(impressions) as impressions,
            SUM(impressions_unique) as impressions_unique,
            SUM(page_views) as page_views,
            SUM(page_views_unique) as page_views_unique,
            SUM(downloads) as downloads,
            SUM(first_time_downloads) as first_time_downloads,
            SUM(redownloads) as redownloads
        ')->groupBy('source');
    }

    /**
     * Scope to aggregate totals
     */
    public function scopeAggregatedTotals($query)
    {
        return $query->selectRaw('
            SUM(impressions) as impressions,
            SUM(impressions_unique) as impressions_unique,
            SUM(page_views) as page_views,
            SUM(page_views_unique) as page_views_unique,
            SUM(downloads) as downloads,
            SUM(first_time_downloads) as first_time_downloads,
            SUM(redownloads) as redownloads
        ');
    }

    /**
     * Calculate conversion rate (impressions to downloads)
     */
    public function getCalculatedConversionRateAttribute(): ?float
    {
        if ($this->impressions > 0) {
            return round(($this->downloads / $this->impressions) * 100, 2);
        }
        return null;
    }

    /**
     * Calculate impression to page view rate
     */
    public function getImpressionToPageViewRateAttribute(): ?float
    {
        if ($this->impressions > 0) {
            return round(($this->page_views / $this->impressions) * 100, 2);
        }
        return null;
    }

    /**
     * Calculate page view to download rate
     */
    public function getPageViewToDownloadRateAttribute(): ?float
    {
        if ($this->page_views > 0) {
            return round(($this->downloads / $this->page_views) * 100, 2);
        }
        return null;
    }

    /**
     * Get source label
     */
    public function getSourceLabelAttribute(): string
    {
        return self::sourceLabels()[$this->source] ?? ucfirst($this->source);
    }
}
