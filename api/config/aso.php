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
        // Major app markets worldwide
        'countries' => [
            // Tier 1 - Major markets
            'us', // United States - largest market
            'gb', // United Kingdom
            'de', // Germany
            'fr', // France
            'jp', // Japan - 3rd largest market
            'kr', // South Korea
            'cn', // China

            // Tier 2 - Large markets
            'ca', // Canada
            'au', // Australia
            'it', // Italy
            'es', // Spain
            'br', // Brazil - largest LATAM
            'mx', // Mexico
            'in', // India - massive growth
            'ru', // Russia

            // Tier 3 - Growing markets
            'nl', // Netherlands
            'se', // Sweden
            'no', // Norway
            'dk', // Denmark
            'pl', // Poland
            'tr', // Turkey
            'sa', // Saudi Arabia
            'ae', // UAE
            'sg', // Singapore
            'hk', // Hong Kong
            'tw', // Taiwan
            'th', // Thailand
            'id', // Indonesia
            'vn', // Vietnam
            'ph', // Philippines
            'my', // Malaysia
            'ar', // Argentina
            'cl', // Chile
            'co', // Colombia
        ],

        // Collection types to track
        'collections' => [
            'top_free',     // Most downloaded free apps
            'top_paid',     // Most downloaded paid apps
            'top_grossing', // Highest revenue apps (includes IAP)
        ],

        // Number of apps to fetch per category/country/collection
        // iTunes RSS max is 100, Google Play scraper can do more
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
