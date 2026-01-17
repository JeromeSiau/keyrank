import 'package:dio/dio.dart';
import 'package:keyrank/core/api/api_client.dart';
import '../domain/hero_metrics.dart';
import '../domain/ranking_mover.dart';

class DashboardRepository {
  final Dio _dio;

  DashboardRepository(this._dio);

  /// Get hero metrics for all apps or a specific app.
  Future<HeroMetrics> getHeroMetrics({int? appId}) async {
    try {
      final response = await _dio.get(
        '/dashboard/metrics',
        queryParameters: appId != null ? {'app_id': appId} : null,
      );
      return HeroMetrics.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get ranking movers for all apps or a specific app.
  Future<RankingMoversData> getRankingMovers({String period = '7d', int? appId}) async {
    try {
      final queryParams = <String, dynamic>{'period': period};
      if (appId != null) {
        queryParams['app_id'] = appId;
      }
      final response = await _dio.get(
        '/dashboard/movers',
        queryParameters: queryParams,
      );
      return RankingMoversData.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
