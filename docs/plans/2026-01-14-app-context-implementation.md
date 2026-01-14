# App Context Global - Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a global app context switcher that filters all screens for a specific app, simplifying navigation by removing `/apps/{id}` routes.

**Architecture:** A `StateNotifierProvider<AppContextNotifier, AppModel?>` manages the selected app. All data providers watch this context and fetch data accordingly. The UI shows a dropdown in the sidebar (desktop) or drawer (mobile) to switch apps.

**Tech Stack:** Flutter, Riverpod 2.6, GoRouter, SharedPreferences

**Design doc:** `docs/plans/2026-01-14-app-context-design.md`

---

## Task 1: Create AppContextProvider

**Files:**
- Create: `lib/core/providers/app_context_provider.dart`
- Test: `test/core/providers/app_context_provider_test.dart`

**Step 1: Write the failing test**

```dart
// test/core/providers/app_context_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyrank/core/providers/app_context_provider.dart';
import 'package:keyrank/features/apps/domain/app_model.dart';

void main() {
  group('AppContextNotifier', () {
    test('initial state is null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(appContextProvider);
      expect(state, isNull);
    });

    test('select sets the app', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final app = AppModel(
        id: 1,
        platform: 'ios',
        storeId: '123',
        name: 'Test App',
        iconUrl: 'https://example.com/icon.png',
        developer: 'Test Dev',
      );

      container.read(appContextProvider.notifier).select(app);
      expect(container.read(appContextProvider), equals(app));
    });

    test('clear sets state to null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final app = AppModel(
        id: 1,
        platform: 'ios',
        storeId: '123',
        name: 'Test App',
        iconUrl: 'https://example.com/icon.png',
        developer: 'Test Dev',
      );

      container.read(appContextProvider.notifier).select(app);
      container.read(appContextProvider.notifier).clear();
      expect(container.read(appContextProvider), isNull);
    });
  });
}
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/core/providers/app_context_provider_test.dart`
Expected: FAIL - "app_context_provider.dart" not found

**Step 3: Write minimal implementation**

```dart
// lib/core/providers/app_context_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/apps/domain/app_model.dart';

final appContextProvider = StateNotifierProvider<AppContextNotifier, AppModel?>((ref) {
  return AppContextNotifier();
});

class AppContextNotifier extends StateNotifier<AppModel?> {
  AppContextNotifier() : super(null);

  void select(AppModel? app) {
    state = app;
  }

  void clear() {
    state = null;
  }
}
```

**Step 4: Run test to verify it passes**

Run: `flutter test test/core/providers/app_context_provider_test.dart`
Expected: PASS (3 tests)

**Step 5: Commit**

```bash
git add lib/core/providers/app_context_provider.dart test/core/providers/app_context_provider_test.dart
git commit -m "feat: add AppContextProvider for global app selection"
```

---

## Task 2: Add persistence setting for app context

**Files:**
- Modify: `lib/core/providers/app_context_provider.dart`
- Modify: `test/core/providers/app_context_provider_test.dart`

**Step 1: Add rememberAppContext setting provider**

Add to `lib/core/providers/app_context_provider.dart`:

```dart
import 'package:shared_preferences/shared_preferences.dart';

// Add after imports
const _kRememberAppContextKey = 'remember_app_context';
const _kSelectedAppIdKey = 'selected_app_id';

final rememberAppContextProvider = StateProvider<bool>((ref) => false);

// Update AppContextNotifier to support persistence
class AppContextNotifier extends StateNotifier<AppModel?> {
  final Ref _ref;
  final SharedPreferences? _prefs;

  AppContextNotifier(this._ref, this._prefs) : super(null) {
    _loadPersistedApp();
  }

  Future<void> _loadPersistedApp() async {
    if (_prefs == null) return;

    final shouldRemember = _prefs!.getBool(_kRememberAppContextKey) ?? false;
    if (!shouldRemember) return;

    final appId = _prefs!.getInt(_kSelectedAppIdKey);
    if (appId == null) return;

    // We'll load the app from appsNotifierProvider in the next task
  }

  void select(AppModel? app) {
    state = app;
    _persistIfEnabled(app);
  }

  void clear() {
    state = null;
    _persistIfEnabled(null);
  }

  Future<void> _persistIfEnabled(AppModel? app) async {
    if (_prefs == null) return;

    final shouldRemember = _prefs!.getBool(_kRememberAppContextKey) ?? false;
    if (!shouldRemember) return;

    if (app != null) {
      await _prefs!.setInt(_kSelectedAppIdKey, app.id);
    } else {
      await _prefs!.remove(_kSelectedAppIdKey);
    }
  }
}

// Update provider to inject dependencies
final appContextProvider = StateNotifierProvider<AppContextNotifier, AppModel?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).valueOrNull;
  return AppContextNotifier(ref, prefs);
});
```

