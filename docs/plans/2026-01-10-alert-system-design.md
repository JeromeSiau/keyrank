# Système d'alertes — Design

## Vue d'ensemble

Système d'alertes configurable permettant aux utilisateurs de recevoir des notifications push (Firebase FCM) sur les changements de positions, ratings, avis et mouvements concurrentiels.

## Architecture

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  Jobs existants │────▶│  AlertEvaluator  │────▶│  Notification   │
│  (DailyRefresh) │     │    Service       │     │    Service      │
└─────────────────┘     └──────────────────┘     └─────────────────┘
                               │                        │
                               ▼                        ▼
                        ┌──────────────┐         ┌──────────────┐
                        │ alert_rules  │         │ notifications│
                        │    table     │         │    table     │
                        └──────────────┘         └──────────────┘
                                                        │
                                                        ▼
                                                 ┌──────────────┐
                                                 │   Firebase   │
                                                 │     FCM      │
                                                 └──────────────┘
```

### Composants

- **AlertEvaluatorService** — évalue les règles après chaque sync job
- **NotificationService** — agrège les alertes, respecte les heures calmes, envoie via FCM
- **Firebase Cloud Messaging** — push notifications gratuites (iOS + Android)

### Intégration

Chaque job existant (SyncRankingsJob, RefreshTopAppsJob, RefreshUserAppsJob) appelle `AlertEvaluatorService::evaluate()` à la fin de son exécution.

## Types d'alertes

| # | Type | Description |
|---|------|-------------|
| 1 | `position_change` | Changement de position sur mes apps (mots-clés) |
| 2 | `rating_change` | Changement de note moyenne |
| 3 | `review_spike` | Pic d'avis négatifs |
| 4 | `review_keyword` | Nouvel avis contenant un mot-clé spécifique |
| 5 | `new_competitor` | Nouvelle app dans le top 100 d'une catégorie |
| 6 | `competitor_passed` | Un concurrent vient de me dépasser |
| 7 | `mass_movement` | Mouvement de masse dans le top X |
| 8 | `keyword_popularity` | Changement de popularité d'un mot-clé |
| 9 | `opportunity` | Position haute sur un mot-clé populaire |

## Conditions supportées

### Position
- **Absolue** : `position < 10`, `position entre 20 et 50`
- **Relative** : `gagné ≥5 places`, `perdu ≥10 places`
- **Tendance** : `en hausse depuis 3 jours`, `chute de 20 places sur 7 jours`
- **Historique** : `meilleure position jamais atteinte`, `retour au niveau d'il y a 30 jours`

### Exemples JSON
```json
// Changement de position
{"direction": "down", "threshold": 10, "period_days": 1}
{"entered_top": 10}
{"exited_top": 50}
{"best_ever": true}

// Tendance sur période
{"trend": "down", "days": 7, "total_change": 20}

// Rating
{"direction": "down", "threshold": 0.2}

// Avis
{"max_rating": 2, "count": 5, "period_hours": 24}
{"keywords": ["bug", "crash", "lent"]}
```

## Scope des règles (héritage)

```
Spécifique (app + keyword) → App/Catégorie → Global → Template système
```

| Scope | Description |
|-------|-------------|
| `global` | S'applique à toutes les apps/données de l'utilisateur |
| `app` | S'applique à une app spécifique |
| `category` | S'applique à une catégorie App Store |
| `keyword` | S'applique à un mot-clé spécifique |

Une règle spécifique désactive la règle parente pour ce scope.

## Templates pré-configurés

| Template | Type | Conditions par défaut |
|----------|------|----------------------|
| Chute brutale | `position_change` | `{"direction": "down", "threshold": 10}` |
| Progression | `position_change` | `{"direction": "up", "threshold": 10}` |
| Entrée top 10 | `position_change` | `{"entered_top": 10}` |
| Note en baisse | `rating_change` | `{"direction": "down", "threshold": 0.2}` |
| Pic d'avis négatifs | `review_spike` | `{"max_rating": 2, "count": 5, "period_hours": 24}` |
| Mot-clé dans avis | `review_keyword` | `{"keywords": ["bug", "crash", "lent"]}` |
| Nouveau concurrent | `new_competitor` | `{"top": 100}` |
| Concurrent vous dépasse | `competitor_passed` | `{}` |
| Mouvement de masse | `mass_movement` | `{"changes": 10, "top": 20}` |
| Popularité mot-clé | `keyword_popularity` | `{"change": 15}` |
| Opportunité | `opportunity` | `{"max_position": 3, "min_popularity": 50}` |

## Modèle de données

