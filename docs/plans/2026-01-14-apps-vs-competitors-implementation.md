# Apps vs Competitors Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Implement differentiation between user-owned apps and competitor apps with contextual linking, feature restrictions, and enriched UI.

**Architecture:** Add `is_competitor` to `user_apps` pivot for global competitors. Create `app_competitors` junction table for per-app contextual competitors. Update Flutter models and providers to support both types. Enrich CompetitorsScreen with list view, filters, and actions.

**Tech Stack:** Laravel 11 (migrations, Eloquent models, API controllers), Flutter/Riverpod (models, providers, UI screens)

---

## Phase 1: Backend Data Model

### Task 1: Add is_competitor to user_apps

**Files:**
- Create: `api/database/migrations/2026_01_14_100000_add_is_competitor_to_user_apps.php`

**Step 1: Create migration file**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('user_apps', function (Blueprint $table) {
            $table->boolean('is_competitor')->default(false)->after('is_owner');
        });
    }

    public function down(): void
    {
        Schema::table('user_apps', function (Blueprint $table) {
            $table->dropColumn('is_competitor');
        });
    }
};
```

**Step 2: Run migration**

```bash
cd api && php artisan migrate
```

Expected: Migration successful, `is_competitor` column added.

**Step 3: Commit**

```bash
git add api/database/migrations/2026_01_14_100000_add_is_competitor_to_user_apps.php
git commit -m "feat(api): add is_competitor flag to user_apps pivot"
```

---

### Task 2: Create app_competitors table

**Files:**
- Create: `api/database/migrations/2026_01_14_100001_create_app_competitors_table.php`

**Step 1: Create migration file**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('app_competitors', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('owner_app_id')->constrained('apps')->onDelete('cascade');
            $table->foreignId('competitor_app_id')->constrained('apps')->onDelete('cascade');
            $table->enum('source', ['manual', 'auto_discovered', 'keyword_overlap'])->default('manual');
            $table->timestamp('created_at')->useCurrent();

            $table->unique(['user_id', 'owner_app_id', 'competitor_app_id'], 'unique_competitor');
            $table->index(['user_id', 'owner_app_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('app_competitors');
    }
};
```

**Step 2: Run migration**

```bash
cd api && php artisan migrate
```

Expected: Migration successful, `app_competitors` table created.

**Step 3: Commit**

```bash
git add api/database/migrations/2026_01_14_100001_create_app_competitors_table.php
git commit -m "feat(api): create app_competitors table for contextual linking"
```

---

### Task 3: Create AppCompetitor model

**Files:**
- Create: `api/app/Models/AppCompetitor.php`

**Step 1: Create model file**

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppCompetitor extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'user_id',
        'owner_app_id',
        'competitor_app_id',
        'source',
    ];

    protected $casts = [
        'created_at' => 'datetime',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function ownerApp(): BelongsTo
    {
        return $this->belongsTo(App::class, 'owner_app_id');
    }

    public function competitorApp(): BelongsTo
    {
        return $this->belongsTo(App::class, 'competitor_app_id');
    }
}
```

**Step 2: Commit**

```bash
git add api/app/Models/AppCompetitor.php
git commit -m "feat(api): add AppCompetitor model"
```

---

### Task 4: Update App model with competitor scopes and relations

**Files:**
- Modify: `api/app/Models/App.php`

**Step 1: Add relations and scopes**

Add after `discoveredApps()` relation (around line 173):

```php
public function competitorLinks(): HasMany
{
    return $this->hasMany(AppCompetitor::class, 'owner_app_id');
}

public function competitorOf(): HasMany
{
    return $this->hasMany(AppCompetitor::class, 'competitor_app_id');
}

public function scopeOwnedBy($query, int $userId)
{
    return $query->whereHas('users', function ($q) use ($userId) {
        $q->where('users.id', $userId)
          ->where('user_apps.is_owner', true);
    });
}

