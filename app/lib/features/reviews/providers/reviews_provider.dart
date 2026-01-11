import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/reviews_repository.dart';
import '../domain/review_model.dart';

/// Provider for fetching reviews for a specific country
final countryReviewsProvider = FutureProvider.family<ReviewsResponse, ({int appId, String country})>((ref, params) async {
  final repository = ref.watch(reviewsRepositoryProvider);
  return repository.getReviewsForCountry(params.appId, params.country);
});

/// Provider for fetching reviews summary across all countries
final reviewsSummaryProvider =
    FutureProvider.family<List<CountryReviewSummary>, int>((ref, appId) async {
  final repository = ref.watch(reviewsRepositoryProvider);
  return repository.getReviewsSummary(appId);
});

/// Provider for fetching the reviews inbox with filters
final reviewsInboxProvider =
    FutureProvider.family<PaginatedReviews, ReviewsInboxParams>(
        (ref, params) async {
  final repository = ref.watch(reviewsRepositoryProvider);
  return repository.getInbox(
    status: params.status,
    rating: params.rating,
    sentiment: params.sentiment,
    appId: params.appId,
    country: params.country,
    search: params.search,
    page: params.page,
  );
});

class ReviewsInboxParams {
  final String? status;
  final int? rating;
  final String? sentiment;
  final int? appId;
  final String? country;
  final String? search;
  final int page;

  ReviewsInboxParams({
    this.status,
    this.rating,
    this.sentiment,
    this.appId,
    this.country,
    this.search,
    this.page = 1,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReviewsInboxParams &&
        other.status == status &&
        other.rating == rating &&
        other.sentiment == sentiment &&
        other.appId == appId &&
        other.country == country &&
        other.search == search &&
        other.page == page;
  }

  @override
  int get hashCode =>
      Object.hash(status, rating, sentiment, appId, country, search, page);
}
