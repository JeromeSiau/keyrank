import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../domain/analytics_summary_model.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository(ref.watch(dioProvider));
});

class AnalyticsRepository {
  final Dio dio;

  AnalyticsRepository(this.dio);

  Future<AnalyticsSummary> getSummary(int appId, {String period = '30d'}) async {
    try {
      final response = await dio.get(
        '/apps/$appId/analytics',
        queryParameters: {'period': period},
      );
      return AnalyticsSummary.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<DownloadsChartData> getDownloads(int appId,
      {String period = '30d'}) async {
    try {
      final response = await dio.get(
        '/apps/$appId/analytics/downloads',
        queryParameters: {'period': period},
      );
      return DownloadsChartData.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<RevenueChartData> getRevenue(int appId,
      {String period = '30d'}) async {
    try {
      final response = await dio.get(
        '/apps/$appId/analytics/revenue',
        queryParameters: {'period': period},
      );
      return RevenueChartData.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<SubscribersDataPoint>> getSubscribers(int appId,
      {String period = '30d'}) async {
    try {
      final response = await dio.get(
        '/apps/$appId/analytics/subscribers',
        queryParameters: {'period': period},
      );
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => SubscribersDataPoint.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<CountryAnalytics>> getCountries(int appId,
      {String period = '30d', int limit = 10}) async {
    try {
      final response = await dio.get(
        '/apps/$appId/analytics/countries',
        queryParameters: {'period': period, 'limit': limit},
      );
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => CountryAnalytics.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<String> exportCsv(int appId, {String period = '30d'}) async {
    try {
      final response = await dio.get(
        '/apps/$appId/analytics/export',
        queryParameters: {'period': period},
      );
      return response.data as String;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
