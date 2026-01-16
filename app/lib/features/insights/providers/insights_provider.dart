import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/insights_repository.dart';
import '../domain/aso_score_model.dart';
import '../domain/insight_model.dart';

/// Provider for fetching insight for an app
final appInsightProvider = FutureProvider.family<AppInsight?, int>((ref, appId) async {
  final repository = ref.watch(insightsRepositoryProvider);
  return repository.getInsight(appId);
});

/// Provider for generating insights
final generateInsightProvider = FutureProvider.family<AppInsight, GenerateInsightParams>((ref, params) async {
  final repository = ref.watch(insightsRepositoryProvider);
  return repository.generateInsights(
    appId: params.appId,
    countries: params.countries,
    periodMonths: params.periodMonths,
    force: params.force,
  );
});

class GenerateInsightParams {
  final int appId;
  final List<String> countries;
  final int periodMonths;
  final bool force;

  GenerateInsightParams({
    required this.appId,
    required this.countries,
    this.periodMonths = 6,
    this.force = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenerateInsightParams &&
          appId == other.appId &&
          countries.join(',') == other.countries.join(',') &&
          periodMonths == other.periodMonths &&
          force == other.force;

  @override
  int get hashCode => Object.hash(appId, countries.join(','), periodMonths, force);
}

/// Provider for comparing apps
final compareAppsProvider = FutureProvider.family<List<InsightComparison>, List<int>>((ref, appIds) async {
  final repository = ref.watch(insightsRepositoryProvider);
  return repository.compareApps(appIds);
});

/// Provider for fetching ASO score for an app
final asoScoreProvider = FutureProvider.family<AsoScore, int>((ref, appId) async {
  final repository = ref.watch(insightsRepositoryProvider);
  return repository.getAsoScore(appId);
});
