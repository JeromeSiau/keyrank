# Keyrank Features Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Ajouter 8 features d'organisation et productivité à Keyrank (Favorites, Tags, Bulk Actions, Export, Comparaison, Filtres, Historique, Notes)

**Architecture:** Laravel API backend avec PHPUnit tests, Flutter frontend avec Riverpod state management. Pattern Repository pour l'accès aux données. TDD approach: test first, implement minimal, refactor.

**Tech Stack:** Laravel 11 + PHPUnit, Flutter 3.x + Riverpod 2.6, PostgreSQL, Dio HTTP client

---

## Feature 1: Favorites & Tags

### Task 1.1: Migration - Ajouter is_favorite à tracked_keywords

**Files:**
- Create: `api/database/migrations/2026_01_10_000001_add_favorite_to_tracked_keywords.php`
- Test: `api/tests/Feature/FavoritesTest.php`

**Step 1: Créer le fichier de test**

```php
// api/tests/Feature/FavoritesTest.php
<?php

namespace Tests\Feature;

use App\Models\App;
use App\Models\Keyword;
use App\Models\TrackedKeyword;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FavoritesTest extends TestCase
{
    use RefreshDatabase;

    public function test_tracked_keyword_has_favorite_columns(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();

        $tracked = TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'is_favorite' => true,
            'favorited_at' => now(),
        ]);

        $this->assertTrue($tracked->is_favorite);
        $this->assertNotNull($tracked->favorited_at);
    }
}
```

**Step 2: Run test - expect FAIL**

```bash
cd api && php artisan test tests/Feature/FavoritesTest.php --filter=test_tracked_keyword_has_favorite_columns
```

Expected: FAIL - Column `is_favorite` doesn't exist

**Step 3: Créer la migration**

```bash
cd api && php artisan make:migration add_favorite_to_tracked_keywords --table=tracked_keywords
```

**Step 4: Implémenter la migration**

```php
// api/database/migrations/2026_01_10_000001_add_favorite_to_tracked_keywords.php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('tracked_keywords', function (Blueprint $table) {
            $table->boolean('is_favorite')->default(false)->after('keyword_id');
            $table->timestamp('favorited_at')->nullable()->after('is_favorite');
        });
    }

    public function down(): void
    {
        Schema::table('tracked_keywords', function (Blueprint $table) {
            $table->dropColumn(['is_favorite', 'favorited_at']);
        });
    }
};
```

**Step 5: Mettre à jour TrackedKeyword model**

```php
// api/app/Models/TrackedKeyword.php - Ajouter aux fillable et casts
protected $fillable = [
    'user_id',
    'app_id',
    'keyword_id',
    'is_favorite',
    'favorited_at',
    'created_at',
];

protected $casts = [
    'is_favorite' => 'boolean',
    'favorited_at' => 'datetime',
    'created_at' => 'datetime',
];
```

**Step 6: Run test - expect PASS**

```bash
cd api && php artisan test tests/Feature/FavoritesTest.php --filter=test_tracked_keyword_has_favorite_columns
```

Expected: PASS

**Step 7: Commit**

```bash
cd api && git add database/migrations/*add_favorite* app/Models/TrackedKeyword.php tests/Feature/FavoritesTest.php && git commit -m "$(cat <<'EOF'
feat(api): add is_favorite column to tracked_keywords

- Add is_favorite boolean and favorited_at timestamp
- Update TrackedKeyword model with new fillable/casts
- Add test for favorite columns
EOF
)"
```

---

### Task 1.2: API Endpoint - Toggle Favorite

**Files:**
- Modify: `api/app/Http/Controllers/Api/KeywordController.php`
- Modify: `api/routes/api.php`
- Test: `api/tests/Feature/FavoritesTest.php`

**Step 1: Ajouter le test pour toggle favorite**

```php
// api/tests/Feature/FavoritesTest.php - Ajouter cette méthode
public function test_user_can_toggle_keyword_favorite(): void
{
    $user = User::factory()->create();
    $app = App::factory()->create();
    $app->users()->attach($user->id);
    $keyword = Keyword::factory()->create();

    $tracked = TrackedKeyword::create([
        'user_id' => $user->id,
        'app_id' => $app->id,
        'keyword_id' => $keyword->id,
    ]);

    // Toggle ON
    $response = $this->actingAs($user)->patchJson("/api/apps/{$app->id}/keywords/{$keyword->id}/favorite");

    $response->assertOk();
    $this->assertTrue($tracked->fresh()->is_favorite);
    $this->assertNotNull($tracked->fresh()->favorited_at);

    // Toggle OFF
    $response = $this->actingAs($user)->patchJson("/api/apps/{$app->id}/keywords/{$keyword->id}/favorite");

    $response->assertOk();
    $this->assertFalse($tracked->fresh()->is_favorite);
    $this->assertNull($tracked->fresh()->favorited_at);
}
```

**Step 2: Run test - expect FAIL**

```bash
cd api && php artisan test tests/Feature/FavoritesTest.php --filter=test_user_can_toggle_keyword_favorite
```

Expected: FAIL - Route not found (404)

**Step 3: Ajouter la route**

```php
// api/routes/api.php - Dans le groupe apps/{app}/keywords
Route::patch('{keyword}/favorite', [KeywordController::class, 'toggleFavorite']);
```

**Step 4: Run test - expect FAIL**

