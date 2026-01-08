# Code Audit Refactoring Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Clean up orphaned directories, eliminate code duplication, and standardize architecture across the Keyrank project.

**Architecture:** The project uses Clean Architecture in Flutter (features with data/domain/presentation/providers layers) and MVC+Services in Laravel. This refactoring extracts duplicated widgets to `shared/widgets/`, utilities to `core/utils/`, and introduces Laravel middleware/traits for repeated patterns.

**Tech Stack:** Flutter/Dart (Riverpod), Laravel/PHP, SQLite

---

## Phase 1: Structure Cleanup

### Task 1: Remove Orphaned Directories

**Files:**
- Delete: `api/api/` (duplicate Laravel)
- Delete: `app/api/` (orphaned Laravel in Flutter)
- Delete: `lib/` (root level orphaned Flutter)
- Delete: `app/app/` (incorrect nesting)
- Delete: `api/app/lib/` (Flutter in Laravel)

**Step 1: Verify orphaned directories exist**

Run:
```bash
ls -la api/api/ 2>/dev/null && echo "EXISTS" || echo "NOT FOUND"
ls -la app/api/ 2>/dev/null && echo "EXISTS" || echo "NOT FOUND"
ls -la lib/ 2>/dev/null && echo "EXISTS" || echo "NOT FOUND"
ls -la app/app/ 2>/dev/null && echo "EXISTS" || echo "NOT FOUND"
ls -la api/app/lib/ 2>/dev/null && echo "EXISTS" || echo "NOT FOUND"
```

**Step 2: Remove orphaned directories**

Run:
```bash
rm -rf api/api/
rm -rf app/api/
rm -rf lib/
rm -rf app/app/
rm -rf api/app/lib/
```

**Step 3: Verify removal**

Run:
```bash
ls -la api/ | head -20
ls -la app/ | head -20
```

Expected: No more `api/api/`, `app/api/`, `app/app/`, `api/app/lib/`

**Step 4: Commit cleanup**

```bash
git add -A
git commit -m "chore: remove orphaned duplicate directories

- Remove api/api/ (duplicate Laravel installation)
- Remove app/api/ (orphaned Laravel in Flutter)
- Remove lib/ at root (incomplete Flutter)
- Remove app/app/ (incorrect nesting)
- Remove api/app/lib/ (Flutter code in Laravel)"
```

---

### Task 2: Remove CLAUDE.md Marker Files

**Files:**
- Delete: All 169-byte `CLAUDE.md` files throughout project

**Step 1: Find all CLAUDE.md marker files**

Run:
```bash
find . -name "CLAUDE.md" -size 169c -type f 2>/dev/null | head -30
```

**Step 2: Count and verify they are empty markers**

Run:
```bash
find . -name "CLAUDE.md" -size 169c -type f 2>/dev/null | wc -l
cat $(find . -name "CLAUDE.md" -size 169c -type f 2>/dev/null | head -1)
```

Expected: ~20+ files, content should be minimal marker text

**Step 3: Remove all marker files**

Run:
```bash
find . -name "CLAUDE.md" -size 169c -type f -delete
```

**Step 4: Commit**

```bash
git add -A
git commit -m "chore: remove empty CLAUDE.md marker files"
```

---

## Phase 2: Flutter Shared Widgets Extraction

### Task 3: Create Shared Buttons Widget

**Files:**
- Create: `app/lib/shared/widgets/buttons.dart`
- Modify: `app/lib/features/dashboard/presentation/dashboard_screen.dart`
- Modify: `app/lib/features/apps/presentation/apps_list_screen.dart`
- Modify: `app/lib/features/apps/presentation/app_detail_screen.dart`

**Step 1: Create buttons.dart with ToolbarButton**

Create `app/lib/shared/widgets/buttons.dart`:
```dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Toolbar button with icon and label, used in screen toolbars
class ToolbarButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  const ToolbarButton({
    super.key,
    this.icon,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.glassBorder),
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (icon != null)
                Icon(icon, size: 16, color: AppColors.textSecondary),
              if (icon != null || isLoading) const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Primary action button with accent color
class PrimaryButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    this.icon,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else if (icon != null)
                Icon(icon, size: 16, color: Colors.white),
              if (icon != null || isLoading) const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small button with border, used for inline actions
class SmallButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? borderColor;

  const SmallButton({
    super.key,
    required this.label,
    required this.onTap,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor ?? AppColors.glassBorder),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor ?? AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
```

