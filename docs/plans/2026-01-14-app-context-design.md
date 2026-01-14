# Design : Contexte App Global

**Date** : 2026-01-14
**Statut** : Validé

## Résumé

Ajout d'un système de contexte app global permettant de filtrer tous les écrans pour une app spécifique via un dropdown persistant. Simplifie la navigation en supprimant les routes avec ID et la section Apps de la sidebar.

## Motivation

Actuellement, les écrans globaux (Dashboard, Reviews, Ratings) montrent des données agrégées sans possibilité de filtrer par app. L'utilisateur doit naviguer vers `/apps/{id}` pour voir les données d'une app spécifique, ce qui crée une rupture dans l'expérience.

## Solution

### Concept

Un dropdown en haut de la sidebar permet de sélectionner :
- "Toutes les apps" (défaut) → écrans en mode agrégé
- Une app spécifique → écrans filtrés pour cette app

### Changements UX

| Avant | Après |
|-------|-------|
| Sidebar liste les apps | Sidebar liste uniquement les écrans |
| Routes `/apps/{id}/keywords` | Routes simples `/keywords` |
| Écrans globaux = agrégat fixe | Écrans adaptables selon contexte |
| Sélection app via navigation | Sélection app via dropdown |

## Spécifications

### 1. Composant App Switcher

**Position** : En haut de la sidebar (desktop) / En haut du drawer (mobile)

**Structure visuelle (fermé)**
```
┌──────────────────────┐
│ [icon] MonApp      ▼ │
└──────────────────────┘
```

**Structure visuelle (ouvert)**
```
┌──────────────────────┐
│ ○ Toutes les apps    │
├──────────────────────┤
│ Favorites            │
│ ● [icon] MonApp      │  ← Sélectionnée
│ ○ [icon] AutreApp    │
├──────────────────────┤
│ iPhone               │
│ ○ [icon] AppIOS1     │
├──────────────────────┤
│ Android              │
│ ○ [icon] AppAndroid1 │
├──────────────────────┤
│ ⚙ Gérer les apps     │
└──────────────────────┘
```

**Comportement**
- Clic ouvre le menu déroulant
- Sélection change le contexte immédiatement
- L'écran courant se rafraîchit avec les données filtrées
- "Gérer les apps" navigue vers `/apps/manage`

### 2. Layout

**Desktop**
```
┌──────────────────────┬─────────────────────────────┐
│ SIDEBAR              │                             │
│                      │                             │
│ ┌──────────────────┐ │                             │
│ │ [icon] MonApp ▼  │ │      CONTENU ÉCRAN          │
│ └──────────────────┘ │                             │
│                      │                             │
│ Dashboard            │                             │
│ Keywords             │                             │
│ Reviews              │                             │
│ Ratings              │                             │
│ Insights             │                             │
│ Analytics            │                             │
│ ──────────────────── │                             │
│ Discover             │                             │
│ Top Charts           │                             │
└──────────────────────┴─────────────────────────────┘
```

**Mobile**
```
┌─────────────────────────────┐
│ ☰  Dashboard      [avatar] │  ← Header avec burger
├─────────────────────────────┤
│                             │
│      CONTENU ÉCRAN          │
│                             │
├─────────────────────────────┤
│ 🏠  📊  ⭐  📈  ⚙          │  ← Bottom nav
└─────────────────────────────┘

Drawer ouvert :
┌──────────────────────┐
│ ┌──────────────────┐ │
│ │ [icon] MonApp ▼  │ │  ← Switcher en haut
│ └──────────────────┘ │
│                      │
│ Dashboard            │
│ Keywords             │
│ ...                  │
└──────────────────────┘
```

### 3. Routes

**Nouvelles routes**
```
/dashboard
/keywords
/reviews
/ratings
/insights
/analytics
/discover
/top-charts
/apps/manage    # Gestion des apps
/apps/add       # Ajouter une app
```

**Routes supprimées**
```
/apps/{id}
/apps/{id}/keywords
/apps/{id}/insights
/apps/{id}/analytics
/apps/{id}/ratings
/apps/{id}/reviews/{country}
```

### 4. Architecture State

