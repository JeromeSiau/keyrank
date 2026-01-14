import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/breakpoints.dart';
import '../theme/app_colors.dart';
import '../../features/auth/providers/auth_provider.dart';
import 'glass_bottom_nav_bar.dart';
import 'glass_navigation_rail.dart';

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
        // Safe area for status bar
        Container(
          color: colors.bgSurface,
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

  Widget _buildTabletLayout(
    BuildContext context,
    WidgetRef ref,
    dynamic user,
    AppColorsExtension colors,
  ) {
    return Row(
      children: [
        // Navigation rail
        GlassNavigationRail(
          selectedIndex: _getSelectedIndex(context),
          onDestinationSelected: (index) => _onDestinationSelected(context, ref, index),
          onLogoTap: () => context.go('/dashboard'),
          trailing: _buildCompactUserMenu(context, ref, user, colors),
        ),
        // Content with border
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: colors.bgBase,
              border: Border(
                left: BorderSide(color: colors.border, width: 1),
              ),
            ),
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(AppColorsExtension colors) {
    return Row(
      children: [
        sidebar,
        // Content area
        Expanded(
          child: Container(
            color: colors.bgBase,
            child: child,
          ),
        ),
      ],
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
        borderRadius: BorderRadius.circular(12),
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
              Text(
                'Settings',
                style: GoogleFonts.plusJakartaSans(color: colors.textPrimary),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout_rounded, size: 18, color: colors.textSecondary),
              const SizedBox(width: 12),
              Text(
                'Logout',
                style: GoogleFonts.plusJakartaSans(color: colors.textPrimary),
              ),
            ],
          ),
        ),
      ],
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colors.accent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            initials,
            style: GoogleFonts.plusJakartaSans(
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
