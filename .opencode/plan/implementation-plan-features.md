# Documentation d'Implémentation - Features Keyrank

> **Date**: Janvier 2026
> **Fonctionnalités**: 8 features simples sans ML/IA
> **Complexité**: Faible à moyenne

---

## Table des matières

1. [Favorites & Tags](#1-favorites--tags)
2. [Bulk Actions](#2-bulk-actions)
3. [Export de données](#3-export-de-données)
4. [Comparaison simple](#4-comparaison-simple)
5. [Recherche & Filtres avancés](#5-recherche--filtres-avancés)
6. [Historique simplifié](#6-historique-simplifié)
7. [Tableau de bord amélioré](#7-tableau-de-bord-amélioré)
8. [Notes & Comments](#8-notes--comments)

---

## 1. Favorites & Tags ⭐

### Vue d'ensemble
Permettre aux utilisateurs de marquer des mots-clés comme favoris et d'ajouter des tags personnalisés pour organiser et filtrer rapidement.

### Implémentation

#### Backend - Database

**Migration 1**: Ajouter `is_favorite` et `favorited_at` à `tracked_keywords`

```php
// database/migrations/2026_01_10_000000_add_favorite_to_tracked_keywords.php
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

**Migration 2**: Créer table `tags`

```php
// database/migrations/2026_01_10_000001_create_tags_table.php
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

**Migration 3**: Créer table pivot `tag_keyword`

```php
// database/migrations/2026_01_10_000002_create_tag_keyword_table.php
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

#### Backend - Models

**Modèle Tag**

```php
// app/Models/Tag.php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Tag extends Model
{
    protected $fillable = [
        'user_id',
        'name',
        'color',
    ];

    protected $casts = [
        'color' => 'string',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function trackedKeywords(): BelongsToMany
    {
        return $this->belongsToMany(TrackedKeyword::class, 'tag_keyword')
            ->withTimestamps();
    }
}
```

**Mise à jour Modèle TrackedKeyword**

```php
// app/Models/TrackedKeyword.php - Mise à jour fillable et casts
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

// Ajouter relation
public function tags(): BelongsToMany
{
    return $this->belongsToMany(Tag::class, 'tag_keyword')
        ->withTimestamps();
}
```

#### Backend - Routes

```php
// routes/api.php - Ajouter dans routes protégées

Route::prefix('tags')->group(function () {
    Route::get('/', [TagsController::class, 'index']);
    Route::post('/', [TagsController::class, 'store']);
    Route::delete('{tag}', [TagsController::class, 'destroy']);
    Route::post('add-to-keyword', [TagsController::class, 'addToKeyword']);
    Route::post('remove-from-keyword', [TagsController::class, 'removeFromKeyword']);
});

Route::prefix('keywords')->group(function () {
    // ... existing routes ...

    Route::post('toggle-favorite', [KeywordController::class, 'toggleFavorite']);
    Route::get('favorites', [KeywordController::class, 'favorites']);
});
```

#### Frontend - UI Components

**TagChip Widget**

```dart
// lib/shared/widgets/tag_chip.dart
import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String name;
  final String color;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showDelete;

  const TagChip({
    super.key,
    required this.name,
    required this.color,
    this.isSelected = false,
    this.onTap,
    this.showDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorValue = Color(int.parse(color.replace('#', '0xFF')));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: colorValue.withAlpha(isSelected ? 50 : 20),
            border: Border.all(
              color: isSelected ? colorValue : colorValue.withAlpha(50),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: colorValue,
                ),
              ),
              if (showDelete) ...[
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: onTap,
                  child: Icon(
                    Icons.close,
                    size: 12,
                    color: colorValue,
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

---

## 2. Bulk Actions ⚡

### Vue d'ensemble
Permettre les actions en masse sur plusieurs mots-clés/apps en même temps.

### Backend - Routes

```php
// routes/api.php - Ajouter

Route::prefix('keywords')->group(function () {
    // ... existing routes ...

    Route::post('bulk-delete', [KeywordController::class, 'bulkDelete']);
    Route::post('bulk-refresh', [KeywordController::class, 'bulkRefresh']);
    Route::post('bulk-add-tags', [KeywordController::class, 'bulkAddTags']);
});
```

---

## 3. Export de données 📊

### Vue d'ensemble
Permettre d'exporter les données de rankings, keywords et insights en CSV, PDF et Excel.

### Backend - Dependencies

```bash
cd api
composer require maatwebsite/excel spatie/browsershot
npm install puppeteer
```

### Backend - Controller

```php
// app/Http/Controllers/Api/ExportController.php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ExportController extends Controller
{
    /**
     * Export rankings
     */
    public function rankings(Request $request, App $app): JsonResponse
    {
        $validated = $request->validate([
            'format' => 'required|in:csv,xlsx,pdf',
            'keyword_ids' => 'nullable|array',
            'keyword_ids.*' => 'integer',
        ]);

        $format = $validated['format'];
        $keywordIds = $validated['keyword_ids'] ?? null;

        $filename = match($format) {
            'csv' => $this->exportService->exportRankingsCsv($app->id, $keywordIds),
            'xlsx' => $this->exportService->exportRankingsExcel($app->id, $keywordIds),
            'pdf' => $this->exportService->exportRankingsPdf($app->id, $keywordIds),
        };

        return response()->json([
            'data' => [
                'filename' => $filename,
                'url' => Storage::url("exports/$filename"),
                'size' => Storage::size("exports/$filename"),
            ],
        ]);
    }
}
```

---

## 4. Comparaison simple 📈

### Vue d'ensemble
Comparer facilement 2-3 apps sur les mêmes mots-clés avec un graphique côte à côte.

### Backend - Routes

```php
// routes/api.php - Ajouter

Route::get('comparison/compare', [ComparisonController::class, 'compare']);
```

---

## 5. Recherche & Filtres avancés 🔍

### Vue d'ensemble
Permettre de rechercher par plusieurs critères et de filtrer par range de ranking, trend, etc.

### Backend - Routes

```php
// routes/api.php - Ajouter

Route::get('keywords/tracked/search', [KeywordController::class, 'searchTracked']);
```

---

## 6. Historique simplifié 📅

### Vue d'ensemble
Vue calendrier et slider de période pour naviguer facilement dans l'historique.

### Frontend - Component

```dart
// lib/shared/widgets/history_period_selector.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';

class HistoryPeriodSelector extends StatelessWidget {
  final DateTimeRange? selectedRange;
  final Function(DateTimeRange?) onPeriodSelected;

  const HistoryPeriodSelector({
    super.key,
    required this.selectedRange,
    required this.onPeriodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(50),
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Period',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _PeriodButton(
                label: '7 days',
                onTap: () => onPeriodSelected(
                  DateTimeRange(
                    start: DateTime.now().subtract(const Duration(days: 7)),
                    end: DateTime.now(),
                  ),
                ),
              ),
              _PeriodButton(
                label: '30 days',
                onTap: () => onPeriodSelected(
                  DateTimeRange(
                    start: DateTime.now().subtract(const Duration(days: 30)),
                    end: DateTime.now(),
                  ),
                ),
              ),
              _PeriodButton(
                label: '90 days',
                onTap: () => onPeriodSelected(
                  DateTimeRange(
                    start: DateTime.now().subtract(const Duration(days: 90)),
                    end: DateTime.now(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgActive,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.glassBorder),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 7. Tableau de bord amélioré 🎛️

### Vue d'ensemble
KPIs principaux, movers, quick actions et widget "À surveiller".

### Backend - Routes

```php
// routes/api.php - Ajouter

Route::prefix('dashboard')->group(function () {
    Route::get('movers', [DashboardController::class, 'movers']);
    Route::get('near-milestones', [DashboardController::class, 'nearMilestones']);
});
```

---

## 8. Notes & Comments 📝

### Vue d'ensemble
Ajouter des notes sur les keywords et comments sur les insights.

### Backend - Database

**Migration**: Créer table `notes`

```php
// database/migrations/2026_01_10_000003_create_notes_table.php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('notes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('tracked_keyword_id')->nullable()->constrained('tracked_keywords')->cascadeOnDelete();
            $table->foreignId('app_insight_id')->nullable()->constrained('app_insights')->cascadeOnDelete();
            $table->text('content');
            $table->timestamps();

            $table->index('user_id');
            $table->index('tracked_keyword_id');
            $table->index('app_insight_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('notes');
    }
};
```

### Backend - Routes

```php
// routes/api.php - Ajouter

Route::prefix('notes')->group(function () {
    Route::get('keyword', [NotesController::class, 'forKeyword']);
    Route::get('insight', [NotesController::class, 'forInsight']);
    Route::post('/', [NotesController::class, 'store']);
    Route::put('{note}', [NotesController::class, 'update']);
    Route::delete('{note}', [NotesController::class, 'destroy']);
});
```

---

## Résumé de l'implémentation

### Ordre recommandé

1. **Favorites & Tags** (2-3 jours)
2. **Bulk Actions** (1-2 jours)
3. **Recherche & Filtres avancés** (2-3 jours)
4. **Tableau de bord amélioré** (2-3 jours)
5. **Historique simplifié** (1-2 jours)
6. **Comparaison simple** (2-3 jours)
7. **Notes & Comments** (2-3 jours)
8. **Export de données** (2-3 jours)

### Temps total estimé: 14-22 jours

### Nouvelles dépendances

**Backend:**
```bash
composer require maatwebsite/excel spatie/browsershot
npm install puppeteer
```

---

Cette documentation couvre l'implémentation complète des 8 fonctionnalités simples pour Keyrank.
