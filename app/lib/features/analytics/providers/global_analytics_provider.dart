import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../apps/domain/app_model.dart';
import '../../apps/providers/apps_provider.dart';
import '../data/analytics_repository.dart';
import '../domain/analytics_summary_model.dart';
import 'analytics_provider.dart';

/// Analytics summary with associated app for global view
class AnalyticsWithApp {
  final AnalyticsSummary summary;
  final AppModel app;

  const AnalyticsWithApp({required this.summary, required this.app});
}

/// Provider that fetches analytics summaries for all apps
final globalAnalyticsProvider = FutureProvider<List<AnalyticsWithApp>>((ref) async {
  final appsState = ref.watch(appsNotifierProvider);
  final apps = appsState.valueOrNull ?? [];
  final repository = ref.read(analyticsRepositoryProvider);
  final period = ref.watch(analyticsPeriodProvider);

  final allAnalytics = <AnalyticsWithApp>[];

  for (final app in apps) {
    try {
      final summary = await repository.getSummary(app.id, period: period);
      if (summary.hasData) {
        allAnalytics.add(AnalyticsWithApp(summary: summary, app: app));
      }
    } catch (_) {
      // Skip apps with errors
    }
  }

  // Sort by total revenue (highest first)
  allAnalytics.sort((a, b) => b.summary.totalRevenue.compareTo(a.summary.totalRevenue));

  return allAnalytics;
});

/// Aggregated totals across all apps
class GlobalAnalyticsTotals {
  final int totalDownloads;
  final double totalRevenue;
  final double totalProceeds;
  final int totalSubscribers;

  const GlobalAnalyticsTotals({
    required this.totalDownloads,
    required this.totalRevenue,
    required this.totalProceeds,
    required this.totalSubscribers,
  });
}

/// Provider for aggregated totals
final globalAnalyticsTotalsProvider = Provider<GlobalAnalyticsTotals>((ref) {
  final analyticsAsync = ref.watch(globalAnalyticsProvider);
  final analytics = analyticsAsync.valueOrNull ?? [];

  int totalDownloads = 0;
  double totalRevenue = 0;
  double totalProceeds = 0;
  int totalSubscribers = 0;

  for (final item in analytics) {
    totalDownloads += item.summary.totalDownloads;
    totalRevenue += item.summary.totalRevenue;
    totalProceeds += item.summary.totalProceeds;
    totalSubscribers += item.summary.activeSubscribers;
  }

  return GlobalAnalyticsTotals(
    totalDownloads: totalDownloads,
    totalRevenue: totalRevenue,
    totalProceeds: totalProceeds,
    totalSubscribers: totalSubscribers,
  );
});
