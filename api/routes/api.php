<?php

use App\Http\Controllers\Api\AlertRulesController;
use App\Http\Controllers\Api\AppController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\ExportController;
use App\Http\Controllers\Api\InsightsController;
use App\Http\Controllers\Api\KeywordController;
use App\Http\Controllers\Api\NotificationsController;
use App\Http\Controllers\Api\RankingController;
use App\Http\Controllers\Api\RatingsController;
use App\Http\Controllers\Api\ReviewsController;
use App\Http\Controllers\Api\NotesController;
use App\Http\Controllers\Api\TagsController;
use App\Http\Controllers\Api\UserPreferencesController;
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
    });

    // Apps
    Route::prefix('apps')->middleware('owns.app')->group(function () {
        Route::get('/', [AppController::class, 'index']);
        Route::get('search', [AppController::class, 'search'])->middleware('throttle:60,1');
        Route::get('search/android', [AppController::class, 'searchAndroid'])->middleware('throttle:60,1');
        Route::post('/', [AppController::class, 'store']);
        Route::get('{app}', [AppController::class, 'show']);
        Route::delete('{app}', [AppController::class, 'destroy']);
        Route::post('{app}/refresh', [AppController::class, 'refresh']);
        Route::patch('{app}/favorite', [AppController::class, 'toggleFavorite']);

        // Keywords for app
        Route::get('{app}/keywords', [KeywordController::class, 'forApp']);
        Route::post('{app}/keywords', [KeywordController::class, 'addToApp']);
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

        // Insights for app
        Route::get('{app}/insights', [InsightsController::class, 'show']);
        Route::post('{app}/insights/generate', [InsightsController::class, 'generate']);

        // Export
        Route::get('{app}/export/rankings', [ExportController::class, 'rankings']);
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
    });

    // Notifications
    Route::prefix('notifications')->group(function () {
        Route::get('/', [NotificationsController::class, 'index']);
        Route::get('unread-count', [NotificationsController::class, 'unreadCount']);
        Route::post('mark-all-read', [NotificationsController::class, 'markAllAsRead']);
        Route::patch('{notification}/read', [NotificationsController::class, 'markAsRead']);
        Route::delete('{notification}', [NotificationsController::class, 'destroy']);
    });
});