public function scopeCompetitorsFor($query, int $userId)
{
    return $query->whereHas('users', function ($q) use ($userId) {
        $q->where('users.id', $userId)
          ->where('user_apps.is_competitor', true);
    });
}
```

Also add the import at the top if not present:
```php
use Illuminate\Database\Eloquent\Relations\HasMany;
```

**Step 2: Update users() relation to include is_competitor pivot**

Update the `users()` method (around line 66) to include `is_owner` and `is_competitor`:

```php
public function users(): BelongsToMany
{
    return $this->belongsToMany(User::class, 'user_apps')
        ->withPivot('is_owner', 'is_competitor', 'is_favorite', 'favorited_at', 'created_at');
}
```

**Step 3: Commit**

```bash
git add api/app/Models/App.php
git commit -m "feat(api): add competitor scopes and relations to App model"
```

---

## Phase 2: Backend API

### Task 5: Create CompetitorController

**Files:**
- Create: `api/app/Http/Controllers/Api/CompetitorController.php`

**Step 1: Create controller**

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppCompetitor;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CompetitorController extends Controller
{
    /**
     * List all competitors (global + contextual) for the authenticated user.
     */
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();
        $ownerAppId = $request->query('app_id');

        // Global competitors
        $globalCompetitors = App::competitorsFor($user->id)
            ->with(['latestRankings', 'latestRatings'])
            ->get()
            ->map(fn($app) => $this->formatCompetitor($app, 'global'));

        // Contextual competitors (if app_id provided)
        $contextualCompetitors = collect();
        if ($ownerAppId) {
            $contextualCompetitors = AppCompetitor::where('user_id', $user->id)
                ->where('owner_app_id', $ownerAppId)
                ->with(['competitorApp.latestRankings', 'competitorApp.latestRatings'])
                ->get()
                ->map(fn($link) => $this->formatCompetitor($link->competitorApp, 'contextual', $link));
        }

        // Merge and deduplicate (contextual takes precedence)
        $contextualIds = $contextualCompetitors->pluck('id')->toArray();
        $merged = $contextualCompetitors->merge(
            $globalCompetitors->filter(fn($c) => !in_array($c['id'], $contextualIds))
        );

        return response()->json([
            'competitors' => $merged->values(),
        ]);
    }

    /**
     * Add a global competitor.
     */
    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'app_id' => 'required|exists:apps,id',
        ]);

        $user = $request->user();
        $appId = $request->input('app_id');

        // Check if already tracked
        $existing = $user->apps()->where('apps.id', $appId)->first();
        if ($existing) {
            // Update to mark as competitor if not already
            $user->apps()->updateExistingPivot($appId, ['is_competitor' => true]);
        } else {
            // Attach as competitor
            $user->apps()->attach($appId, ['is_competitor' => true]);
        }

        $app = App::with(['latestRankings', 'latestRatings'])->find($appId);

        return response()->json([
            'competitor' => $this->formatCompetitor($app, 'global'),
        ], 201);
    }

    /**
     * Remove a global competitor.
     */
    public function destroy(Request $request, int $appId): JsonResponse
    {
        $user = $request->user();

        // Remove competitor flag (keep app if is_owner)
        $pivot = $user->apps()->where('apps.id', $appId)->first();
        if ($pivot) {
            if ($pivot->pivot->is_owner) {
                // Just remove competitor flag
                $user->apps()->updateExistingPivot($appId, ['is_competitor' => false]);
            } else {
                // Remove completely
                $user->apps()->detach($appId);
            }
        }

        // Also remove any contextual links
        AppCompetitor::where('user_id', $user->id)
            ->where('competitor_app_id', $appId)
            ->delete();

        return response()->json(['success' => true]);
    }

    /**
     * Link a competitor to a specific app (contextual).
     */
    public function linkToApp(Request $request, int $ownerAppId): JsonResponse
    {
        $request->validate([
            'competitor_app_id' => 'required|exists:apps,id',
            'source' => 'sometimes|in:manual,auto_discovered,keyword_overlap',
        ]);

        $user = $request->user();
        $competitorAppId = $request->input('competitor_app_id');

        // Verify user owns the owner app
        $ownerApp = App::ownedBy($user->id)->find($ownerAppId);
        if (!$ownerApp) {
            return response()->json(['error' => 'App not found or not owned'], 404);
        }

        // Create or update link
        $link = AppCompetitor::updateOrCreate(
            [
                'user_id' => $user->id,
                'owner_app_id' => $ownerAppId,
                'competitor_app_id' => $competitorAppId,
            ],
            [
                'source' => $request->input('source', 'manual'),
            ]
        );

        // Ensure competitor app is tracked
        $existing = $user->apps()->where('apps.id', $competitorAppId)->first();
        if (!$existing) {
            $user->apps()->attach($competitorAppId, ['is_competitor' => true]);
        }

        $competitorApp = App::with(['latestRankings', 'latestRatings'])->find($competitorAppId);

        return response()->json([
            'competitor' => $this->formatCompetitor($competitorApp, 'contextual', $link),
        ], 201);
    }

    /**
     * Unlink a competitor from a specific app.
     */
    public function unlinkFromApp(Request $request, int $ownerAppId, int $competitorAppId): JsonResponse
    {
        $user = $request->user();

        AppCompetitor::where('user_id', $user->id)
            ->where('owner_app_id', $ownerAppId)
            ->where('competitor_app_id', $competitorAppId)
            ->delete();

        return response()->json(['success' => true]);
    }

    /**
     * Get competitors for a specific app.
     */
    public function forApp(Request $request, int $appId): JsonResponse
    {
        $user = $request->user();

        // Contextual competitors for this app
        $contextual = AppCompetitor::where('user_id', $user->id)
            ->where('owner_app_id', $appId)
            ->with(['competitorApp.latestRankings', 'competitorApp.latestRatings'])
            ->get()
            ->map(fn($link) => $this->formatCompetitor($link->competitorApp, 'contextual', $link));

        // Global competitors
        $global = App::competitorsFor($user->id)
            ->with(['latestRankings', 'latestRatings'])
            ->get()
            ->map(fn($app) => $this->formatCompetitor($app, 'global'));

        // Merge (contextual first, then global excluding duplicates)
        $contextualIds = $contextual->pluck('id')->toArray();
        $merged = $contextual->merge(
            $global->filter(fn($c) => !in_array($c['id'], $contextualIds))
        );

        return response()->json([
            'competitors' => $merged->values(),
        ]);
    }

    private function formatCompetitor(App $app, string $type, ?AppCompetitor $link = null): array
    {
        return [
            'id' => $app->id,
            'platform' => $app->platform,
            'store_id' => $app->store_id,
            'name' => $app->name,
            'icon_url' => $app->icon_url,
            'developer' => $app->developer,
            'rating' => $app->rating,
            'rating_count' => $app->rating_count,
            'competitor_type' => $type,
            'source' => $link?->source,
            'linked_at' => $link?->created_at?->toIso8601String(),
        ];
    }
}
```

