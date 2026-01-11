import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
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

  /// Get AI-generated reply suggestion for a review
  Future<String> suggestReply({
    required int appId,
    required int reviewId,
  }) async {
    try {
      final response = await dio.post(
        '${ApiConstants.apps}/$appId/reviews/$reviewId/suggest-reply',
      );

      return response.data['data']['suggestion'] as String;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
