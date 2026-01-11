<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class KeywordPopularityAggregate extends Model
{
    public $timestamps = false;

    protected $table = 'keyword_popularity_aggregates';

    protected $fillable = [
        'keyword_id',
        'period_type',
        'period_start',
        'avg_popularity',
        'min_popularity',
        'max_popularity',
        'data_points',
    ];

    protected $casts = [
        'avg_popularity' => 'float',
        'min_popularity' => 'integer',
        'max_popularity' => 'integer',
        'data_points' => 'integer',
        'period_start' => 'date',
    ];

    public function keyword(): BelongsTo
    {
        return $this->belongsTo(Keyword::class);
    }
}
