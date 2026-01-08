# Settings Page & Light Mode Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add theme switching (system/light/dark) with a settings page accessible via a user dropdown menu.

**Architecture:** Riverpod StateNotifier for theme state with shared_preferences persistence. Light theme maintains glassmorphism aesthetic. User menu dropdown replaces current logout-only footer. Settings page displays theme selector and account info.

**Tech Stack:** Flutter, Riverpod, shared_preferences, go_router, Material 3

---

## Task 1: Add Light Theme Colors

**Files:**
- Modify: `app/lib/core/theme/app_colors.dart`

**Step 1: Add AppColorsLight class after AppColors**

Add this class at line 81, before `GlassDecoration`:

```dart
/// Design system colors for liquid glass light theme
class AppColorsLight {
  // Base backgrounds - light for contrast with glass panels
  static const bgBase = Color(0xFFf5f5f7);
  static const bgSurface = Color(0xFFffffff);

  // Glass effect backgrounds (semi-transparent white)
  static const glassPanel = Color(0xFFffffff);
  static const glassPanelAlpha = Color(0xCCffffff); // 80% opacity
  static const glassBorder = Color(0xFFe0e0e0);
  static const glassHighlight = Color(0x08000000); // subtle dark highlight

  // Legacy support
  static const bgPanel = glassPanel;
  static const bgHover = Color(0xFFf0f0f0);
  static const bgActive = Color(0xFFe8e8e8);

  // Borders
  static const border = Color(0xFFe5e5e5);
  static const borderLight = Color(0xFFd4d4d4);

  // Text
  static const textPrimary = Color(0xFF1a1a1a);
  static const textSecondary = Color(0xFF6b6b6b);
  static const textMuted = Color(0xFF9a9a9a);

  // Accent - slightly darker blue for contrast
  static const accent = Color(0xFF2563eb);
  static const accentHover = Color(0xFF1d4ed8);
  static const accentMuted = Color(0x262563eb);

  // Semantic colors remain vibrant
  static const green = Color(0xFF16a34a);
  static const greenBright = Color(0xFF22c55e);
  static const greenDim = Color(0xFF166534);
  static const greenMuted = Color(0x2616a34a);

  static const red = Color(0xFFdc2626);
  static const redBright = Color(0xFFef4444);
  static const redDim = Color(0xFF991b1b);
  static const redMuted = Color(0x26dc2626);

  static const yellow = Color(0xFFca8a04);
  static const yellowBright = Color(0xFFeab308);
  static const orange = Color(0xFFea580c);
  static const purple = Color(0xFF9333ea);
}
```

**Step 2: Run app to verify no syntax errors**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter analyze lib/core/theme/app_colors.dart
```

Expected: No issues found

**Step 3: Commit**

```bash
git add app/lib/core/theme/app_colors.dart
git commit -m "feat: add light theme color palette"
```

---

## Task 2: Add Light Theme to AppTheme

**Files:**
- Modify: `app/lib/core/theme/app_theme.dart`

**Step 1: Replace the lightTheme getter (line 244)**

Replace `static ThemeData get lightTheme => darkTheme;` with the full light theme:

```dart
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColorsLight.bgBase,
      colorScheme: const ColorScheme.light(
        surface: AppColorsLight.bgSurface,
        primary: AppColorsLight.accent,
        onPrimary: Colors.white,
        secondary: AppColorsLight.purple,
        error: AppColorsLight.red,
      ),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: AppColorsLight.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: AppColorsLight.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColorsLight.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColorsLight.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColorsLight.textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColorsLight.textSecondary,
        ),
        bodyLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColorsLight.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColorsLight.textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColorsLight.textMuted,
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColorsLight.textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: AppColorsLight.textMuted,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          color: AppColorsLight.textMuted,
        ),
      ),
      dividerColor: AppColorsLight.border,
      dividerTheme: const DividerThemeData(
        color: AppColorsLight.border,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsLight.bgPanel,
        foregroundColor: AppColorsLight.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColorsLight.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColorsLight.bgPanel,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColorsLight.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorsLight.bgSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColorsLight.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColorsLight.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColorsLight.accent),
        ),
        hintStyle: const TextStyle(
          fontSize: 13,
          color: AppColorsLight.textMuted,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsLight.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColorsLight.accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorsLight.textSecondary,
          side: const BorderSide(color: AppColorsLight.border),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorsLight.textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColorsLight.textMuted,
          padding: const EdgeInsets.all(8),
          minimumSize: const Size(32, 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        dense: true,
        minVerticalPadding: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: AppColorsLight.bgSurface,
        indicatorColor: AppColorsLight.accentMuted,
        selectedIconTheme: IconThemeData(color: AppColorsLight.accent, size: 20),
        unselectedIconTheme: IconThemeData(color: AppColorsLight.textMuted, size: 20),
        selectedLabelTextStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColorsLight.accent,
        ),
        unselectedLabelTextStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColorsLight.textMuted,
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColorsLight.border),
        radius: const Radius.circular(4),
        thickness: WidgetStateProperty.all(6),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColorsLight.bgActive,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: const TextStyle(
          fontSize: 12,
          color: AppColorsLight.textPrimary,
        ),
      ),
    );
  }