```bash
cd api && php artisan test tests/Feature/FavoritesTest.php --filter=test_user_can_toggle_keyword_favorite
```

Expected: FAIL - Method toggleFavorite does not exist

**Step 5: Implémenter toggleFavorite**

```php
// api/app/Http/Controllers/Api/KeywordController.php - Ajouter cette méthode
public function toggleFavorite(Request $request, App $app, Keyword $keyword): JsonResponse
{
    $user = $request->user();

    $tracked = TrackedKeyword::where('user_id', $user->id)
        ->where('app_id', $app->id)
        ->where('keyword_id', $keyword->id)
        ->firstOrFail();

    $newFavorite = !$tracked->is_favorite;

    $tracked->update([
        'is_favorite' => $newFavorite,
        'favorited_at' => $newFavorite ? now() : null,
    ]);

    return response()->json([
        'data' => [
            'is_favorite' => $tracked->is_favorite,
            'favorited_at' => $tracked->favorited_at?->toISOString(),
        ],
    ]);
}
```

**Step 6: Run test - expect PASS**

```bash
cd api && php artisan test tests/Feature/FavoritesTest.php --filter=test_user_can_toggle_keyword_favorite
```

Expected: PASS

**Step 7: Commit**

```bash
cd api && git add app/Http/Controllers/Api/KeywordController.php routes/api.php tests/Feature/FavoritesTest.php && git commit -m "$(cat <<'EOF'
feat(api): add toggle favorite endpoint for keywords

- PATCH /apps/{app}/keywords/{keyword}/favorite
- Toggles is_favorite boolean and sets/clears favorited_at
EOF
)"
```

---

### Task 1.3: Migration - Créer table tags

**Files:**
- Create: `api/database/migrations/2026_01_10_000002_create_tags_table.php`
- Create: `api/app/Models/Tag.php`
- Test: `api/tests/Feature/TagsTest.php`

**Step 1: Créer le fichier de test**

```php
// api/tests/Feature/TagsTest.php
<?php

namespace Tests\Feature;

use App\Models\Tag;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class TagsTest extends TestCase
{
    use RefreshDatabase;

    public function test_tag_belongs_to_user(): void
    {
        $user = User::factory()->create();

        $tag = Tag::create([
            'user_id' => $user->id,
            'name' => 'Important',
            'color' => '#ef4444',
        ]);

        $this->assertEquals($user->id, $tag->user_id);
        $this->assertEquals('Important', $tag->name);
        $this->assertEquals('#ef4444', $tag->color);
    }
}
```

**Step 2: Run test - expect FAIL**

```bash
cd api && php artisan test tests/Feature/TagsTest.php --filter=test_tag_belongs_to_user
```

Expected: FAIL - Class Tag not found

**Step 3: Créer la migration**

```bash
cd api && php artisan make:migration create_tags_table
```

**Step 4: Implémenter la migration**

```php
// api/database/migrations/2026_01_10_000002_create_tags_table.php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tags', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->string('name', 50);
            $table->string('color', 7)->default('#6366f1');
            $table->timestamps();

            $table->unique(['user_id', 'name']);
            $table->index('user_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('tags');
    }
};
```

**Step 5: Créer le model Tag**

```php
// api/app/Models/Tag.php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Tag extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'name',
        'color',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
```

**Step 6: Créer la factory Tag**

```php
// api/database/factories/TagFactory.php
<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class TagFactory extends Factory
{
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'name' => fake()->word(),
            'color' => fake()->hexColor(),
        ];
    }
}
```

**Step 7: Run test - expect PASS**

```bash
cd api && php artisan test tests/Feature/TagsTest.php --filter=test_tag_belongs_to_user
```

Expected: PASS

**Step 8: Commit**

```bash
cd api && git add database/migrations/*create_tags* database/factories/TagFactory.php app/Models/Tag.php tests/Feature/TagsTest.php && git commit -m "$(cat <<'EOF'
feat(api): create tags table and model

- Tags belong to users with unique name per user
- Color hex code support with default indigo
EOF
)"
```

---

### Task 1.4: Migration - Créer table pivot tag_keyword

**Files:**
- Create: `api/database/migrations/2026_01_10_000003_create_tag_keyword_table.php`
- Modify: `api/app/Models/Tag.php`
- Modify: `api/app/Models/TrackedKeyword.php`
- Test: `api/tests/Feature/TagsTest.php`

**Step 1: Ajouter le test pour la relation many-to-many**

```php
// api/tests/Feature/TagsTest.php - Ajouter cette méthode
public function test_tag_can_be_attached_to_tracked_keyword(): void
{
    $user = User::factory()->create();
    $app = App::factory()->create();
    $app->users()->attach($user->id);
    $keyword = Keyword::factory()->create();

    $tracked = TrackedKeyword::create([
        'user_id' => $user->id,
        'app_id' => $app->id,
        'keyword_id' => $keyword->id,
    ]);

    $tag = Tag::create([
        'user_id' => $user->id,
        'name' => 'Important',
        'color' => '#ef4444',
    ]);

    $tracked->tags()->attach($tag->id);

    $this->assertCount(1, $tracked->tags);
    $this->assertEquals('Important', $tracked->tags->first()->name);
}
```

N'oublie pas d'ajouter les imports en haut du fichier:
```php
use App\Models\App;
use App\Models\Keyword;
use App\Models\TrackedKeyword;
```

**Step 2: Run test - expect FAIL**

