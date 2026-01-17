# Team-Centric Architecture Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Refactor the app from user-centric to team-centric data ownership, with permission enforcement for viewers.

**Architecture:** All tracked resources (apps, keywords, competitors, alerts, tags, metadata) belong to teams via `team_id`. Controllers filter by user's `current_team_id` and check permissions before write operations using an `AuthorizesTeamActions` trait.

**Tech Stack:** Laravel 11, MySQL, Flutter/Riverpod

**Design Doc:** `docs/plans/2026-01-17-team-centric-permissions-design.md`

---

## Task 1: Database Migration

**Files:**
- Create: `api/database/migrations/2026_01_17_300000_convert_to_team_centric.php`

**Step 1: Create the migration file**

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
        // 1. Drop user_apps table (replaced by team_apps)
        Schema::dropIfExists('user_apps');

        // 2. tracked_keywords: add team_id, drop user_id
        Schema::table('tracked_keywords', function (Blueprint $table) {
            $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
        });
        Schema::table('tracked_keywords', function (Blueprint $table) {
            $table->dropForeign(['user_id']);
            $table->dropColumn('user_id');
        });
        // Update unique constraint
        DB::statement('DROP INDEX IF EXISTS tracked_keywords_user_app_keyword_unique ON tracked_keywords');
        Schema::table('tracked_keywords', function (Blueprint $table) {
            $table->unique(['team_id', 'app_id', 'keyword_id'], 'tracked_keywords_team_app_keyword_unique');
        });

        // 3. app_competitors: add team_id, drop user_id
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
        });
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->dropForeign(['user_id']);
            $table->dropColumn('user_id');
        });
        DB::statement('DROP INDEX IF EXISTS unique_competitor ON app_competitors');
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->unique(['team_id', 'owner_app_id', 'competitor_app_id'], 'app_competitors_team_unique');
        });

        // 4. alert_rules: add team_id, drop user_id
        Schema::table('alert_rules', function (Blueprint $table) {
            $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
        });
        Schema::table('alert_rules', function (Blueprint $table) {
            $table->dropForeign(['user_id']);
            $table->dropIndex(['user_id', 'type', 'is_active']);
            $table->dropIndex(['user_id', 'scope_type', 'scope_id']);
            $table->dropColumn('user_id');
        });
        Schema::table('alert_rules', function (Blueprint $table) {
            $table->index(['team_id', 'type', 'is_active']);
            $table->index(['team_id', 'scope_type', 'scope_id']);
        });

        // 5. tags: add team_id, drop user_id
        Schema::table('tags', function (Blueprint $table) {
            $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
        });
        Schema::table('tags', function (Blueprint $table) {
            $table->dropForeign(['user_id']);
            $table->dropIndex(['user_id']);
            $table->dropUnique(['user_id', 'name']);
            $table->dropColumn('user_id');
        });
        Schema::table('tags', function (Blueprint $table) {
            $table->unique(['team_id', 'name']);
            $table->index('team_id');
        });

        // 6. app_voice_settings: add team_id, drop user_id
        Schema::table('app_voice_settings', function (Blueprint $table) {
            $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
        });
        Schema::table('app_voice_settings', function (Blueprint $table) {
            $table->dropForeign(['user_id']);
            $table->dropUnique(['app_id', 'user_id']);
            $table->dropColumn('user_id');
        });
        Schema::table('app_voice_settings', function (Blueprint $table) {
            $table->unique(['team_id', 'app_id']);
        });

        // 7. app_metadata_drafts: add team_id, drop user_id
        Schema::table('app_metadata_drafts', function (Blueprint $table) {
            $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
        });
        Schema::table('app_metadata_drafts', function (Blueprint $table) {
            $table->dropForeign(['user_id']);
            $table->dropUnique('app_user_locale_unique');
            $table->dropIndex(['user_id', 'status']);
            $table->dropColumn('user_id');
        });
        Schema::table('app_metadata_drafts', function (Blueprint $table) {
            $table->unique(['team_id', 'app_id', 'locale'], 'app_team_locale_unique');
            $table->index(['team_id', 'status']);
        });

        // 8. subscriptions: add team_id, drop user_id
        Schema::table('subscriptions', function (Blueprint $table) {
            $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
        });
        Schema::table('subscriptions', function (Blueprint $table) {
            $table->dropIndex(['user_id', 'stripe_status']);
            $table->dropColumn('user_id');
        });
        Schema::table('subscriptions', function (Blueprint $table) {
            $table->index(['team_id', 'stripe_status']);
        });
    }

    public function down(): void
    {
        // Not implementing down() - this is a destructive migration for dev only
        throw new \Exception('This migration cannot be reversed');
    }
};
```

**Step 2: Run the migration**

```bash
cd api && php artisan migrate
```

Expected: Migration runs successfully, tables updated.

**Step 3: Commit**

```bash
git add api/database/migrations/2026_01_17_300000_convert_to_team_centric.php
git commit -m "feat: migrate tables from user_id to team_id"
```

---

## Task 2: Create AuthorizesTeamActions Trait

**Files:**
- Create: `api/app/Http/Controllers/Concerns/AuthorizesTeamActions.php`

**Step 1: Create the trait**

```php
<?php

