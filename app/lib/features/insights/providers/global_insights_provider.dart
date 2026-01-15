import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../apps/domain/app_model.dart';
import '../../apps/providers/apps_provider.dart';
import '../data/insights_repository.dart';
import '../domain/insight_model.dart';

/// Insight data with associated app for global view
class InsightWithApp {
  final AppInsight insight;
  final AppModel app;

  const InsightWithApp({required this.insight, required this.app});
}

/// Provider that fetches insights for all apps
final globalInsightsProvider = FutureProvider<List<InsightWithApp>>((ref) async {
  final appsState = ref.watch(appsNotifierProvider);
  final apps = appsState.valueOrNull ?? [];
  final repository = ref.read(insightsRepositoryProvider);

  final allInsights = <InsightWithApp>[];

  for (final app in apps) {
    try {
      final insight = await repository.getInsight(app.id);
      if (insight != null) {
        allInsights.add(InsightWithApp(insight: insight, app: app));
      }
    } catch (_) {
      // Skip apps with errors
    }
  }

  // Sort by analyzed date (most recent first)
  allInsights.sort((a, b) => b.insight.analyzedAt.compareTo(a.insight.analyzedAt));

  return allInsights;
});