```bash
cd api && php artisan test tests/Feature/TagsTest.php --filter=test_tag_can_be_attached_to_tracked_keyword
```

Expected: FAIL - Table tag_keyword doesn't exist

**Step 3: Créer la migration pivot**

```bash
cd api && php artisan make:migration create_tag_keyword_table
```

**Step 4: Implémenter la migration**

```php
// api/database/migrations/2026_01_10_000003_create_tag_keyword_table.php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tag_keyword', function (Blueprint $table) {
            $table->id();
            $table->foreignId('tag_id')->constrained()->cascadeOnDelete();
            $table->foreignId('tracked_keyword_id')->constrained()->cascadeOnDelete();
            $table->timestamps();

            $table->unique(['tag_id', 'tracked_keyword_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('tag_keyword');
    }
};
```

**Step 5: Ajouter la relation dans Tag**

```php
// api/app/Models/Tag.php - Ajouter use et méthode
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

public function trackedKeywords(): BelongsToMany
{
    return $this->belongsToMany(TrackedKeyword::class, 'tag_keyword')
        ->withTimestamps();
}
```

**Step 6: Ajouter la relation dans TrackedKeyword**

```php
// api/app/Models/TrackedKeyword.php - Ajouter use et méthode
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

public function tags(): BelongsToMany
{
    return $this->belongsToMany(Tag::class, 'tag_keyword')
        ->withTimestamps();
}
```

**Step 7: Run test - expect PASS**

```bash
cd api && php artisan test tests/Feature/TagsTest.php --filter=test_tag_can_be_attached_to_tracked_keyword
```

Expected: PASS

**Step 8: Commit**

```bash
cd api && git add database/migrations/*tag_keyword* app/Models/Tag.php app/Models/TrackedKeyword.php tests/Feature/TagsTest.php && git commit -m "$(cat <<'EOF'
feat(api): create tag_keyword pivot table

- Many-to-many relationship between tags and tracked_keywords
- Cascade delete on both sides
EOF
)"
```

---

### Task 1.5: API - CRUD Tags

**Files:**
- Create: `api/app/Http/Controllers/Api/TagsController.php`
- Modify: `api/routes/api.php`
- Test: `api/tests/Feature/TagsTest.php`

**Step 1: Ajouter les tests CRUD**

```php
// api/tests/Feature/TagsTest.php - Ajouter ces méthodes

public function test_user_can_list_their_tags(): void
{
    $user = User::factory()->create();
    Tag::factory()->count(3)->create(['user_id' => $user->id]);
    Tag::factory()->create(); // Another user's tag

    $response = $this->actingAs($user)->getJson('/api/tags');

    $response->assertOk();
    $response->assertJsonCount(3, 'data');
}

public function test_user_can_create_tag(): void
{
    $user = User::factory()->create();

    $response = $this->actingAs($user)->postJson('/api/tags', [
        'name' => 'High Priority',
        'color' => '#ef4444',
    ]);

    $response->assertCreated();
    $response->assertJsonPath('data.name', 'High Priority');
    $this->assertDatabaseHas('tags', [
        'user_id' => $user->id,
        'name' => 'High Priority',
    ]);
}

public function test_user_cannot_create_duplicate_tag_name(): void
{
    $user = User::factory()->create();
    Tag::create(['user_id' => $user->id, 'name' => 'Important', 'color' => '#000']);

    $response = $this->actingAs($user)->postJson('/api/tags', [
        'name' => 'Important',
        'color' => '#ef4444',
    ]);

    $response->assertStatus(422);
}

public function test_user_can_delete_their_tag(): void
{
    $user = User::factory()->create();
    $tag = Tag::create(['user_id' => $user->id, 'name' => 'ToDelete', 'color' => '#000']);

    $response = $this->actingAs($user)->deleteJson("/api/tags/{$tag->id}");

    $response->assertNoContent();
    $this->assertDatabaseMissing('tags', ['id' => $tag->id]);
}
```

**Step 2: Run tests - expect FAIL**

```bash
cd api && php artisan test tests/Feature/TagsTest.php
```

Expected: FAIL - Route not found

**Step 3: Créer le controller**

```php
// api/app/Http/Controllers/Api/TagsController.php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Tag;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Validation\Rule;

class TagsController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $tags = Tag::where('user_id', $request->user()->id)
            ->orderBy('name')
            ->get();

        return response()->json(['data' => $tags]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => [
                'required',
                'string',
                'max:50',
                Rule::unique('tags')->where('user_id', $request->user()->id),
            ],
            'color' => 'nullable|string|regex:/^#[0-9a-fA-F]{6}$/',
        ]);

        $tag = Tag::create([
            'user_id' => $request->user()->id,
            'name' => $validated['name'],
            'color' => $validated['color'] ?? '#6366f1',
        ]);

        return response()->json(['data' => $tag], 201);
    }

    public function destroy(Request $request, Tag $tag): Response
    {
        if ($tag->user_id !== $request->user()->id) {
            abort(403);
        }

        $tag->delete();

        return response()->noContent();
    }
}
```

**Step 4: Ajouter les routes**

```php
// api/routes/api.php - Dans le groupe auth:sanctum
Route::prefix('tags')->group(function () {
    Route::get('/', [TagsController::class, 'index']);
    Route::post('/', [TagsController::class, 'store']);
    Route::delete('{tag}', [TagsController::class, 'destroy']);
});
```

