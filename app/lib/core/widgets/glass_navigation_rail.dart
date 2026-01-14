import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../utils/l10n_extension.dart';
import '../../features/notifications/providers/notifications_provider.dart';

class GlassNavigationRail extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final unreadAsync = ref.watch(unreadCountProvider);
    final unreadCount = unreadAsync.valueOrNull ?? 0;

    return Container(
      width: 72,
      decoration: BoxDecoration(
        color: colors.bgSurface,
        border: Border(
          right: BorderSide(color: colors.border),
        ),
      ),
      child: Column(
        children: [
          // Logo
          InkWell(
            onTap: onLogoTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Navigation items
          Expanded(
            child: NavigationRail(
              backgroundColor: Colors.transparent,
              indicatorColor: colors.accentMuted,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.grid_view_outlined, color: colors.textMuted),
                  selectedIcon: Icon(Icons.grid_view_rounded, color: colors.accent),
                  label: Text(
                    context.l10n.nav_dashboard,
                    style: TextStyle(fontSize: 10, color: colors.textSecondary),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.apps_outlined, color: colors.textMuted),
                  selectedIcon: Icon(Icons.apps_rounded, color: colors.accent),
                  label: Text(
                    context.l10n.nav_myApps,
                    style: TextStyle(fontSize: 10, color: colors.textSecondary),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.search_outlined, color: colors.textMuted),
                  selectedIcon: Icon(Icons.search_rounded, color: colors.accent),
                  label: Text(
                    context.l10n.nav_keywords,
                    style: TextStyle(fontSize: 10, color: colors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          // Notification bell
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text('$unreadCount'),
              child: IconButton(
                icon: Icon(Icons.notifications_outlined, color: colors.textMuted),
                onPressed: () => context.go('/notifications'),
                tooltip: context.l10n.nav_alerts,
              ),
            ),
          ),
          // User menu at bottom
          trailing,
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