```

**Step 2: Add AppColorsLight import at top**

The import is already there via `app_colors.dart`, but verify `AppColorsLight` is accessible.

**Step 3: Run analyzer**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter analyze lib/core/theme/app_theme.dart
```

Expected: No issues found

**Step 4: Commit**

```bash
git add app/lib/core/theme/app_theme.dart
git commit -m "feat: add complete light theme with Material 3"
```

---

## Task 3: Create Theme Provider

**Files:**
- Create: `app/lib/core/providers/theme_provider.dart`

**Step 1: Create the theme provider file**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeModeKey = 'theme_mode';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main');
});

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeModeNotifier(this._prefs) : super(_loadThemeMode(_prefs));

  static ThemeMode _loadThemeMode(SharedPreferences prefs) {
    final value = prefs.getString(_themeModeKey);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(_themeModeKey, mode.name);
  }
}
```

**Step 2: Run analyzer**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter analyze lib/core/providers/theme_provider.dart
```

Expected: No issues found

**Step 3: Commit**

```bash
git add app/lib/core/providers/theme_provider.dart
git commit -m "feat: add theme provider with persistence"
```

---

## Task 4: Update main.dart to Use Theme Provider

**Files:**
- Modify: `app/lib/main.dart`

**Step 1: Replace entire main.dart content**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/theme_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'keyrank.app',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
```

**Step 2: Run app to verify theme loads**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter run -d macos
```

Expected: App starts with system theme (dark/light based on OS setting)

**Step 3: Commit**

```bash
git add app/lib/main.dart
git commit -m "feat: wire theme provider to MaterialApp"
```

---

## Task 5: Make GlassContainer Theme-Aware

**Files:**
- Modify: `app/lib/core/theme/app_colors.dart`

**Step 1: Update GlassDecoration to accept isDark parameter**

Replace the `GlassDecoration` class (lines 83-102):

```dart
/// Glass panel decoration with frosted effect
class GlassDecoration extends BoxDecoration {
  GlassDecoration({
    double radius = AppColors.radiusMedium,
    bool showBorder = true,
    Color? backgroundColor,
    bool isDark = true,
  }) : super(
          color: backgroundColor ??
              (isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha),
          borderRadius: BorderRadius.circular(radius),
          border: showBorder
              ? Border.all(
                  color: isDark ? AppColors.glassBorder : AppColorsLight.glassBorder,
                  width: 1,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: isDark ? const Color(0x20000000) : const Color(0x10000000),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        );
}
```

**Step 2: Update GlassContainer to use theme brightness**

Replace the `GlassContainer` class (lines 105-160):

```dart
/// Glass container widget with optional blur
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showBorder;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  const GlassContainer({
    super.key,
    required this.child,
    this.radius = AppColors.radiusMedium,
    this.padding,
    this.margin,
    this.showBorder = true,
    this.backgroundColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: GlassDecoration(
        radius: radius,
        showBorder: showBorder,
        backgroundColor: backgroundColor,
        isDark: isDark,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isDark ? AppColors.glassHighlight : AppColorsLight.glassHighlight,
                  Colors.transparent,
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

**Step 3: Run analyzer**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter analyze lib/core/theme/app_colors.dart
```

Expected: No issues found

**Step 4: Commit**

```bash
git add app/lib/core/theme/app_colors.dart
git commit -m "feat: make glass components theme-aware"
```

---

## Task 6: Create User Menu Widget

**Files:**
- Create: `app/lib/core/widgets/user_menu.dart`

**Step 1: Create the user menu widget**

```dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class UserMenu extends StatelessWidget {
  final String userName;
  final String userEmail;
  final VoidCallback onLogout;

  const UserMenu({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? _DarkColors() : _LightColors();

    final initials = userName.isNotEmpty
        ? userName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
        : 'U';

    return PopupMenuButton<String>(
      offset: const Offset(0, -120),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        side: BorderSide(color: colors.border),
      ),
      color: colors.surface,
      onSelected: (value) {
        switch (value) {
          case 'settings':
            context.push('/settings');
            break;
          case 'logout':
            onLogout();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          height: 40,
          child: Text(
            userEmail,
            style: TextStyle(
              fontSize: 12,
              color: colors.textMuted,
            ),
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'settings',
          height: 44,
          child: Row(
            children: [
              Icon(Icons.settings_outlined, size: 18, color: colors.textSecondary),
              const SizedBox(width: 12),
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 13,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          height: 44,
          child: Row(
            children: [
              Icon(Icons.logout_rounded, size: 18, color: colors.textSecondary),
              const SizedBox(width: 12),
              Text(
                'Se déconnecter',
                style: TextStyle(
                  fontSize: 13,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.bgActive,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppColors.radiusMedium),
            hoverColor: colors.bgHover,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366f1), Color(0xFF8b5cf6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          userEmail,
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.textMuted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.unfold_more,
                    size: 18,
                    color: colors.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DarkColors {
  final textPrimary = AppColors.textPrimary;
  final textSecondary = AppColors.textSecondary;
  final textMuted = AppColors.textMuted;
  final bgActive = AppColors.bgActive.withAlpha(100);
  final bgHover = AppColors.bgHover;
  final surface = AppColors.bgSurface;
  final border = AppColors.glassBorder;
}

class _LightColors {
  final textPrimary = AppColorsLight.textPrimary;
  final textSecondary = AppColorsLight.textSecondary;
  final textMuted = AppColorsLight.textMuted;
  final bgActive = AppColorsLight.bgActive.withAlpha(200);
  final bgHover = AppColorsLight.bgHover;
  final surface = AppColorsLight.bgSurface;
  final border = AppColorsLight.glassBorder;
}
```

**Step 2: Run analyzer**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter analyze lib/core/widgets/user_menu.dart
```

Expected: No issues found

**Step 3: Commit**

```bash
git add app/lib/core/widgets/user_menu.dart
git commit -m "feat: add user menu dropdown widget"
```

---

## Task 7: Update MainShell Sidebar to Use UserMenu

**Files:**
- Modify: `app/lib/core/router/app_router.dart`

**Step 1: Add import for UserMenu**

Add at line 7 (after app_colors import):

```dart
import '../widgets/user_menu.dart';
```

**Step 2: Update _GlassSidebar to receive userEmail**

Update the `_GlassSidebar` class constructor (around line 179) to add `userEmail`:

```dart
class _GlassSidebar extends StatelessWidget {
  final int selectedIndex;
  final int? selectedAppId;
  final ValueChanged<int> onDestinationSelected;
  final String userName;
  final String userEmail;
  final VoidCallback onLogout;

