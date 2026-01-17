import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/review_intelligence_model.dart';
import '../domain/review_model.dart';

final reviewsRepositoryProvider = Provider<ReviewsRepository>((ref) {
  return ReviewsRepository(ref.watch(dioProvider));
});

class ReviewsRepository {
  final Dio dio;

  ReviewsRepository(this.dio);

  /// Get reviews for a country (auto-fetches from iTunes if stale)
  Future<ReviewsResponse> getReviewsForCountry(int appId, String country) async {
    try {
      final response =
          await dio.get('${ApiConstants.apps}/$appId/reviews/$country');
      return ReviewsResponse.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<CountryReviewSummary>> getReviewsSummary(int appId) async {
    try {
      final response =
          await dio.get('${ApiConstants.apps}/$appId/reviews/summary');
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      final countries = data['countries'] as List<dynamic>? ?? [];
      return countries
          .map((e) => CountryReviewSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get reviews inbox for all user's apps with filters
  Future<PaginatedReviews> getInbox({
    String? status,
    int? rating,
    String? sentiment,
    int? appId,
    String? country,
    String? search,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };

      if (status != null) queryParams['status'] = status;
      if (rating != null) queryParams['rating'] = rating;
      if (sentiment != null) queryParams['sentiment'] = sentiment;
      if (appId != null) queryParams['app_id'] = appId;
      if (country != null) queryParams['country'] = country;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await dio.get(
        '/reviews/inbox',
        queryParameters: queryParams,
      );

      return PaginatedReviews.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Reply to a review
  Future<Review> replyToReview({
    required int appId,
    required int reviewId,
    required String response,
  }) async {
    try {
      final result = await dio.post(
        '${ApiConstants.apps}/$appId/reviews/$reviewId/reply',
        data: {'response': response},
      );

      return Review.fromJson(result.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get AI-generated reply suggestions for a review
  /// If [tone] is provided, generates only that tone. Otherwise generates all 3 tones.
  Future<AiReplyResponse> suggestReply({
    required int appId,
    required int reviewId,
    ReplyTone? tone,
  }) async {
    try {
      final response = await dio.post(
        '${ApiConstants.apps}/$appId/reviews/$reviewId/suggest-reply',
        data: tone != null ? {'tone': tone.name} : null,
      );

      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw ApiException(message: 'Invalid response from server');
      }
      return AiReplyResponse.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // ============================================
  // Review Intelligence Methods
  // ============================================

  /// Get review intelligence dashboard data
  Future<ReviewIntelligence> getReviewIntelligence(int appId) async {
    try {
      final response =
          await dio.get('${ApiConstants.apps}/$appId/review-intelligence');
      final data = response.data['data'] as Map<String, dynamic>;
      return ReviewIntelligence.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get paginated feature requests
  Future<List<InsightItem>> getFeatureRequests(
    int appId, {
    String? status,
    String? priority,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };
      if (status != null) queryParams['status'] = status;
      if (priority != null) queryParams['priority'] = priority;

      final response = await dio.get(
        '${ApiConstants.apps}/$appId/review-intelligence/feature-requests',
        queryParameters: queryParams,
      );

      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => InsightItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get paginated bug reports
  Future<List<InsightItem>> getBugReports(
    int appId, {
    String? status,
    String? priority,
    String? platform,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };
      if (status != null) queryParams['status'] = status;
      if (priority != null) queryParams['priority'] = priority;
      if (platform != null) queryParams['platform'] = platform;

      final response = await dio.get(
        '${ApiConstants.apps}/$appId/review-intelligence/bug-reports',
        queryParameters: queryParams,
      );

      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => InsightItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get reviews linked to a specific insight
  Future<List<Review>> getInsightReviews(int appId, int insightId) async {
    try {
      final response = await dio.get(
        '${ApiConstants.apps}/$appId/review-intelligence/insights/$insightId/reviews',
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final reviews = data['reviews'] as List<dynamic>;
      return reviews
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Update insight status or priority
  Future<InsightItem> updateInsight(
    int appId,
    int insightId, {
    String? status,
    String? priority,
  }) async {
    try {
      final response = await dio.patch(
        '${ApiConstants.apps}/$appId/review-intelligence/insights/$insightId',
        data: {
          if (status != null) 'status': status,
          if (priority != null) 'priority': priority,
        },
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return InsightItem.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