**Step 2: Commit**

```bash
git add api/app/Http/Controllers/Api/CompetitorController.php
git commit -m "feat(api): add CompetitorController with CRUD operations"
```

---

### Task 6: Add competitor routes

**Files:**
- Modify: `api/routes/api.php`

**Step 1: Add routes**

Add after the Tags routes section (around line 166):

```php
// Competitors
Route::prefix('competitors')->group(function () {
    Route::get('/', [CompetitorController::class, 'index']);
    Route::post('/', [CompetitorController::class, 'store']);
    Route::delete('{appId}', [CompetitorController::class, 'destroy']);
});

// App-specific competitors (within apps prefix, requires owns.app middleware)
```

Also add within the `apps` middleware group (around line 90, after the `toggleFavorite` route):

```php
Route::get('{app}/competitors', [CompetitorController::class, 'forApp']);
Route::post('{app}/competitors', [CompetitorController::class, 'linkToApp']);
Route::delete('{app}/competitors/{competitorAppId}', [CompetitorController::class, 'unlinkFromApp']);
```

And add the import at the top:
```php
use App\Http\Controllers\Api\CompetitorController;
```

**Step 2: Commit**

```bash
git add api/routes/api.php
git commit -m "feat(api): add competitor API routes"
```

---

### Task 7: Update AppController to include is_owner and is_competitor

**Files:**
- Modify: `api/app/Http/Controllers/Api/AppController.php`

**Step 1: Find the index method and update the response**