**Step 2: Update tests with mock SharedPreferences**

The existing tests should still pass since prefs is optional. Run them:

Run: `flutter test test/core/providers/app_context_provider_test.dart`
Expected: PASS

**Step 3: Commit**

```bash
git add lib/core/providers/app_context_provider.dart
git commit -m "feat: add persistence support for app context"
```

---

## Task 3: Create AppContextSwitcher widget

**Files:**
- Create: `lib/core/widgets/app_context_switcher.dart`
- Test: `test/core/widgets/app_context_switcher_test.dart`

**Step 1: Write the failing test**

```dart
// test/core/widgets/app_context_switcher_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyrank/core/widgets/app_context_switcher.dart';
import 'package:keyrank/core/theme/app_theme.dart';
import 'package:keyrank/core/providers/app_context_provider.dart';
import 'package:keyrank/features/apps/providers/apps_provider.dart';
import 'package:keyrank/features/apps/domain/app_model.dart';

void main() {
  Widget buildTestWidget({List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(body: AppContextSwitcher()),
      ),
    );
  }

  final testApps = [
    AppModel(id: 1, platform: 'ios', storeId: '111', name: 'App One', iconUrl: '', developer: 'Dev'),
    AppModel(id: 2, platform: 'ios', storeId: '222', name: 'App Two', iconUrl: '', developer: 'Dev'),
  ];

  testWidgets('displays "All apps" when no app selected', (tester) async {
    await tester.pumpWidget(buildTestWidget(
      overrides: [
        appsNotifierProvider.overrideWith((ref) => _MockAppsNotifier(testApps)),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.text('All apps'), findsOneWidget);
  });

  testWidgets('displays selected app name', (tester) async {
    await tester.pumpWidget(buildTestWidget(
      overrides: [
        appsNotifierProvider.overrideWith((ref) => _MockAppsNotifier(testApps)),
        appContextProvider.overrideWith((ref) => _MockAppContextNotifier(testApps[0])),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.text('App One'), findsOneWidget);
  });
}

class _MockAppsNotifier extends AppsNotifier {
  _MockAppsNotifier(List<AppModel> apps) : super(_MockAppsRepository()) {
    state = AsyncValue.data(apps);
  }
}

class _MockAppsRepository implements AppsRepository {
  @override Future<List<AppModel>> getApps() async => [];
  @override Future<AppModel> addApp(AddAppRequest request) async => throw UnimplementedError();
  @override Future<void> deleteApp(int id) async {}
  @override Future<AppModel> toggleFavorite(int id) async => throw UnimplementedError();
  @override Future<AppModel> getAppPreview({required String platform, required String storeId, String? country}) async => throw UnimplementedError();
}

class _MockAppContextNotifier extends AppContextNotifier {
  _MockAppContextNotifier(AppModel? app) : super() {
    if (app != null) select(app);
  }
}
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/core/widgets/app_context_switcher_test.dart`
Expected: FAIL - "app_context_switcher.dart" not found

**Step 3: Write minimal implementation**

