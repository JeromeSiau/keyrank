<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

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
        'difficulty',
        'difficulty_label',
        'competition',
        'top_competitors',
    ];

    protected $casts = [
        'is_favorite' => 'boolean',
        'favorited_at' => 'datetime',
        'created_at' => 'datetime',
        'difficulty' => 'integer',
        'competition' => 'integer',
        'top_competitors' => 'array',
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

    public function tags(): BelongsToMany
    {
        return $this->belongsToMany(Tag::class, 'tag_keyword')
            ->withTimestamps();
    }

    public function note(): HasOne
    {
        return $this->hasOne(Note::class);
    }
}
