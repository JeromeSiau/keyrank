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

// Sync reviews from connected store accounts every 12 hours
Schedule::command('reviews:sync-connected')
    ->twiceDaily(3, 15)
    ->withoutOverlapping()
    ->runInBackground();

// Sync public reviews (iTunes/Google Play) for all apps daily at 4 AM
Schedule::command('reviews:sync-all')
    ->dailyAt('04:00')
    ->withoutOverlapping()
    ->runInBackground();

// Sync analytics from App Store Connect and Google Play daily at 6 AM
Schedule::command('analytics:sync-daily')
    ->dailyAt('06:00')
    ->withoutOverlapping()
    ->runInBackground();

// Compute analytics summaries after sync completes (6:30 AM)
Schedule::command('analytics:compute-summaries')
    ->dailyAt('06:30')
    ->withoutOverlapping();
