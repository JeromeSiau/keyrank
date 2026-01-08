# Sidebar Favorites Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add favorites functionality to apps with a reorganized sidebar showing favorites, iOS apps, and Android apps in collapsible sections.

**Architecture:** Backend stores favorites in `user_apps` pivot table. Flutter uses derived providers for sidebar grouping. Optimistic updates for instant UX.

**Tech Stack:** Laravel 12, Flutter/Riverpod, SharedPreferences for collapse state

---

## Task 1: Backend Migration

**Files:**
- Create: `api/database/migrations/2026_01_08_200000_add_favorite_to_user_apps.php`

**Step 1: Create migration file**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('user_apps', function (Blueprint $table) {
            $table->boolean('is_favorite')->default(false)->after('app_id');
            $table->timestamp('favorited_at')->nullable()->after('is_favorite');
        });
    }

    public function down(): void
    {
        Schema::table('user_apps', function (Blueprint $table) {
            $table->dropColumn(['is_favorite', 'favorited_at']);
        });
    }
};
```

**Step 2: Run migration**

```bash
cd api && php artisan migrate
```

Expected: Migration runs successfully

**Step 3: Commit**

```bash
git add api/database/migrations/2026_01_08_200000_add_favorite_to_user_apps.php
git commit -m "feat(api): add favorite columns to user_apps pivot"
```

---

## Task 2: Backend Models Update

**Files:**
- Modify: `api/app/Models/User.php:53-57`
- Modify: `api/app/Models/App.php:35-39`

**Step 1: Update User model pivot**

In `api/app/Models/User.php`, update the `apps()` relationship:

```php
public function apps(): BelongsToMany
{
    return $this->belongsToMany(App::class, 'user_apps')
        ->withPivot('is_favorite', 'favorited_at', 'created_at');
}
```

**Step 2: Update App model pivot**

In `api/app/Models/App.php`, update the `users()` relationship:

```php
public function users(): BelongsToMany
{
    return $this->belongsToMany(User::class, 'user_apps')
        ->withPivot('is_favorite', 'favorited_at', 'created_at');
}
```

**Step 3: Commit**

```bash
git add api/app/Models/User.php api/app/Models/App.php
git commit -m "feat(api): add favorite pivot fields to models"
```

---

## Task 3: Backend Controller - Index with Favorites

**Files:**
- Modify: `api/app/Http/Controllers/Api/AppController.php:23-34`

**Step 1: Update index method**

Replace the `index` method:

```php
public function index(Request $request): JsonResponse
{
    $apps = $request->user()
        ->apps()
        ->withCount('trackedKeywords')
        ->get()
        ->map(function ($app) {
            $app->is_favorite = (bool) $app->pivot->is_favorite;
            $app->favorited_at = $app->pivot->favorited_at;
            return $app;
        })
        ->sortBy([
            ['is_favorite', 'desc'],
            ['favorited_at', 'desc'],
            ['name', 'asc'],
        ])
        ->values();

    return response()->json([
        'data' => $apps,
    ]);
}
```

**Step 2: Test endpoint**

```bash
curl -H "Authorization: Bearer <token>" http://localhost:8000/api/apps
```

Expected: Apps returned with `is_favorite` and `favorited_at` fields

**Step 3: Commit**

```bash
git add api/app/Http/Controllers/Api/AppController.php
git commit -m "feat(api): return favorite status in apps list"
```

---

## Task 4: Backend Controller - Toggle Favorite Endpoint

**Files:**
- Modify: `api/app/Http/Controllers/Api/AppController.php` (add method)
- Modify: `api/routes/api.php:49`

**Step 1: Add toggleFavorite method to AppController**

Add after the `refresh` method:

```php
/**
 * Toggle app favorite status
 */
public function toggleFavorite(Request $request, App $app): JsonResponse
{
    $validated = $request->validate([
        'is_favorite' => 'required|boolean',
    ]);

    $isFavorite = $validated['is_favorite'];

    $request->user()->apps()->updateExistingPivot($app->id, [
        'is_favorite' => $isFavorite,
        'favorited_at' => $isFavorite ? now() : null,
    ]);

    return response()->json([
        'is_favorite' => $isFavorite,
        'favorited_at' => $isFavorite ? now()->toIso8601String() : null,
    ]);
}
```

**Step 2: Add route**

In `api/routes/api.php`, after line 49 (`Route::post('{app}/refresh', ...)`), add:

```php
Route::patch('{app}/favorite', [AppController::class, 'toggleFavorite']);
```

**Step 3: Test endpoint**

```bash
curl -X PATCH -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"is_favorite": true}' \
  http://localhost:8000/api/apps/1/favorite
