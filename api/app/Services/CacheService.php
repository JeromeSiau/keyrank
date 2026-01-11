<?php

namespace App\Services;

use Illuminate\Support\Facades\Cache;

class CacheService
{
    // Cache TTLs in seconds
    const TTL_SHORT = 300;      // 5 minutes
    const TTL_MEDIUM = 1800;    // 30 minutes
    const TTL_LONG = 3600;      // 1 hour
    const TTL_DAY = 86400;      // 1 day

    /**
     * Cache key prefixes
     */
    const PREFIX_DASHBOARD = 'dashboard:';
    const PREFIX_APP = 'app:';
    const PREFIX_RANKINGS = 'rankings:';
    const PREFIX_RATINGS = 'ratings:';
    const PREFIX_REVIEWS = 'reviews:';
    const PREFIX_KEYWORDS = 'keywords:';
    const PREFIX_USER = 'user:';

    /**
     * Get cached dashboard overview
     */
    public static function getDashboardOverview(int $userId, callable $callback)
    {
        $key = self::PREFIX_DASHBOARD . "overview:{$userId}";
        return Cache::remember($key, self::TTL_SHORT, $callback);
    }

    /**
     * Get cached app details
     */
    public static function getApp(int $appId, callable $callback)
    {
        $key = self::PREFIX_APP . $appId;
        return Cache::remember($key, self::TTL_MEDIUM, $callback);
    }

    /**
     * Get cached rankings for an app
     */
    public static function getAppRankings(int $appId, int $userId, string $country, callable $callback)
    {
        $key = self::PREFIX_RANKINGS . "{$appId}:{$userId}:{$country}";
        return Cache::remember($key, self::TTL_SHORT, $callback);
    }

    /**
     * Get cached ratings for an app
     */
    public static function getAppRatings(int $appId, string $country, callable $callback)
    {
        $key = self::PREFIX_RATINGS . "{$appId}:{$country}";
        return Cache::remember($key, self::TTL_MEDIUM, $callback);
    }

    /**
     * Get cached reviews summary for an app
     */
    public static function getReviewsSummary(int $appId, callable $callback)
    {
        $key = self::PREFIX_REVIEWS . "summary:{$appId}";
        return Cache::remember($key, self::TTL_MEDIUM, $callback);
    }

    /**
     * Get cached keyword search results
     */
    public static function getKeywordSearch(string $query, string $country, callable $callback)
    {
        $key = self::PREFIX_KEYWORDS . "search:" . md5("{$query}:{$country}");
        return Cache::remember($key, self::TTL_LONG, $callback);
    }

    /**
     * Get cached user subscription status
     */
    public static function getUserSubscription(int $userId, callable $callback)
    {
        $key = self::PREFIX_USER . "subscription:{$userId}";
        return Cache::remember($key, self::TTL_MEDIUM, $callback);
    }

    /**
     * Get cached top charts
     */
    public static function getTopCharts(string $platform, int $categoryId, string $country, callable $callback)
    {
        $key = "topcharts:{$platform}:{$categoryId}:{$country}";
        return Cache::remember($key, self::TTL_LONG, $callback);
    }

    /**
     * Clear cache for an app
     */
    public static function clearAppCache(int $appId): void
    {
        Cache::forget(self::PREFIX_APP . $appId);
        // Clear related caches - in production, use cache tags
        // Cache::tags(['app:' . $appId])->flush();
    }

    /**
     * Clear cache for user dashboard
     */
    public static function clearUserDashboard(int $userId): void
    {
        Cache::forget(self::PREFIX_DASHBOARD . "overview:{$userId}");
    }

    /**
     * Clear cache for user subscription
     */
    public static function clearUserSubscription(int $userId): void
    {
        Cache::forget(self::PREFIX_USER . "subscription:{$userId}");
    }

    /**
     * Clear rankings cache for an app
     */
    public static function clearRankingsCache(int $appId): void
    {
        // In production with Redis, use patterns or tags
        // For now, we rely on TTL expiration
    }

    /**
     * Cache a value with automatic key generation
     */
    public static function remember(string $prefix, array $params, int $ttl, callable $callback)
    {
        $key = $prefix . ':' . md5(serialize($params));
        return Cache::remember($key, $ttl, $callback);
    }

    /**
     * Forget a cached value
     */
    public static function forget(string $prefix, array $params): void
    {
        $key = $prefix . ':' . md5(serialize($params));
        Cache::forget($key);
    }
}