namespace App\Http\Controllers\Concerns;

use App\Models\Team;
use Illuminate\Http\JsonResponse;

trait AuthorizesTeamActions
{
    /**
     * Get the current team for the authenticated user.
     */
    protected function currentTeam(): Team
    {
        $user = auth()->user();
        $team = $user->currentTeam;

        if (!$team) {
            abort(403, 'No team selected. Please select a team first.');
        }

        return $team;
    }

    /**
     * Authorize an action based on team permissions.
     *
     * @throws \Symfony\Component\HttpKernel\Exception\HttpException
     */
    protected function authorizeTeamAction(string $permission): void
    {
        $user = auth()->user();
        $team = $this->currentTeam();

        if (!$team->userHasPermission($user, $permission)) {
            abort(403, "You do not have permission to: {$permission}");
        }
    }

    /**
     * Check if user can perform action (without aborting).
     */
    protected function canPerformTeamAction(string $permission): bool
    {
        $user = auth()->user();
        $team = $user->currentTeam;

        if (!$team) {
            return false;
        }

        return $team->userHasPermission($user, $permission);
    }
}
```

**Step 2: Commit**

```bash
git add api/app/Http/Controllers/Concerns/AuthorizesTeamActions.php
git commit -m "feat: add AuthorizesTeamActions trait for permission checks"
```

---

## Task 3: Update Models

**Files:**
- Modify: `api/app/Models/TrackedKeyword.php`
- Modify: `api/app/Models/AppCompetitor.php`
- Modify: `api/app/Models/AlertRule.php`
- Modify: `api/app/Models/Tag.php`
- Modify: `api/app/Models/AppVoiceSetting.php`
- Modify: `api/app/Models/AppMetadataDraft.php`

**Step 1: Update TrackedKeyword model**

In `api/app/Models/TrackedKeyword.php`, change `user_id` to `team_id` in fillable and relationships:

```php
// Change in $fillable array:
// 'user_id' => 'team_id'

// Change relationship:
public function team(): BelongsTo
{
    return $this->belongsTo(Team::class);
}
// Remove user() relationship if exists
```

**Step 2: Update AppCompetitor model**

In `api/app/Models/AppCompetitor.php`:

```php
// In $fillable: change 'user_id' to 'team_id'

// Add relationship:
public function team(): BelongsTo
{
    return $this->belongsTo(Team::class);
}
```

**Step 3: Update AlertRule model**

In `api/app/Models/AlertRule.php`:

```php
// In $fillable: change 'user_id' to 'team_id'

// Change relationship:
public function team(): BelongsTo
{
    return $this->belongsTo(Team::class);
}
```

**Step 4: Update Tag model**

In `api/app/Models/Tag.php`:

```php
// In $fillable: change 'user_id' to 'team_id'