**Step 2: Update dashboard_screen.dart imports and usage**

Add import at top of `app/lib/features/dashboard/presentation/dashboard_screen.dart`:
```dart
import '../../../shared/widgets/buttons.dart';
```

Replace `_ToolbarButton` usage with `ToolbarButton`, `_PrimaryButton` with `PrimaryButton`, `_SmallButton` with `SmallButton`.

Delete the private `_ToolbarButton`, `_PrimaryButton`, `_SmallButton` class definitions (lines ~87-176 and ~492-524).

**Step 3: Update apps_list_screen.dart**

Add import at top of `app/lib/features/apps/presentation/apps_list_screen.dart`:
```dart
import '../../../shared/widgets/buttons.dart';
```

Replace usages and delete private class definitions (lines ~89-176 and ~320-352).

**Step 4: Update app_detail_screen.dart**

Add import at top of `app/lib/features/apps/presentation/app_detail_screen.dart`:
```dart
import '../../../shared/widgets/buttons.dart';
```

Replace usages and delete private `_ToolbarButton` class definition (lines ~306-356).

**Step 5: Verify Flutter app builds**

Run:
```bash
cd app && flutter analyze && flutter build macos --debug 2>&1 | tail -20
```

Expected: No errors

**Step 6: Commit**

```bash
git add -A
git commit -m "refactor(flutter): extract shared button widgets

- Create shared/widgets/buttons.dart with ToolbarButton, PrimaryButton, SmallButton
- Remove duplicate button definitions from dashboard, apps_list, app_detail screens
- Reduces ~170 lines of duplicated code"
```

---

### Task 4: Create Shared State Widgets (Error, Empty, Loading)

**Files:**
- Create: `app/lib/shared/widgets/states.dart`
- Modify: `app/lib/features/dashboard/presentation/dashboard_screen.dart`
- Modify: `app/lib/features/apps/presentation/apps_list_screen.dart`
- Modify: `app/lib/features/keywords/presentation/keyword_search_screen.dart`
- Modify: `app/lib/features/ratings/presentation/app_ratings_screen.dart`

**Step 1: Create states.dart**

Create `app/lib/shared/widgets/states.dart`:
```dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'buttons.dart';

/// Loading indicator widget
class LoadingView extends StatelessWidget {
  final String? message;

  const LoadingView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(strokeWidth: 2),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error view with retry button
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.red.withAlpha(30),
                  AppColors.red.withAlpha(10),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 40, color: AppColors.red),
          ),
          const SizedBox(height: 24),
          Text(
            'Une erreur est survenue',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            PrimaryButton(
              icon: Icons.refresh,
              label: 'Réessayer',
              onTap: onRetry!,
            ),
          ],
        ],
      ),
    );
  }
}

/// Empty state view with icon, title, subtitle and optional action
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.accent;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withAlpha(30),
                  color.withAlpha(10),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 40, color: color),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 24),
            PrimaryButton(
              label: actionLabel!,
              onTap: onAction!,
            ),
          ],
        ],
      ),
    );
  }
}
```

**Step 2: Update all screens to use shared state widgets**

Add to each screen:
```dart
import '../../../shared/widgets/states.dart';
```

Replace `_ErrorView` with `ErrorView`, `_EmptyState`/`_EmptyAppsState` with `EmptyStateView`.

Delete the private class definitions from each screen.

**Step 3: Verify Flutter app builds**

Run:
```bash
cd app && flutter analyze
```

Expected: No errors

**Step 4: Commit**

```bash
git add -A
git commit -m "refactor(flutter): extract shared state widgets

- Create shared/widgets/states.dart with LoadingView, ErrorView, EmptyStateView
- Remove duplicate state widgets from 4 screens
- Reduces ~200 lines of duplicated code"
```

---

### Task 5: Create Shared Barrel Export

**Files:**
- Create: `app/lib/shared/widgets/widgets.dart`

**Step 1: Create barrel export file**

Create `app/lib/shared/widgets/widgets.dart`:
```dart
export 'buttons.dart';
export 'states.dart';
```

**Step 2: Update imports in screens to use barrel**

Replace individual imports:
```dart
// Before
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/states.dart';

// After
import '../../../shared/widgets/widgets.dart';
```

**Step 3: Commit**

