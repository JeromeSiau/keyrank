# Unify Competitors Architecture

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Unifier tous les competitors dans `app_competitors` avec `owner_app_id` nullable (NULL = global, valeur = contextuel) et supprimer `is_competitor` de `user_apps`.

**Architecture:**
- `app_competitors.owner_app_id` devient nullable
- Competitors globaux : `owner_app_id = NULL`
- Competitors contextuels : `owner_app_id = <app_id>`
- Suppression de `user_apps.is_competitor`

**Tech Stack:** Laravel 11, PHP 8.3, Flutter/Dart, Riverpod

---

## Task 1: Migration - Rendre owner_app_id nullable et migrer les données

**Files:**
- Create: `api/database/migrations/2026_01_16_120000_make_owner_app_id_nullable_in_app_competitors.php`

**Step 1: Créer la migration**

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
        // 1. Drop the unique constraint that includes owner_app_id
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->dropUnique('unique_competitor');
            $table->dropIndex(['user_id', 'owner_app_id']);
        });

        // 2. Make owner_app_id nullable
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->foreignId('owner_app_id')->nullable()->change();
        });

        // 3. Migrate global competitors from user_apps to app_competitors
        DB::statement("
            INSERT INTO app_competitors (user_id, owner_app_id, competitor_app_id, source, created_at)
            SELECT ua.user_id, NULL, ua.app_id, 'manual', ua.created_at
            FROM user_apps ua
            WHERE ua.is_competitor = 1
            AND NOT EXISTS (
                SELECT 1 FROM app_competitors ac
                WHERE ac.user_id = ua.user_id
                AND ac.owner_app_id IS NULL
                AND ac.competitor_app_id = ua.app_id
            )
        ");

        // 4. Add new unique constraint (user_id, owner_app_id nullable, competitor_app_id)
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->unique(['user_id', 'owner_app_id', 'competitor_app_id'], 'unique_competitor');
            $table->index(['user_id', 'owner_app_id']);
        });

        // 5. Remove is_competitor from user_apps
        Schema::table('user_apps', function (Blueprint $table) {
            $table->dropColumn('is_competitor');
        });
    }

    public function down(): void
    {
        // 1. Re-add is_competitor to user_apps
        Schema::table('user_apps', function (Blueprint $table) {
            $table->boolean('is_competitor')->default(false)->after('is_owner');
        });

        // 2. Migrate global competitors back to user_apps
        DB::statement("
            UPDATE user_apps ua
            SET is_competitor = 1
            WHERE EXISTS (
                SELECT 1 FROM app_competitors ac
                WHERE ac.user_id = ua.user_id
                AND ac.competitor_app_id = ua.app_id
                AND ac.owner_app_id IS NULL
            )
        ");

        // 3. Delete global competitors from app_competitors
        DB::table('app_competitors')->whereNull('owner_app_id')->delete();

        // 4. Drop constraints
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->dropUnique('unique_competitor');
            $table->dropIndex(['user_id', 'owner_app_id']);
        });

        // 5. Make owner_app_id required again
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->foreignId('owner_app_id')->nullable(false)->change();
        });

        // 6. Re-add original constraints
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->unique(['user_id', 'owner_app_id', 'competitor_app_id'], 'unique_competitor');
            $table->index(['user_id', 'owner_app_id']);
        });
    }
};
```

**Step 2: Vérifier la migration**

Run: `cd api && php artisan migrate:status`
Expected: La nouvelle migration apparaît en "Pending"

**Step 3: Exécuter la migration**

Run: `cd api && php artisan migrate`
Expected: Migration successful

---

## Task 2: Mettre à jour le modèle App - Supprimer scopeCompetitorsFor

**Files:**
- Modify: `api/app/Models/App.php:66-69` (users relation)
- Modify: `api/app/Models/App.php:193-199` (supprimer scopeCompetitorsFor)

**Step 1: Mettre à jour la relation users() pour retirer is_competitor du pivot**

Dans `api/app/Models/App.php`, modifier la méthode `users()` :

```php
public function users(): BelongsToMany
{
    return $this->belongsToMany(User::class, 'user_apps')
        ->withPivot('is_owner', 'is_favorite', 'favorited_at', 'created_at');
}
```

**Step 2: Supprimer le scope scopeCompetitorsFor**

Supprimer les lignes 193-199 (la méthode `scopeCompetitorsFor`).

**Step 3: Commit**

```bash
git add api/app/Models/App.php
git commit -m "refactor(api): remove is_competitor from App model pivot"
```

---

## Task 3: Mettre à jour le modèle AppCompetitor - Ajouter scope pour globaux

**Files:**
- Modify: `api/app/Models/AppCompetitor.php`

**Step 1: Ajouter les scopes pour filtrer global/contextuel**

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Builder;

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

    /**
     * Scope for global competitors (not linked to any specific app).
     */
    public function scopeGlobal(Builder $query): Builder
    {
        return $query->whereNull('owner_app_id');
    }

    /**
     * Scope for contextual competitors (linked to a specific app).
     */
    public function scopeContextual(Builder $query): Builder
    {
        return $query->whereNotNull('owner_app_id');
    }

    /**
     * Scope for competitors of a specific owner app.
     */
    public function scopeForOwnerApp(Builder $query, int $ownerAppId): Builder
    {
        return $query->where('owner_app_id', $ownerAppId);
    }

    /**
     * Check if this is a global competitor.
     */
    public function isGlobal(): bool
    {
        return $this->owner_app_id === null;
    }
}
```

