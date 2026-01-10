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
