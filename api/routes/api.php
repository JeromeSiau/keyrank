<?php

use App\Http\Controllers\Api\AlertPreferencesController;
use App\Http\Controllers\Api\AlertRulesController;
use App\Http\Controllers\Api\AnalyticsController;
use App\Http\Controllers\Api\ApiKeyController;
use App\Http\Controllers\Api\AppController;
use App\Http\Controllers\Api\BillingController;
use App\Http\Controllers\Api\ChatController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\CompetitorController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\ExportController;
use App\Http\Controllers\Api\InsightsController;
use App\Http\Controllers\Api\ActionableInsightsController;
use App\Http\Controllers\Api\IntegrationsController;
use App\Http\Controllers\Api\KeywordController;
use App\Http\Controllers\Api\NotificationsController;
use App\Http\Controllers\Api\OnboardingController;
use App\Http\Controllers\Api\PublicApiController;
use App\Http\Controllers\Api\RankingController;
use App\Http\Controllers\Api\RatingsController;
use App\Http\Controllers\Api\ReviewsController;
use App\Http\Controllers\Api\NotesController;
use App\Http\Controllers\Api\StoreConnectionController;
use App\Http\Controllers\Api\SyncController;
use App\Http\Controllers\Api\TagsController;
use App\Http\Controllers\Api\UserPreferencesController;
use App\Http\Controllers\Api\VoiceSettingsController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// Public routes
Route::prefix('auth')->group(function () {
    Route::post('register', [AuthController::class, 'register'])->middleware('throttle:10,1');
    Route::post('login', [AuthController::class, 'login'])->middleware('throttle:10,1');
});

