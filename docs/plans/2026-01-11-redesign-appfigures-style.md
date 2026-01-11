# Redesign Keyrank - Style Appfigures

**Date:** 2026-01-11
**Status:** Approved
**Inspiration:** Appfigures UI/UX

---

## Objectifs

1. **Améliorer la navigation** — Réorganiser le menu avec des sections thématiques
2. **Enrichir les visualisations** — Ajouter graphiques, sparklines, sentiment analysis
3. **Moderniser le look & feel** — Améliorer les composants tout en gardant le glass design dark

---

## Décisions clés

- **Design system** : Conserver et améliorer le glass design dark (pas de passage au light)
- **Navigation** : Approche hybride (apps détaillées + sections globales)
- **Dashboard** : Affiche uniquement les apps connectées (pas les concurrents trackés)
- **Apps trackées** : Vue adaptée avec données publiques uniquement + CTA "Connect to unlock"

---

## 1. Nouvelle Navigation

### Structure Sidebar

```
OVERVIEW
  📊 Dashboard

MES APPS
  [Liste dynamique des apps connectées]
  + Ajouter une app

OPTIMIZATION
  🔍 Keyword Inspector    — recherche/analyse keywords
  📈 Keyword Performance  — suivi des keywords trackés

ENGAGEMENT
  💬 Reviews Inbox        — toutes les reviews, filtres, réponses
  ⭐ Ratings Analysis     — histogrammes, sentiment, trends

INTELLIGENCE
  🌐 Discover             — exploration marché
  🏆 Top Charts           — classements par catégorie/pays
  👥 Competitors          — comparaison avec concurrents

FOOTER
  🔔 Notifications (avec badge)
  ⚙️ Settings
  👤 User menu
```

### Responsive

- **Desktop (>1200px)** : Sidebar complète 220px avec sections collapsibles
- **Tablet (600-1200px)** : Rail compact avec icônes, hover pour labels
- **Mobile (<600px)** : Bottom nav 4 items (Dashboard, Apps, Reviews, More)

---

## 2. Dashboard

Cockpit central avec vue agrégée des apps connectées uniquement.

### Layout

```
┌─────────────────────────────────────────────────────────────────────┐
│  METRICS BAR (4-5 cards)                                            │
│  [Downloads] [Revenue] [Ratings] [Reviews] [Keywords]               │
│  Chaque card : valeur + tendance (↑29%)                            │
├─────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────┐  ┌─────────────────────────────────┐  │
│  │ DOWNLOADS TREND         │  │ TOP COUNTRIES                   │  │
│  │ Line chart + compare    │  │ Liste pays avec % et barres     │  │
│  └─────────────────────────┘  └─────────────────────────────────┘  │
│  ┌─────────────────────────┐  ┌─────────────────────────────────┐  │
│  │ SENTIMENT OVERVIEW      │  │ RECENT ACTIVITY                 │  │
│  │ 89% positive bar        │  │ Feed d'événements récents       │  │
│  └─────────────────────────┘  └─────────────────────────────────┘  │
├─────────────────────────────────────────────────────────────────────┤
│  TOP PERFORMING APPS                                                │
│  Table avec : App, Revenue, Downloads, Rating, Trend (sparkline)    │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 3. Vue App Détaillée

Accessible via clic sur une app dans "Mes Apps".

### Onglets

1. **Overview** — Metrics + charts + sentiment + countries
2. **Keywords** — Table avec sparklines, position, change, popularity
3. **Reviews** — Liste filtrable + sentiment breakdown
4. **Ratings** — Détail par pays, évolution temporelle
5. **Insights** — Analyse AI

### Header App

```
[Icon 64px] App Name
            By Developer • Category • ★ 4.61
                                        [Period: Last 30d ▼]
