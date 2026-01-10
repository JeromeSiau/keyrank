import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../widgets/keyrank_logo.dart';
import '../widgets/user_menu.dart';
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
import '../../features/insights/presentation/app_insights_screen.dart';
import '../../features/insights/presentation/insights_compare_screen.dart';
import '../../features/apps/presentation/widgets/sidebar_apps_list.dart';
import '../../features/settings/presentation/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final authNotifier = ref.read(authStateProvider.notifier);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(authNotifier.stream),
    redirect: (context, state) {
      final isAuthenticated = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (authState.isLoading) {
        return null;
      }

      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }
      if (isAuthenticated && isAuthRoute) {
        return '/dashboard';
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
              GoRoute(
                path: ':id/insights',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  final appName = state.uri.queryParameters['name'] ?? 'App';
                  return AppInsightsScreen(appId: id, appName: appName);
                },
              ),
              GoRoute(
                path: 'compare',
                builder: (context, state) {
                  final idsParam = state.uri.queryParameters['ids'] ?? '';
                  final ids = idsParam.split(',').map((s) => int.tryParse(s)).whereType<int>().toList();
                  return InsightsCompareScreen(appIds: ids);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/keywords',
            builder: (context, state) => const KeywordSearchScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Glass sidebar
            _GlassSidebar(
              selectedIndex: _getSelectedIndex(context),
              selectedAppId: _getSelectedAppId(context),
              onDestinationSelected: (index) => _onDestinationSelected(context, index),
              userName: user?.name ?? 'User',
              userEmail: user?.email ?? '',
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

  int? _getSelectedAppId(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final match = RegExp(r'^/apps/(\d+)').firstMatch(location);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
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
  final int? selectedAppId;
  final ValueChanged<int> onDestinationSelected;
  final String userName;
  final String userEmail;
  final VoidCallback onLogout;

  const _GlassSidebar({
    required this.selectedIndex,
    required this.selectedAppId,
    required this.onDestinationSelected,
    required this.userName,
    required this.userEmail,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        border: Border.all(color: isDark ? AppColors.glassBorder : AppColorsLight.glassBorder),
        boxShadow: [
          BoxShadow(
            color: isDark ? const Color(0x20000000) : const Color(0x10000000),
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
              // Header with logo
              _buildHeader(context, isDark),

              // Navigation
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNavSection(
                        context,
                        isDark: isDark,
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
                      const SizedBox(height: 16),
                      SidebarAppsList(selectedAppId: selectedAppId),
                      const SizedBox(height: 20),
                      _buildNavSection(
                        context,
                        isDark: isDark,
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

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const KeyrankLogoIcon(size: 36),
          const SizedBox(width: 12),
          Text(
            'keyrank',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavSection(
    BuildContext context, {
    required bool isDark,
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
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            ),
          ),
        ),
        ...items.map((item) => _buildNavItem(context, item, isDark)),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, _NavItemData item, bool isDark) {
    final isSelected = selectedIndex == item.index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: isSelected
            ? (isDark ? AppColors.accent : AppColorsLight.accent).withAlpha(30)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: InkWell(
          onTap: () => onDestinationSelected(item.index),
          borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          hoverColor: isDark ? AppColors.bgHover : AppColorsLight.bgHover,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  isSelected ? item.selectedIcon : item.icon,
                  size: 20,
                  color: isSelected
                      ? (isDark ? AppColors.accent : AppColorsLight.accent)
                      : (isDark ? AppColors.textMuted : AppColorsLight.textMuted),
                ),
                const SizedBox(width: 12),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? AppColors.textPrimary : AppColorsLight.textPrimary)
                        : (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary),
                  ),
                ),
                if (item.badge != null) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.bgActive : AppColorsLight.bgActive,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.badge!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
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
    return UserMenu(
      userName: userName,
      userEmail: userEmail,
      onLogout: onLogout,
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

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
