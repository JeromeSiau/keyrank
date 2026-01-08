# Sidebar Favorites Design

## Context

Réorganisation UX de la sidebar pour rendre les apps accessibles directement sans surcharger l'interface quand l'utilisateur a beaucoup d'apps.

## Solution retenue

Direction "Smart Groups" avec:
- Section **Favoris** en haut (apps épinglées)
- Groupes **iPhone** / **Android** collapsibles pour les autres apps
- Navigation sections existantes (OVERVIEW, RESEARCH) conservées en dessous

## Décisions

| Question | Choix |
|----------|-------|
| Stockage favoris | Backend (pivot `user_apps`) |
| Limite favoris | Douce (~5), warning visuel au-delà |
| Groupement non-favoris | Par plateforme (iOS/Android) |
| Action toggle favori | Étoile au hover (sidebar) + bouton dans page détail |
| Scroll | Hauteur max par section, scroll interne si dépassement |

## Backend

### Migration

```php
// database/migrations/xxxx_add_favorite_to_user_apps.php
Schema::table('user_apps', function (Blueprint $table) {
    $table->boolean('is_favorite')->default(false);
    $table->timestamp('favorited_at')->nullable();
});
```

### Endpoint

```
PATCH /api/apps/{id}/favorite
Body: { "is_favorite": true|false }
Response: { "is_favorite": true, "favorited_at": "2026-01-08T..." }
```

### AppController

Ajouter méthode `toggleFavorite($id)`:
- Update pivot `user_apps` pour le user courant
- Set `favorited_at` si `is_favorite = true`, sinon `null`

### Réponse GET /api/apps

Ajouter `is_favorite` et `favorited_at` dans chaque app retournée.
Ordre: favoris d'abord (par `favorited_at`), puis alphabétique.

## Flutter

### AppModel

```dart
class AppModel {
  final int id;
  final String platform;
  final String storeId;
  final String name;
  final String iconUrl;
  final String developer;
  final double? rating;
  final int? ratingCount;
  final String storefront;
  final int trackedKeywordsCount;
  final bool isFavorite; // NEW

  AppModel copyWith({bool? isFavorite, ...});
}
```

### Provider

```dart
// Nouveau provider dérivé pour la sidebar
final sidebarAppsProvider = Provider<SidebarApps>((ref) {
  final apps = ref.watch(appsNotifierProvider);
  return apps.when(
    data: (list) => SidebarApps(
      favorites: list.where((a) => a.isFavorite).toList(),
      iosList: list.where((a) => !a.isFavorite && a.platform == 'ios').toList(),
      androidList: list.where((a) => !a.isFavorite && a.platform == 'android').toList(),
    ),
    loading: () => SidebarApps.empty(),
    error: (_, __) => SidebarApps.empty(),
  );
});

class SidebarApps {
  final List<AppModel> favorites;
  final List<AppModel> iosList;
  final List<AppModel> androidList;

  SidebarApps({required this.favorites, required this.iosList, required this.androidList});

  factory SidebarApps.empty() => SidebarApps(favorites: [], iosList: [], androidList: []);

  bool get hasTooManyFavorites => favorites.length > 5;
}
```

### Repository

```dart
Future<void> toggleFavorite(int appId, bool isFavorite) async {
  await _client.patch('/api/apps/$appId/favorite', data: {
    'is_favorite': isFavorite,
  });
}
```

### AppsNotifier

Ajouter méthode:

```dart
Future<void> toggleFavorite(int appId) async {
  final currentApps = state.value ?? [];
  final app = currentApps.firstWhere((a) => a.id == appId);
  final newValue = !app.isFavorite;

  // Optimistic update
  state = AsyncData(currentApps.map((a) =>
    a.id == appId ? a.copyWith(isFavorite: newValue) : a
  ).toList());

  try {
    await _repository.toggleFavorite(appId, newValue);
  } catch (e) {
    // Rollback
    state = AsyncData(currentApps);
    rethrow;
  }
}
```

## UI Sidebar

### Structure

```
┌─────────────────────┐
│  FAVORIS            │
│  ⭐ PodSpot     ☆   │
│  ⭐ MyApp      ☆   │
│                     │
│  iPHONE         [3] │
│    AppName1     ☆   │
│    AppName2     ☆   │
│                     │
│  ANDROID        [2] │
│    (collapsed)      │
├─────────────────────┤
│  OVERVIEW           │
│    Dashboard        │
│    My Apps          │
│  RESEARCH           │
│    Keywords         │
└─────────────────────┘
```

### Composants

1. **SidebarAppsList** - Widget principal orchestrant les sections
2. **SidebarAppTile** - Ligne d'app avec étoile au hover
3. **CollapsibleSection** - Header cliquable avec badge count

### Comportements

- Groupes iOS/Android collapsés par défaut
- État collapse sauvé en `SharedPreferences`
- Hauteur max par section (~200px), scroll interne si dépassement
- Clic app → navigation `/apps/{id}`
- Hover ligne → icône ☆ apparaît
- Clic ☆ → toggle favori (optimistic update)
- >5 favoris → warning visuel (bordure orange)

## UI Page Détail

Ajouter bouton "Favorite" dans la toolbar existante:

```
┌─────────────────────────────────────────┐
│  ⭐ Favorite  │  📊 Ratings  │  🗑 Delete │
└─────────────────────────────────────────┘
```

- Toggle identique à la sidebar
- État synchronisé via le même provider

## Fichiers à modifier/créer

### Backend (api/)
- `database/migrations/xxxx_add_favorite_to_user_apps.php` (create)
- `app/Http/Controllers/Api/AppController.php` (modify)
- `routes/api.php` (modify)

### Flutter (app/)
- `lib/features/apps/domain/app_model.dart` (modify)
- `lib/features/apps/data/apps_repository.dart` (modify)
- `lib/features/apps/providers/apps_provider.dart` (modify)
- `lib/features/apps/providers/sidebar_apps_provider.dart` (create)
- `lib/core/router/app_router.dart` (modify - sidebar)
- `lib/features/apps/presentation/widgets/sidebar_apps_list.dart` (create)
- `lib/features/apps/presentation/widgets/sidebar_app_tile.dart` (create)
- `lib/features/apps/presentation/widgets/collapsible_section.dart` (create)
- `lib/features/apps/presentation/app_detail_screen.dart` (modify)
