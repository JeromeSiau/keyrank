import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/reviews_repository.dart';
import '../domain/review_model.dart';

/// Provider for fetching reviews for a specific country
final countryReviewsProvider = FutureProvider.family<ReviewsResponse, ({int appId, String country})>((ref, params) async {
  final repository = ref.watch(reviewsRepositoryProvider);
  return repository.getReviewsForCountry(params.appId, params.country);
});

/// Provider for fetching reviews summary across all countries
final reviewsSummaryProvider = FutureProvider.family<List<CountryReviewSummary>, int>((ref, appId) async {
  final repository = ref.watch(reviewsRepositoryProvider);
  return repository.getReviewsSummary(appId);
});
