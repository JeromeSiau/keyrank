# Unified Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Consolidation des 3 plans (Security, Performance, Code Quality) en un seul document ordonné pour éviter les conflits et respecter les dépendances.

**Architecture:** Approche séquentielle avec dépendances respectées :
1. Sécurité critique (secrets, git) en premier
2. Migrations DB avant les changements de code
3. Extraction des providers avant les optimisations `.select()`
4. Vérification unique à la fin

**Tech Stack:** Flutter 3.x, Riverpod 2.6+, Freezed, Dio, Laravel 11, Sanctum, MySQL 8+, Redis

---

## Phase 1: Security - Git Cleanup & Secrets (CRITICAL - FIRST)

### Task 1: Remove .env from Git History

**Source:** Security Plan Task 1
**Priority:** 🔴 Critical

**Files:**
- Modify: `.gitignore` (ensure .env is listed)
- Delete from history: `api/.env`

**Step 1: Verify .env is in .gitignore**

```bash
grep "^\.env$" api/.gitignore
```

Expected: `.env` (already present)

**Step 2: Create backup of current .env**

```bash
cp api/.env api/.env.backup.local
```

**Step 3: Remove .env from Git history using git filter-repo**

```bash
# Install git-filter-repo if needed
brew install git-filter-repo

# Remove .env from entire history
cd /Users/jerome/Projets/web/flutter/ranking
git filter-repo --path api/.env --invert-paths --force
```

**Step 4: Force push to remote (CAUTION: coordinate with team)**

```bash
git push origin main --force-with-lease
```

**Step 5: Verify .env is not tracked**

```bash
git ls-files | grep "\.env$"
```

Expected: No output (file not tracked)

---

### Task 2: Remove Firebase Config Files from Git

**Source:** Security Plan Task 2
**Priority:** 🔴 Critical

**Files:**
- Modify: `app/.gitignore`
- Delete from history: `app/ios/Runner/GoogleService-Info.plist`
- Delete from history: `app/android/app/google-services.json`

**Step 1: Add Firebase configs to .gitignore**

Add to `app/.gitignore`:

```gitignore
# Firebase configuration (contains API keys)
ios/Runner/GoogleService-Info.plist
android/app/google-services.json
```

**Step 2: Create backups**

```bash
cp app/ios/Runner/GoogleService-Info.plist app/ios/Runner/GoogleService-Info.plist.backup
cp app/android/app/google-services.json app/android/app/google-services.json.backup
```

**Step 3: Remove from Git tracking (keep local files)**

```bash
git rm --cached app/ios/Runner/GoogleService-Info.plist
git rm --cached app/android/app/google-services.json
```

**Step 4: Commit the .gitignore update**

```bash
git add app/.gitignore
git commit -m "chore: add Firebase config files to .gitignore for security"
```

---

### Task 3: Rotate All Exposed Secrets

**Source:** Security Plan Task 3
**Priority:** 🔴 Critical

**Action items (manual - do in respective dashboards):**

1. **Apple Search Ads** - Generate new private key in App Store Connect
2. **OpenRouter** - Revoke and regenerate API key at openrouter.ai
3. **Stripe** - Roll API keys in Stripe Dashboard (test → production)
4. **Brevo/Sendinblue** - Reset SMTP password
5. **Firebase** - Regenerate API keys in Firebase Console
6. **Laravel APP_KEY** - Regenerate with `php artisan key:generate`

**Step 1: After rotating, update .env.example with placeholders**

Modify `api/.env.example`:

```env
APP_KEY=base64:GENERATE_NEW_KEY_WITH_php_artisan_key:generate

APPLE_SEARCH_ADS_CLIENT_ID=your-client-id
APPLE_SEARCH_ADS_TEAM_ID=your-team-id
APPLE_SEARCH_ADS_KEY_ID=your-key-id
APPLE_SEARCH_ADS_ORG_ID=your-org-id
APPLE_SEARCH_ADS_PRIVATE_KEY="-----BEGIN EC PRIVATE KEY-----\nYOUR_KEY_HERE\n-----END EC PRIVATE KEY-----"

OPENROUTER_API_KEY=sk-or-v1-your-key-here

STRIPE_KEY=pk_test_your-publishable-key
STRIPE_SECRET=sk_test_your-secret-key

MAIL_USERNAME=your-smtp-username
MAIL_PASSWORD=your-smtp-password
```

**Step 2: Commit .env.example update**

```bash
git add api/.env.example
git commit -m "chore: update .env.example with placeholder values"
```

---

## Phase 2: Database Migrations (Before Code Changes)

### Task 4: Fix Index Migration for team_id

**Source:** Performance Plan Task 8
**Priority:** 🔴 Critical
**Dependency:** Must run BEFORE Task 5 (ExportController fix)

**Files:**
- Create: `api/database/migrations/2026_01_17_400000_fix_tracked_keywords_team_index.php`

**Step 1: Create migration**

Run: `cd api && php artisan make:migration fix_tracked_keywords_team_index`

**Step 2: Write the migration**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('tracked_keywords', function (Blueprint $table) {
            // Drop old user_id index if it exists
            try {
                $table->dropIndex('tracked_user_app');
            } catch (\Exception $e) {
                // Index might not exist
            }

            // Add correct team_id indexes
            $table->index(['team_id', 'app_id'], 'tracked_team_app');
            $table->index(['team_id', 'keyword_id'], 'tracked_team_keyword');
        });
    }

    public function down(): void
    {
        Schema::table('tracked_keywords', function (Blueprint $table) {
            $table->dropIndex('tracked_team_app');
            $table->dropIndex('tracked_team_keyword');
        });
    }
};
```

**Step 3: Run the migration**

Run: `cd api && php artisan migrate`
Expected: Migration runs successfully

**Step 4: Commit**

```bash
git add api/database/migrations/2026_01_17_400000_fix_tracked_keywords_team_index.php
git commit -m "perf: add correct team_id indexes to tracked_keywords table"
```

---

## Phase 3: Critical Bug Fixes

### Task 5: Fix ExportController Broken user_id Reference

**Source:** Code Quality Plan Task 1
**Priority:** 🔴 Critical
**Dependency:** Task 4 (migration) should be run first

**Files:**
- Modify: `api/app/Http/Controllers/Api/ExportController.php:31-32`

**Step 1: Read the current implementation**

Open `api/app/Http/Controllers/Api/ExportController.php` and locate the broken query.

**Step 2: Fix the user_id to team_id reference**

Find:
```php
$trackedKeywordIds = TrackedKeyword::where('app_id', $app->id)
    ->where('user_id', $user->id)
    ->pluck('id');
```

Replace with:
```php
$team = $request->user()->currentTeam();
if (!$team) {
    abort(403, 'No team selected');
}

$trackedKeywordIds = TrackedKeyword::where('app_id', $app->id)
    ->where('team_id', $team->id)
    ->pluck('id');