```bash
git add -A
git commit -m "refactor(flutter): add shared widgets barrel export"
```

---

## Phase 3: Flutter Utilities Extraction

### Task 6: Create Formatters Utility

**Files:**
- Create: `app/lib/core/utils/formatters.dart`
- Modify: `app/lib/features/ratings/presentation/app_ratings_screen.dart`
- Modify: `app/lib/features/reviews/presentation/country_reviews_screen.dart`

**Step 1: Create formatters.dart**

Create `app/lib/core/utils/formatters.dart`:
```dart
import 'package:intl/intl.dart';

/// Format large numbers with K/M suffixes
String formatCount(num? count) {
  if (count == null) return '-';
  if (count >= 1000000) {
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }
  if (count >= 1000) {
    return '${(count / 1000).toStringAsFixed(1)}K';
  }
  return count.toString();
}

/// Format date as "Jan 8, 2026"
String formatDate(DateTime date) {
  return DateFormat('MMM d, y').format(date);
}

/// Format date as "08/01/2026"
String formatDateShort(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

/// Safely parse a double from dynamic value
double? safeParseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

/// Safely parse an int from dynamic value
int? safeParseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
```

**Step 2: Update app_ratings_screen.dart**

Add import:
```dart
import '../../../core/utils/formatters.dart';
```

Delete `_formatCount()` and `_formatDate()` private methods, use imported functions.

**Step 3: Update country_reviews_screen.dart**

Add same import and remove duplicate methods.

**Step 4: Verify and commit**

Run:
```bash
cd app && flutter analyze
git add -A
git commit -m "refactor(flutter): extract formatters utility

- Create core/utils/formatters.dart with formatCount, formatDate, safeParseDouble
- Remove duplicate formatting methods from ratings and reviews screens"
```

---

### Task 7: Create Color Helpers Utility

**Files:**
- Create: `app/lib/core/utils/color_helpers.dart`
- Modify: `app/lib/features/ratings/presentation/app_ratings_screen.dart`

**Step 1: Create color_helpers.dart**

Create `app/lib/core/utils/color_helpers.dart`:
```dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Get color based on rating value (0-5 scale)
Color getRatingColor(double? rating) {
  if (rating == null) return AppColors.textMuted;
  if (rating >= 4.5) return AppColors.green;
  if (rating >= 4.0) return AppColors.yellow;
  if (rating >= 3.0) return AppColors.orange;
  return AppColors.red;
}

/// Get color based on ranking position
Color getRankingColor(int? position) {
  if (position == null) return AppColors.textMuted;
  if (position <= 10) return AppColors.green;
  if (position <= 50) return AppColors.yellow;
  if (position <= 100) return AppColors.orange;
  return AppColors.red;
}

/// Get color for position change (positive = good, negative = bad)
Color getChangeColor(int change) {
  if (change > 0) return AppColors.green;
  if (change < 0) return AppColors.red;
  return AppColors.textMuted;
}
```

**Step 2: Update screens to use color helpers**

Add import and remove `_getRatingColor()` private methods.

**Step 3: Verify and commit**

Run:
```bash
cd app && flutter analyze
git add -A
git commit -m "refactor(flutter): extract color helpers utility

- Create core/utils/color_helpers.dart with getRatingColor, getRankingColor, getChangeColor
- Remove duplicate color logic from ratings screen"
```

---

### Task 8: Create Utils Barrel Export

**Files:**
- Create: `app/lib/core/utils/utils.dart`

**Step 1: Create barrel export**

Create `app/lib/core/utils/utils.dart`:
```dart
export 'formatters.dart';
export 'color_helpers.dart';
```

**Step 2: Commit**

```bash
git add -A
git commit -m "refactor(flutter): add core utils barrel export"
```

---

## Phase 4: Laravel Refactoring

### Task 9: Create Authorization Middleware

**Files:**
- Create: `api/app/Http/Middleware/EnsureUserOwnsApp.php`
- Modify: `api/app/Http/Kernel.php` (or `bootstrap/app.php` for Laravel 11+)
- Modify: `api/routes/api.php`

**Step 1: Create middleware**