N'oublie pas l'import en haut du fichier:
```php
use App\Http\Controllers\Api\TagsController;
```

**Step 5: Run tests - expect PASS**

```bash
cd api && php artisan test tests/Feature/TagsTest.php
```

Expected: All PASS

**Step 6: Commit**

```bash
cd api && git add app/Http/Controllers/Api/TagsController.php routes/api.php tests/Feature/TagsTest.php && git commit -m "$(cat <<'EOF'
feat(api): add CRUD endpoints for tags

- GET /tags - list user's tags
- POST /tags - create new tag
- DELETE /tags/{id} - delete tag
EOF
)"
```

---

### Task 1.6: API - Attach/Detach Tags to Keywords

**Files:**
- Modify: `api/app/Http/Controllers/Api/TagsController.php`
- Modify: `api/routes/api.php`
- Test: `api/tests/Feature/TagsTest.php`

**Step 1: Ajouter les tests**

```php
// api/tests/Feature/TagsTest.php - Ajouter ces méthodes

public function test_user_can_add_tag_to_keyword(): void
{
    $user = User::factory()->create();
    $app = App::factory()->create();
    $app->users()->attach($user->id);
    $keyword = Keyword::factory()->create();
    $tracked = TrackedKeyword::create([
        'user_id' => $user->id,
        'app_id' => $app->id,
        'keyword_id' => $keyword->id,
    ]);
    $tag = Tag::create(['user_id' => $user->id, 'name' => 'Test', 'color' => '#000']);

    $response = $this->actingAs($user)->postJson('/api/tags/add-to-keyword', [
        'tag_id' => $tag->id,
        'tracked_keyword_id' => $tracked->id,
    ]);

    $response->assertOk();
    $this->assertTrue($tracked->tags->contains($tag));
}

public function test_user_can_remove_tag_from_keyword(): void
{
    $user = User::factory()->create();
    $app = App::factory()->create();
    $app->users()->attach($user->id);
    $keyword = Keyword::factory()->create();
    $tracked = TrackedKeyword::create([
        'user_id' => $user->id,
        'app_id' => $app->id,
        'keyword_id' => $keyword->id,
    ]);
    $tag = Tag::create(['user_id' => $user->id, 'name' => 'Test', 'color' => '#000']);
    $tracked->tags()->attach($tag->id);

    $response = $this->actingAs($user)->postJson('/api/tags/remove-from-keyword', [
        'tag_id' => $tag->id,
        'tracked_keyword_id' => $tracked->id,
    ]);

    $response->assertOk();
    $this->assertFalse($tracked->fresh()->tags->contains($tag));
}
```

**Step 2: Run tests - expect FAIL**

```bash
cd api && php artisan test tests/Feature/TagsTest.php --filter="test_user_can_add_tag_to_keyword|test_user_can_remove_tag_from_keyword"
```

Expected: FAIL - Route not found

**Step 3: Ajouter les méthodes au controller**

```php
// api/app/Http/Controllers/Api/TagsController.php - Ajouter ces méthodes

public function addToKeyword(Request $request): JsonResponse
{
    $validated = $request->validate([
        'tag_id' => 'required|exists:tags,id',
        'tracked_keyword_id' => 'required|exists:tracked_keywords,id',
    ]);

    $user = $request->user();
    $tag = Tag::findOrFail($validated['tag_id']);
    $tracked = TrackedKeyword::findOrFail($validated['tracked_keyword_id']);

    // Verify ownership
    if ($tag->user_id !== $user->id || $tracked->user_id !== $user->id) {
        abort(403);
    }

    $tracked->tags()->syncWithoutDetaching([$tag->id]);

    return response()->json([
        'data' => $tracked->load('tags'),
    ]);
}

public function removeFromKeyword(Request $request): JsonResponse
{
    $validated = $request->validate([
        'tag_id' => 'required|exists:tags,id',
        'tracked_keyword_id' => 'required|exists:tracked_keywords,id',
    ]);

    $user = $request->user();
    $tag = Tag::findOrFail($validated['tag_id']);
    $tracked = TrackedKeyword::findOrFail($validated['tracked_keyword_id']);

    // Verify ownership
    if ($tag->user_id !== $user->id || $tracked->user_id !== $user->id) {
        abort(403);
    }

    $tracked->tags()->detach($tag->id);

    return response()->json([
        'data' => $tracked->load('tags'),
    ]);
}
```

**Step 4: Ajouter les routes**

```php
// api/routes/api.php - Dans le groupe tags
Route::post('add-to-keyword', [TagsController::class, 'addToKeyword']);
Route::post('remove-from-keyword', [TagsController::class, 'removeFromKeyword']);
```

**Step 5: Run tests - expect PASS**

```bash
cd api && php artisan test tests/Feature/TagsTest.php
```

Expected: All PASS

**Step 6: Commit**

```bash
cd api && git add app/Http/Controllers/Api/TagsController.php routes/api.php tests/Feature/TagsTest.php && git commit -m "$(cat <<'EOF'
feat(api): add/remove tags from keywords

- POST /tags/add-to-keyword
- POST /tags/remove-from-keyword
- Ownership verification for both tag and keyword
EOF
)"
```

---

### Task 1.7: Flutter - Tag Model & Repository