  const _GlassSidebar({
    required this.selectedIndex,
    required this.selectedAppId,
    required this.onDestinationSelected,
    required this.userName,
    required this.userEmail,
    required this.onLogout,
  });
```

**Step 3: Update _buildUserFooter to return UserMenu**

Replace the `_buildUserFooter` method (around line 368-447) with:

```dart
  Widget _buildUserFooter(BuildContext context) {
    return UserMenu(
      userName: userName,
      userEmail: userEmail,
      onLogout: onLogout,
    );
  }
```

**Step 4: Update MainShell to pass userEmail**

In `MainShell.build()`, update the `_GlassSidebar` instantiation (around line 120-126):

```dart
            _GlassSidebar(
              selectedIndex: _getSelectedIndex(context),
              selectedAppId: _getSelectedAppId(context),
              onDestinationSelected: (index) => _onDestinationSelected(context, index),
              userName: user?.name ?? 'User',
              userEmail: user?.email ?? '',
              onLogout: () => ref.read(authStateProvider.notifier).logout(),
            ),
```

**Step 5: Make sidebar theme-aware**

In `_GlassSidebar.build()`, add brightness check and update colors. Replace the container decoration (lines 189-202):

```dart
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        border: Border.all(color: isDark ? AppColors.glassBorder : AppColorsLight.glassBorder),
        boxShadow: [
          BoxShadow(
            color: isDark ? const Color(0x20000000) : const Color(0x10000000),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
```

Then update all hardcoded color references in `_buildHeader`, `_buildNavSection`, and `_buildNavItem` to use the `isDark` conditional. This is extensive - pass `isDark` to helper methods.

**Step 6: Run analyzer**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter analyze lib/core/router/app_router.dart
```

Expected: No issues found

**Step 7: Run app to test user menu**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter run -d macos
```

Expected: User menu dropdown appears on click, shows email, Settings, and Se déconnecter options

**Step 8: Commit**

```bash
git add app/lib/core/router/app_router.dart
git commit -m "feat: replace logout button with user menu dropdown"
```

---

## Task 8: Create Settings Screen

**Files:**
- Create: `app/lib/features/settings/presentation/settings_screen.dart`

**Step 1: Create directories**

```bash
mkdir -p /Users/jerome/Projets/web/flutter/ranking/app/lib/features/settings/presentation
```

**Step 2: Create settings screen**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 32),

            // Appearance section
            _SectionCard(
              isDark: isDark,
              title: 'Apparence',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thème',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('Système'),
                        icon: Icon(Icons.brightness_auto),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('Sombre'),
                        icon: Icon(Icons.dark_mode),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Clair'),
                        icon: Icon(Icons.light_mode),
                      ),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (selection) {
                      ref.read(themeModeProvider.notifier).setThemeMode(selection.first);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Account section
            _SectionCard(
              isDark: isDark,
              title: 'Compte',
              child: Column(
                children: [
                  _InfoRow(
                    isDark: isDark,
                    label: 'Email',
                    value: user?.email ?? '-',
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    isDark: isDark,
                    label: 'Membre depuis',
                    value: user?.createdAt != null
                        ? DateFormat.yMMMMd('fr_FR').format(user!.createdAt)
                        : '-',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(authStateProvider.notifier).logout();
                },
                icon: Icon(
                  Icons.logout_rounded,
                  color: isDark ? AppColors.red : AppColorsLight.red,
                ),
                label: Text(
                  'Se déconnecter',
                  style: TextStyle(
                    color: isDark ? AppColors.red : AppColorsLight.red,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isDark ? AppColors.red.withAlpha(100) : AppColorsLight.red.withAlpha(100),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.isDark,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(
          color: isDark ? AppColors.glassBorder : AppColorsLight.glassBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final bool isDark;
  final String label;
  final String value;

  const _InfoRow({
    required this.isDark,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
          ),
        ),
      ],
    );
  }
}
```

**Step 3: Run analyzer**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter analyze lib/features/settings/presentation/settings_screen.dart
```

Expected: No issues found

**Step 4: Commit**

```bash
git add app/lib/features/settings/presentation/settings_screen.dart
git commit -m "feat: add settings screen with theme selector"
```

---

## Task 9: Add Settings Route

**Files:**
- Modify: `app/lib/core/router/app_router.dart`

**Step 1: Add import for SettingsScreen**

Add after line 17:

```dart
import '../../features/settings/presentation/settings_screen.dart';
```

**Step 2: Add /settings route in ShellRoute**

Add after the `/keywords` route (around line 98):

```dart
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
```

**Step 3: Run analyzer**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter analyze lib/core/router/app_router.dart
```

Expected: No issues found

**Step 4: Run app to test full flow**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter run -d macos
```

Expected:
- Click user menu → dropdown appears
- Click Settings → navigates to /settings
- Theme selector works, changes persist
- Account info displays correctly

**Step 5: Commit**

```bash
git add app/lib/core/router/app_router.dart
git commit -m "feat: add settings route"
```

---

## Task 10: Add intl Package for Date Formatting

**Files:**
- Modify: `app/pubspec.yaml`

**Step 1: Check if intl is already present**

```bash
grep -n "intl:" /Users/jerome/Projets/web/flutter/ranking/app/pubspec.yaml
```

If not present, add under dependencies:

```yaml
  intl: ^0.19.0
```

**Step 2: Run pub get**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter pub get
```

**Step 3: Commit if changes were made**

```bash
git add app/pubspec.yaml app/pubspec.lock
git commit -m "chore: add intl package for date formatting"
```

---

## Final Verification

**Run full app test:**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter run -d macos
```

**Checklist:**
- [ ] App starts with system theme
- [ ] User menu dropdown shows email, Settings, Se déconnecter
- [ ] Settings page accessible via user menu
- [ ] Theme selector changes theme immediately
- [ ] Theme preference persists after app restart
- [ ] Light mode has proper glassmorphism effect
- [ ] All colors adapt correctly to light/dark mode
- [ ] Account info displays correctly
- [ ] Logout works from both settings and dropdown
