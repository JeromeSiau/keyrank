# Simplify App Platform Schema

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Refactor the database schema so each app has ONE platform, eliminating redundant fields and simplifying all code.

**Architecture:** Currently apps can theoretically have both `apple_id` AND `google_play_id` with duplicated fields (`rating`/`google_rating`, etc.). Child tables (`app_ratings`, `app_reviews`, `app_rankings`) redundantly store `platform`. The new design: each app record = one platform, with `platform` enum and single `store_id` field. Child tables inherit platform from parent app.

**Tech Stack:** Laravel 11 (PHP), Flutter/Dart, SQLite

---

## Current State (Problems)

**apps table:**
- `apple_id` + `google_play_id` (should be single `store_id`)
- `rating` + `google_rating` (should be single `rating`)
- `icon_url` + `google_icon_url` (should be single `icon_url`)
- `ratings_fetched_at` + `google_ratings_fetched_at` (should be single)
- No `platform` field - must be inferred

**Child tables (app_ratings, app_reviews, app_rankings):**
- All store `platform` redundantly (should inherit from app)

---

## Task 1: Create Database Migration

**Files:**
- Create: `api/database/migrations/2026_01_08_170000_simplify_apps_platform_schema.php`

**Step 1: Write the migration**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // Step 1: Add new columns to apps
        Schema::table('apps', function (Blueprint $table) {
            $table->enum('platform', ['ios', 'android'])->default('ios')->after('user_id');
            $table->string('store_id')->nullable()->after('platform');
        });

        // Step 2: Migrate existing data
        // iOS apps: platform=ios, store_id=apple_id
        DB::table('apps')
            ->whereNotNull('apple_id')
            ->update([
                'platform' => 'ios',
                'store_id' => DB::raw('apple_id'),
            ]);

        // Android apps: platform=android, store_id=google_play_id, merge google_ fields
        DB::table('apps')
            ->whereNull('apple_id')
            ->whereNotNull('google_play_id')
            ->update([
                'platform' => 'android',
                'store_id' => DB::raw('google_play_id'),
                'icon_url' => DB::raw('google_icon_url'),
                'rating' => DB::raw('google_rating'),
                'rating_count' => DB::raw('google_rating_count'),
                'ratings_fetched_at' => DB::raw('google_ratings_fetched_at'),
                'reviews_fetched_at' => DB::raw('google_reviews_fetched_at'),
            ]);

        // Step 3: Drop old columns from apps
        Schema::table('apps', function (Blueprint $table) {
            $table->dropColumn([
                'apple_id',
                'google_play_id',
                'google_icon_url',
                'google_rating',
                'google_rating_count',
                'google_ratings_fetched_at',
                'google_reviews_fetched_at',
            ]);
        });

        // Step 4: Make store_id required and add unique constraint
        Schema::table('apps', function (Blueprint $table) {
            $table->string('store_id')->nullable(false)->change();
            $table->unique(['user_id', 'platform', 'store_id']);
        });

        // Step 5: Drop platform column from child tables
        Schema::table('app_ratings', function (Blueprint $table) {
            $table->dropIndex('app_ratings_app_id_platform_country_recorded_at_unique');
            $table->dropColumn('platform');
            $table->unique(['app_id', 'country', 'recorded_at']);
        });

        Schema::table('app_reviews', function (Blueprint $table) {
            $table->dropIndex('app_reviews_app_id_platform_country_index');
            $table->dropColumn('platform');
        });

        Schema::table('app_rankings', function (Blueprint $table) {
            $table->dropIndex('app_rankings_app_id_platform_keyword_id_recorded_at_unique');
            $table->dropColumn('platform');
            $table->unique(['app_id', 'keyword_id', 'recorded_at']);
        });
    }

    public function down(): void
    {
        // This migration is not easily reversible
        throw new \Exception('This migration cannot be reversed. Restore from backup.');
    }
};
```

**Step 2: Backup database before running**

```bash
cp api/database/database.sqlite api/database/database.sqlite.backup
```

**Step 3: Run migration**

```bash
cd api && php artisan migrate
```

**Step 4: Verify migration**

```bash
cd api && sqlite3 database/database.sqlite ".schema apps"
```

Expected: `platform`, `store_id` columns present; no `apple_id`, `google_play_id`, `google_*` columns

**Step 5: Commit**

```bash
git add api/database/migrations/
git commit -m "feat: simplify apps table schema - one platform per app"
```

---

## Task 2: Update Laravel App Model

**Files:**
- Modify: `api/app/Models/App.php`

**Step 1: Update fillable and casts**

Replace the entire model with:

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class App extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'platform',
        'store_id',
        'bundle_id',
        'name',
        'icon_url',
        'developer',
        'rating',
        'rating_count',
        'storefront',
        'ratings_fetched_at',
        'reviews_fetched_at',
    ];

    protected $casts = [
        'rating' => 'decimal:1',
        'rating_count' => 'integer',
        'ratings_fetched_at' => 'datetime',
        'reviews_fetched_at' => 'datetime',
    ];

    public function isIos(): bool
    {
        return $this->platform === 'ios';
    }

    public function isAndroid(): bool
    {
        return $this->platform === 'android';
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function keywords(): BelongsToMany
    {
        return $this->belongsToMany(Keyword::class, 'tracked_keywords')
            ->withPivot('created_at');
    }

    public function trackedKeywords(): HasMany
    {
        return $this->hasMany(TrackedKeyword::class);
    }

    public function rankings(): HasMany
    {
        return $this->hasMany(AppRanking::class);
    }

    public function latestRankings(): HasMany
    {
        return $this->hasMany(AppRanking::class)
            ->whereDate('recorded_at', today());
    }

    public function ratings(): HasMany
    {
        return $this->hasMany(AppRating::class);
    }

    public function latestRatings(): HasMany
    {
        return $this->hasMany(AppRating::class)
            ->whereIn('id', function ($query) {
                $query->selectRaw('MAX(id)')
                    ->from('app_ratings')
                    ->where('app_id', $this->id)
                    ->groupBy('country');
            });
    }

    public function reviews(): HasMany
    {
        return $this->hasMany(AppReview::class);
    }
}
```

