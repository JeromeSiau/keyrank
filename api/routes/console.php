<?php

use App\Jobs\Collectors\RatingsCollector;
use App\Jobs\Collectors\ReviewsCollector;
use App\Jobs\Collectors\RankingsCollector;
use App\Jobs\Collectors\TopChartsCollector;
use App\Jobs\Collectors\AppDiscoveryCollector;
use App\Jobs\Collectors\SearchSuggestCollector;
use App\Jobs\Collectors\AppMetadataCollector;
use App\Jobs\Collectors\CategoryRankingCollector;
use App\Jobs\Collectors\AsoMetadataCollector;
use App\Jobs\Collectors\FeaturedAppsCollector;
// use App\Jobs\EnrichmentJob;  // Disabled - uses OpenRouter API
// use App\Jobs\InsightGeneratorJob;  // Disabled - uses OpenRouter API
use App\Jobs\RefreshAllKeywordSuggestionsJob;
use App\Jobs\SyncFunnelAnalyticsJob;
use App\Jobs\WeeklyDigestJob;
use Illuminate\Support\Facades\Schedule;

/*
|--------------------------------------------------------------------------
| Console Routes / Scheduled Tasks
|--------------------------------------------------------------------------
*/

// =============================================================================
// V2 Collectors - Background data collection (no on-demand fetching)
// =============================================================================

// Rankings collector - every 2 hours (runs on 'collectors' queue)
Schedule::job(new RankingsCollector())
    ->everyTwoHours()
    ->withoutOverlapping();

// Reviews collector - every 4 hours (runs on 'collectors' queue)
Schedule::job(new ReviewsCollector())
    ->everyFourHours()
    ->withoutOverlapping();

// Ratings collector - every 6 hours (runs on 'collectors' queue)
Schedule::job(new RatingsCollector())
    ->everySixHours()
    ->withoutOverlapping();

// Top Charts collector - daily at 4 AM (collects top 100 per category/country)
// Replaces legacy aso:daily-refresh for top apps
Schedule::job(new TopChartsCollector())
    ->dailyAt('04:00')
    ->withoutOverlapping();

// App Discovery collector - daily at 5 AM (discovers related apps, same developer)
Schedule::job(new AppDiscoveryCollector())
    ->dailyAt('05:00')
    ->withoutOverlapping();

// Search Suggest collector - Monday and Thursday at 2 AM (collects autocomplete suggestions)
Schedule::job(new SearchSuggestCollector())
    ->days([1, 4]) // Monday and Thursday
    ->at('02:00')
    ->withoutOverlapping();

// App Metadata collector - every 12 hours (tracks version, price, size changes)
Schedule::job(new AppMetadataCollector())
    ->twiceDaily(1, 13) // 1 AM and 1 PM
    ->withoutOverlapping();

// Category Ranking collector - daily at 4:30 AM (after TopChartsCollector)
// Tracks your apps' positions in their categories
Schedule::job(new CategoryRankingCollector())
    ->dailyAt('04:30')
    ->withoutOverlapping();

// ASO Metadata collector - weekly on Wednesday at 3 AM
// Snapshots ASO data (title, description, keywords) for tracked apps
Schedule::job(new AsoMetadataCollector())
    ->weeklyOn(3, '03:00')
    ->withoutOverlapping();

// Featured Apps collector - daily at 6 AM
// Detects apps featured by Apple/Google
Schedule::job(new FeaturedAppsCollector())
    ->dailyAt('06:00')
    ->withoutOverlapping();

// =============================================================================
// V2 AI & Intelligence Jobs (DISABLED - uses OpenRouter API = $$$)
// =============================================================================

// Review enrichment - hourly (sentiment, themes, language detection)
// WARNING: With 10k+ apps, this can cost $50-100+/month
// Schedule::job(new EnrichmentJob())
//     ->hourly()
//     ->withoutOverlapping();

// Insight generation - daily at 8:00 AM
// Uses AI to generate suggestions - lower volume but still costs
// Schedule::job(new InsightGeneratorJob())
//     ->dailyAt('08:00')
//     ->withoutOverlapping();

// Weekly digest email - Monday at 9:00 AM (NO AI - just emails)
Schedule::job(new WeeklyDigestJob())
    ->weeklyOn(1, '09:00')
    ->withoutOverlapping();

// =============================================================================
// Alert Digests (User-configured email notifications)
// =============================================================================

// Daily alert digest - runs hourly, sends to users whose digest_time matches
// Each user configures their preferred time in settings (default 09:00)
Schedule::command('alerts:send-digests --period=daily')
    ->hourly()
    ->withoutOverlapping()
    ->runInBackground();

// Weekly alert digest - runs hourly on configured days
// Each user configures their preferred day and time in settings
Schedule::command('alerts:send-digests --period=weekly')
    ->hourly()
    ->withoutOverlapping()
    ->runInBackground();

// Keyword suggestions refresh - weekly on Sunday at 2 AM
// Refreshes keyword suggestions for all apps using each app's storefront
Schedule::job(new RefreshAllKeywordSuggestionsJob())
    ->weeklyOn(0, '02:00')
    ->withoutOverlapping();

// =============================================================================
// Legacy commands (kept for backwards compatibility, can be removed)
// =============================================================================

// NOTE: aso:daily-refresh is now replaced by TopChartsCollector (4 AM)
// Keeping it disabled - uncomment only if you need the old behavior
// Schedule::command('aso:daily-refresh')
//     ->dailyAt('03:00')
//     ->withoutOverlapping()
//     ->runInBackground();

// Cleanup old data every Monday at 5 AM
// Aggregates daily → weekly (>90 days) and weekly → monthly (>1 year)
Schedule::command('aso:cleanup --days=90')
    ->weeklyOn(1, '05:00');

// Sync categories every Sunday at 3 AM
Schedule::command('categories:sync')
    ->weeklyOn(0, '03:00');

// Sync reviews from connected store accounts every 12 hours
// (Different from ReviewsCollector - this uses official API for owned apps)
Schedule::command('reviews:sync-connected')
    ->twiceDaily(3, 15)
    ->withoutOverlapping()
    ->runInBackground();

// NOTE: reviews:sync-all removed - now handled by ReviewsCollector (every 4 hours)

// Sync analytics from App Store Connect and Google Play daily at 6 AM
Schedule::command('analytics:sync-daily')
    ->dailyAt('06:00')
    ->withoutOverlapping()
    ->runInBackground();

// Compute analytics summaries after sync completes (6:30 AM)
Schedule::command('analytics:compute-summaries')
    ->dailyAt('06:30')
    ->withoutOverlapping();

// Sync conversion funnel data from store APIs (7 AM, after analytics sync)
// Fetches impressions, page views, and download data with source attribution
Schedule::job(new SyncFunnelAnalyticsJob(daysBack: 30))
    ->dailyAt('07:00')
    ->withoutOverlapping();