// Add relationship:
public function team(): BelongsTo
{
    return $this->belongsTo(Team::class);
}
```

**Step 5: Update AppVoiceSetting model** (if exists)

```php
// In $fillable: change 'user_id' to 'team_id'

public function team(): BelongsTo
{
    return $this->belongsTo(Team::class);
}
```

**Step 6: Update AppMetadataDraft model**

In `api/app/Models/AppMetadataDraft.php`:

```php
// In $fillable: change 'user_id' to 'team_id'

public function team(): BelongsTo
{
    return $this->belongsTo(Team::class);
}
```

**Step 7: Commit**

```bash
git add api/app/Models/
git commit -m "feat: update models to use team_id instead of user_id"
```

---

## Task 4: Update AppController

**Files:**
- Modify: `api/app/Http/Controllers/Api/AppController.php`

**Step 1: Add trait and update methods**

```php
use App\Http\Controllers\Concerns\AuthorizesTeamActions;

class AppController extends Controller
{
    use AuthorizesTeamActions;

    public function index(Request $request): JsonResponse
    {
        $team = $this->currentTeam();
        $apps = $team->apps()->with(['keywords', 'ratings'])->get();

        return response()->json(['data' => $apps]);
    }

    public function store(Request $request): JsonResponse
    {
        $this->authorizeTeamAction('manage_apps');

        // ... existing validation ...

        $team = $this->currentTeam();
        // Add app to team via team_apps pivot
        $team->apps()->attach($app->id, ['added_by' => auth()->id()]);

        // ... rest of method ...
    }

    public function destroy(App $app): JsonResponse
    {
        $this->authorizeTeamAction('manage_apps');

        $team = $this->currentTeam();
        $team->apps()->detach($app->id);

        return response()->json(['success' => true]);
    }
}
```

**Step 2: Verify with route test**

```bash
cd api && php artisan route:list --path=apps
```

**Step 3: Commit**

```bash
git add api/app/Http/Controllers/Api/AppController.php
git commit -m "feat: update AppController to use team-centric data"
```

---

## Task 5: Update KeywordController

**Files:**
- Modify: `api/app/Http/Controllers/Api/KeywordController.php`

**Step 1: Add trait and update queries**

Replace `auth()->id()` / `$request->user()->id` with `$this->currentTeam()->id`:

```php
use App\Http\Controllers\Concerns\AuthorizesTeamActions;

class KeywordController extends Controller
{
    use AuthorizesTeamActions;

    public function index(Request $request, App $app): JsonResponse
    {
        $team = $this->currentTeam();
        $keywords = TrackedKeyword::where('team_id', $team->id)
            ->where('app_id', $app->id)
            ->get();

        return response()->json(['data' => $keywords]);
    }

    public function store(Request $request, App $app): JsonResponse
    {
        $this->authorizeTeamAction('manage_keywords');

        $team = $this->currentTeam();

        // Create with team_id instead of user_id
        $keyword = TrackedKeyword::create([
            'team_id' => $team->id,
            'app_id' => $app->id,
            // ... other fields
        ]);

        return response()->json(['data' => $keyword], 201);
    }

    public function destroy(TrackedKeyword $keyword): JsonResponse
    {
        $this->authorizeTeamAction('manage_keywords');

        // Verify keyword belongs to current team
        if ($keyword->team_id !== $this->currentTeam()->id) {
            abort(403);
        }

        $keyword->delete();
        return response()->json(['success' => true]);
    }
}
```

**Step 2: Commit**

```bash
git add api/app/Http/Controllers/Api/KeywordController.php
git commit -m "feat: update KeywordController to use team_id"
```

---

## Task 6: Update CompetitorController

**Files:**
- Modify: `api/app/Http/Controllers/Api/CompetitorController.php`

**Step 1: Add trait and update**

```php
use App\Http\Controllers\Concerns\AuthorizesTeamActions;

class CompetitorController extends Controller
{
    use AuthorizesTeamActions;

