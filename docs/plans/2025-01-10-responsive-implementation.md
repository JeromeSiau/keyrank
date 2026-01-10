# Responsive Design Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Adapter l'application Keyrank pour mobile (Bottom Nav), tablette (Navigation Rail) et desktop (Sidebar).

**Architecture:** Créer un ResponsiveShell qui remplace MainShell et adapte la navigation selon la largeur d'écran via LayoutBuilder. Les breakpoints sont : mobile < 600px, tablette 600-1024px, desktop > 1024px.

**Tech Stack:** Flutter, Riverpod, GoRouter, Material 3 NavigationBar/NavigationRail

---

## Task 1: Créer les constantes de breakpoints

**Files:**
- Create: `app/lib/core/constants/breakpoints.dart`

**Step 1: Créer le fichier breakpoints.dart**

```dart
/// Responsive breakpoints for the app
class Breakpoints {
  Breakpoints._();

  /// Mobile: < 600px - Bottom Navigation Bar
  static const double mobile = 600;

  /// Tablet: 600-1024px - Navigation Rail
  static const double tablet = 1024;

  /// Check if width is mobile
  static bool isMobile(double width) => width < mobile;

  /// Check if width is tablet
  static bool isTablet(double width) => width >= mobile && width < tablet;

  /// Check if width is desktop
  static bool isDesktop(double width) => width >= tablet;
}

/// Screen size enum for cleaner conditionals
enum ScreenSize { mobile, tablet, desktop }

/// Extension to get ScreenSize from width
extension ScreenSizeExtension on double {
  ScreenSize get screenSize {
    if (this < Breakpoints.mobile) return ScreenSize.mobile;
    if (this < Breakpoints.tablet) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }
}
```

**Step 2: Vérifier que le fichier compile**

Run: `cd /Users/jerome/Projets/web/flutter/ranking/app && flutter analyze lib/core/constants/breakpoints.dart`
Expected: No issues found

**Step 3: Commit**

```bash
git add app/lib/core/constants/breakpoints.dart
git commit -m "feat(responsive): add breakpoint constants"
```

---

## Task 2: Créer le widget ResponsiveBuilder utilitaire

**Files:**
- Create: `app/lib/core/widgets/responsive_builder.dart`

**Step 1: Créer le fichier responsive_builder.dart**

```dart
import 'package:flutter/material.dart';
import '../constants/breakpoints.dart';

/// Builder widget that provides different layouts based on screen size
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context) desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (Breakpoints.isMobile(width)) {
          return mobile(context);
        }

        if (Breakpoints.isTablet(width)) {
          return tablet?.call(context) ?? desktop(context);
        }

        return desktop(context);
      },
    );
  }
}

/// Simpler widget that just provides the current screen size
class ResponsiveWidget extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenSize screenSize) builder;

  const ResponsiveWidget({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = constraints.maxWidth.screenSize;
        return builder(context, screenSize);
      },
    );
  }
}
```

**Step 2: Vérifier que le fichier compile**

Run: `cd /Users/jerome/Projets/web/flutter/ranking/app && flutter analyze lib/core/widgets/responsive_builder.dart`
Expected: No issues found

**Step 3: Commit**

```bash
git add app/lib/core/widgets/responsive_builder.dart
git commit -m "feat(responsive): add ResponsiveBuilder widget"
```

---

## Task 3: Créer le composant GlassBottomNavBar pour mobile

**Files:**
- Create: `app/lib/core/widgets/glass_bottom_nav_bar.dart`

**Step 1: Créer le fichier glass_bottom_nav_bar.dart**

```dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/l10n_extension.dart';

class GlassBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const GlassBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        border: Border(
          top: BorderSide(color: colors.glassBorder),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: NavigationBar(
            height: 65,
            elevation: 0,
            backgroundColor: Colors.transparent,
            indicatorColor: colors.accent.withAlpha(30),
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined, color: colors.textMuted),
                selectedIcon: Icon(Icons.dashboard, color: colors.accent),
                label: context.l10n.nav_dashboard,
              ),
              NavigationDestination(
                icon: Icon(Icons.apps_outlined, color: colors.textMuted),
                selectedIcon: Icon(Icons.apps, color: colors.accent),
                label: context.l10n.nav_myApps,
              ),
              NavigationDestination(
                icon: Icon(Icons.explore_outlined, color: colors.textMuted),
                selectedIcon: Icon(Icons.explore, color: colors.accent),
                label: context.l10n.nav_discover,
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline, color: colors.textMuted),
                selectedIcon: Icon(Icons.person, color: colors.accent),
                label: context.l10n.common_settings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Step 2: Vérifier que le fichier compile**

Run: `cd /Users/jerome/Projets/web/flutter/ranking/app && flutter analyze lib/core/widgets/glass_bottom_nav_bar.dart`
Expected: No issues found

**Step 3: Commit**

```bash
git add app/lib/core/widgets/glass_bottom_nav_bar.dart
git commit -m "feat(responsive): add GlassBottomNavBar for mobile"
```

---

## Task 4: Créer le composant GlassNavigationRail pour tablette

**Files:**
- Create: `app/lib/core/widgets/glass_navigation_rail.dart`

**Step 1: Créer le fichier glass_navigation_rail.dart**

```dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/l10n_extension.dart';
import 'keyrank_logo.dart';

class GlassNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onLogoTap;
  final Widget trailing;

  const GlassNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onLogoTap,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 72,
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        border: Border.all(color: colors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: const Color(0x20000000),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Column(
            children: [
              // Logo
              InkWell(
                onTap: onLogoTap,
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: KeyrankLogoIcon(size: 32),
                ),
              ),
              const SizedBox(height: 8),
              // Navigation items
              Expanded(
                child: NavigationRail(
                  backgroundColor: Colors.transparent,
                  indicatorColor: colors.accent.withAlpha(30),
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined, color: colors.textMuted),
                      selectedIcon: Icon(Icons.dashboard, color: colors.accent),
                      label: Text(
                        context.l10n.nav_dashboard,
                        style: TextStyle(fontSize: 10, color: colors.textSecondary),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.apps_outlined, color: colors.textMuted),
                      selectedIcon: Icon(Icons.apps, color: colors.accent),
                      label: Text(
                        context.l10n.nav_myApps,
                        style: TextStyle(fontSize: 10, color: colors.textSecondary),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.explore_outlined, color: colors.textMuted),
                      selectedIcon: Icon(Icons.explore, color: colors.accent),
                      label: Text(
                        context.l10n.nav_discover,
                        style: TextStyle(fontSize: 10, color: colors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              // User menu at bottom
              trailing,
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Step 2: Vérifier que le fichier compile**

Run: `cd /Users/jerome/Projets/web/flutter/ranking/app && flutter analyze lib/core/widgets/glass_navigation_rail.dart`
Expected: No issues found

**Step 3: Commit**

```bash
git add app/lib/core/widgets/glass_navigation_rail.dart
git commit -m "feat(responsive): add GlassNavigationRail for tablet"
```

---

## Task 5: Créer le ResponsiveShell principal

**Files:**
- Create: `app/lib/core/widgets/responsive_shell.dart`

**Step 1: Créer le fichier responsive_shell.dart**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/breakpoints.dart';
import '../theme/app_colors.dart';
import '../../features/auth/providers/auth_provider.dart';
import 'glass_bottom_nav_bar.dart';
import 'glass_navigation_rail.dart';
import 'user_menu.dart';

class ResponsiveShell extends ConsumerWidget {
  final Widget child;
  final Widget sidebar;

  const ResponsiveShell({
    super.key,
    required this.child,
    required this.sidebar,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      backgroundColor: colors.bgBase,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenSize = constraints.maxWidth.screenSize;

          return switch (screenSize) {
            ScreenSize.mobile => _buildMobileLayout(context, ref, colors),
            ScreenSize.tablet => _buildTabletLayout(context, ref, user, colors),
            ScreenSize.desktop => _buildDesktopLayout(colors),
          };
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref, AppColorsExtension colors) {
    return Column(
      children: [
        // Content
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppColors.radiusLarge),
            child: child,
          ),
        ),
        // Bottom navigation
        GlassBottomNavBar(
          selectedIndex: _getSelectedIndex(context),
          onDestinationSelected: (index) => _onDestinationSelected(context, ref, index),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    WidgetRef ref,
    dynamic user,
    AppColorsExtension colors,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Navigation rail
          GlassNavigationRail(
            selectedIndex: _getSelectedIndex(context),
            onDestinationSelected: (index) => _onDestinationSelected(context, ref, index),
            onLogoTap: () => context.go('/dashboard'),
            trailing: _buildCompactUserMenu(context, ref, user, colors),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppColors.radiusLarge),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(AppColorsExtension colors) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          sidebar,
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppColors.radiusLarge),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactUserMenu(
    BuildContext context,
    WidgetRef ref,
    dynamic user,
    AppColorsExtension colors,
  ) {
    final initials = (user?.name ?? 'U')
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase();

    return PopupMenuButton<String>(
      offset: const Offset(72, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        side: BorderSide(color: colors.border),
      ),
      color: colors.bgSurface,
      onSelected: (value) {
        if (value == 'settings') {
          context.push('/settings');
        } else if (value == 'logout') {
          ref.read(authStateProvider.notifier).logout();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings_outlined, size: 18, color: colors.textSecondary),
              const SizedBox(width: 12),
              Text('Settings', style: TextStyle(color: colors.textPrimary)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout_rounded, size: 18, color: colors.textSecondary),
              const SizedBox(width: 12),
              Text('Logout', style: TextStyle(color: colors.textPrimary)),
            ],
          ),
        ),
      ],
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6366f1), Color(0xFF8b5cf6)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            initials,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/apps')) return 1;
    if (location.startsWith('/discover')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onDestinationSelected(BuildContext context, WidgetRef ref, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/apps');
        break;
      case 2:
        context.go('/discover');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }
}
```

**Step 2: Vérifier que le fichier compile**

Run: `cd /Users/jerome/Projets/web/flutter/ranking/app && flutter analyze lib/core/widgets/responsive_shell.dart`
Expected: No issues found

**Step 3: Commit**

```bash
git add app/lib/core/widgets/responsive_shell.dart
git commit -m "feat(responsive): add ResponsiveShell with mobile/tablet/desktop layouts"
```

---

## Task 6: Intégrer ResponsiveShell dans app_router.dart

**Files:**
- Modify: `app/lib/core/router/app_router.dart`

**Step 1: Ajouter les imports nécessaires**

Ajouter après la ligne `import '../widgets/user_menu.dart';` :

```dart
import '../widgets/responsive_shell.dart';
import '../constants/breakpoints.dart';
```

**Step 2: Modifier MainShell pour utiliser ResponsiveShell**

Remplacer le contenu de la méthode `build` de `MainShell` (lignes 139-165) par :

```dart
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ResponsiveShell(
      sidebar: _GlassSidebar(
        selectedIndex: _getSelectedIndex(context),
        selectedAppId: _getSelectedAppId(context),
        onDestinationSelected: (index) => _onDestinationSelected(context, index),
        userName: user?.name ?? 'User',
        userEmail: user?.email ?? '',
        onLogout: () => ref.read(authStateProvider.notifier).logout(),
      ),
      child: child,
    );
  }
```

**Step 3: Vérifier que l'app compile**

Run: `cd /Users/jerome/Projets/web/flutter/ranking/app && flutter analyze`
Expected: No issues found

**Step 4: Lancer l'app et tester les breakpoints**

Run: `cd /Users/jerome/Projets/web/flutter/ranking/app && flutter run -d chrome`
Test: Redimensionner la fenêtre pour voir les 3 layouts

**Step 5: Commit**

```bash
git add app/lib/core/router/app_router.dart
git commit -m "feat(responsive): integrate ResponsiveShell in router"
```

---

## Task 7: Ajouter l'AppBar contextuelle pour mobile

**Files:**
- Modify: `app/lib/core/widgets/responsive_shell.dart`

**Step 1: Ajouter une AppBar au layout mobile**

Modifier `_buildMobileLayout` pour ajouter une AppBar avec SafeArea :

```dart
  Widget _buildMobileLayout(BuildContext context, WidgetRef ref, AppColorsExtension colors) {
    return Column(
      children: [
        // Safe area for status bar
        Container(
          color: colors.bgBase,
          child: SafeArea(
            bottom: false,
            child: Container(),
          ),
        ),
        // Content
        Expanded(
          child: child,
        ),
        // Bottom navigation
        SafeArea(
          top: false,
          child: GlassBottomNavBar(
            selectedIndex: _getSelectedIndex(context),
            onDestinationSelected: (index) => _onDestinationSelected(context, ref, index),
          ),
        ),
      ],
    );
  }
```

**Step 2: Vérifier que l'app compile**

Run: `cd /Users/jerome/Projets/web/flutter/ranking/app && flutter analyze`
Expected: No issues found

**Step 3: Commit**

```bash
git add app/lib/core/widgets/responsive_shell.dart
git commit -m "feat(responsive): add SafeArea handling for mobile"
```

---

## Task 8: Créer un barrel export pour les widgets responsive

**Files:**
- Create: `app/lib/core/widgets/responsive.dart`

**Step 1: Créer le fichier barrel export**

```dart
export 'responsive_builder.dart';
export 'responsive_shell.dart';
export 'glass_bottom_nav_bar.dart';
export 'glass_navigation_rail.dart';
```

**Step 2: Commit**

```bash
git add app/lib/core/widgets/responsive.dart
git commit -m "feat(responsive): add barrel export for responsive widgets"
```

---

## Task 9: Tester sur différentes tailles d'écran

**Step 1: Lancer sur web et tester les 3 breakpoints**

Run: `cd /Users/jerome/Projets/web/flutter/ranking/app && flutter run -d chrome`

Tests manuels :
- [ ] < 600px : Bottom Navigation visible, pas de sidebar
- [ ] 600-1024px : Navigation Rail visible (72px), pas de sidebar complète
- [ ] > 1024px : Sidebar complète (220px)

**Step 2: Vérifier la navigation fonctionne sur chaque layout**

- [ ] Dashboard accessible
- [ ] My Apps accessible
- [ ] Discover accessible
- [ ] Settings accessible (mobile via 4ème icône, tablet/desktop via menu user)

**Step 3: Commit final si tout fonctionne**

```bash
git add -A
git commit -m "feat(responsive): complete responsive navigation implementation"
```

---

## Tâches futures (hors scope actuel)

Ces tâches seront à faire dans une prochaine itération :

1. **Adapter le Dashboard** - Stats en grille responsive
2. **Adapter My Apps** - Tabs pour mobile, filtres pour tablette
3. **Adapter App Detail** - Sections empilées sur mobile
4. **Adapter Discover** - Grille responsive
5. **Adapter Categories** - Liste/grille selon la taille
