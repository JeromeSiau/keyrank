# Keyword Metrics Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Ajouter les métriques difficulty et top_competitors aux keywords trackés, mises à jour avec le ranking sync.

**Architecture:** Stocker difficulty, difficulty_label, competition et top_competitors (JSON) directement dans la table tracked_keywords. Calculer ces métriques dans SyncRankings.php en réutilisant la logique existante de KeywordDiscoveryService.

**Tech Stack:** Laravel (PHP), Flutter/Dart, Riverpod

---

## Task 1: Migration - Ajouter les colonnes métriques

**Files:**
- Create: `api/database/migrations/2026_01_10_000001_add_metrics_to_tracked_keywords.php`

**Step 1: Créer la migration**

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
            $table->unsignedTinyInteger('difficulty')->nullable()->after('favorited_at');
            $table->string('difficulty_label', 20)->nullable()->after('difficulty');
            $table->unsignedSmallInteger('competition')->nullable()->after('difficulty_label');
            $table->json('top_competitors')->nullable()->after('competition');
        });
    }

    public function down(): void
    {
        Schema::table('tracked_keywords', function (Blueprint $table) {
            $table->dropColumn(['difficulty', 'difficulty_label', 'competition', 'top_competitors']);
        });
    }
};
```

**Step 2: Lancer la migration**

```bash
cd api && php artisan migrate
```

Expected: Migration successful

**Step 3: Commit**

```bash
git add api/database/migrations/
git commit -m "feat(api): add metrics columns to tracked_keywords table"
```

---

## Task 2: Model TrackedKeyword - Ajouter les casts

**Files:**
- Modify: `api/app/Models/TrackedKeyword.php`

**Step 1: Ajouter les colonnes au fillable et casts**

Dans `TrackedKeyword.php`, modifier :

```php
protected $fillable = [
    'user_id',
    'app_id',
    'keyword_id',
    'is_favorite',
    'favorited_at',
    'created_at',
    'difficulty',
    'difficulty_label',
    'competition',
    'top_competitors',
];

protected $casts = [
    'is_favorite' => 'boolean',
    'favorited_at' => 'datetime',
    'created_at' => 'datetime',
    'difficulty' => 'integer',
    'competition' => 'integer',
    'top_competitors' => 'array',
];
```

**Step 2: Commit**

```bash
git add api/app/Models/TrackedKeyword.php
git commit -m "feat(api): add metrics fields to TrackedKeyword model"
```

---

## Task 3: SyncRankings - Calculer et stocker les métriques

**Files:**
- Modify: `api/app/Console/Commands/SyncRankings.php`

**Step 1: Injecter KeywordDiscoveryService**

Ajouter dans le constructeur :

```php
public function __construct(
    private iTunesService $iTunesService,
    private GooglePlayService $googlePlayService,
    private KeywordDiscoveryService $keywordDiscoveryService
) {
    parent::__construct();
}
```

Et ajouter l'import :
```php
use App\Services\KeywordDiscoveryService;
```

**Step 2: Modifier la boucle pour calculer les métriques**

Remplacer le bloc try/catch dans handle() :

```php
try {
    $country = strtolower($item->keyword->storefront);
    $platform = $item->app->platform;

    // Get search results (we need them for both position and metrics)
    $service = $platform === 'ios' ? $this->iTunesService : $this->googlePlayService;
    $searchResults = $service->searchApps($item->keyword->keyword, $country, 50);

    // Find position
    $position = null;
    $appStoreId = $item->app->store_id;
    $idField = $platform === 'ios' ? 'apple_id' : 'google_play_id';

    foreach ($searchResults as $result) {
        if (($result[$idField] ?? null) === $appStoreId) {
            $position = $result['position'];
            break;
        }
    }

    // Calculate difficulty
    $difficulty = $this->keywordDiscoveryService->calculateDifficulty($searchResults);

    // Get top 3 competitors
    $topCompetitors = array_slice(array_map(fn($r) => [
        'name' => $r['name'],
        'position' => $r['position'],
        'icon_url' => $r['icon_url'] ?? null,
    ], $searchResults), 0, 3);

    // Save ranking
    AppRanking::updateOrCreate(
        [
            'app_id' => $item->app_id,
            'keyword_id' => $item->keyword_id,
            'recorded_at' => today(),
        ],
        ['position' => $position]
    );

    // Update tracked_keywords metrics for all users tracking this keyword/app pair
    TrackedKeyword::where('app_id', $item->app_id)
        ->where('keyword_id', $item->keyword_id)
        ->update([
            'difficulty' => $difficulty['score'],
            'difficulty_label' => $difficulty['label'],
            'competition' => count($searchResults),
            'top_competitors' => $topCompetitors,
        ]);

    $synced++;
} catch (\Exception $e) {
    $this->error("\nError syncing {$platform} {$item->keyword->keyword}: {$e->getMessage()}");
    $errors++;
}
```

**Step 3: Tester la commande**

```bash
cd api && php artisan aso:sync-rankings --app=1
```

Expected: Rankings synced with metrics updated

**Step 4: Commit**

```bash
git add api/app/Console/Commands/SyncRankings.php
git commit -m "feat(api): calculate and store keyword metrics during ranking sync"
```

---

## Task 4: API - Retourner les métriques

**Files:**
- Modify: `api/app/Http/Controllers/Api/KeywordController.php`

**Step 1: Modifier forApp() pour inclure les métriques**

Dans la méthode `forApp()`, modifier le return du map (ligne ~106-125) :

```php
$result = $trackedKeywords->map(function ($tracked) use ($rankingsByKeyword) {
    $keyword = $tracked->keyword;
    $entries = $rankingsByKeyword[$keyword->id] ?? [];
    $latest = $entries[0] ?? null;
    $previous = $entries[1] ?? null;
    $change = $latest && $previous && $latest->position && $previous->position
        ? $previous->position - $latest->position
        : null;

    return [
        'id' => $keyword->id,
        'tracked_keyword_id' => $tracked->id,
        'keyword' => $keyword->keyword,
        'storefront' => $keyword->storefront,
        'popularity' => $keyword->popularity,
        'tracked_since' => $tracked->created_at,
        'position' => $latest?->position,
        'change' => $change,
        'last_updated' => $latest?->recorded_at,
        'is_favorite' => $tracked->is_favorite,
        'favorited_at' => $tracked->favorited_at?->toISOString(),
        'tags' => $tracked->tags->map(fn($tag) => [
            'id' => $tag->id,
            'name' => $tag->name,
            'color' => $tag->color,
        ]),
        'note' => $tracked->note?->content,
        // New metrics
        'difficulty' => $tracked->difficulty,
        'difficulty_label' => $tracked->difficulty_label,
        'competition' => $tracked->competition,
        'top_competitors' => $tracked->top_competitors,
    ];
});
```

**Step 2: Tester l'API**

```bash
curl -H "Authorization: Bearer TOKEN" http://localhost:8000/api/apps/1/keywords | jq
```

Expected: Response includes difficulty, difficulty_label, competition, top_competitors

**Step 3: Commit**

```bash
git add api/app/Http/Controllers/Api/KeywordController.php
git commit -m "feat(api): return keyword metrics in API response"
```

---

## Task 5: Flutter Model - Ajouter les champs

**Files:**
- Modify: `app/lib/features/keywords/domain/keyword_model.dart`

**Step 1: Ajouter TopCompetitor class** (si pas déjà utilisée pour tracked keywords)

La classe `TopCompetitor` existe déjà pour les suggestions. On la réutilise.

**Step 2: Ajouter les champs à Keyword**

```dart
class Keyword {
  final int id;
  final int? trackedKeywordId;
  final String keyword;
  final String storefront;
  final int? popularity;
  final int? position;
  final int? change;
  final DateTime? lastUpdated;
  final DateTime? trackedSince;
  final bool isFavorite;
  final DateTime? favoritedAt;
  final List<TagModel> tags;
  final String? note;
  // New metrics
  final int? difficulty;
  final String? difficultyLabel;
  final int? competition;
  final List<TopCompetitor>? topCompetitors;