**Files:**
- Create: `app/lib/features/tags/domain/tag_model.dart`
- Create: `app/lib/features/tags/data/tags_repository.dart`
- Test: `app/test/features/tags/tags_repository_test.dart`

**Step 1: Créer le test**

```dart
// app/test/features/tags/tags_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ranking/features/tags/domain/tag_model.dart';

void main() {
  group('TagModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 1,
        'name': 'Important',
        'color': '#ef4444',
        'created_at': '2026-01-10T00:00:00.000Z',
      };

      final tag = TagModel.fromJson(json);

      expect(tag.id, 1);
      expect(tag.name, 'Important');
      expect(tag.color, '#ef4444');
    });

    test('colorValue returns correct Color', () {
      final tag = TagModel(id: 1, name: 'Test', color: '#ef4444');

      expect(tag.colorValue.value, 0xFFef4444);
    });
  });
}
```

**Step 2: Run test - expect FAIL**

```bash
cd app && flutter test test/features/tags/tags_repository_test.dart
```

Expected: FAIL - File not found

**Step 3: Créer le dossier et le model**

```bash
mkdir -p app/lib/features/tags/domain app/lib/features/tags/data app/test/features/tags
```

```dart
// app/lib/features/tags/domain/tag_model.dart
import 'dart:ui';

class TagModel {
  final int id;
  final String name;
  final String color;
  final DateTime? createdAt;

  const TagModel({
    required this.id,
    required this.name,
    required this.color,
    this.createdAt,
  });

  Color get colorValue {
    final hex = color.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'] as int,
      name: json['name'] as String,
      color: json['color'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  TagModel copyWith({
    int? id,
    String? name,
    String? color,
    DateTime? createdAt,
  }) {
    return TagModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
```

**Step 4: Run test - expect PASS**

```bash
cd app && flutter test test/features/tags/tags_repository_test.dart
```

Expected: PASS

**Step 5: Créer le repository**

```dart
// app/lib/features/tags/data/tags_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../domain/tag_model.dart';

final tagsRepositoryProvider = Provider<TagsRepository>((ref) {
  return TagsRepository(dio: ref.watch(dioProvider));
});

class TagsRepository {
  final Dio dio;

  TagsRepository({required this.dio});

  Future<List<TagModel>> getTags() async {
    try {
      final response = await dio.get('/tags');
      final data = response.data['data'] as List;
      return data.map((e) => TagModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<TagModel> createTag({
    required String name,
    required String color,
  }) async {
    try {
      final response = await dio.post('/tags', data: {
        'name': name,
        'color': color,
      });
      return TagModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> deleteTag(int id) async {
    try {
      await dio.delete('/tags/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> addTagToKeyword({
    required int tagId,
    required int trackedKeywordId,
  }) async {
    try {
      await dio.post('/tags/add-to-keyword', data: {
        'tag_id': tagId,
        'tracked_keyword_id': trackedKeywordId,
      });
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> removeTagFromKeyword({
    required int tagId,
    required int trackedKeywordId,
  }) async {
    try {
      await dio.post('/tags/remove-from-keyword', data: {
        'tag_id': tagId,
        'tracked_keyword_id': trackedKeywordId,
      });
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
```

**Step 6: Commit**

```bash
cd app && git add lib/features/tags test/features/tags && git commit -m "$(cat <<'EOF'
feat(app): add TagModel and TagsRepository

- TagModel with color parsing
- Repository for CRUD operations
- Add/remove tags from keywords
EOF
)"
```

---

### Task 1.8: Flutter - Tags Provider

**Files:**
- Create: `app/lib/features/tags/providers/tags_provider.dart`

**Step 1: Créer le provider**

```dart
// app/lib/features/tags/providers/tags_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/tags_repository.dart';
import '../domain/tag_model.dart';

final tagsProvider = FutureProvider<List<TagModel>>((ref) async {
  return ref.watch(tagsRepositoryProvider).getTags();
});

class TagsNotifier extends StateNotifier<AsyncValue<List<TagModel>>> {
  final TagsRepository _repository;
  final Ref _ref;

  TagsNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final tags = await _repository.getTags();
      state = AsyncValue.data(tags);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<TagModel> createTag({
    required String name,
    required String color,
  }) async {
    final tag = await _repository.createTag(name: name, color: color);

    final currentTags = state.valueOrNull ?? [];
    state = AsyncValue.data([...currentTags, tag]);

    return tag;
  }

  Future<void> deleteTag(int id) async {
    final currentTags = state.valueOrNull ?? [];

    // Optimistic update
    state = AsyncValue.data(
      currentTags.where((t) => t.id != id).toList(),
    );

    try {
      await _repository.deleteTag(id);
    } catch (e) {
      // Rollback
      state = AsyncValue.data(currentTags);
      rethrow;
    }
  }
}

final tagsNotifierProvider = StateNotifierProvider<TagsNotifier, AsyncValue<List<TagModel>>>((ref) {
  return TagsNotifier(
    ref.watch(tagsRepositoryProvider),
    ref,
  );
});
```

**Step 2: Commit**

```bash
cd app && git add lib/features/tags/providers && git commit -m "$(cat <<'EOF'
feat(app): add TagsNotifier with optimistic updates

- FutureProvider for simple reads
- StateNotifier for create/delete with optimistic UI
EOF
)"
```

---

### Task 1.9: Flutter - TagChip Widget

**Files:**
- Create: `app/lib/features/tags/presentation/widgets/tag_chip.dart`

