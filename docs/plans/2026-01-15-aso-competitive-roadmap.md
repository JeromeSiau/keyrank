# Keyrank ASO Competitive Roadmap

> **Objectif**: Atteindre la parité fonctionnelle avec Astro, ASO.dev et Appfigures, puis les dépasser grâce à l'avantage AI.

**Date**: 15 janvier 2026
**Auteur**: Claude (analyse automatisée)
**Statut**: Draft - En attente de validation

---

## Table des Matières

1. [Analyse Concurrentielle](#1-analyse-concurrentielle)
2. [État Actuel de Keyrank](#2-état-actuel-de-keyrank)
3. [Gap Analysis](#3-gap-analysis)
4. [Phase 1: Quick Wins](#4-phase-1-quick-wins)
5. [Phase 2: Core Parity](#5-phase-2-core-parity)
6. [Phase 3: Différenciation AI](#6-phase-3-différenciation-ai)
7. [Phase 4: Enterprise](#7-phase-4-enterprise)
8. [Spécifications Techniques](#8-spécifications-techniques)
9. [Métriques de Succès](#9-métriques-de-succès)

---

## 1. Analyse Concurrentielle

### 1.1 Astro (tryastro.app)

**Points forts:**
- Keyword tracking illimité
- Base de données de millions de keywords indexés
- Difficulty scoring pour compétitivité de ranking
- Support de 60+ pays
- Intégration DeepL pour traductions
- Données de popularité directement d'Apple Search Ads
- Interface minimaliste et efficace

**Pricing:** Abonnement annuel fixe, pas de frais par keyword

**Claim marketing:** "90% des utilisateurs voient une augmentation des impressions dans la première semaine"

### 1.2 ASO.dev

**Points forts:**
- Tracking keywords toutes les 4h (vs quotidien chez d'autres)
- **Metadata Editor intégré** (killer feature)
- Bulk Editor pour modifications en masse
- Gestion screenshots et IAP
- Support des 39 locales iOS
- Auto-translation intégrée
- AI pour réponses aux reviews
- Custom Product Pages (A/B testing)
- Ads Intelligence (tracking pubs concurrents)
- 45+ features au total

**Faiblesse:** iOS uniquement

### 1.3 Appfigures

**Points forts:**
- Analytics universels (tous les stores)
- Consolidation données multi-stores
- Keyword research & tracking
- Competitor analysis approfondie
- 2.9B reviews trackées
- Apple Ads Intelligence
- SDK Intelligence
- Market Explorer
- API access pour automation

**Positionnement:** Plus analytics/market intelligence que pure ASO

### 1.4 Sensor Tower

**Points forts:**
- Usage insights avancés (sessions, time spent, retention)
- Digital advertising intelligence (Pathmatics)
- Gaming analytics spécialisés (Game IQ)
- Cross-platform (mobile + web)
- Corporate development & investment data

**Positionnement:** Enterprise, market intelligence, pas pure ASO tool

### 1.5 Tableau Comparatif

| Feature | Keyrank | Astro | ASO.dev | Appfigures |
|---------|:-------:|:-----:|:-------:|:----------:|
| Keyword tracking | ✅ | ✅ | ✅ | ✅ |
| Ranking history | ✅ | ✅ | ✅ | ✅ |
| Keyword difficulty | ❌ | ✅ | ✅ | ✅ |
| Keyword suggestions AI | ❌ | ✅ | ✅ | ❌ |
| **Metadata editor** | ❌ | ❌ | ✅ | ❌ |
| Multi-locale management | ❌ | ❌ | ✅ | ❌ |
| Auto-translation | ❌ | ✅ | ✅ | ❌ |
| Competitor tracking | ✅ | ✅ | ✅ | ✅ |
| Competitor keyword spy | ❌ | ✅ | ✅ | ✅ |
| Competitor metadata history | ❌ | ❌ | ❌ | ❌ |
| Reviews inbox | ✅ | ✅ | ✅ | ✅ |
| Review reply | ✅ | ✅ | ✅ | ✅ |
| AI review reply | ❌ | ❌ | ✅ | ❌ |
| Sentiment analysis | ✅ | ❌ | ✅ | ❌ |
| Ratings tracking | ✅ | ✅ | ✅ | ✅ |
| Analytics (downloads) | ✅ | ❌ | ❌ | ✅ |
| Analytics (revenue) | ✅ | ❌ | ❌ | ✅ |
| Conversion funnel | ❌ | ❌ | ❌ | ✅ |
| **AI Chat assistant** | ✅ | ❌ | ❌ | ❌ |
| **AI Insights** | ✅ | ❌ | ❌ | ❌ |
| Alerts customisables | ✅ | ✅ | ✅ | ✅ |
| Slack integration | ❌ | ❌ | ❌ | ✅ |
| Export CSV/PDF | ❌ | ✅ | ✅ | ✅ |
| Team management | ❌ | ❌ | ✅ | ✅ |
| API publique | ❌ | ❌ | ❌ | ✅ |
| iOS support | ✅ | ✅ | ✅ | ✅ |
| Android support | ✅ | ✅ | ❌ | ✅ |

**Légende:** ✅ Présent | ❌ Absent | 🟡 Partiel

---

## 2. État Actuel de Keyrank

### 2.1 Features Implémentées

#### Authentication & Onboarding
- Login/Register avec JWT
- Onboarding multi-étapes
- OAuth App Store Connect
- OAuth Google Play Console

#### Apps Management
- Ajout/suppression apps iOS et Android
- Recherche apps dans les stores
- Preview avant ajout
- Multi-app support

#### Keywords
- Tracking positions par pays
- Historique de ranking
- Popularité (Apple Search Ads)
- Tags et notes
- Recherche keywords
- Top charts par catégorie

#### Competitors
- Ajout competitors (global/contextual)
- Auto-discovery
- Vue liste basique

#### Reviews
- Inbox centralisée
- Filtres (unanswered, negative, rating)
- Reply to reviews
- Sentiment analysis
- Par pays

#### Ratings
- Tracking par pays
- Tendances (30/60/90 jours)
- Distribution par étoiles

#### Analytics
- Downloads
- Revenue
- Subscribers
- Country breakdown
- Sparklines

#### Alerts
- Rules custom
- Templates pré-définis
- Toggle on/off
- Push notifications (Firebase)

#### AI Features (AVANTAGE COMPÉTITIF)
- Insights par app (category scores, themes)
- Chat assistant multi-turn
- Suggested questions
- Comparaison insights multi-apps

#### Infrastructure
- 11 langues supportées
- Responsive (mobile/tablet/desktop)
- Material Design 3
- Dark mode

### 2.2 Architecture Technique

```
app/lib/
├── core/
│   ├── api/           # Dio + AuthInterceptor
│   ├── router/        # GoRouter + ShellRoute
│   ├── theme/         # Material 3 tokens
│   └── providers/     # Global state
├── features/          # 20 modules
│   ├── auth/
│   ├── apps/
│   ├── keywords/
│   ├── rankings/
│   ├── reviews/
│   ├── ratings/
│   ├── competitors/
│   ├── insights/
│   ├── analytics/
│   ├── alerts/
│   ├── notifications/
│   ├── chat/
│   ├── settings/
│   ├── integrations/
│   └── ...
└── shared/            # Widgets partagés
```

**Stack:**
- Flutter 3.x
- Riverpod 2.6+ (state management)
- Freezed (immutable models)
- GoRouter (navigation)
- Dio (HTTP)
- fl_chart (visualizations)
- Firebase Messaging (push)

---

## 3. Gap Analysis

### 3.1 Gaps Critiques (Must Have)

| Gap | Impact | Effort | Concurrent Reference |
|-----|--------|--------|---------------------|
| Metadata Editor | Users quittent pour ASO.dev | Élevé | ASO.dev |
| Keyword difficulty score | Feature ASO de base attendue | Faible | Astro, ASO.dev |
| Keyword suggestions AI | Différenciateur Astro | Moyen | Astro |
| Competitor keyword spy | Question #1 des users | Moyen | Tous |
| Export data (CSV/PDF) | Basique, souvent demandé | Faible | Tous |

### 3.2 Gaps Importants (Should Have)

| Gap | Impact | Effort | Concurrent Reference |
|-----|--------|--------|---------------------|
| AI review reply | Gain de temps énorme | Faible | ASO.dev |
| Auto-translation | Apps internationales | Moyen | ASO.dev, Astro |
| Conversion funnel | Prouver ROI | Moyen | Appfigures |
| Slack integration | Adoption équipe | Faible | Appfigures |
| Team management | Plans enterprise | Moyen | ASO.dev, Appfigures |
| Bulk keyword actions | Power users | Faible | ASO.dev |

### 3.3 Gaps Nice to Have

| Gap | Impact | Effort | Concurrent Reference |
|-----|--------|--------|---------------------|
| API publique | Agences, power users | Élevé | Appfigures |
| Webhooks | Custom integrations | Moyen | - |
| A/B test (CPP) | Optimisation avancée | Élevé | ASO.dev |
| SDK Intelligence | Niche | Élevé | Appfigures |

### 3.4 Opportunités de Différenciation

Keyrank a des features uniques à exploiter:

| Feature Unique | Potentiel | Action |
|----------------|-----------|--------|
| AI Chat | Très élevé | Ajouter actions exécutables |
| AI Insights | Élevé | Ajouter ASO Score + recommendations |
| Competitor metadata history | Personne ne l'a | Implémenter = différenciateur |

---

## 4. Phase 1: Quick Wins

> **Objectif:** Impact maximum, effort minimum. Livrable en 2-4 semaines.

### 4.1 ASO Score Global

**Description:**
Score de santé ASO de 0 à 100, calculé automatiquement, affiché sur Dashboard et Insights.

**User Stories:**
```
US-1.1: En tant qu'utilisateur, je veux voir un score ASO global pour mon app
        afin de comprendre rapidement ma performance.

US-1.2: En tant qu'utilisateur, je veux voir le breakdown du score par catégorie
        (metadata, keywords, reviews, ratings, competition) pour identifier
        les points faibles.

US-1.3: En tant qu'utilisateur, je veux voir l'évolution du score dans le temps
        pour mesurer mes progrès.
```

**Calcul du Score:**
```dart
class AsoScoreCalculator {
  int calculate(App app, Keywords keywords, Reviews reviews, Ratings ratings) {
    final metadataScore = _calculateMetadataScore(app);      // 0-25
    final keywordScore = _calculateKeywordScore(keywords);    // 0-25
    final reviewScore = _calculateReviewScore(reviews);       // 0-25
    final ratingScore = _calculateRatingScore(ratings);       // 0-25

    return metadataScore + keywordScore + reviewScore + ratingScore;
  }

  int _calculateMetadataScore(App app) {
    int score = 0;
    // Title utilise caractères max: +5
    if (app.title.length >= 25) score += 5;
    // Subtitle présent et optimisé: +5
    if (app.subtitle?.isNotEmpty ?? false) score += 5;
    // Description > 2000 chars: +5
    if (app.description.length >= 2000) score += 5;
    // Keywords field utilisé (iOS): +5
    if (app.keywords?.isNotEmpty ?? false) score += 5;
    // Localisations complètes: +5
    if (app.localizedMetadata.length >= 5) score += 5;
    return score;
  }

  int _calculateKeywordScore(Keywords keywords) {
    int score = 0;
    // Nombre keywords trackés: +5 si > 20
    if (keywords.count >= 20) score += 5;
    // % keywords dans top 10: +10 si > 30%
    final topTenPercent = keywords.inTopTen / keywords.count;
    if (topTenPercent >= 0.3) score += 10;
    // Tendance positive: +5
    if (keywords.averagePositionChange < 0) score += 5;
    // Couverture difficulty: +5
    if (keywords.hasDifficultyData) score += 5;
    return score;
  }

  int _calculateReviewScore(Reviews reviews) {
    int score = 0;
    // Sentiment > 70% positif: +10
    if (reviews.positiveSentimentPercent >= 70) score += 10;
    // Réponse rate > 50%: +10
    if (reviews.responseRate >= 0.5) score += 10;
    // Pas de spike négatif récent: +5
    if (!reviews.hasRecentNegativeSpike) score += 5;
    return score;
  }

  int _calculateRatingScore(Ratings ratings) {
    int score = 0;
    // Rating > 4.5: +15, > 4.0: +10, > 3.5: +5
    if (ratings.average >= 4.5) score += 15;
    else if (ratings.average >= 4.0) score += 10;
    else if (ratings.average >= 3.5) score += 5;
    // Tendance stable ou positive: +10
    if (ratings.trend >= 0) score += 10;
    return score;
  }
}
```

**UI - Dashboard Widget:**
```
┌─────────────────────────────────────┐
│  ASO Health Score                   │
│                                     │
│         78/100                      │
│    ████████████████░░░░             │
│         ↑ +3 vs last week           │
│                                     │
│  Metadata      ████████░░░░  62%    │
│  Keywords      █████████████  85%   │
│  Reviews       ██████████████ 91%   │
│  Ratings       ███████████░░  74%   │
│                                     │
│  [View Details →]                   │
└─────────────────────────────────────┘
```

**Fichiers à modifier:**
- `lib/features/dashboard/presentation/widgets/aso_score_widget.dart` (nouveau)
- `lib/features/dashboard/presentation/screens/dashboard_screen.dart`
- `lib/features/insights/domain/models/aso_score.dart` (nouveau)
- `lib/features/insights/data/insights_repository.dart`

**API Backend:**
```
GET /api/apps/{appId}/aso-score

Response:
{
  "score": 78,
  "breakdown": {
    "metadata": 62,
    "keywords": 85,
    "reviews": 91,
    "ratings": 74
  },
  "trend": {
    "change": 3,
    "period": "week"
  },
  "recommendations": [
    {
      "category": "metadata",
      "action": "Add keywords to subtitle",
      "impact": "+5 score"
    }
  ]
}
```

---

### 4.2 Keyword Difficulty Score

**Description:**
Afficher un score de difficulté 0-100 pour chaque keyword, basé sur la compétition.

**User Stories:**
```
US-2.1: En tant qu'utilisateur, je veux voir la difficulté de chaque keyword
        pour prioriser ceux où j'ai une chance de ranker.

US-2.2: En tant qu'utilisateur, je veux comprendre pourquoi un keyword est
        difficile (nombre de concurrents, force des concurrents).

US-2.3: En tant qu'utilisateur, je veux filtrer mes keywords par difficulté
        pour trouver les "easy wins".
```

**Calcul de la Difficulté:**
```dart
class KeywordDifficultyCalculator {
  /// Score 0-100, où 100 = très difficile
  int calculate({
    required int popularity,
    required int numberOfAppsRanking,
    required double averageRatingTopTen,
    required int averageReviewsTopTen,
  }) {
    // Facteur popularité (keywords populaires = plus compétitifs)
    final popularityFactor = (popularity / 100) * 30; // max 30 points

    // Facteur nombre de concurrents
    final competitorFactor = min(numberOfAppsRanking / 50, 1.0) * 25; // max 25

    // Facteur qualité top 10 (apps bien notées = dur à déloger)
    final qualityFactor = (averageRatingTopTen / 5) * 25; // max 25

    // Facteur reviews (apps avec beaucoup de reviews = établies)
    final reviewFactor = min(averageReviewsTopTen / 10000, 1.0) * 20; // max 20

    return (popularityFactor + competitorFactor + qualityFactor + reviewFactor).round();
  }
}
```

**UI - Keywords List:**
```
┌────────────────────────────────────────────────────────────────────┐
│ Keyword            │ Position │ Change │ Pop │ Difficulty │ Chance │
├────────────────────┼──────────┼────────┼─────┼────────────┼────────┤
│ budget tracker     │    #3    │   ↑2   │  52 │ 🟢 28 Easy │  High  │
│ expense manager    │    #8    │   ↓1   │  45 │ 🟠 54 Med  │  Med   │
│ money saving app   │   #23    │   ─    │  61 │ 🔴 78 Hard │  Low   │
└────────────────────────────────────────────────────────────────────┘

Filtres: [All] [🟢 Easy < 40] [🟠 Medium 40-70] [🔴 Hard > 70]
```

**Model Freezed:**
```dart
@freezed
class KeywordDifficulty with _$KeywordDifficulty {
  const factory KeywordDifficulty({
    required int score,
    required String level, // easy, medium, hard
    required int competitorCount,
    required double avgRatingTopTen,
    required int avgReviewsTopTen,
    @JsonKey(name: 'chance_of_top_ten') required String chanceOfTopTen,
  }) = _KeywordDifficulty;

  factory KeywordDifficulty.fromJson(Map<String, dynamic> json) =>
      _$KeywordDifficultyFromJson(json);
}
```

**Fichiers à modifier:**
- `lib/features/keywords/domain/models/keyword.dart` - ajouter difficulty
- `lib/features/keywords/presentation/widgets/keyword_list_item.dart`
- `lib/features/keywords/presentation/screens/keywords_screen.dart` - filtres
- `lib/features/keywords/providers/keywords_provider.dart`

---

### 4.3 Export CSV

**Description:**
Permettre l'export des données en CSV depuis Keywords, Analytics, Reviews.

**User Stories:**
```
US-3.1: En tant qu'utilisateur, je veux exporter mes keywords en CSV
        pour les analyser dans Excel ou les partager avec mon équipe.

US-3.2: En tant qu'utilisateur, je veux exporter mes analytics
        pour créer des rapports personnalisés.

US-3.3: En tant qu'utilisateur, je veux choisir les colonnes à exporter
        et la période de données.
```

**Implementation Flutter:**
```dart
class CsvExporter {
  Future<void> exportKeywords(List<Keyword> keywords, String filename) async {
    final csv = StringBuffer();

    // Header
    csv.writeln('Keyword,Position,Change,Popularity,Difficulty,Tags,Notes');

    // Data
    for (final kw in keywords) {
      csv.writeln([
        _escapeCsv(kw.keyword),
        kw.position,
        kw.change,
        kw.popularity,
        kw.difficulty?.score ?? '',
        _escapeCsv(kw.tags.map((t) => t.name).join(';')),
        _escapeCsv(kw.notes ?? ''),
      ].join(','));
    }

    await _saveFile(csv.toString(), filename);
  }

  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  Future<void> _saveFile(String content, String filename) async {
    if (kIsWeb) {
      // Web: download via browser
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // Mobile/Desktop: share ou save
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(content);
      await Share.shareFiles([file.path]);
    }
  }
}
```

**UI - Export Button:**
```
┌─────────────────────────────────────────┐
│  Export Keywords                    [X] │
├─────────────────────────────────────────┤
│                                         │
│  Format: [CSV ▼]                        │
│                                         │
│  Columns to include:                    │
│  [✓] Keyword                            │
│  [✓] Position                           │
│  [✓] Change                             │
│  [✓] Popularity                         │
│  [✓] Difficulty                         │
│  [ ] Tags                               │
│  [ ] Notes                              │
│  [ ] Ranking History (last 30 days)     │
│                                         │
│  [Cancel]              [Export]         │
│                                         │
└─────────────────────────────────────────┘
```

**Fichiers à créer:**
- `lib/core/utils/csv_exporter.dart`
- `lib/shared/widgets/export_dialog.dart`

**Fichiers à modifier:**
- `lib/features/keywords/presentation/screens/keywords_screen.dart`
- `lib/features/analytics/presentation/screens/analytics_screen.dart`
- `lib/features/reviews/presentation/screens/reviews_inbox_screen.dart`

---

### 4.4 AI Review Reply Generator

**Description:**
Générer automatiquement des suggestions de réponses aux reviews via l'AI.

**User Stories:**
```
US-4.1: En tant qu'utilisateur, je veux que l'AI me suggère une réponse
        à une review négative pour gagner du temps.

US-4.2: En tant qu'utilisateur, je veux choisir le ton de la réponse
        (professionnel, empathique, bref).

US-4.3: En tant qu'utilisateur, je veux pouvoir éditer la suggestion
        avant de l'envoyer.

US-4.4: En tant qu'utilisateur, je veux que la réponse soit générée
        dans la langue de la review originale.
```

**API Backend:**
```
POST /api/reviews/{reviewId}/generate-reply

Request:
{
  "tone": "professional", // professional, empathetic, brief
  "language": "fr" // auto-detect from review if not specified
}

Response:
{
  "suggestions": [
    {
      "tone": "professional",
      "content": "Merci pour votre retour. Nous avons identifié ce problème..."
    },
    {
      "tone": "empathetic",
      "content": "Nous sommes vraiment désolés pour ce désagrément..."
    },
    {
      "tone": "brief",
      "content": "Merci! Correctif en cours, mise à jour cette semaine."
    }
  ],
  "detected_issues": ["crash", "export"],
  "sentiment": "negative"
}
```

**UI - Review Reply:**
```
┌─────────────────────────────────────────────────────────────────────┐
│  ⭐⭐ Review from Jean-Pierre (France) • 2 days ago                 │
│                                                                     │
│  "L'app plante quand j'essaie d'exporter mes données. Très         │
│   frustrant car j'utilisais cette fonctionnalité tous les jours."  │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│  🤖 AI Suggested Replies                                            │
│                                                                     │
│  Tone: [Professional ▼]                                             │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ Merci pour votre retour, Jean-Pierre. Nous avons identifié  │   │
│  │ le problème d'export et notre équipe travaille activement   │   │
│  │ sur un correctif qui sera disponible dans la prochaine      │   │
│  │ mise à jour. Nous vous présentons nos excuses pour ce       │   │
│  │ désagrément.                                                 │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  [Regenerate] [Edit before sending]           [Send Reply]          │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Fichiers à créer:**
- `lib/features/reviews/presentation/widgets/ai_reply_generator.dart`
- `lib/features/reviews/domain/models/reply_suggestion.dart`

**Fichiers à modifier:**
- `lib/features/reviews/data/reviews_repository.dart`
- `lib/features/reviews/presentation/widgets/review_card.dart`

---

### 4.5 Email Alerts

**Description:**
Envoyer les alertes par email en plus des push notifications.

**User Stories:**
```
US-5.1: En tant qu'utilisateur, je veux recevoir mes alertes par email
        pour ne pas dépendre uniquement de mon téléphone.

US-5.2: En tant qu'utilisateur, je veux choisir quelles alertes
        vont par email vs push.

US-5.3: En tant qu'utilisateur, je veux recevoir un digest quotidien
        plutôt que des emails individuels.
```

**Settings UI:**
```
┌─────────────────────────────────────────────────────────────────────┐
│  Alert Delivery Settings                                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Email: jerome@example.com                    [Change]              │
│                                                                     │
│  DELIVERY METHOD                                                    │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                          │ Push │ Email │ Digest │          │   │
│  │ Critical alerts          │  ✓   │   ✓   │   -    │          │   │
│  │ Ranking changes          │  ✓   │   ○   │   ✓    │          │   │
│  │ New reviews              │  ○   │   ○   │   ✓    │          │   │
│  │ Rating changes           │  ✓   │   ✓   │   -    │          │   │
│  │ Competitor updates       │  ○   │   ○   │   ✓    │          │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  DIGEST SCHEDULE                                                    │
│  Daily digest at: [09:00 AM ▼]                                      │
│  Weekly summary: [Monday ▼] at [09:00 AM ▼]                         │
│                                                                     │
│  [Save Preferences]                                                 │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Model:**
```dart
@freezed
class AlertPreferences with _$AlertPreferences {
  const factory AlertPreferences({
    required String email,
    required Map<String, AlertDelivery> deliveryByType,
    required String digestTime,
    required String weeklyDigestDay,
  }) = _AlertPreferences;
}

@freezed
class AlertDelivery with _$AlertDelivery {
  const factory AlertDelivery({
    required bool push,
    required bool email,
    required bool digest,
  }) = _AlertDelivery;
}
```

**Backend:** Nécessite un service d'envoi d'emails (SendGrid, AWS SES, etc.)

---

### 4.6 Custom Date Range Picker

**Description:**
Permettre la sélection de dates personnalisées au lieu de juste 30/60/90 jours.

**User Stories:**
```
US-6.1: En tant qu'utilisateur, je veux sélectionner une période custom
        pour analyser une campagne spécifique.

US-6.2: En tant qu'utilisateur, je veux des presets rapides
        (Today, Yesterday, Last 7 days, This month, Last month, Custom).

US-6.3: En tant qu'utilisateur, je veux comparer deux périodes
        (cette semaine vs semaine dernière).
```

**UI Component:**
```dart
class DateRangePicker extends StatelessWidget {
  final DateTimeRange? selected;
  final ValueChanged<DateTimeRange> onChanged;

  // Presets
  static final presets = [
    ('Today', _today),
    ('Yesterday', _yesterday),
    ('Last 7 days', _last7Days),
    ('Last 30 days', _last30Days),
    ('This month', _thisMonth),
    ('Last month', _lastMonth),
    ('Last 90 days', _last90Days),
    ('Custom', null),
  ];
}
```

**UI:**
```
┌─────────────────────────────────────────┐
│  Date Range                         [▼] │
├─────────────────────────────────────────┤
│  ○ Today                                │
│  ○ Yesterday                            │
│  ○ Last 7 days                          │
│  ● Last 30 days                         │
│  ○ This month                           │
│  ○ Last month                           │
│  ○ Last 90 days                         │
│  ○ Custom...                            │
│    ┌─────────────┐  ┌─────────────┐     │
│    │ Jan 1, 2026 │→ │ Jan 15, 2026│     │
│    └─────────────┘  └─────────────┘     │
│                                         │
│  [ ] Compare to previous period         │
│                                         │
└─────────────────────────────────────────┘
```

**Fichiers à créer:**
- `lib/shared/widgets/date_range_picker.dart`

**Fichiers à modifier:**
- `lib/features/analytics/presentation/screens/analytics_screen.dart`
- `lib/features/analytics/providers/analytics_period_provider.dart`
- `lib/features/dashboard/presentation/screens/dashboard_screen.dart`
- `lib/features/ratings/presentation/screens/ratings_analysis_screen.dart`

---

## 5. Phase 2: Core Parity

> **Objectif:** Rattraper ASO.dev et Astro sur les features core.

### 5.1 Metadata Editor

**Description:**
Éditeur complet pour modifier les métadonnées de l'app directement depuis Keyrank.

**User Stories:**
```
US-7.1: En tant qu'utilisateur, je veux éditer le titre de mon app
        avec un compteur de caractères en temps réel.

US-7.2: En tant qu'utilisateur, je veux voir quels keywords trackés
        sont présents/absents dans mes métadonnées.

US-7.3: En tant qu'utilisateur, je veux sauvegarder des brouillons
        sans publier sur le store.

US-7.4: En tant qu'utilisateur, je veux publier mes changements
        directement sur App Store Connect / Google Play.

US-7.5: En tant qu'utilisateur, je veux voir l'historique de mes
        changements de métadonnées.
```

**Composants UI:**

#### 5.1.1 Title Editor
```
┌─────────────────────────────────────────────────────────────────────┐
│  APP NAME                                               27/30 ✓     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ Budget Tracker - Money Saver                                │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  Keyword Analysis:                                                  │
│  ✅ "budget tracker" (pop: 52, you: #3)                            │
│  ✅ "money saver" (pop: 45, you: #8)                               │
│  ⚠️  Missing: "expense" (pop: 38) - consider adding                │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

#### 5.1.2 Subtitle Editor (iOS)
```
┌─────────────────────────────────────────────────────────────────────┐
│  SUBTITLE                                               28/30 ✓     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ Expense Manager & Finance App                               │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  💡 Suggestions based on your tracked keywords:                     │
│  • "Spending Tracker & Budget Planner" (2 high-value keywords)     │
│  • "Personal Finance & Expense Log" (targets different searches)   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

#### 5.1.3 Keywords Field (iOS 100 chars)
```
┌─────────────────────────────────────────────────────────────────────┐
│  KEYWORDS (iOS)                                         89/100      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ budget,tracker,money,expense,finance,savings,wallet,spend,  │   │
│  │ planner,manager                                              │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  Optimization:                                                      │
│  ⚠️  "app" detected - low value, consider removing (saves 3 chars) │
│  ⚠️  "free" detected - already in title, redundant                 │
│  💡 Space for 11 more chars - suggestions:                          │
│     • "daily" (pop: 31) - 5 chars                                  │
│     • "bills" (pop: 28) - 5 chars                                  │
│                                                                     │
│  [Optimize Automatically]                                           │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

#### 5.1.4 Description Editor
```
┌─────────────────────────────────────────────────────────────────────┐
│  DESCRIPTION                                       2,847/4,000      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ Track your expenses and manage your budget with the #1      │   │
│  │ rated personal finance app.                                 │   │
│  │                                                             │   │
│  │ **FEATURES:**                                               │   │
│  │ • Automatic expense tracking                                │   │
│  │ • Budget goals and alerts                                   │   │
│  │ • Beautiful charts and reports                              │   │
│  │ • Bank sync (500+ banks supported)                          │   │
│  │ • Export to CSV and PDF                                     │   │
│  │ ...                                                         │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  Keyword Density:                                                   │
│  "budget": 5x ✓  "expense": 3x ✓  "tracker": 2x ✓  "money": 1x ⚠️  │
│                                                                     │
│  [Preview on App Store]                                             │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Models:**
```dart
@freezed
class AppMetadata with _$AppMetadata {
  const factory AppMetadata({
    required String locale,
    required String title,
    String? subtitle,
    String? keywords, // iOS only, comma-separated
    required String description,
    String? promotionalText,
    String? whatsNew,
    required MetadataStatus status,
    DateTime? lastPublished,
    DateTime? lastModified,
  }) = _AppMetadata;
}

enum MetadataStatus { live, draft, pendingReview }

@freezed
class MetadataAnalysis with _$MetadataAnalysis {
  const factory MetadataAnalysis({
    required int titleCharCount,
    required int titleMaxChars,
    required int subtitleCharCount,
    required int subtitleMaxChars,
    required int keywordsCharCount,
    required int keywordsMaxChars,
    required int descriptionCharCount,
    required int descriptionMaxChars,
    required List<KeywordPresence> keywordAnalysis,
    required List<String> suggestions,
    required List<String> warnings,
  }) = _MetadataAnalysis;
}

@freezed
class KeywordPresence with _$KeywordPresence {
  const factory KeywordPresence({
    required String keyword,
    required bool inTitle,
    required bool inSubtitle,
    required bool inKeywords,
    required bool inDescription,
    required int popularity,
    required int? currentPosition,
  }) = _KeywordPresence;
}
```

**API Endpoints:**
```
# Get current metadata for all locales
GET /api/apps/{appId}/metadata
Response: { "locales": [AppMetadata] }

# Update metadata (save draft)
PUT /api/apps/{appId}/metadata/{locale}
Request: { "title": "...", "subtitle": "...", ... }
Response: { "status": "draft", "analysis": MetadataAnalysis }

# Publish to store
POST /api/apps/{appId}/metadata/publish
Request: { "locales": ["en-US", "fr-FR"] }
Response: { "status": "pending_review", "submittedAt": "..." }

# Get metadata history
GET /api/apps/{appId}/metadata/history
Response: { "versions": [{ "locale": "...", "changes": [...], "date": "..." }] }
```

**App Store Connect API Integration:**
```dart
class AppStoreConnectService {
  final String apiKey;
  final String issuerId;
  final String privateKey;

  Future<void> updateAppInfo(String appId, AppMetadata metadata) async {
    // 1. Generate JWT token
    final token = _generateJwt();

    // 2. Get app info ID
    final appInfo = await _getAppInfo(appId, token);

    // 3. Update localization
    await _updateAppInfoLocalization(
      appInfo.id,
      metadata.locale,
      {
        'name': metadata.title,
        'subtitle': metadata.subtitle,
        'description': metadata.description,
        'keywords': metadata.keywords,
        'promotionalText': metadata.promotionalText,
      },
      token,
    );
  }
}
```

**Fichiers à créer:**
```
lib/features/metadata/
├── data/
│   ├── metadata_repository.dart
│   └── app_store_connect_service.dart
├── domain/
│   └── models/
│       ├── app_metadata.dart
│       ├── metadata_analysis.dart
│       └── keyword_presence.dart
├── presentation/
│   ├── screens/
│   │   ├── metadata_editor_screen.dart
│   │   └── metadata_history_screen.dart
│   └── widgets/
│       ├── title_editor.dart
│       ├── subtitle_editor.dart
│       ├── keywords_editor.dart
│       ├── description_editor.dart
│       ├── keyword_analysis_card.dart
│       └── char_counter.dart
└── providers/
    ├── metadata_provider.dart
    └── metadata_analysis_provider.dart
```

---

### 5.2 Multi-Locale View

**Description:**
Vue tableau de toutes les locales pour gérer les traductions efficacement.

**User Stories:**
```
US-8.1: En tant qu'utilisateur, je veux voir toutes mes locales
        dans un tableau pour identifier celles qui manquent.

US-8.2: En tant qu'utilisateur, je veux copier le contenu
        d'une locale vers une autre.

US-8.3: En tant qu'utilisateur, je veux voir le statut de chaque
        locale (live, draft, empty).
```

**UI:**
```
┌─────────────────────────────────────────────────────────────────────┐
│  🌍 Localizations                              [+ Add Locale]       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Filter: [All ▼]  [Show empty only]  [Show drafts only]            │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ Locale      │ Title           │ Subtitle      │ Status      │   │
│  │─────────────┼─────────────────┼───────────────┼─────────────│   │
│  │ 🇺🇸 en-US   │ Budget Track... │ Expense Ma... │ ✅ Live     │   │
│  │ 🇬🇧 en-GB   │ Budget Track... │ Expense Ma... │ ✅ Live     │   │
│  │ 🇫🇷 fr-FR   │ Suivi Budget... │ Gestion Dé... │ ✅ Live     │   │
│  │ 🇩🇪 de-DE   │ Budget Track... │ ⚠️ Empty      │ 📝 Draft    │   │
│  │ 🇪🇸 es-ES   │ ⚠️ Empty        │ ⚠️ Empty      │ ➖ Empty    │   │
│  │ 🇮🇹 it-IT   │ ⚠️ Empty        │ ⚠️ Empty      │ ➖ Empty    │   │
│  │ 🇯🇵 ja      │ 予算トラッカー... │ 支出管理...    │ ✅ Live     │   │
│  │ 🇰🇷 ko      │ 예산 추적기...   │ 지출 관리...   │ ✅ Live     │   │
│  │ 🇨🇳 zh-Hans │ 预算追踪器...    │ 费用管理...    │ ✅ Live     │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  Coverage: 6/9 locales (67%)                                        │
│  💡 Germany is your #3 market - consider localizing de-DE          │
│                                                                     │
│  Bulk Actions:                                                      │
│  [Copy en-US to selected] [Auto-translate selected] [Delete empty] │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

### 5.3 Keyword Suggestions AI

**Description:**
Recommandations intelligentes de keywords basées sur l'app, les concurrents et les tendances.

**User Stories:**
```
US-9.1: En tant qu'utilisateur, je veux des suggestions de keywords
        basées sur mon app et sa catégorie.

US-9.2: En tant qu'utilisateur, je veux voir les keywords de mes
        concurrents que je ne track pas.

US-9.3: En tant qu'utilisateur, je veux découvrir des long-tail
        keywords avec moins de compétition.

US-9.4: En tant qu'utilisateur, je veux voir les keywords trending
        dans ma catégorie.
```

**UI - Keyword Suggestions Panel:**
```
┌─────────────────────────────────────────────────────────────────────┐
│  🎯 Keyword Suggestions for "MyApp"                   [Refresh]     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Category: [All ▼]                                                  │
│  • High Opportunity    • Competitor Keywords    • Long-tail         │
│  • Trending            • Related to tracked                         │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  🔥 HIGH OPPORTUNITY (easy wins)                                    │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ Keyword              │ Pop │ Diff │ Competitor │ Action     │   │
│  │──────────────────────┼─────┼──────┼────────────┼────────────│   │
│  │ spending tracker     │  52 │  28  │ Mint: #4   │ [+ Track]  │   │
│  │ daily budget         │  41 │  22  │ YNAB: #6   │ [+ Track]  │   │
│  │ expense diary        │  38 │  19  │ -          │ [+ Track]  │   │
│  └─────────────────────────────────────────────────────────────┘   │
│  💡 These keywords have good popularity but low difficulty.         │
│     Your competitors rank for them - you should too.               │
│                                                                     │
│  👀 COMPETITOR KEYWORDS (they rank, you don't)                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ Keyword              │ Pop │ Who ranks        │ Action      │   │
│  │──────────────────────┼─────┼──────────────────┼─────────────│   │
│  │ bill reminder        │  45 │ Mint #2, YNAB #5 │ [+ Track]   │   │
│  │ subscription tracker │  39 │ Mint #3          │ [+ Track]   │   │
│  │ receipt scanner      │  36 │ Expensify #1     │ [+ Track]   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  🔤 LONG-TAIL SUGGESTIONS                                          │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ "budget tracker for couples"        Pop: 23  Diff: 12      │   │
│  │ "expense tracker with receipt"      Pop: 19  Diff: 15      │   │
│  │ "monthly budget planner app"        Pop: 21  Diff: 18      │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  [Track All Suggested] (15 keywords)                                │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Algorithm:**
```dart
class KeywordSuggestionEngine {
  Future<List<KeywordSuggestion>> getSuggestions(
    App app,
    List<Keyword> trackedKeywords,
    List<Competitor> competitors,
  ) async {
    final suggestions = <KeywordSuggestion>[];

    // 1. Competitor keyword analysis
    final competitorKeywords = await _getCompetitorKeywords(competitors);
    final missingKeywords = competitorKeywords
        .where((kw) => !trackedKeywords.any((t) => t.keyword == kw.keyword))
        .toList();

    // 2. Category-based suggestions
    final categoryKeywords = await _getCategoryKeywords(app.categoryId);

    // 3. Long-tail generation
    final longTail = _generateLongTail(trackedKeywords);

    // 4. Trending keywords
    final trending = await _getTrendingKeywords(app.categoryId);

    // 5. Score and rank all suggestions
    return _rankSuggestions([
      ...missingKeywords.map((k) => k.copyWith(source: 'competitor')),
      ...categoryKeywords.map((k) => k.copyWith(source: 'category')),
      ...longTail.map((k) => k.copyWith(source: 'long_tail')),
      ...trending.map((k) => k.copyWith(source: 'trending')),
    ]);
  }

  List<KeywordSuggestion> _generateLongTail(List<Keyword> tracked) {
    final modifiers = ['app', 'free', 'best', 'simple', 'easy', 'daily', 'monthly'];
    final suggestions = <KeywordSuggestion>[];

    for (final kw in tracked.take(10)) {
      for (final mod in modifiers) {
        suggestions.add(KeywordSuggestion(
          keyword: '$mod ${kw.keyword}',
          source: 'long_tail',
          basedOn: kw.keyword,
        ));
        suggestions.add(KeywordSuggestion(
          keyword: '${kw.keyword} $mod',
          source: 'long_tail',
          basedOn: kw.keyword,
        ));
      }
    }

    return suggestions;
  }
}
```

---

### 5.4 Competitor Keyword Spy

**Description:**
Voir tous les keywords pour lesquels un concurrent rank, avec comparaison directe.

**User Stories:**
```
US-10.1: En tant qu'utilisateur, je veux voir tous les keywords
         pour lesquels mon concurrent rank.

US-10.2: En tant qu'utilisateur, je veux voir où je rank vs
         mon concurrent pour chaque keyword.

US-10.3: En tant qu'utilisateur, je veux identifier les "gaps"
         (keywords où ils rankent mais pas moi).

US-10.4: En tant qu'utilisateur, je veux ajouter facilement
         les keywords de mes concurrents à mon tracking.
```

**UI - Competitor Keyword Analysis:**
```
┌─────────────────────────────────────────────────────────────────────┐
│  🔍 Keyword Analysis: MyApp vs CompetitorApp                        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  SUMMARY                                                            │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                                                             │   │
│  │   Total Keywords Analyzed: 156                              │   │
│  │                                                             │   │
│  │   ┌─────────┐    ┌─────────┐    ┌─────────┐               │   │
│  │   │ You Win │    │  Tied   │    │They Win │               │   │
│  │   │   47    │    │   23    │    │   86    │               │   │
│  │   │  (30%)  │    │  (15%)  │    │  (55%)  │               │   │
│  │   └─────────┘    └─────────┘    └─────────┘               │   │
│  │                                                             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  Filter: [All ▼] [You win] [They win] [Gaps] [Not tracking]        │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ Keyword              │ You  │ Them │ Gap │ Pop │ Action     │   │
│  │──────────────────────┼──────┼──────┼─────┼─────┼────────────│   │
│  │ budget tracker       │  #3  │  #7  │ +4  │  52 │ ✓ Tracking │   │
│  │ expense manager      │  #8  │  #4  │ -4  │  45 │ ✓ Tracking │   │
│  │ spending tracker     │  -   │  #4  │ gap │  52 │ [+ Track]  │   │
│  │ bill reminder        │  -   │  #2  │ gap │  45 │ [+ Track]  │   │
│  │ money saver          │  #5  │  #5  │  0  │  41 │ ✓ Tracking │   │
│  │ finance app          │ #12  │ #18  │ +6  │  38 │ ✓ Tracking │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  🎯 QUICK ACTIONS                                                   │
│  [Track all gaps (23)] [Export comparison] [Set up gap alerts]     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Keyword Overlap Matrix (multi-competitor):**
```
┌─────────────────────────────────────────────────────────────────────┐
│  📊 Keyword Overlap Matrix                                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│                    │ MyApp │ Mint │ YNAB │ PocketGuard │           │
│  ──────────────────┼───────┼──────┼──────┼─────────────┤           │
│  budget tracker    │   #3  │  #1  │  #5  │     #8      │           │
│  expense manager   │   #8  │  #2  │  #4  │     #6      │           │
│  spending tracker  │   -   │  #3  │  #7  │     -       │           │
│  bill reminder     │   -   │  #2  │  #1  │     #4      │           │
│  money manager     │  #12  │  #4  │  #3  │     #5      │           │
│  savings app       │   #6  │  #8  │  -   │     #2      │           │
│                                                                     │
│  Legend: #N = position, - = not ranking, highlighted = you win     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

### 5.5 Bulk Keyword Actions

**Description:**
Actions groupées sur plusieurs keywords (add, remove, tag, export).

**User Stories:**
```
US-11.1: En tant qu'utilisateur, je veux sélectionner plusieurs keywords
         et les supprimer en une fois.

US-11.2: En tant qu'utilisateur, je veux appliquer un tag à plusieurs
         keywords simultanément.

US-11.3: En tant qu'utilisateur, je veux ajouter plusieurs keywords
         depuis une liste (paste ou import).
```

**UI:**
```
┌─────────────────────────────────────────────────────────────────────┐
│  Keywords                                    12 selected            │
├─────────────────────────────────────────────────────────────────────┤
│  Bulk Actions: [Add Tag ▼] [Remove] [Export] [Add to Metadata]     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  [✓] Select all (156)                                               │
│                                                                     │
│  [✓] budget tracker        #3   ↑2   Pop: 52                       │
│  [✓] expense manager       #8   ↓1   Pop: 45                       │
│  [ ] money saver           #5   ─    Pop: 41                       │
│  [✓] spending tracker      #12  ↑3   Pop: 52                       │
│  ...                                                                │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Bulk Add from List:**
```
┌─────────────────────────────────────────────────────────────────────┐
│  Add Keywords in Bulk                                          [X]  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Paste keywords (one per line or comma-separated):                 │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ budget tracker                                              │   │
│  │ expense manager                                             │   │
│  │ money saver                                                 │   │
│  │ spending app                                                │   │
│  │ finance planner                                             │   │
│  │                                                             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  Or import from file: [Choose CSV file]                            │
│                                                                     │
│  Preview: 5 keywords detected                                       │
│  • 2 already tracking (will skip)                                  │
│  • 3 new keywords to add                                           │
│                                                                     │
│  Options:                                                           │
│  [✓] Skip duplicates                                               │
│  [ ] Apply tag: [Select tag ▼]                                     │
│                                                                     │
│  [Cancel]                                  [Add 3 Keywords]         │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

### 5.6 Conversion Funnel Analytics

**Description:**
Visualiser le funnel Impressions → Page Views → Downloads avec source attribution.

**User Stories:**
```
US-12.1: En tant qu'utilisateur, je veux voir mon taux de conversion
         à chaque étape du funnel.

US-12.2: En tant qu'utilisateur, je veux voir quelles sources
         (Search, Browse, Referral) convertissent le mieux.

US-12.3: En tant qu'utilisateur, je veux comparer mon funnel
         à la moyenne de ma catégorie.

US-12.4: En tant qu'utilisateur, je veux voir l'évolution de mon
         funnel dans le temps.
```

**Data Source:** App Store Connect Analytics API / Google Play Console API

**UI:**
```
┌─────────────────────────────────────────────────────────────────────┐
│  📈 Conversion Funnel                              Last 30 days ▼   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                                                             │   │
│  │  IMPRESSIONS           PAGE VIEWS            DOWNLOADS      │   │
│  │  ┌───────────┐        ┌───────────┐        ┌───────────┐   │   │
│  │  │  125,430  │   →    │   23,891  │   →    │   4,521   │   │   │
│  │  │           │        │   19.0%   │        │   18.9%   │   │   │
│  │  │           │        │  ↑ 2.3%   │        │  ↓ 0.8%   │   │   │
│  │  └───────────┘        └───────────┘        └───────────┘   │   │
│  │                                                             │   │
│  │  Overall CVR: 3.6% (Impressions → Downloads)               │   │
│  │  Category avg: 2.9%  ✅ You're 24% above average           │   │
│  │                                                             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  BY SOURCE                                                          │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ Source     │ Impressions │ Page Views │ Downloads │  CVR   │   │
│  │────────────┼─────────────┼────────────┼───────────┼────────│   │
│  │ 🔍 Search  │    77,767   │   16,712   │   3,729   │  4.8%  │   │
│  │ 📂 Browse  │    22,577   │    3,823   │     452   │  2.0%  │   │
│  │ 🔗 Referral│    13,797   │    2,159   │     271   │  2.0%  │   │
│  │ 📢 App Ads │    11,289   │    1,197   │      69   │  0.6%  │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  💡 INSIGHT: Search traffic converts 2.4x better than Browse.      │
│     Focus on keyword optimization to increase Search impressions.  │
│                                                                     │
│  FUNNEL TREND                                                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  CVR %                                                      │   │
│  │  5% ┤            ╭──╮                                       │   │
│  │  4% ┤     ╭─────╯  ╰───╮     ╭────                         │   │
│  │  3% ┤────╯              ╰───╯                               │   │
│  │  2% ┤                                                       │   │
│  │     └────┬────┬────┬────┬────┬────┬                        │   │
│  │         W1   W2   W3   W4   W5   W6                        │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Models:**
```dart
@freezed
class ConversionFunnel with _$ConversionFunnel {
  const factory ConversionFunnel({
    required int impressions,
    required int pageViews,
    required int downloads,
    required double impressionToPageViewRate,
    required double pageViewToDownloadRate,
    required double overallConversionRate,
    required double categoryAverageRate,
    required List<SourceConversion> bySource,
    required List<FunnelDataPoint> trend,
  }) = _ConversionFunnel;
}

@freezed
class SourceConversion with _$SourceConversion {
  const factory SourceConversion({
    required String source, // search, browse, referral, app_ads
    required int impressions,
    required int pageViews,
    required int downloads,
    required double conversionRate,
  }) = _SourceConversion;
}
```

---

## 6. Phase 3: Différenciation AI

> **Objectif:** Exploiter l'avantage AI pour dépasser les concurrents.

### 6.1 AI Optimization Wizard

**Description:**
Assistant guidé qui optimise les métadonnées étape par étape avec l'AI.

**User Stories:**
```
US-13.1: En tant qu'utilisateur, je veux être guidé step-by-step
         pour optimiser mes métadonnées.

US-13.2: En tant qu'utilisateur, je veux que l'AI me propose
         plusieurs variantes à choisir.

US-13.3: En tant qu'utilisateur, je veux voir l'impact estimé
         de chaque suggestion.
```

**Flow:**
```
Step 1: Title Optimization
   ↓
Step 2: Subtitle Optimization
   ↓
Step 3: Keywords Field (iOS)
   ↓
Step 4: Description Optimization
   ↓
Step 5: Review & Publish
```

**UI - Step 1 Example:**
```
┌─────────────────────────────────────────────────────────────────────┐
│  🧙 AI Optimization Wizard                                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Step 1 of 5: Title Optimization                                   │
│  ━━━━━━━━━━━━●━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━                      │
│                                                                     │
│  Current title: "Budget Tracker"                                   │
│  Character usage: 14/30 (47% - room for optimization!)             │
│                                                                     │
│  🤖 I analyzed:                                                     │
│  • Your top 5 competitors' titles                                  │
│  • Trending keywords in Finance category                           │
│  • Your current keyword rankings                                   │
│                                                                     │
│  Here are my suggestions:                                          │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ OPTION A (Recommended)                    Estimated: +15%   │   │
│  │                                           impressions       │   │
│  │ "Budget Tracker - Money Saver"                              │   │
│  │                                                             │   │
│  │ Why: Adds "money saver" (pop:45, you don't rank yet)       │   │
│  │ Characters: 27/30                                           │   │
│  │                                                  [Choose]   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ OPTION B                                  Estimated: +12%   │   │
│  │                                           impressions       │   │
│  │ "Budget Tracker: Expense Manager"                           │   │
│  │                                                             │   │
│  │ Why: "expense manager" (pop:38) targets different searches │   │
│  │ Characters: 30/30                                           │   │
│  │                                                  [Choose]   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ OPTION C                                  Estimated: +8%    │   │
│  │                                           impressions       │   │
│  │ "Budget & Expense Tracker App"                              │   │
│  │                                                             │   │
│  │ Why: Covers both "budget" and "expense" keywords           │   │
│  │ Characters: 28/30                                           │   │
│  │                                                  [Choose]   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  [Keep current title]  [Write my own]           [Skip this step]   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

### 6.2 Competitor Metadata History

**Description:**
Tracker et historiser tous les changements de métadonnées des concurrents.

**User Stories:**
```
US-14.1: En tant qu'utilisateur, je veux voir quand un concurrent
         a changé son titre/subtitle/description.

US-14.2: En tant qu'utilisateur, je veux comparer avant/après
         pour comprendre leur stratégie.

US-14.3: En tant qu'utilisateur, je veux être alerté quand
         un concurrent change ses métadonnées.
```

**Feature unique - personne ne l'a!**

**UI:**
```
┌─────────────────────────────────────────────────────────────────────┐
│  📜 Metadata History: CompetitorApp                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  TIMELINE                                                           │
│                                                                     │
│  🔵 Jan 10, 2026 - Title Changed                                   │
│  │  Before: "Budget Planner"                                       │
│  │  After:  "Budget Planner - Money Tracker & Savings"             │
│  │  Analysis: Added 2 keywords (money tracker, savings)            │
│  │                                                                  │
│  🔵 Dec 28, 2025 - Description Updated                             │
│  │  +324 characters added                                          │
│  │  New keywords detected: "AI-powered", "automatic categorization"│
│  │  [View full diff]                                               │
│  │                                                                  │
│  🔵 Dec 15, 2025 - Subtitle Changed                                │
│  │  Before: "Personal Finance App"                                 │
│  │  After:  "Expense Tracker & Bill Reminder"                      │
│  │  Analysis: Shifted focus to utility keywords                    │
│  │                                                                  │
│  🔵 Nov 20, 2025 - Keywords Field Updated (iOS)                    │
│  │  Removed: "free", "best", "top"                                 │
│  │  Added: "subscription", "recurring", "split"                    │
│  │                                                                  │
│                                                                     │
│  💡 INSIGHT: They've made 4 metadata changes in 2 months.          │
│     Their strategy appears to focus on utility-specific keywords.  │
│                                                                     │
│  [Set up alerts for this competitor]  [Export history]             │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Implementation:**
- Backend scrapes competitor app pages daily
- Stores metadata snapshots
- Computes diffs when changes detected
- Triggers alerts

---

### 6.3 Chat with Executable Actions

**Description:**
L'AI Chat peut exécuter des actions, pas juste donner des conseils.

**User Stories:**
```
US-15.1: En tant qu'utilisateur, je veux que l'AI ajoute un keyword
         à mon tracking quand je le demande.

US-15.2: En tant qu'utilisateur, je veux que l'AI crée une alerte
         basée sur ma demande en langage naturel.

US-15.3: En tant qu'utilisateur, je veux que l'AI modifie mes
         métadonnées après confirmation.
```

**Actions supportées:**
```dart
enum ChatAction {
  addKeyword,
  removeKeyword,
  createAlert,
  updateMetadata,
  addCompetitor,
  exportData,
  generateReport,
}
```

**UI:**
```
┌─────────────────────────────────────────────────────────────────────┐
│  💬 AI Assistant                                                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  👤 You:                                                            │
│  Add "spending tracker" to my keywords and alert me if I reach     │
│  top 10 for it                                                     │
│                                                                     │
│  🤖 Assistant:                                                      │
│                                                                     │
│  I'll do two things for you:                                       │
│                                                                     │
│  1. Add "spending tracker" to tracking                             │
│     ┌─────────────────────────────────────────┐                    │
│     │ Keyword: spending tracker               │                    │
│     │ Current popularity: 52                  │                    │
│     │ Difficulty: 28 (Easy)                   │                    │
│     │ Your current position: Not ranking      │                    │
│     └─────────────────────────────────────────┘                    │
│     [✓ Confirm Add]  [Cancel]                                      │
│                                                                     │
│  2. Create alert rule                                              │
│     ┌─────────────────────────────────────────┐                    │
│     │ When: "spending tracker" reaches top 10 │                    │
│     │ Notify via: Push + Email                │                    │
│     └─────────────────────────────────────────┘                    │
│     [✓ Confirm Alert]  [Modify]  [Cancel]                          │
│                                                                     │
│  ────────────────────────────────────────────────────────────────  │
│  │ What else can I help with?                              [Send]│  │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

### 6.4 Review Intelligence Dashboard

**Description:**
Dashboard dédié à l'analyse intelligente des reviews avec extraction automatique.

**User Stories:**
```
US-16.1: En tant qu'utilisateur, je veux voir automatiquement
         les feature requests extraites des reviews.

US-16.2: En tant qu'utilisateur, je veux voir les bugs reportés
         regroupés par type.

US-16.3: En tant qu'utilisateur, je veux voir l'impact de chaque
         version sur le sentiment des reviews.
```

**UI:**
```
┌─────────────────────────────────────────────────────────────────────┐
│  🧠 Review Intelligence                            Last 30 days ▼   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  FEATURE REQUESTS (AI-extracted)                    23 total       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ #1  "Dark mode"                           15 mentions       │   │
│  │     "Please add dark mode" "Need night mode" "Eyes hurt"   │   │
│  │     Priority: HIGH (frequently requested)                   │   │
│  │     [View all mentions] [Mark as planned]                   │   │
│  │                                                             │   │
│  │ #2  "Widget support"                      11 mentions       │   │
│  │     "Home screen widget please" "iOS widget would be great"│   │
│  │     Priority: HIGH                                          │   │
│  │     [View all mentions] [Mark as planned]                   │   │
│  │                                                             │   │
│  │ #3  "Export to PDF"                       8 mentions        │   │
│  │     "Need PDF export" "Can't share reports"                │   │
│  │     Priority: MEDIUM                                        │   │
│  │     [View all mentions] [Mark as planned]                   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  BUG REPORTS (AI-extracted)                         12 total       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ 🐛 "Crash on launch"          8 reports    iOS 17.2+        │   │
│  │ 🐛 "Sync not working"         3 reports    After v2.3.1     │   │
│  │ 🐛 "Notification issues"      1 report     Android 14       │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  SENTIMENT BY VERSION                                               │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ v2.3.1  ██████████████░░░░░░  71%  ↓ from 89%  ⚠️ ALERT    │   │
│  │ v2.3.0  ████████████████████  89%  ← best release          │   │
│  │ v2.2.0  █████████████████░░░  78%                          │   │
│  │ v2.1.0  ███████████████░░░░░  71%                          │   │
│  └─────────────────────────────────────────────────────────────┘   │
│  💡 v2.3.1 caused sentiment drop - check crash reports above      │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 7. Phase 4: Enterprise

> **Objectif:** Features pour justifier un pricing premium et conquérir les équipes.

### 7.1 Team Management

**Description:**
Gestion multi-utilisateurs avec rôles et permissions.

**Roles:**
```dart
enum TeamRole {
  owner,    // Full access, billing, delete workspace
  admin,    // Full access except billing
  editor,   // Can modify apps, keywords, metadata
  viewer,   // Read-only access
}

class RolePermissions {
  static const Map<TeamRole, List<Permission>> permissions = {
    TeamRole.owner: [Permission.all],
    TeamRole.admin: [
      Permission.manageApps,
      Permission.manageKeywords,
      Permission.editMetadata,
      Permission.manageAlerts,
      Permission.manageCompetitors,
      Permission.inviteMembers,
      Permission.viewAnalytics,
      Permission.exportData,
    ],
    TeamRole.editor: [
      Permission.manageApps,
      Permission.manageKeywords,
      Permission.editMetadata,
      Permission.manageAlerts,
      Permission.viewAnalytics,
    ],
    TeamRole.viewer: [
      Permission.viewApps,
      Permission.viewKeywords,
      Permission.viewAnalytics,
      Permission.exportData,
    ],
  };
}
```

**UI:** (voir Section 9 Settings plus haut)

---

### 7.2 Slack Integration

**Description:**
Envoyer les alertes et rapports dans Slack.

**Features:**
- OAuth Slack connection
- Channel selection per alert type
- Rich message formatting
- Interactive buttons (snooze, view details)

**Slack Message Format:**
```
┌─────────────────────────────────────────────────────────────────────┐
│ 🔔 Keyrank Alert                                                    │
│                                                                     │
│ *Rating dropped below 4.0*                                         │
│ App: MyApp                                                         │
│ Country: United States                                             │
│ New rating: 3.9 (was 4.1)                                          │
│                                                                     │
│ [View in Keyrank]  [Snooze 1 week]  [Check reviews]                │
└─────────────────────────────────────────────────────────────────────┘
```

---

### 7.3 Scheduled PDF Reports

**Description:**
Rapports automatiques PDF envoyés par email.

**Report Types:**
- Weekly Summary (rankings, reviews, ratings)
- Monthly Performance (analytics, trends, insights)
- Competitor Report (position comparison)
- Custom Report (choose metrics)

**UI - Report Builder:**
```
┌─────────────────────────────────────────────────────────────────────┐
│  📊 Scheduled Reports                            [+ New Report]     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ACTIVE REPORTS                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ Weekly Performance Summary                                  │   │
│  │ Every Monday at 9:00 AM → jerome@example.com               │   │
│  │ Includes: Rankings, Reviews, Ratings, Insights             │   │
│  │ [Edit] [Preview] [Pause] [Delete]                          │   │
│  │                                                             │   │
│  │ Monthly Stakeholder Report                                  │   │
│  │ 1st of month at 9:00 AM → team@company.com                 │   │
│  │ Includes: Analytics, Trends, Competitor Comparison         │   │
│  │ [Edit] [Preview] [Pause] [Delete]                          │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

### 7.4 Public API

**Description:**
API REST pour accès programmatique aux données.

**Endpoints:**
```
# Authentication
POST /api/v1/auth/token

# Apps
GET  /api/v1/apps
GET  /api/v1/apps/{id}
GET  /api/v1/apps/{id}/keywords
GET  /api/v1/apps/{id}/rankings
GET  /api/v1/apps/{id}/reviews
GET  /api/v1/apps/{id}/ratings
GET  /api/v1/apps/{id}/analytics

# Keywords
GET  /api/v1/keywords/search
GET  /api/v1/keywords/{id}/history

# Competitors
GET  /api/v1/competitors
GET  /api/v1/competitors/{id}/keywords

# Webhooks
POST /api/v1/webhooks
GET  /api/v1/webhooks
DELETE /api/v1/webhooks/{id}
```

**Rate Limits:**
- Free: 100 requests/day
- Pro: 1,000 requests/day
- Enterprise: 10,000 requests/day

---

### 7.5 Webhooks

**Description:**
Envoyer des events à des endpoints custom.

**Events disponibles:**
```dart
enum WebhookEvent {
  rankingChanged,
  newReview,
  ratingChanged,
  alertTriggered,
  competitorMetadataChanged,
  keywordTrending,
}
```

**Payload example:**
```json
{
  "event": "ranking_changed",
  "timestamp": "2026-01-15T10:30:00Z",
  "data": {
    "app_id": 123,
    "app_name": "MyApp",
    "keyword": "budget tracker",
    "old_position": 5,
    "new_position": 3,
    "country": "US"
  }
}
```

---

## 8. Spécifications Techniques

### 8.1 Nouvelles Dépendances Flutter

```yaml
dependencies:
  # Export
  csv: ^5.0.0
  pdf: ^3.10.0
  share_plus: ^7.0.0

  # Rich text editing
  flutter_quill: ^8.0.0

  # Date picking
  syncfusion_flutter_datepicker: ^24.0.0

  # Charts (déjà présent)
  fl_chart: ^0.66.0

  # Slack OAuth
  flutter_appauth: ^6.0.0
```

### 8.2 Nouveaux Endpoints API Backend

```
# ASO Score
GET /api/apps/{appId}/aso-score

# Metadata
GET /api/apps/{appId}/metadata
PUT /api/apps/{appId}/metadata/{locale}
POST /api/apps/{appId}/metadata/publish
GET /api/apps/{appId}/metadata/history

# Keyword Suggestions
GET /api/keywords/suggestions/{appId}
GET /api/keywords/difficulty/{keyword}

# Competitor Intelligence
GET /api/competitors/{id}/keywords
GET /api/competitors/{id}/metadata-history

# Conversion Funnel
GET /api/analytics/{appId}/funnel

# AI Features
POST /api/reviews/{id}/generate-reply
POST /api/chat/execute-action

# Team
GET /api/team/members
POST /api/team/invite
PUT /api/team/members/{id}/role
DELETE /api/team/members/{id}

# Integrations
POST /api/integrations/slack
DELETE /api/integrations/slack
POST /api/webhooks
GET /api/webhooks
DELETE /api/webhooks/{id}

# Reports
GET /api/reports
POST /api/reports
PUT /api/reports/{id}
DELETE /api/reports/{id}
POST /api/reports/{id}/generate
```

### 8.3 Structure des Nouveaux Modules

```
lib/features/
├── metadata/                 # NEW - Phase 2
│   ├── data/
│   │   ├── metadata_repository.dart
│   │   └── app_store_connect_service.dart
│   ├── domain/models/
│   │   ├── app_metadata.dart
│   │   ├── metadata_analysis.dart
│   │   └── keyword_presence.dart
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── metadata_editor_screen.dart
│   │   │   ├── multi_locale_screen.dart
│   │   │   └── metadata_history_screen.dart
│   │   └── widgets/
│   │       ├── title_editor.dart
│   │       ├── subtitle_editor.dart
│   │       ├── keywords_field_editor.dart
│   │       ├── description_editor.dart
│   │       ├── char_counter.dart
│   │       └── keyword_analysis_card.dart
│   └── providers/
│       ├── metadata_provider.dart
│       └── metadata_analysis_provider.dart
│
├── team/                     # NEW - Phase 4
│   ├── data/team_repository.dart
│   ├── domain/models/
│   │   ├── team_member.dart
│   │   └── team_invitation.dart
│   ├── presentation/
│   │   ├── screens/team_management_screen.dart
│   │   └── widgets/
│   │       ├── member_list.dart
│   │       ├── invite_dialog.dart
│   │       └── role_selector.dart
│   └── providers/team_provider.dart
│
├── reports/                  # NEW - Phase 4
│   ├── data/reports_repository.dart
│   ├── domain/models/
│   │   ├── scheduled_report.dart
│   │   └── report_config.dart
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── reports_screen.dart
│   │   │   └── report_builder_screen.dart
│   │   └── widgets/
│   │       └── report_preview.dart
│   └── providers/reports_provider.dart
│
└── webhooks/                 # NEW - Phase 4
    ├── data/webhooks_repository.dart
    ├── domain/models/webhook.dart
    ├── presentation/
    │   └── screens/webhooks_screen.dart
    └── providers/webhooks_provider.dart
```

---

## 9. Métriques de Succès

### 9.1 KPIs par Phase

**Phase 1 - Quick Wins:**
| Métrique | Baseline | Target | Mesure |
|----------|----------|--------|--------|
| Feature usage (ASO Score) | 0% | 70% | % users qui voient le score |
| Export usage | 0% | 30% | % users qui exportent/mois |
| AI Reply usage | 0% | 40% | % reviews répondues via AI |

**Phase 2 - Core Parity:**
| Métrique | Baseline | Target | Mesure |
|----------|----------|--------|--------|
| Metadata Editor usage | 0% | 50% | % users actifs mensuels |
| Keyword suggestions added | 0 | 5/user/month | Keywords ajoutés via suggestions |
| Churn reduction | X% | X-20% | Réduction du churn |

**Phase 3 - Différenciation:**
| Métrique | Baseline | Target | Mesure |
|----------|----------|--------|--------|
| AI Wizard completion | 0% | 60% | % users qui terminent le wizard |
| Chat actions executed | 0 | 3/user/month | Actions via chat |
| NPS improvement | X | X+15 | Net Promoter Score |

**Phase 4 - Enterprise:**
| Métrique | Baseline | Target | Mesure |
|----------|----------|--------|--------|
| Team accounts | 0% | 20% | % comptes avec >1 membre |
| Enterprise plan upgrades | 0 | 50 | Nouveaux plans enterprise |
| API usage | 0 | 100 clients | Clients utilisant l'API |

### 9.2 Competitive Benchmarks

| Critère | Actuellement | Après Phase 2 | Après Phase 4 |
|---------|--------------|---------------|---------------|
| Feature parity vs Astro | 65% | 90% | 100% |
| Feature parity vs ASO.dev | 55% | 95% | 100% |
| Feature parity vs Appfigures | 50% | 75% | 95% |
| Unique AI features | 2 | 5 | 8 |

---

## 10. Conclusion

### Résumé des Priorités

1. **Metadata Editor** - Feature #1 manquante, différenciateur ASO.dev
2. **ASO Score + Actions** - Transformer data en guidance actionnable
3. **Keyword Intelligence** - Difficulty, suggestions, competitor spy
4. **AI Enhancement** - Wizard, executable chat, review intelligence
5. **Enterprise Features** - Team, Slack, API pour plans premium

### Avantage Compétitif Final

Après implémentation complète:
- **vs Astro**: Parité + AI supérieur + Metadata editor
- **vs ASO.dev**: Parité + AI supérieur + Android support
- **vs Appfigures**: Parité fonctionnelle + AI différenciateur + UX moderne

### Risques et Mitigations

| Risque | Probabilité | Impact | Mitigation |
|--------|-------------|--------|------------|
| App Store Connect API changes | Moyenne | Élevé | Abstraction layer, monitoring |
| AI costs scalability | Moyenne | Moyen | Quotas, caching, model optimization |
| Competitor copy features | Haute | Faible | Continuous innovation, UX focus |

---

*Document généré le 15 janvier 2026*
*Version: 1.0 - Draft*
