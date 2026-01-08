<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class KeywordPopularityHistory extends Model
{
    public $timestamps = false;

    protected $table = 'keyword_popularity_history';

    protected $fillable = [
        'keyword_id',
        'popularity',
        'recorded_at',
    ];

    protected $casts = [
        'popularity' => 'integer',
        'recorded_at' => 'date',
    ];

    public function keyword(): BelongsTo
    {
        return $this->belongsTo(Keyword::class);
    }
}