```

Expected: `{"is_favorite": true, "favorited_at": "2026-01-08T..."}`

**Step 4: Commit**

```bash
git add api/app/Http/Controllers/Api/AppController.php api/routes/api.php
git commit -m "feat(api): add toggle favorite endpoint"
```

---

## Task 5: Flutter Model Update

**Files:**
- Modify: `app/lib/features/apps/domain/app_model.dart:1-67`

**Step 1: Add isFavorite field to AppModel**

Update the class:

```dart
class AppModel {
  final int id;
  final String platform;
  final String storeId;
  final String? bundleId;
  final String name;
  final String? iconUrl;
  final String? developer;
  final double? rating;
  final int ratingCount;
  final String? storefront;
  final int? trackedKeywordsCount;
  final DateTime createdAt;
  final bool isFavorite;
  final DateTime? favoritedAt;

  AppModel({
    required this.id,
    required this.platform,
    required this.storeId,
    this.bundleId,
    required this.name,
    this.iconUrl,
    this.developer,
    this.rating,
    required this.ratingCount,
    this.storefront,
    this.trackedKeywordsCount,
    required this.createdAt,
    this.isFavorite = false,
    this.favoritedAt,
  });

  bool get isIos => platform == 'ios';
  bool get isAndroid => platform == 'android';

  AppModel copyWith({
    int? id,
    String? platform,
    String? storeId,
    String? bundleId,
    String? name,
    String? iconUrl,
    String? developer,
    double? rating,
    int? ratingCount,
    String? storefront,
    int? trackedKeywordsCount,
    DateTime? createdAt,
    bool? isFavorite,
    DateTime? favoritedAt,
  }) {
    return AppModel(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      storeId: storeId ?? this.storeId,
      bundleId: bundleId ?? this.bundleId,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      developer: developer ?? this.developer,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      storefront: storefront ?? this.storefront,
      trackedKeywordsCount: trackedKeywordsCount ?? this.trackedKeywordsCount,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      favoritedAt: favoritedAt ?? this.favoritedAt,
    );
  }

