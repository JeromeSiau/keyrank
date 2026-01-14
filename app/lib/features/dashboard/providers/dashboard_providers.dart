import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/providers/app_context_provider.dart';
import '../data/dashboard_repository.dart';
import '../domain/hero_metrics.dart';
import '../domain/ranking_mover.dart';

/// Repository provider
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return DashboardRepository(dio);
});

/// Hero metrics provider - filters by app context if selected.
final heroMetricsProvider = FutureProvider<HeroMetrics>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  final selectedApp = ref.watch(appContextProvider);
  return repository.getHeroMetrics(appId: selectedApp?.id);
});

/// Selected period for movers
final moversPeriodProvider = StateProvider<String>((ref) => '7d');

/// Ranking movers provider (family version for custom periods)
final rankingMoversProvider =
    FutureProvider.family<RankingMoversData, String>((ref, period) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  final selectedApp = ref.watch(appContextProvider);
  return repository.getRankingMovers(period: period, appId: selectedApp?.id);
});

/// Combined movers provider that uses the selected period and app context.
final currentMoversProvider = FutureProvider<RankingMoversData>((ref) async {
  final period = ref.watch(moversPeriodProvider);
  final repository = ref.watch(dashboardRepositoryProvider);
  final selectedApp = ref.watch(appContextProvider);
  return repository.getRankingMovers(period: period, appId: selectedApp?.id);
});