**Step 2: Verify syntax**

```bash
php -l api/app/Models/App.php
```

**Step 3: Commit**

```bash
git add api/app/Models/App.php
git commit -m "refactor: simplify App model - single platform per app"
```

---

## Task 3: Update AppRating Model

**Files:**
- Modify: `api/app/Models/AppRating.php`

**Step 1: Remove platform from fillable**

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppRating extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'app_id',
        'country',
        'rating',
        'rating_count',
        'recorded_at',
    ];

    protected $casts = [
        'rating' => 'float',
        'rating_count' => 'integer',
        'recorded_at' => 'datetime',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }
}
```

**Step 2: Commit**

```bash
git add api/app/Models/AppRating.php
git commit -m "refactor: remove platform from AppRating model"
```

---

## Task 4: Update AppReview Model

**Files:**
- Modify: `api/app/Models/AppReview.php`

**Step 1: Remove platform from fillable**

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppReview extends Model
{
    protected $fillable = [
        'app_id',
        'country',
        'review_id',
        'author',
        'title',
        'content',
        'rating',
        'version',
        'reviewed_at',
    ];

    protected $casts = [
        'rating' => 'integer',
        'reviewed_at' => 'datetime',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }
}
```

**Step 2: Commit**

```bash
git add api/app/Models/AppReview.php
git commit -m "refactor: remove platform from AppReview model"
```

---

## Task 5: Update AppRanking Model

**Files:**
- Modify: `api/app/Models/AppRanking.php`

**Step 1: Check current model and remove platform**

```bash
cat api/app/Models/AppRanking.php
```

Then update to remove `platform` from fillable.

**Step 2: Commit**

```bash
git add api/app/Models/AppRanking.php
git commit -m "refactor: remove platform from AppRanking model"
```

---

## Task 6: Update AppController

**Files:**
- Modify: `api/app/Http/Controllers/Api/AppController.php`

**Step 1: Read current implementation**

