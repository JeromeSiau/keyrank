import 'package:dio/dio.dart';
import '../domain/competitor_model.dart';

class CompetitorsRepository {
  final Dio _dio;

  CompetitorsRepository(this._dio);

  /// Get all competitors (global + contextual for optional app).
  Future<List<CompetitorModel>> getCompetitors({int? appId}) async {
    final queryParams = <String, dynamic>{};
    if (appId != null) {
      queryParams['app_id'] = appId;
    }

    final response = await _dio.get('/competitors', queryParameters: queryParams);
    final data = response.data['competitors'] as List<dynamic>;
    return data.map((json) => CompetitorModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Get competitors for a specific app.
  Future<List<CompetitorModel>> getCompetitorsForApp(int appId) async {
    final response = await _dio.get('/apps/$appId/competitors');
    final data = response.data['competitors'] as List<dynamic>;
    return data.map((json) => CompetitorModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Add a global competitor.
  Future<CompetitorModel> addGlobalCompetitor(int appId) async {
    final response = await _dio.post('/competitors', data: {'app_id': appId});
    return CompetitorModel.fromJson(response.data['competitor'] as Map<String, dynamic>);
  }

  /// Remove a global competitor.
  Future<void> removeGlobalCompetitor(int appId) async {
    await _dio.delete('/competitors/$appId');
  }

  /// Link a competitor to a specific app.
  Future<CompetitorModel> linkCompetitorToApp({
    required int ownerAppId,
    required int competitorAppId,
    String source = 'manual',
  }) async {
    final response = await _dio.post(
      '/apps/$ownerAppId/competitors',
      data: {
        'competitor_app_id': competitorAppId,
        'source': source,
      },
    );
    return CompetitorModel.fromJson(response.data['competitor'] as Map<String, dynamic>);
  }

  /// Unlink a competitor from a specific app.
  Future<void> unlinkCompetitorFromApp({
    required int ownerAppId,
    required int competitorAppId,
  }) async {
    await _dio.delete('/apps/$ownerAppId/competitors/$competitorAppId');
  }
}
