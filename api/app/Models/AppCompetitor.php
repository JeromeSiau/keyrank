<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppCompetitor extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'user_id',
        'owner_app_id',
        'competitor_app_id',
        'source',
    ];

    protected $casts = [
        'created_at' => 'datetime',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function ownerApp(): BelongsTo
    {
        return $this->belongsTo(App::class, 'owner_app_id');
    }

    public function competitorApp(): BelongsTo
    {
        return $this->belongsTo(App::class, 'competitor_app_id');
    }
}
