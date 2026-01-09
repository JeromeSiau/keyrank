import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/insight_model.dart';

final insightsRepositoryProvider = Provider<InsightsRepository>((ref) {
  return InsightsRepository(ref.watch(dioProvider));
});

class InsightsRepository {
  final Dio dio;

  InsightsRepository(this.dio);

  /// Get the latest insight for an app
  Future<AppInsight?> getInsight(int appId) async {
    try {
      final response = await dio.get('${ApiConstants.apps}/$appId/insights');
      return AppInsight.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw ApiException.fromDioError(e);
    }
  }

  /// Generate new insights for an app
  Future<AppInsight> generateInsights({
    required int appId,
    required List<String> countries,
    int periodMonths = 6,
    bool force = false,
  }) async {
    try {
      final response = await dio.post(
        '${ApiConstants.apps}/$appId/insights/generate',
        data: {
          'countries': countries,
          'period_months': periodMonths,
          'force': force,
        },
      );
      return AppInsight.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Compare multiple apps
  Future<List<InsightComparison>> compareApps(List<int> appIds) async {
    try {
      final response = await dio.get(
        ApiConstants.insightsCompare,
        queryParameters: {'app_ids': appIds},
      );
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => InsightComparison.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
