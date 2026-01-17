import 'package:dio/dio.dart';
import '../domain/competitor_model.dart';
import '../domain/competitor_keywords_model.dart';
import '../domain/competitor_metadata_history_model.dart';

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

  /// Get competitor keywords with comparison to user's app.
  Future<CompetitorKeywordsResponse> getCompetitorKeywords({
    required int competitorId,
    required int appId,
    String country = 'US',
  }) async {
    final response = await _dio.get(
      '/competitors/$competitorId/keywords',
      queryParameters: {
        'app_id': appId,
        'country': country,
      },
    );
    return CompetitorKeywordsResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Add a keyword to track for a competitor.
  Future<void> addKeywordToCompetitor({
    required int competitorId,
    required String keyword,
    String storefront = 'US',
  }) async {
    await _dio.post(
      '/competitors/$competitorId/keywords',
      data: {
        'keyword': keyword,
        'storefront': storefront,
      },
    );
  }

  /// Add multiple keywords to track for a competitor (bulk).
  Future<({int added, int skipped})> addKeywordsToCompetitor({
    required int competitorId,
    required List<String> keywords,
    String storefront = 'US',
  }) async {
    final response = await _dio.post(
      '/competitors/$competitorId/keywords/bulk',
      data: {
        'keywords': keywords,
        'storefront': storefront,
      },
    );
    return (
      added: response.data['added'] as int,
      skipped: response.data['skipped'] as int,
    );
  }

  /// Get metadata history for a competitor.
  Future<CompetitorMetadataHistoryResponse> getMetadataHistory({
    required int competitorId,
    String locale = 'en-US',
    int days = 90,
    bool changesOnly = true,
  }) async {
    final response = await _dio.get(
      '/competitors/$competitorId/metadata-history',
      queryParameters: {
        'locale': locale,
        'days': days,
        'changes_only': changesOnly,
      },
    );
    return CompetitorMetadataHistoryResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// Export metadata history as CSV.
  Future<List<int>> exportMetadataHistory({
    required int competitorId,
    String locale = 'en-US',
    int days = 90,
  }) async {
    final response = await _dio.get<List<int>>(
      '/competitors/$competitorId/metadata-history/export',
      queryParameters: {
        'locale': locale,
        'days': days,
      },
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data ?? [];
  }

  /// Get AI-generated insights from metadata changes.
  Future<MetadataInsightsResponse> getMetadataInsights({
    required int competitorId,
    String locale = 'en-US',
    int days = 90,
  }) async {
    final response = await _dio.get(
      '/competitors/$competitorId/metadata-insights',
      queryParameters: {
        'locale': locale,
        'days': days,
      },
    );
    return MetadataInsightsResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
