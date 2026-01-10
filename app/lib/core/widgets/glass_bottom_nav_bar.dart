import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../utils/l10n_extension.dart';
import '../../features/notifications/providers/notifications_provider.dart';

class GlassBottomNavBar extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const GlassBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final unreadAsync = ref.watch(unreadCountProvider);
    final unreadCount = unreadAsync.valueOrNull ?? 0;

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
            onDestinationSelected: (index) {
              // Handle notification bell tap (index 3)
              if (index == 3) {
                context.go('/notifications');
              } else {
                // Adjust index for items after the bell
                onDestinationSelected(index < 3 ? index : index - 1);
              }
            },
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
                icon: Badge(
                  isLabelVisible: unreadCount > 0,
                  label: Text('$unreadCount'),
                  child: Icon(Icons.notifications_outlined, color: colors.textMuted),
                ),
                selectedIcon: Badge(
                  isLabelVisible: unreadCount > 0,
                  label: Text('$unreadCount'),
                  child: Icon(Icons.notifications, color: colors.accent),
                ),
                label: context.l10n.nav_notifications,
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
