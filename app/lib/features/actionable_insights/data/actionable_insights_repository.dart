import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../domain/actionable_insight_model.dart';

final actionableInsightsRepositoryProvider =
    Provider<ActionableInsightsRepository>((ref) {
  return ActionableInsightsRepository(ref.watch(dioProvider));
});

class ActionableInsightsRepository {
  final Dio dio;

  ActionableInsightsRepository(this.dio);

  /// Get paginated list of insights
  Future<List<ActionableInsight>> getInsights({
    int? appId,
    String? type,
    bool? unreadOnly,
    String? priority,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };
      if (appId != null) queryParams['app_id'] = appId;
      if (type != null) queryParams['type'] = type;
      if (unreadOnly == true) queryParams['unread'] = true;
      if (priority != null) queryParams['priority'] = priority;

      final response = await dio.get(
        '/actionable-insights',
        queryParameters: queryParams,
      );

      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => ActionableInsight.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get summary for dashboard
  Future<InsightsSummary> getSummary() async {
    try {
      final response = await dio.get('/actionable-insights/summary');
      return InsightsSummary.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get unread count
  Future<InsightsUnreadCount> getUnreadCount({int? appId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (appId != null) queryParams['app_id'] = appId;

      final response = await dio.get(
        '/actionable-insights/unread-count',
        queryParameters: queryParams,
      );
      return InsightsUnreadCount.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Mark an insight as read
  Future<ActionableInsight> markAsRead(int insightId) async {
    try {
      final response =
          await dio.post('/actionable-insights/$insightId/read');
      return ActionableInsight.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Dismiss an insight
  Future<void> dismiss(int insightId) async {
    try {
      await dio.post('/actionable-insights/$insightId/dismiss');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Mark all insights as read
  Future<int> markAllAsRead({int? appId}) async {
    try {
      final data = <String, dynamic>{};
      if (appId != null) data['app_id'] = appId;

      final response = await dio.post(
        '/actionable-insights/mark-all-read',
        data: data,
      );
      return response.data['data']['marked_count'] as int;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