**Step 2: Commit**

```bash
git add api/app/Models/AppCompetitor.php
git commit -m "refactor(api): add scopes for global/contextual competitors"
```

---

## Task 4: Mettre à jour CompetitorController - Utiliser uniquement app_competitors

**Files:**
- Modify: `api/app/Http/Controllers/Api/CompetitorController.php`

**Step 1: Réécrire index() pour utiliser app_competitors**

```php
/**
 * List all competitors (global + contextual) for the authenticated user.
 */
public function index(Request $request): JsonResponse
{
    $user = $request->user();
    $ownerAppId = $request->query('app_id');

    $query = AppCompetitor::where('user_id', $user->id)
        ->with(['competitorApp.latestRankings', 'competitorApp.latestRatings']);

    if ($ownerAppId) {
        // Get both global and contextual for this app
        $query->where(function ($q) use ($ownerAppId) {
            $q->whereNull('owner_app_id')
              ->orWhere('owner_app_id', $ownerAppId);
        });
    }

    $competitors = $query->get()
        ->map(fn($link) => $this->formatCompetitor(
            $link->competitorApp,
            $link->isGlobal() ? 'global' : 'contextual',
            $link
        ));

    // Deduplicate: if same competitor is both global and contextual, keep contextual
    $deduplicated = $competitors->groupBy('id')
        ->map(fn($group) => $group->firstWhere('competitor_type', 'contextual') ?? $group->first())
        ->values();

    return response()->json([
        'competitors' => $deduplicated,
    ]);
}
```

**Step 2: Réécrire store() pour créer dans app_competitors**

```php
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

    // Check if already exists as global competitor
    $existing = AppCompetitor::where('user_id', $user->id)
        ->whereNull('owner_app_id')
        ->where('competitor_app_id', $appId)
        ->first();

    if ($existing) {
        $app = App::with(['latestRankings', 'latestRatings'])->find($appId);
        return response()->json([
            'competitor' => $this->formatCompetitor($app, 'global', $existing),
        ], 200);
    }

    // Create global competitor
    $link = AppCompetitor::create([
        'user_id' => $user->id,
        'owner_app_id' => null,
        'competitor_app_id' => $appId,
        'source' => 'manual',
    ]);

    $app = App::with(['latestRankings', 'latestRatings'])->find($appId);

    return response()->json([
        'competitor' => $this->formatCompetitor($app, 'global', $link),
    ], 201);
}
```

**Step 3: Réécrire destroy() pour supprimer de app_competitors**

```php
/**
 * Remove a global competitor.
 */
public function destroy(Request $request, int $appId): JsonResponse
{
    $user = $request->user();

    // Remove global competitor entry
    AppCompetitor::where('user_id', $user->id)
        ->whereNull('owner_app_id')
        ->where('competitor_app_id', $appId)
        ->delete();

    // Also remove any contextual links
    AppCompetitor::where('user_id', $user->id)
        ->where('competitor_app_id', $appId)
        ->delete();

    return response()->json(['success' => true]);
}
```

**Step 4: Simplifier linkToApp() - retirer la logique user_apps**

```php
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

    $competitorApp = App::with(['latestRankings', 'latestRatings'])->find($competitorAppId);

    return response()->json([
        'competitor' => $this->formatCompetitor($competitorApp, 'contextual', $link),
    ], 201);
}
```

