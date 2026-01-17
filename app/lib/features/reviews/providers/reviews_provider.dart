import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/reviews_repository.dart';
import '../domain/review_intelligence_model.dart';
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

// ============================================
// Review Intelligence Providers
// ============================================

/// Provider for fetching review intelligence dashboard data
final reviewIntelligenceProvider =
    FutureProvider.family<ReviewIntelligence, int>((ref, appId) async {
  final repository = ref.watch(reviewsRepositoryProvider);
  return repository.getReviewIntelligence(appId);
});

/// Provider for fetching feature requests with filters
final featureRequestsProvider =
    FutureProvider.family<List<InsightItem>, InsightFilterParams>(
        (ref, params) async {
  final repository = ref.watch(reviewsRepositoryProvider);
  return repository.getFeatureRequests(
    params.appId,
    status: params.status,
    priority: params.priority,
    page: params.page,
  );
});

/// Provider for fetching bug reports with filters
final bugReportsProvider =
    FutureProvider.family<List<InsightItem>, InsightFilterParams>(
        (ref, params) async {
  final repository = ref.watch(reviewsRepositoryProvider);
  return repository.getBugReports(
    params.appId,
    status: params.status,
    priority: params.priority,
    platform: params.platform,
    page: params.page,
  );
});

/// Provider for fetching reviews linked to an insight
final insightReviewsProvider =
    FutureProvider.family<List<Review>, ({int appId, int insightId})>(
        (ref, params) async {
  final repository = ref.watch(reviewsRepositoryProvider);
  return repository.getInsightReviews(params.appId, params.insightId);
});

/// Parameters for filtering insights
class InsightFilterParams {
  final int appId;
  final String? status;
  final String? priority;
  final String? platform;
  final int page;

  InsightFilterParams({
    required this.appId,
    this.status,
    this.priority,
    this.platform,
    this.page = 1,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InsightFilterParams &&
        other.appId == appId &&
        other.status == status &&
        other.priority == priority &&
        other.platform == platform &&
        other.page == page;
  }

  @override
  int get hashCode => Object.hash(appId, status, priority, platform, page);
}
