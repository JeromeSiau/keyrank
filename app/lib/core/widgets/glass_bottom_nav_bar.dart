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
