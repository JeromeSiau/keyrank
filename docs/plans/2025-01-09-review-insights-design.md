# Review Insights - Design Document

## Overview

Nouvelle feature pour Keyrank : analyse IA des reviews pour identifier forces et faiblesses des apps (les siennes et les concurrents).

## Objectifs

1. **Analyse forces/faiblesses** — Comprendre ce que les users aiment/détestent dans une app
2. **Veille concurrentielle** — Comparer plusieurs apps pour identifier des opportunités
3. **Alertes intelligentes** (futur) — Détecter quand un nouveau problème émerge

## UX

### Deux points d'entrée

1. **Onglet "Insights"** sur chaque app (`/apps/:id/insights`)
   - Forces et faiblesses de cette app
   - Basé sur ses reviews agrégées multi-pays

2. **Écran "Compare"** dans la nav principale (`/compare`)
   - Sélectionner 2-4 apps
   - Vue côte à côte des forces/faiblesses
   - Identifier les opportunités

### Onglet Insights

**Header :**
- Bouton "Analyser" / "Rafraîchir"
- Sélecteur pays (multi-select)
- Sélecteur période (3/6/12 mois)
- Métadonnées : "847 reviews • US, FR, DE • Analysé il y a 2h"

**Section Forces/Faiblesses :**
- Deux colonnes cards
- Bullets générés par l'IA

**Section Catégories :**
- 6 cards avec score (1-5)
- Résumé texte
- Couleur selon score (rouge < 3, jaune 3-4, vert > 4)

**Section Thèmes Émergents :**
- Liste expandable
- Badge sentiment (positif/négatif/mixte)
- Fréquence affichée
- Exemples de quotes en expand

### Écran Compare

- Step 1 : Sélectionner 2-4 apps
- Step 2 : Tableau comparatif (lignes = catégories, colonnes = apps)
- Step 3 : Section "Opportunités" en bas

## Modèle d'analyse

### Catégories fixes (score 1-5 + résumé)

- UX / Interface
- Performance / Stabilité
- Fonctionnalités
- Prix / Valeur
- Support / Service
- Onboarding

### Thèmes émergents (détectés dynamiquement)

- Label généré ("Problème de sync iCloud"...)
- Sentiment (positif/négatif/mixte)
- Fréquence (nombre de mentions)
- Exemples de reviews

### Métadonnées

- Nombre de reviews analysées
- Pays inclus
- Période
- Date dernière analyse

## Architecture Backend

### Nouvelle table

```sql
CREATE TABLE app_insights (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    app_id BIGINT NOT NULL REFERENCES apps(id),
    analysis_type ENUM('full', 'refresh') DEFAULT 'full',
    reviews_count INT NOT NULL,
    countries JSON NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    category_scores JSON NOT NULL,
    category_summaries JSON NOT NULL,
    emergent_themes JSON NOT NULL,
    overall_strengths JSON NOT NULL,
    overall_weaknesses JSON NOT NULL,
    opportunities JSON,
    raw_llm_response TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_app_insights_app_id (app_id),
    INDEX idx_app_insights_created (created_at)
);
```

### Endpoints API

```
POST /api/apps/{id}/insights/generate
  Body: { countries: string[], period_months: 3|6|12 }
  Response: AppInsight object

GET /api/apps/{id}/insights
  Response: AppInsight | 404

GET /api/compare
  Query: apps[]=123&apps[]=456
  Response: { apps: AppInsight[] }
```

### Flow d'analyse

1. User clique "Analyser"
2. Backend fetch reviews des pays sélectionnés
3. Chunking si > 150 reviews (batch de 100-150)
4. Appel LLM pour chaque chunk
5. Synthèse finale des chunks
6. Stockage dans `app_insights`
7. Retour au frontend

## Intégration LLM

### Provider

- **OpenRouter** (mutualisation des clés)
- **Modèle** : GPT-5 nano (ou fallback Claude Haiku, Gemini Flash)

### Config

```php
// config/services.php
'openrouter' => [
    'api_key' => env('OPENROUTER_API_KEY'),
    'base_url' => 'https://openrouter.ai/api/v1',
    'model' => env('OPENROUTER_MODEL', 'openai/gpt-5-nano'),
],
```

### Prompt structure

```
Tu es un analyste ASO expert. Analyse ces reviews d'application mobile.

APP: {app_name} ({platform})
REVIEWS: {count} reviews de {countries} sur les {period} derniers mois

---
{reviews: rating + date + contenu}
---

Réponds en JSON:
{
  "categories": {
    "ux": { "score": 1-5, "summary": "..." },
    "performance": { "score": 1-5, "summary": "..." },
    "features": { "score": 1-5, "summary": "..." },
    "pricing": { "score": 1-5, "summary": "..." },
    "support": { "score": 1-5, "summary": "..." },
    "onboarding": { "score": 1-5, "summary": "..." }
  },
  "emergent_themes": [
    {
      "label": "...",
      "sentiment": "positive|negative|mixed",
      "frequency": 12,
      "summary": "...",
      "example_quotes": ["..."]
    }
  ],
  "overall_strengths": ["..."],
  "overall_weaknesses": ["..."],
  "opportunities": ["..."]
}
```

## Gestion des données

### Contraintes

- Max 100 reviews par pays (limite API stores)
- Solution : agrégation multi-pays

### Cache

- Analyse valide 24-72h
- Invalidation si nouvelles reviews fetchées
- Refresh toujours manuel (contrôle coûts)

### Transparence

Toujours afficher :
- Nombre de reviews analysées
- Pays inclus
- Période couverte
- Date de l'analyse

## Coûts estimés

| Scénario | Reviews | Coût estimé |
|----------|---------|-------------|
| 1 app, 1 pays | ~100 | ~$0.003 |
| 1 app, 5 pays | ~500 | ~$0.015 |
| Compare 4 apps | ~2000 | ~$0.06 |

## Hors scope MVP

- Alertes automatiques (phase 2)
- Analyse de tendances temporelles (phase 2)
- Export PDF/CSV des rapports
- Limites par tier utilisateur (monitorer d'abord)
