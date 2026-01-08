import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../widgets/keyrank_logo.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/apps/presentation/apps_list_screen.dart';
import '../../features/apps/presentation/app_detail_screen.dart';
import '../../features/apps/presentation/add_app_screen.dart';
import '../../features/keywords/presentation/keyword_search_screen.dart';
import '../../features/ratings/presentation/app_ratings_screen.dart';
import '../../features/reviews/presentation/country_reviews_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isAuthenticated = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/apps',
            builder: (context, state) => const AppsListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddAppScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return AppDetailScreen(appId: id);
                },
              ),
              GoRoute(
                path: ':id/ratings',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  final appName = state.uri.queryParameters['name'] ?? 'App';
                  return AppRatingsScreen(appId: id, appName: appName);
                },
              ),
              GoRoute(
                path: ':id/reviews/:country',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  final country = state.pathParameters['country']!;
                  final appName = state.uri.queryParameters['name'] ?? 'App';
                  return CountryReviewsScreen(appId: id, appName: appName, country: country);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/keywords',
            builder: (context, state) => const KeywordSearchScreen(),
          ),
        ],
      ),
    ],
  );
});

class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Glass sidebar
            _GlassSidebar(
              selectedIndex: _getSelectedIndex(context),
              onDestinationSelected: (index) => _onDestinationSelected(context, index),
              userName: user?.name ?? 'User',
              onLogout: () => ref.read(authStateProvider.notifier).logout(),
            ),
            const SizedBox(width: 12),
            // Main content
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppColors.radiusLarge),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/apps')) return 1;
    if (location.startsWith('/keywords')) return 2;
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/apps');
        break;
      case 2:
        context.go('/keywords');
        break;
    }
  }
}

class _GlassSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final String userName;
  final VoidCallback onLogout;

  const _GlassSidebar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.userName,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: AppColors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Column(
            children: [
              // Header with logo
              _buildHeader(context),

              // Navigation
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNavSection(
                        context,
                        label: 'OVERVIEW',
                        items: [
                          _NavItemData(
                            icon: Icons.dashboard_outlined,
                            selectedIcon: Icons.dashboard,
                            label: 'Dashboard',
                            index: 0,
                          ),
                          _NavItemData(
                            icon: Icons.apps_outlined,
                            selectedIcon: Icons.apps,
                            label: 'My Apps',
                            index: 1,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildNavSection(
                        context,
                        label: 'RESEARCH',
                        items: [
                          _NavItemData(
                            icon: Icons.search_outlined,
                            selectedIcon: Icons.search,
                            label: 'Keywords',
                            index: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Footer with user
              _buildUserFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const KeyrankLogoIcon(size: 36),
          const SizedBox(width: 12),
          const Text(
            'keyrank',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavSection(
    BuildContext context, {
    required String label,
    required List<_NavItemData> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: AppColors.textMuted,
            ),
          ),
        ),
        ...items.map((item) => _buildNavItem(context, item)),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, _NavItemData item) {
    final isSelected = selectedIndex == item.index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: isSelected ? AppColors.accent.withAlpha(30) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: InkWell(
          onTap: () => onDestinationSelected(item.index),
          borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          hoverColor: AppColors.bgHover,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  isSelected ? item.selectedIcon : item.icon,
                  size: 20,
                  color: isSelected ? AppColors.accent : AppColors.textMuted,
                ),
                const SizedBox(width: 12),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                if (item.badge != null) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.bgActive,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.badge!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserFooter(BuildContext context) {
    final initials = userName.isNotEmpty
        ? userName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
        : 'U';

    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(100),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        child: InkWell(
          onTap: onLogout,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          hoverColor: AppColors.bgHover,
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
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        'Sign out',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.logout_rounded,
                  size: 18,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int index;
  final String? badge;

  const _NavItemData({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.index,
    this.badge,
  });
}
