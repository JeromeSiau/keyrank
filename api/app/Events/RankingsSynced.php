<?php

namespace App\Events;

use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Support\Collection;

class RankingsSynced
{
    use Dispatchable;

    public function __construct(
        public Collection $rankings
    ) {}
}