### Table `alert_rules`
```sql
CREATE TABLE alert_rules (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(255) NOT NULL,
    type ENUM('position_change', 'rating_change', 'review_spike',
              'review_keyword', 'new_competitor', 'competitor_passed',
              'mass_movement', 'keyword_popularity', 'opportunity') NOT NULL,
    scope_type ENUM('global', 'app', 'category', 'keyword') NOT NULL DEFAULT 'global',
    scope_id BIGINT UNSIGNED NULL,
    conditions JSON NOT NULL,
    is_template BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    priority INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX (user_id, type, is_active),
    INDEX (user_id, scope_type, scope_id)
);
```

### Table `notifications`
```sql
CREATE TABLE notifications (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    alert_rule_id BIGINT UNSIGNED NULL,
    type ENUM('position_change', 'rating_change', 'review_spike',
              'review_keyword', 'new_competitor', 'competitor_passed',
              'mass_movement', 'keyword_popularity', 'opportunity',
              'aggregated') NOT NULL,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    data JSON NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    read_at TIMESTAMP NULL,
    sent_at TIMESTAMP NULL,
    created_at TIMESTAMP NULL,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (alert_rule_id) REFERENCES alert_rules(id) ON DELETE SET NULL,
    INDEX (user_id, is_read, created_at),
    INDEX (user_id, created_at)
);
```

### Modifications table `users`
```sql
ALTER TABLE users ADD COLUMN timezone VARCHAR(50) NOT NULL DEFAULT 'UTC';
ALTER TABLE users ADD COLUMN fcm_token VARCHAR(255) NULL;
ALTER TABLE users ADD COLUMN quiet_hours_start TIME NOT NULL DEFAULT '22:00:00';
ALTER TABLE users ADD COLUMN quiet_hours_end TIME NOT NULL DEFAULT '08:00:00';
```

## Services Backend

### AlertEvaluatorService

```php
class AlertEvaluatorService
{
    public function evaluate(string $type, Collection $changedData): void
    {
        // 1. Récupérer les règles actives pour ce type
        // 2. Pour chaque user concerné, évaluer ses règles (global → spécifique)
        // 3. Collecter les alertes déclenchées
        // 4. Passer au NotificationService
    }

    public function evaluatePositionChanges(Collection $rankings): Collection;
    public function evaluateRatingChanges(Collection $ratings): Collection;
    public function evaluateReviews(Collection $reviews): Collection;
    public function evaluateTopApps(Collection $topApps): Collection;
    public function evaluateKeywordPopularity(Collection $keywords): Collection;
}
```

### NotificationService

```php
class NotificationService
{
    public function send(User $user, Collection $alerts): void
    {
        // 1. Vérifier heures calmes (avec timezone user)
        // 2. Agréger si plusieurs alertes similaires
        // 3. Sauvegarder en BDD (table notifications)
        // 4. Envoyer push FCM si pas en heures calmes
        //    (sinon envoi différé au réveil)
    }

    public function aggregate(Collection $alerts): Collection;
    public function isQuietHours(User $user): bool;
    public function scheduleForLater(User $user, Collection $alerts): void;
    public function sendFcm(User $user, Notification $notification): void;
}
```

## Anti-spam

### Agrégation
Si plusieurs alertes du même type sont déclenchées en même temps, elles sont groupées :
- "15 mouvements de position détectés" au lieu de 15 notifications séparées

### Heures calmes
- Configurable par utilisateur (défaut: 22h - 8h)
- Respecte le timezone de l'utilisateur
- Les alertes pendant les heures calmes sont stockées et envoyées au "réveil"

## Interface Flutter

### Écrans

1. **Inbox/Alertes** — liste des notifications avec badge non-lus, swipe pour marquer lu/supprimer
2. **Règles** — templates activables + liste des règles custom de l'utilisateur
3. **Builder de règle** — formulaire guidé :
   - Étape 1 : Type d'alerte
   - Étape 2 : Scope (global, app, catégorie, mot-clé)
   - Étape 3 : Conditions et seuils
   - Étape 4 : Nom et activation
4. **Settings alertes** — timezone, heures calmes, token FCM

### Deep links
```json
{
  "type": "position_change",
  "app_id": 123,
  "keyword_id": 456
}
```
Tap sur notification → ouvre l'écran de l'app/keyword concerné.

### Badge
Compteur de notifications non-lues affiché sur l'icône de l'app et dans la navigation.

## Évaluation temps réel

Les règles sont évaluées immédiatement après chaque job de synchronisation :
- `SyncRankingsJob` → évalue `position_change`, `opportunity`
- `RefreshTopAppsJob` → évalue `new_competitor`, `competitor_passed`, `mass_movement`
- `RefreshUserAppsJob` → évalue `rating_change`
- Job reviews (à créer) → évalue `review_spike`, `review_keyword`
- Job keyword popularity (à créer) → évalue `keyword_popularity`

## Dépendances

- **Firebase Cloud Messaging** — notifications push (gratuit)
- **laravel-notification-channels/fcm** — package Laravel pour FCM
- **firebase_messaging** — package Flutter pour recevoir les push
