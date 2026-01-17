import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/breakpoints.dart';
import '../providers/app_context_provider.dart';
import '../theme/app_colors.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../shared/widgets/floating_chat_button.dart';
import 'glass_bottom_nav_bar.dart';
import 'app_navigation_rail.dart';

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
    final selectedApp = ref.watch(appContextProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenSize = screenWidth.screenSize;

    return Scaffold(
      backgroundColor: colors.bgBase,
      body: Stack(
        children: [
          switch (screenSize) {
            ScreenSize.mobile => _buildMobileLayout(context, ref, colors),
            ScreenSize.tablet => _buildTabletLayout(context, ref, user, colors),
            ScreenSize.desktop => _buildDesktopLayout(colors),
          },
          // Floating chat button - only visible when an app is selected and NOT on chat screen
          if (selectedApp != null && !GoRouterState.of(context).uri.path.startsWith('/chat'))
            Positioned(
              right: 24,
              bottom: screenSize == ScreenSize.mobile ? 80 : 24,
              child: FloatingChatButton(
                onTap: () => context.go('/chat'),
                isExpanded: screenSize != ScreenSize.mobile,
              ),
            ),
        ],
      ),
    );
  }

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
          AppNavigationRail(
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
