import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/ratings_repository.dart';
import '../domain/rating_model.dart';

/// Provider for fetching app ratings
final appRatingsProvider = FutureProvider.family<AppRatingsResponse, int>((ref, appId) async {
  final repository = ref.watch(ratingsRepositoryProvider);
  return repository.getRatingsForApp(appId);
});

/// Provider for fetching rating history for a specific country
final ratingHistoryProvider = FutureProvider.family<List<CountryRating>, ({int appId, String country, int days})>((ref, params) async {
  final repository = ref.watch(ratingsRepositoryProvider);
  return repository.getRatingHistory(
    params.appId,
    country: params.country,
    days: params.days,
  );
});
