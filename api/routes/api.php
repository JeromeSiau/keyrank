<?php

use App\Http\Controllers\Api\AppController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\InsightsController;
use App\Http\Controllers\Api\KeywordController;
use App\Http\Controllers\Api\RankingController;
use App\Http\Controllers\Api\RatingsController;
use App\Http\Controllers\Api\ReviewsController;
use App\Http\Controllers\Api\TagsController;
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
});