Locate the `index` method and ensure pivot data is included in the response. Find where apps are transformed/formatted and add:

```php
'is_owner' => $app->pivot->is_owner ?? false,
'is_competitor' => $app->pivot->is_competitor ?? false,
```

**Step 2: Update the show method similarly**

Ensure single app responses include `is_owner` and `is_competitor` from the pivot.

**Step 3: Commit**

```bash
git add api/app/Http/Controllers/Api/AppController.php
git commit -m "feat(api): include is_owner and is_competitor in app responses"
```

---

## Phase 3: Frontend Models

### Task 8: Update AppModel with isOwner and isCompetitor

**Files:**
- Modify: `app/lib/features/apps/domain/app_model.dart`

**Step 1: Add fields to AppModel class**

After `favoritedAt` field (line 28), add:
```dart
final bool isOwner;
final bool isCompetitor;
```

**Step 2: Update constructor**

Add parameters after `favoritedAt`:
```dart
this.isOwner = false,
this.isCompetitor = false,
```

**Step 3: Update copyWith**

Add to copyWith parameters:
```dart
bool? isOwner,
bool? isCompetitor,
```

Add to return statement:
```dart
isOwner: isOwner ?? this.isOwner,
isCompetitor: isCompetitor ?? this.isCompetitor,
```

**Step 4: Update fromJson**

Add parsing after `favoritedAt`:
```dart
isOwner: json['is_owner'] as bool? ?? false,
isCompetitor: json['is_competitor'] as bool? ?? false,
```

**Step 5: Commit**

```bash
git add app/lib/features/apps/domain/app_model.dart
git commit -m "feat(app): add isOwner and isCompetitor to AppModel"
```

---

### Task 9: Create CompetitorModel

**Files:**
- Create: `app/lib/features/competitors/domain/competitor_model.dart`

**Step 1: Create the file**

```dart
/// Represents a competitor app with its relationship metadata.
class CompetitorModel {
  final int id;
  final String platform;
  final String storeId;
  final String name;
  final String? iconUrl;
  final String? developer;
  final double? rating;
  final int ratingCount;
  final String competitorType; // 'global' or 'contextual'
  final String? source; // 'manual', 'auto_discovered', 'keyword_overlap'
  final DateTime? linkedAt;

  CompetitorModel({
    required this.id,
    required this.platform,
    required this.storeId,
    required this.name,
    this.iconUrl,
    this.developer,
    this.rating,
    required this.ratingCount,
    required this.competitorType,
    this.source,
    this.linkedAt,
  });

  bool get isGlobal => competitorType == 'global';
  bool get isContextual => competitorType == 'contextual';
  bool get isIos => platform == 'ios';
  bool get isAndroid => platform == 'android';

  factory CompetitorModel.fromJson(Map<String, dynamic> json) {
    return CompetitorModel(
      id: json['id'] as int,
      platform: json['platform'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      developer: json['developer'] as String?,
      rating: _parseDouble(json['rating']),
      ratingCount: _parseInt(json['rating_count']) ?? 0,
      competitorType: json['competitor_type'] as String? ?? 'global',
      source: json['source'] as String?,
      linkedAt: json['linked_at'] != null
          ? DateTime.tryParse(json['linked_at'] as String)
          : null,
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

**Step 2: Commit**

```bash
mkdir -p app/lib/features/competitors/domain
git add app/lib/features/competitors/domain/competitor_model.dart
git commit -m "feat(app): add CompetitorModel"
```

---

### Task 10: Create CompetitorsRepository

**Files:**
- Create: `app/lib/features/competitors/data/competitors_repository.dart`

**Step 1: Create the file**

```dart
import 'package:dio/dio.dart';
import '../domain/competitor_model.dart';

class CompetitorsRepository {
  final Dio _dio;

  CompetitorsRepository(this._dio);