    // Replace all auth()->id() with $this->currentTeam()->id
    // Add $this->authorizeTeamAction('manage_competitors') to store/update/destroy
}
```

**Step 2: Commit**

```bash
git add api/app/Http/Controllers/Api/CompetitorController.php
git commit -m "feat: update CompetitorController to use team_id"
```

---

## Task 7: Update AlertRulesController

**Files:**
- Modify: `api/app/Http/Controllers/Api/AlertRulesController.php`

**Step 1: Add trait and update**

```php
use App\Http\Controllers\Concerns\AuthorizesTeamActions;

class AlertRulesController extends Controller
{
    use AuthorizesTeamActions;

    // Replace user_id queries with team_id
    // Add authorizeTeamAction('manage_alerts') to write operations
}
```

**Step 2: Commit**

```bash
git add api/app/Http/Controllers/Api/AlertRulesController.php
git commit -m "feat: update AlertRulesController to use team_id"
```

---

## Task 8: Update MetadataController

**Files:**
- Modify: `api/app/Http/Controllers/Api/MetadataController.php`

**Step 1: Add trait and update**

```php
use App\Http\Controllers\Concerns\AuthorizesTeamActions;

class MetadataController extends Controller
{
    use AuthorizesTeamActions;

    // Replace user_id with team_id
    // Add authorizeTeamAction('edit_metadata') to write operations
}
```

**Step 2: Commit**

```bash
git add api/app/Http/Controllers/Api/MetadataController.php
git commit -m "feat: update MetadataController to use team_id"
```

---

## Task 9: Update TagsController

**Files:**
- Modify: `api/app/Http/Controllers/Api/TagsController.php`

**Step 1: Add trait and update**

```php
use App\Http\Controllers\Concerns\AuthorizesTeamActions;

class TagsController extends Controller
{
    use AuthorizesTeamActions;

    // Replace user_id with team_id
    // Add authorizeTeamAction('manage_apps') to write operations
}
```

**Step 2: Commit**

```bash
git add api/app/Http/Controllers/Api/TagsController.php
git commit -m "feat: update TagsController to use team_id"
```

---

## Task 10: Update Flutter Team Provider for Cache Invalidation

**Files:**
- Modify: `app/lib/features/team/providers/team_provider.dart`

**Step 1: Update switchTeam to invalidate all team-dependent caches**

```dart
Future<TeamModel?> switchTeam(int teamId) async {
  state = const AsyncValue.loading();
  try {
    final team = await _repository.switchTeam(teamId);
    _ref.read(currentTeamIdProvider.notifier).state = teamId;

    // Invalidate all team-dependent providers
    _ref.invalidate(appsProvider);
    _ref.invalidate(keywordsProvider);
    // Add other providers as needed

    state = const AsyncValue.data(null);
    return team;
  } catch (e, st) {
    state = AsyncValue.error(e, st);
    return null;
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/features/team/providers/team_provider.dart
git commit -m "feat: invalidate caches on team switch"
```

---

## Task 11: Verification

**Step 1: Reset database and test**

```bash
cd api
php artisan migrate:fresh
php artisan db:seed # if you have seeders
```

**Step 2: Test API endpoints**

```bash
# Create user (auto-creates Personal team)
# Login
# Add an app → should work (owner has all permissions)
# Check app appears in team context
```

**Step 3: Final commit**

```bash
git add -A
git commit -m "feat: complete team-centric architecture migration"
```

---

## Summary

| Task | Description | Permission |
|------|-------------|------------|
| 1 | Database migration | - |
| 2 | AuthorizesTeamActions trait | - |
| 3 | Update models | - |
| 4 | AppController | `manage_apps` |
| 5 | KeywordController | `manage_keywords` |
| 6 | CompetitorController | `manage_competitors` |
| 7 | AlertRulesController | `manage_alerts` |
| 8 | MetadataController | `edit_metadata` |
| 9 | TagsController | `manage_apps` |
| 10 | Flutter cache invalidation | - |
| 11 | Verification | - |
