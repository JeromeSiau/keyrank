import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/rating_model.dart';

final ratingsRepositoryProvider = Provider<RatingsRepository>((ref) {
  return RatingsRepository(ref.watch(dioProvider));
});

class RatingsRepository {
  final Dio dio;

  RatingsRepository(this.dio);

  /// Get ratings for an app (auto-fetches from iTunes if stale)
  Future<AppRatingsResponse> getRatingsForApp(int appId) async {
    try {
      final response = await dio.get('${ApiConstants.apps}/$appId/ratings');
      return AppRatingsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<CountryRating>> getRatingHistory(
    int appId, {
    required String country,
    int days = 30,
  }) async {
    try {
      final response = await dio.get(
        '${ApiConstants.apps}/$appId/ratings/history',
        queryParameters: {
          'country': country,
          'days': days,
        },
      );
      final history = response.data['history'] as List<dynamic>? ?? [];
      return history
          .map((e) => CountryRating.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
