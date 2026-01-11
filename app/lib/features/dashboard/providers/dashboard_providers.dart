import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../data/dashboard_repository.dart';
import '../domain/hero_metrics.dart';
import '../domain/ranking_mover.dart';

/// Repository provider
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return DashboardRepository(dio);
});

/// Hero metrics provider
final heroMetricsProvider = FutureProvider<HeroMetrics>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getHeroMetrics();
});

/// Selected period for movers
final moversPeriodProvider = StateProvider<String>((ref) => '7d');

/// Ranking movers provider
final rankingMoversProvider =
    FutureProvider.family<RankingMoversData, String>((ref, period) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getRankingMovers(period: period);
});

/// Combined movers provider that uses the selected period
final currentMoversProvider = FutureProvider<RankingMoversData>((ref) async {
  final period = ref.watch(moversPeriodProvider);
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getRankingMovers(period: period);
});
