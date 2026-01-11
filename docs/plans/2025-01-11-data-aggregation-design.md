# Data Aggregation Design

## Objectif

Remplacer la suppression brute des données > 90 jours par un système d'agrégation qui conserve l'historique long terme tout en réduisant le volume de stockage.

## Rétention

| Période | Granularité | Durée |
|---------|-------------|-------|
| 0 - 90 jours | Journalier | 90 jours |
| 90 jours - 1 an | Hebdomadaire | ~9 mois |
| > 1 an | Mensuel | Illimité |

## Métriques agrégées

Chaque agrégat stocke :
- `avg_position` / `avg_popularity` : moyenne de la période
- `min_position` / `min_popularity` : meilleure valeur
- `max_position` / `max_popularity` : pire valeur
- `data_points` : nombre de jours avec données (fiabilité de la moyenne)

## Nouvelles tables

```sql
CREATE TABLE app_ranking_aggregates (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    app_id BIGINT UNSIGNED NOT NULL,
    keyword_id BIGINT UNSIGNED NOT NULL,
    period_type ENUM('weekly', 'monthly') NOT NULL,
    period_start DATE NOT NULL,
    avg_position DECIMAL(5,2) NOT NULL,
    min_position INT UNSIGNED NOT NULL,
    max_position INT UNSIGNED NOT NULL,
    data_points TINYINT UNSIGNED NOT NULL,

    UNIQUE KEY unique_aggregate (app_id, keyword_id, period_type, period_start),
    KEY idx_period (period_type, period_start),

    FOREIGN KEY (app_id) REFERENCES apps(id) ON DELETE CASCADE,
    FOREIGN KEY (keyword_id) REFERENCES keywords(id) ON DELETE CASCADE
);

CREATE TABLE keyword_popularity_aggregates (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    keyword_id BIGINT UNSIGNED NOT NULL,
    period_type ENUM('weekly', 'monthly') NOT NULL,
    period_start DATE NOT NULL,
    avg_popularity DECIMAL(5,2) NOT NULL,
    min_popularity INT UNSIGNED NOT NULL,
    max_popularity INT UNSIGNED NOT NULL,
    data_points TINYINT UNSIGNED NOT NULL,

    UNIQUE KEY unique_aggregate (keyword_id, period_type, period_start),
    KEY idx_period (period_type, period_start),

    FOREIGN KEY (keyword_id) REFERENCES keywords(id) ON DELETE CASCADE
);
```

## Logique d'agrégation

Exécutée dans `aso:cleanup`, dans cet ordre :

### 1. Hebdo → Mensuel (données > 1 an)

```php
// Récupérer les weekly aggregates > 1 an
$cutoffMonthly = now()->subYear();

// Pour chaque app/keyword, grouper par mois
// Calculer avg pondérée par data_points, min des min, max des max
// Insérer avec period_type = 'monthly'
// Supprimer les weekly source
```

### 2. Daily → Hebdo (données > 90 jours)

```php
$cutoffWeekly = now()->subDays(90);

// Pour chaque app/keyword, grouper par semaine ISO
// Calculer avg, min, max, count
// Insérer avec period_type = 'weekly'
// Supprimer les daily source
```

## API unifiée

```
GET /api/apps/{id}/keywords/{keyword_id}/history?from=...&to=...
```

Réponse combinant les trois sources :

```json
{
  "data": [
    {"date": "2025-01-11", "position": 5, "type": "daily"},
    {"period_start": "2024-10-07", "avg": 8.2, "min": 5, "max": 12, "type": "weekly"},
    {"period_start": "2024-01-01", "avg": 15.3, "min": 8, "max": 25, "type": "monthly"}
  ]
}
```

## Fichiers impactés

### Nouveaux fichiers
- `database/migrations/xxxx_create_aggregate_tables.php`
- `app/Models/AppRankingAggregate.php`
- `app/Models/KeywordPopularityAggregate.php`
- `app/Console/Commands/MigrateToAggregates.php` (one-shot pour données existantes)

### Fichiers modifiés
- `app/Console/Commands/CleanupHistory.php` - Ajouter logique d'agrégation
- `app/Http/Controllers/RankingController.php` - Query unifié

## Scheduling

Inchangé :
```php
Schedule::command('aso:cleanup --days=90')
    ->weeklyOn(1, '05:00');
```

## Migration des données existantes

Avant de déployer le nouveau cleanup :
```bash
php artisan aso:migrate-to-aggregates
```

Cette commande traite l'historique existant > 90 jours en appliquant la même logique d'agrégation.