```bash
cat api/app/Http/Controllers/Api/AppController.php
```

**Step 2: Update store() method**

The `store()` method should:
- Accept `platform` (required: ios|android) and `store_id` (required)
- Fetch app details from appropriate service based on platform
- Store with unified fields

Key changes:
- Replace `apple_id`/`google_play_id` checks with `platform` check
- Use `store_id` instead of platform-specific IDs
- Remove `google_*` field handling

**Step 3: Update index() and show() methods**

- Return `platform` and `store_id` instead of `apple_id`/`google_play_id`

**Step 4: Commit**

```bash
git add api/app/Http/Controllers/Api/AppController.php
git commit -m "refactor: update AppController for simplified schema"
```

---

## Task 7: Update RatingsController

**Files:**
- Modify: `api/app/Http/Controllers/Api/RatingsController.php`

**Step 1: Simplify - platform comes from app**

Key changes:
- Remove platform parameter from requests (get from `$app->platform`)
- Remove platform-specific timestamp fields (just use `ratings_fetched_at`)
- Simplify `fetchRatingsIfStale()` to check `$app->platform`
- Remove `platform` from AppRating::create calls
- Remove `->where('platform', ...)` from queries

**Step 2: Commit**

```bash
git add api/app/Http/Controllers/Api/RatingsController.php
git commit -m "refactor: simplify RatingsController - platform from app"
```

---

## Task 8: Update ReviewsController

**Files:**
- Modify: `api/app/Http/Controllers/Api/ReviewsController.php`

**Step 1: Simplify - platform comes from app**

Same pattern as RatingsController:
- Remove platform parameter
- Use `$app->platform` directly
- Remove `platform` from AppReview::updateOrCreate calls
- Remove `->where('platform', ...)` from queries

**Step 2: Commit**

```bash
git add api/app/Http/Controllers/Api/ReviewsController.php
git commit -m "refactor: simplify ReviewsController - platform from app"
```

---

## Task 9: Update KeywordController

**Files:**
- Modify: `api/app/Http/Controllers/Api/KeywordController.php`

**Step 1: Simplify ranking operations**

- Use `$app->platform` instead of checking apple_id/google_play_id
- Use `$app->store_id` for store lookups
- Remove `platform` from AppRanking::updateOrCreate calls

**Step 2: Commit**

```bash
git add api/app/Http/Controllers/Api/KeywordController.php
git commit -m "refactor: simplify KeywordController - platform from app"
```

---

## Task 10: Update RankingController

**Files:**
- Modify: `api/app/Http/Controllers/Api/RankingController.php`

**Step 1: Read and simplify**

```bash
cat api/app/Http/Controllers/Api/RankingController.php
```

Remove platform handling, use `$app->platform`.

**Step 2: Commit**

```bash
git add api/app/Http/Controllers/Api/RankingController.php
git commit -m "refactor: simplify RankingController - platform from app"
```

---

## Task 11: Update SyncRankings Command

**Files:**
- Modify: `api/app/Console/Commands/SyncRankings.php`

**Step 1: Simplify platform handling**

- Use `$app->platform` and `$app->store_id`
- Remove dual-platform logic

**Step 2: Commit**

```bash
git add api/app/Console/Commands/SyncRankings.php
git commit -m "refactor: simplify SyncRankings - platform from app"
```

---

## Task 12: Update Flutter AppModel

**Files:**
- Modify: `app/lib/features/apps/domain/app_model.dart`

**Step 1: Simplify model**

