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
      final response = await dio.get('${ApiConstants.apps}/$appId/reviews/$country');
      return ReviewsResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<CountryReviewSummary>> getReviewsSummary(int appId) async {
    try {
      final response = await dio.get('${ApiConstants.apps}/$appId/reviews/summary');
      final countries = response.data['countries'] as List<dynamic>? ?? [];
      return countries
          .map((e) => CountryReviewSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
