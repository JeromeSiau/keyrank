<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Subscription Plans
    |--------------------------------------------------------------------------
    |
    | Define the available subscription plans and their limits.
    | 'stripe_price_id' should be set in production to the actual Stripe Price IDs.
    |
    */

    'free' => [
        'name' => 'Free',
        'stripe_price_id' => null, // No Stripe subscription for free tier
        'limits' => [
            'apps' => 2,
            'keywords_per_app' => 10,
            'competitors_per_app' => 3,
            'history_days' => 30,
            'exports' => false,
            'api_access' => false,
            'priority_support' => false,
            'ai_insights' => false,
            'ai_chat_messages_per_day' => 5,
        ],
    ],

    'pro' => [
        'name' => 'Pro',
        'stripe_price_id' => env('STRIPE_PRICE_PRO_MONTHLY', 'price_pro_monthly'),
        'stripe_price_id_yearly' => env('STRIPE_PRICE_PRO_YEARLY', 'price_pro_yearly'),
        'limits' => [
            'apps' => 10,
            'keywords_per_app' => 100,
            'competitors_per_app' => 10,
            'history_days' => 365,
            'exports' => true,
            'api_access' => false,
            'priority_support' => false,
            'ai_insights' => true,
            'ai_chat_messages_per_day' => 50,
        ],
    ],

    'business' => [
        'name' => 'Business',
        'stripe_price_id' => env('STRIPE_PRICE_BUSINESS_MONTHLY', 'price_business_monthly'),
        'stripe_price_id_yearly' => env('STRIPE_PRICE_BUSINESS_YEARLY', 'price_business_yearly'),
        'limits' => [
            'apps' => 50,
            'keywords_per_app' => 500,
            'competitors_per_app' => 25,
            'history_days' => -1, // Unlimited
            'exports' => true,
            'api_access' => true,
            'priority_support' => true,
            'ai_insights' => true,
            'ai_chat_messages_per_day' => -1, // Unlimited
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Default Plan
    |--------------------------------------------------------------------------
    */

    'default' => 'free',

    /*
    |--------------------------------------------------------------------------
    | Grace Period
    |--------------------------------------------------------------------------
    |
    | Number of days to allow access after subscription ends.
    |
    */

    'grace_period_days' => 3,
];
