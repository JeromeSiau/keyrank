<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    protected $fillable = [
        'platform',
        'store_id',
        'name',
    ];

    public function scopePlatform($query, string $platform)
    {
        return $query->where('platform', $platform);
    }

    public function scopeIos($query)
    {
        return $query->platform('ios');
    }

    public function scopeAndroid($query)
    {
        return $query->platform('android');
    }
}
