<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppInsight extends Model
{
    protected $fillable = [
        'app_id', 'analysis_type', 'reviews_count', 'countries',
        'period_start', 'period_end', 'category_scores', 'category_summaries',
        'emergent_themes', 'overall_strengths', 'overall_weaknesses',
        'opportunities', 'raw_llm_response',
    ];

    protected $casts = [
        'countries' => 'array',
        'category_scores' => 'array',
        'category_summaries' => 'array',
        'emergent_themes' => 'array',
        'overall_strengths' => 'array',
        'overall_weaknesses' => 'array',
        'opportunities' => 'array',
        'period_start' => 'date',
        'period_end' => 'date',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }
}
