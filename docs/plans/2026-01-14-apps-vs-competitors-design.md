# Design : Différenciation Apps vs Competitors

## 1. Contexte

Keyrank doit différencier deux types d'apps :
- **Mes Apps** : les apps que l'utilisateur possède/publie et qu'il track activement
- **Competitors** : les apps concurrentes qu'il surveille pour analyse comparative

Cette différenciation impacte trois dimensions :
1. **Visuel/Organisation** — Affichage séparé dans l'interface
2. **Fonctionnel** — Actions différentes selon le type
3. **Analytique** — Dashboards et rapports adaptés

## 2. Modèle de données

### 2.1 Modifications à `user_apps` (pivot existant)

```sql
ALTER TABLE user_apps ADD COLUMN is_competitor BOOLEAN DEFAULT FALSE;
```

| Colonne | Type | Description |
|---------|------|-------------|
| `is_owner` | BOOLEAN | (existe déjà) `true` = app appartient à l'utilisateur |
| `is_competitor` | BOOLEAN | (nouveau) `true` = competitor global |

### 2.2 Nouvelle table `app_competitors`

Lie un competitor spécifiquement à une app de l'utilisateur (relation contextuelle).

```sql
CREATE TABLE app_competitors (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    owner_app_id BIGINT UNSIGNED NOT NULL,
    competitor_app_id BIGINT UNSIGNED NOT NULL,
    source ENUM('manual', 'auto_discovered', 'keyword_overlap') DEFAULT 'manual',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (owner_app_id) REFERENCES apps(id) ON DELETE CASCADE,
    FOREIGN KEY (competitor_app_id) REFERENCES apps(id) ON DELETE CASCADE,
    UNIQUE KEY unique_competitor (user_id, owner_app_id, competitor_app_id)
);
```

### 2.3 Logique de requêtes

```sql
-- Mes apps (pour AppContextSwitcher)
SELECT apps.* FROM apps
JOIN user_apps ON apps.id = user_apps.app_id
WHERE user_apps.user_id = :userId AND user_apps.is_owner = TRUE;

-- Competitors globaux
SELECT apps.* FROM apps
JOIN user_apps ON apps.id = user_apps.app_id
WHERE user_apps.user_id = :userId AND user_apps.is_competitor = TRUE;

-- Competitors d'une app spécifique (contextuels + globaux)
SELECT apps.*, 'contextual' as competitor_type FROM apps
JOIN app_competitors ON apps.id = app_competitors.competitor_app_id
WHERE app_competitors.user_id = :userId AND app_competitors.owner_app_id = :appId
UNION
SELECT apps.*, 'global' as competitor_type FROM apps
JOIN user_apps ON apps.id = user_apps.app_id
WHERE user_apps.user_id = :userId AND user_apps.is_competitor = TRUE;
```

## 3. Interface utilisateur

### 3.1 AppContextSwitcher (sidebar)

Comportement inchangé, mais filtrage explicite :
- Affiche uniquement les apps où `is_owner = true`
- Option "Toutes les apps" en haut de la liste
- Les competitors n'apparaissent jamais dans ce sélecteur

### 3.2 Section Competitors (`/competitors`)

**Vue liste enrichie :**

