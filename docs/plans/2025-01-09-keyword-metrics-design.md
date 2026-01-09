# Keyword Metrics: Difficulty & Top Competitors

## Objectif

Ajouter les métriques de difficulté et les top concurrents aux keywords trackés, comme dans les suggestions existantes.

## Changements

### 1. Base de données

Migration pour `tracked_keywords` :

```php
$table->unsignedTinyInteger('difficulty')->nullable();
$table->string('difficulty_label', 20)->nullable();
$table->unsignedSmallInteger('competition')->nullable();
$table->json('top_competitors')->nullable();
```

Format `top_competitors` :
```json
[
  {"name": "App Name", "position": 1, "icon_url": "https://..."},
  {"name": "App Name 2", "position": 2, "icon_url": "https://..."},
  {"name": "App Name 3", "position": 3, "icon_url": "https://..."}
]
```

### 2. Backend (Ranking Check)

Modifier le job de ranking check pour :
1. Réutiliser `KeywordDiscoveryService::calculateDifficulty()` sur les résultats de recherche
2. Extraire les top 3 competitors (name, position, icon_url)
3. Sauvegarder dans `tracked_keywords`

### 3. API Response

Ajouter au endpoint keywords :
```json
{
  "difficulty": 48,
  "difficulty_label": "medium",
  "competition": 200,
  "top_competitors": [...]
}
```

### 4. Flutter

**Modèle `Keyword`** : Ajouter les champs
- `difficulty: int?`
- `difficultyLabel: String?`
- `competition: int?`
- `topCompetitors: List<TopCompetitor>?`

**UI** : Ajouter 2 colonnes dans la liste
- **Difficulty** : Badge coloré avec score
  - 0-25 : vert (easy)
  - 26-50 : jaune (medium)
  - 51-75 : orange (hard)
  - 76-100 : rouge (very_hard)
- **Apps in Ranking** : 3 icônes rondes des top concurrents

## Fichiers impactés

### API
- `database/migrations/xxxx_add_metrics_to_tracked_keywords.php` (nouveau)
- `app/Models/TrackedKeyword.php`
- `app/Jobs/RankingCheckJob.php` (ou équivalent)
- `app/Http/Controllers/Api/KeywordController.php`

### Flutter
- `lib/features/keywords/domain/keyword_model.dart`
- `lib/features/keywords/presentation/keywords_list_screen.dart` (ou équivalent)
