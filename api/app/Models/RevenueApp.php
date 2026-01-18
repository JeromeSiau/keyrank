<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RevenueApp extends Model
{
    protected $fillable = [
        'source',
        'source_id',
        'source_url',
        'app_name',
        'matched_app_id',
        'mrr_cents',
        'monthly_revenue_cents',
        'arr_cents',
        'annual_revenue_cents',
        'monthly_profit_cents',
        'active_subscribers',
        'active_trials',
        'active_users',
        'monthly_downloads',
        'total_downloads',
        'new_customers',
        'ltv_cents',
        'arpu_cents',
        'churn_rate',
        'growth_rate_mom',
        'apple_id',
        'bundle_id',
        'app_store_url',
        'play_store_url',
        'platform',
        'credential_type',
        'business_model',
        'category',
        'is_for_sale',
        'asking_price_cents',
        'revenue_verified',
        'ios_rating',
        'android_rating',
        'logo_url',
        'description',
        'scraped_at',
    ];

    protected $casts = [
        'mrr_cents' => 'integer',
        'monthly_revenue_cents' => 'integer',
        'arr_cents' => 'integer',
        'annual_revenue_cents' => 'integer',
        'monthly_profit_cents' => 'integer',
        'active_subscribers' => 'integer',
        'active_trials' => 'integer',
        'active_users' => 'integer',
        'monthly_downloads' => 'integer',
        'total_downloads' => 'integer',
        'new_customers' => 'integer',
        'ltv_cents' => 'integer',
        'arpu_cents' => 'integer',
        'churn_rate' => 'decimal:2',
        'growth_rate_mom' => 'decimal:2',
        'is_for_sale' => 'boolean',
        'asking_price_cents' => 'integer',
        'revenue_verified' => 'boolean',
        'ios_rating' => 'decimal:1',
        'android_rating' => 'decimal:1',
        'scraped_at' => 'datetime',
        'matched_app_id' => 'integer',
    ];

    /**
     * Get MRR in dollars
     */
    public function getMrrAttribute(): ?float
    {
        return $this->mrr_cents ? $this->mrr_cents / 100 : null;
    }

    /**
     * Get monthly revenue in dollars
     */
    public function getMonthlyRevenueAttribute(): ?float
    {
        return $this->monthly_revenue_cents ? $this->monthly_revenue_cents / 100 : null;
    }

    /**
     * Get ARR in dollars
     */
    public function getArrAttribute(): ?float
    {
        return $this->arr_cents ? $this->arr_cents / 100 : null;
    }

    /**
     * Get the matched app (explicit foreign key relation)
     */
    public function matchedApp(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(App::class, 'matched_app_id');
    }

    /**
     * Find linked App model by Apple ID or Bundle ID (for matching)
     */
    public function findMatchingApp(): ?App
    {
        if ($this->apple_id) {
            $app = App::where('store_id', $this->apple_id)
                ->where('platform', 'ios')
                ->first();
            if ($app) {
                return $app;
            }
        }

        if ($this->bundle_id) {
            $app = App::where('bundle_id', $this->bundle_id)
                ->where('platform', 'android')
                ->first();
            if ($app) {
                return $app;
            }
        }

        return null;
    }

    /**
     * Get LTV in dollars
     */
    public function getLtvAttribute(): ?float
    {
        return $this->ltv_cents ? $this->ltv_cents / 100 : null;
    }

    /**
     * Get ARPU in dollars
     */
    public function getArpuAttribute(): ?float
    {
        return $this->arpu_cents ? $this->arpu_cents / 100 : null;
    }

    /**
     * Get annual revenue in dollars
     */
    public function getAnnualRevenueAttribute(): ?float
    {
        return $this->annual_revenue_cents ? $this->annual_revenue_cents / 100 : null;
    }

    /**
     * Get monthly profit in dollars
     */
    public function getMonthlyProfitAttribute(): ?float
    {
        return $this->monthly_profit_cents ? $this->monthly_profit_cents / 100 : null;
    }

    /**
     * Get asking price in dollars
     */
    public function getAskingPriceAttribute(): ?float
    {
        return $this->asking_price_cents ? $this->asking_price_cents / 100 : null;
    }

    /**
     * Scope for verified revenue
     */
    public function scopeVerified($query)
    {
        return $query->where('revenue_verified', true);
    }

    /**
     * Scope for apps with MRR
     */
    public function scopeWithMrr($query)
    {
        return $query->whereNotNull('mrr_cents')->where('mrr_cents', '>', 0);
    }

    /**
     * Scope by source
     */
    public function scopeFromSource($query, string $source)
    {
        return $query->where('source', $source);
    }

    /**
     * Scope by platform
     */
    public function scopeForPlatform($query, string $platform)
    {
        return $query->where('platform', $platform)
            ->orWhere('platform', 'both');
    }
}
