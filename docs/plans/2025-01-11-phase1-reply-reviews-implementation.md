# Phase 1: Reply to Reviews - Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Enable users to connect their App Store Connect and Google Play accounts to view and reply to reviews directly from Keyrank.

**Architecture:** Backend-centric approach where all store API calls go through Laravel. Flutter app communicates only with our API. Credentials encrypted server-side with AES-256-GCM.

**Tech Stack:** Laravel 11 (backend), Flutter/Riverpod (frontend), OpenRouter for AI suggestions, Firebase JWT for Apple auth.

---

## Task 1: Database Migrations

**Files:**
- Create: `api/database/migrations/2026_01_11_000001_create_store_connections_table.php`
- Create: `api/database/migrations/2026_01_11_000002_create_app_voice_settings_table.php`
- Create: `api/database/migrations/2026_01_11_000003_add_reply_fields_to_app_reviews_table.php`

### Step 1: Create store_connections migration

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('store_connections', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->enum('platform', ['ios', 'android']);
            $table->text('credentials'); // AES-256-GCM encrypted
            $table->timestamp('connected_at');
            $table->timestamp('last_sync_at')->nullable();
            $table->enum('status', ['active', 'expired', 'revoked'])->default('active');
            $table->timestamps();

            $table->unique(['user_id', 'platform']);
            $table->index(['user_id', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('store_connections');
    }
};
```

### Step 2: Create app_voice_settings migration

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('app_voice_settings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->text('tone_description')->nullable(); // e.g., "Friendly, casual, use emojis"
            $table->string('default_language', 10)->default('auto');
            $table->string('signature')->nullable(); // e.g., "- The Team"
            $table->timestamps();

            $table->unique(['app_id', 'user_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('app_voice_settings');
    }
};
```

### Step 3: Add reply fields to app_reviews migration

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('app_reviews', function (Blueprint $table) {
            $table->enum('sentiment', ['positive', 'negative', 'neutral'])->nullable()->after('reviewed_at');
            $table->text('our_response')->nullable()->after('sentiment');
            $table->timestamp('responded_at')->nullable()->after('our_response');
            $table->string('store_response_id')->nullable()->after('responded_at'); // ID from store API

            $table->index(['app_id', 'sentiment']);
            $table->index(['app_id', 'responded_at']);
        });
    }

    public function down(): void
    {
        Schema::table('app_reviews', function (Blueprint $table) {
            $table->dropColumn(['sentiment', 'our_response', 'responded_at', 'store_response_id']);
        });
    }
};
```

### Step 4: Run migrations

Run: `cd /Users/jerome/Projets/web/flutter/ranking/api && php artisan migrate`
Expected: 3 migrations executed successfully

### Step 5: Commit

```bash
git add api/database/migrations/
git commit -m "feat(db): add store_connections, app_voice_settings, and review reply fields"
```

---

## Task 2: Eloquent Models

**Files:**
- Create: `api/app/Models/StoreConnection.php`
- Create: `api/app/Models/AppVoiceSetting.php`
- Modify: `api/app/Models/AppReview.php`
- Modify: `api/app/Models/User.php`
- Modify: `api/app/Models/App.php`

### Step 1: Create StoreConnection model

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Facades\Crypt;

class StoreConnection extends Model
{
    protected $fillable = [
        'user_id',
        'platform',
        'credentials',
        'connected_at',
        'last_sync_at',
        'status',
    ];

    protected $casts = [
        'connected_at' => 'datetime',
        'last_sync_at' => 'datetime',
    ];

    protected $hidden = ['credentials'];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function setCredentialsAttribute(array $value): void
    {
        $this->attributes['credentials'] = Crypt::encryptString(json_encode($value));
    }

    public function getCredentialsAttribute(?string $value): ?array
    {
        if (!$value) return null;
        return json_decode(Crypt::decryptString($value), true);
    }

    public function isActive(): bool
    {
        return $this->status === 'active';
    }

    public function markAsExpired(): void
    {
        $this->update(['status' => 'expired']);
    }

    public function updateLastSync(): void
    {
        $this->update(['last_sync_at' => now()]);
    }
}
```

