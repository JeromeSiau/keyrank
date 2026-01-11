<?php

use App\Http\Controllers\Api\StripeWebhookController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

// Stripe webhooks (must be in web.php to bypass API auth)
Route::post('stripe/webhook', [StripeWebhookController::class, 'handleWebhook']);
