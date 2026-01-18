<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RevenueSkippedUrl extends Model
{
    protected $fillable = [
        'source',
        'url',
        'reason',
        'checked_at',
    ];

    protected $casts = [
        'checked_at' => 'datetime',
    ];
}