Create `api/app/Http/Middleware/EnsureUserOwnsApp.php`:
```php
<?php

namespace App\Http\Middleware;

use App\Models\App;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureUserOwnsApp
{
    public function handle(Request $request, Closure $next): Response
    {
        $appId = $request->route('app') ?? $request->route('id');

        if ($appId) {
            $app = App::find($appId);

            if (!$app) {
                return response()->json(['message' => 'App not found'], 404);
            }

            if ($app->user_id !== $request->user()->id) {
                return response()->json(['message' => 'Unauthorized'], 403);
            }

            // Make app available to controller
            $request->merge(['validated_app' => $app]);
        }

        return $next($request);
    }
}
```

**Step 2: Register middleware alias**

Add to `api/bootstrap/app.php` (Laravel 11+):
```php
->withMiddleware(function (Middleware $middleware) {
    $middleware->alias([
        'owns.app' => \App\Http\Middleware\EnsureUserOwnsApp::class,
    ]);
})
```

**Step 3: Update routes to use middleware**

In `api/routes/api.php`, group routes that need ownership check:
```php
Route::middleware(['auth:sanctum', 'owns.app'])->group(function () {
    Route::get('/apps/{app}', [AppController::class, 'show']);
    Route::put('/apps/{app}', [AppController::class, 'update']);
    Route::delete('/apps/{app}', [AppController::class, 'destroy']);
    // etc.
});
```

**Step 4: Remove duplicate ownership checks from controllers**

In each controller, remove:
```php
if ($app->user_id !== $request->user()->id) {
    return response()->json(['message' => 'Unauthorized'], 403);
}
```

Replace `App::findOrFail($id)` with `$request->validated_app`.

**Step 5: Verify API works**

Run:
```bash
cd api && php artisan route:list | grep apps
```

**Step 6: Commit**

```bash
git add -A
git commit -m "refactor(api): extract app ownership to middleware

- Create EnsureUserOwnsApp middleware
- Remove 15+ duplicate ownership checks from controllers
- Routes now use 'owns.app' middleware for authorization"
```

---

### Task 10: Create Shared Validation Rules

**Files:**
- Create: `api/app/Rules/CountryCode.php`
- Create: `api/app/Rules/Platform.php`
- Modify: Controllers to use new rules

**Step 1: Create CountryCode rule**

Create `api/app/Rules/CountryCode.php`:
```php
<?php

namespace App\Rules;

use Closure;
use Illuminate\Contracts\Validation\ValidationRule;

class CountryCode implements ValidationRule
{
    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        if (!is_string($value) || strlen($value) !== 2) {
            $fail('The :attribute must be a valid 2-letter country code.');
        }
    }
}
```

**Step 2: Create Platform rule**

Create `api/app/Rules/Platform.php`:
```php
<?php

namespace App\Rules;

use Closure;
use Illuminate\Contracts\Validation\ValidationRule;

class Platform implements ValidationRule
{
    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        if (!in_array($value, ['ios', 'android'])) {
            $fail('The :attribute must be either ios or android.');
        }
    }
}
```

**Step 3: Update controllers to use rules**

Replace:
```php
'country' => 'nullable|string|size:2'
'platform' => 'nullable|string|in:ios,android'
```

With:
```php
use App\Rules\CountryCode;
use App\Rules\Platform;

'country' => ['nullable', new CountryCode],
'platform' => ['nullable', new Platform],
```

**Step 4: Commit**

```bash
git add -A
git commit -m "refactor(api): extract shared validation rules

- Create CountryCode and Platform validation rules
- Replace repeated validation strings with reusable rules"
```

---

### Task 11: Extract Priority Countries to Config

**Files:**
- Modify: `api/config/app.php`
- Modify: `api/app/Http/Controllers/Api/RatingsController.php`

**Step 1: Add to config/app.php**

Add at end of `api/config/app.php`:
```php
/*
|--------------------------------------------------------------------------
| ASO Configuration
|--------------------------------------------------------------------------
*/
'priority_countries' => ['us', 'gb', 'fr', 'de', 'jp', 'cn', 'kr', 'au', 'br', 'mx'],
```

**Step 2: Update RatingsController**

Replace hardcoded arrays:
```php
// Before
$priorityCountries = ['us', 'gb', 'fr', 'de', 'jp', 'cn', 'kr', 'au', 'br', 'mx'];

// After
$priorityCountries = config('app.priority_countries');
```

**Step 3: Commit**

```bash
git add -A
git commit -m "refactor(api): move priority countries to config

- Add priority_countries to config/app.php
- Remove duplicate hardcoded arrays from RatingsController"
```