```dart
class AppModel {
  final int id;
  final int userId;
  final String platform; // 'ios' or 'android'
  final String storeId;
  final String? bundleId;
  final String name;
  final String? iconUrl;
  final String? developer;
  final double? rating;
  final int ratingCount;
  final String? storefront;
  final int? trackedKeywordsCount;
  final DateTime createdAt;

  AppModel({
    required this.id,
    required this.userId,
    required this.platform,
    required this.storeId,
    this.bundleId,
    required this.name,
    this.iconUrl,
    this.developer,
    this.rating,
    required this.ratingCount,
    this.storefront,
    this.trackedKeywordsCount,
    required this.createdAt,
  });

  bool get isIos => platform == 'ios';
  bool get isAndroid => platform == 'android';

  factory AppModel.fromJson(Map<String, dynamic> json) {
    return AppModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      platform: json['platform'] as String,
      storeId: json['store_id'] as String,
      bundleId: json['bundle_id'] as String?,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      developer: json['developer'] as String?,
      rating: _parseDouble(json['rating']),
      ratingCount: _parseInt(json['rating_count']) ?? 0,
      storefront: json['storefront'] as String?,
      trackedKeywordsCount: _parseInt(json['tracked_keywords_count']),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
```

**Step 2: Remove display* getters**

No longer needed - just use `iconUrl`, `rating`, `ratingCount` directly.

**Step 3: Commit**

```bash
git add app/lib/features/apps/domain/app_model.dart
git commit -m "refactor: simplify Flutter AppModel - single platform"
```

---

## Task 13: Update Flutter Screens

**Files:**
- Modify: `app/lib/features/apps/presentation/app_detail_screen.dart`
- Modify: `app/lib/features/apps/presentation/apps_list_screen.dart`
- Modify: `app/lib/features/dashboard/presentation/dashboard_screen.dart`

**Step 1: Update app_detail_screen.dart**

- Replace `app.hasIos`/`app.hasAndroid` with `app.isIos`/`app.isAndroid`
- Replace `app.displayIconUrl` with `app.iconUrl`
- Replace `app.displayRating` with `app.rating`
- Replace `app.displayRatingCount` with `app.ratingCount`
- Update platform badges to show single badge based on `app.platform`

**Step 2: Update apps_list_screen.dart**

- Same replacements as above

**Step 3: Update dashboard_screen.dart**

- Same replacements as above

**Step 4: Run Flutter analyze**

```bash
cd app && flutter analyze
```

**Step 5: Commit**

```bash
git add app/lib/features/
git commit -m "refactor: update Flutter screens for simplified app model"
```

---

## Task 14: Update Add App Screen

**Files:**
- Modify: `app/lib/features/apps/presentation/add_app_screen.dart`

**Step 1: Update to send platform + store_id**

When adding an app, send:
```json
{
  "platform": "ios",  // or "android"
  "store_id": "1234567890"
}
```

**Step 2: Commit**

```bash
git add app/lib/features/apps/presentation/add_app_screen.dart
git commit -m "refactor: update add app screen for new schema"
```

---

## Task 15: Update Apps Repository

**Files:**
- Modify: `app/lib/features/apps/data/apps_repository.dart`

**Step 1: Update API calls**

- Update `addApp()` to send `platform` and `store_id`
- Remove any `apple_id`/`google_play_id` references

**Step 2: Commit**

```bash
git add app/lib/features/apps/data/apps_repository.dart
git commit -m "refactor: update apps repository for new schema"
```

---

## Task 16: Final Testing

**Step 1: Run Laravel tests**

```bash
cd api && php artisan test
```

**Step 2: Run Flutter tests**

```bash
cd app && flutter test
```

**Step 3: Manual testing**

1. View dashboard - apps should display correctly
2. View app detail - ratings, reviews should work
3. Add new iOS app
4. Add new Android app
5. Track keywords on both platforms
6. View ratings per country

**Step 4: Final commit**

```bash
git add .
git commit -m "feat: complete platform schema simplification"
```

---

## Summary of Changes

**Removed from apps table:**
- `apple_id`, `google_play_id` → replaced with `platform` + `store_id`
- `google_icon_url` → merged into `icon_url`
- `google_rating`, `google_rating_count` → merged into `rating`, `rating_count`
- `google_ratings_fetched_at`, `google_reviews_fetched_at` → merged into single timestamps

**Removed from child tables:**
- `platform` column from `app_ratings`, `app_reviews`, `app_rankings`

**Code simplified:**
- No more `display*` getters in Flutter
- No more platform parameter in API endpoints
- No more conditional logic for iOS vs Android fields
- Platform determined by single `$app->platform` field