**Step 1: Créer le widget**

```dart
// app/lib/features/tags/presentation/widgets/tag_chip.dart
import 'package:flutter/material.dart';
import '../../domain/tag_model.dart';

class TagChip extends StatelessWidget {
  final TagModel tag;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TagChip({
    super.key,
    required this.tag,
    this.isSelected = false,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = tag.colorValue;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color.withAlpha(isSelected ? 50 : 20),
            border: Border.all(
              color: isSelected ? color : color.withAlpha(80),
              width: isSelected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tag.name,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
              if (onDelete != null) ...[
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(
                    Icons.close,
                    size: 12,
                    color: color,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

**Step 2: Commit**

```bash
cd app && git add lib/features/tags/presentation && git commit -m "$(cat <<'EOF'
feat(app): add TagChip widget

- Color-coded chip with selection state
- Optional delete button
EOF
)"
```

---

## Feature 2: Bulk Actions

### Task 2.1: API - Bulk Delete Keywords

**Files:**
- Modify: `api/app/Http/Controllers/Api/KeywordController.php`
- Modify: `api/routes/api.php`
- Test: `api/tests/Feature/BulkActionsTest.php`

**Step 1: Créer le fichier de test**

```php
// api/tests/Feature/BulkActionsTest.php
<?php

namespace Tests\Feature;

use App\Models\App;
use App\Models\Keyword;
use App\Models\TrackedKeyword;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class BulkActionsTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_bulk_delete_keywords(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);

        $keywords = Keyword::factory()->count(5)->create();
        $trackedIds = [];

        foreach ($keywords as $keyword) {
            $tracked = TrackedKeyword::create([
                'user_id' => $user->id,
                'app_id' => $app->id,
                'keyword_id' => $keyword->id,
            ]);
            $trackedIds[] = $tracked->id;
        }

        $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/keywords/bulk-delete", [
            'tracked_keyword_ids' => array_slice($trackedIds, 0, 3),
        ]);

        $response->assertOk();
        $response->assertJsonPath('data.deleted_count', 3);
        $this->assertDatabaseCount('tracked_keywords', 2);
    }
}
```

**Step 2: Run test - expect FAIL**

```bash
cd api && php artisan test tests/Feature/BulkActionsTest.php --filter=test_user_can_bulk_delete_keywords
```

Expected: FAIL - Route not found

**Step 3: Ajouter la route**

```php
// api/routes/api.php - Dans le groupe apps/{app}/keywords
Route::post('bulk-delete', [KeywordController::class, 'bulkDelete']);
```

**Step 4: Implémenter bulkDelete**

```php
// api/app/Http/Controllers/Api/KeywordController.php - Ajouter cette méthode
public function bulkDelete(Request $request, App $app): JsonResponse
{
    $validated = $request->validate([
        'tracked_keyword_ids' => 'required|array|min:1',
        'tracked_keyword_ids.*' => 'integer|exists:tracked_keywords,id',
    ]);

    $user = $request->user();

    $deletedCount = TrackedKeyword::whereIn('id', $validated['tracked_keyword_ids'])
        ->where('user_id', $user->id)
        ->where('app_id', $app->id)
        ->delete();

    return response()->json([
        'data' => [
            'deleted_count' => $deletedCount,
        ],
    ]);
}
```

**Step 5: Run test - expect PASS**

```bash
cd api && php artisan test tests/Feature/BulkActionsTest.php --filter=test_user_can_bulk_delete_keywords
```

Expected: PASS

**Step 6: Commit**

```bash
cd api && git add app/Http/Controllers/Api/KeywordController.php routes/api.php tests/Feature/BulkActionsTest.php && git commit -m "$(cat <<'EOF'
feat(api): add bulk delete keywords endpoint

- POST /apps/{app}/keywords/bulk-delete
- Deletes multiple tracked keywords at once
- Returns count of deleted items
EOF
)"
```

---

### Task 2.2: API - Bulk Add Tags

**Files:**
- Modify: `api/app/Http/Controllers/Api/KeywordController.php`
- Modify: `api/routes/api.php`
- Test: `api/tests/Feature/BulkActionsTest.php`

**Step 1: Ajouter le test**

```php
// api/tests/Feature/BulkActionsTest.php - Ajouter cette méthode

use App\Models\Tag;