```
┌─────────────────────────────────────────────────────────┐
│  Competitors                           [+ Ajouter]      │
├─────────────────────────────────────────────────────────┤
│  Filtre: [Tous ▼] [Global ▼] [Liés à App X ▼]          │
├─────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────┐   │
│  │ 🎯 Competitor A                         Global   │   │
│  │    Fitness • 4.5★ • Rank #3 sur "workout"       │   │
│  │    [Voir] [Comparer] [Lier à une app]           │   │
│  └──────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────┐   │
│  │ 🎯 Competitor B                      → Mon App X │   │
│  │    Fitness • 4.2★ • Rank #7 sur "fitness"       │   │
│  │    [Voir] [Comparer] [Délier]                   │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

**Comportement contextuel :**
- Si "Toutes les apps" sélectionné → Affiche tous les competitors (globaux + liés)
- Si "Mon App X" sélectionné → Competitors de App X + globaux (avec badge distinctif)

### 3.3 Fiche Competitor

Réutilise `AppDetailScreen` avec adaptations :
- Mêmes onglets : Overview, Keywords, Rankings, Reviews
- Actions masquées : "Répondre aux avis", Opportunity Engine, Suggestions
- Bouton additionnel : "Comparer avec [App sélectionnée]" en header
- Badge visuel : indicateur "Competitor" dans le header

### 3.4 Fonction Compare

- Devient une **action** accessible depuis la section Competitors
- Peut comparer : mon app vs 1+ competitors, ou plusieurs competitors entre eux
- Accessible via : bouton dans la liste, ou depuis la fiche d'un competitor

## 4. Fonctionnalités différenciées

| Fonctionnalité | Mes Apps | Competitors | Notes |
|----------------|:--------:|:-----------:|-------|
| Tracker keywords | ✅ | ✅ | Même table `tracked_keywords` |
| Voir rankings | ✅ | ✅ | Même logique |
| Alertes complètes | ✅ | ❌ | — |
| Alertes mouvement | ✅ | ✅ | "Entre top 10", "Gagne +15 places" |
| Répondre aux avis | ✅ | ❌ | Bouton masqué |
| Voir reviews | ✅ | ✅ | Lecture seule pour competitors |
| Opportunity Engine | ✅ | ❌ | Filtré sur `is_owner = true` |
| Suggestions keywords | ✅ | ❌ | Idem |
| Export/reporting | ✅ | ✅ | Inclus dans rapports comparatifs |

### 4.1 Alertes pour competitors

**Disponibles :**
- "Competitor X entre dans le top 10 sur [keyword]"
- "Competitor X gagne +15 places sur [keyword]"
- "Competitor X a mis à jour sa fiche (nouvelle version)"

**Non disponibles :**
- Opportunity scores
- Suggestions d'actions
- Alertes rating/reviews détaillées

### 4.2 Dashboard contextuel

- **App sélectionnée** : Widget "Top Competitors" avec mouvements récents
- **Vue globale** : Résumé des mouvements competitors sur toutes les apps

## 5. API Endpoints

### 5.1 Nouveaux endpoints

```
GET    /api/competitors                    # Liste tous les competitors (global + contextuels)
POST   /api/competitors                    # Ajouter un competitor global
DELETE /api/competitors/{id}               # Supprimer un competitor global

POST   /api/apps/{id}/competitors          # Lier un competitor à une app
DELETE /api/apps/{id}/competitors/{cid}    # Délier un competitor d'une app
GET    /api/apps/{id}/competitors          # Competitors d'une app spécifique
```

### 5.2 Modifications endpoints existants

```
GET /api/apps                              # Ajouter paramètre ?type=owned|competitor|all
GET /api/apps/{id}                         # Inclure is_owner, is_competitor dans la réponse
```

## 6. Plan d'implémentation

### 6.1 Backend (Laravel)

1. **Migration** : Ajouter `is_competitor` à `user_apps`
2. **Migration** : Créer table `app_competitors`
3. **Model** : Créer `AppCompetitor` model avec relations
4. **Model** : Modifier `App` model — ajouter scopes `owned()`, `competitors()`
5. **Controller** : Créer `CompetitorController`
6. **Routes** : Ajouter endpoints competitors
7. **Tests** : Tests unitaires pour les nouvelles relations

### 6.2 Frontend (Flutter)

1. **Model** : Ajouter `isOwner`, `isCompetitor` à `AppModel`
2. **Model** : Créer `AppCompetitorModel` pour la relation contextuelle
3. **Repository** : Créer `CompetitorsRepository`
4. **Provider** : Créer `competitorsProvider` (global + contextuel)
5. **UI** : Enrichir `CompetitorsScreen` — liste, filtres, actions
6. **UI** : Adapter `AppDetailScreen` — masquer actions si competitor
7. **UI** : Filtrer `AppContextSwitcher` sur `isOwner = true`
8. **Tests** : Tests widgets pour les comportements différenciés

## 7. Questions ouvertes

- [ ] Limite du nombre de competitors par plan/tier ?
- [ ] Auto-discovery des competitors basé sur keywords overlap ?
- [ ] Notification quand un competitor est auto-découvert ?

## 8. Références

- [Keyrank V1 Spec](./2026-01-13-keyrank-v1-spec.md) — Section 7.3 Analyse concurrents
- [Appfigures Competitor Tracking](https://appfigures.com/support/kb/638/how-to-track-competitors-any-app-with-appfigures)
- [AppTweak Competitor Analysis](https://www.apptweak.com/en/aso-tools/app-competition-monitoring)
