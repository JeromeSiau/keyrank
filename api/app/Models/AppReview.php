<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppReview extends Model
{
    protected $fillable = [
        'app_id',
        'country',
        'review_id',
        'author',
        'title',
        'content',
        'rating',
        'version',
        'reviewed_at',
    ];

    protected $casts = [
        'rating' => 'integer',
        'reviewed_at' => 'datetime',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }
}