```

**Step 3: Run Laravel tests**

Run: `cd api && php artisan test --filter=Export`
Expected: Tests pass (or no tests exist yet - that's ok)

**Step 4: Commit**

```bash
git add api/app/Http/Controllers/Api/ExportController.php
git commit -m "fix: replace broken user_id with team_id in ExportController"
```

---

### Task 6: Add Authorization Check to AppController.show()

**Source:** Code Quality Plan Task 2
**Priority:** 🔴 Critical

**Files:**
- Modify: `api/app/Http/Controllers/Api/AppController.php:292-311`

**Step 1: Read the current show method**

Open `api/app/Http/Controllers/Api/AppController.php` and locate the `show()` method.

**Step 2: Add team ownership verification**

Find the beginning of the method:
```php
public function show(Request $request, App $app): JsonResponse
{
    $team = $this->currentTeam();
```

Replace with:
```php
public function show(Request $request, App $app): JsonResponse
{
    $team = $this->currentTeam();

    // Verify team owns this app
    if (!$app->teams()->where('teams.id', $team->id)->exists()) {
        abort(404, 'App not found');
    }
```

**Step 3: Run Laravel tests**

Run: `cd api && php artisan test --filter=AppController`
Expected: All tests pass

**Step 4: Commit**

```bash
git add api/app/Http/Controllers/Api/AppController.php
git commit -m "fix: add team authorization check to AppController.show()"
```

---

### Task 7: Add Error Handling to DashboardRepository

**Source:** Code Quality Plan Task 3
**Priority:** 🔴 Critical

**Files:**
- Modify: `app/lib/features/dashboard/data/dashboard_repository.dart:5-31`

**Step 1: Read the current implementation**

Open `app/lib/features/dashboard/data/dashboard_repository.dart`.

**Step 2: Add try-catch to getHeroMetrics**

Find:
```dart
Future<HeroMetrics> getHeroMetrics({int? appId}) async {
  final queryParams = <String, dynamic>{};
  if (appId != null) {
    queryParams['app_id'] = appId.toString();
  }

  final response = await _dio.get(
    '/dashboard/metrics',
    queryParameters: queryParams,
  );
  return HeroMetrics.fromJson(response.data['data']);
}
```

Replace with:
```dart
Future<HeroMetrics> getHeroMetrics({int? appId}) async {
  try {
    final queryParams = <String, dynamic>{};
    if (appId != null) {
      queryParams['app_id'] = appId.toString();
    }

    final response = await _dio.get(
      '/dashboard/metrics',
      queryParameters: queryParams,
    );
    return HeroMetrics.fromJson(response.data['data']);
  } on DioException catch (e) {
    throw ApiException.fromDioError(e);
  }
}
```

**Step 3: Add try-catch to getMovers**

Find:
```dart
Future<MoversData> getMovers({int? appId, String period = '7d'}) async {
  final queryParams = <String, dynamic>{'period': period};
  if (appId != null) {
    queryParams['app_id'] = appId.toString();
  }

  final response = await _dio.get(
    '/dashboard/movers',
    queryParameters: queryParams,
  );
  return MoversData.fromJson(response.data['data']);
}
```

Replace with:
```dart
Future<MoversData> getMovers({int? appId, String period = '7d'}) async {
  try {
    final queryParams = <String, dynamic>{'period': period};
    if (appId != null) {
      queryParams['app_id'] = appId.toString();
    }

    final response = await _dio.get(
      '/dashboard/movers',
      queryParameters: queryParams,
    );
    return MoversData.fromJson(response.data['data']);
  } on DioException catch (e) {
    throw ApiException.fromDioError(e);
  }
}
```

**Step 4: Verify import exists**

Ensure at top of file:
```dart
import 'package:dio/dio.dart';
import 'package:ranking/core/api/api_exception.dart';
```

**Step 5: Run Flutter analyze**

Run: `cd app && flutter analyze lib/features/dashboard/`
Expected: No errors

**Step 6: Commit**

```bash
git add app/lib/features/dashboard/data/dashboard_repository.dart
git commit -m "fix: add error handling to dashboard repository API calls"
```

---

### Task 8: Add Validation Limits to Bulk Operations

**Source:** Code Quality Plan Task 4
**Priority:** 🔴 Critical

**Files:**
- Modify: `api/app/Http/Controllers/Api/KeywordController.php:414-416`

**Step 1: Read the current bulkDelete validation**

Open `api/app/Http/Controllers/Api/KeywordController.php` and locate `bulkDelete()`.

**Step 2: Add max limit to array validation**

Find:
```php
$validated = $request->validate([
    'tracked_keyword_ids' => 'required|array|min:1',
    'tracked_keyword_ids.*' => 'integer|exists:tracked_keywords,id',
]);
```

Replace with:
```php
$validated = $request->validate([
    'tracked_keyword_ids' => 'required|array|min:1|max:500',
    'tracked_keyword_ids.*' => 'integer|exists:tracked_keywords,id',
]);
```

**Step 3: Apply same fix to bulkAddTags and bulkFavorite**

Search for other bulk methods and add `max:500` to array validations.

**Step 4: Run Laravel tests**

Run: `cd api && php artisan test --filter=Keyword`
Expected: All tests pass

**Step 5: Commit**

```bash
git add api/app/Http/Controllers/Api/KeywordController.php
git commit -m "fix: add max limit to bulk operation validations to prevent DoS"
```

---

## Phase 4: Security - CORS & Token Configuration

### Task 9: Fix CORS Configuration

**Source:** Security Plan Task 4
**Priority:** 🔴 Critical

**Files:**
- Modify: `api/config/cors.php`

**Step 1: Read current CORS config**

```bash
cat api/config/cors.php
```

**Step 2: Update CORS configuration**

Replace `api/config/cors.php` content:

```php
<?php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    'allowed_origins' => explode(',', env('CORS_ALLOWED_ORIGINS', 'http://localhost:3000,http://127.0.0.1:3000')),
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['Content-Type', 'Accept', 'Authorization', 'X-Requested-With', 'X-API-Key'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false, // Changed from true - not needed for Bearer token auth
];
```

**Step 3: Add CORS_ALLOWED_ORIGINS to .env.example**

Add to `api/.env.example`:

```env
# CORS - comma-separated list of allowed origins
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:8080
# Production example: CORS_ALLOWED_ORIGINS=https://app.keyrank.com,https://keyrank.com
```

**Step 4: Run tests to verify API still works**

```bash
cd api && php artisan test --filter=AuthController
```

Expected: All tests pass

**Step 5: Commit**

```bash
git add api/config/cors.php api/.env.example
git commit -m "security: restrict CORS to specific origins and methods"
```

---

### Task 10: Configure Token Expiration

**Source:** Security Plan Task 5
**Priority:** 🔴 Critical

**Files:**
- Modify: `api/config/sanctum.php`

**Step 1: Update Sanctum config for token expiration**

Edit `api/config/sanctum.php`, change line ~50:

```php
'expiration' => env('SANCTUM_TOKEN_EXPIRATION', 60), // 60 minutes, was null
```

**Step 2: Add to .env.example**

```env
# Sanctum token expiration in minutes (default: 60)
SANCTUM_TOKEN_EXPIRATION=60
```

**Step 3: Commit**

```bash
git add api/config/sanctum.php api/.env.example
git commit -m "security: set token expiration to 60 minutes"
```

---

### Task 11: Configure Secure Session Cookies

**Source:** Security Plan Task 6
**Priority:** 🔴 Critical

**Files:**
- Modify: `api/config/session.php`
- Modify: `api/.env.example`

**Step 1: Update session.php for secure defaults**

Edit `api/config/session.php`:

Line ~50 (encrypt):
```php
'encrypt' => env('SESSION_ENCRYPT', true), // Changed default to true
```

Line ~172 (secure):
```php
'secure' => env('SESSION_SECURE_COOKIE', true), // Changed default to true
```

Line ~202 (same_site):
```php
'same_site' => env('SESSION_SAME_SITE', 'strict'), // Changed from 'lax' to 'strict'
```

**Step 2: Add session vars to .env.example**

```env
# Session security
SESSION_ENCRYPT=true
SESSION_SECURE_COOKIE=true
SESSION_SAME_SITE=strict
```

**Step 3: Commit**

```bash
git add api/config/session.php api/.env.example
git commit -m "security: enable session encryption and secure cookies"
```

---

## Phase 5: Security - Authentication Hardening

### Task 12: Strengthen Password Requirements

**Source:** Security Plan Task 7
**Priority:** 🟠 High

**Files:**
- Modify: `api/app/Http/Controllers/Api/AuthController.php`

**Step 1: Write test for password complexity**

Create/modify `api/tests/Feature/AuthControllerTest.php`:

```php
public function test_register_requires_strong_password(): void
{
    // Weak password should fail
    $response = $this->postJson('/api/auth/register', [
        'name' => 'Test User',
        'email' => 'test@example.com',
        'password' => '12345678', // No uppercase, no special char
        'password_confirmation' => '12345678',
    ]);

    $response->assertStatus(422);
    $response->assertJsonValidationErrors(['password']);
}

public function test_register_accepts_strong_password(): void
{
    $response = $this->postJson('/api/auth/register', [
        'name' => 'Test User',
        'email' => 'strong' . time() . '@example.com',
        'password' => 'SecurePass123!',
        'password_confirmation' => 'SecurePass123!',
    ]);

    $response->assertStatus(201);
}
```

**Step 2: Run test to verify it fails**

```bash
cd api && php artisan test --filter=test_register_requires_strong_password
```

Expected: FAIL (weak password currently accepted)

**Step 3: Update validation in AuthController**

Edit `api/app/Http/Controllers/Api/AuthController.php`, lines 21-25:

```php
$validated = $request->validate([
    'name' => 'required|string|max:255',
    'email' => 'required|string|email|max:255|unique:users',
    'password' => [
        'required',
        'string',
        'min:10',
        'confirmed',
        'regex:/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{10,}$/',
    ],
], [
    'password.regex' => 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character (@$!%*?&).',
]);
```

**Step 4: Run tests to verify they pass**

```bash
cd api && php artisan test --filter=AuthController
```

Expected: All tests pass

**Step 5: Commit**

```bash
git add api/app/Http/Controllers/Api/AuthController.php api/tests/Feature/AuthControllerTest.php
git commit -m "security: enforce strong password requirements"
```

---

### Task 13: Implement Rate Limiting on Login

**Source:** Security Plan Task 8
**Priority:** 🟠 High

**Files:**
- Modify: `api/routes/api.php`
- Create: `api/app/Http/Middleware/LoginRateLimiter.php`

**Step 1: Create custom rate limiter middleware**

Create `api/app/Http/Middleware/LoginRateLimiter.php`:

```php
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\RateLimiter;
use Symfony\Component\HttpFoundation\Response;

class LoginRateLimiter
{
    public function handle(Request $request, Closure $next): Response
    {
        $key = 'login:' . $request->ip();

        if (RateLimiter::tooManyAttempts($key, 5)) {
            $seconds = RateLimiter::availableIn($key);
            return response()->json([
                'message' => "Too many login attempts. Please try again in {$seconds} seconds.",
            ], 429);
        }

        $response = $next($request);

        // Only count failed attempts
        if ($response->getStatusCode() === 422 || $response->getStatusCode() === 401) {
            RateLimiter::hit($key, 300); // 5 minute decay
        } else {
            RateLimiter::clear($key);
        }

        return $response;
    }
}
```

**Step 2: Register middleware in bootstrap/app.php**

Edit `api/bootstrap/app.php`, add alias:

```php
->withMiddleware(function (Middleware $middleware) {
    $middleware->alias([
        'login.rate' => \App\Http\Middleware\LoginRateLimiter::class,
    ]);
})
```

**Step 3: Update routes to use new middleware**

Edit `api/routes/api.php`, line ~46:

```php
Route::post('login', [AuthController::class, 'login'])->middleware(['throttle:10,1', 'login.rate']);
```

**Step 4: Test rate limiting manually**

```bash
# Run 6 failed login attempts rapidly
for i in {1..6}; do
  curl -X POST http://localhost:8000/api/auth/login \
    -H "Content-Type: application/json" \
    -d '{"email":"wrong@test.com","password":"wrong"}'
done
```

Expected: 6th request returns 429 Too Many Requests

**Step 5: Commit**

```bash
git add api/app/Http/Middleware/LoginRateLimiter.php api/bootstrap/app.php api/routes/api.php
git commit -m "security: implement rate limiting with lockout for failed logins"
```

---

## Phase 6: Security Headers

### Task 14: Add Security Headers Middleware

**Source:** Security Plan Task 9
**Priority:** 🟠 High

**Files:**
- Create: `api/app/Http/Middleware/SecurityHeaders.php`
- Modify: `api/bootstrap/app.php`

**Step 1: Create SecurityHeaders middleware**

Create `api/app/Http/Middleware/SecurityHeaders.php`:

```php
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class SecurityHeaders
{
    public function handle(Request $request, Closure $next): Response
    {
        $response = $next($request);

        $response->headers->set('X-Content-Type-Options', 'nosniff');
        $response->headers->set('X-Frame-Options', 'DENY');
        $response->headers->set('X-XSS-Protection', '1; mode=block');
        $response->headers->set('Referrer-Policy', 'strict-origin-when-cross-origin');
        $response->headers->set('Permissions-Policy', 'geolocation=(), microphone=(), camera=()');

        // Only add HSTS in production with HTTPS
        if (config('app.env') === 'production' && $request->secure()) {
            $response->headers->set('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
        }

        return $response;
    }
}
```

**Step 2: Register as global middleware**

Edit `api/bootstrap/app.php`:

```php
->withMiddleware(function (Middleware $middleware) {
    $middleware->append(\App\Http\Middleware\SecurityHeaders::class);
    // ... existing middleware
})
```

**Step 3: Test headers are present**

```bash
curl -I http://localhost:8000/api/countries
```

Expected: Response includes X-Content-Type-Options, X-Frame-Options, etc.

**Step 4: Commit**

```bash
git add api/app/Http/Middleware/SecurityHeaders.php api/bootstrap/app.php
git commit -m "security: add security headers middleware"
```

---

## Phase 7: Flutter Code Organization (BEFORE Performance .select() fixes)

> ⚠️ **IMPORTANT:** Ces tâches DOIVENT être exécutées AVANT les tâches de Performance qui utilisent `.select()` car elles renomment les providers.

### Task 15: Extract AppsListScreen Providers

**Source:** Code Quality Plan Task 7
**Priority:** 🟠 High
**Dependency:** Must be completed BEFORE Task 24 (Performance .select())

**Files:**
- Create: `app/lib/features/apps/providers/apps_filter_providers.dart`
- Modify: `app/lib/features/apps/presentation/apps_list_screen.dart`

**Step 1: Create new providers file**

Create `app/lib/features/apps/providers/apps_filter_providers.dart`:
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ranking/features/apps/domain/app_model.dart';
import 'package:ranking/features/apps/providers/apps_provider.dart';

/// Selected category filter for apps list
final selectedCategoryFilterProvider = StateProvider<String?>((ref) => null);

/// Available categories derived from current apps
final availableCategoriesProvider = Provider<List<String>>((ref) {
  final appsState = ref.watch(appsNotifierProvider);
  return appsState.maybeWhen(
    data: (apps) {
      final categories = apps
          .map((app) => app.categoryName)
          .whereType<String>()
          .toSet()
          .toList();
      categories.sort();
      return categories;
    },
    orElse: () => <String>[],
  );
});

/// Filtered apps based on selected category
final filteredAppsProvider = Provider<List<AppModel>>((ref) {
  final appsState = ref.watch(appsNotifierProvider);
  final selectedCategory = ref.watch(selectedCategoryFilterProvider);

  return appsState.maybeWhen(
    data: (apps) {
      if (selectedCategory == null) return apps;
      return apps.where((app) => app.categoryName == selectedCategory).toList();
    },
    orElse: () => <AppModel>[],
  );
});
```

**Step 2: Update apps_list_screen.dart imports**

Remove the inline provider definitions (lines 18-49) and add import:
```dart
import 'package:ranking/features/apps/providers/apps_filter_providers.dart';
```

**Step 3: Update provider references**

Replace:
- `_selectedCategoryFilterProvider` → `selectedCategoryFilterProvider`
- `_availableCategoriesProvider` → `availableCategoriesProvider`
- `_filteredAppsProvider` → `filteredAppsProvider`

**Step 4: Run Flutter analyze**

Run: `cd app && flutter analyze lib/features/apps/`
Expected: No errors

**Step 5: Commit**

```bash
git add app/lib/features/apps/providers/apps_filter_providers.dart
git add app/lib/features/apps/presentation/apps_list_screen.dart
git commit -m "refactor: extract inline providers from AppsListScreen to dedicated file"
```

---

### Task 16: Extract DiscoverScreen Providers

**Source:** Code Quality Plan Task 8
**Priority:** 🟠 High

**Files:**
- Create: `app/lib/features/keywords/providers/discover_providers.dart`
- Modify: `app/lib/features/keywords/presentation/discover_screen.dart`

**Step 1: Create new providers file**

Create `app/lib/features/keywords/providers/discover_providers.dart`:
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ranking/features/keywords/data/keywords_repository.dart';
import 'package:ranking/features/keywords/domain/keyword_model.dart';
import 'package:ranking/features/apps/providers/app_context_provider.dart';

/// Search query for keyword discovery
final discoverSearchQueryProvider = StateProvider<String>((ref) => '');

/// Selected tab index for discover screen
final discoverTabIndexProvider = StateProvider<int>((ref) => 0);

/// Selected category for suggestions
final discoverCategoryProvider = StateProvider<String?>((ref) => null);

/// Keyword search results
final discoverSearchResultsProvider = FutureProvider<KeywordSearchResponse?>((ref) async {
  final query = ref.watch(discoverSearchQueryProvider);
  if (query.length < 2) return null;

  // Debounce
  await Future.delayed(const Duration(milliseconds: 300));
  if (ref.read(discoverSearchQueryProvider) != query) return null;

  final repository = ref.watch(keywordsRepositoryProvider);
  final appContext = ref.watch(appContextProvider);
  if (appContext == null) return null;

  return repository.searchKeyword(
    query: query,
    country: appContext.country,
    platform: appContext.app.platform,
  );
});

/// Keyword suggestions for discovery
final discoverSuggestionsProvider = FutureProvider<List<KeywordSuggestion>>((ref) async {
  final appContext = ref.watch(appContextProvider);
  if (appContext == null) return [];

  final repository = ref.watch(keywordsRepositoryProvider);
  return repository.getKeywordSuggestions(
    appId: appContext.app.id,
    country: appContext.country,
  );
});

/// Filtered suggestions by category
final filteredSuggestionsProvider = Provider<List<KeywordSuggestion>>((ref) {
  final suggestionsAsync = ref.watch(discoverSuggestionsProvider);
  final selectedCategory = ref.watch(discoverCategoryProvider);

  return suggestionsAsync.maybeWhen(
    data: (suggestions) {
      if (selectedCategory == null) return suggestions;
      return suggestions.where((s) => s.category == selectedCategory).toList();
    },
    orElse: () => <KeywordSuggestion>[],
  );
});
```

**Step 2: Update discover_screen.dart**

Remove inline providers (lines 20-61) and add import:
```dart
import 'package:ranking/features/keywords/providers/discover_providers.dart';
```

**Step 3: Update provider references in the file**

Update all `_` prefixed provider references to use the new public providers.

**Step 4: Run Flutter analyze**

Run: `cd app && flutter analyze lib/features/keywords/`
Expected: No errors

**Step 5: Commit**

```bash
git add app/lib/features/keywords/providers/discover_providers.dart
git add app/lib/features/keywords/presentation/discover_screen.dart
git commit -m "refactor: extract inline providers from DiscoverScreen to dedicated file"
```

---

## Phase 8: Flutter Performance Fixes

### Task 17: Replace Image.network with SafeImage in Keywords Screen

**Source:** Performance Plan Task 1
**Priority:** 🟠 High

**Files:**
- Modify: `app/lib/features/keywords/presentation/keywords_screen.dart:796-804`

**Step 1: Read the current implementation**

Open `app/lib/features/keywords/presentation/keywords_screen.dart` and locate the `Image.network` usage around line 796-804.

**Step 2: Replace Image.network with SafeImage**

Find:
```dart
Image.network(
  data.app.iconUrl!,
  width: 20,
  height: 20,
  errorBuilder: (_, _, _) => Icon(Icons.apps, size: 20, color: colors.textMuted),
)
```

Replace with:
```dart
SafeImage(
  imageUrl: data.app.iconUrl!,
  width: 20,
  height: 20,
  placeholder: Icon(Icons.apps, size: 20, color: colors.textMuted),
)
```

**Step 3: Verify SafeImage import exists**

Ensure this import is at the top of the file:
```dart
import 'package:ranking/shared/widgets/safe_image.dart';
```

**Step 4: Run the app to verify**

Run: `cd app && flutter run --dart-define=API_BASE_URL=http://localhost:8000/api`
Expected: Keywords screen displays app icons without network errors on rebuild

**Step 5: Commit**

```bash
git add app/lib/features/keywords/presentation/keywords_screen.dart
git commit -m "perf: replace Image.network with cached SafeImage in keywords screen"
```

---

### Task 18: Parallelize Global Keywords Provider with Future.wait

**Source:** Performance Plan Task 2
**Priority:** 🟠 High

**Files:**
- Modify: `app/lib/features/keywords/providers/global_keywords_provider.dart:17-51`

**Step 1: Read the current implementation**

Open `app/lib/features/keywords/providers/global_keywords_provider.dart` and understand the sequential loop.

**Step 2: Replace sequential loop with Future.wait**

Find the sequential loop pattern:
```dart
for (final app in apps) {
  try {
    final keywords = await repository.getKeywordsForApp(app.id);
    for (final keyword in keywords) {
      allKeywords.add(KeywordWithApp(
        keyword: keyword,
        app: app,
      ));
    }
  } catch (e) {
    // Skip apps that fail to load
  }
}
```

Replace with parallel execution:
```dart
final results = await Future.wait(
  apps.map((app) async {
    try {
      final keywords = await repository.getKeywordsForApp(app.id);
      return keywords.map((keyword) => KeywordWithApp(
        keyword: keyword,
        app: app,
      )).toList();
    } catch (e) {
      return <KeywordWithApp>[];
    }
  }),
);

for (final keywordList in results) {
  allKeywords.addAll(keywordList);
}
```

**Step 3: Run the app and test keywords loading**

Run: `cd app && flutter run --dart-define=API_BASE_URL=http://localhost:8000/api`
Expected: Keywords screen loads significantly faster (parallel instead of sequential)

**Step 4: Commit**

```bash
git add app/lib/features/keywords/providers/global_keywords_provider.dart
git commit -m "perf: parallelize keywords fetching with Future.wait"
```

---

### Task 19: Add Debounce to Keyword Search Provider

**Source:** Performance Plan Task 3
**Priority:** 🟠 High

**Files:**
- Modify: `app/lib/features/keywords/providers/keywords_provider.dart:27-35`

**Step 1: Read the current search provider implementation**

Open `app/lib/features/keywords/providers/keywords_provider.dart` and locate `_keywordSearchResultsProvider`.

**Step 2: Create a debounced search provider**

Add a new debounced provider after `_keywordSearchQueryProvider`:

```dart
final _keywordSearchQueryProvider = StateProvider<String>((ref) => '');

// Add debounced version
final _debouncedSearchQueryProvider = Provider<String>((ref) {
  final query = ref.watch(_keywordSearchQueryProvider);
  return query;
});

final _keywordSearchResultsProvider = FutureProvider<KeywordSearchResponse?>((ref) async {
  final query = ref.watch(_debouncedSearchQueryProvider);
  if (query.length < 2) return null;

  // Add delay for debounce effect
  await Future.delayed(const Duration(milliseconds: 300));

  // Check if query changed during delay
  if (ref.read(_keywordSearchQueryProvider) != query) {
    return null;
  }

  final repository = ref.watch(keywordsRepositoryProvider);
  final appContext = ref.watch(appContextProvider);
  if (appContext == null) return null;

  return repository.searchKeyword(
    query: query,
    country: appContext.country,
    platform: appContext.app.platform,
  );
});
```

**Step 3: Test the search debouncing**

Run: `cd app && flutter run --dart-define=API_BASE_URL=http://localhost:8000/api`
Expected: Typing "hello" only triggers 1 API call instead of 5

**Step 4: Commit**

```bash
git add app/lib/features/keywords/providers/keywords_provider.dart
git commit -m "perf: add debounce to keyword search to reduce API calls"
```

---

### Task 20: Remove shrinkWrap from Insights GridView

**Source:** Performance Plan Task 4
**Priority:** 🟠 High

**Files:**
- Modify: `app/lib/features/insights/presentation/insights_screen.dart:92`

**Step 1: Read the current GridView implementation**

Open `app/lib/features/insights/presentation/insights_screen.dart` and locate the GridView with `shrinkWrap: true`.

**Step 2: Remove shrinkWrap and adjust physics**

Find:
```dart
GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  // ...
)
```

If inside a `SingleChildScrollView`, wrap with `SliverGrid` or use `CustomScrollView`. If standalone, remove shrinkWrap:
```dart
GridView.builder(
  // Remove: shrinkWrap: true,
  // Remove: physics: const NeverScrollableScrollPhysics(),
  // ...
)
```

**Step 3: Test the insights screen**

Run: `cd app && flutter run --dart-define=API_BASE_URL=http://localhost:8000/api`
Expected: Insights screen scrolls smoothly without layout jank

**Step 4: Commit**

```bash
git add app/lib/features/insights/presentation/insights_screen.dart
git commit -m "perf: remove shrinkWrap from insights GridView for virtualization"
```

---

### Task 21: Add .select() to Apps List Screen Providers

**Source:** Performance Plan Task 5
**Priority:** 🟠 High
**Dependency:** Task 15 (Extract providers) must be completed first

**Files:**
- Modify: `app/lib/features/apps/presentation/apps_list_screen.dart:57-60`

**Step 1: Read the current provider watches**

Open `app/lib/features/apps/presentation/apps_list_screen.dart` and locate the provider watches.

**Step 2: Add .select() for granular subscriptions**

Find:
```dart
final appsAsync = ref.watch(appsNotifierProvider);
final filteredApps = ref.watch(filteredAppsProvider);
final availableCategories = ref.watch(availableCategoriesProvider);
```

Replace with selective watches where appropriate:
```dart
final appsAsync = ref.watch(appsNotifierProvider);
final filteredApps = ref.watch(filteredAppsProvider.select((apps) => apps));
final availableCategories = ref.watch(availableCategoriesProvider.select((cats) => cats.toSet()));
```

For the main list, if only length is needed for certain widgets:
```dart
final appCount = ref.watch(filteredAppsProvider.select((apps) => apps.length));
```

**Step 3: Test the apps list screen**

Run: `cd app && flutter run --dart-define=API_BASE_URL=http://localhost:8000/api`
Expected: Apps list doesn't rebuild entirely when unrelated state changes

**Step 4: Commit**

```bash
git add app/lib/features/apps/presentation/apps_list_screen.dart
git commit -m "perf: add .select() to reduce unnecessary widget rebuilds"
```

---

### Task 22: Add .autoDispose to App Preview Provider

**Source:** Performance Plan Task 11
**Priority:** 🟠 High

**Files:**
- Modify: `app/lib/features/apps/providers/app_preview_provider.dart`

**Step 1: Read and modify the provider**

Find:
```dart
final appPreviewProvider = FutureProvider.family<AppPreview?, AppPreviewParams>((ref, params) async {
```

Replace with:
```dart
final appPreviewProvider = FutureProvider.autoDispose.family<AppPreview?, AppPreviewParams>((ref, params) async {
```

**Step 2: Test the app**

Run: `cd app && flutter run --dart-define=API_BASE_URL=http://localhost:8000/api`
Expected: App works normally, memory is freed when leaving preview screen

**Step 3: Commit**

```bash
git add app/lib/features/apps/providers/app_preview_provider.dart
git commit -m "perf: add autoDispose to app preview provider to free memory"
```

---

### Task 23: Configure SafeImage Cache Limits

**Source:** Performance Plan Task 12
**Priority:** 🟠 High

**Files:**
- Modify: `app/lib/shared/widgets/safe_image.dart:27-51`

**Step 1: Read current SafeImage implementation**

Open `app/lib/shared/widgets/safe_image.dart`.

**Step 2: Add cache manager with limits**

Add import at top:
```dart
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
```

Create a custom cache manager:
```dart
class AppIconCacheManager {
  static const key = 'appIconCache';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 200,
    ),
  );
}
```

Update `CachedNetworkImage` to use it:
```dart
Widget image = CachedNetworkImage(
  imageUrl: imageUrl,
  cacheManager: AppIconCacheManager.instance,
  width: width,
  height: height,
  fit: fit,
  // ... rest of params
);
```

**Step 3: Test the app**

Run: `cd app && flutter run --dart-define=API_BASE_URL=http://localhost:8000/api`
Expected: Images are cached and memory stays bounded

**Step 4: Commit**

```bash
git add app/lib/shared/widgets/safe_image.dart
git commit -m "perf: add cache size limits to SafeImage widget"
```

---

## Phase 9: Laravel Performance Fixes

### Task 24: Optimize ReviewIntelligenceController COUNT Queries

**Source:** Performance Plan Task 6
**Priority:** 🟠 High

**Files:**
- Modify: `api/app/Http/Controllers/Api/ReviewIntelligenceController.php:58-62`

**Step 1: Read the current implementation**

Open `api/app/Http/Controllers/Api/ReviewIntelligenceController.php` and locate the multiple COUNT queries.

**Step 2: Replace with single aggregated query**

Find:
```php
'total_feature_requests' => ReviewInsight::where('app_id', $app->id)->featureRequests()->count(),
'total_bug_reports' => ReviewInsight::where('app_id', $app->id)->bugReports()->count(),
'open_feature_requests' => ReviewInsight::where('app_id', $app->id)->featureRequests()->open()->count(),
'open_bug_reports' => ReviewInsight::where('app_id', $app->id)->bugReports()->open()->count(),
'high_priority_bugs' => ReviewInsight::where('app_id', $app->id)->bugReports()->highPriority()->open()->count(),
```

Replace with:
```php
$summary = ReviewInsight::where('app_id', $app->id)
    ->selectRaw("
        COUNT(CASE WHEN type = 'feature_request' THEN 1 END) as total_feature_requests,
        COUNT(CASE WHEN type = 'bug_report' THEN 1 END) as total_bug_reports,
        COUNT(CASE WHEN type = 'feature_request' AND status = 'open' THEN 1 END) as open_feature_requests,
        COUNT(CASE WHEN type = 'bug_report' AND status = 'open' THEN 1 END) as open_bug_reports,
        COUNT(CASE WHEN type = 'bug_report' AND priority = 'high' AND status = 'open' THEN 1 END) as high_priority_bugs
    ")
    ->first();

// Then use $summary->total_feature_requests, etc.
```

**Step 3: Run Laravel tests**

Run: `cd api && php artisan test --filter=ReviewIntelligence`
Expected: All tests pass

**Step 4: Commit**

```bash
git add api/app/Http/Controllers/Api/ReviewIntelligenceController.php
git commit -m "perf: combine 5 COUNT queries into single aggregate query"
```

---

### Task 25: Convert RankingsCollector to Batch Upsert

**Source:** Performance Plan Task 7
**Priority:** 🟠 High

**Files:**
- Modify: `api/app/Jobs/Collectors/RankingsCollector.php:80-86`

**Step 1: Read the current implementation**

Open `api/app/Jobs/Collectors/RankingsCollector.php` and locate the loop with `updateOrCreate`.

**Step 2: Replace with batch upsert**

Find:
```php
foreach ($items as $item) {
    AppRanking::updateOrCreate(
        [
            'app_id' => $item['app_id'],
            'keyword_id' => $item['keyword_id'],
            'recorded_at' => $item['recorded_at'],
        ],
        [
            'position' => $item['position'],
        ]
    );
    $this->updateKeywordMetrics($item, $position);
}
```

Replace with:
```php
$rows = [];
foreach ($items as $item) {
    $rows[] = [
        'app_id' => $item['app_id'],
        'keyword_id' => $item['keyword_id'],
        'recorded_at' => $item['recorded_at'],
        'position' => $item['position'],
        'created_at' => now(),
        'updated_at' => now(),
    ];
}

AppRanking::upsert(
    $rows,
    ['app_id', 'keyword_id', 'recorded_at'],
    ['position', 'updated_at']
);

// Update metrics after batch insert
foreach ($items as $item) {
    $this->updateKeywordMetrics($item, $item['position']);
}
```

**Step 3: Run Laravel tests**

Run: `cd api && php artisan test --filter=Rankings`
Expected: All tests pass

**Step 4: Commit**

```bash
git add api/app/Jobs/Collectors/RankingsCollector.php
git commit -m "perf: replace N updateOrCreate calls with batch upsert"
```

---

### Task 26: Optimize AnalyticsSyncService with Batch Lookup

**Source:** Performance Plan Task 9
**Priority:** 🟠 High

**Files:**
- Modify: `api/app/Services/AnalyticsSyncService.php:79-106`

**Step 1: Read the current implementation**

Open `api/app/Services/AnalyticsSyncService.php` and locate the loop with individual app lookups.

**Step 2: Replace with batch lookup**

Find:
```php
foreach ($mergedData as $data) {
    $app = App::where('store_id', $data['store_id'])
        ->where('platform', 'ios')
        ->first();

    if (!$app) continue;

    AppAnalytics::updateOrCreate([...], [...]);
}
```

Replace with:
```php
// Batch lookup all apps first
$storeIds = array_column($mergedData, 'store_id');
$appMap = App::where('platform', 'ios')
    ->whereIn('store_id', $storeIds)
    ->pluck('id', 'store_id')
    ->toArray();

// Prepare batch upsert data
$rows = [];
foreach ($mergedData as $data) {
    $appId = $appMap[$data['store_id']] ?? null;
    if (!$appId) continue;

    $rows[] = [
        'app_id' => $appId,
        'date' => $data['date'],
        'country_code' => $data['country_code'],
        'impressions' => $data['impressions'] ?? 0,
        'downloads' => $data['downloads'] ?? 0,
        'created_at' => now(),
        'updated_at' => now(),
    ];
}

// Single batch upsert
if (!empty($rows)) {
    AppAnalytics::upsert(
        $rows,
        ['app_id', 'date', 'country_code'],
        ['impressions', 'downloads', 'updated_at']
    );
}
```

**Step 3: Run Laravel tests**

Run: `cd api && php artisan test --filter=Analytics`
Expected: All tests pass

**Step 4: Commit**

```bash
git add api/app/Services/AnalyticsSyncService.php
git commit -m "perf: batch lookup apps and use upsert in analytics sync"
```

---

### Task 27: Add Cache to Dashboard Metrics

**Source:** Performance Plan Task 10
**Priority:** 🟠 High

**Files:**
- Modify: `api/app/Http/Controllers/Api/DashboardController.php:69-131`

**Step 1: Read the current metrics implementation**

Open `api/app/Http/Controllers/Api/DashboardController.php` and locate the `metrics` method.

**Step 2: Wrap with cache**

Add caching around the metrics computation:

```php
public function metrics(Request $request): JsonResponse
{
    $team = $this->currentTeam();
    $appIds = $team->apps()->pluck('id')->toArray();

    if (empty($appIds)) {
        return response()->json([
            'rating_stats' => null,
            'keyword_stats' => null,
            // ... empty defaults
        ]);
    }

    $cacheKey = "dashboard_metrics_{$team->id}_" . md5(json_encode($appIds));

    $data = Cache::remember($cacheKey, now()->addMinutes(15), function () use ($appIds) {
        // Existing metrics computation logic here
        $ratingStats = DB::table('apps')
            ->whereIn('id', $appIds)
            // ... rest of query

        return [
            'rating_stats' => $ratingStats,
            'keyword_stats' => $keywordStats,
            // ... other metrics
        ];
    });

    return response()->json($data);
}
```

**Step 3: Run Laravel tests**

Run: `cd api && php artisan test --filter=Dashboard`
Expected: All tests pass

**Step 4: Commit**

```bash
git add api/app/Http/Controllers/Api/DashboardController.php
git commit -m "perf: cache dashboard metrics for 15 minutes"
```

---

## Phase 10: Flutter Models - Freezed Conversion

### Task 28: Convert AppModel to Freezed

**Source:** Code Quality Plan Task 5
**Priority:** 🟡 Medium

**Files:**
- Create: `app/lib/features/apps/domain/app_model.freezed.dart` (auto-generated)
- Modify: `app/lib/features/apps/domain/app_model.dart`

**Step 1: Read the current AppModel**

Open `app/lib/features/apps/domain/app_model.dart` and understand the structure.

**Step 2: Create Freezed version of AppModel**

Replace the entire file content with:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_model.freezed.dart';
part 'app_model.g.dart';

@freezed
class AppModel with _$AppModel {
  const factory AppModel({
    required int id,
    @JsonKey(name: 'store_id') required String storeId,
    required String name,
    required String platform,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? developer,
    @JsonKey(name: 'developer_id') String? developerId,
    String? subtitle,
    String? description,
    double? rating,
    @JsonKey(name: 'rating_count') int? ratingCount,
    double? price,
    String? currency,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'category_name') String? categoryName,
    String? country,
    @JsonKey(name: 'size_bytes') int? sizeBytes,
    String? version,
    @JsonKey(name: 'release_date') DateTime? releaseDate,
    @JsonKey(name: 'updated_date') DateTime? updatedDate,
    @JsonKey(name: 'release_notes') String? releaseNotes,
    List<String>? screenshots,
    @JsonKey(name: 'is_favorite') @Default(false) bool isFavorite,
    @JsonKey(name: 'favorited_at') DateTime? favoritedAt,
    @JsonKey(name: 'best_rank') int? bestRank,
    @JsonKey(name: 'keywords_count') @Default(0) int keywordsCount,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _AppModel;

  factory AppModel.fromJson(Map<String, dynamic> json) => _$AppModelFromJson(json);
}

@freezed
class AppSearchResult with _$AppSearchResult {
  const factory AppSearchResult({
    @JsonKey(name: 'store_id') required String storeId,
    required String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? developer,
    @JsonKey(name: 'developer_id') String? developerId,
    double? rating,
    @JsonKey(name: 'rating_count') int? ratingCount,
    @JsonKey(name: 'category_name') String? categoryName,
    double? price,
    String? currency,
  }) = _AppSearchResult;

  factory AppSearchResult.fromJson(Map<String, dynamic> json) =>
      _$AppSearchResultFromJson(json);
}

@freezed
class AndroidSearchResult with _$AndroidSearchResult {
  const factory AndroidSearchResult({
    @JsonKey(name: 'store_id') required String storeId,
    required String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? developer,
    double? rating,
    @JsonKey(name: 'rating_count') int? ratingCount,
    @JsonKey(name: 'category_name') String? categoryName,
  }) = _AndroidSearchResult;

  factory AndroidSearchResult.fromJson(Map<String, dynamic> json) =>
      _$AndroidSearchResultFromJson(json);
}

@freezed
class AppPreview with _$AppPreview {
  const factory AppPreview({
    @JsonKey(name: 'store_id') required String storeId,
    required String name,
    required String platform,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? developer,
    @JsonKey(name: 'developer_id') String? developerId,
    String? subtitle,
    String? description,
    double? rating,
    @JsonKey(name: 'rating_count') int? ratingCount,
    double? price,
    String? currency,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'category_name') String? categoryName,
    String? country,
    @JsonKey(name: 'size_bytes') int? sizeBytes,
    String? version,
    @JsonKey(name: 'release_date') DateTime? releaseDate,
    @JsonKey(name: 'updated_date') DateTime? updatedDate,
    @JsonKey(name: 'release_notes') String? releaseNotes,
    List<String>? screenshots,
  }) = _AppPreview;

  factory AppPreview.fromJson(Map<String, dynamic> json) =>
      _$AppPreviewFromJson(json);
}
```

**Step 3: Run code generation**

Run: `cd app && dart run build_runner build --delete-conflicting-outputs`
Expected: Generated files created without errors

**Step 4: Run Flutter analyze**

Run: `cd app && flutter analyze lib/features/apps/`
Expected: No errors (may have warnings about unused code in other files)

**Step 5: Commit**

```bash
git add app/lib/features/apps/domain/app_model.dart
git add app/lib/features/apps/domain/app_model.freezed.dart
git add app/lib/features/apps/domain/app_model.g.dart
git commit -m "refactor: convert AppModel and related classes to Freezed"
```

---

### Task 29: Convert KeywordModel to Freezed

**Source:** Code Quality Plan Task 6
**Priority:** 🟡 Medium

**Files:**
- Modify: `app/lib/features/keywords/domain/keyword_model.dart`

**Step 1: Read the current KeywordModel**

Open `app/lib/features/keywords/domain/keyword_model.dart` and understand all classes.

**Step 2: Convert Keyword class to Freezed**

The file contains: `Keyword`, `KeywordSearchResponse`, `KeywordSuggestion`, `TopCompetitor`.

Replace with Freezed versions:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'keyword_model.freezed.dart';
part 'keyword_model.g.dart';

@freezed
class Keyword with _$Keyword {
  const Keyword._();

  const factory Keyword({
    required int id,
    @JsonKey(name: 'keyword_id') int? keywordId,
    @JsonKey(name: 'app_id') required int appId,
    required String keyword,
    int? popularity,
    int? position,
    @JsonKey(name: 'previous_position') int? previousPosition,
    int? change,
    @JsonKey(name: 'best_rank') int? bestRank,
    @JsonKey(name: 'is_favorite') @Default(false) bool isFavorite,
    String? note,
    @JsonKey(name: 'recorded_at') DateTime? recordedAt,
    @JsonKey(name: 'favorited_at') DateTime? favoritedAt,
    List<String>? tags,
  }) = _Keyword;

  factory Keyword.fromJson(Map<String, dynamic> json) => _$KeywordFromJson(json);

  // Computed properties
  bool get hasImproved => change != null && change! > 0;
  bool get hasDeclined => change != null && change! < 0;
  bool get isRanked => position != null && position! > 0;
  bool get isUnranked => position == null || position == 0;
}

@freezed
class KeywordSearchResponse with _$KeywordSearchResponse {
  const factory KeywordSearchResponse({
    required String keyword,
    int? popularity,
    @JsonKey(name: 'top_competitors') List<TopCompetitor>? topCompetitors,
  }) = _KeywordSearchResponse;

  factory KeywordSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$KeywordSearchResponseFromJson(json);
}

@freezed
class KeywordSuggestion with _$KeywordSuggestion {
  const KeywordSuggestion._();

  const factory KeywordSuggestion({
    required String keyword,
    int? popularity,
    String? category,
    @JsonKey(name: 'top_competitors') List<TopCompetitor>? topCompetitors,
  }) = _KeywordSuggestion;

  factory KeywordSuggestion.fromJson(Map<String, dynamic> json) =>
      _$KeywordSuggestionFromJson(json);

  String get categoryIcon {
    return switch (category) {
      'trending' => '🔥',
      'low_competition' => '👀',
      'from_description' => '📝',
      'rising' => '📈',
      'related' => '🔗',
      _ => '💡',
    };
  }
}

@freezed
class TopCompetitor with _$TopCompetitor {
  const factory TopCompetitor({
    required String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    required int position,
  }) = _TopCompetitor;

  factory TopCompetitor.fromJson(Map<String, dynamic> json) =>
      _$TopCompetitorFromJson(json);
}
```

**Step 3: Run code generation**

Run: `cd app && dart run build_runner build --delete-conflicting-outputs`
Expected: Generated files created without errors

**Step 4: Run Flutter analyze**

Run: `cd app && flutter analyze lib/features/keywords/`
Expected: No errors

**Step 5: Commit**

```bash
git add app/lib/features/keywords/domain/keyword_model.dart
git add app/lib/features/keywords/domain/keyword_model.freezed.dart
git add app/lib/features/keywords/domain/keyword_model.g.dart
git commit -m "refactor: convert KeywordModel and related classes to Freezed"
```

---

## Phase 11: Localization

### Task 30: Localize Dashboard Hardcoded Strings

**Source:** Code Quality Plan Task 9
**Priority:** 🟡 Medium

**Files:**
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/l10n/app_fr.arb`
- Modify: `app/lib/features/dashboard/presentation/dashboard_screen.dart`

**Step 1: Add strings to app_en.arb**

Add to `app/lib/l10n/app_en.arb`:
```json
"connectYourStores": "Connect Your Stores",
"connectStoresDescription": "Link App Store Connect or Google Play to import your apps and reply to reviews.",
"connectButton": "Connect",
"appsWithInsights": "{count} apps with insights",
"@appsWithInsights": {
  "placeholders": {
    "count": {"type": "int"}
  }
}
```

**Step 2: Add strings to app_fr.arb**

Add to `app/lib/l10n/app_fr.arb`:
```json
"connectYourStores": "Connectez vos stores",
"connectStoresDescription": "Liez App Store Connect ou Google Play pour importer vos apps et répondre aux avis.",
"connectButton": "Connecter",
"appsWithInsights": "{count} apps avec insights",
"@appsWithInsights": {
  "placeholders": {
    "count": {"type": "int"}
  }
}
```

**Step 3: Run code generation for l10n**

Run: `cd app && flutter gen-l10n`
Expected: Generated localization files updated

**Step 4: Update dashboard_screen.dart**

Replace hardcoded strings:

Line 648: `'Connect Your Stores'` → `context.l10n.connectYourStores`
Line 657: `'Link App Store Connect...'` → `context.l10n.connectStoresDescription`
Line 671: `'Connect'` → `context.l10n.connectButton`

**Step 5: Run Flutter analyze**

Run: `cd app && flutter analyze lib/features/dashboard/`
Expected: No errors

**Step 6: Commit**

```bash
git add app/lib/l10n/app_en.arb
git add app/lib/l10n/app_fr.arb
git add app/lib/features/dashboard/presentation/dashboard_screen.dart
git commit -m "fix: localize hardcoded strings in dashboard screen"
```

---

### Task 31: Localize Insights Screen Strings

**Source:** Code Quality Plan Task 10
**Priority:** 🟡 Medium

**Files:**
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/l10n/app_fr.arb`
- Modify: `app/lib/features/insights/presentation/insights_screen.dart`

**Step 1: Add strings to app_en.arb**

Add to `app/lib/l10n/app_en.arb`:
```json
"insightsTitle": "Insights - {appName}",
"@insightsTitle": {
  "placeholders": {
    "appName": {"type": "String"}
  }
},
"insightsAllApps": "Insights (All Apps)",
"noInsightsGenerated": "No insights generated yet",
"selectAppForInsights": "Select an app to generate insights from reviews"
```

**Step 2: Add strings to app_fr.arb**

Add to `app/lib/l10n/app_fr.arb`:
```json
"insightsTitle": "Insights - {appName}",
"@insightsTitle": {
  "placeholders": {
    "appName": {"type": "String"}
  }
},
"insightsAllApps": "Insights (Toutes les apps)",
"noInsightsGenerated": "Aucun insight généré",
"selectAppForInsights": "Sélectionnez une app pour générer des insights à partir des avis"
```

**Step 3: Run code generation for l10n**

Run: `cd app && flutter gen-l10n`
Expected: Generated localization files updated

**Step 4: Update insights_screen.dart**

Replace hardcoded strings:

Line 25: `'Insights - ${selectedApp.name}'` → `context.l10n.insightsTitle(selectedApp.name)`
Line 46: `'Insights (All Apps)'` → `context.l10n.insightsAllApps`
Line 58: `'No insights generated yet'` → `context.l10n.noInsightsGenerated`
Line 63: `'Select an app to generate insights from reviews'` → `context.l10n.selectAppForInsights`

**Step 5: Run Flutter analyze**

Run: `cd app && flutter analyze lib/features/insights/`
Expected: No errors

**Step 6: Commit**

```bash
git add app/lib/l10n/app_en.arb
git add app/lib/l10n/app_fr.arb
git add app/lib/features/insights/presentation/insights_screen.dart
git commit -m "fix: localize hardcoded strings in insights screen"
```

---

## Phase 12: Code Standards

### Task 32: Replace Print Statements with Logger

**Source:** Code Quality Plan Task 11
**Priority:** 🟡 Medium

**Files:**
- Modify: `app/lib/core/services/fcm_service.dart`

**Step 1: Read the current implementation**

Open `app/lib/core/services/fcm_service.dart` and locate all print statements.

**Step 2: Add logger import**

Add at top of file:
```dart
import 'dart:developer' as developer;
```

**Step 3: Replace print statements**

Line 50: `print('FCM initialization skipped: $e');`
→ `developer.log('FCM initialization skipped: $e', name: 'FCM');`

Line 60: `print('Failed to send FCM token: $e');`
→ `developer.log('Failed to send FCM token: $e', name: 'FCM', level: 900);`

Line 67: `print('Foreground message: ${message.notification?.title}');`
→ `developer.log('Foreground message: ${message.notification?.title}', name: 'FCM');`

Line 73: `print('Message tapped: ${message.data}');`
→ `developer.log('Message tapped: ${message.data}', name: 'FCM');`

Line 82: `print('Failed to clear FCM token: $e');`
→ `developer.log('Failed to clear FCM token: $e', name: 'FCM', level: 900);`

**Step 4: Run Flutter analyze**

Run: `cd app && flutter analyze lib/core/services/`
Expected: No linter warnings about print statements

**Step 5: Commit**

```bash
git add app/lib/core/services/fcm_service.dart
git commit -m "fix: replace print statements with developer.log in FCM service"
```

---

### Task 33: Create Response Trait for Consistent Formatting

**Source:** Code Quality Plan Task 12
**Priority:** 🟡 Medium

**Files:**
- Create: `api/app/Http/Traits/ApiResponse.php`

**Step 1: Create the trait**

Create `api/app/Http/Traits/ApiResponse.php`:
```php
<?php

namespace App\Http\Traits;

use Illuminate\Http\JsonResponse;

trait ApiResponse
{
    /**
     * Success response with data
     */
    protected function successResponse(mixed $data, string $message = null, int $code = 200): JsonResponse
    {
        $response = ['data' => $data];
        if ($message) {
            $response['message'] = $message;
        }
        return response()->json($response, $code);
    }

    /**
     * Created response (201)
     */
    protected function createdResponse(mixed $data, string $message = null): JsonResponse
    {
        return $this->successResponse($data, $message, 201);
    }

    /**
     * Error response
     */
    protected function errorResponse(string $message, int $code = 400): JsonResponse
    {
        return response()->json(['error' => $message], $code);
    }

    /**
     * Not found response
     */
    protected function notFoundResponse(string $resource = 'Resource'): JsonResponse
    {
        return $this->errorResponse("{$resource} not found", 404);
    }

    /**
     * Forbidden response
     */
    protected function forbiddenResponse(string $message = 'Forbidden'): JsonResponse
    {
        return $this->errorResponse($message, 403);
    }

    /**
     * No content response (204)
     */
    protected function noContentResponse(): JsonResponse
    {
        return response()->json(null, 204);
    }
}
```

**Step 2: Commit**

```bash
git add api/app/Http/Traits/ApiResponse.php
git commit -m "feat: add ApiResponse trait for consistent response formatting"
```

---

## Phase 13: Security - XSS & Model Protection

### Task 34: Sanitize Email Template Data

**Source:** Security Plan Task 10
**Priority:** 🟡 Medium

**Files:**
- Modify: `api/resources/views/emails/weekly-digest.blade.php`
- Modify: `api/resources/views/emails/alert-notification.blade.php`
- Modify: `api/resources/views/emails/alert-digest.blade.php`

**Step 1: Update weekly-digest.blade.php**

Replace user data output with `e()` helper. Key lines to update:

Line ~211:
```blade
<span class="insight-title">{{ e($insight['title']) }}</span>
```

Line ~213:
```blade
<div class="insight-description">{{ e($insight['description']) }}</div>
```

Line ~229:
```blade
<img src="{{ e($app['icon_url']) }}" alt="{{ e($app['name']) }}" class="app-icon">
```

Line ~234:
```blade
<div class="app-name">{{ e($app['name']) }}</div>
```

**Step 2: Update alert-notification.blade.php**

The `{{ }}` syntax already escapes, but ensure markdown content is sanitized:

```blade
# {{ e($notification->title) }}

{{ e($notification->body) }}
```

**Step 3: Update alert-digest.blade.php**

Same pattern - wrap user data with `e()`:

```blade
{{ e($notification->body) }}
- **App:** {{ e($data['app_name']) }}
- **Keyword:** {{ e($data['keyword']) }}
```

**Step 4: Test email rendering**

```bash
cd api && php artisan tinker
>>> Mail::raw('Test', fn($m) => $m->to('test@example.com'));
```

**Step 5: Commit**

```bash
git add api/resources/views/emails/
git commit -m "security: sanitize user data in email templates to prevent XSS"
```

---

### Task 35: Update User Model Hidden Fields

**Source:** Security Plan Task 11
**Priority:** 🟡 Medium

**Files:**
- Modify: `api/app/Models/User.php`

**Step 1: Update $hidden array**

Edit `api/app/Models/User.php`, lines ~49-52:

```php
protected $hidden = [
    'password',
    'remember_token',
    'api_key_hash',
    'api_key_created_at',
    'fcm_token',
    'two_factor_secret',
    'two_factor_recovery_codes',
];
```

**Step 2: Write test to verify fields are hidden**

Add to `api/tests/Feature/AuthControllerTest.php`:

```php
public function test_user_response_hides_sensitive_fields(): void
{
    $user = \App\Models\User::factory()->create([
        'api_key_hash' => 'test_hash',
        'fcm_token' => 'test_fcm_token',
    ]);

    $this->actingAs($user);

    $response = $this->getJson('/api/auth/me');

    $response->assertStatus(200);
    $response->assertJsonMissing(['api_key_hash', 'fcm_token', 'password']);
}
```

**Step 3: Run test**

```bash
cd api && php artisan test --filter=test_user_response_hides_sensitive_fields
```

Expected: PASS

**Step 4: Commit**

```bash
git add api/app/Models/User.php api/tests/Feature/AuthControllerTest.php
git commit -m "security: hide sensitive fields in User model JSON responses"
```

---

## Phase 14: Flutter Security

### Task 36: Implement App Lifecycle Handler

**Source:** Security Plan Task 12
**Priority:** 🟡 Medium

**Files:**
- Modify: `app/lib/main.dart`

**Step 1: Add WidgetsBindingObserver mixin**

Edit `app/lib/main.dart`, update `_MyAppState`:

```dart
class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  bool _hasLoadedPreferences = false;
  bool _hasFcmInitialized = false;
  DateTime? _backgroundedAt;
  static const _sessionTimeoutMinutes = 15;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _backgroundedAt = DateTime.now();
        break;
      case AppLifecycleState.resumed:
        _checkSessionTimeout();
        break;
      default:
        break;
    }
  }

  void _checkSessionTimeout() {
    if (_backgroundedAt != null) {
      final elapsed = DateTime.now().difference(_backgroundedAt!);
      if (elapsed.inMinutes >= _sessionTimeoutMinutes) {
        // Session expired - require re-authentication
        ref.read(authStateProvider.notifier).logout();
      }
      _backgroundedAt = null;
    }
  }

  // ... rest of existing code
}
```

**Step 2: Test by backgrounding app for 15+ minutes**

Manual test: Background app, wait 15 minutes, resume - should redirect to login.

**Step 3: Commit**

```bash
cd app && git add lib/main.dart
git commit -m "security: implement session timeout on app background"
```

---

### Task 37: Fix Email Validation Regex

**Source:** Security Plan Task 13
**Priority:** 🟡 Medium

**Files:**
- Modify: `app/lib/features/auth/presentation/login_screen.dart`
- Modify: `app/lib/features/auth/presentation/register_screen.dart`

**Step 1: Create email validator helper**

Create `app/lib/core/utils/validators.dart`:

```dart
class Validators {
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static String? validateEmail(String? value, {required String errorMessage}) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    if (!_emailRegex.hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }

  static String? validatePassword(String? value, {
    required String requiredMessage,
    required String lengthMessage,
  }) {
    if (value == null || value.isEmpty) {
      return requiredMessage;
    }
    if (value.length < 10) {
      return lengthMessage;
    }
    return null;
  }
}
```

**Step 2: Update login_screen.dart**

Edit `app/lib/features/auth/presentation/login_screen.dart`, replace email validator:

```dart
import '../../../core/utils/validators.dart';

// In the TextFormField for email:
validator: (value) => Validators.validateEmail(
  value,
  errorMessage: l10n.auth_emailInvalid,
),
```

**Step 3: Update register_screen.dart**

Same pattern for register screen.

**Step 4: Commit**

```bash
cd app && git add lib/core/utils/validators.dart lib/features/auth/presentation/
git commit -m "security: implement proper email validation with regex"
```

---

## Phase 15: Documentation & Final

### Task 38: Create Production Environment Template

**Source:** Security Plan Task 14
**Priority:** 🟢 Low

**Files:**
- Create: `api/.env.production.example`

**Step 1: Create production environment template**

Create `api/.env.production.example`:

```env
APP_NAME=Keyrank
APP_ENV=production
APP_KEY=base64:GENERATE_WITH_php_artisan_key:generate
APP_DEBUG=false
APP_URL=https://api.keyrank.com

LOG_CHANNEL=stack
LOG_LEVEL=error

DB_CONNECTION=mysql
DB_HOST=your-production-db-host
DB_PORT=3306
DB_DATABASE=keyrank_production
DB_USERNAME=keyrank_user
DB_PASSWORD=SECURE_PASSWORD_HERE

SESSION_DRIVER=database
SESSION_ENCRYPT=true
SESSION_SECURE_COOKIE=true
SESSION_SAME_SITE=strict

SANCTUM_TOKEN_EXPIRATION=60
CORS_ALLOWED_ORIGINS=https://app.keyrank.com

# Use secrets manager for these in production:
# - APPLE_SEARCH_ADS_*
# - OPENROUTER_API_KEY
# - STRIPE_*
# - MAIL_*
```

**Step 2: Add to .gitignore (already there, verify)**

```bash
grep "\.env\.production" api/.gitignore
```

**Step 3: Commit**

```bash
git add api/.env.production.example
git commit -m "docs: add production environment template with secure defaults"
```

---

### Task 39: Final Verification

**Priority:** 🟢 Low

**Step 1: Run code generation**

Run: `cd app && dart run build_runner build --delete-conflicting-outputs`
Expected: All generated files created

**Step 2: Run Flutter tests**

Run: `cd app && flutter test`
Expected: All tests pass

**Step 3: Run Flutter analyze**

Run: `cd app && flutter analyze`
Expected: No errors

**Step 4: Run Laravel tests**

Run: `cd api && php artisan test`
Expected: All tests pass

**Step 5: Verify no secrets in tracked files**

```bash
git grep -i "sk_test\|pk_test\|sk-or-v1\|BEGIN.*PRIVATE\|password.*=" -- "*.php" "*.dart" "*.json" "*.plist"
```

Expected: No matches (or only in .example files)

**Step 6: Final commit**

```bash
git add -A
git commit -m "chore: complete unified implementation (security + performance + code quality)"
```

---

## Summary

| Phase | Tasks | Domain | Priority |
|-------|-------|--------|----------|
| Phase 1 | 1-3 | Security - Git/Secrets | 🔴 Critical |
| Phase 2 | 4 | Database Migration | 🔴 Critical |
| Phase 3 | 5-8 | Bug Fixes | 🔴 Critical |
| Phase 4 | 9-11 | Security - CORS/Tokens | 🔴 Critical |
| Phase 5 | 12-13 | Security - Auth | 🟠 High |
| Phase 6 | 14 | Security Headers | 🟠 High |
| Phase 7 | 15-16 | Flutter Code Org | 🟠 High |
| Phase 8 | 17-23 | Flutter Performance | 🟠 High |
| Phase 9 | 24-27 | Laravel Performance | 🟠 High |
| Phase 10 | 28-29 | Freezed Models | 🟡 Medium |
| Phase 11 | 30-31 | Localization | 🟡 Medium |
| Phase 12 | 32-33 | Code Standards | 🟡 Medium |
| Phase 13 | 34-35 | Security - XSS/Model | 🟡 Medium |
| Phase 14 | 36-37 | Flutter Security | 🟡 Medium |
| Phase 15 | 38-39 | Documentation/Final | 🟢 Low |

**Total tasks:** 39
- 🔴 Critical: 11 tasks
- 🟠 High: 14 tasks
- 🟡 Medium: 12 tasks
- 🟢 Low: 2 tasks

**Key Dependencies:**
1. Task 4 (migration) → before Task 5 (ExportController)
2. Task 15 (extract providers) → before Task 21 (.select())
3. Task 1-3 (git cleanup) → first of all