### Step 2: Create AppVoiceSetting model

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppVoiceSetting extends Model
{
    protected $fillable = [
        'app_id',
        'user_id',
        'tone_description',
        'default_language',
        'signature',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
```

### Step 3: Update AppReview model

Add to `api/app/Models/AppReview.php`:

```php
// Add to $fillable array:
'sentiment',
'our_response',
'responded_at',
'store_response_id',

// Add to $casts array:
'responded_at' => 'datetime',

// Add methods:
public function isAnswered(): bool
{
    return $this->responded_at !== null;
}

public function scopeUnanswered($query)
{
    return $query->whereNull('responded_at');
}

public function scopeAnswered($query)
{
    return $query->whereNotNull('responded_at');
}

public function scopeNegative($query)
{
    return $query->where('rating', '<=', 2);
}

public function scopeBySentiment($query, string $sentiment)
{
    return $query->where('sentiment', $sentiment);
}
```

### Step 4: Update User model

Add to `api/app/Models/User.php`:

```php
// Add relationship:
public function storeConnections(): HasMany
{
    return $this->hasMany(StoreConnection::class);
}

public function getStoreConnection(string $platform): ?StoreConnection
{
    return $this->storeConnections()->where('platform', $platform)->where('status', 'active')->first();
}

public function hasStoreConnection(string $platform): bool
{
    return $this->getStoreConnection($platform) !== null;
}
```

### Step 5: Update App model

Add to `api/app/Models/App.php`:

```php
// Add relationship:
public function voiceSettings(): HasMany
{
    return $this->hasMany(AppVoiceSetting::class);
}

public function getVoiceSettingForUser(int $userId): ?AppVoiceSetting
{
    return $this->voiceSettings()->where('user_id', $userId)->first();
}
```

### Step 6: Commit

```bash
git add api/app/Models/
git commit -m "feat(models): add StoreConnection, AppVoiceSetting, and update review model"
```

---

## Task 3: Apple App Store Connect Service

**Files:**
- Create: `api/app/Services/AppStoreConnectService.php`
- Modify: `api/config/services.php`

### Step 1: Add config

Add to `api/config/services.php`:

```php
'app_store_connect' => [
    'base_url' => env('APP_STORE_CONNECT_BASE_URL', 'https://api.appstoreconnect.apple.com'),
],
```

### Step 2: Create AppStoreConnectService

```php
<?php

namespace App\Services;

use App\Models\StoreConnection;
use Firebase\JWT\JWT;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Cache;

class AppStoreConnectService
{
    private string $baseUrl;

    public function __construct()
    {
        $this->baseUrl = config('services.app_store_connect.base_url');
    }

    /**
     * Generate JWT token for App Store Connect API
     */
    public function generateToken(array $credentials): string
    {
        $cacheKey = "asc_token_{$credentials['key_id']}";

        return Cache::remember($cacheKey, 1000, function () use ($credentials) {
            $header = [
                'alg' => 'ES256',
                'kid' => $credentials['key_id'],
                'typ' => 'JWT',
            ];

            $payload = [
                'iss' => $credentials['issuer_id'],
                'iat' => time(),
                'exp' => time() + 1200, // 20 minutes
                'aud' => 'appstoreconnect-v1',
            ];

            return JWT::encode($payload, $credentials['private_key'], 'ES256', null, $header);
        });
    }

    /**
     * Fetch reviews for an app
     */
    public function getReviews(StoreConnection $connection, string $appStoreId, ?string $cursor = null): ?array
    {
        try {
            $token = $this->generateToken($connection->credentials);

            $url = "{$this->baseUrl}/v1/apps/{$appStoreId}/customerReviews";
            $params = [
                'limit' => 100,
                'sort' => '-createdDate',
                'include' => 'response',
            ];

            if ($cursor) {
                $params['cursor'] = $cursor;
            }

            $response = Http::withToken($token)
                ->timeout(30)
                ->get($url, $params);

            if ($response->successful()) {
                return $response->json();
            }

            if ($response->status() === 401) {
                $connection->markAsExpired();
            }

            Log::error('App Store Connect API error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('App Store Connect API exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Reply to a review
     */
    public function replyToReview(StoreConnection $connection, string $reviewId, string $responseBody): ?array
    {
        try {
            $token = $this->generateToken($connection->credentials);

            $response = Http::withToken($token)
                ->timeout(30)
                ->post("{$this->baseUrl}/v1/customerReviewResponses", [
                    'data' => [
                        'type' => 'customerReviewResponses',
                        'attributes' => [
                            'responseBody' => $responseBody,
                        ],
                        'relationships' => [
                            'review' => [
                                'data' => [
                                    'type' => 'customerReviews',
                                    'id' => $reviewId,
                                ],
                            ],
                        ],
                    ],
                ]);

            if ($response->successful()) {
                return $response->json();
            }

            Log::error('App Store Connect reply error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('App Store Connect reply exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Validate credentials by making a test API call
     */
    public function validateCredentials(array $credentials): bool
    {
        try {
            $token = $this->generateToken($credentials);

            $response = Http::withToken($token)
                ->timeout(10)
                ->get("{$this->baseUrl}/v1/apps", ['limit' => 1]);

            return $response->successful();
        } catch (\Exception $e) {
            Log::error('App Store Connect validation failed', ['error' => $e->getMessage()]);
            return false;
        }
    }
}
```

### Step 3: Install Firebase JWT package

Run: `cd /Users/jerome/Projets/web/flutter/ranking/api && composer require firebase/php-jwt`
Expected: Package installed successfully

### Step 4: Commit

```bash
git add api/app/Services/AppStoreConnectService.php api/config/services.php composer.json composer.lock
git commit -m "feat(api): add App Store Connect service for reviews"
```

---

## Task 4: Google Play Developer API Service

**Files:**
- Create: `api/app/Services/GooglePlayService.php` (update existing or create new)

### Step 1: Update/Create GooglePlayService

Check if `api/app/Services/GooglePlayService.php` exists and update it, or create with this content:

```php
<?php

namespace App\Services;

use App\Models\StoreConnection;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class GooglePlayDeveloperService
{
    private string $baseUrl = 'https://androidpublisher.googleapis.com/androidpublisher/v3';

    /**
     * Get access token from refresh token
     */
    private function getAccessToken(array $credentials): ?string
    {
        try {
            $response = Http::asForm()->post('https://oauth2.googleapis.com/token', [
                'client_id' => $credentials['client_id'],
                'client_secret' => $credentials['client_secret'],
                'refresh_token' => $credentials['refresh_token'],
                'grant_type' => 'refresh_token',
            ]);

            if ($response->successful()) {
                return $response->json('access_token');
            }

            Log::error('Google OAuth token refresh failed', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('Google OAuth exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Fetch reviews for an app
     */
    public function getReviews(StoreConnection $connection, string $packageName): ?array
    {
        try {
            $token = $this->getAccessToken($connection->credentials);
            if (!$token) {
                $connection->markAsExpired();
                return null;
            }

            $response = Http::withToken($token)
                ->timeout(30)
                ->get("{$this->baseUrl}/applications/{$packageName}/reviews");

            if ($response->successful()) {
                return $response->json();
            }

            if ($response->status() === 401) {
                $connection->markAsExpired();
            }

            Log::error('Google Play API error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('Google Play API exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Reply to a review
     */
    public function replyToReview(StoreConnection $connection, string $packageName, string $reviewId, string $replyText): ?array
    {
        try {
            $token = $this->getAccessToken($connection->credentials);
            if (!$token) {
                $connection->markAsExpired();
                return null;
            }

            $response = Http::withToken($token)
                ->timeout(30)
                ->post("{$this->baseUrl}/applications/{$packageName}/reviews/{$reviewId}:reply", [
                    'replyText' => $replyText,
                ]);

            if ($response->successful()) {
                return $response->json();
            }

            Log::error('Google Play reply error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('Google Play reply exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Validate credentials
     */
    public function validateCredentials(array $credentials): bool
    {
        $token = $this->getAccessToken($credentials);
        return $token !== null;
    }
}
```

### Step 2: Commit

```bash
git add api/app/Services/GooglePlayDeveloperService.php
git commit -m "feat(api): add Google Play Developer service for reviews"
```

---

## Task 5: Store Connections Controller

**Files:**
- Create: `api/app/Http/Controllers/Api/StoreConnectionsController.php`
- Modify: `api/routes/api.php`

### Step 1: Create controller

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\StoreConnection;
use App\Services\AppStoreConnectService;
use App\Services\GooglePlayDeveloperService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class StoreConnectionsController extends Controller
{
    public function __construct(
        private AppStoreConnectService $appStoreConnect,
        private GooglePlayDeveloperService $googlePlay,
    ) {}

    /**
     * List user's store connections
     */
    public function index(): JsonResponse
    {
        $connections = Auth::user()->storeConnections()->get(['id', 'platform', 'status', 'connected_at', 'last_sync_at']);

        return response()->json([
            'data' => $connections->map(fn($c) => [
                'id' => $c->id,
                'platform' => $c->platform,
                'status' => $c->status,
                'connected_at' => $c->connected_at?->toIso8601String(),
                'last_sync_at' => $c->last_sync_at?->toIso8601String(),
            ]),
        ]);
    }

    /**
     * Connect Apple App Store Connect
     */
    public function connectApple(Request $request): JsonResponse
    {
        $request->validate([
            'issuer_id' => 'required|string',
            'key_id' => 'required|string',
            'private_key' => 'required|string',
        ]);

        $credentials = [
            'issuer_id' => $request->issuer_id,
            'key_id' => $request->key_id,
            'private_key' => $request->private_key,
        ];

        // Validate credentials
        if (!$this->appStoreConnect->validateCredentials($credentials)) {
            return response()->json(['message' => 'Invalid App Store Connect credentials'], 422);
        }

        // Create or update connection
        $connection = Auth::user()->storeConnections()->updateOrCreate(
            ['platform' => 'ios'],
            [
                'credentials' => $credentials,
                'connected_at' => now(),
                'status' => 'active',
            ]
        );

        return response()->json([
            'message' => 'App Store Connect connected successfully',
            'data' => [
                'id' => $connection->id,
                'platform' => 'ios',
                'status' => 'active',
                'connected_at' => $connection->connected_at->toIso8601String(),
            ],
        ]);
    }

    /**
     * Connect Google Play (OAuth callback)
     */
    public function connectGoogle(Request $request): JsonResponse
    {
        $request->validate([
            'client_id' => 'required|string',
            'client_secret' => 'required|string',
            'refresh_token' => 'required|string',
        ]);

        $credentials = [
            'client_id' => $request->client_id,
            'client_secret' => $request->client_secret,
            'refresh_token' => $request->refresh_token,
        ];

        // Validate credentials
        if (!$this->googlePlay->validateCredentials($credentials)) {
            return response()->json(['message' => 'Invalid Google Play credentials'], 422);
        }

        // Create or update connection
        $connection = Auth::user()->storeConnections()->updateOrCreate(
            ['platform' => 'android'],
            [
                'credentials' => $credentials,
                'connected_at' => now(),
                'status' => 'active',
            ]
        );

        return response()->json([
            'message' => 'Google Play connected successfully',
            'data' => [
                'id' => $connection->id,
                'platform' => 'android',
                'status' => 'active',
                'connected_at' => $connection->connected_at->toIso8601String(),
            ],
        ]);
    }

    /**
     * Disconnect a store
     */
    public function disconnect(string $platform): JsonResponse
    {
        $connection = Auth::user()->storeConnections()->where('platform', $platform)->first();

        if (!$connection) {
            return response()->json(['message' => 'Connection not found'], 404);
        }

        $connection->delete();

        return response()->json(['message' => 'Disconnected successfully']);
    }
}
```

### Step 2: Add routes

Add to `api/routes/api.php` inside the protected routes group:

```php
// Store Connections
Route::prefix('store-connections')->group(function () {
    Route::get('/', [StoreConnectionsController::class, 'index']);
    Route::post('apple', [StoreConnectionsController::class, 'connectApple']);
    Route::post('google', [StoreConnectionsController::class, 'connectGoogle']);
    Route::delete('{platform}', [StoreConnectionsController::class, 'disconnect'])->where('platform', 'ios|android');
});
```

Don't forget to add the use statement at the top:
```php
use App\Http\Controllers\Api\StoreConnectionsController;
```

### Step 3: Commit

```bash
git add api/app/Http/Controllers/Api/StoreConnectionsController.php api/routes/api.php
git commit -m "feat(api): add store connections endpoints"
```

---

## Task 6: Review Reply Controller

**Files:**
- Modify: `api/app/Http/Controllers/Api/ReviewsController.php`

### Step 1: Add reply functionality to ReviewsController

Add these methods to the existing `ReviewsController`:

```php
// Add to constructor:
private AppStoreConnectService $appStoreConnect,
private GooglePlayDeveloperService $googlePlay,
private OpenRouterService $openRouter,

// Add new method: Get reviews inbox (all apps)
public function inbox(Request $request): JsonResponse
{
    $user = Auth::user();

    $query = AppReview::query()
        ->whereIn('app_id', $user->apps()->pluck('apps.id'))
        ->with('app:id,name,icon_url,platform');

    // Filters
    if ($request->has('status')) {
        if ($request->status === 'unanswered') {
            $query->unanswered();
        } elseif ($request->status === 'answered') {
            $query->answered();
        }
    }

    if ($request->has('rating')) {
        $query->where('rating', $request->rating);
    }

    if ($request->has('sentiment')) {
        $query->bySentiment($request->sentiment);
    }

    if ($request->has('app_id')) {
        $query->where('app_id', $request->app_id);
    }

    if ($request->has('country')) {
        $query->where('country', strtoupper($request->country));
    }

    if ($request->has('search')) {
        $query->where(function ($q) use ($request) {
            $q->where('content', 'like', "%{$request->search}%")
              ->orWhere('title', 'like', "%{$request->search}%");
        });
    }

    $reviews = $query->orderByDesc('reviewed_at')
        ->paginate($request->get('per_page', 20));

    return response()->json([
        'data' => $reviews->map(fn($r) => [
            'id' => $r->id,
            'app' => [
                'id' => $r->app->id,
                'name' => $r->app->name,
                'icon_url' => $r->app->icon_url,
                'platform' => $r->app->platform,
            ],
            'author' => $r->author,
            'title' => $r->title,
            'content' => $r->content,
            'rating' => $r->rating,
            'country' => $r->country,
            'sentiment' => $r->sentiment,
            'reviewed_at' => $r->reviewed_at->toIso8601String(),
            'our_response' => $r->our_response,
            'responded_at' => $r->responded_at?->toIso8601String(),
        ]),
        'meta' => [
            'current_page' => $reviews->currentPage(),
            'last_page' => $reviews->lastPage(),
            'per_page' => $reviews->perPage(),
            'total' => $reviews->total(),
        ],
    ]);
}

// Add new method: Reply to a review
public function reply(Request $request, AppReview $review): JsonResponse
{
    $request->validate([
        'response' => 'required|string|max:5970', // Apple limit
    ]);

    $user = Auth::user();
    $app = $review->app;

    // Check user owns the app
    if (!$user->apps()->where('apps.id', $app->id)->exists()) {
        return response()->json(['message' => 'Unauthorized'], 403);
    }

    // Get store connection
    $connection = $user->getStoreConnection($app->platform);
    if (!$connection) {
        return response()->json(['message' => 'Store not connected'], 422);
    }

    // Send reply to store
    $result = null;
    if ($app->platform === 'ios') {
        $result = $this->appStoreConnect->replyToReview($connection, $review->review_id, $request->response);
    } else {
        $result = $this->googlePlay->replyToReview($connection, $app->store_id, $review->review_id, $request->response);
    }

    if (!$result) {
        return response()->json(['message' => 'Failed to send reply to store'], 500);
    }

    // Update review in DB
    $review->update([
        'our_response' => $request->response,
        'responded_at' => now(),
        'store_response_id' => $result['data']['id'] ?? null,
    ]);

    return response()->json([
        'message' => 'Reply sent successfully',
        'data' => [
            'id' => $review->id,
            'our_response' => $review->our_response,
            'responded_at' => $review->responded_at->toIso8601String(),
        ],
    ]);
}

// Add new method: Generate AI suggestion
public function suggestReply(Request $request, AppReview $review): JsonResponse
{
    $user = Auth::user();
    $app = $review->app;

    // Check user owns the app
    if (!$user->apps()->where('apps.id', $app->id)->exists()) {
        return response()->json(['message' => 'Unauthorized'], 403);
    }

    // Get voice settings
    $voiceSettings = $app->getVoiceSettingForUser($user->id);
    $tone = $voiceSettings?->tone_description ?? 'Professional and empathetic';
    $signature = $voiceSettings?->signature ?? '';

    $systemPrompt = <<<PROMPT
You are a customer support specialist helping app developers respond to user reviews.
Generate a helpful, professional response to the following app review.

Tone guidelines: {$tone}
{$signature}

Rules:
- Keep response under 500 characters
- Be empathetic and acknowledge the user's feedback
- If it's a bug report, thank them and mention you're looking into it
- If it's positive, thank them genuinely
- Never be defensive or argumentative
- Match the language of the review
PROMPT;

    $userPrompt = <<<PROMPT
App: {$app->name}
Review Rating: {$review->rating}/5 stars
Review Title: {$review->title}
Review Content: {$review->content}

Generate a response:
PROMPT;

    $result = $this->openRouter->chat($systemPrompt, $userPrompt, false);

    if (!$result) {
        return response()->json(['message' => 'Failed to generate suggestion'], 500);
    }

    return response()->json([
        'data' => [
            'suggestion' => trim($result['content'] ?? ''),
        ],
    ]);
}
```

### Step 2: Add routes

Add to `api/routes/api.php`:

```php
// Reviews inbox (global)
Route::get('reviews/inbox', [ReviewsController::class, 'inbox']);

// Inside the apps routes with owns.app middleware:
Route::post('{app}/reviews/{review}/reply', [ReviewsController::class, 'reply']);
Route::post('{app}/reviews/{review}/suggest', [ReviewsController::class, 'suggestReply']);
```

### Step 3: Add use statements

Add to ReviewsController:
```php
use App\Services\AppStoreConnectService;
use App\Services\GooglePlayDeveloperService;
use App\Services\OpenRouterService;
use Illuminate\Support\Facades\Auth;
```

### Step 4: Commit

```bash
git add api/app/Http/Controllers/Api/ReviewsController.php api/routes/api.php
git commit -m "feat(api): add review inbox, reply, and AI suggestion endpoints"
```

---

## Task 7: Voice Settings Controller

**Files:**
- Create: `api/app/Http/Controllers/Api/VoiceSettingsController.php`
- Modify: `api/routes/api.php`

### Step 1: Create controller

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppVoiceSetting;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class VoiceSettingsController extends Controller
{
    public function show(App $app): JsonResponse
    {
        $settings = $app->getVoiceSettingForUser(Auth::id());

        return response()->json([
            'data' => $settings ? [
                'tone_description' => $settings->tone_description,
                'default_language' => $settings->default_language,
                'signature' => $settings->signature,
            ] : null,
        ]);
    }

    public function update(Request $request, App $app): JsonResponse
    {
        $request->validate([
            'tone_description' => 'nullable|string|max:500',
            'default_language' => 'nullable|string|max:10',
            'signature' => 'nullable|string|max:100',
        ]);

        $settings = AppVoiceSetting::updateOrCreate(
            ['app_id' => $app->id, 'user_id' => Auth::id()],
            $request->only(['tone_description', 'default_language', 'signature'])
        );

        return response()->json([
            'message' => 'Voice settings updated',
            'data' => [
                'tone_description' => $settings->tone_description,
                'default_language' => $settings->default_language,
                'signature' => $settings->signature,
            ],
        ]);
    }
}
```

### Step 2: Add routes

Add inside the apps routes with owns.app middleware:
```php
Route::get('{app}/voice-settings', [VoiceSettingsController::class, 'show']);
Route::put('{app}/voice-settings', [VoiceSettingsController::class, 'update']);
```

Add use statement:
```php
use App\Http\Controllers\Api\VoiceSettingsController;
```

### Step 3: Commit

```bash
git add api/app/Http/Controllers/Api/VoiceSettingsController.php api/routes/api.php
git commit -m "feat(api): add voice settings endpoints for AI tone customization"
```

---

## Task 8: Review Sync CRON Job

**Files:**
- Create: `api/app/Console/Commands/SyncConnectedReviews.php`
- Modify: `api/app/Console/Kernel.php` or `api/routes/console.php`

### Step 1: Create command

```php
<?php

namespace App\Console\Commands;

use App\Models\App;
use App\Models\AppReview;
use App\Models\StoreConnection;
use App\Services\AppStoreConnectService;
use App\Services\GooglePlayDeveloperService;
use App\Services\OpenRouterService;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;

class SyncConnectedReviews extends Command
{
    protected $signature = 'reviews:sync-connected {--user= : Sync for specific user}';
    protected $description = 'Sync reviews from connected store accounts';

    public function __construct(
        private AppStoreConnectService $appStoreConnect,
        private GooglePlayDeveloperService $googlePlay,
        private OpenRouterService $openRouter,
    ) {
        parent::__construct();
    }

    public function handle(): int
    {
        $query = StoreConnection::where('status', 'active');

        if ($userId = $this->option('user')) {
            $query->where('user_id', $userId);
        }

        $connections = $query->get();
        $this->info("Syncing reviews for {$connections->count()} connections");

        foreach ($connections as $connection) {
            $this->syncConnection($connection);
        }

        return Command::SUCCESS;
    }

    private function syncConnection(StoreConnection $connection): void
    {
        $user = $connection->user;
        $apps = $user->apps()->where('platform', $connection->platform)->get();

        foreach ($apps as $app) {
            $this->info("Syncing {$app->name} ({$connection->platform})");

            try {
                if ($connection->platform === 'ios') {
                    $this->syncIosReviews($connection, $app);
                } else {
                    $this->syncAndroidReviews($connection, $app);
                }
            } catch (\Exception $e) {
                Log::error("Failed to sync reviews for app {$app->id}", ['error' => $e->getMessage()]);
                $this->error("Failed: {$e->getMessage()}");
            }
        }

        $connection->updateLastSync();
    }

    private function syncIosReviews(StoreConnection $connection, App $app): void
    {
        $data = $this->appStoreConnect->getReviews($connection, $app->store_id);

        if (!$data || empty($data['data'])) {
            return;
        }

        foreach ($data['data'] as $reviewData) {
            $this->upsertReview($app, $reviewData, 'ios');
        }
    }

    private function syncAndroidReviews(StoreConnection $connection, App $app): void
    {
        $data = $this->googlePlay->getReviews($connection, $app->store_id);

        if (!$data || empty($data['reviews'])) {
            return;
        }

        foreach ($data['reviews'] as $reviewData) {
            $this->upsertReview($app, $reviewData, 'android');
        }
    }

    private function upsertReview(App $app, array $data, string $platform): void
    {
        $attrs = $platform === 'ios'
            ? $this->parseIosReview($data)
            : $this->parseAndroidReview($data);

        $review = AppReview::updateOrCreate(
            [
                'app_id' => $app->id,
                'review_id' => $attrs['review_id'],
                'country' => $attrs['country'] ?? 'US',
            ],
            $attrs
        );

        // Analyze sentiment if not set
        if (!$review->sentiment) {
            $this->analyzeSentiment($review);
        }
    }

    private function parseIosReview(array $data): array
    {
        $attrs = $data['attributes'] ?? [];
        return [
            'review_id' => $data['id'],
            'author' => $attrs['reviewerNickname'] ?? 'Anonymous',
            'title' => $attrs['title'] ?? null,
            'content' => $attrs['body'] ?? '',
            'rating' => $attrs['rating'] ?? 0,
            'country' => $attrs['territory'] ?? 'US',
            'reviewed_at' => $attrs['createdDate'] ?? now(),
        ];
    }

    private function parseAndroidReview(array $data): array
    {
        $comment = $data['comments'][0]['userComment'] ?? [];
        return [
            'review_id' => $data['reviewId'],
            'author' => $data['authorName'] ?? 'Anonymous',
            'title' => null,
            'content' => $comment['text'] ?? '',
            'rating' => $comment['starRating'] ?? 0,
            'country' => 'US', // Google doesn't expose country easily
            'reviewed_at' => isset($comment['lastModified']['seconds'])
                ? \Carbon\Carbon::createFromTimestamp($comment['lastModified']['seconds'])
                : now(),
        ];
    }

    private function analyzeSentiment(AppReview $review): void
    {
        // Simple rule-based for speed, or use AI
        if ($review->rating >= 4) {
            $sentiment = 'positive';
        } elseif ($review->rating <= 2) {
            $sentiment = 'negative';
        } else {
            $sentiment = 'neutral';
        }

        $review->update(['sentiment' => $sentiment]);
    }
}
```

### Step 2: Register in scheduler

Add to `api/routes/console.php` or `app/Console/Kernel.php`:

```php
// In routes/console.php:
use Illuminate\Support\Facades\Schedule;

Schedule::command('reviews:sync-connected')->everyTwelveHours();
```

### Step 3: Commit

```bash
git add api/app/Console/Commands/SyncConnectedReviews.php api/routes/console.php
git commit -m "feat(api): add CRON job to sync reviews from connected stores"
```

---

## Task 9: Flutter - Models & Repository

**Files:**
- Create: `app/lib/features/store_connections/domain/store_connection_model.dart`
- Create: `app/lib/features/store_connections/data/store_connections_repository.dart`
- Modify: `app/lib/features/reviews/domain/review_model.dart`
- Modify: `app/lib/features/reviews/data/reviews_repository.dart`

### Step 1: Create StoreConnection model

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_connection_model.freezed.dart';
part 'store_connection_model.g.dart';

@freezed
class StoreConnection with _$StoreConnection {
  const factory StoreConnection({
    required int id,
    required String platform,
    required String status,
    required DateTime connectedAt,
    DateTime? lastSyncAt,
  }) = _StoreConnection;

  factory StoreConnection.fromJson(Map<String, dynamic> json) =>
      _$StoreConnectionFromJson(json);
}
```

### Step 2: Create StoreConnections repository

```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../domain/store_connection_model.dart';

final storeConnectionsRepositoryProvider = Provider<StoreConnectionsRepository>((ref) {
  return StoreConnectionsRepository(ref.watch(dioProvider));
});

class StoreConnectionsRepository {
  final Dio dio;

  StoreConnectionsRepository(this.dio);

  Future<List<StoreConnection>> getConnections() async {
    final response = await dio.get('/store-connections');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => StoreConnection.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<StoreConnection> connectApple({
    required String issuerId,
    required String keyId,
    required String privateKey,
  }) async {
    final response = await dio.post('/store-connections/apple', data: {
      'issuer_id': issuerId,
      'key_id': keyId,
      'private_key': privateKey,
    });
    return StoreConnection.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<StoreConnection> connectGoogle({
    required String clientId,
    required String clientSecret,
    required String refreshToken,
  }) async {
    final response = await dio.post('/store-connections/google', data: {
      'client_id': clientId,
      'client_secret': clientSecret,
      'refresh_token': refreshToken,
    });
    return StoreConnection.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> disconnect(String platform) async {
    await dio.delete('/store-connections/$platform');
  }
}
```

### Step 3: Update Review model

Add to `app/lib/features/reviews/domain/review_model.dart`:

```dart
class Review {
  final int id;
  final String author;
  final String? title;
  final String content;
  final int rating;
  final String? version;
  final String country;
  final String? sentiment;
  final DateTime reviewedAt;
  final String? ourResponse;
  final DateTime? respondedAt;
  final ReviewApp? app; // For inbox view

  Review({
    required this.id,
    required this.author,
    this.title,
    required this.content,
    required this.rating,
    this.version,
    required this.country,
    this.sentiment,
    required this.reviewedAt,
    this.ourResponse,
    this.respondedAt,
    this.app,
  });

  bool get isAnswered => respondedAt != null;

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      author: json['author'] as String,
      title: json['title'] as String?,
      content: json['content'] as String? ?? '',
      rating: json['rating'] as int,
      version: json['version'] as String?,
      country: json['country'] as String? ?? 'US',
      sentiment: json['sentiment'] as String?,
      reviewedAt: DateTime.parse(json['reviewed_at'] as String),
      ourResponse: json['our_response'] as String?,
      respondedAt: json['responded_at'] != null
          ? DateTime.parse(json['responded_at'] as String)
          : null,
      app: json['app'] != null
          ? ReviewApp.fromJson(json['app'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ReviewApp {
  final int id;
  final String name;
  final String? iconUrl;
  final String platform;

  ReviewApp({
    required this.id,
    required this.name,
    this.iconUrl,
    required this.platform,
  });

  factory ReviewApp.fromJson(Map<String, dynamic> json) {
    return ReviewApp(
      id: json['id'] as int,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      platform: json['platform'] as String,
    );
  }
}
```

### Step 4: Update Reviews repository

Add to `app/lib/features/reviews/data/reviews_repository.dart`:

```dart
Future<PaginatedReviews> getInbox({
  String? status,
  int? rating,
  String? sentiment,
  int? appId,
  String? country,
  String? search,
  int page = 1,
  int perPage = 20,
}) async {
  final response = await dio.get('/reviews/inbox', queryParameters: {
    if (status != null) 'status': status,
    if (rating != null) 'rating': rating,
    if (sentiment != null) 'sentiment': sentiment,
    if (appId != null) 'app_id': appId,
    if (country != null) 'country': country,
    if (search != null) 'search': search,
    'page': page,
    'per_page': perPage,
  });

  return PaginatedReviews.fromJson(response.data);
}

Future<Review> replyToReview(int appId, int reviewId, String response) async {
  final result = await dio.post('/apps/$appId/reviews/$reviewId/reply', data: {
    'response': response,
  });
  return Review.fromJson(result.data['data'] as Map<String, dynamic>);
}

Future<String> suggestReply(int appId, int reviewId) async {
  final response = await dio.post('/apps/$appId/reviews/$reviewId/suggest');
  return response.data['data']['suggestion'] as String;
}
```

Add this class:

```dart
class PaginatedReviews {
  final List<Review> reviews;
  final int currentPage;
  final int lastPage;
  final int total;

  PaginatedReviews({
    required this.reviews,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory PaginatedReviews.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>;
    final meta = json['meta'] as Map<String, dynamic>;
    return PaginatedReviews(
      reviews: data.map((e) => Review.fromJson(e as Map<String, dynamic>)).toList(),
      currentPage: meta['current_page'] as int,
      lastPage: meta['last_page'] as int,
      total: meta['total'] as int,
    );
  }
}
```

### Step 5: Run build_runner

Run: `cd /Users/jerome/Projets/web/flutter/ranking/app && dart run build_runner build --delete-conflicting-outputs`
Expected: Generated files created

### Step 6: Commit

```bash
git add app/lib/features/
git commit -m "feat(flutter): add store connection and review reply models/repositories"
```

---

## Task 10: Flutter - Providers

**Files:**
- Create: `app/lib/features/store_connections/providers/store_connections_provider.dart`
- Modify: `app/lib/features/reviews/providers/reviews_provider.dart`

### Step 1: Create StoreConnections provider

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/store_connections_repository.dart';
import '../domain/store_connection_model.dart';

final storeConnectionsProvider = AsyncNotifierProvider<StoreConnectionsNotifier, List<StoreConnection>>(() {
  return StoreConnectionsNotifier();
});

class StoreConnectionsNotifier extends AsyncNotifier<List<StoreConnection>> {
  @override
  Future<List<StoreConnection>> build() async {
    return ref.watch(storeConnectionsRepositoryProvider).getConnections();
  }

  Future<void> connectApple({
    required String issuerId,
    required String keyId,
    required String privateKey,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(storeConnectionsRepositoryProvider).connectApple(
        issuerId: issuerId,
        keyId: keyId,
        privateKey: privateKey,
      );
      return ref.read(storeConnectionsRepositoryProvider).getConnections();
    });
  }

  Future<void> connectGoogle({
    required String clientId,
    required String clientSecret,
    required String refreshToken,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(storeConnectionsRepositoryProvider).connectGoogle(
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
      );
      return ref.read(storeConnectionsRepositoryProvider).getConnections();
    });
  }

  Future<void> disconnect(String platform) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(storeConnectionsRepositoryProvider).disconnect(platform);
      return ref.read(storeConnectionsRepositoryProvider).getConnections();
    });
  }

  bool isConnected(String platform) {
    return state.valueOrNull?.any((c) => c.platform == platform && c.status == 'active') ?? false;
  }
}
```

### Step 2: Update Reviews provider

Add to `app/lib/features/reviews/providers/reviews_provider.dart`:

```dart
final reviewsInboxProvider = FutureProvider.family<PaginatedReviews, ReviewsInboxParams>((ref, params) async {
  return ref.watch(reviewsRepositoryProvider).getInbox(
    status: params.status,
    rating: params.rating,
    sentiment: params.sentiment,
    appId: params.appId,
    country: params.country,
    search: params.search,
    page: params.page,
  );
});

class ReviewsInboxParams {
  final String? status;
  final int? rating;
  final String? sentiment;
  final int? appId;
  final String? country;
  final String? search;
  final int page;

  ReviewsInboxParams({
    this.status,
    this.rating,
    this.sentiment,
    this.appId,
    this.country,
    this.search,
    this.page = 1,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReviewsInboxParams &&
        other.status == status &&
        other.rating == rating &&
        other.sentiment == sentiment &&
        other.appId == appId &&
        other.country == country &&
        other.search == search &&
        other.page == page;
  }

  @override
  int get hashCode => Object.hash(status, rating, sentiment, appId, country, search, page);
}
```

### Step 3: Commit

```bash
git add app/lib/features/
git commit -m "feat(flutter): add store connections and reviews inbox providers"
```

---

## Task 11: Flutter - Store Connections Screen

**Files:**
- Create: `app/lib/features/store_connections/presentation/store_connections_screen.dart`
- Create: `app/lib/features/store_connections/presentation/connect_apple_screen.dart`
- Modify: `app/lib/core/router/app_router.dart`

### Step 1: Create StoreConnections screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/store_connections_provider.dart';

class StoreConnectionsScreen extends ConsumerWidget {
  const StoreConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionsAsync = ref.watch(storeConnectionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Connections'),
      ),
      body: connectionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (connections) {
          final iosConnection = connections.where((c) => c.platform == 'ios').firstOrNull;
          final androidConnection = connections.where((c) => c.platform == 'android').firstOrNull;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ConnectionCard(
                title: 'App Store Connect',
                subtitle: 'Connect to reply to iOS reviews',
                icon: Icons.apple,
                connection: iosConnection,
                onConnect: () => context.push('/settings/connections/apple'),
                onDisconnect: () => ref.read(storeConnectionsProvider.notifier).disconnect('ios'),
              ),
              const SizedBox(height: 16),
              _ConnectionCard(
                title: 'Google Play Console',
                subtitle: 'Connect to reply to Android reviews',
                icon: Icons.android,
                connection: androidConnection,
                onConnect: () => context.push('/settings/connections/google'),
                onDisconnect: () => ref.read(storeConnectionsProvider.notifier).disconnect('android'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ConnectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final StoreConnection? connection;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const _ConnectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.connection,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    final isConnected = connection?.status == 'active';

    return Card(
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title),
        subtitle: Text(isConnected ? 'Connected' : subtitle),
        trailing: isConnected
            ? TextButton(
                onPressed: onDisconnect,
                child: const Text('Disconnect'),
              )
            : ElevatedButton(
                onPressed: onConnect,
                child: const Text('Connect'),
              ),
      ),
    );
  }
}
```

### Step 2: Create Connect Apple screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/store_connections_provider.dart';

class ConnectAppleScreen extends ConsumerStatefulWidget {
  const ConnectAppleScreen({super.key});

  @override
  ConsumerState<ConnectAppleScreen> createState() => _ConnectAppleScreenState();
}

class _ConnectAppleScreenState extends ConsumerState<ConnectAppleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _issuerIdController = TextEditingController();
  final _keyIdController = TextEditingController();
  final _privateKeyController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _issuerIdController.dispose();
    _keyIdController.dispose();
    _privateKeyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(storeConnectionsProvider.notifier).connectApple(
        issuerId: _issuerIdController.text.trim(),
        keyId: _keyIdController.text.trim(),
        privateKey: _privateKeyController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connected successfully!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect App Store Connect'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How to get your API Key:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '1. Go to App Store Connect > Users and Access > Keys\n'
                '2. Click the + button to create a new key\n'
                '3. Give it a name and select "App Manager" role\n'
                '4. Download the .p8 file and note the Key ID\n'
                '5. Copy the Issuer ID from the top of the page',
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _issuerIdController,
                decoration: const InputDecoration(
                  labelText: 'Issuer ID',
                  hintText: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                ),
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _keyIdController,
                decoration: const InputDecoration(
                  labelText: 'Key ID',
                  hintText: 'XXXXXXXXXX',
                ),
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _privateKeyController,
                decoration: const InputDecoration(
                  labelText: 'Private Key (paste .p8 content)',
                  hintText: '-----BEGIN PRIVATE KEY-----\n...',
                ),
                maxLines: 5,
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Connect'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Step 3: Add routes

Add to `app/lib/core/router/app_router.dart`:

```dart
GoRoute(
  path: '/settings/connections',
  builder: (context, state) => const StoreConnectionsScreen(),
  routes: [
    GoRoute(
      path: 'apple',
      builder: (context, state) => const ConnectAppleScreen(),
    ),
    GoRoute(
      path: 'google',
      builder: (context, state) => const ConnectGoogleScreen(),
    ),
  ],
),
```

### Step 4: Commit

```bash
git add app/lib/features/store_connections/ app/lib/core/router/
git commit -m "feat(flutter): add store connections screens"
```

---

## Task 12: Flutter - Reviews Inbox Screen

**Files:**
- Create: `app/lib/features/reviews/presentation/reviews_inbox_screen.dart`
- Create: `app/lib/features/reviews/presentation/widgets/review_card.dart`
- Create: `app/lib/features/reviews/presentation/widgets/reply_modal.dart`

### Step 1: Create ReviewsInbox screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/reviews_provider.dart';
import 'widgets/review_card.dart';
import 'widgets/reply_modal.dart';

class ReviewsInboxScreen extends ConsumerStatefulWidget {
  const ReviewsInboxScreen({super.key});

  @override
  ConsumerState<ReviewsInboxScreen> createState() => _ReviewsInboxScreenState();
}

class _ReviewsInboxScreenState extends ConsumerState<ReviewsInboxScreen> {
  String? _statusFilter = 'unanswered';
  int? _ratingFilter;
  String? _sentimentFilter;
  String? _searchQuery;
  int _currentPage = 1;

  ReviewsInboxParams get _params => ReviewsInboxParams(
    status: _statusFilter,
    rating: _ratingFilter,
    sentiment: _sentimentFilter,
    search: _searchQuery,
    page: _currentPage,
  );

  @override
  Widget build(BuildContext context) {
    final reviewsAsync = ref.watch(reviewsInboxProvider(_params));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews Inbox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Unanswered'),
                  selected: _statusFilter == 'unanswered',
                  onSelected: (v) => setState(() => _statusFilter = v ? 'unanswered' : null),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Negative'),
                  selected: _sentimentFilter == 'negative',
                  onSelected: (v) => setState(() => _sentimentFilter = v ? 'negative' : null),
                ),
                const SizedBox(width: 8),
                ...List.generate(5, (i) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text('${i + 1}★'),
                    selected: _ratingFilter == i + 1,
                    onSelected: (v) => setState(() => _ratingFilter = v ? i + 1 : null),
                  ),
                )),
              ],
            ),
          ),
          // Reviews list
          Expanded(
            child: reviewsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (paginated) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: paginated.reviews.length,
                itemBuilder: (context, index) {
                  final review = paginated.reviews[index];
                  return ReviewCard(
                    review: review,
                    onReply: () => _showReplyModal(review),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilters() {
    // TODO: Show filter bottom sheet
  }

  void _showReplyModal(Review review) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ReplyModal(review: review),
    );
  }
}
```

### Step 2: Create ReviewCard widget

```dart
import 'package:flutter/material.dart';
import '../../domain/review_model.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback onReply;

  const ReviewCard({
    super.key,
    required this.review,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                if (review.app != null) ...[
                  CircleAvatar(
                    backgroundImage: review.app!.iconUrl != null
                        ? NetworkImage(review.app!.iconUrl!)
                        : null,
                    radius: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      review.app!.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                _buildRatingStars(review.rating),
              ],
            ),
            const SizedBox(height: 8),
            // Author & date
            Row(
              children: [
                Text(
                  review.author,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(width: 8),
                Text(
                  '${review.country} · ${_formatDate(review.reviewedAt)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Title & content
            if (review.title != null) ...[
              Text(
                review.title!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
            ],
            Text(review.content),
            const SizedBox(height: 12),
            // Response or reply button
            if (review.isAnswered) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your response:',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(review.ourResponse!),
                  ],
                ),
              ),
            ] else ...[
              ElevatedButton.icon(
                onPressed: onReply,
                icon: const Icon(Icons.reply),
                label: const Text('Reply'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      children: List.generate(5, (i) => Icon(
        i < rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 16,
      )),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }
}
```

### Step 3: Create ReplyModal widget

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/reviews_repository.dart';
import '../../domain/review_model.dart';

class ReplyModal extends ConsumerStatefulWidget {
  final Review review;

  const ReplyModal({super.key, required this.review});

  @override
  ConsumerState<ReplyModal> createState() => _ReplyModalState();
}

class _ReplyModalState extends ConsumerState<ReplyModal> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  bool _isLoadingSuggestion = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _getSuggestion() async {
    setState(() => _isLoadingSuggestion = true);
    try {
      final suggestion = await ref.read(reviewsRepositoryProvider).suggestReply(
        widget.review.app!.id,
        widget.review.id,
      );
      _controller.text = suggestion;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingSuggestion = false);
    }
  }

  Future<void> _submit() async {
    if (_controller.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(reviewsRepositoryProvider).replyToReview(
        widget.review.app!.id,
        widget.review.id,
        _controller.text,
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reply sent!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Reply to review',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // AI suggestion button
          OutlinedButton.icon(
            onPressed: _isLoadingSuggestion ? null : _getSuggestion,
            icon: _isLoadingSuggestion
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_awesome),
            label: const Text('Generate AI suggestion'),
          ),
          const SizedBox(height: 16),
          // Response text field
          TextField(
            controller: _controller,
            maxLines: 5,
            maxLength: 5970,
            decoration: const InputDecoration(
              hintText: 'Write your response...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Send Reply'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
```

### Step 4: Add route

Add to router:
```dart
GoRoute(
  path: '/reviews',
  builder: (context, state) => const ReviewsInboxScreen(),
),
```

### Step 5: Commit

```bash
git add app/lib/features/reviews/presentation/
git commit -m "feat(flutter): add reviews inbox screen with reply and AI suggestion"
```

---

## Task 13: Add Navigation & Localization

**Files:**
- Modify: `app/lib/core/widgets/glass_bottom_nav_bar.dart` or navigation component
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/l10n/app_fr.arb`

### Step 1: Add navigation item for Reviews Inbox

Add a new navigation item for the Reviews Inbox in your navigation component.

### Step 2: Add localization strings

Add to `app_en.arb`:
```json
"reviewsInbox": "Reviews",
"replyToReview": "Reply",
"generateSuggestion": "Generate AI suggestion",
"sendReply": "Send Reply",
"unanswered": "Unanswered",
"answered": "Answered",
"yourResponse": "Your response",
"storeConnections": "Store Connections",
"connectAppStoreConnect": "Connect App Store Connect",
"connectGooglePlay": "Connect Google Play",
"connected": "Connected",
"disconnect": "Disconnect"
```

Add French translations to `app_fr.arb`:
```json
"reviewsInbox": "Avis",
"replyToReview": "Répondre",
"generateSuggestion": "Générer une suggestion IA",
"sendReply": "Envoyer",
"unanswered": "Sans réponse",
"answered": "Répondu",
"yourResponse": "Votre réponse",
"storeConnections": "Connexions aux stores",
"connectAppStoreConnect": "Connecter App Store Connect",
"connectGooglePlay": "Connecter Google Play",
"connected": "Connecté",
"disconnect": "Déconnecter"
```

### Step 3: Regenerate localizations

Run: `cd /Users/jerome/Projets/web/flutter/ranking/app && flutter gen-l10n`

### Step 4: Commit

```bash
git add app/lib/
git commit -m "feat(flutter): add reviews inbox navigation and localization"
```

---

## Task 14: Final Testing & Cleanup

### Step 1: Run backend tests

Run: `cd /Users/jerome/Projets/web/flutter/ranking/api && php artisan test`
Expected: All tests pass

### Step 2: Run Flutter analyzer

Run: `cd /Users/jerome/Projets/web/flutter/ranking/app && flutter analyze`
Expected: No issues found

### Step 3: Build Flutter app

Run: `cd /Users/jerome/Projets/web/flutter/ranking/app && flutter build web`
Expected: Build successful

### Step 4: Final commit

```bash
git add .
git commit -m "feat: complete Phase 1 - Reply to reviews implementation"
```

---

## Summary

This plan implements:

1. **Database:** 3 new migrations for store connections, voice settings, and review reply fields
2. **Backend Services:** App Store Connect and Google Play API integrations
3. **API Endpoints:** Store connections, review inbox, reply, AI suggestions, voice settings
4. **CRON Job:** Automatic review sync from connected stores
5. **Flutter:** Models, repositories, providers for store connections and reviews
6. **Flutter UI:** Store connections screen, reviews inbox with filters, reply modal with AI suggestions
7. **Localization:** English and French strings

Total: ~14 tasks, estimated 50-70 individual steps.
