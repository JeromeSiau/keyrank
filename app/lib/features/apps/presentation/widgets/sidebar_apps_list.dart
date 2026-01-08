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
