<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RevenueApp extends Model
{
    protected $fillable = [
        'source',
        'source_id',
        'app_name',
        'mrr_cents',
        'monthly_revenue_cents',
        'arr_cents',
        'active_subscribers',
        'active_trials',
        'monthly_downloads',
        'new_customers',
        'apple_id',
        'bundle_id',
        'app_store_url',
        'play_store_url',
        'platform',
        'credential_type',
        'business_model',
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
        'active_subscribers' => 'integer',
        'active_trials' => 'integer',
        'monthly_downloads' => 'integer',
        'new_customers' => 'integer',
        'is_for_sale' => 'boolean',
        'asking_price_cents' => 'integer',
        'revenue_verified' => 'boolean',
        'ios_rating' => 'decimal:1',
        'android_rating' => 'decimal:1',
        'scraped_at' => 'datetime',
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
     * Find linked App model by Apple ID or Bundle ID
     */
    public function linkedApp(): ?\Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        if ($this->apple_id) {
            $app = App::where('store_id', $this->apple_id)
                ->where('platform', 'ios')
                ->first();
            if ($app) {
                return $this->belongsTo(App::class)->withDefault($app);
            }
        }

        if ($this->bundle_id) {
            $app = App::where('bundle_id', $this->bundle_id)
                ->where('platform', 'android')
                ->first();
            if ($app) {
                return $this->belongsTo(App::class)->withDefault($app);
            }
        }

        return null;
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
