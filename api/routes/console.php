<?php

use Illuminate\Support\Facades\Schedule;

/*
|--------------------------------------------------------------------------
| Console Routes / Scheduled Tasks
|--------------------------------------------------------------------------
*/

// Daily ASO refresh - dispatches chained jobs to queue
// Jobs run sequentially: top-apps → user-apps → rankings → suggestions
Schedule::command('aso:daily-refresh')
    ->dailyAt('03:00')
    ->withoutOverlapping()
    ->runInBackground();

// Cleanup old data every Monday at 5 AM
Schedule::command('aso:cleanup --days=90')
    ->weeklyOn(1, '05:00');

// Sync categories every Sunday at 3 AM
Schedule::command('categories:sync')
    ->weeklyOn(0, '03:00');