  factory AppModel.fromJson(Map<String, dynamic> json) {
    return AppModel(
      id: json['id'] as int,
      platform: json['platform'] as String,
      storeId: json['store_id'] as String,
      bundleId: json['bundle_id'] as String?,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      developer: json['developer'] as String?,
      rating: _parseDouble(json['rating']),
      ratingCount: _parseInt(json['rating_count']) ?? 0,
      storefront: json['storefront'] as String?,
      trackedKeywordsCount: _parseInt(json['tracked_keywords_count']),
      createdAt: DateTime.parse(json['created_at'] as String),
      isFavorite: json['is_favorite'] as bool? ?? false,
      favoritedAt: json['favorited_at'] != null
          ? DateTime.parse(json['favorited_at'] as String)
          : null,
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/features/apps/domain/app_model.dart
git commit -m "feat(flutter): add isFavorite to AppModel"
```

---

## Task 6: Flutter Repository Update

**Files:**
- Modify: `app/lib/features/apps/data/apps_repository.dart`

**Step 1: Add toggleFavorite method**

Add after `refreshApp` method:

```dart
Future<void> toggleFavorite(int appId, bool isFavorite) async {
  try {
    await dio.patch(
      '${ApiConstants.apps}/$appId/favorite',
      data: {'is_favorite': isFavorite},
    );
  } on DioException catch (e) {
    throw ApiException.fromDioError(e);
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/features/apps/data/apps_repository.dart
git commit -m "feat(flutter): add toggleFavorite to repository"
```

---

## Task 7: Flutter Provider Update

**Files:**
- Modify: `app/lib/features/apps/providers/apps_provider.dart`

**Step 1: Add toggleFavorite to AppsNotifier**

Add method to `AppsNotifier` class:

```dart
Future<void> toggleFavorite(int appId) async {
  final currentApps = state.valueOrNull;
  if (currentApps == null) return;

  final appIndex = currentApps.indexWhere((a) => a.id == appId);
  if (appIndex == -1) return;

  final app = currentApps[appIndex];
  final newFavorite = !app.isFavorite;

  // Optimistic update
  final updatedApps = List<AppModel>.from(currentApps);
  updatedApps[appIndex] = app.copyWith(
    isFavorite: newFavorite,
    favoritedAt: newFavorite ? DateTime.now() : null,
  );
  state = AsyncValue.data(updatedApps);

  try {
    await _repository.toggleFavorite(appId, newFavorite);
  } catch (e) {
    // Rollback on error
    state = AsyncValue.data(currentApps);
    rethrow;
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/features/apps/providers/apps_provider.dart
git commit -m "feat(flutter): add toggleFavorite with optimistic update"
```

---

## Task 8: Flutter Sidebar Apps Provider

**Files:**
- Create: `app/lib/features/apps/providers/sidebar_apps_provider.dart`

**Step 1: Create sidebar apps provider**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/app_model.dart';
import 'apps_provider.dart';

class SidebarApps {
  final List<AppModel> favorites;
  final List<AppModel> iosList;
  final List<AppModel> androidList;

  const SidebarApps({
    required this.favorites,
    required this.iosList,
    required this.androidList,
  });

  factory SidebarApps.empty() => const SidebarApps(
        favorites: [],
        iosList: [],
        androidList: [],
      );

  bool get hasTooManyFavorites => favorites.length > 5;
  bool get hasApps => favorites.isNotEmpty || iosList.isNotEmpty || androidList.isNotEmpty;
  int get totalCount => favorites.length + iosList.length + androidList.length;
}

final sidebarAppsProvider = Provider<SidebarApps>((ref) {
  final appsAsync = ref.watch(appsNotifierProvider);

  return appsAsync.when(
    data: (apps) {
      final favorites = apps.where((a) => a.isFavorite).toList()
        ..sort((a, b) => (b.favoritedAt ?? DateTime(0)).compareTo(a.favoritedAt ?? DateTime(0)));

      final nonFavorites = apps.where((a) => !a.isFavorite).toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      return SidebarApps(
        favorites: favorites,
        iosList: nonFavorites.where((a) => a.isIos).toList(),
        androidList: nonFavorites.where((a) => a.isAndroid).toList(),
      );
    },
    loading: () => SidebarApps.empty(),
    error: (_, __) => SidebarApps.empty(),
  );
});
```

**Step 2: Commit**

```bash
git add app/lib/features/apps/providers/sidebar_apps_provider.dart
git commit -m "feat(flutter): add sidebar apps provider with grouping"
```

---

## Task 9: Flutter Sidebar App Tile Widget

**Files:**
- Create: `app/lib/features/apps/presentation/widgets/sidebar_app_tile.dart`

**Step 1: Create sidebar app tile widget**

```dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/app_model.dart';

class SidebarAppTile extends StatefulWidget {
  final AppModel app;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const SidebarAppTile({
    super.key,
    required this.app,
    required this.isSelected,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  State<SidebarAppTile> createState() => _SidebarAppTileState();
}

class _SidebarAppTileState extends State<SidebarAppTile> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Material(
        color: widget.isSelected
            ? AppColors.accent.withAlpha(30)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          hoverColor: AppColors.bgHover,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                // App icon
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.bgActive,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: widget.app.iconUrl != null
                      ? Image.network(
                          widget.app.iconUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.apps,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                        )
                      : const Icon(
                          Icons.apps,
                          size: 14,
                          color: AppColors.textMuted,
                        ),
                ),
                const SizedBox(width: 8),
                // App name
                Expanded(
                  child: Text(
                    widget.app.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: widget.isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Favorite star (visible on hover or if favorite)
                if (_isHovering || widget.app.isFavorite)
                  GestureDetector(
                    onTap: widget.onToggleFavorite,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        widget.app.isFavorite
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 16,
                        color: widget.app.isFavorite
                            ? AppColors.yellow
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/features/apps/presentation/widgets/sidebar_app_tile.dart
git commit -m "feat(flutter): add sidebar app tile with hover star"
```

---

## Task 10: Flutter Collapsible Section Widget

**Files:**
- Create: `app/lib/features/apps/presentation/widgets/collapsible_section.dart`

**Step 1: Create collapsible section widget**

```dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CollapsibleSection extends StatelessWidget {
  final String label;
  final int count;
  final bool isExpanded;
  final VoidCallback onToggle;
  final List<Widget> children;
  final double maxHeight;

  const CollapsibleSection({
    super.key,
    required this.label,
    required this.count,
    required this.isExpanded,
    required this.onToggle,
    required this.children,
    this.maxHeight = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            hoverColor: AppColors.bgHover,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_right_rounded,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.bgActive,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Content
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/features/apps/presentation/widgets/collapsible_section.dart
git commit -m "feat(flutter): add collapsible section widget"
```

---

## Task 11: Flutter Sidebar Apps List Widget

**Files:**
- Create: `app/lib/features/apps/presentation/widgets/sidebar_apps_list.dart`

**Step 1: Create sidebar apps list widget**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/apps_provider.dart';
import '../../providers/sidebar_apps_provider.dart';
import 'collapsible_section.dart';
import 'sidebar_app_tile.dart';

class SidebarAppsList extends ConsumerStatefulWidget {
  final int? selectedAppId;

  const SidebarAppsList({super.key, this.selectedAppId});

  @override
  ConsumerState<SidebarAppsList> createState() => _SidebarAppsListState();
}

class _SidebarAppsListState extends ConsumerState<SidebarAppsList> {
  bool _iosExpanded = false;
  bool _androidExpanded = false;
  bool _prefsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _iosExpanded = prefs.getBool('sidebar_ios_expanded') ?? false;
      _androidExpanded = prefs.getBool('sidebar_android_expanded') ?? false;
      _prefsLoaded = true;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sidebar_ios_expanded', _iosExpanded);
    await prefs.setBool('sidebar_android_expanded', _androidExpanded);
  }

  void _toggleIos() {
    setState(() => _iosExpanded = !_iosExpanded);
    _savePreferences();
  }

  void _toggleAndroid() {
    setState(() => _androidExpanded = !_androidExpanded);
    _savePreferences();
  }

  @override
  Widget build(BuildContext context) {
    final sidebarApps = ref.watch(sidebarAppsProvider);

    if (!_prefsLoaded || !sidebarApps.hasApps) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Favorites section
        if (sidebarApps.favorites.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'FAVORITES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: AppColors.textMuted,
                  ),
                ),
                if (sidebarApps.hasTooManyFavorites) ...[
                  const SizedBox(width: 6),
                  Tooltip(
                    message: 'Consider keeping 5 or fewer favorites',
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: 12,
                      color: AppColors.yellow.withAlpha(180),
                    ),
                  ),
                ],
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: sidebarApps.favorites.map((app) {
                return SidebarAppTile(
                  app: app,
                  isSelected: app.id == widget.selectedAppId,
                  onTap: () => context.go('/apps/${app.id}'),
                  onToggleFavorite: () => _toggleFavorite(app.id),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // iOS section
        if (sidebarApps.iosList.isNotEmpty)
          CollapsibleSection(
            label: 'iPHONE',
            count: sidebarApps.iosList.length,
            isExpanded: _iosExpanded,
            onToggle: _toggleIos,
            children: sidebarApps.iosList.map((app) {
              return SidebarAppTile(
                app: app,
                isSelected: app.id == widget.selectedAppId,
                onTap: () => context.go('/apps/${app.id}'),
                onToggleFavorite: () => _toggleFavorite(app.id),
              );
            }).toList(),
          ),

        // Android section
        if (sidebarApps.androidList.isNotEmpty)
          CollapsibleSection(
            label: 'ANDROID',
            count: sidebarApps.androidList.length,
            isExpanded: _androidExpanded,
            onToggle: _toggleAndroid,
            children: sidebarApps.androidList.map((app) {
              return SidebarAppTile(
                app: app,
                isSelected: app.id == widget.selectedAppId,
                onTap: () => context.go('/apps/${app.id}'),
                onToggleFavorite: () => _toggleFavorite(app.id),
              );
            }).toList(),
          ),

        const SizedBox(height: 8),
      ],
    );
  }

  void _toggleFavorite(int appId) {
    ref.read(appsNotifierProvider.notifier).toggleFavorite(appId);
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/features/apps/presentation/widgets/sidebar_apps_list.dart
git commit -m "feat(flutter): add sidebar apps list with sections"
```

---

## Task 12: Flutter Integrate Sidebar in Router

**Files:**
- Modify: `app/lib/core/router/app_router.dart`

**Step 1: Add import**

At top of file, add:

```dart
import '../../features/apps/presentation/widgets/sidebar_apps_list.dart';
import '../../features/apps/providers/apps_provider.dart';
```

**Step 2: Update _GlassSidebar to accept selectedAppId**

Update `_GlassSidebar` class definition:

```dart
class _GlassSidebar extends StatelessWidget {
  final int selectedIndex;
  final int? selectedAppId;
  final ValueChanged<int> onDestinationSelected;
  final String userName;
  final VoidCallback onLogout;

  const _GlassSidebar({
    required this.selectedIndex,
    required this.selectedAppId,
    required this.onDestinationSelected,
    required this.userName,
    required this.onLogout,
  });
```

**Step 3: Add SidebarAppsList in sidebar build method**

In `_GlassSidebar.build`, inside the `Column` children, after the OVERVIEW section and before `const SizedBox(height: 20)`, insert:

```dart
const SizedBox(height: 16),
SidebarAppsList(selectedAppId: selectedAppId),
```

**Step 4: Update MainShell to extract selectedAppId**

Update `_getSelectedIndex` to also return app ID, and update the call in `build`:

First, add a helper method to `MainShell`:

```dart
int? _getSelectedAppId(BuildContext context) {
  final location = GoRouterState.of(context).matchedLocation;
  final match = RegExp(r'^/apps/(\d+)').firstMatch(location);
  if (match != null) {
    return int.tryParse(match.group(1)!);
  }
  return null;
}
```

Then update the `_GlassSidebar` call in `build`:

```dart
_GlassSidebar(
  selectedIndex: _getSelectedIndex(context),
  selectedAppId: _getSelectedAppId(context),
  onDestinationSelected: (index) => _onDestinationSelected(context, index),
  userName: user?.name ?? 'User',
  onLogout: () => ref.read(authStateProvider.notifier).logout(),
),
```

**Step 5: Commit**

```bash
git add app/lib/core/router/app_router.dart
git commit -m "feat(flutter): integrate apps list in sidebar"
```

---

## Task 13: Flutter Add Favorite Button to App Detail

**Files:**
- Modify: `app/lib/features/apps/presentation/app_detail_screen.dart`

**Step 1: Update _Toolbar to accept isFavorite and onToggleFavorite**

Update `_Toolbar` class:

```dart
class _Toolbar extends StatelessWidget {
  final String appName;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onToggleFavorite;
  final VoidCallback onDelete;
  final VoidCallback onViewRatings;

  const _Toolbar({
    required this.appName,
    required this.isFavorite,
    required this.onBack,
    required this.onToggleFavorite,
    required this.onDelete,
    required this.onViewRatings,
  });
```

**Step 2: Add favorite button in _Toolbar build**

In the `Row` children, after `Expanded(...)` and before `ToolbarButton` for Ratings, add:

```dart
ToolbarButton(
  icon: isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
  label: 'Favorite',
  iconColor: isFavorite ? AppColors.yellow : null,
  onTap: onToggleFavorite,
),
const SizedBox(width: 10),
```

**Step 3: Update _Toolbar call in build method**

In `AppDetailScreen.build`, update the `_Toolbar` widget:

```dart
_Toolbar(
  appName: app.name,
  isFavorite: app.isFavorite,
  onBack: () => context.go('/apps'),
  onToggleFavorite: () => ref.read(appsNotifierProvider.notifier).toggleFavorite(widget.appId),
  onDelete: _deleteApp,
  onViewRatings: () => context.push(
    '/apps/${widget.appId}/ratings?name=${Uri.encodeComponent(app.name)}',
  ),
),
```

**Step 4: Update ToolbarButton to accept iconColor**

In `app/lib/shared/widgets/buttons.dart`, update `ToolbarButton`:

```dart
class ToolbarButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;
  final bool isLoading;
  final Color? iconColor;

  const ToolbarButton({
    super.key,
    this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
    this.isLoading = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.red : AppColors.textSecondary;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        hoverColor: AppColors.bgHover,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.glassBorder),
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (icon != null)
                Icon(icon, size: 16, color: iconColor ?? color),
              if (icon != null || isLoading) const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Step 5: Commit**

```bash
git add app/lib/features/apps/presentation/app_detail_screen.dart app/lib/shared/widgets/buttons.dart
git commit -m "feat(flutter): add favorite toggle to app detail toolbar"
```

---

## Task 14: Final Testing & Cleanup

**Step 1: Run Flutter app**

```bash
cd app && flutter run -d macos
```

**Step 2: Test scenarios**

- [ ] Apps appear in sidebar grouped by platform
- [ ] Hovering shows star icon
- [ ] Clicking star adds to favorites
- [ ] Favorites appear at top
- [ ] Favorites persist after refresh
- [ ] iOS/Android sections collapse/expand
- [ ] Collapse state persists
- [ ] Favorite button works in app detail
- [ ] Warning appears with >5 favorites

**Step 3: Final commit**

```bash
git add -A
git commit -m "feat: complete sidebar favorites implementation"
```

---

## Summary

| Task | Description |
|------|-------------|
| 1 | Backend migration - add columns |
| 2 | Backend models - pivot fields |
| 3 | Backend index - return favorites |
| 4 | Backend endpoint - toggle favorite |
| 5 | Flutter model - add fields |
| 6 | Flutter repository - toggle method |
| 7 | Flutter provider - optimistic update |
| 8 | Flutter sidebar provider - grouping |
| 9 | Flutter sidebar tile widget |
| 10 | Flutter collapsible section widget |
| 11 | Flutter sidebar apps list widget |
| 12 | Flutter router integration |
| 13 | Flutter app detail favorite button |
| 14 | Testing & cleanup |
