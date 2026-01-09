# Keyword Discovery Service - Design Document

## Overview

Service de découverte de mots-clés pour l'ASO (App Store Optimization). Génère des suggestions de keywords à tracker pour une app donnée, basées sur ses métadonnées et celles de ses concurrents.

## Décisions

| Aspect | Choix |
|--------|-------|
| Use case | Suggestions de keywords à tracker pour n'importe quelle app |
| Sources | Métadonnées app + concurrents (top catégorie) |
| Métriques | Complet (position, compétition, difficulté, tendance) |
| Concurrents | Auto (top catégorie) + ajout manuel |
| Difficulté | Pondéré (nb résultats + force top 10) |

## Architecture

### Nouveau service : `KeywordDiscoveryService`

```php
class KeywordDiscoveryService
{
    // Génère les suggestions pour une app
    public function getSuggestionsForApp(App $app, string $country): array;

    // Appelle l'endpoint iTunes hints
    public function getSearchHints(string $term, string $country): array;

    // Calcule les métriques d'un keyword
    public function getKeywordMetrics(string $keyword, string $appId, string $country): array;

    // Score de difficulté 0-100
    public function calculateDifficulty(array $searchResults): int;

    // Top apps de la même catégorie
    public function getCompetitors(App $app, string $country, int $limit = 10): array;
}
```

**Dépendances :**
- `iTunesService` (existant)

### Endpoint iTunes Hints (non-documenté)

```
GET https://search.itunes.apple.com/WebObjects/MZSearchHints.woa/wa/hints
  ?clientApplication=Software
  &term={search_term}

Headers:
  X-Apple-Store-Front: {store_id}-1,29
```

Store IDs : US=143441, FR=143442, GB=143444, etc.

## Flow de génération

```
GET /api/apps/{app}/keywords/suggestions?country=us

1. Extraire termes seeds de l'app
   - Nom: "Photo Editor Pro" → ["photo", "editor", "pro"]
   - Description: mots significatifs (premiers 500 chars)
   - Catégorie: "Photography"

2. Récupérer concurrents (top 10 catégorie)
   - Extraire leurs termes seeds aussi

3. Appeler iTunes hints pour chaque seed (max 10)
   - Paralléliser avec Http::pool
   - Dédupliquer les résultats
   - Cache 24h

4. Enrichir chaque keyword avec métriques
   - Position actuelle de l'app
   - Nombre de résultats (compétition)
   - Difficulté calculée

5. Retourner suggestions triées
   - Par source (app > concurrent)
   - Par opportunité
```

## Format de réponse API

```json
{
  "data": [
    {
      "keyword": "photo editor",
      "source": "app_name",
      "metrics": {
        "position": 45,
        "competition": 1850,
        "difficulty": 72,
        "difficulty_label": "hard"
      },
      "top_competitors": [
        {"name": "Lightroom", "position": 1, "rating": 4.8},
        {"name": "VSCO", "position": 2, "rating": 4.7}
      ]
    }
  ],
  "meta": {
    "app_id": "1234567890",
    "country": "US",
    "total": 47,
    "sources": {
      "app_metadata": 12,
      "competitors": 35
    },
    "generated_at": "2025-01-09T15:30:00Z"
  }
}
```

### Labels de difficulté

| Score | Label | Couleur |
|-------|-------|---------|
| 0-25 | easy | vert |
| 26-50 | medium | jaune |
| 51-75 | hard | orange |
| 76-100 | very_hard | rouge |

## Calcul de difficulté

```php
function calculateDifficulty(array $results): int
{
    $resultCount = count($results);
    $top10 = array_slice($results, 0, 10);

    // Score basé sur le nombre de résultats (0-40)
    $resultScore = min(40, $resultCount / 5);

    // Score basé sur la force du top 10 (0-60)
    $strengthScore = 0;
    foreach ($top10 as $app) {
        $rating = $app['rating'] ?? 0;
        $reviews = $app['rating_count'] ?? 0;
        $strengthScore += $rating * log10(max(1, $reviews));
    }
    $strengthScore = min(60, $strengthScore / 10 * 6);

    return (int) round($resultScore + $strengthScore);
}
```

## Cache

| Donnée | Durée | Clé |
|--------|-------|-----|
| iTunes hints | 24h | `hints_{term}_{country}` |
| Détails app | 24h | Via iTunesService |
| Résultats recherche | 1h | Via iTunesService |
| Suggestions complètes | 12h | `suggestions_{appId}_{country}` |

## Fichiers à créer/modifier

### Backend (Laravel)

1. **Créer** `app/Services/KeywordDiscoveryService.php`
2. **Modifier** `app/Http/Controllers/Api/KeywordController.php`
   - Remplacer `AppleSearchAdsService` par `KeywordDiscoveryService`
   - Mettre à jour la méthode `suggestions()`
3. **Supprimer** `app/Services/AppleSearchAdsService.php` (inutilisé)

### Constantes Store IDs

```php
private const STORE_IDS = [
    'US' => '143441',
    'FR' => '143442',
    'GB' => '143444',
    'DE' => '143443',
    'JP' => '143462',
    'CN' => '143465',
    'AU' => '143460',
    'CA' => '143455',
    // ... autres pays
];
```

## Performance

- Temps estimé : 3-5 secondes
- Parallélisation des appels hints via `Http::pool`
- Rate limiting iTunes : ~100ms entre appels
- Option `?detailed=false` pour skip les métriques (réponse rapide)

## V2 (Future)

- Suggestions basées sur keywords déjà trackés
- Détection automatique des concurrents par keywords communs
- Tendances historiques de difficulté
- Export CSV des suggestions
