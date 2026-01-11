<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppRankingAggregate extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'app_id',
        'keyword_id',
        'period_type',
        'period_start',
        'avg_position',
        'min_position',
        'max_position',
        'data_points',
    ];

    protected $casts = [
        'avg_position' => 'float',
        'min_position' => 'integer',
        'max_position' => 'integer',
        'data_points' => 'integer',
        'period_start' => 'date',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    public function keyword(): BelongsTo
    {
        return $this->belongsTo(Keyword::class);
    }
}