public function test_user_can_bulk_add_tags_to_keywords(): void
{
    $user = User::factory()->create();
    $app = App::factory()->create();
    $app->users()->attach($user->id);

    $tag = Tag::create(['user_id' => $user->id, 'name' => 'Priority', 'color' => '#ef4444']);

    $keywords = Keyword::factory()->count(3)->create();
    $trackedIds = [];

    foreach ($keywords as $keyword) {
        $tracked = TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
        ]);
        $trackedIds[] = $tracked->id;
    }

    $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/keywords/bulk-add-tags", [
        'tracked_keyword_ids' => $trackedIds,
        'tag_ids' => [$tag->id],
    ]);

    $response->assertOk();
    $response->assertJsonPath('data.updated_count', 3);

    foreach ($trackedIds as $id) {
        $this->assertTrue(TrackedKeyword::find($id)->tags->contains($tag));
    }
}
```

**Step 2: Run test - expect FAIL**

```bash
cd api && php artisan test tests/Feature/BulkActionsTest.php --filter=test_user_can_bulk_add_tags_to_keywords
```

Expected: FAIL - Route not found

**Step 3: Ajouter la route**

```php
// api/routes/api.php - Dans le groupe apps/{app}/keywords
Route::post('bulk-add-tags', [KeywordController::class, 'bulkAddTags']);
```

**Step 4: Implémenter bulkAddTags**

```php
// api/app/Http/Controllers/Api/KeywordController.php - Ajouter cette méthode
public function bulkAddTags(Request $request, App $app): JsonResponse
{
    $validated = $request->validate([
        'tracked_keyword_ids' => 'required|array|min:1',
        'tracked_keyword_ids.*' => 'integer|exists:tracked_keywords,id',
        'tag_ids' => 'required|array|min:1',
        'tag_ids.*' => 'integer|exists:tags,id',
    ]);

    $user = $request->user();

    // Verify all tags belong to user
    $userTagIds = Tag::where('user_id', $user->id)
        ->whereIn('id', $validated['tag_ids'])
        ->pluck('id')
        ->toArray();

    if (count($userTagIds) !== count($validated['tag_ids'])) {
        abort(403, 'Some tags do not belong to you');
    }

    $trackedKeywords = TrackedKeyword::whereIn('id', $validated['tracked_keyword_ids'])
        ->where('user_id', $user->id)
        ->where('app_id', $app->id)
        ->get();

    foreach ($trackedKeywords as $tracked) {
        $tracked->tags()->syncWithoutDetaching($userTagIds);
    }

    return response()->json([
        'data' => [
            'updated_count' => $trackedKeywords->count(),
        ],
    ]);
}
```

N'oublie pas l'import:
```php
use App\Models\Tag;
```

**Step 5: Run test - expect PASS**

```bash
cd api && php artisan test tests/Feature/BulkActionsTest.php --filter=test_user_can_bulk_add_tags_to_keywords
```

Expected: PASS

**Step 6: Commit**

```bash
cd api && git add app/Http/Controllers/Api/KeywordController.php routes/api.php tests/Feature/BulkActionsTest.php && git commit -m "$(cat <<'EOF'
feat(api): add bulk add tags endpoint

- POST /apps/{app}/keywords/bulk-add-tags
- Adds multiple tags to multiple keywords
- Verifies tag ownership
EOF
)"
```

---

### Task 2.3: API - Bulk Toggle Favorite

**Files:**
- Modify: `api/app/Http/Controllers/Api/KeywordController.php`
- Modify: `api/routes/api.php`
- Test: `api/tests/Feature/BulkActionsTest.php`

**Step 1: Ajouter le test**

```php
// api/tests/Feature/BulkActionsTest.php - Ajouter cette méthode

public function test_user_can_bulk_toggle_favorites(): void
{
    $user = User::factory()->create();
    $app = App::factory()->create();
    $app->users()->attach($user->id);

    $keywords = Keyword::factory()->count(3)->create();
    $trackedIds = [];

    foreach ($keywords as $keyword) {
        $tracked = TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'is_favorite' => false,
        ]);
        $trackedIds[] = $tracked->id;
    }

    $response = $this->actingAs($user)->postJson("/api/apps/{$app->id}/keywords/bulk-favorite", [
        'tracked_keyword_ids' => $trackedIds,
        'is_favorite' => true,
    ]);

    $response->assertOk();
    $response->assertJsonPath('data.updated_count', 3);

    foreach ($trackedIds as $id) {
        $this->assertTrue(TrackedKeyword::find($id)->is_favorite);
    }
}
```

**Step 2: Run test - expect FAIL**

```bash
cd api && php artisan test tests/Feature/BulkActionsTest.php --filter=test_user_can_bulk_toggle_favorites
```

Expected: FAIL - Route not found

**Step 3: Ajouter la route**

```php
// api/routes/api.php - Dans le groupe apps/{app}/keywords
Route::post('bulk-favorite', [KeywordController::class, 'bulkFavorite']);
```

**Step 4: Implémenter bulkFavorite**

```php
// api/app/Http/Controllers/Api/KeywordController.php - Ajouter cette méthode
public function bulkFavorite(Request $request, App $app): JsonResponse
{
    $validated = $request->validate([
        'tracked_keyword_ids' => 'required|array|min:1',
        'tracked_keyword_ids.*' => 'integer|exists:tracked_keywords,id',
        'is_favorite' => 'required|boolean',
    ]);

    $user = $request->user();
    $isFavorite = $validated['is_favorite'];

    $updatedCount = TrackedKeyword::whereIn('id', $validated['tracked_keyword_ids'])
        ->where('user_id', $user->id)
        ->where('app_id', $app->id)
        ->update([
            'is_favorite' => $isFavorite,
            'favorited_at' => $isFavorite ? now() : null,
        ]);

    return response()->json([
        'data' => [
            'updated_count' => $updatedCount,
        ],
    ]);
}
```

**Step 5: Run test - expect PASS**

```bash
cd api && php artisan test tests/Feature/BulkActionsTest.php --filter=test_user_can_bulk_toggle_favorites
```

Expected: PASS

**Step 6: Commit**

```bash
cd api && git add app/Http/Controllers/Api/KeywordController.php routes/api.php tests/Feature/BulkActionsTest.php && git commit -m "$(cat <<'EOF'
feat(api): add bulk favorite endpoint

