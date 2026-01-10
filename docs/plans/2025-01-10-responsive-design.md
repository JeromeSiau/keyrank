# Design Responsive - Keyrank App

## Objectif

Adapter l'application pour fonctionner sur mobile, tablette et desktop avec une expérience utilisateur optimale sur chaque format.

## Breakpoints

| Format | Largeur | Navigation |
|--------|---------|------------|
| Mobile | < 600px | Bottom Navigation Bar |
| Tablette | 600px - 1024px | Navigation Rail |
| Desktop | > 1024px | Sidebar complète (actuelle) |

## Architecture

### ResponsiveShell

Remplace le `MainShell` actuel par un widget qui adapte la navigation selon la largeur d'écran via `LayoutBuilder`.

```
ResponsiveShell
├── < 600px    → ScaffoldWithBottomNav
├── 600-1024px → ScaffoldWithNavigationRail
└── > 1024px   → CurrentSidebarLayout
```

### Fichiers à créer

- `lib/core/widgets/responsive_shell.dart` - Widget central
- `lib/core/constants/breakpoints.dart` - Constantes breakpoints

### Fichiers à modifier

- `lib/core/router/app_router.dart` - Utiliser ResponsiveShell

## Destinations de navigation

Les 3 destinations principales (identiques sur tous formats) :

1. **Dashboard** (home) - Accueil et stats globales
2. **My Apps** (apps) - Liste des apps trackées
3. **Discover** (explore) - Recherche et découverte

Plus le menu utilisateur (profile/settings/logout).

## Layout Mobile (< 600px)

```
┌─────────────────────────┐
│  AppBar (contextuelle)  │
├─────────────────────────┤
│                         │
│    Contenu scrollable   │
│                         │
├─────────────────────────┤
│ 🏠    📱    🔍    👤   │
└─────────────────────────┘
```

### Bottom Navigation Bar

- 4 items : Dashboard, My Apps, Discover, Profile
- Style glass cohérent avec le design actuel

### AppBar contextuelle

- Titre de la page courante
- Actions spécifiques à l'écran
- Back button si navigation profonde

### Adaptations contenu

- Cards en full-width
- Tableaux → listes verticales
- Stats empilées verticalement

## Layout Tablette (600-1024px)

```
┌──────┬──────────────────────────────┐
│  🏠  │                              │
│  📱  │      Contenu principal       │
│  🔍  │                              │
├──────┤                              │
│  👤  │                              │
└──────┴──────────────────────────────┘
```

### Navigation Rail

- Largeur fixe : 72px
- Icônes avec labels en dessous
- Style glass comme sidebar actuelle
- Menu utilisateur en bas

### Adaptations contenu

- Grilles 2 colonnes possibles
- Tableaux avec colonnes principales
- Stats en 2x2

## Layout Desktop (> 1024px)

Conserve le layout actuel avec sidebar 220px.

## Écrans à adapter

| Écran | Mobile | Tablette |
|-------|--------|----------|
| Dashboard | Stats empilées, cards full-width | Stats 2x2, cards en grille |
| My Apps | Liste + tabs (Favoris/iPhone/Android) | Liste avec filtres latéraux |
| App Detail | Sections empilées, tabs pour insights | Layout actuel simplifié |
| Discover | Recherche + résultats en liste | Grille 2-3 colonnes |
| Categories | Liste scrollable | Grille de catégories |

## Widget utilitaire

```dart
ResponsiveBuilder(
  mobile: (context) => MobileLayout(),
  tablet: (context) => TabletLayout(),
  desktop: (context) => DesktopLayout(),
)
```

## Plan d'implémentation

1. **Infrastructure** - Breakpoints + ResponsiveShell
2. **Navigation** - Bottom Nav + Navigation Rail
3. **Dashboard** - Premier écran adapté
4. **My Apps** - Intégration liste apps trackées
5. **Autres écrans** - App detail, Discover, Categories

## Ce qui ne change pas

- Système de couleurs et thème
- Animations existantes
- Logique métier et state management
- Routes (GoRouter)
