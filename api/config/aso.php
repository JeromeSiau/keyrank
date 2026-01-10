<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Top Apps Configuration
    |--------------------------------------------------------------------------
    |
    | Countries and collections to track for daily top apps refresh.
    | Each combination of country × collection × category will be fetched.
    |
    */

    'top_apps' => [
        // Countries to track (ISO 3166-1 alpha-2 codes)
        // These are markets with significant app developer communities
        'countries' => [
            'us', // United States - largest market
            'fr', // France
            'gb', // United Kingdom
            'de', // Germany
            'tr', // Turkey - growing dev community
        ],

        // Collection types to track
        'collections' => [
            'top_free',     // Most downloaded free apps
            'top_paid',     // Most downloaded paid apps
            'top_grossing', // Highest revenue apps (includes IAP)
        ],

        // Number of apps to fetch per category/country/collection
        'limit' => 100,
    ],

    /*
    |--------------------------------------------------------------------------
    | Rate Limiting
    |--------------------------------------------------------------------------
    */

    'rate_limits' => [
        // Delay between requests in milliseconds
        'ios' => 100,      // iOS RSS feeds are free, minimal delay
        'android' => 500,  // Android scraping needs more delay
    ],

    /*
    |--------------------------------------------------------------------------
    | Cache Configuration
    |--------------------------------------------------------------------------
    */

    'cache' => [
        // How long to cache keyword suggestions (in hours)
        'suggestions_ttl' => 24,

        // How long to cache app details (in hours)
        'app_details_ttl' => 6,
    ],
];