---

## Phase 5: Complete Architecture

### Task 12: Add Missing Providers to Ratings Feature

**Files:**
- Create: `app/lib/features/ratings/providers/ratings_provider.dart`
- Modify: `app/lib/features/ratings/presentation/app_ratings_screen.dart`

**Step 1: Create ratings_provider.dart**

Create `app/lib/features/ratings/providers/ratings_provider.dart`:
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/ratings_repository.dart';
import '../domain/rating_model.dart';

final ratingsRepositoryProvider = Provider<RatingsRepository>((ref) {
  return RatingsRepository(ref);
});

final appRatingsProvider = FutureProvider.family<List<AppRating>, ({int appId, String? platform})>((ref, params) async {
  final repository = ref.watch(ratingsRepositoryProvider);
  return repository.getAppRatings(appId: params.appId, platform: params.platform);
});

final ratingsHistoryProvider = FutureProvider.family<List<RatingHistory>, ({int appId, String country, String? platform})>((ref, params) async {
  final repository = ref.watch(ratingsRepositoryProvider);
  return repository.getRatingsOverTime(
    appId: params.appId,
    country: params.country,
    platform: params.platform,
  );
});
```

**Step 2: Update screen to use providers**

Update `app_ratings_screen.dart` to use the new providers instead of inline FutureProviders.

**Step 3: Commit**

```bash
git add -A
git commit -m "refactor(flutter): add providers layer to ratings feature

- Create ratings_provider.dart with appRatingsProvider, ratingsHistoryProvider
- Align ratings feature with Clean Architecture pattern"
```

---

### Task 13: Add Missing Providers to Reviews Feature

**Files:**
- Create: `app/lib/features/reviews/providers/reviews_provider.dart`
- Modify: `app/lib/features/reviews/presentation/country_reviews_screen.dart`

**Step 1: Create reviews_provider.dart**

Create `app/lib/features/reviews/providers/reviews_provider.dart`:
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/reviews_repository.dart';
import '../domain/review_model.dart';

final reviewsRepositoryProvider = Provider<ReviewsRepository>((ref) {
  return ReviewsRepository(ref);
});

final countryReviewsProvider = FutureProvider.family<List<AppReview>, ({int appId, String country, String? platform})>((ref, params) async {
  final repository = ref.watch(reviewsRepositoryProvider);
  return repository.getCountryReviews(
    appId: params.appId,
    country: params.country,
    platform: params.platform,
  );
});
```

**Step 2: Update screen to use providers**

**Step 3: Commit**

```bash
git add -A
git commit -m "refactor(flutter): add providers layer to reviews feature

- Create reviews_provider.dart with countryReviewsProvider
- Align reviews feature with Clean Architecture pattern"
```

---

## Phase 6: Final Verification

### Task 14: Full Project Verification

**Step 1: Verify Flutter builds**

Run:
```bash
cd app && flutter clean && flutter pub get && flutter analyze && flutter build macos --debug
```

Expected: Build succeeds

**Step 2: Verify Laravel works**

Run:
```bash
cd api && php artisan config:clear && php artisan route:list | head -20
```

Expected: Routes listed without errors

**Step 3: Run any existing tests**

Run:
```bash
cd api && php artisan test 2>&1 | tail -20
cd ../app && flutter test 2>&1 | tail -20
```

**Step 4: Final commit**

```bash
git add -A
git commit -m "chore: complete code audit refactoring

Summary:
- Removed 5 orphaned directories (~300MB)
- Extracted 3 shared Flutter widgets (buttons, states)
- Extracted 2 Flutter utilities (formatters, color_helpers)
- Created Laravel ownership middleware
- Added shared validation rules
- Completed architecture for ratings/reviews features

Code reduction: ~950 lines of duplicated code eliminated"
```

---

## Summary

| Phase | Tasks | Lines Saved | Impact |
|-------|-------|-------------|--------|
| 1. Structure Cleanup | 2 | - | ~300MB disk |
| 2. Shared Widgets | 3 | ~370 | DRY UI |
| 3. Utilities | 3 | ~80 | DRY logic |
| 4. Laravel | 3 | ~200 | DRY backend |
| 5. Architecture | 2 | - | Consistency |
| 6. Verification | 1 | - | Quality |
| **Total** | **14** | **~650 lines** | **Maintainability** |