**Provider central**
```dart
final appContextProvider = StateNotifierProvider<AppContextNotifier, AppModel?>((ref) {
  return AppContextNotifier(ref);
});

class AppContextNotifier extends StateNotifier<AppModel?> {
  AppContextNotifier(this.ref) : super(null) {
    _loadPersistedContext();
  }

  final Ref ref;

  void select(AppModel? app) {
    state = app;
    _persistIfEnabled(app);
  }

  void clear() => select(null);

  Future<void> _loadPersistedContext() async {
    final shouldRemember = ref.read(rememberAppContextSettingProvider);
    if (!shouldRemember) return;

    final prefs = await SharedPreferences.getInstance();
    final appId = prefs.getInt('app_context_id');
    if (appId != null) {
      final apps = ref.read(appsNotifierProvider).valueOrNull ?? [];
      state = apps.firstWhereOrNull((a) => a.id == appId);
    }
  }

  Future<void> _persistIfEnabled(AppModel? app) async {
    final shouldRemember = ref.read(rememberAppContextSettingProvider);
    if (!shouldRemember) return;

    final prefs = await SharedPreferences.getInstance();
    if (app != null) {
      await prefs.setInt('app_context_id', app.id);
    } else {
      await prefs.remove('app_context_id');
    }
  }
}
```

**Providers data adaptés**
```dart
// Exemple : keywords
final keywordsProvider = FutureProvider<List<Keyword>>((ref) {
  final app = ref.watch(appContextProvider);
  return ref.read(keywordsRepository).getKeywords(appId: app?.id);
});
```

**Setting de persistance**
```dart
final rememberAppContextSettingProvider = StateProvider<bool>((ref) => false);
```

### 5. Écrans dual-mode

Chaque écran adapte son affichage selon le contexte.

**Pattern d'implémentation**
```dart
class KeywordsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedApp = ref.watch(appContextProvider);
    final keywords = ref.watch(keywordsProvider);

    return keywords.when(
      data: (list) => selectedApp == null
          ? KeywordsTableMultiApp(keywords: list)   // Colonne "App" visible
          : KeywordsTableSingleApp(keywords: list), // Sans colonne "App"
      loading: () => LoadingIndicator(),
      error: (e, _) => ErrorWidget(e),
    );
  }
}
```

**Différences par mode**

| Mode | Header | Tableau | Actions |
|------|--------|---------|---------|
| Toutes les apps | "Keywords (toutes)" | Colonne App + tri | Actions groupées |
| App sélectionnée | "Keywords - MonApp" | Sans colonne App | Actions directes |

**Écrans concernés**
- `DashboardScreen` : Métriques agrégées vs métriques de l'app
- `KeywordsScreen` : Liste multi-app vs liste filtrée
- `ReviewsScreen` : Reviews de toutes les apps vs une app
- `RatingsScreen` : Idem
- `InsightsScreen` : Insights agrégés vs par app
- `AnalyticsScreen` : Analytics agrégés vs par app

**Écrans non affectés (toujours globaux)**
- `DiscoverScreen` : Recherche d'apps à ajouter
- `TopChartsScreen` : Charts globaux du store
- `AppsManageScreen` : Gestion du portfolio

### 6. Migration API

Les endpoints backend doivent supporter `app_id` optionnel :

```
GET /api/keywords              → Toutes les apps
GET /api/keywords?app_id=123   → Filtrées pour l'app 123

GET /api/reviews               → Toutes les apps
GET /api/reviews?app_id=123    → Filtrées

# Idem pour : /ratings, /insights, /analytics, /dashboard/metrics
```

## Implémentation

### Fichiers à créer

- `app/lib/core/providers/app_context_provider.dart`
- `app/lib/core/widgets/app_context_switcher.dart`

### Fichiers à modifier

- `app/lib/core/router/app_router.dart` - Simplifier les routes
- `app/lib/core/widgets/responsive_shell.dart` - Intégrer le switcher
- `app/lib/features/*/providers/*.dart` - Utiliser `appContextProvider`
- `app/lib/features/*/presentation/*_screen.dart` - Mode dual

### Fichiers à supprimer

- Composants `SidebarAppsList` et widgets de listing d'apps dans la sidebar
- Routes `/apps/{id}/*` dans le router

### Setting à ajouter

- "Se souvenir de l'app sélectionnée" (bool, défaut: false)

## Questions résolues

| Question | Décision |
|----------|----------|
| Position du switcher | Haut de la sidebar (desktop) / drawer (mobile) |
| Routes avec ID | Supprimées, tout via contexte |
| Mode sans app | Vue multi-app avec colonne "App" |
| Section Apps sidebar | Supprimée |
| Gestion des apps | Via "Gérer les apps" dans le dropdown |
| Persistance | Setting utilisateur (on/off) |
| URLs partageables | Non, contexte local uniquement |
