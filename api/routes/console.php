<?php

use Illuminate\Support\Facades\Schedule;

/*
|--------------------------------------------------------------------------
| Console Routes / Scheduled Tasks
|--------------------------------------------------------------------------
*/

// Sync rankings every day at 4 AM
Schedule::command('aso:sync-rankings')
    ->dailyAt('04:00')
    ->withoutOverlapping()
    ->runInBackground();

// Cleanup old data every Monday at 5 AM
Schedule::command('aso:cleanup --days=90')
    ->weeklyOn(1, '05:00');
