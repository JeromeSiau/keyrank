import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/analytics_repository.dart';
import '../domain/analytics_summary_model.dart';

/// Selected period for analytics (global state)
final analyticsPeriodProvider = StateProvider<String>((ref) => '30d');

/// Analytics summary for an app
final analyticsSummaryProvider =
    FutureProvider.family<AnalyticsSummary, int>((ref, appId) async {
  final period = ref.watch(analyticsPeriodProvider);
  return ref.watch(analyticsRepositoryProvider).getSummary(appId, period: period);
});

/// Downloads chart data for an app
final analyticsDownloadsProvider =
    FutureProvider.family<DownloadsChartData, int>((ref, appId) async {
  final period = ref.watch(analyticsPeriodProvider);
  return ref.watch(analyticsRepositoryProvider).getDownloads(appId, period: period);
});

/// Revenue chart data for an app
final analyticsRevenueProvider =
    FutureProvider.family<RevenueChartData, int>((ref, appId) async {
  final period = ref.watch(analyticsPeriodProvider);
  return ref.watch(analyticsRepositoryProvider).getRevenue(appId, period: period);
});

/// Subscribers data for an app
final analyticsSubscribersProvider =
    FutureProvider.family<List<SubscribersDataPoint>, int>((ref, appId) async {
  final period = ref.watch(analyticsPeriodProvider);
  return ref.watch(analyticsRepositoryProvider).getSubscribers(appId, period: period);
});

/// Country breakdown for an app
final analyticsCountriesProvider =
    FutureProvider.family<List<CountryAnalytics>, int>((ref, appId) async {
  final period = ref.watch(analyticsPeriodProvider);
  return ref.watch(analyticsRepositoryProvider).getCountries(appId, period: period);
});

/// Available period options
const analyticsPeriodOptions = [
  ('7d', '7 Days'),
  ('30d', '30 Days'),
  ('90d', '90 Days'),
  ('ytd', 'Year to Date'),
  ('all', 'All Time'),
];