```

### Adaptation selon type d'app

| Section | App connectée | App trackée |
|---------|---------------|-------------|
| Downloads & Revenue | ✅ Chart complet | ❌ "Connect to unlock" |
| DPR | ✅ | ❌ |
| Ratings Breakdown | ✅ | ✅ |
| Sentiment | ✅ | ✅ |
| Top Countries | ✅ Réel | ⚠️ Basé sur reviews |
| Keywords | ✅ | ✅ |
| Reviews | ✅ + Reply | ✅ Read-only |

---

## 4. Composants Visuels

### Metric Card avec tendance

```
┌─────────────────────┐
│  Downloads          │  ← Label gris clair
│  36.7K              │  ← Valeur grande, blanche
│  ↑ 29%              │  ← Badge vert/rouge
│  vs last period     │  ← Sous-texte discret
└─────────────────────┘
```

- Fond glass (#1a1a1a, 90% opacity, blur)
- Hover : élévation + glow accent
- Chevron coloré (vert positif, rouge négatif)

### Sparkline

```
╱╲╱─╲╱╱╲
```

- Trait 2px couleur accent
- Pas d'axes ni labels
- Largeur ~80px
- Couleur selon tendance (vert/rouge)

### Sentiment Bar

```
😊 89% ████████████████████░░░░ 11% 😞
```

- Barre bi-color (vert/rouge)
- Pourcentages aux extrémités
- Tooltip : "Based on X reviews"

### Star Histogram

```
★★★★★  ████████████████████  9.3M
★★★★☆  ███                    965K
★★★☆☆  ██                     389K
★★☆☆☆  █                      156K
★☆☆☆☆  ██                     539K
```

- Barres proportionnelles
- Dégradé couleur (5★ vert → 1★ rouge)
- Nombres formatés (K, M)

### Country Distribution

```
🇺🇸 United States    ████████████  24.3%
🇦🇺 Australia        ████          8.9%
```

- Flag + nom pays
- Barre proportionnelle accent
- Pourcentage aligné droite

---

## 5. Tables enrichies

### Table Keywords

```
│ KEYWORD        POSITION   CHANGE   POPULARITY   DIFFICULTY   TREND │
│ photo editor      #3       ↑ 2        78           45        ╱╲╱─  │
│ image edit        #8       ↓ 1        65           62        ─╲╱╲  │
```

- Position : badge coloré (#1-3 vert, #4-10 jaune, #11+ neutre)
- Change : ↑ vert, ↓ rouge, ━ gris
- Sparkline 30 jours
- Row hover highlight
- Sortable par colonne

### Table Apps

```
│ APP               REVENUE     DOWNLOADS   RATING    TREND          │
│ 🎮 Action Game    $11,858       13,961    ★ 4.56    ╱╱╲╱╱         │
│                    ↑ 8%         ↑ 12%     +0.02                    │
```

- Deux lignes : valeur + variation
- Icon app à gauche
- Sparkline

---

## 6. Reviews & Ratings

### Reviews Inbox (global)

```
┌─────────────────────────────────────────────────────────────────────┐
│  OVERVIEW CARDS                                                     │
│  [Total Reviews] [Avg Rating] [Sentiment Bar]                       │
├─────────────────────────────────────────────────────────────────────┤
│  SENTIMENT BREAKDOWN (12 months)                                    │
│  Bar chart mensuel                                                  │
├─────────────────────────────────────────────────────────────────────┤
│  FILTERS  [Unanswered] [Negative only] [★★☆☆☆ & below]             │
├─────────────────────────────────────────────────────────────────────┤
│  REVIEWS LIST                                                       │
│  Cards avec : stars, texte, app, pays, date, [Reply] [AI ✨]       │
└─────────────────────────────────────────────────────────────────────┘
```

### Ratings (onglet app)

- Current Rating avec histogram
- Ratings by country (liste avec rating + count)
- Rating Trend (line chart 12 mois)

---

## 7. Intelligence

### Discover (Keyword Intelligence)

```
┌─────────────────────────────────────────────────────────────────────┐
│  Search bar + Country/Platform selectors                            │
├─────────────────────────────────────────────────────────────────────┤
│  INSIGHTS                    │  TOP 10 PERFORMANCE                  │
│  Popularity [progress]       │  Est. Downloads, Est. Revenue, DPR   │
│  Competitiveness [progress]  │                                      │
├─────────────────────────────────────────────────────────────────────┤
│  TOP RESULTS (table)         │  TOP ADVERTISERS (liste)             │
└─────────────────────────────────────────────────────────────────────┘
```

### Top Charts

- Filtres : Country, Category, Collection (Free/Paid/Grossing)
- Table : Rank, App, Rating, Change, Trend, [Track]

### Competitors

- Sélecteur multi-apps
- Comparison table (metrics côte à côte)
- Ranking comparison (multi-line chart)

---

## 8. Données requises (Backend)

| Feature | Status | Notes |
|---------|--------|-------|
| Sentiment analysis | ✅ Disponible | Sur reviews |
| Revenue & Downloads | 🔄 En cours | Via Store Connections |
| Geographic data | ❌ À prévoir | Via Store Connections |
| DPR | ❌ À calculer | downloads / ratings |
| Estimated downloads (competitors) | ❌ Optionnel | Estimation ou masqué |

---

## 9. Récapitulatif des changements

| Composant | Status |
|-----------|--------|
| Navigation restructurée (hybride) | Nouveau |
| Dashboard agrégé (vos apps) | Refonte |
| Metric cards avec tendances | Nouveau |
| Sparklines dans tables | Nouveau |
| Sentiment analysis bar | Nouveau |
| Star histogram | Amélioré |
| Country distribution | Nouveau |
| Reviews Inbox enrichi | Refonte |
| Ratings Analysis | Nouveau écran |
| Keyword Inspector | Refonte |
| Top Charts | Nouveau écran |
| Competitors view | Refonte |

---

## Prochaines étapes

1. Créer les nouveaux composants visuels (MetricCard, Sparkline, SentimentBar, etc.)
2. Refactorer la navigation/sidebar
3. Implémenter le nouveau Dashboard
4. Refactorer la vue App Detail avec onglets
5. Enrichir Reviews Inbox
6. Ajouter Ratings Analysis
7. Refactorer Discover/Keyword Inspector
8. Ajouter Top Charts
9. Refactorer Competitors view