```dart
// lib/core/widgets/app_context_switcher.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_context_provider.dart';
import '../theme/app_colors.dart';
import '../../features/apps/providers/apps_provider.dart';
import '../../features/apps/providers/sidebar_apps_provider.dart';
import '../../features/apps/domain/app_model.dart';

class AppContextSwitcher extends ConsumerWidget {
  const AppContextSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedApp = ref.watch(appContextProvider);
    final colors = context.colors;

    return InkWell(
      onTap: () => _showAppPicker(context, ref),
      borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: colors.bgElevated,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            if (selectedApp != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  selectedApp.iconUrl,
                  width: 24,
                  height: 24,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.apps,
                    size: 24,
                    color: colors.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ] else ...[
              Icon(Icons.apps, size: 24, color: colors.textMuted),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                selectedApp?.name ?? 'All apps',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: colors.textMuted),
          ],
        ),
      ),
    );
  }

  void _showAppPicker(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final sidebarApps = ref.read(sidebarAppsProvider);
    final selectedApp = ref.read(appContextProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.bgBase,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _AppPickerSheet(
        sidebarApps: sidebarApps,
        selectedApp: selectedApp,
        onSelect: (app) {
          ref.read(appContextProvider.notifier).select(app);
          Navigator.pop(context);
        },
        onManageApps: () {
          Navigator.pop(context);
          context.go('/apps/manage');
        },
      ),
    );
  }
}

class _AppPickerSheet extends StatelessWidget {
  final SidebarApps sidebarApps;
  final AppModel? selectedApp;
  final ValueChanged<AppModel?> onSelect;
  final VoidCallback onManageApps;

  const _AppPickerSheet({
    required this.sidebarApps,
    required this.selectedApp,
    required this.onSelect,
    required this.onManageApps,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // All apps option
          _AppTile(
            icon: Icons.apps,
            name: 'All apps',
            isSelected: selectedApp == null,
            onTap: () => onSelect(null),
          ),

          Divider(color: colors.border, height: 1),

          // App list
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                if (sidebarApps.favorites.isNotEmpty) ...[
                  _SectionHeader(title: 'Favorites'),
                  ...sidebarApps.favorites.map((app) => _AppTile(
                    iconUrl: app.iconUrl,
                    name: app.name,
                    isSelected: selectedApp?.id == app.id,
                    onTap: () => onSelect(app),
                  )),
                ],
                if (sidebarApps.iosList.isNotEmpty) ...[
                  _SectionHeader(title: 'iPhone'),
                  ...sidebarApps.iosList.map((app) => _AppTile(
                    iconUrl: app.iconUrl,
                    name: app.name,
                    isSelected: selectedApp?.id == app.id,
                    onTap: () => onSelect(app),
                  )),
                ],
                if (sidebarApps.androidList.isNotEmpty) ...[
                  _SectionHeader(title: 'Android'),
                  ...sidebarApps.androidList.map((app) => _AppTile(
                    iconUrl: app.iconUrl,
                    name: app.name,
                    isSelected: selectedApp?.id == app.id,
                    onTap: () => onSelect(app),
                  )),
                ],
              ],
            ),
          ),

          Divider(color: colors.border, height: 1),

          // Manage apps
          _AppTile(
            icon: Icons.settings,
            name: 'Manage apps',
            isSelected: false,
            onTap: onManageApps,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: colors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AppTile extends StatelessWidget {
  final IconData? icon;
  final String? iconUrl;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const _AppTile({
    this.icon,
    this.iconUrl,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListTile(
      leading: iconUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                iconUrl!,
                width: 32,
                height: 32,
                errorBuilder: (_, __, ___) => Icon(Icons.apps, color: colors.textMuted),
              ),
            )
          : Icon(icon, color: colors.textMuted),
      title: Text(
        name,
        style: TextStyle(
          color: colors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: colors.accent)
          : null,
      onTap: onTap,
    );
  }
}
```

**Step 4: Run test to verify it passes**

Run: `flutter test test/core/widgets/app_context_switcher_test.dart`
Expected: PASS

**Step 5: Commit**

```bash
git add lib/core/widgets/app_context_switcher.dart test/core/widgets/app_context_switcher_test.dart
git commit -m "feat: add AppContextSwitcher widget"
```

---

## Task 4: Integrate switcher into sidebar