  /// Get all competitors (global + contextual for optional app).
  Future<List<CompetitorModel>> getCompetitors({int? appId}) async {
    final queryParams = <String, dynamic>{};
    if (appId != null) {
      queryParams['app_id'] = appId;
    }

    final response = await _dio.get('/competitors', queryParameters: queryParams);
    final data = response.data['competitors'] as List<dynamic>;
    return data.map((json) => CompetitorModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Get competitors for a specific app.
  Future<List<CompetitorModel>> getCompetitorsForApp(int appId) async {
    final response = await _dio.get('/apps/$appId/competitors');
    final data = response.data['competitors'] as List<dynamic>;
    return data.map((json) => CompetitorModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Add a global competitor.
  Future<CompetitorModel> addGlobalCompetitor(int appId) async {
    final response = await _dio.post('/competitors', data: {'app_id': appId});
    return CompetitorModel.fromJson(response.data['competitor'] as Map<String, dynamic>);
  }

  /// Remove a global competitor.
  Future<void> removeGlobalCompetitor(int appId) async {
    await _dio.delete('/competitors/$appId');
  }

  /// Link a competitor to a specific app.
  Future<CompetitorModel> linkCompetitorToApp({
    required int ownerAppId,
    required int competitorAppId,
    String source = 'manual',
  }) async {
    final response = await _dio.post(
      '/apps/$ownerAppId/competitors',
      data: {
        'competitor_app_id': competitorAppId,
        'source': source,
      },
    );
    return CompetitorModel.fromJson(response.data['competitor'] as Map<String, dynamic>);
  }

  /// Unlink a competitor from a specific app.
  Future<void> unlinkCompetitorFromApp({
    required int ownerAppId,
    required int competitorAppId,
  }) async {
    await _dio.delete('/apps/$ownerAppId/competitors/$competitorAppId');
  }
}
```

**Step 2: Commit**

```bash
mkdir -p app/lib/features/competitors/data
git add app/lib/features/competitors/data/competitors_repository.dart
git commit -m "feat(app): add CompetitorsRepository"
```

---

### Task 11: Create competitors providers

**Files:**
- Create: `app/lib/features/competitors/providers/competitors_provider.dart`

**Step 1: Create the file**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/dio_provider.dart';
import '../../apps/providers/app_context_provider.dart';
import '../data/competitors_repository.dart';
import '../domain/competitor_model.dart';

/// Repository provider
final competitorsRepositoryProvider = Provider<CompetitorsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CompetitorsRepository(dio);
});

/// Competitors list provider (context-aware)
final competitorsProvider = FutureProvider<List<CompetitorModel>>((ref) async {
  final repository = ref.watch(competitorsRepositoryProvider);
  final selectedAppId = ref.watch(selectedAppIdProvider);

  if (selectedAppId != null) {
    return repository.getCompetitorsForApp(selectedAppId);
  } else {
    return repository.getCompetitors();
  }
});

/// Competitors for a specific app
final competitorsForAppProvider = FutureProvider.family<List<CompetitorModel>, int>((ref, appId) async {
  final repository = ref.watch(competitorsRepositoryProvider);
  return repository.getCompetitorsForApp(appId);
});

/// Filter state for competitors list
enum CompetitorFilter { all, global, contextual }

final competitorFilterProvider = StateProvider<CompetitorFilter>((ref) => CompetitorFilter.all);

/// Filtered competitors
final filteredCompetitorsProvider = Provider<AsyncValue<List<CompetitorModel>>>((ref) {
  final competitorsAsync = ref.watch(competitorsProvider);
  final filter = ref.watch(competitorFilterProvider);

  return competitorsAsync.whenData((competitors) {
    switch (filter) {
      case CompetitorFilter.all:
        return competitors;
      case CompetitorFilter.global:
        return competitors.where((c) => c.isGlobal).toList();
      case CompetitorFilter.contextual:
        return competitors.where((c) => c.isContextual).toList();
    }
  });
});
```

**Step 2: Commit**

```bash
mkdir -p app/lib/features/competitors/providers
git add app/lib/features/competitors/providers/competitors_provider.dart
git commit -m "feat(app): add competitors providers"
```

---

## Phase 4: Frontend UI

### Task 12: Update AppContextSwitcher to filter owned apps only

**Files:**
- Modify: `app/lib/core/widgets/app_context_switcher.dart`

**Step 1: Find where apps are filtered/displayed**

Locate where the apps list is used and add filter:
```dart
// Filter to show only owned apps
final ownedApps = apps.where((app) => app.isOwner).toList();
```

Use `ownedApps` instead of `apps` in the dropdown/selector.

**Step 2: Commit**

```bash
git add app/lib/core/widgets/app_context_switcher.dart
git commit -m "feat(app): filter AppContextSwitcher to owned apps only"
```

---

### Task 13: Update AppDetailScreen for competitor restrictions

**Files:**
- Modify: `app/lib/features/apps/presentation/app_detail_screen.dart`

**Step 1: Add isCompetitor check**

Find where action buttons are rendered (Reply to reviews, etc.) and wrap with condition:
```dart
if (!app.isCompetitor) ...[
  // Reply to reviews button
  // Opportunity Engine section
  // Keyword suggestions section
],
```

**Step 2: Add competitor badge in header if applicable**

```dart
if (app.isCompetitor)
  Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: colors.purple.withAlpha(30),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      'Competitor',
      style: AppTypography.caption.copyWith(color: colors.purple),
    ),
  ),
```

**Step 3: Commit**

```bash
git add app/lib/features/apps/presentation/app_detail_screen.dart
git commit -m "feat(app): restrict actions for competitor apps in detail screen"
```

---

### Task 14: Refactor CompetitorsScreen with new list view

**Files:**
- Modify: `app/lib/features/keywords/presentation/competitors_screen.dart`

This is a larger refactor. The new screen should:
1. Show list of competitors (global + contextual)
2. Have filter chips (All / Global / Linked to [App])
3. Each competitor tile shows: icon, name, type badge, rating, actions
4. Actions: View, Compare, Link/Unlink
5. Keep Compare functionality as a modal/action

**Step 1: Update imports and providers**

Replace the local providers with the new ones from competitors feature:
```dart
import '../../competitors/providers/competitors_provider.dart';
import '../../competitors/domain/competitor_model.dart';
```

**Step 2: Rewrite the screen structure**

The screen should have:
- Toolbar with title, filter, and Add button
- List of competitor tiles
- Empty state when no competitors
- Compare mode (existing) as a secondary action

(This is a substantial rewrite - implementation details depend on exact current structure)

**Step 3: Commit**

```bash
git add app/lib/features/keywords/presentation/competitors_screen.dart
git commit -m "feat(app): refactor CompetitorsScreen with list view and filters"
```

---

## Phase 5: Integration & Testing

### Task 15: Run Flutter code generation

**Step 1: Run build_runner**

```bash
cd app && dart run build_runner build --delete-conflicting-outputs
```

**Step 2: Verify no errors**

```bash
cd app && flutter analyze
```

Expected: No analysis issues.

**Step 3: Commit generated files if any**

```bash
git add -A && git commit -m "chore: regenerate code after model changes"
```

---

### Task 16: Manual integration test

**Step 1: Start backend**

```bash
cd api && php artisan serve
```

**Step 2: Start Flutter app**

```bash
cd app && flutter run --dart-define=API_BASE_URL=http://localhost:8000/api
```

**Step 3: Test scenarios**

1. Add a global competitor via API/UI
2. Verify it appears in Competitors section
3. Select an owned app in context switcher
4. Verify competitors list updates
5. Link a competitor to the selected app
6. Verify it shows as "contextual"
7. View competitor detail - verify restricted actions
8. Compare functionality still works

---

### Task 17: Final commit and summary

```bash
git add -A
git commit -m "feat: complete apps vs competitors differentiation

- Added is_competitor flag to user_apps pivot
- Created app_competitors table for contextual linking
- Added CompetitorController with full CRUD
- Updated Flutter models with isOwner/isCompetitor
- Created competitors repository and providers
- Updated UI to filter and restrict based on app type"
```

---

## Summary

| Phase | Tasks | Description |
|-------|-------|-------------|
| 1 | 1-4 | Backend data model (migrations, models) |
| 2 | 5-7 | Backend API (controller, routes) |
| 3 | 8-11 | Frontend models and providers |
| 4 | 12-14 | Frontend UI updates |
| 5 | 15-17 | Integration and testing |

**Estimated commits:** 12-15
**Key files created:** 6 new files
**Key files modified:** 6 existing files
