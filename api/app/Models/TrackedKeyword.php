<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class TrackedKeyword extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'user_id',
        'app_id',
        'keyword_id',
        'is_favorite',
        'favorited_at',
        'created_at',
    ];

    protected $casts = [
        'is_favorite' => 'boolean',
        'favorited_at' => 'datetime',
        'created_at' => 'datetime',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    public function keyword(): BelongsTo
    {
        return $this->belongsTo(Keyword::class);
    }
}