- POST /apps/{app}/keywords/bulk-favorite
- Set favorite status on multiple keywords at once
EOF
)"
```

---

## Feature 3: Export CSV

### Task 3.1: API - Export Rankings CSV

**Files:**
- Create: `api/app/Http/Controllers/Api/ExportController.php`
- Modify: `api/routes/api.php`
- Test: `api/tests/Feature/ExportTest.php`

**Step 1: Créer le fichier de test**

```php
// api/tests/Feature/ExportTest.php
<?php

namespace Tests\Feature;

use App\Models\App;
use App\Models\AppRanking;
use App\Models\Keyword;
use App\Models\TrackedKeyword;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ExportTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_export_rankings_csv(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);

        $keyword = Keyword::factory()->create(['term' => 'test keyword']);
        TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
        ]);

        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'storefront' => 'US',
            'rank' => 5,
            'recorded_at' => now(),
        ]);

        $response = $this->actingAs($user)->getJson("/api/apps/{$app->id}/export/rankings");

        $response->assertOk();
        $response->assertHeader('Content-Type', 'text/csv; charset=UTF-8');
        $response->assertHeader('Content-Disposition');
        $this->assertStringContains('test keyword', $response->content());
    }
}
```

**Step 2: Run test - expect FAIL**

```bash
cd api && php artisan test tests/Feature/ExportTest.php --filter=test_user_can_export_rankings_csv
```

Expected: FAIL - Route not found

**Step 3: Créer ExportController**

```php
// api/app/Http/Controllers/Api/ExportController.php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppRanking;
use App\Models\TrackedKeyword;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\StreamedResponse;

class ExportController extends Controller
{
    public function rankings(Request $request, App $app): StreamedResponse
    {
        $user = $request->user();

        $trackedKeywordIds = TrackedKeyword::where('app_id', $app->id)
            ->where('user_id', $user->id)
            ->pluck('keyword_id');

        $rankings = AppRanking::where('app_id', $app->id)
            ->whereIn('keyword_id', $trackedKeywordIds)
            ->with('keyword')
            ->orderBy('recorded_at', 'desc')
            ->get();

        $filename = "rankings-{$app->name}-" . now()->format('Y-m-d') . '.csv';

        return response()->streamDownload(function () use ($rankings) {
            $handle = fopen('php://output', 'w');

            // Header row
            fputcsv($handle, ['Keyword', 'Storefront', 'Rank', 'Date']);

            // Data rows
            foreach ($rankings as $ranking) {
                fputcsv($handle, [
                    $ranking->keyword->term,
                    $ranking->storefront,
                    $ranking->rank,
                    $ranking->recorded_at->toDateString(),
                ]);
            }

            fclose($handle);
        }, $filename, [
            'Content-Type' => 'text/csv; charset=UTF-8',
        ]);
    }
}
```

**Step 4: Ajouter la route**

```php
// api/routes/api.php - Dans le groupe apps/{app}
Route::get('export/rankings', [ExportController::class, 'rankings']);
```

N'oublie pas l'import:
```php
use App\Http\Controllers\Api\ExportController;
```

**Step 5: Run test - expect PASS**

```bash
cd api && php artisan test tests/Feature/ExportTest.php --filter=test_user_can_export_rankings_csv
```

Expected: PASS

**Step 6: Commit**

```bash
cd api && git add app/Http/Controllers/Api/ExportController.php routes/api.php tests/Feature/ExportTest.php && git commit -m "$(cat <<'EOF'
feat(api): add CSV export for rankings

- GET /apps/{app}/export/rankings
- Streamed download, no file storage needed
- Filters by user's tracked keywords
EOF
)"
```

---

## Suite du plan...

Les features 4-8 suivent le même pattern TDD. Chaque feature est décomposée en:

1. **Tests d'abord** - Écrire les tests qui décrivent le comportement attendu
2. **Voir les tests échouer** - Confirmer que les tests détectent l'absence de code
3. **Implémentation minimale** - Écrire juste assez de code pour passer les tests
4. **Voir les tests passer** - Valider l'implémentation
5. **Commit** - Sauvegarder le travail

### Features restantes (structure identique):

- **Feature 4: Comparaison simple** - Comparer 2-3 apps sur mêmes keywords
- **Feature 5: Recherche & Filtres avancés** - Filtres multi-critères
- **Feature 6: Historique simplifié** - Sélecteur de période
- **Feature 7: Tableau de bord amélioré** - KPIs, movers, milestones
- **Feature 8: Notes & Comments** - Notes sur keywords/insights

---

## Résumé des routes API

```
# Tags
GET    /api/tags
POST   /api/tags
DELETE /api/tags/{id}
POST   /api/tags/add-to-keyword
POST   /api/tags/remove-from-keyword

# Keywords (nouvelles routes)
PATCH  /api/apps/{app}/keywords/{keyword}/favorite
POST   /api/apps/{app}/keywords/bulk-delete
POST   /api/apps/{app}/keywords/bulk-add-tags
POST   /api/apps/{app}/keywords/bulk-favorite

# Export
GET    /api/apps/{app}/export/rankings
```

---

## Commandes utiles

```bash
# Lancer tous les tests API
cd api && php artisan test

# Lancer tests d'une feature
cd api && php artisan test tests/Feature/FavoritesTest.php

# Lancer tests Flutter
cd app && flutter test

# Migrer la base
cd api && php artisan migrate

# Reset et re-migrer
cd api && php artisan migrate:fresh --seed
```
