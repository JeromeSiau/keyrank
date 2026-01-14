import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../utils/l10n_extension.dart';
import '../widgets/keyrank_logo.dart';
import '../widgets/user_menu.dart';
import '../widgets/responsive_shell.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/apps/presentation/apps_list_screen.dart';
import '../../features/apps/presentation/app_detail_screen.dart';
import '../../features/apps/presentation/add_app_screen.dart';
import '../../features/keywords/presentation/discover_screen.dart';
import '../../features/ratings/presentation/app_ratings_screen.dart';
import '../../features/reviews/presentation/country_reviews_screen.dart';
import '../../features/reviews/presentation/reviews_inbox_screen.dart';
import '../../features/insights/presentation/app_insights_screen.dart';
import '../../features/insights/presentation/insights_compare_screen.dart';
import '../widgets/app_context_switcher.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/notifications/providers/notifications_provider.dart';
import '../../features/alerts/presentation/alert_rule_builder_screen.dart';
import '../../features/alerts/presentation/alerts_screen.dart';
import '../../features/alerts/domain/alert_rule_model.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/store_connections/presentation/store_connections_screen.dart';
import '../../features/store_connections/presentation/connect_apple_screen.dart';
import '../../features/store_connections/presentation/connect_google_screen.dart';
import '../../features/integrations/presentation/integrations_screen.dart';
import '../../features/integrations/presentation/connect_app_store_screen.dart';
import '../../features/integrations/presentation/connect_google_play_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/onboarding/providers/onboarding_provider.dart';
import '../../features/analytics/presentation/app_analytics_screen.dart';
import '../../features/chat/presentation/chat_screen.dart';
import '../../features/chat/presentation/chat_conversation_screen.dart';
import '../../features/ratings/presentation/ratings_analysis_screen.dart';
import '../../features/keywords/presentation/top_charts_screen.dart';
import '../../features/keywords/presentation/competitors_screen.dart';
import '../../features/billing/presentation/billing_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final authNotifier = ref.read(authStateProvider.notifier);
  final onboardingStatus = ref.watch(onboardingStatusProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(authNotifier.stream),
    redirect: (context, state) {
      final isAuthenticated = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final isOnboardingRoute = state.matchedLocation.startsWith('/onboarding');

      if (authState.isLoading) {
        return null;
      }

      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }
      if (isAuthenticated && isAuthRoute) {
        // Check if user needs onboarding
        final status = onboardingStatus.valueOrNull;
        if (status != null && !status.isCompleted) {
          return '/onboarding';
        }
        return '/dashboard';
      }

      // Redirect to onboarding if needed (for authenticated users)
      if (isAuthenticated && !isOnboardingRoute) {
        final status = onboardingStatus.valueOrNull;
        if (status != null && !status.isCompleted) {
          return '/onboarding';
        }
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
      // Onboarding (outside main shell)
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
        routes: [
          GoRoute(
            path: 'connect/app-store',
            builder: (context, state) => const ConnectAppStoreScreen(),
          ),
          GoRoute(
            path: 'connect/google-play',
            builder: (context, state) => const ConnectGooglePlayScreen(),
          ),
        ],
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
                path: 'compare',
                builder: (context, state) {
                  final idsParam = state.uri.queryParameters['ids'] ?? '';
                  final ids = idsParam.split(',').map((s) => int.tryParse(s)).whereType<int>().toList();
                  return InsightsCompareScreen(appIds: ids);
                },
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
                path: ':id/analytics',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  final appName = state.uri.queryParameters['name'] ?? 'App';
                  return AppAnalyticsScreen(appId: id, appName: appName);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/discover',
            builder: (context, state) => const DiscoverScreen(),
            routes: [
              GoRoute(
                path: 'preview/:platform/:storeId',
                builder: (context, state) {
                  final platform = state.pathParameters['platform']!;
                  final storeId = state.pathParameters['storeId']!;
                  final country = state.uri.queryParameters['country'] ?? 'us';
                  return AppDetailScreen(
                    platform: platform,
                    storeId: storeId,
                    country: country,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
            routes: [
              // Legacy store connections (V1)
              GoRoute(
                path: 'connections',
                builder: (context, state) => const StoreConnectionsScreen(),
                routes: [
                  GoRoute(
                    path: 'apple',
                    builder: (context, state) => const ConnectAppleScreen(),
                  ),
                  GoRoute(
                    path: 'google',
                    builder: (context, state) => const ConnectGoogleScreen(),
                  ),
                ],
              ),
              // New integrations (V2)
              GoRoute(
                path: 'integrations',
                builder: (context, state) => const IntegrationsScreen(),
                routes: [
                  GoRoute(
                    path: 'app-store',
                    builder: (context, state) => const ConnectAppStoreScreen(),
                  ),
                  GoRoute(
                    path: 'google-play',
                    builder: (context, state) => const ConnectGooglePlayScreen(),
                  ),
                ],
              ),
              // Billing
              GoRoute(
                path: 'billing',
                builder: (context, state) => const BillingScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/reviews',
            builder: (context, state) => const ReviewsInboxScreen(),
          ),
          GoRoute(
            path: '/ratings',
            builder: (context, state) => const RatingsAnalysisScreen(),
          ),
          GoRoute(
            path: '/top-charts',
            builder: (context, state) => const TopChartsScreen(),
          ),
          GoRoute(
            path: '/competitors',
            builder: (context, state) => const CompetitorsScreen(),
          ),
          GoRoute(
            path: '/alerts',
            builder: (context, state) => const AlertsScreen(),
          ),
          GoRoute(
            path: '/alerts/builder',
            builder: (context, state) {
              final existingRule = state.extra as AlertRuleModel?;
              return AlertRuleBuilderScreen(existingRule: existingRule);
            },
          ),
          GoRoute(
            path: '/chat',
            builder: (context, state) => const ChatScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return ChatConversationScreen(conversationId: id);
                },
              ),
            ],
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

    return ResponsiveShell(
      sidebar: _GlassSidebar(
        selectedIndex: _getSelectedIndex(context),
        onDestinationSelected: (index) => _onDestinationSelected(context, index),
        userName: user?.name ?? 'User',
        userEmail: user?.email ?? '',
        onLogout: () => ref.read(authStateProvider.notifier).logout(),
      ),
      child: child,
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/apps')) return 1;
    if (location.startsWith('/discover')) return 2; // Keyword Inspector also uses /discover
    if (location.startsWith('/reviews')) return 3;
    if (location.startsWith('/ratings')) return 4;
    if (location.startsWith('/top-charts')) return 6;
    if (location.startsWith('/competitors')) return 7;
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
        context.go('/discover'); // Keyword Inspector
        break;
      case 3:
        context.go('/reviews');
        break;
      case 4:
        context.go('/ratings');
        break;
      case 5:
        context.go('/discover');
        break;
      case 6:
        context.go('/top-charts');
        break;
      case 7:
        context.go('/competitors');
        break;
    }
  }
}

class _GlassSidebar extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final String userName;
  final String userEmail;
  final VoidCallback onLogout;

  const _GlassSidebar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.userName,
    required this.userEmail,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unreadAsync = ref.watch(unreadCountProvider);
    final unreadCount = unreadAsync.valueOrNull ?? 0;

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
              // Header with logo and notification bell
              _buildHeader(context, isDark, unreadCount),

              // App context switcher
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: AppContextSwitcher(),
              ),
              const SizedBox(height: 16),

              // Navigation
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // OVERVIEW section (only Dashboard now)
                      _buildNavSection(
                        context,
                        isDark: isDark,
                        label: context.l10n.nav_overview,
                        items: [
                          _NavItemData(
                            icon: Icons.dashboard_outlined,
                            selectedIcon: Icons.dashboard,
                            label: context.l10n.nav_dashboard,
                            index: 0,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // OPTIMIZATION section
                      _buildNavSection(
                        context,
                        isDark: isDark,
                        label: context.l10n.nav_optimization,
                        items: [
                          _NavItemData(
                            icon: Icons.search_outlined,
                            selectedIcon: Icons.search,
                            label: context.l10n.nav_keywordInspector,
                            index: 2,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ENGAGEMENT section
                      _buildNavSection(
                        context,
                        isDark: isDark,
                        label: context.l10n.nav_engagement,
                        items: [
                          _NavItemData(
                            icon: Icons.inbox_outlined,
                            selectedIcon: Icons.inbox_rounded,
                            label: context.l10n.nav_reviewsInbox,
                            index: 3,
                          ),
                          _NavItemData(
                            icon: Icons.star_outline,
                            selectedIcon: Icons.star,
                            label: context.l10n.nav_ratingsAnalysis,
                            index: 4,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // INTELLIGENCE section
                      _buildNavSection(
                        context,
                        isDark: isDark,
                        label: context.l10n.nav_intelligence,
                        items: [
                          _NavItemData(
                            icon: Icons.explore_outlined,
                            selectedIcon: Icons.explore,
                            label: context.l10n.nav_discover,
                            index: 5,
                          ),
                          _NavItemData(
                            icon: Icons.leaderboard_outlined,
                            selectedIcon: Icons.leaderboard,
                            label: context.l10n.nav_topCharts,
                            index: 6,
                          ),
                          _NavItemData(
                            icon: Icons.people_outline,
                            selectedIcon: Icons.people,
                            label: context.l10n.nav_competitors,
                            index: 7,
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

  Widget _buildHeader(BuildContext context, bool isDark, int unreadCount) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => context.go('/dashboard'),
              borderRadius: BorderRadius.circular(8),
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
            ),
          ),
          Badge(
            isLabelVisible: unreadCount > 0,
            label: Text('$unreadCount'),
            child: IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              ),
              onPressed: () => context.go('/notifications'),
              tooltip: context.l10n.nav_notifications,
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
