# Keyrank v2 — Design Document

> **Vision** : Transformer Keyrank d'un clone Astro en un concurrent sérieux d'AppFigures — un SaaS public d'ASO avec des visualisations exceptionnelles, une profondeur de données maximale, et une intelligence IA intégrée.

**Date** : 11 janvier 2026
**Auteur** : Jerome + Claude
**Status** : En attente de validation

---

## Table des matières

1. [Contexte & Objectifs](#1-contexte--objectifs)
2. [Positionnement & Différenciation](#2-positionnement--différenciation)
3. [Architecture Data](#3-architecture-data)
4. [Intégrations & Stores](#4-intégrations--stores)
5. [Onboarding](#5-onboarding)
6. [Modèle Owner vs Watcher](#6-modèle-owner-vs-watcher)
7. [Visualisations & Design System](#7-visualisations--design-system)
8. [Dashboard Principal](#8-dashboard-principal)
9. [Intelligence IA](#9-intelligence-ia)
10. [Écrans & Navigation](#10-écrans--navigation)
11. [Modèle de données](#11-modèle-de-données)
12. [API Endpoints](#12-api-endpoints)
13. [Jobs & Collectors](#13-jobs--collectors)
14. [Plans & Billing](#14-plans--billing)
15. [Plan d'implémentation](#15-plan-dimplémentation)
16. [Métriques de succès](#16-métriques-de-succès)

---

## 1. Contexte & Objectifs

### 1.1 État actuel

Keyrank est actuellement un clone d'Astro avec :
- ✅ Tracking keywords, rankings, ratings, reviews
- ✅ Alertes et notifications push
- ✅ Analyse des avis avec IA
- ✅ Charts basiques (LineChart, histogrammes)
- ✅ Sync journalier via CRON
- ❌ Fetch on-demand (données pas toujours prêtes)
- ❌ Dashboard fragmenté (pages séparées)
- ❌ Visualisations basiques
- ❌ Pas de connexion aux comptes développeur

### 1.2 Objectifs v2

| Objectif | Description | Métrique |
|----------|-------------|----------|
| **Data-first** | Stocker toutes les données, jamais de fetch on-demand | 0 appels API déclenchés par l'UI |
| **Visuellement impressionnant** | Design Apple-style avec charts custom | NPS design > 8/10 |
| **Intelligence actionable** | Insights IA proactifs | 3+ insights/semaine/app |
| **Onboarding fluide** | De l'inscription au premier insight < 5 min | Time-to-value < 5 min |
| **Multi-plateforme** | iOS, Android, puis autres stores | 2 stores MVP, 6+ à terme |

### 1.3 Contraintes

- **Qualité > Vitesse** : Préférer des fondations solides à un lancement rapide
- **Budget serveur maîtrisé** : Architecture scalable économiquement
- **Pas d'over-engineering** : Features minimales viables, itérer ensuite

---

## 2. Positionnement & Différenciation

### 2.1 Analyse concurrentielle

| Critère | AppFigures | Sensor Tower | AppTweak | **Keyrank v2** |
|---------|------------|--------------|----------|----------------|
| Prix entrée | $7.99/mo | $$$$ | $$$ | Compétitif |
| Cible | Indie/PME | Enterprise | Mid-market | Indie → PME |
| Force | Analytics + ASO unifié | Market intelligence | Keyword tools | **Visuel + IA** |
| Faiblesse | UI datée | Prix | Complexe | Nouveau venu |

### 2.2 Positionnement Keyrank

> **"L'ASO tool qui vous montre ce qui compte, pas ce qui noie"**

- **Design épuré Apple-style** vs dashboards surchargés des concurrents
- **IA explicative** qui répond "pourquoi" pas juste "quoi"
- **Données profondes** stockées depuis le jour 1, historique illimité
- **Prix accessible** pour les indépendants et petites équipes

---

## 3. Architecture Data

### 3.1 Philosophie "Data Lake First"

**Avant (v1)** : Fetch on-demand avec cache 24h
```
User request → Check cache → If stale → Fetch API → Store → Return
```

**Après (v2)** : Collect everything, query anything
```
Collectors (background) → Store continuously
User request → Read from DB → Return instantly
```

### 3.2 Collectors autonomes

| Collector | Fréquence | Source | Données |
|-----------|-----------|--------|---------|
| `RankingsCollector` | Toutes les 2h | iTunes Search / Play Search | Position top 200 par keyword/pays |
| `RatingsCollector` | Toutes les 6h | iTunes Lookup / Play Store | Note moyenne, count par pays |
| `ReviewsCollector` | Toutes les 4h | iTunes RSS / Play Scraper | Nouveaux avis, sentiment |
| `TopChartsCollector` | Toutes les 6h | iTunes RSS / Play Charts | Top apps par catégorie/pays |
| `MetadataCollector` | Journalier | Store APIs | Icon, description, version, prix |
| `SalesCollector` | Journalier | App Store Connect / Play Console | Downloads, revenue, subscribers |
| `PopularityCollector` | Journalier | Apple Search Ads API | Search popularity score |

### 3.3 Stratégie de stockage

```
┌─────────────────────────────────────────────────────────────────┐
│                         HOT DATA                                │
│                    (MySQL/PostgreSQL)                           │
│                                                                 │
│  • 90 derniers jours                                           │
│  • Tables partitionnées par mois                               │
│  • Index optimisés pour requêtes fréquentes                    │
│  • Requêtes < 100ms                                            │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                        WARM DATA                                │
│                   (Tables agrégées)                             │
│                                                                 │
│  • Agrégats hebdomadaires et mensuels                          │
│  • Pré-calculés par job nocturne                               │
│  • Pour charts historiques longue période                      │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                        COLD DATA                                │
│              (Compressed / Object Storage)                      │
│                                                                 │
│  • Données > 90 jours (raw)                                    │
│  • Archives compressées                                        │
│  • Requêtes plus lentes mais économiques                       │
│  • Export on-demand uniquement                                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 3.4 Partitionnement des tables

```sql
-- Exemple: table rankings partitionnée par mois
CREATE TABLE app_rankings (
    id BIGINT AUTO_INCREMENT,
    app_id INT NOT NULL,
    keyword_id INT NOT NULL,
    country_code VARCHAR(2) NOT NULL,
    position SMALLINT,
    recorded_at TIMESTAMP NOT NULL,
    PRIMARY KEY (id, recorded_at),
    INDEX idx_app_keyword_country (app_id, keyword_id, country_code, recorded_at)
) PARTITION BY RANGE (UNIX_TIMESTAMP(recorded_at)) (
    PARTITION p_2026_01 VALUES LESS THAN (UNIX_TIMESTAMP('2026-02-01')),
    PARTITION p_2026_02 VALUES LESS THAN (UNIX_TIMESTAMP('2026-03-01')),
    -- ... auto-créées par job maintenance
    PARTITION p_future VALUES LESS THAN MAXVALUE
);
```

### 3.5 Rétention des données

| Type de donnée | Hot (détail) | Warm (agrégé) | Cold (archive) |
|----------------|--------------|---------------|----------------|
| Rankings | 90 jours | 2 ans (weekly) | Illimité (monthly) |
| Ratings | 90 jours | 2 ans (weekly) | Illimité (monthly) |
| Reviews | 1 an (full text) | — | Illimité (metadata only) |
| Sales/Downloads | 90 jours | 2 ans (weekly) | Illimité (monthly) |
| Top Charts | 30 jours | 1 an (weekly) | — |

---

## 4. Intégrations & Stores

### 4.1 Stores supportés par phase

| Phase | Store | Type | Priorité |
|-------|-------|------|----------|
| **MVP** | iOS App Store | Mobile | P0 |
| **MVP** | Google Play | Mobile | P0 |
| **Phase 2** | Mac App Store | Desktop | P1 |
| **Phase 2** | Apple TV App Store | TV | P2 |
| **Phase 3** | Amazon Appstore | Mobile | P2 |
| **Phase 3** | Steam | Gaming | P3 |
| **Phase 3** | Windows Store | Desktop | P3 |
| **Future** | Samsung Galaxy Store | Mobile | P4 |
| **Future** | Huawei AppGallery | Mobile | P4 |

### 4.2 Niveaux d'intégration

#### Niveau "Basic" (recherche publique)

Pas d'authentification requise. Données publiques uniquement.

**Sources :**
- iTunes Search API (apps, rankings)
- iTunes Lookup API (metadata, ratings)
- iTunes RSS Feeds (reviews, top charts)
- Google Play Scraper (Node.js service)

**Données accessibles :**
- Métadonnées app (nom, icon, description, version, prix)
- Rankings par keyword (via search)
- Ratings et distribution estimée
- Reviews publics
- Position dans Top Charts

#### Niveau "Pro" (compte développeur connecté)

Authentification OAuth ou API Key. Données privées.

**App Store Connect :**
```
Authentification : API Key (JWT)
- Générer dans ASC > Users and Access > Keys
- Clé privée .p8 + Key ID + Issuer ID
- JWT signé côté serveur, expire après 20 min
```

**Données exclusives :**
- Liste complète des apps du compte
- Downloads par jour/pays/source
- Revenue et In-App Purchases
- Subscription metrics (MRR, churn, trials)
- Pre-orders
- Promo codes usage
- App Analytics (impressions, conversion)
- Crash reports (via App Store Connect API)

**Google Play Console :**
```
Authentification : Service Account
- Créer dans Google Cloud Console
- Activer Google Play Developer API
- Télécharger JSON credentials
- Lier le service account au Play Console
```

**Données exclusives :**
- Liste complète des apps
- Installs/uninstalls par jour/pays
- Revenue et subscriptions
- Ratings breakdown détaillé
- Acquisition reports
- Crash & ANR reports
- Store listing experiments results

### 4.3 Intégrations additionnelles (Phase 2+)

| Service | Usage | Authentification |
|---------|-------|------------------|
| Apple Search Ads | Keyword popularity, ad spend | OAuth 2.0 |
| Stripe | Revenue in-app custom | API Key |
| Slack | Notifications, weekly digest | OAuth 2.0 |
| Webhook générique | Intégrations custom | API Key |

### 4.4 Table `integrations`

```sql
CREATE TABLE integrations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    type ENUM('app_store_connect', 'google_play_console', 'apple_search_ads', 'stripe', 'slack', 'webhook') NOT NULL,
    status ENUM('pending', 'active', 'error', 'revoked') DEFAULT 'pending',
    credentials JSON, -- Encrypted: API keys, tokens, etc.
    metadata JSON, -- Team name, account info, etc.
    last_sync_at TIMESTAMP NULL,
    error_message TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_type (user_id, type)
);
```

---

## 5. Onboarding

### 5.1 Objectifs

- **Time-to-value < 5 minutes** : De l'inscription au premier insight
- **Progressive disclosure** : Montrer la valeur avant de demander des efforts
- **Skip-friendly** : Chaque étape optionnelle (sauf compte)

### 5.2 Flow en 4 étapes

#### Étape 1: Welcome

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│                          🎯                                     │
│                                                                 │
│              Track your apps like never before                  │
│                                                                 │
│     Beautiful insights, deep data, actionable intelligence      │
│                                                                 │
│                                                                 │
│                     ┌─────────────────┐                        │
│                     │   Get Started   │                        │
│                     └─────────────────┘                        │
│                                                                 │
│                Already have an account? Sign in                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

#### Étape 2: Connect Stores

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  Step 2 of 4                                    [Skip for now]  │
│                                                                 │
│  Connect your developer accounts                                │
│  We'll automatically find all your apps                         │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │                                                           │ │
│  │   (Apple logo)  App Store Connect                        │ │
│  │                                                           │ │
│  │   Access your sales, downloads, and all your iOS apps    │ │
│  │                                                           │ │
│  │   ┌─────────────────────────────────────────────────┐    │ │
│  │   │           Connect with Apple                    │    │ │
│  │   └─────────────────────────────────────────────────┘    │ │
│  │                                                           │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │                                                           │ │
│  │   (Google logo)  Google Play Console                     │ │
│  │                                                           │ │
│  │   Access your stats, revenue, and all your Android apps  │ │
│  │                                                           │ │
│  │   ┌─────────────────────────────────────────────────┐    │ │
│  │   │           Connect with Google                   │    │ │
│  │   └─────────────────────────────────────────────────┘    │ │
│  │                                                           │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ─────────────────────── or ────────────────────────────────── │
│                                                                 │
│         Search for apps manually (limited features)             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Flow App Store Connect :**
1. User clique "Connect with Apple"
2. Modal explique comment générer une API Key dans ASC
3. User upload la clé .p8 + saisit Key ID + Issuer ID
4. Backend valide en appelant l'API ASC
5. Si OK → status "active", fetch apps list

**Flow Google Play Console :**
1. User clique "Connect with Google"
2. Modal explique comment créer un Service Account
3. User upload le JSON credentials
4. Backend valide en appelant l'API Play
5. Si OK → status "active", fetch apps list

#### Étape 3: Select Apps

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  Step 3 of 4                                                    │
│                                                                 │
│  We found 6 apps in your accounts                               │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │                                                           │ │
│  │  From App Store Connect:                                  │ │
│  │                                                           │ │
│  │  ☑️  (icon) MyApp Pro           12.3K downloads    iOS   │ │
│  │  ☑️  (icon) MyApp Lite          45.1K downloads    iOS   │ │
│  │  ☐  (icon) MyApp (deprecated)   deprecated         iOS   │ │
│  │                                                           │ │
│  │  From Google Play Console:                                │ │
│  │                                                           │ │
│  │  ☑️  (icon) MyApp               89.2K downloads  Android │ │
│  │  ☑️  (icon) MyApp Pro           23.1K downloads  Android │ │
│  │  ☐  (icon) Test App             12 downloads     Android │ │
│  │                                                           │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                                                 │
│  Want to track competitor apps too?                             │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │  🔍  Search for an app...                                 │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                                                 │
│                     ┌─────────────────┐                        │
│                     │    Continue     │                        │
│                     └─────────────────┘                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

#### Étape 4: Quick Setup

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  Step 4 of 4                                                    │
│                                                                 │
│  Quick setup for MyApp Pro                                      │
│  (We'll suggest more keywords later based on your data)         │
│                                                                 │
│  Countries to track:                                            │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │  🇺🇸 US  ☑️   🇬🇧 UK  ☑️   🇫🇷 FR  ☑️   🇩🇪 DE  ☑️        │ │
│  │  🇯🇵 JP  ☐    🇰🇷 KR  ☐    🇨🇳 CN  ☐    🇧🇷 BR  ☐        │ │
│  │                                                           │ │
│  │  + Add more countries                                     │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                                                 │
│  Initial keywords (from your app metadata):                     │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │  ☑️ photo editor       ☑️ camera app       ☑️ filters    │ │
│  │  ☑️ photo effects      ☑️ image editor     ☐ selfie      │ │
│  │                                                           │ │
│  │  + Add custom keyword                                     │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                                                 │
│                ┌──────────────────────────┐                    │
│                │   Start Tracking 🚀      │                    │
│                └──────────────────────────┘                    │
│                                                                 │
│                     Skip, I'll set up later                     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 5.3 Post-onboarding

Après "Start Tracking" :
1. Redirect vers Dashboard
2. Banner "We're collecting your first data, check back in a few minutes"
3. Premier collector run immédiat pour les apps sélectionnées
4. Notification push quand premières données prêtes
5. Email de bienvenue avec quick tips

---

## 6. Modèle Owner vs Watcher

### 6.1 Définitions

| Type | Description | Cas d'usage |
|------|-------------|-------------|
| **Owned** | App dont l'utilisateur est le développeur (via compte connecté) | Vos propres apps |
| **Watched** | App trackée sans être propriétaire (recherche publique) | Concurrents, inspirations |

### 6.2 Données par type

| Donnée | Owned (connecté) | Watched (public) |
|--------|------------------|------------------|
| Rankings keywords | ✅ Full | ✅ Full |
| Ratings & distribution | ✅ Exact | ✅ Exact |
| Reviews publics | ✅ Full | ✅ Full |
| Métadonnées (icon, desc) | ✅ Full | ✅ Full |
| Position Top Charts | ✅ Full | ✅ Full |
| **Downloads** | ✅ Exact | ⚠️ Estimations |
| **Revenue** | ✅ Exact | ❌ Non disponible |
| **Conversion rate** | ✅ Exact | ❌ Non disponible |
| **Subscriber count** | ✅ Exact | ❌ Non disponible |
| **Crash reports** | ✅ Full | ❌ Non disponible |
| **Acquisition source** | ✅ Full | ❌ Non disponible |

### 6.3 Tags pour apps watched

Les apps watched peuvent être catégorisées :

| Tag | Icône | Usage |
|-----|-------|-------|
| `competitor` | 🎯 | Concurrent direct |
| `inspiration` | 💡 | App dont on s'inspire |
| `benchmark` | 📊 | Référence du marché |
| `client` | 👤 | App d'un client (agences) |
| Custom | 🏷️ | Tags personnalisés |

### 6.4 Affichage dans l'UI

```
┌─────────────────────────────────────────────────────────────────┐
│  📱 YOUR APPS                                                   │
│                                                                 │
│  OWNED (3)                        via App Store Connect         │
│  ─────────────────────────────────────────────────────────────  │
│  (icon) MyApp Pro         ★4.7  $12.4K  124K dl  #8   →        │
│  (icon) MyApp Lite        ★4.3  $2.1K   89K dl   #24  →        │
│  (icon) MyApp Android     ★4.5  $8.2K   201K dl  #12  →        │
│                                                                 │
│  WATCHING (5)                               Public data only 👁️ │
│  ─────────────────────────────────────────────────────────────  │
│  (icon) VSCO              ★4.7  ██████  #3   🎯 competitor  →  │
│  (icon) Snapseed          ★4.5  █████   #5   🎯 competitor  →  │
│  (icon) Lightroom         ★4.6  ██████  #2   🎯 competitor  →  │
│  (icon) Camera+ 2         ★4.8  ████    #11  💡 inspiration →  │
│  (icon) Facetune          ★4.4  █████   #7   🎯 competitor  →  │
│                                                                 │
│  ┌─────────────────┐                                           │
│  │   + Add App     │                                           │
│  └─────────────────┘                                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 6.5 Estimations pour apps watched

Pour les downloads des apps non-owned, on peut proposer des estimations basées sur :
- Position dans les charts
- Nombre de ratings (corrélation downloads/ratings)
- Comparaison avec apps owned similaires

**Affichage :**
```
Downloads: ~125K-150K (estimated)
           ℹ️ Connect as owner for exact data
```

---

## 7. Visualisations & Design System

### 7.1 Principes de design

| Principe | Description | Exemple |
|----------|-------------|---------|
| **Une métrique hero** | Chaque carte met en avant UN chiffre principal | "4.7" en gros, détails en petit |
| **Couleurs sémantiques** | Vert = positif, Rouge = attention, Bleu = neutre | Tendance ↗ en vert |
| **Espaces généreux** | Padding 24px, gaps 16px, respiration visuelle | Pas de surcharge |
| **Animations subtiles** | Transitions 200-300ms, easing naturel | Fade in des données |
| **Progressive disclosure** | Vue d'ensemble → détails au clic | Sparkline → Full chart |

### 7.2 Palette de couleurs

```
// Semantic colors
success: #34C759     // Vert Apple - tendances positives
warning: #FF9500     // Orange - attention requise
error: #FF3B30       // Rouge - problèmes
info: #007AFF        // Bleu Apple - neutre/info

// Chart colors
primary: #007AFF     // Ligne principale
secondary: #5856D6   // Ligne secondaire
tertiary: #AF52DE    // Ligne tertiaire
comparison: #8E8E93  // Ligne comparaison (dashed)

// Backgrounds
card: #FFFFFF
cardHover: #F9F9F9
surface: #F2F2F7
divider: #E5E5EA

// Text
textPrimary: #000000
textSecondary: #8E8E93
textTertiary: #C7C7CC
```

### 7.3 Typographie

```
// Font family
fontFamily: -apple-system, BlinkMacSystemFont, 'SF Pro Display', sans-serif

// Sizes
heroMetric: 48px / bold      // Chiffre principal
headline: 24px / semibold    // Titre section
title: 17px / semibold       // Titre carte
body: 15px / regular         // Texte courant
caption: 13px / regular      // Labels, metadata
micro: 11px / medium         // Tags, badges
```

### 7.4 Composants de visualisation

#### MetricCard

Carte avec chiffre principal, tendance, et sparkline.

```
┌─────────────────────────────────────────┐
│  DOWNLOADS                              │
│                                         │
│       124.5K                            │
│                                         │
│  ↗ +12.3%         ╱╲╱──╱╲               │
│  vs last period   (sparkline)           │
│                                         │
└─────────────────────────────────────────┘

Props:
- title: string
- value: string | number
- change: { value: number, direction: 'up' | 'down' | 'neutral' }
- sparklineData: number[]
- period: '7d' | '30d' | '90d'
- color: 'success' | 'warning' | 'error' | 'info'
```

#### TrendChart

Graphique principal avec période selector et tooltips.

```
┌─────────────────────────────────────────────────────────────────┐
│  Keyword: "photo editor"                    7d   30d   90d     │
│                                                       ↗ +3     │
│                                                                 │
│  12 ─                                    ╭───────              │
│  15 ─                    ╭───────────────╯                     │
│  18 ─      ╭────────────╯                                      │
│  21 ─  ────╯                                                   │
│      ───┬─────┬─────┬─────┬─────┬─────┬─────┬────              │
│        Jan   Feb   Mar   Apr   May   Jun   Jul                 │
│                                                                 │
│  (Gradient fill sous la courbe, couleur selon tendance)        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

Props:
- data: { date: Date, value: number }[]
- periods: ('7d' | '30d' | '90d' | '1y')[]
- selectedPeriod: string
- showGradient: boolean
- invertAxis: boolean (pour rankings où bas = mieux)
- compareData?: { date: Date, value: number }[] (overlay)
```

#### Sparkline

Mini-graphique inline pour tableaux et listes.

```
╱╲╱──╱╲    (48x16px, no axes, just the line)

Props:
- data: number[]
- color: 'success' | 'warning' | 'error' | 'neutral'
- width: number (default 48)
- height: number (default 16)
```

#### RingChart

Distribution circulaire (ratings).

```
       ┌─────────┐
      ╱           ╲      ★★★★★  68%  ████████████████
     │    4.6     │      ★★★★   18%  █████
     │    ★★★★½   │      ★★★     8%  ██
      ╲    ∕     ╱       ★★      4%  █
       └───────┘         ★       2%  ▌

Props:
- average: number
- distribution: { stars: 1-5, percentage: number }[]
- showLabels: boolean
- size: 'small' | 'medium' | 'large'
```

#### HeatmapGrid

Matrice pour données pays × keywords ou temps × keywords.

```
           US   UK   FR   DE   JP   AU   CA
photo      ██   ██   ▓▓   ▓▓   ░░   ██   ██
editor     ██   ▓▓   ▓▓   ░░   ░░   ▓▓   ██
camera     ▓▓   ▓▓   ██   ██   ▓▓   ░░   ▓▓

██ Top 10   ▓▓ Top 50   ░░ Top 100   ·· Not ranked

Props:
- rows: { id: string, label: string }[]
- columns: { id: string, label: string }[]
- values: Map<`${rowId}-${colId}`, number>
- colorScale: (value: number) => Color
- legend: { label: string, color: Color }[]
```

#### ComparisonChart

Overlay multi-séries pour comparaison apps/périodes.

```
┌─────────────────────────────────────────────────────────────────┐
│  Downloads: MyApp vs Competitor                                 │
│                                                                 │
│  ── MyApp (solid)                                              │
│  ┄┄ VSCO (dashed)                                              │
│                                                                 │
│       ────────╮    ╭──────                                     │
│   ┄┄┄┄┄┄┄┄┄╮  ╰────╯   ┄┄┄┄┄                                  │
│            ╰┄┄┄┄┄┄┄┄┄┄┄╯                                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

Props:
- series: { id: string, label: string, data: DataPoint[], style: 'solid' | 'dashed' }[]
- showLegend: boolean
- interactive: boolean (hover to highlight series)
```

#### ChangeIndicator

Badge de changement avec flèche et couleur.

```
↗ +12    (vert, valeur positive)
↘ -5     (rouge, valeur négative)
→ 0      (gris, pas de changement)

Props:
- value: number
- format: 'number' | 'percent' | 'position'
- size: 'small' | 'medium'
- showIcon: boolean
```

### 7.5 Animations

```dart
// Standard transitions
const Duration defaultDuration = Duration(milliseconds: 200);
const Curve defaultCurve = Curves.easeOutCubic;

// Chart animations
const Duration chartLoadDuration = Duration(milliseconds: 600);
const Curve chartCurve = Curves.easeOutQuart;

// Number counting animation
const Duration countDuration = Duration(milliseconds: 400);

// Skeleton shimmer
const Duration shimmerDuration = Duration(milliseconds: 1500);
```

### 7.6 Interactions

| Interaction | Action | Feedback |
|-------------|--------|----------|
| **Hover** (chart) | Affiche tooltip avec valeur exacte + date | Cursor pointer, point highlight |
| **Click & drag** (chart) | Zoom sur période sélectionnée | Selection overlay |
| **Pinch** (mobile) | Zoom in/out | Haptic feedback |
| **Long press** | Menu contextuel | Ripple + menu |
| **Pull to refresh** | Actualise les données | Indicator + haptic |

---

## 8. Dashboard Principal

### 8.1 Structure

```
┌─────────────────────────────────────────────────────────────────────┐
│  HEADER                                                             │
├─────────────────────────────────────────────────────────────────────┤
│  GREETING + LAST SYNC                                               │
├─────────────────────────────────────────────────────────────────────┤
│  HERO METRICS (6 cards)                                             │
├─────────────────────────────────────────────────────────────────────┤
│  RANKING MOVEMENTS                                                  │
├─────────────────────────────────────────────────────────────────────┤
│  YOUR APPS (owned + watched)                                        │
├─────────────────────────────────────────────────────────────────────┤
│  RECENT REVIEWS                                                     │
├─────────────────────────────────────────────────────────────────────┤
│  ALERTS                                                             │
├─────────────────────────────────────────────────────────────────────┤
│  INSIGHTS (AI)                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 8.2 Header

```
┌─────────────────────────────────────────────────────────────────────┐
│  (logo) Keyrank      Apps ▾   Keywords   Reviews   Analytics        │
│                                                         🔔  ⚡  👤  │
└─────────────────────────────────────────────────────────────────────┘

- Logo: Click → Dashboard
- Apps: Dropdown avec liste apps + "View all"
- Keywords, Reviews, Analytics: Navigation principale
- 🔔 Notifications: Badge count si non-lues
- ⚡ Integrations: Quick access modal
- 👤 Profile: Settings, billing, logout
```

### 8.3 Hero Metrics

6 cartes avec les KPIs principaux. Données agrégées de toutes les apps **owned**.

| Carte | Valeur | Trend | Sparkline |
|-------|--------|-------|-----------|
| Total Apps | Count owned + watched | +N this month | — |
| Avg Rating | Moyenne pondérée | Δ vs période précédente | 30d trend |
| Keywords | Total tracked | N in top 10 | — |
| Downloads | Sum (owned only) | % change | 30d trend |
| Revenue | Sum (owned only) | % change | 30d trend |
| Reviews | Count (30d) | N need reply | Sentiment bar |

### 8.4 Ranking Movements

Split view : keywords qui montent vs qui descendent.

```
┌─────────────────────────────────────────────────────────────────────┐
│  📊 RANKING MOVEMENTS                              7d   30d   90d  │
├────────────────────────────────┬────────────────────────────────────┤
│  Keywords improving ↗          │  Keywords declining ↘             │
│  ───────────────────────────   │  ───────────────────────────      │
│  ↑ 23  photo editor       #5   │  ↓ 8   filter app          #34   │
│  ↑ 15  camera app         #8   │  ↓ 5   edit photos         #28   │
│  ↑ 12  selfie            #12   │  ↓ 3   portrait mode       #19   │
│  ↑ 8   beauty cam        #15   │                                   │
│                                │                                   │
│  [View all 156 keywords →]                                         │
└─────────────────────────────────────────────────────────────────────┘
```

### 8.5 Your Apps

Liste des apps avec mini-stats et sparklines.

```
┌─────────────────────────────────────────────────────────────────────┐
│  📱 YOUR APPS                                         [+ Add App]  │
├─────────────────────────────────────────────────────────────────────┤
│  OWNED (3)                                                         │
│  ───────────────────────────────────────────────────────────────── │
│  ┌─────┐                                                           │
│  │icon │  MyApp Pro                               iOS              │
│  │     │  ★ 4.7 (↗+0.1)   #8 photo   124K dl   $12.4K             │
│  │     │  ╱╲╱──╱╲ rank    ╱──╱╲╱ downloads                        │
│  └─────┘                                                           │
│  ─────────────────────────────────────────────────────────────────  │
│  ┌─────┐                                                           │
│  │icon │  MyApp Lite                              iOS              │
│  │     │  ★ 4.3 (↘-0.2)   #24 photo   89K dl    $2.1K             │
│  │     │  ╲╱╲──╱╲ rank    ╱╱──╱╲ downloads                        │
│  └─────┘                                                           │
├─────────────────────────────────────────────────────────────────────┤
│  WATCHING (5)                                    Public data only  │
│  ───────────────────────────────────────────────────────────────── │
│  ┌─────┐                                                           │
│  │icon │  VSCO                    🎯 competitor   iOS              │
│  │     │  ★ 4.7   #3 photo   ██████████ (estimated ~2M dl)        │
│  └─────┘                                                           │
│  ... (collapsed, expand to see more)                               │
└─────────────────────────────────────────────────────────────────────┘
```

### 8.6 Recent Reviews

Feed des derniers avis avec action rapide.

```
┌─────────────────────────────────────────────────────────────────────┐
│  💬 RECENT REVIEWS                               [View all →]      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ★★★★★  "Amazing app, love the new filters!"                       │
│  🇺🇸 US · 2h ago · MyApp Pro                           [Reply]     │
│  ─────────────────────────────────────────────────────────────────  │
│  ★★☆☆☆  "Crashes on iPhone 12, please fix"                         │
│  🇬🇧 UK · 5h ago · MyApp Lite              ⚠️ [Reply urgently]     │
│  ─────────────────────────────────────────────────────────────────  │
│  ★★★★☆  "Good but missing dark mode"                               │
│  🇫🇷 FR · 1d ago · MyApp Pro                           [Reply]     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

Indicateurs visuels :
- ⚠️ pour avis < 3 étoiles non répondus
- Badge "New" pour avis < 24h
- Icône 🤖 si réponse IA suggérée disponible

### 8.7 Alerts

Notifications actives basées sur les règles d'alerte.

```
┌─────────────────────────────────────────────────────────────────────┐
│  🔔 ALERTS                                    [Manage rules →]     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  🔴  MyApp Lite dropped below 4.0 rating in Germany                │
│      2h ago · Rating: 3.9 (was 4.1)                    [View]      │
│  ─────────────────────────────────────────────────────────────────  │
│  🟡  "photo editor" keyword lost 5+ positions                      │
│      6h ago · Position: #18 (was #12)                  [View]      │
│  ─────────────────────────────────────────────────────────────────  │
│  🟢  MyApp Pro reached #1 in Photography (France)                  │
│      1d ago · First time!                              [Share]     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

Couleurs :
- 🔴 Rouge : Problème critique (rating drop, ranking crash)
- 🟡 Orange : Attention requise (tendance négative)
- 🟢 Vert : Succès à célébrer (milestone atteint)

### 8.8 Insights (AI)

Panneau d'insights générés par l'IA.

```
┌─────────────────────────────────────────────────────────────────────┐
│  💡 INSIGHTS                                       This week ▾     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │  🎯 OPPORTUNITY                                               │ │
│  │                                                               │ │
│  │  "photo filters" is trending (+340% searches)                 │ │
│  │  You rank #89 — Competitors: VSCO #4, Snapseed #12           │ │
│  │                                                               │ │
│  │  → Consider optimizing your metadata for this keyword         │ │
│  │                                                               │ │
│  │  [Add to tracked]  [Dismiss]                                 │ │
│  └───────────────────────────────────────────────────────────────┘ │
│                                                                     │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │  ⚠️ ATTENTION                                                 │ │
│  │                                                               │ │
│  │  12 reviews mention "crash" this week (vs 2 last week)        │ │
│  │  Common: iPhone 15 Pro + iOS 17.2                            │ │
│  │                                                               │ │
│  │  [View reviews]  [Create bug ticket]                         │ │
│  └───────────────────────────────────────────────────────────────┘ │
│                                                                     │
│                                    [Ask AI a question... 💬]       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 9. Intelligence IA

### 9.1 Architecture 3 niveaux

```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│   NIVEAU 1: DÉTECTION AUTOMATIQUE (Background)                      │
│   ──────────────────────────────────────────────                    │
│   Tourne en continu, génère des événements                          │
│                                                                     │
│   • Anomalies statistiques (rankings, ratings, reviews)             │
│   • Pics inhabituels (positifs ou négatifs)                         │
│   • Changements chez les concurrents                                │
│   • Nouveaux keywords trending                                      │
│   • Corrélations (update app → reviews négatifs)                    │
│                                                                     │
│   Output: Events table → triggers alerts + insights                 │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   NIVEAU 2: INSIGHTS GÉNÉRÉS (Daily/Weekly batch)                   │
│   ──────────────────────────────────────────────────                │
│   Analyse périodique, résumés actionables                           │
│                                                                     │
│   • Weekly digest email                                             │
│   • Review sentiment synthesis                                      │
│   • Keyword opportunities                                           │
│   • Competitor analysis                                             │
│   • ASO Score & recommendations                                     │
│                                                                     │
│   Output: app_insights table → displayed in UI                      │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   NIVEAU 3: CHAT INTERACTIF (On-demand)                             │
│   ──────────────────────────────────────────────────                │
│   Questions libres sur les données                                  │
│                                                                     │
│   • "Pourquoi mon ranking a chuté ?"                               │
│   • "Quels keywords cibler en Allemagne ?"                         │
│   • "Résume les plaintes récurrentes"                              │
│   • "Compare ma performance vs VSCO"                               │
│                                                                     │
│   Output: Real-time response with citations                         │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 9.2 Pipeline de traitement

```
┌─────────────────────────────────────────────────────────────────────┐
│                      DATA ENRICHMENT PIPELINE                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  1. COLLECT (Collectors)                                           │
│     Raw data → rankings, ratings, reviews tables                   │
│                                                                     │
│  2. ENRICH (Background jobs, après collect)                        │
│     ├─ Reviews → Sentiment (positive/negative/neutral)             │
│     ├─ Reviews → Theme extraction (crash, price, feature, UI...)   │
│     ├─ Reviews → Language detection                                │
│     ├─ Rankings → Anomaly score (statistical deviation)            │
│     └─ Keywords → Trend classification (rising/stable/falling)     │
│                                                                     │
│  3. AGGREGATE (Daily job)                                          │
│     ├─ Daily summaries per app                                     │
│     ├─ Weekly/monthly rollups                                      │
│     └─ Comparison baselines (vs previous period)                   │
│                                                                     │
│  4. ANALYZE (Daily/Weekly job - LLM)                               │
│     ├─ Feed aggregated data to GPT-5-nano                          │
│     ├─ Prompt: "Generate actionable insights"                      │
│     └─ Store structured insights in app_insights                   │
│                                                                     │
│  5. NOTIFY (Event-driven)                                          │
│     ├─ High-priority insights → Push notification                  │
│     ├─ Weekly digest → Email                                       │
│     └─ Dashboard → Real-time update                                │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 9.3 Types d'insights

| Type | Icône | Trigger | Action suggérée |
|------|-------|---------|-----------------|
| `opportunity` | 🎯 | Keyword trending où user mal positionné | Add to tracked, optimize metadata |
| `warning` | ⚠️ | Anomalie négative (ranking drop, bad reviews) | Investigate, fix issue |
| `win` | 🏆 | Milestone atteint (top 10, best rating) | Celebrate, share |
| `competitor_move` | 👀 | Changement significatif chez concurrent | Analyze, react |
| `theme` | 💬 | Pattern dans les reviews | Address in update, reply |
| `suggestion` | 💡 | Recommandation ASO générale | Implement |

### 9.4 Chat IA - Architecture RAG

```
┌─────────────────────────────────────────────────────────────────────┐
│                         CHAT ARCHITECTURE                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  USER QUESTION                                                      │
│  "Why did my ranking drop last week?"                              │
│                                                                     │
│           ↓                                                        │
│                                                                     │
│  CONTEXT RETRIEVAL (RAG)                                           │
│  ├─ Extract entities: app, keyword, time period                    │
│  ├─ Fetch relevant data:                                           │
│  │   ├─ Rankings history (last 30 days)                           │
│  │   ├─ Reviews (last 30 days, esp. negative)                     │
│  │   ├─ Competitor rankings (same period)                         │
│  │   ├─ App updates/changes                                       │
│  │   └─ Related insights                                          │
│  └─ Format as structured context                                   │
│                                                                     │
│           ↓                                                        │
│                                                                     │
│  LLM CALL (GPT-5-nano)                                             │
│  ├─ System prompt: ASO expert, data analyst                       │
│  ├─ Context: Retrieved data                                       │
│  ├─ User question                                                  │
│  └─ Output format: Markdown with citations                        │
│                                                                     │
│           ↓                                                        │
│                                                                     │
│  RESPONSE                                                          │
│  ├─ Structured answer                                              │
│  ├─ Data citations (clickable links to charts/reviews)            │
│  └─ Suggested follow-up actions                                   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 9.5 Prompts système

#### Insight Generation Prompt

```
You are an ASO (App Store Optimization) expert analyzing app performance data.

Given the following data for the app "{{app_name}}":
- Rankings: {{rankings_summary}}
- Ratings: {{ratings_summary}}
- Reviews: {{reviews_summary}}
- Competitors: {{competitors_summary}}

Generate 2-4 actionable insights. Each insight must:
1. Have a clear type: opportunity, warning, win, competitor_move, theme, or suggestion
2. Be specific with numbers and dates
3. Include a recommended action
4. Be concise (max 3 sentences)

Output as JSON array:
[
  {
    "type": "opportunity",
    "title": "Short title",
    "description": "Detailed description with numbers",
    "action": "Recommended action",
    "priority": "high|medium|low",
    "data_refs": ["ranking:keyword_id:123", "review:456"]
  }
]
```

#### Chat System Prompt

```
You are Keyrank AI, an ASO expert assistant. You have access to the user's app data.

Your role:
- Answer questions about app performance, rankings, reviews
- Provide data-driven explanations (always cite specific numbers and dates)
- Suggest actionable improvements
- Compare with competitors when relevant

Guidelines:
- Be concise but thorough
- Always back claims with data from the context
- Use bullet points for readability
- Include relevant time periods
- Suggest follow-up actions

When you reference specific data, format as:
- Rankings: [View chart](#ranking:keyword_id)
- Reviews: [See review](#review:review_id)
- Ratings: [Rating details](#rating:country:date)
```

### 9.6 Coûts et optimisation

| Niveau | Modèle | Fréquence | Coût estimé |
|--------|--------|-----------|-------------|
| Enrichment (sentiment) | GPT-5-nano | Per review | ~$0.001/review |
| Insight generation | GPT-5-nano | Daily/app | ~$0.01/app/day |
| Chat | GPT-5-nano | On-demand | ~$0.005/question |

**Optimisations :**
- Cache des réponses chat pour questions similaires
- Batch processing pour enrichment (100 reviews/call)
- Skip enrichment si review trop court (< 10 mots)
- Rate limiting par user (100 questions/jour free tier)

---

## 10. Écrans & Navigation

### 10.1 Structure de navigation

```
┌─────────────────────────────────────────────────────────────────────┐
│                           NAVIGATION                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  HEADER (toujours visible)                                         │
│  ├─ Logo → Dashboard                                               │
│  ├─ Apps dropdown → App detail                                     │
│  ├─ Keywords → Keywords list                                       │
│  ├─ Reviews → Reviews inbox                                        │
│  ├─ Analytics → Analytics dashboard                                │
│  ├─ 🔔 Notifications                                               │
│  ├─ ⚡ Integrations (quick access)                                 │
│  └─ 👤 Profile menu                                                │
│                                                                     │
│  ÉCRANS PRINCIPAUX                                                 │
│  ├─ /dashboard                    Dashboard principal              │
│  ├─ /apps                         Liste des apps                   │
│  ├─ /apps/:id                     Détail app (tabs)                │
│  │   ├─ /apps/:id/overview        Vue d'ensemble                   │
│  │   ├─ /apps/:id/keywords        Keywords de l'app                │
│  │   ├─ /apps/:id/rankings        Historique rankings              │
│  │   ├─ /apps/:id/ratings         Ratings par pays                 │
│  │   ├─ /apps/:id/reviews         Reviews de l'app                 │
│  │   └─ /apps/:id/analytics       Analytics (si owned)             │
│  ├─ /keywords                     Tous les keywords                │
│  ├─ /keywords/:id                 Détail keyword                   │
│  ├─ /reviews                      Inbox reviews (toutes apps)      │
│  ├─ /analytics                    Analytics global                 │
│  ├─ /insights                     Tous les insights IA             │
│  ├─ /chat                         Chat IA                          │
│  ├─ /alerts                       Gestion des alertes              │
│  ├─ /competitors                  Analyse concurrents              │
│  └─ /top-charts                   Browse top charts                │
│                                                                     │
│  SETTINGS                                                          │
│  ├─ /settings/profile             Profil utilisateur               │
│  ├─ /settings/integrations        Connexions stores                │
│  ├─ /settings/notifications       Préférences notifs               │
│  ├─ /settings/billing             Plans et facturation             │
│  └─ /settings/team                Gestion équipe (future)          │
│                                                                     │
│  ONBOARDING                                                        │
│  ├─ /onboarding/welcome           Step 1                           │
│  ├─ /onboarding/connect           Step 2 - Connect stores          │
│  ├─ /onboarding/apps              Step 3 - Select apps             │
│  └─ /onboarding/setup             Step 4 - Quick setup             │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 10.2 Écrans détaillés

#### Dashboard (`/dashboard`)

Voir section 8.

#### App Detail (`/apps/:id`)

```
┌─────────────────────────────────────────────────────────────────────┐
│  ← Back to Apps                                                     │
│                                                                     │
│  ┌─────┐                                                           │
│  │icon │  MyApp Pro                                    iOS         │
│  │     │  by MyCompany                                             │
│  └─────┘  Photography · v3.2.1 · Updated 3 days ago                │
│                                                                     │
│  ┌─────────┬──────────┬─────────┬─────────┬───────────┐           │
│  │Overview │ Keywords │ Ratings │ Reviews │ Analytics │           │
│  └─────────┴──────────┴─────────┴─────────┴───────────┘           │
│                                                                     │
│  (Tab content here)                                                │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Tab: Overview**
- Hero metrics (rating, downloads, revenue, best keyword)
- Trend chart (sélecteur: ranking/downloads/revenue)
- Recent activity (reviews, ranking changes)
- Quick insights pour cette app

**Tab: Keywords**
- Liste keywords trackés avec sparklines
- Filtres: country, tag, position range
- Bulk actions: add, delete, tag
- Button: Add keywords

**Tab: Ratings**
- Rating trend chart
- Distribution ring chart
- Ratings by country table avec heatmap
- Historical comparison

**Tab: Reviews**
- Reviews list avec filtres
- Sentiment filter
- Reply status filter
- AI reply suggestions

**Tab: Analytics** (owned only)
- Downloads trend
- Revenue trend
- Conversion funnel
- Source breakdown
- Country breakdown

#### Keywords List (`/keywords`)

```
┌─────────────────────────────────────────────────────────────────────┐
│  Keywords                                      [+ Add Keywords]     │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ 🔍 Search keywords...              App: All ▾   Country: 🇺🇸 ▾│   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  156 keywords tracked                    Sort: Position ▾          │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Keyword          App          Pos   Δ7d   Vol    Diff     │   │
│  │  ─────────────────────────────────────────────────────────  │   │
│  │  photo editor     MyApp Pro    #5    ↑3    12.4K  Medium   │   │
│  │                                ╱╲╱──╱╲                      │   │
│  │  ─────────────────────────────────────────────────────────  │   │
│  │  camera app       MyApp Pro    #8    ↑2    8.2K   High     │   │
│  │                                ──╱╲╱─                       │   │
│  │  ─────────────────────────────────────────────────────────  │   │
│  │  ...                                                        │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

#### Reviews Inbox (`/reviews`)

```
┌─────────────────────────────────────────────────────────────────────┐
│  Reviews                                                            │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  All (89)  │  Needs Reply (12)  │  Negative (18)  │  Replied │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  App: All ▾    Country: All ▾    Rating: All ▾    Period ▾  │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  ★★★★★  5h ago · MyApp Pro · 🇺🇸 US                          │   │
│  │  "Amazing app! The new filters are beautiful and easy..."    │   │
│  │                                                              │   │
│  │  Sentiment: 😊 Positive   Themes: #filters #easy-to-use     │   │
│  │                                                              │   │
│  │  [Reply]  [🤖 AI Suggest]  [Dismiss]                        │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  ★★☆☆☆  1d ago · MyApp Lite · 🇬🇧 UK              ⚠️ Urgent │   │
│  │  "App keeps crashing when I try to export. Very frustrating" │   │
│  │                                                              │   │
│  │  Sentiment: 😤 Negative   Themes: #crash #export            │   │
│  │                                                              │   │
│  │  [Reply]  [🤖 AI Suggest]  [Mark as Bug]                    │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

#### Chat IA (`/chat`)

```
┌─────────────────────────────────────────────────────────────────────┐
│  🤖 Keyrank AI                                                 ✕   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Quick questions:                                           │   │
│  │  • Why did my ranking drop?                                 │   │
│  │  • What keywords should I target?                           │   │
│  │  • Summarize recent negative reviews                        │   │
│  │  • How am I doing vs competitors?                           │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  👤  Why did my ranking for "photo editor" drop last week?         │
│                                                                     │
│  🤖  I analyzed your data for "photo editor" (US). Here's what     │
│      I found:                                                      │
│                                                                     │
│      **Timeline:**                                                 │
│      • Jan 8: Position #5                                          │
│      • Jan 11: Dropped to #12 (-7 places)                         │
│      • Jan 13: Stabilized at #10                                  │
│                                                                     │
│      **Likely causes:**                                            │
│                                                                     │
│      1. **New competitor**: "PhotoLab AI" entered top 10 on        │
│         Jan 10 with aggressive ASA campaign [View competitor]      │
│                                                                     │
│      2. **Rating dip**: Your average dropped from 4.7 to 4.5       │
│         (8 negative reviews mentioning crashes) [View reviews]     │
│                                                                     │
│      **Recommendations:**                                          │
│      • Fix the crash bug (high priority)                          │
│      • Reply to negative reviews                                   │
│      • Consider defensive ASA campaign                            │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Ask a follow-up question...                            ↵   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

#### Integrations (`/settings/integrations`)

```
┌─────────────────────────────────────────────────────────────────────┐
│  Settings > Integrations                                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  CONNECTED                                                         │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  (Apple)  App Store Connect                    ✅ Connected │   │
│  │                                                             │   │
│  │  Team: MyCompany Inc.                                       │   │
│  │  Apps: 3 apps synced                                        │   │
│  │  Last sync: 2 hours ago                                     │   │
│  │                                                             │   │
│  │  [Refresh]  [Disconnect]                                   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  AVAILABLE                                                         │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  (Google)  Google Play Console               [Connect]      │   │
│  │  Access your Android apps, stats, and revenue               │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  (Apple)  Apple Search Ads                   [Connect]      │   │
│  │  Import keyword popularity and ad performance               │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  COMING SOON                                                       │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  (Mac)  Mac App Store                                              │
│  (TV)   Apple TV App Store                                         │
│  (Stripe) Stripe - Track in-app revenue                            │
│  (Slack) Slack - Get notifications                                 │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 11. Modèle de données

### 11.1 Tables principales

#### Users & Auth

```sql
-- Users
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    avatar_url VARCHAR(500),
    timezone VARCHAR(50) DEFAULT 'UTC',
    locale VARCHAR(10) DEFAULT 'en',
    onboarding_completed_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Integrations (store connections)
CREATE TABLE integrations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    type ENUM('app_store_connect', 'google_play_console', 'apple_search_ads', 'stripe', 'slack') NOT NULL,
    status ENUM('pending', 'active', 'error', 'revoked') DEFAULT 'pending',
    credentials JSON, -- Encrypted
    metadata JSON, -- Team name, account info
    last_sync_at TIMESTAMP NULL,
    error_message TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_type (user_id, type)
);
```

#### Apps

```sql
-- Apps
CREATE TABLE apps (
    id INT PRIMARY KEY AUTO_INCREMENT,
    store_id VARCHAR(50) NOT NULL, -- Apple ID or Play package
    platform ENUM('ios', 'android', 'macos', 'tvos') NOT NULL,
    name VARCHAR(255) NOT NULL,
    developer_name VARCHAR(255),
    icon_url VARCHAR(500),
    description TEXT,
    current_version VARCHAR(50),
    price DECIMAL(10, 2),
    currency VARCHAR(3),
    primary_category VARCHAR(100),
    content_rating VARCHAR(50),
    store_url VARCHAR(500),
    metadata_updated_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_store_platform (store_id, platform)
);

-- User-App relationship
CREATE TABLE user_apps (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    app_id INT NOT NULL,
    ownership_type ENUM('owned', 'watched') NOT NULL,
    integration_id INT NULL, -- If owned, link to integration
    tag VARCHAR(50) NULL, -- competitor, inspiration, benchmark, client
    is_favorite BOOLEAN DEFAULT FALSE,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (app_id) REFERENCES apps(id) ON DELETE CASCADE,
    FOREIGN KEY (integration_id) REFERENCES integrations(id) ON DELETE SET NULL,
    UNIQUE KEY unique_user_app (user_id, app_id)
);
```

#### Keywords & Rankings

```sql
-- Keywords
CREATE TABLE keywords (
    id INT PRIMARY KEY AUTO_INCREMENT,
    term VARCHAR(255) NOT NULL,
    platform ENUM('ios', 'android') NOT NULL,
    country_code VARCHAR(2) NOT NULL,
    search_popularity INT NULL, -- 5-100 from ASA
    difficulty_score INT NULL, -- 0-100 calculated
    difficulty_label ENUM('easy', 'medium', 'hard', 'very_hard') NULL,
    total_apps INT NULL, -- Apps in search results
    popularity_updated_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_keyword (term, platform, country_code)
);

-- Tracked keywords per user-app
CREATE TABLE tracked_keywords (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    app_id INT NOT NULL,
    keyword_id INT NOT NULL,
    is_favorite BOOLEAN DEFAULT FALSE,
    tags JSON, -- Array of tag names
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (app_id) REFERENCES apps(id) ON DELETE CASCADE,
    FOREIGN KEY (keyword_id) REFERENCES keywords(id) ON DELETE CASCADE,
    UNIQUE KEY unique_tracking (user_id, app_id, keyword_id)
);

-- Rankings history (partitioned by month)
CREATE TABLE app_rankings (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    app_id INT NOT NULL,
    keyword_id INT NOT NULL,
    position SMALLINT NULL, -- NULL = not in top 200
    recorded_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_app_keyword_date (app_id, keyword_id, recorded_at),
    INDEX idx_recorded_at (recorded_at)
) PARTITION BY RANGE (UNIX_TIMESTAMP(recorded_at)) (
    PARTITION p_2026_01 VALUES LESS THAN (UNIX_TIMESTAMP('2026-02-01')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- Rankings aggregates (weekly/monthly)
CREATE TABLE app_ranking_aggregates (
    id INT PRIMARY KEY AUTO_INCREMENT,
    app_id INT NOT NULL,
    keyword_id INT NOT NULL,
    period_type ENUM('weekly', 'monthly') NOT NULL,
    period_start DATE NOT NULL,
    avg_position DECIMAL(5, 2),
    best_position SMALLINT,
    worst_position SMALLINT,
    data_points INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_aggregate (app_id, keyword_id, period_type, period_start)
);
```

#### Ratings

```sql
-- Ratings history
CREATE TABLE app_ratings (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    app_id INT NOT NULL,
    country_code VARCHAR(2) NOT NULL,
    rating_average DECIMAL(3, 2), -- 1.00 to 5.00
    rating_count INT,
    rating_count_current_version INT NULL,
    rating_average_current_version DECIMAL(3, 2) NULL,
    recorded_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_app_country_date (app_id, country_code, recorded_at)
);

-- Ratings aggregates
CREATE TABLE app_rating_aggregates (
    id INT PRIMARY KEY AUTO_INCREMENT,
    app_id INT NOT NULL,
    country_code VARCHAR(2) NOT NULL,
    period_type ENUM('weekly', 'monthly') NOT NULL,
    period_start DATE NOT NULL,
    avg_rating DECIMAL(3, 2),
    total_ratings INT,
    new_ratings INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_aggregate (app_id, country_code, period_type, period_start)
);
```

#### Reviews

```sql
-- Reviews
CREATE TABLE app_reviews (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    app_id INT NOT NULL,
    store_review_id VARCHAR(100) NOT NULL,
    country_code VARCHAR(2) NOT NULL,
    author_name VARCHAR(255),
    rating TINYINT NOT NULL, -- 1-5
    title VARCHAR(500),
    body TEXT,
    app_version VARCHAR(50),
    device VARCHAR(100),
    os_version VARCHAR(50),
    review_date TIMESTAMP NOT NULL,
    -- Enrichment fields
    sentiment ENUM('positive', 'negative', 'neutral', 'mixed') NULL,
    sentiment_score DECIMAL(3, 2) NULL, -- -1.00 to 1.00
    themes JSON NULL, -- ["crash", "price", "feature_request"]
    language VARCHAR(10) NULL,
    enriched_at TIMESTAMP NULL,
    -- Reply tracking
    has_reply BOOLEAN DEFAULT FALSE,
    reply_text TEXT NULL,
    reply_date TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_review (app_id, store_review_id),
    INDEX idx_app_date (app_id, review_date),
    INDEX idx_sentiment (app_id, sentiment, review_date)
);
```

#### Analytics (Owned apps only)

```sql
-- Daily analytics
CREATE TABLE app_analytics (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    app_id INT NOT NULL,
    integration_id INT NOT NULL,
    country_code VARCHAR(2) NOT NULL,
    date DATE NOT NULL,
    -- Downloads
    downloads INT DEFAULT 0,
    updates INT DEFAULT 0,
    redownloads INT DEFAULT 0,
    -- Revenue
    revenue DECIMAL(12, 2) DEFAULT 0,
    iap_revenue DECIMAL(12, 2) DEFAULT 0,
    -- Subscriptions
    new_subscriptions INT DEFAULT 0,
    active_subscriptions INT DEFAULT 0,
    churned_subscriptions INT DEFAULT 0,
    -- Conversion
    impressions INT DEFAULT 0,
    page_views INT DEFAULT 0,
    conversion_rate DECIMAL(5, 4) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_analytics (app_id, country_code, date),
    INDEX idx_app_date (app_id, date)
);

-- Analytics aggregates
CREATE TABLE app_analytics_aggregates (
    id INT PRIMARY KEY AUTO_INCREMENT,
    app_id INT NOT NULL,
    country_code VARCHAR(2), -- NULL for global
    period_type ENUM('weekly', 'monthly') NOT NULL,
    period_start DATE NOT NULL,
    total_downloads INT,
    total_revenue DECIMAL(14, 2),
    avg_conversion_rate DECIMAL(5, 4),
    mrr DECIMAL(12, 2), -- Monthly recurring revenue
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_aggregate (app_id, country_code, period_type, period_start)
);
```

#### Insights & Alerts

```sql
-- AI-generated insights
CREATE TABLE app_insights (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    app_id INT NULL, -- NULL for cross-app insights
    type ENUM('opportunity', 'warning', 'win', 'competitor_move', 'theme', 'suggestion') NOT NULL,
    priority ENUM('high', 'medium', 'low') DEFAULT 'medium',
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    action_text VARCHAR(255),
    action_url VARCHAR(500),
    data_refs JSON, -- References to related data
    is_read BOOLEAN DEFAULT FALSE,
    is_dismissed BOOLEAN DEFAULT FALSE,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (app_id) REFERENCES apps(id) ON DELETE CASCADE,
    INDEX idx_user_unread (user_id, is_read, is_dismissed, generated_at)
);

-- Alert rules
CREATE TABLE alert_rules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    app_id INT NULL, -- NULL for all apps
    type ENUM('ranking_drop', 'ranking_gain', 'rating_drop', 'rating_gain', 'negative_review', 'keyword_opportunity') NOT NULL,
    threshold INT, -- e.g., 5 for "drop more than 5 positions"
    country_codes JSON, -- ["US", "UK"] or NULL for all
    is_enabled BOOLEAN DEFAULT TRUE,
    notify_push BOOLEAN DEFAULT TRUE,
    notify_email BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (app_id) REFERENCES apps(id) ON DELETE SET NULL
);

-- Alert notifications (triggered)
CREATE TABLE alert_notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    alert_rule_id INT NOT NULL,
    app_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    data JSON, -- Context data
    is_read BOOLEAN DEFAULT FALSE,
    triggered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (alert_rule_id) REFERENCES alert_rules(id) ON DELETE CASCADE,
    FOREIGN KEY (app_id) REFERENCES apps(id) ON DELETE CASCADE
);
```

#### Chat History

```sql
-- Chat conversations
CREATE TABLE chat_conversations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    app_id INT NULL, -- Context app if any
    title VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Chat messages
CREATE TABLE chat_messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    conversation_id INT NOT NULL,
    role ENUM('user', 'assistant') NOT NULL,
    content TEXT NOT NULL,
    context_data JSON NULL, -- RAG context used
    tokens_used INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversation_id) REFERENCES chat_conversations(id) ON DELETE CASCADE
);
```

### 11.2 Index stratégiques

```sql
-- Pour dashboard (apps d'un user avec dernières stats)
CREATE INDEX idx_user_apps_user ON user_apps(user_id, ownership_type);

-- Pour rankings movers (top changes)
CREATE INDEX idx_rankings_recent ON app_rankings(app_id, keyword_id, recorded_at DESC);

-- Pour reviews feed
CREATE INDEX idx_reviews_recent ON app_reviews(app_id, review_date DESC);
CREATE INDEX idx_reviews_needs_reply ON app_reviews(app_id, has_reply, rating, review_date);

-- Pour insights
CREATE INDEX idx_insights_active ON app_insights(user_id, is_dismissed, generated_at DESC);
```

---

## 12. API Endpoints

### 12.1 Authentication

```
POST   /api/auth/register          Register new user
POST   /api/auth/login             Login (returns token)
POST   /api/auth/logout            Logout (revoke token)
POST   /api/auth/forgot-password   Request password reset
POST   /api/auth/reset-password    Reset password with token
GET    /api/auth/me                Get current user
```

### 12.2 Integrations

```
GET    /api/integrations                    List user integrations
POST   /api/integrations/app-store-connect  Connect ASC (upload key)
POST   /api/integrations/google-play        Connect Play Console (upload JSON)
DELETE /api/integrations/:id                Disconnect integration
POST   /api/integrations/:id/refresh        Force refresh/resync
GET    /api/integrations/:id/apps           List apps from integration
```

### 12.3 Apps

```
GET    /api/apps                    List user apps (owned + watched)
POST   /api/apps                    Add app (search or from integration)
GET    /api/apps/:id                Get app details
PUT    /api/apps/:id                Update app (tag, favorite)
DELETE /api/apps/:id                Remove app from tracking
GET    /api/apps/:id/overview       Get overview stats
GET    /api/apps/:id/keywords       Get tracked keywords
GET    /api/apps/:id/rankings       Get ranking history
GET    /api/apps/:id/ratings        Get ratings by country
GET    /api/apps/:id/reviews        Get reviews
GET    /api/apps/:id/analytics      Get analytics (owned only)
GET    /api/apps/:id/insights       Get AI insights

GET    /api/apps/search             Search apps in stores
```

### 12.4 Keywords

```
GET    /api/keywords                List all tracked keywords
POST   /api/keywords                Add keyword(s) to tracking
DELETE /api/keywords/:id            Remove keyword
PUT    /api/keywords/:id            Update (favorite, tags)
GET    /api/keywords/:id/rankings   Get ranking history for keyword
GET    /api/keywords/:id/competitors Get top ranked apps for keyword

POST   /api/keywords/bulk           Bulk operations (add, delete, tag)
GET    /api/keywords/suggestions    Get keyword suggestions
GET    /api/keywords/trending       Get trending keywords in category
```

### 12.5 Reviews

```
GET    /api/reviews                 List reviews (all apps)
GET    /api/reviews/:id             Get review detail
POST   /api/reviews/:id/reply       Submit reply
GET    /api/reviews/:id/suggest-reply Get AI reply suggestion
PUT    /api/reviews/:id             Update (mark as read, bug, etc.)

GET    /api/reviews/stats           Get review stats (sentiment, themes)
```

### 12.6 Analytics

```
GET    /api/analytics/overview      Global analytics (all owned apps)
GET    /api/analytics/downloads     Downloads breakdown
GET    /api/analytics/revenue       Revenue breakdown
GET    /api/analytics/subscriptions Subscription metrics
GET    /api/analytics/countries     Country breakdown
```

### 12.7 Insights & Alerts

```
GET    /api/insights                List AI insights
PUT    /api/insights/:id            Mark as read/dismissed

GET    /api/alerts/rules            List alert rules
POST   /api/alerts/rules            Create alert rule
PUT    /api/alerts/rules/:id        Update rule
DELETE /api/alerts/rules/:id        Delete rule
GET    /api/alerts/notifications    List triggered alerts
PUT    /api/alerts/notifications/:id Mark as read
```

### 12.8 Chat

```
GET    /api/chat/conversations           List conversations
POST   /api/chat/conversations           Create new conversation
GET    /api/chat/conversations/:id       Get conversation with messages
POST   /api/chat/conversations/:id/messages Send message (returns AI response)
DELETE /api/chat/conversations/:id       Delete conversation
```

### 12.9 Dashboard

```
GET    /api/dashboard/metrics       Hero metrics (aggregated)
GET    /api/dashboard/movers        Ranking movers (up/down)
GET    /api/dashboard/reviews       Recent reviews
GET    /api/dashboard/alerts        Active alerts
GET    /api/dashboard/insights      Latest insights
```

### 12.10 Settings

```
GET    /api/settings/profile        Get profile
PUT    /api/settings/profile        Update profile
GET    /api/settings/notifications  Get notification prefs
PUT    /api/settings/notifications  Update notification prefs
GET    /api/settings/billing        Get billing info
POST   /api/settings/billing/subscribe Subscribe to plan
POST   /api/settings/billing/cancel    Cancel subscription
```

---

## 13. Jobs & Collectors

### 13.1 Liste des jobs

| Job | Schedule | Description | Priority |
|-----|----------|-------------|----------|
| `RankingsCollector` | */2h | Fetch rankings for all tracked keywords | Critical |
| `RatingsCollector` | */6h | Fetch ratings for all tracked apps/countries | High |
| `ReviewsCollector` | */4h | Fetch new reviews | High |
| `TopChartsCollector` | */6h | Fetch top charts by category | Medium |
| `MetadataCollector` | Daily 00:00 | Update app metadata | Low |
| `SalesCollector` | Daily 06:00 | Fetch sales/downloads (ASC/Play) | High |
| `PopularityCollector` | Daily 03:00 | Fetch keyword popularity (ASA) | Medium |
| `EnrichmentJob` | After ReviewsCollector | Sentiment + theme analysis | Medium |
| `InsightGeneratorJob` | Daily 08:00 | Generate AI insights | Medium |
| `AggregatorJob` | Daily 01:00 | Compute weekly/monthly aggregates | Low |
| `CleanupJob` | Weekly Sun 02:00 | Archive old data, clean partitions | Low |
| `WeeklyDigestJob` | Weekly Mon 09:00 | Send weekly digest emails | Low |

### 13.2 Architecture des collectors

```php
// Base collector structure
abstract class BaseCollector
{
    protected int $rateLimit = 300; // ms between requests
    protected int $batchSize = 50;
    protected int $maxRetries = 3;

    abstract public function collect(): void;
    abstract public function getItems(): Collection;
    abstract public function processItem($item): void;

    public function run(): void
    {
        $items = $this->getItems();

        foreach ($items->chunk($this->batchSize) as $batch) {
            foreach ($batch as $item) {
                try {
                    $this->processItem($item);
                    usleep($this->rateLimit * 1000);
                } catch (Exception $e) {
                    $this->handleError($item, $e);
                }
            }
        }

        $this->onComplete();
    }
}
```

### 13.3 RankingsCollector

```php
class RankingsCollector extends BaseCollector
{
    protected int $rateLimit = 200;

    public function getItems(): Collection
    {
        // Get unique (app_id, keyword_id) pairs across all users
        return TrackedKeyword::query()
            ->select('app_id', 'keyword_id')
            ->distinct()
            ->with(['keyword', 'app'])
            ->get();
    }

    public function processItem($item): void
    {
        $keyword = $item->keyword;
        $app = $item->app;

        // Search in store
        $results = match($app->platform) {
            'ios' => $this->iTunesService->search($keyword->term, $keyword->country_code, 200),
            'android' => $this->playService->search($keyword->term, $keyword->country_code, 200),
        };

        // Find app position
        $position = null;
        foreach ($results as $index => $result) {
            if ($result['store_id'] === $app->store_id) {
                $position = $index + 1;
                break;
            }
        }

        // Store ranking
        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => $position,
            'recorded_at' => now(),
        ]);

        // Update keyword difficulty
        $this->updateKeywordDifficulty($keyword, $results);
    }
}
```

### 13.4 EnrichmentJob

```php
class EnrichmentJob implements ShouldQueue
{
    public function handle(): void
    {
        // Get unenriched reviews
        $reviews = AppReview::query()
            ->whereNull('enriched_at')
            ->where('created_at', '>', now()->subDays(7))
            ->limit(100)
            ->get();

        if ($reviews->isEmpty()) return;

        // Batch process with LLM
        $prompt = $this->buildEnrichmentPrompt($reviews);
        $response = $this->llm->complete($prompt, 'gpt-5-nano');
        $enrichments = json_decode($response, true);

        // Update reviews
        foreach ($enrichments as $reviewId => $data) {
            AppReview::where('id', $reviewId)->update([
                'sentiment' => $data['sentiment'],
                'sentiment_score' => $data['score'],
                'themes' => $data['themes'],
                'language' => $data['language'],
                'enriched_at' => now(),
            ]);
        }
    }

    private function buildEnrichmentPrompt(Collection $reviews): string
    {
        return <<<PROMPT
        Analyze these app reviews and return JSON with sentiment and themes.

        Reviews:
        {$reviews->map(fn($r) => "ID {$r->id}: {$r->body}")->join("\n")}

        Return format:
        {
            "review_id": {
                "sentiment": "positive|negative|neutral|mixed",
                "score": -1.0 to 1.0,
                "themes": ["crash", "price", "feature", "ui", "performance", "ads", "other"],
                "language": "en|fr|de|..."
            }
        }
        PROMPT;
    }
}
```

### 13.5 InsightGeneratorJob

```php
class InsightGeneratorJob implements ShouldQueue
{
    public function handle(): void
    {
        $users = User::whereNotNull('onboarding_completed_at')->get();

        foreach ($users as $user) {
            $apps = $user->apps()->where('ownership_type', 'owned')->get();

            foreach ($apps as $userApp) {
                $context = $this->gatherContext($userApp->app);
                $insights = $this->generateInsights($user, $userApp->app, $context);

                foreach ($insights as $insight) {
                    AppInsight::create([
                        'user_id' => $user->id,
                        'app_id' => $userApp->app_id,
                        ...$insight,
                    ]);
                }
            }
        }
    }

    private function gatherContext(App $app): array
    {
        return [
            'rankings' => $this->getRankingsSummary($app),
            'ratings' => $this->getRatingsSummary($app),
            'reviews' => $this->getReviewsSummary($app),
            'competitors' => $this->getCompetitorsSummary($app),
        ];
    }

    private function generateInsights(User $user, App $app, array $context): array
    {
        $prompt = view('prompts.insight-generation', compact('app', 'context'))->render();
        $response = $this->llm->complete($prompt, 'gpt-5-nano');
        return json_decode($response, true);
    }
}
```

### 13.6 Monitoring des jobs

```sql
-- Job execution log
CREATE TABLE job_executions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    job_name VARCHAR(100) NOT NULL,
    status ENUM('running', 'completed', 'failed') NOT NULL,
    items_processed INT DEFAULT 0,
    items_failed INT DEFAULT 0,
    error_message TEXT NULL,
    started_at TIMESTAMP NOT NULL,
    completed_at TIMESTAMP NULL,
    duration_ms INT NULL
);
```

Dashboard admin pour visualiser :
- Dernier run de chaque job
- Taux de succès/échec
- Items traités
- Alertes si job en retard

---

## 14. Plans & Billing

### 14.1 Plans

| Feature | Free | Indie ($9/mo) | Pro ($29/mo) | Team ($79/mo) |
|---------|------|---------------|--------------|---------------|
| Apps (owned) | 1 | 5 | 20 | 50 |
| Apps (watched) | 3 | 10 | 30 | Unlimited |
| Keywords/app | 20 | 100 | 500 | 1000 |
| Countries | 3 | 10 | All | All |
| History | 30 days | 1 year | 2 years | Unlimited |
| AI Insights | Basic | Full | Full | Full |
| AI Chat | 10/mo | 100/mo | 500/mo | Unlimited |
| Integrations | — | ASC, Play | + ASA, Slack | + API |
| Team members | 1 | 1 | 3 | 10 |
| Export | — | CSV | CSV, PDF | + API |
| Support | Community | Email | Priority | Dedicated |

### 14.2 Implémentation Stripe

```php
// Plans table
CREATE TABLE plans (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    stripe_price_id VARCHAR(100) NOT NULL,
    price_monthly DECIMAL(10, 2) NOT NULL,
    limits JSON NOT NULL, -- {"apps_owned": 5, "keywords_per_app": 100, ...}
    features JSON NOT NULL, -- ["ai_insights", "priority_support", ...]
    is_active BOOLEAN DEFAULT TRUE
);

// Subscriptions
CREATE TABLE subscriptions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    plan_id INT NOT NULL,
    stripe_subscription_id VARCHAR(100),
    stripe_customer_id VARCHAR(100),
    status ENUM('active', 'past_due', 'canceled', 'trialing') NOT NULL,
    current_period_start TIMESTAMP,
    current_period_end TIMESTAMP,
    cancel_at_period_end BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (plan_id) REFERENCES plans(id)
);
```

### 14.3 Enforcement des limites

```php
class LimitEnforcer
{
    public function canAddApp(User $user, string $type): bool
    {
        $limits = $user->subscription->plan->limits;
        $current = $user->apps()->where('ownership_type', $type)->count();

        $limitKey = $type === 'owned' ? 'apps_owned' : 'apps_watched';
        return $current < $limits[$limitKey];
    }

    public function canAddKeyword(User $user, App $app): bool
    {
        $limits = $user->subscription->plan->limits;
        $current = TrackedKeyword::where('user_id', $user->id)
            ->where('app_id', $app->id)
            ->count();

        return $current < $limits['keywords_per_app'];
    }

    public function canUseChat(User $user): bool
    {
        $limits = $user->subscription->plan->limits;
        $thisMonth = ChatMessage::where('user_id', $user->id)
            ->where('role', 'user')
            ->where('created_at', '>=', now()->startOfMonth())
            ->count();

        return $thisMonth < $limits['chat_messages_monthly'];
    }
}
```

---

## 15. Plan d'implémentation

### Phase 0: Fondations (Semaines 1-2)

**Backend :**
- [ ] Refactor: Supprimer fetch on-demand des controllers
- [ ] Créer structure des collectors (base class + scheduling)
- [ ] Ajouter colonnes manquantes aux tables existantes
- [ ] Créer tables nouvelles (integrations, insights, chat, aggregates)
- [ ] Partitionnement des tables volumineuses
- [ ] Setup API App Store Connect (JWT auth)
- [ ] Setup API Google Play Console (Service Account)

**Frontend :**
- [ ] Supprimer les appels qui déclenchent des syncs
- [ ] Ajouter "last sync" indicator global
- [ ] Créer composants UI de base (MetricCard, ChangeIndicator, etc.)

### Phase 1: Onboarding & Intégrations (Semaines 3-4)

**Backend :**
- [ ] Endpoints CRUD integrations
- [ ] Flow validation App Store Connect
- [ ] Flow validation Google Play Console
- [ ] Auto-discovery apps depuis integrations
- [ ] Migration users existants (marquer ownership)

**Frontend :**
- [ ] Page /settings/integrations
- [ ] Modal connexion App Store Connect
- [ ] Modal connexion Google Play Console
- [ ] Onboarding wizard (4 steps)
- [ ] Header quick-access integrations
- [ ] Écran sélection apps post-connexion

### Phase 2: Dashboard & Visualisations (Semaines 5-7)

**Composants UI :**
- [ ] TrendChart (LineChart amélioré avec gradient)
- [ ] Sparkline (mini chart inline)
- [ ] RingChart (distribution ratings)
- [ ] HeatmapGrid (pays × keywords)
- [ ] ComparisonChart (overlay multi-séries)
- [ ] MetricCard (avec sparkline intégré)

**Dashboard :**
- [ ] Nouveau layout dashboard
- [ ] Section Hero Metrics (6 cards)
- [ ] Section Ranking Movements
- [ ] Section Your Apps (owned vs watched)
- [ ] Section Recent Reviews
- [ ] Section Alerts
- [ ] Animations et transitions

**App Detail :**
- [ ] Refonte tabs avec nouveaux charts
- [ ] Tab Overview avec insights
- [ ] Tab Ratings avec heatmap pays

### Phase 3: Deep Data Collection (Semaines 8-10)

**Collectors :**
- [ ] RankingsCollector (toutes les 2h)
- [ ] RatingsCollector (toutes les 6h)
- [ ] ReviewsCollector (toutes les 4h)
- [ ] TopChartsCollector (toutes les 6h)
- [ ] MetadataCollector (journalier)
- [ ] SalesCollector (ASC/Play, journalier)
- [ ] PopularityCollector (ASA, journalier)

**Infrastructure :**
- [ ] Queue worker setup (Redis)
- [ ] Retry logic et dead letter queue
- [ ] Monitoring dashboard admin
- [ ] Alerting si collector fail

**Aggregation :**
- [ ] AggregatorJob (weekly/monthly)
- [ ] Migration données historiques vers aggregates
- [ ] CleanupJob pour archivage

### Phase 4: Intelligence IA (Semaines 11-13)

**Enrichment :**
- [ ] EnrichmentJob (sentiment, themes)
- [ ] Anomaly detection (statistical)
- [ ] Trend classification

**Insights :**
- [ ] InsightGeneratorJob
- [ ] Table app_insights
- [ ] UI panneau Insights
- [ ] Types: opportunity, warning, win, theme
- [ ] Actions suggérées

**Chat :**
- [ ] Architecture RAG
- [ ] Context retrieval
- [ ] Endpoints chat
- [ ] UI chat modal/page
- [ ] Historique conversations

**Notifications :**
- [ ] Push notifications pour insights high priority
- [ ] WeeklyDigestJob + email template

### Phase 5: Polish & Scale (Semaines 14-16)

**Billing :**
- [ ] Intégration Stripe
- [ ] Plans table + logic
- [ ] Checkout flow
- [ ] Portail client Stripe
- [ ] Enforcement des limites
- [ ] Upgrade/downgrade flow

**Export & API :**
- [ ] Export CSV rankings/reviews
- [ ] Export PDF reports
- [ ] API publique (Pro+ plans)

**Performance :**
- [ ] Index optimization
- [ ] Query caching (Redis)
- [ ] CDN pour assets
- [ ] Load testing

**Cold Storage :**
- [ ] Migration données > 90 jours
- [ ] Requêtes sur cold storage
- [ ] UI pour accès historique

---

## 16. Métriques de succès

### 16.1 Product Metrics

| Métrique | Cible | Mesure |
|----------|-------|--------|
| Time-to-first-value | < 5 min | Temps onboarding → premier insight |
| DAU/MAU ratio | > 30% | Engagement quotidien |
| Features discovery | > 60% | % users qui utilisent 3+ features |
| AI chat usage | > 50% | % users qui posent 1+ question/semaine |
| NPS | > 50 | Survey trimestriel |

### 16.2 Technical Metrics

| Métrique | Cible | Alerte si |
|----------|-------|-----------|
| API response time (p95) | < 200ms | > 500ms |
| Collector success rate | > 99% | < 95% |
| Data freshness (rankings) | < 3h | > 6h |
| Error rate | < 0.1% | > 1% |
| Uptime | 99.9% | < 99.5% |

### 16.3 Business Metrics

| Métrique | Cible M6 | Cible M12 |
|----------|----------|-----------|
| Registered users | 1,000 | 5,000 |
| Paid subscribers | 100 | 500 |
| MRR | $1,500 | $8,000 |
| Churn rate | < 5%/mo | < 3%/mo |
| CAC | < $50 | < $30 |
| LTV | > $200 | > $300 |

---

## Annexes

### A. Références

- [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)
- [Google Play Developer API](https://developers.google.com/android-publisher)
- [Apple Search Ads API](https://developer.apple.com/documentation/apple_search_ads)
- [AppFigures](https://appfigures.com) - Référence design
- [fl_chart](https://pub.dev/packages/fl_chart) - Charts Flutter

### B. Glossaire

| Terme | Définition |
|-------|------------|
| ASO | App Store Optimization |
| ASC | App Store Connect |
| ASA | Apple Search Ads |
| MRR | Monthly Recurring Revenue |
| RAG | Retrieval-Augmented Generation |
| Owned app | App dont l'utilisateur est le développeur |
| Watched app | App suivie sans être propriétaire |

### C. Historique des révisions

| Date | Version | Changements |
|------|---------|-------------|
| 2026-01-11 | 1.0 | Version initiale |

---

*Document généré lors de la session de brainstorming du 11 janvier 2026.*