// Public utility routes
Route::get('countries', [DashboardController::class, 'countries']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {

    // Reviews inbox (all apps)
    Route::get('reviews/inbox', [ReviewsController::class, 'inbox']);

    // Auth
    Route::prefix('auth')->group(function () {
        Route::post('logout', [AuthController::class, 'logout']);
        Route::get('me', [AuthController::class, 'me']);
    });

    // User Preferences
    Route::prefix('user')->group(function () {
        Route::get('preferences', [UserPreferencesController::class, 'show']);
        Route::put('preferences', [UserPreferencesController::class, 'update']);
        Route::put('fcm-token', [UserPreferencesController::class, 'updateFcmToken']);
    });

    // Dashboard
    Route::prefix('dashboard')->group(function () {
        Route::get('overview', [DashboardController::class, 'overview']);
        Route::get('metrics', [DashboardController::class, 'metrics']);
        Route::get('movers', [DashboardController::class, 'movers']);
    });

    // Apps
    Route::prefix('apps')->group(function () {
        // Preview (no ownership required)
        Route::get('preview/{platform}/{storeId}', [AppController::class, 'preview'])
            ->where('platform', 'ios|android')
            ->middleware('throttle:60,1');
    });

    Route::prefix('apps')->middleware('owns.app')->group(function () {
        Route::get('/', [AppController::class, 'index']);
        Route::get('search', [AppController::class, 'search'])->middleware('throttle:60,1');
        Route::get('search/android', [AppController::class, 'searchAndroid'])->middleware('throttle:60,1');
        Route::post('/', [AppController::class, 'store'])->middleware('plan.limit:apps');
        Route::get('{app}', [AppController::class, 'show']);
        Route::delete('{app}', [AppController::class, 'destroy']);
        Route::post('{app}/refresh', [AppController::class, 'refresh']);
        Route::post('{app}/refresh-data', [AppController::class, 'refreshData']);
        Route::patch('{app}/favorite', [AppController::class, 'toggleFavorite']);
        Route::get('{app}/developer-apps', [AppController::class, 'developerApps']);

        // Competitors for app
        Route::get('{app}/competitors', [CompetitorController::class, 'forApp']);
        Route::post('{app}/competitors', [CompetitorController::class, 'linkToApp']);
        Route::delete('{app}/competitors/{competitorAppId}', [CompetitorController::class, 'unlinkFromApp']);

        // Keywords for app
        Route::get('{app}/keywords', [KeywordController::class, 'forApp']);
        Route::post('{app}/keywords', [KeywordController::class, 'addToApp'])->middleware('plan.limit:keywords_per_app');
        Route::delete('{app}/keywords/{keyword}', [KeywordController::class, 'removeFromApp']);
        Route::patch('{app}/keywords/{keyword}/favorite', [KeywordController::class, 'toggleFavorite']);
        Route::get('{app}/keywords/suggestions', [KeywordController::class, 'suggestions']);
        Route::post('{app}/keywords/bulk-delete', [KeywordController::class, 'bulkDelete']);
        Route::post('{app}/keywords/bulk-add-tags', [KeywordController::class, 'bulkAddTags']);
        Route::post('{app}/keywords/bulk-favorite', [KeywordController::class, 'bulkFavorite']);
        Route::post('{app}/keywords/import', [KeywordController::class, 'import']);

        // Rankings for app (auto-fetches if stale)
        Route::get('{app}/rankings', [RankingController::class, 'index']);
        Route::get('{app}/rankings/history', [RankingController::class, 'history']);

        // Ratings for app (auto-fetches if stale)
        Route::get('{app}/ratings', [RatingsController::class, 'forApp']);
        Route::get('{app}/ratings/history', [RatingsController::class, 'history']);

        // Reviews for app (auto-fetches if stale)
        Route::get('{app}/reviews/summary', [ReviewsController::class, 'summary']);
        Route::get('{app}/reviews/{country}', [ReviewsController::class, 'forCountry']);
        Route::post('{app}/reviews/{review}/reply', [ReviewsController::class, 'reply']);
        Route::post('{app}/reviews/{review}/suggest', [ReviewsController::class, 'suggestReply'])
            ->middleware('throttle:10,1');

        // Insights for app
        Route::get('{app}/insights', [InsightsController::class, 'show']);
        Route::post('{app}/insights/generate', [InsightsController::class, 'generate'])
            ->middleware('plan.feature:ai_insights');

        // ASO Score
        Route::get('{app}/aso-score', [InsightsController::class, 'asoScore']);

        // Export
        Route::get('{app}/export/rankings', [ExportController::class, 'rankings'])
            ->middleware('plan.feature:exports');
        Route::get('{app}/export/reviews', [ExportController::class, 'reviews'])
            ->middleware('plan.feature:exports');
        Route::get('{app}/export/ratings', [ExportController::class, 'ratings'])
            ->middleware('plan.feature:exports');
        Route::get('{app}/export/report', [ExportController::class, 'report'])
            ->middleware('plan.feature:exports');

        // Voice Settings
        Route::get('{app}/voice-settings', [VoiceSettingsController::class, 'show']);
        Route::put('{app}/voice-settings', [VoiceSettingsController::class, 'update']);

        // Analytics
        Route::get('{app}/analytics', [AnalyticsController::class, 'index']);
        Route::get('{app}/analytics/downloads', [AnalyticsController::class, 'downloads']);
        Route::get('{app}/analytics/revenue', [AnalyticsController::class, 'revenue']);
        Route::get('{app}/analytics/subscribers', [AnalyticsController::class, 'subscribers']);
        Route::get('{app}/analytics/countries', [AnalyticsController::class, 'countries']);
        Route::get('{app}/analytics/export', [AnalyticsController::class, 'export'])
            ->middleware('plan.feature:exports');
    });

    // Keywords (global search)
    Route::prefix('keywords')->group(function () {
        Route::get('search', [KeywordController::class, 'search'])->middleware('throttle:60,1');
        Route::get('{keyword}/history', [KeywordController::class, 'history']);
    });

    // Rankings
    Route::get('rankings/movers', [RankingController::class, 'movers']);

    // Insights comparison
    Route::get('insights/compare', [InsightsController::class, 'compare']);

    // Tags
    Route::prefix('tags')->group(function () {
        Route::get('/', [TagsController::class, 'index']);
        Route::post('/', [TagsController::class, 'store']);
        Route::delete('{tag}', [TagsController::class, 'destroy']);
        Route::post('add-to-keyword', [TagsController::class, 'addToKeyword']);
        Route::post('remove-from-keyword', [TagsController::class, 'removeFromKeyword']);
    });

    // Competitors
    Route::prefix('competitors')->group(function () {
        Route::get('/', [CompetitorController::class, 'index']);
        Route::post('/', [CompetitorController::class, 'store']);
        Route::delete('{appId}', [CompetitorController::class, 'destroy']);
        Route::get('{competitorId}/keywords', [CompetitorController::class, 'keywords']);
        Route::post('{competitorId}/keywords', [CompetitorController::class, 'addKeyword']);
        Route::post('{competitorId}/keywords/bulk', [CompetitorController::class, 'addKeywords']);
    });

    // Categories
    Route::prefix('categories')->group(function () {
        Route::get('/', [CategoryController::class, 'index']);
        Route::get('{categoryId}/top', [CategoryController::class, 'top'])->middleware('throttle:60,1');
    });

    // Notes
    Route::prefix('notes')->group(function () {
        Route::get('keyword', [NotesController::class, 'forKeyword']);
        Route::get('insight', [NotesController::class, 'forInsight']);
        Route::post('/', [NotesController::class, 'store']);
        Route::delete('{note}', [NotesController::class, 'destroy']);
    });

    // Alert Rules
    Route::prefix('alerts')->group(function () {
        Route::get('templates', [AlertRulesController::class, 'templates']);
        Route::get('rules', [AlertRulesController::class, 'index']);
        Route::post('rules', [AlertRulesController::class, 'store']);
        Route::put('rules/{rule}', [AlertRulesController::class, 'update']);
        Route::delete('rules/{rule}', [AlertRulesController::class, 'destroy']);
        Route::patch('rules/{rule}/toggle', [AlertRulesController::class, 'toggle']);

        // Alert Preferences (delivery settings)
        Route::get('preferences', [AlertPreferencesController::class, 'show']);
        Route::put('preferences', [AlertPreferencesController::class, 'update']);
        Route::get('types', [AlertPreferencesController::class, 'types']);
    });

    // Notifications
    Route::prefix('notifications')->group(function () {
        Route::get('/', [NotificationsController::class, 'index']);
        Route::get('unread-count', [NotificationsController::class, 'unreadCount']);
        Route::post('mark-all-read', [NotificationsController::class, 'markAllAsRead']);
        Route::patch('{notification}/read', [NotificationsController::class, 'markAsRead']);
        Route::delete('{notification}', [NotificationsController::class, 'destroy']);
    });

    // Store Connections
    Route::prefix('store-connections')->group(function () {
        Route::get('/', [StoreConnectionController::class, 'index']);
        Route::post('/', [StoreConnectionController::class, 'store']);
        Route::get('{storeConnection}', [StoreConnectionController::class, 'show']);
        Route::patch('{storeConnection}', [StoreConnectionController::class, 'update']);
        Route::delete('{storeConnection}', [StoreConnectionController::class, 'destroy']);
        Route::post('{storeConnection}/validate', [StoreConnectionController::class, 'validateConnection'])->middleware('throttle:30,1');
        Route::post('{storeConnection}/sync-apps', [StoreConnectionController::class, 'syncApps'])->middleware('throttle:10,1');
    });

    // Chat (AI Assistant)
    Route::prefix('chat')->group(function () {
        Route::get('conversations', [ChatController::class, 'index']);
        Route::post('conversations', [ChatController::class, 'store']);
        Route::get('conversations/{conversation}', [ChatController::class, 'show']);
        Route::post('conversations/{conversation}/messages', [ChatController::class, 'sendMessage'])
            ->middleware('throttle:12,1'); // Max 1 question per 5 seconds
        Route::delete('conversations/{conversation}', [ChatController::class, 'destroy']);
        Route::get('quota', [ChatController::class, 'quota']);
    });

    // App-specific chat (within apps prefix)
    Route::prefix('apps')->middleware('owns.app')->group(function () {
        Route::get('{app}/chat', [ChatController::class, 'forApp']);
        Route::post('{app}/chat/ask', [ChatController::class, 'quickAsk'])
            ->middleware('throttle:12,1');
        Route::get('{app}/chat/suggestions', [ChatController::class, 'suggestedQuestions']);
    });

    // Actionable Insights (AI-generated)
    Route::prefix('actionable-insights')->group(function () {
        Route::get('/', [ActionableInsightsController::class, 'index']);
        Route::get('summary', [ActionableInsightsController::class, 'summary']);
        Route::get('unread-count', [ActionableInsightsController::class, 'unreadCount']);
        Route::post('mark-all-read', [ActionableInsightsController::class, 'markAllAsRead']);
        Route::get('{insight}', [ActionableInsightsController::class, 'show']);
        Route::post('{insight}/read', [ActionableInsightsController::class, 'markAsRead']);
        Route::post('{insight}/dismiss', [ActionableInsightsController::class, 'dismiss']);
    });

    // Integrations (V2)
    Route::prefix('integrations')->group(function () {
        Route::get('/', [IntegrationsController::class, 'index']);
        Route::get('{integration}', [IntegrationsController::class, 'show']);
        Route::delete('{integration}', [IntegrationsController::class, 'destroy']);
        Route::post('{integration}/refresh', [IntegrationsController::class, 'refresh']);
        Route::get('{integration}/apps', [IntegrationsController::class, 'apps']);
        Route::post('app-store-connect', [IntegrationsController::class, 'connectAppStore']);
        Route::post('google-play', [IntegrationsController::class, 'connectGooglePlay']);
    });

    // Onboarding
    Route::prefix('onboarding')->group(function () {
        Route::get('status', [OnboardingController::class, 'status']);
        Route::post('step', [OnboardingController::class, 'updateStep']);
        Route::post('complete', [OnboardingController::class, 'complete']);
        Route::post('skip', [OnboardingController::class, 'skip']);
    });

    // Sync Status
    Route::prefix('sync')->group(function () {
        Route::get('status', [SyncController::class, 'status']);
        Route::get('history', [SyncController::class, 'history']);
    });

    // Billing
    Route::prefix('billing')->group(function () {
        Route::get('status', [BillingController::class, 'status']);
        Route::get('plans', [BillingController::class, 'plans']);
        Route::post('checkout', [BillingController::class, 'checkout']);
        Route::get('portal', [BillingController::class, 'portal']);
        Route::post('cancel', [BillingController::class, 'cancel']);
        Route::post('resume', [BillingController::class, 'resume']);
    });

    // API Key Management
    Route::prefix('api-key')->group(function () {
        Route::get('status', [ApiKeyController::class, 'status']);
        Route::post('generate', [ApiKeyController::class, 'generate']);
        Route::delete('revoke', [ApiKeyController::class, 'revoke']);
    });
});

// Public API (authenticated via API key, for Pro+ users)
Route::prefix('v1')->middleware(['api.key', 'throttle:60,1'])->group(function () {
    Route::get('apps', [PublicApiController::class, 'apps']);
    Route::get('apps/{app}', [PublicApiController::class, 'app']);
    Route::get('apps/{app}/rankings', [PublicApiController::class, 'rankings']);
    Route::get('apps/{app}/ratings', [PublicApiController::class, 'ratings']);
    Route::get('apps/{app}/reviews', [PublicApiController::class, 'reviews']);
    Route::get('apps/{app}/keywords', [PublicApiController::class, 'keywords']);
});
