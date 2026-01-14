import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/l10n_extension.dart';
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
        selectedAppId: _getSelectedAppId(context),
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
    // Your Apps section
    if (location.startsWith('/apps')) return 1;
    if (location.startsWith('/ratings')) return 2;
    if (location.startsWith('/reviews')) return 3;
    // Research section
    if (location.startsWith('/discover')) return 4;
    if (location.startsWith('/competitors')) return 5;
    if (location.startsWith('/top-charts')) return 6;
    // Settings section
    if (location.startsWith('/alerts')) return 7;
    if (location.startsWith('/settings')) return 8;
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
      // Your Apps section
      case 1:
        context.go('/apps');
        break;
      case 2:
        context.go('/ratings');
        break;
      case 3:
        context.go('/reviews');
        break;
      // Research section
      case 4:
        context.go('/discover');
        break;
      case 5:
        context.go('/competitors');
        break;
      case 6:
        context.go('/top-charts');
        break;
      // Settings section
      case 7:
        context.go('/alerts');
        break;
      case 8:
        context.go('/settings');
        break;
    }
  }
}

/// Clean sidebar with new navigation structure
class _GlassSidebar extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final unreadAsync = ref.watch(unreadCountProvider);
    final unreadCount = unreadAsync.valueOrNull ?? 0;

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: colors.bgSurface,
        border: Border(
          right: BorderSide(color: colors.border, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Header with logo and notification bell
          _buildHeader(context, colors, unreadCount),

          // Navigation
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // OVERVIEW section
                  _buildNavSection(
                    context,
                    colors: colors,
                    label: context.l10n.nav_overview,
                    items: [
                      _NavItemData(
                        icon: Icons.grid_view_outlined,
                        selectedIcon: Icons.grid_view_rounded,
                        label: context.l10n.nav_dashboard,
                        index: 0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // YOUR APPS section
                  _buildNavSection(
                    context,
                    colors: colors,
                    label: context.l10n.nav_yourApps,
                    items: [
                      _NavItemData(
                        icon: Icons.apps_outlined,
                        selectedIcon: Icons.apps_rounded,
                        label: context.l10n.nav_myApps,
                        index: 1,
                      ),
                      _NavItemData(
                        icon: Icons.trending_up_outlined,
                        selectedIcon: Icons.trending_up_rounded,
                        label: context.l10n.nav_rankings,
                        index: 2,
                      ),
                      _NavItemData(
                        icon: Icons.chat_bubble_outline_rounded,
                        selectedIcon: Icons.chat_bubble_rounded,
                        label: context.l10n.nav_reviews,
                        index: 3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // RESEARCH section
                  _buildNavSection(
                    context,
                    colors: colors,
                    label: context.l10n.nav_research,
                    items: [
                      _NavItemData(
                        icon: Icons.search_outlined,
                        selectedIcon: Icons.search_rounded,
                        label: context.l10n.nav_keywords,
                        index: 4,
                      ),
                      _NavItemData(
                        icon: Icons.groups_outlined,
                        selectedIcon: Icons.groups_rounded,
                        label: context.l10n.nav_competitors,
                        index: 5,
                      ),
                      _NavItemData(
                        icon: Icons.leaderboard_outlined,
                        selectedIcon: Icons.leaderboard_rounded,
                        label: context.l10n.nav_topCharts,
                        index: 6,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // SETTINGS section
                  _buildNavSection(
                    context,
                    colors: colors,
                    label: context.l10n.nav_settings,
                    items: [
                      _NavItemData(
                        icon: Icons.notifications_outlined,
                        selectedIcon: Icons.notifications_rounded,
                        label: context.l10n.nav_alerts,
                        index: 7,
                        badgeCount: unreadCount > 0 ? unreadCount : null,
                      ),
                      _NavItemData(
                        icon: Icons.settings_outlined,
                        selectedIcon: Icons.settings_rounded,
                        label: context.l10n.common_settings,
                        index: 8,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Footer with user
          _buildUserFooter(context, colors),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppColorsExtension colors, int unreadCount) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () => context.go('/dashboard'),
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            // Bar chart icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colors.accent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.bar_chart_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            // Logo text: key**rank**
            RichText(
              text: TextSpan(
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  color: colors.textPrimary,
                  letterSpacing: -0.5,
                ),
                children: const [
                  TextSpan(
                    text: 'key',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text: 'rank',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavSection(
    BuildContext context, {
    required AppColorsExtension colors,
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
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: colors.textMuted,
            ),
          ),
        ),
        ...items.map((item) => _buildNavItem(context, item, colors)),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, _NavItemData item, AppColorsExtension colors) {
    final isSelected = selectedIndex == item.index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: isSelected ? colors.accentMuted : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => onDestinationSelected(item.index),
          borderRadius: BorderRadius.circular(8),
          hoverColor: colors.bgHover,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  isSelected ? item.selectedIcon : item.icon,
                  size: 20,
                  color: isSelected ? colors.accent : colors.textMuted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? colors.textPrimary : colors.textSecondary,
                    ),
                  ),
                ),
                if (item.badgeCount != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.accent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${item.badgeCount}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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

  Widget _buildUserFooter(BuildContext context, AppColorsExtension colors) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.border, width: 1),
        ),
      ),
      child: UserMenu(
        userName: userName,
        userEmail: userEmail,
        onLogout: onLogout,
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int index;
  final int? badgeCount;

  const _NavItemData({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.index,
    this.badgeCount,
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