**Files:**
- Modify: `lib/core/widgets/responsive_shell.dart`
- Remove: Sidebar apps list section

**Step 1: Read current responsive_shell.dart**

Run: Read the file to understand current structure

**Step 2: Update MainShell to include AppContextSwitcher**

In `responsive_shell.dart`, replace the sidebar apps list with the AppContextSwitcher at the top of the sidebar:

```dart
// In the sidebar Column, after the logo/header:
const AppContextSwitcher(),
const SizedBox(height: 16),
// Then the navigation items (Dashboard, Keywords, etc.)
```

**Step 3: Remove SidebarAppsList usage**

Remove any `SidebarAppsList` widget and related imports from the sidebar.

**Step 4: Run flutter analyze**

Run: `flutter analyze`
Expected: No errors

**Step 5: Test manually**

Run: `flutter run`
Verify: AppContextSwitcher appears at top of sidebar

**Step 6: Commit**

```bash
git add lib/core/widgets/responsive_shell.dart
git commit -m "feat: integrate AppContextSwitcher into sidebar"
```

---

## Task 5: Simplify routes (remove /apps/{id})

**Files:**
- Modify: `lib/core/router/app_router.dart`

**Step 1: Update route structure**

Replace app-specific routes with context-based routes:

```dart
// Before:
// GoRoute(path: '/apps/:id', ...)
// GoRoute(path: '/apps/:id/keywords', ...)

// After:
GoRoute(path: '/keywords', builder: (_, __) => const KeywordsScreen()),
GoRoute(path: '/insights', builder: (_, __) => const InsightsScreen()),
GoRoute(path: '/analytics', builder: (_, __) => const AnalyticsScreen()),
GoRoute(path: '/apps/manage', builder: (_, __) => const AppsManageScreen()),
GoRoute(path: '/apps/add', builder: (_, __) => const AppAddScreen()),
```

**Step 2: Remove _getSelectedAppId helper**

This is no longer needed since app context comes from provider.

**Step 3: Update navigation helpers**

Update any `context.go('/apps/$id')` calls to use `ref.read(appContextProvider.notifier).select(app)` instead.

**Step 4: Run flutter analyze**

Run: `flutter analyze`
Fix any broken imports/references

**Step 5: Commit**

```bash
git add lib/core/router/app_router.dart
git commit -m "refactor: simplify routes to use app context provider"
```

---

## Task 6: Update KeywordsScreen for dual-mode

**Files:**
- Modify: `lib/features/keywords/presentation/keywords_screen.dart`
- Modify: `lib/features/keywords/providers/keywords_provider.dart`

**Step 1: Update provider to use app context**

```dart
// lib/features/keywords/providers/keywords_provider.dart
final keywordsProvider = FutureProvider<List<KeywordModel>>((ref) {
  final app = ref.watch(appContextProvider);
  final repository = ref.read(keywordsRepositoryProvider);
  return repository.getKeywords(appId: app?.id);
});
```

**Step 2: Update repository to accept optional appId**

Modify `getKeywords(int appId)` to `getKeywords({int? appId})`.

**Step 3: Update screen for dual-mode display**

```dart
// In KeywordsScreen build method:
final selectedApp = ref.watch(appContextProvider);
final keywords = ref.watch(keywordsProvider);

// Header
Text(selectedApp == null ? 'Keywords (all apps)' : 'Keywords - ${selectedApp.name}')

// Table: show App column only when selectedApp is null
if (selectedApp == null) DataColumn(label: Text('App')),
```

**Step 4: Run tests**

Run: `flutter test`
Expected: All pass

**Step 5: Commit**

```bash
git add lib/features/keywords/
git commit -m "feat: update KeywordsScreen for dual-mode (all apps / single app)"
```

---

## Task 7: Update remaining screens for dual-mode

Repeat Task 6 pattern for each screen:

- `DashboardScreen` + `heroMetricsProvider`
- `ReviewsScreen` + `reviewsProvider`
- `RatingsScreen` + `ratingsProvider`
- `InsightsScreen` + `insightsProvider`
- `AnalyticsScreen` + `analyticsProvider`