**Step 5: Simplifier forApp()**

```php
/**
 * Get competitors for a specific app.
 */
public function forApp(Request $request, int $appId): JsonResponse
{
    $user = $request->user();

    // Get both global and contextual competitors
    $competitors = AppCompetitor::where('user_id', $user->id)
        ->where(function ($q) use ($appId) {
            $q->whereNull('owner_app_id')
              ->orWhere('owner_app_id', $appId);
        })
        ->with(['competitorApp.latestRankings', 'competitorApp.latestRatings'])
        ->get()
        ->map(fn($link) => $this->formatCompetitor(
            $link->competitorApp,
            $link->isGlobal() ? 'global' : 'contextual',
            $link
        ));

    // Deduplicate: contextual takes precedence
    $deduplicated = $competitors->groupBy('id')
        ->map(fn($group) => $group->firstWhere('competitor_type', 'contextual') ?? $group->first())
        ->values();

    return response()->json([
        'competitors' => $deduplicated,
    ]);
}
```

**Step 6: Vérifier que le serveur démarre sans erreur**

Run: `cd api && php artisan serve &`
Expected: Server starts successfully

**Step 7: Commit**

```bash
git add api/app/Http/Controllers/Api/CompetitorController.php
git commit -m "refactor(api): use app_competitors table only for all competitors"
```

---

## Task 5: Nettoyer - Supprimer la migration is_competitor

**Files:**
- Delete: `api/database/migrations/2026_01_14_100000_add_is_competitor_to_user_apps.php`

**Step 1: Supprimer le fichier de migration (déjà appliquée et annulée par la nouvelle)**

```bash
rm api/database/migrations/2026_01_14_100000_add_is_competitor_to_user_apps.php
```

**Step 2: Commit**

```bash
git add -A
git commit -m "chore(api): remove obsolete is_competitor migration"
```

---

## Task 6: Mettre à jour le modèle User si nécessaire

**Files:**
- Check: `api/app/Models/User.php`

**Step 1: Vérifier si User.php référence is_competitor**

Chercher et supprimer toute référence à `is_competitor` dans le modèle User.

**Step 2: Commit si modifications**

```bash
git add api/app/Models/User.php
git commit -m "refactor(api): remove is_competitor references from User model"
```

---

## Task 7: Tester l'API manuellement

**Step 1: Tester GET /competitors**

Run: `curl -H "Authorization: Bearer <token>" http://localhost:8000/api/competitors | jq`
Expected: Liste des competitors avec `competitor_type: "global"` ou `"contextual"`

**Step 2: Tester POST /competitors (ajouter global)**

Run: `curl -X POST -H "Authorization: Bearer <token>" -H "Content-Type: application/json" -d '{"app_id": 1}' http://localhost:8000/api/competitors | jq`
Expected: Competitor créé avec `competitor_type: "global"`

**Step 3: Tester DELETE /competitors/{id}**

Run: `curl -X DELETE -H "Authorization: Bearer <token>" http://localhost:8000/api/competitors/1 | jq`
Expected: `{"success": true}`

---

## Task 8: Vérifier le frontend Flutter

**Files:**
- Review: `app/lib/features/competitors/data/competitors_repository.dart`
- Review: `app/lib/features/competitors/domain/competitor_model.dart`

**Step 1: Vérifier que le modèle Flutter est compatible**

Le modèle `CompetitorModel` utilise déjà `competitorType` qui vient de l'API - aucun changement nécessaire.

**Step 2: Vérifier le repository**

Le repository utilise les mêmes endpoints - aucun changement nécessaire.

**Step 3: Tester l'app Flutter**

Run: `cd app && flutter run`
Expected: La liste des competitors s'affiche correctement

---

## Task 9: Commit final et nettoyage

**Step 1: Vérifier que tout est propre**

Run: `cd api && php artisan test --filter=Competitor`
Expected: Tests passent (ou à créer si absents)

**Step 2: Commit final**

```bash
git add -A
git commit -m "refactor: unify competitors in app_competitors table

- Make owner_app_id nullable (NULL = global, value = contextual)
- Migrate existing global competitors from user_apps.is_competitor
- Remove is_competitor column from user_apps
- Update CompetitorController to use app_competitors only
- Add scopes to AppCompetitor model (global, contextual, forOwnerApp)
- No changes needed in Flutter (API response format unchanged)"
```
