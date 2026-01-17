<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppVoiceSetting extends Model
{
    protected $fillable = [
        'app_id',
        'team_id',
        'tone_description',
        'default_language',
        'signature',
    ];

    protected $attributes = [
        'default_language' => 'auto',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    public function team(): BelongsTo
    {
        return $this->belongsTo(Team::class);
    }
}