**For each screen:**
1. Update provider to watch `appContextProvider`
2. Update repository method to accept optional `appId`
3. Update screen header to show context
4. Add/hide App column in tables based on context
5. Test and commit

**Commit after each screen:**

```bash
git commit -m "feat: update DashboardScreen for dual-mode"
git commit -m "feat: update ReviewsScreen for dual-mode"
# etc.
```

---

## Task 8: Create AppsManageScreen

**Files:**
- Create: `lib/features/apps/presentation/apps_manage_screen.dart`

**Step 1: Create screen**

```dart
// lib/features/apps/presentation/apps_manage_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/apps_provider.dart';
import '../../../core/theme/app_colors.dart';

class AppsManageScreen extends ConsumerWidget {
  const AppsManageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsAsync = ref.watch(appsNotifierProvider);
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Apps'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/apps/add'),
          ),
        ],
      ),
      body: appsAsync.when(
        data: (apps) => ListView.builder(
          itemCount: apps.length,
          itemBuilder: (context, index) {
            final app = apps[index];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(app.iconUrl, width: 40, height: 40),
              ),
              title: Text(app.name),
              subtitle: Text(app.developer),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(context, ref, app),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, AppModel app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete App'),
        content: Text('Remove "${app.name}" from tracking?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(appsNotifierProvider.notifier).deleteApp(app.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
```

**Step 2: Register route**

Already done in Task 5.

**Step 3: Run flutter analyze**

Run: `flutter analyze`
Expected: No errors

**Step 4: Commit**

```bash
git add lib/features/apps/presentation/apps_manage_screen.dart
git commit -m "feat: add AppsManageScreen for app portfolio management"
```

---

## Task 9: Add Settings toggle for persistence

**Files:**
- Modify: `lib/features/settings/presentation/settings_screen.dart`

**Step 1: Add toggle in settings**

```dart
// In SettingsScreen, add a new section:
SwitchListTile(
  title: const Text('Remember selected app'),
  subtitle: const Text('Persist app selection between sessions'),
  value: ref.watch(rememberAppContextProvider),
  onChanged: (value) {
    ref.read(rememberAppContextProvider.notifier).state = value;
    // Also persist this setting
    ref.read(sharedPreferencesProvider).whenData((prefs) {
      prefs.setBool('remember_app_context', value);
    });
  },
),
```

**Step 2: Load setting on startup**

In `app_context_provider.dart`, load the setting from SharedPreferences.

**Step 3: Commit**

```bash
git add lib/features/settings/ lib/core/providers/app_context_provider.dart
git commit -m "feat: add settings toggle for app context persistence"
```

---

## Task 10: Cleanup and final testing

**Step 1: Remove unused files**

- Delete `SidebarAppsList` and related widgets if no longer used
- Remove `selectedAppProvider` if it existed and is unused

**Step 2: Run full test suite**

Run: `flutter test`
Expected: All pass

**Step 3: Run flutter analyze**

Run: `flutter analyze`
Expected: No issues

**Step 4: Manual testing checklist**

- [ ] App context switcher shows at top of sidebar
- [ ] "All apps" mode shows aggregate data with App column
- [ ] Selecting an app filters all screens
- [ ] "Manage apps" opens apps management screen
- [ ] Settings toggle for persistence works
- [ ] Mobile: switcher in drawer works

**Step 5: Final commit**

```bash
git add -A
git commit -m "chore: cleanup unused code and finalize app context feature"
```

---

## Summary

| Task | Description | Estimated Commits |
|------|-------------|-------------------|
| 1 | AppContextProvider | 1 |
| 2 | Persistence support | 1 |
| 3 | AppContextSwitcher widget | 1 |
| 4 | Integrate into sidebar | 1 |
| 5 | Simplify routes | 1 |
| 6 | KeywordsScreen dual-mode | 1 |
| 7 | Remaining screens (5x) | 5 |
| 8 | AppsManageScreen | 1 |
| 9 | Settings toggle | 1 |
| 10 | Cleanup | 1 |

**Total: ~14 commits**