  Keyword({
    required this.id,
    this.trackedKeywordId,
    required this.keyword,
    required this.storefront,
    this.popularity,
    this.position,
    this.change,
    this.lastUpdated,
    this.trackedSince,
    this.isFavorite = false,
    this.favoritedAt,
    this.tags = const [],
    this.note,
    this.difficulty,
    this.difficultyLabel,
    this.competition,
    this.topCompetitors,
  });

  factory Keyword.fromJson(Map<String, dynamic> json) {
    return Keyword(
      id: json['id'] as int,
      trackedKeywordId: json['tracked_keyword_id'] as int?,
      keyword: json['keyword'] as String,
      storefront: json['storefront'] as String,
      popularity: json['popularity'] as int?,
      position: json['position'] as int?,
      change: json['change'] as int?,
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'] as String)
          : null,
      trackedSince: json['tracked_since'] != null
          ? DateTime.parse(json['tracked_since'] as String)
          : null,
      isFavorite: json['is_favorite'] as bool? ?? false,
      favoritedAt: json['favorited_at'] != null
          ? DateTime.parse(json['favorited_at'] as String)
          : null,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => TagModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      note: json['note'] as String?,
      difficulty: json['difficulty'] as int?,
      difficultyLabel: json['difficulty_label'] as String?,
      competition: json['competition'] as int?,
      topCompetitors: (json['top_competitors'] as List<dynamic>?)
          ?.map((e) => TopCompetitor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Keyword copyWith({
    int? id,
    int? trackedKeywordId,
    String? keyword,
    String? storefront,
    int? popularity,
    int? position,
    int? change,
    DateTime? lastUpdated,
    DateTime? trackedSince,
    bool? isFavorite,
    DateTime? favoritedAt,
    List<TagModel>? tags,
    String? note,
    int? difficulty,
    String? difficultyLabel,
    int? competition,
    List<TopCompetitor>? topCompetitors,
  }) {
    return Keyword(
      id: id ?? this.id,
      trackedKeywordId: trackedKeywordId ?? this.trackedKeywordId,
      keyword: keyword ?? this.keyword,
      storefront: storefront ?? this.storefront,
      popularity: popularity ?? this.popularity,
      position: position ?? this.position,
      change: change ?? this.change,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      trackedSince: trackedSince ?? this.trackedSince,
      isFavorite: isFavorite ?? this.isFavorite,
      favoritedAt: favoritedAt ?? this.favoritedAt,
      tags: tags ?? this.tags,
      note: note ?? this.note,
      difficulty: difficulty ?? this.difficulty,
      difficultyLabel: difficultyLabel ?? this.difficultyLabel,
      competition: competition ?? this.competition,
      topCompetitors: topCompetitors ?? this.topCompetitors,
    );
  }

  // Existing getters...
  bool get isRanked => position != null;
  bool get hasImproved => change != null && change! > 0;
  bool get hasDeclined => change != null && change! < 0;
}
```

**Step 3: Commit**

```bash
git add app/lib/features/keywords/domain/keyword_model.dart
git commit -m "feat(app): add metrics fields to Keyword model"
```

---

## Task 6: Flutter UI - Ajouter les colonnes Difficulty et Apps in Ranking

**Files:**
- Modify: `app/lib/features/apps/presentation/app_detail_screen.dart`

**Step 1: Ajouter les headers de colonnes dans _KeywordsTableState**

Chercher le Row avec les headers (autour de la ligne 1240-1296) et ajouter après KEYWORD :

```dart
const SizedBox(
  width: 70,
  child: Text(
    'DIFFICULTY',
    style: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: AppColors.textMuted,
    ),
    textAlign: TextAlign.center,
  ),
),
const SizedBox(width: 8),
const SizedBox(
  width: 100,
  child: Text(
    'TOP APPS',
    style: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: AppColors.textMuted,
    ),
  ),
),
const SizedBox(width: 8),
```

**Step 2: Ajouter les colonnes dans _KeywordRow**

Dans le build() de _KeywordRowState (après la colonne Position, avant Tags), ajouter :

```dart
// Difficulty badge
SizedBox(
  width: 70,
  child: keyword.difficulty != null
      ? _DifficultyBadge(
          score: keyword.difficulty!,
          label: keyword.difficultyLabel ?? 'easy',
        )
      : const Text('--', style: TextStyle(color: AppColors.textMuted), textAlign: TextAlign.center),
),
const SizedBox(width: 8),
// Top competitors
SizedBox(
  width: 100,
  child: keyword.topCompetitors != null && keyword.topCompetitors!.isNotEmpty
      ? _TopCompetitorsRow(competitors: keyword.topCompetitors!)
      : const Text('--', style: TextStyle(color: AppColors.textMuted)),
),
const SizedBox(width: 8),
```

**Step 3: Créer le widget _DifficultyBadge**

Ajouter à la fin du fichier :

```dart
class _DifficultyBadge extends StatelessWidget {
  final int score;
  final String label;

