<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Third Party Services
    |--------------------------------------------------------------------------
    |
    | This file is for storing the credentials for third party services such
    | as Mailgun, Postmark, AWS and more. This file provides the de facto
    | location for this type of information, allowing packages to have
    | a conventional file to locate the various service credentials.
    |
    */

    'postmark' => [
        'key' => env('POSTMARK_API_KEY'),
    ],

    'resend' => [
        'key' => env('RESEND_API_KEY'),
    ],

    'ses' => [
        'key' => env('AWS_ACCESS_KEY_ID'),
        'secret' => env('AWS_SECRET_ACCESS_KEY'),
        'region' => env('AWS_DEFAULT_REGION', 'us-east-1'),
    ],

    'slack' => [
        'notifications' => [
            'bot_user_oauth_token' => env('SLACK_BOT_USER_OAUTH_TOKEN'),
            'channel' => env('SLACK_BOT_USER_DEFAULT_CHANNEL'),
        ],
    ],

    'gplay_scraper' => [
        'url' => env('GPLAY_SCRAPER_URL', 'http://localhost:8001'),
    ],

    'revenue_scraper' => [
        'url' => env('REVENUE_SCRAPER_URL', 'http://localhost:8001'),
    ],

    'apple_search_ads' => [
        'client_id' => env('APPLE_SEARCH_ADS_CLIENT_ID'),
        'team_id' => env('APPLE_SEARCH_ADS_TEAM_ID'),
        'key_id' => env('APPLE_SEARCH_ADS_KEY_ID'),
        'private_key_path' => env('APPLE_SEARCH_ADS_PRIVATE_KEY_PATH'),
        'private_key' => env('APPLE_SEARCH_ADS_PRIVATE_KEY'),
    ],

    'openrouter' => [
        'api_key' => env('OPENROUTER_API_KEY'),
        'base_url' => env('OPENROUTER_BASE_URL', 'https://openrouter.ai/api/v1'),
        'model' => env('OPENROUTER_MODEL', 'openai/gpt-5-nano'),
    ],

    'proxy' => [
        'enabled' => env('PROXY_ENABLED', false),
        'host' => env('PROXY_HOST'),
        'port' => env('PROXY_PORT', 10001),
        'username' => env('PROXY_USERNAME'),
        'password' => env('PROXY_PASSWORD'),
    ],

    'app_store_connect' => [
        'base_url' => env('APP_STORE_CONNECT_BASE_URL', 'https://api.appstoreconnect.apple.com'),
    ],

];
