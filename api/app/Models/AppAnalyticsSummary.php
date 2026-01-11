<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppAnalyticsSummary extends Model
{
    use HasFactory;

    protected $table = 'app_analytics_summaries';

    protected $fillable = [
        'app_id',
        'period',
        'total_downloads',
        'total_revenue',
        'total_proceeds',
        'active_subscribers',
        'downloads_change_pct',
        'revenue_change_pct',
        'subscribers_change_pct',
        'computed_at',
    ];

    protected $casts = [
        'total_downloads' => 'integer',
        'total_revenue' => 'decimal:2',
        'total_proceeds' => 'decimal:2',
        'active_subscribers' => 'integer',
        'downloads_change_pct' => 'decimal:2',
        'revenue_change_pct' => 'decimal:2',
        'subscribers_change_pct' => 'decimal:2',
        'computed_at' => 'datetime',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }
}