  const _DifficultyBadge({required this.score, required this.label});

  Color get _color {
    if (score <= 25) return AppColors.green;
    if (score <= 50) return AppColors.yellow;
    if (score <= 75) return AppColors.orange;
    return AppColors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withAlpha(25),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$score',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
```

**Step 4: Créer le widget _TopCompetitorsRow**

```dart
class _TopCompetitorsRow extends StatelessWidget {
  final List<TopCompetitor> competitors;

  const _TopCompetitorsRow({required this.competitors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...competitors.take(3).map((c) => Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Tooltip(
            message: '${c.name} (#${c.position})',
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.bgActive,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: c.iconUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        c.iconUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(Icons.apps, size: 14, color: AppColors.textMuted),
                      ),
                    )
                  : const Icon(Icons.apps, size: 14, color: AppColors.textMuted),
            ),
          ),
        )),
      ],
    );
  }
}
```

**Step 5: Ajouter l'import pour TopCompetitor**

En haut du fichier, ajouter :
```dart
import '../../keywords/domain/keyword_model.dart' show TopCompetitor;
```

**Step 6: Ajouter AppColors.orange si manquant**

Vérifier dans `app/lib/core/theme/app_colors.dart` si `orange` existe, sinon ajouter :
```dart
static const Color orange = Color(0xFFF97316);
```

**Step 7: Tester l'app**

```bash
cd app && flutter run -d macos
```

Expected: Keywords list shows Difficulty badge and Top Apps icons

**Step 8: Commit**

```bash
git add app/lib/features/apps/presentation/app_detail_screen.dart app/lib/core/theme/app_colors.dart
git commit -m "feat(app): add Difficulty and Top Apps columns to keywords list"
```

---

## Task 7: Test end-to-end et commit final

**Step 1: Lancer le sync pour peupler les données**

```bash
cd api && php artisan aso:sync-rankings
```

**Step 2: Vérifier dans l'app**

Ouvrir l'app, aller sur un app detail, vérifier que les colonnes Difficulty et Top Apps sont bien affichées.

**Step 3: Commit final**

```bash
git add -A
git commit -m "feat: keyword metrics (difficulty + top competitors) - complete"
```
