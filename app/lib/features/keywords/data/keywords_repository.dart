import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/keyword_model.dart';

final keywordsRepositoryProvider = Provider<KeywordsRepository>((ref) {
  return KeywordsRepository(dio: ref.watch(dioProvider));
});

class KeywordsRepository {
  final Dio dio;

  KeywordsRepository({required this.dio});

  Future<KeywordSearchResponse> searchKeyword({
    required String query,
    String country = 'us',
    String platform = 'ios',
    int limit = 50,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.keywordsSearch,
        queryParameters: {
          'q': query,
          'country': country,
          'platform': platform,
          'limit': limit,
        },
      );
      return KeywordSearchResponse.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<Keyword>> getKeywordsForApp(int appId) async {
    try {
      final response = await dio.get('${ApiConstants.apps}/$appId/keywords');
      final data = response.data['data'] as List;
      return data.map((e) => Keyword.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Keyword> addKeywordToApp(int appId, String keyword, {String storefront = 'US'}) async {
    try {
      final response = await dio.post(
        '${ApiConstants.apps}/$appId/keywords',
        data: {
          'keyword': keyword,
          'storefront': storefront,
        },
      );
      return Keyword.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> removeKeywordFromApp(int appId, int keywordId) async {
    try {
      await dio.delete('${ApiConstants.apps}/$appId/keywords/$keywordId');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<RankingHistoryPoint>> getRankingHistory(
    int appId, {
    required int keywordId,
    int days = 30,
  }) async {
    try {
      final response = await dio.get(
        '${ApiConstants.apps}/$appId/rankings/history',
        queryParameters: {
          'keyword_id': keywordId,
          'days': days,
        },
      );
      final data = response.data['data'] as List;
      return data.map((e) => RankingHistoryPoint.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<KeywordSuggestionsResponse> getKeywordSuggestions(
    int appId, {
    String country = 'US',
    int limit = 30,
  }) async {
    try {
      final response = await dio.get(
        '${ApiConstants.apps}/$appId/keywords/suggestions',
        queryParameters: {
          'country': country.toUpperCase(),
          'limit': limit,
        },
        options: Options(
          receiveTimeout: const Duration(minutes: 3),
        ),
      );
      return KeywordSuggestionsResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Map<String, dynamic>> toggleFavorite(int appId, int keywordId) async {
    try {
      final response = await dio.patch(
        '${ApiConstants.apps}/$appId/keywords/$keywordId/favorite',
      );
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> saveNote(int trackedKeywordId, String content) async {
    try {
      await dio.post(
        '${ApiConstants.baseUrl}/notes',
        data: {
          'tracked_keyword_id': trackedKeywordId,
          'content': content,
        },
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> deleteNote(int noteId) async {
    try {
      await dio.delete('${ApiConstants.baseUrl}/notes/$noteId');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Bulk delete tracked keywords
  Future<int> bulkDelete(int appId, List<int> trackedKeywordIds) async {
    try {
      final response = await dio.post(
        '${ApiConstants.apps}/$appId/keywords/bulk-delete',
        data: {'tracked_keyword_ids': trackedKeywordIds},
      );
      return response.data['data']['deleted_count'] as int;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Bulk add tags to tracked keywords
  Future<int> bulkAddTags(int appId, List<int> trackedKeywordIds, List<int> tagIds) async {
    try {
      final response = await dio.post(
        '${ApiConstants.apps}/$appId/keywords/bulk-add-tags',
        data: {
          'tracked_keyword_ids': trackedKeywordIds,
          'tag_ids': tagIds,
        },
      );
      return response.data['data']['updated_count'] as int;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Bulk set favorite status for tracked keywords
  Future<int> bulkFavorite(int appId, List<int> trackedKeywordIds, bool isFavorite) async {
    try {
      final response = await dio.post(
        '${ApiConstants.apps}/$appId/keywords/bulk-favorite',
        data: {
          'tracked_keyword_ids': trackedKeywordIds,
          'is_favorite': isFavorite,
        },
      );
      return response.data['data']['updated_count'] as int;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Export rankings as CSV
  Future<String> exportRankingsCsv(int appId) async {
    try {
      final response = await dio.get(
        '${ApiConstants.apps}/$appId/export/rankings',
        options: Options(responseType: ResponseType.plain),
      );
      return response.data as String;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Import keywords from text (one per line)
  Future<ImportResult> importKeywords(int appId, String keywords, {String storefront = 'US'}) async {
    try {
      final response = await dio.post(
        '${ApiConstants.apps}/$appId/keywords/import',
        data: {
          'keywords': keywords,
          'storefront': storefront,
        },
      );
      return ImportResult.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

class ImportResult {
  final int imported;
  final int skipped;
  final int errors;
  final int total;

  ImportResult({
    required this.imported,
    required this.skipped,
    required this.errors,
    required this.total,
  });

  factory ImportResult.fromJson(Map<String, dynamic> json) {
    return ImportResult(
      imported: json['imported'] as int,
      skipped: json['skipped'] as int,
      errors: json['errors'] as int,
      total: json['total'] as int,
    );
  }
}

class RankingHistoryPoint {
  final int? position;
  final DateTime recordedAt;

  RankingHistoryPoint({
    required this.position,
    required this.recordedAt,
  });

  factory RankingHistoryPoint.fromJson(Map<String, dynamic> json) {
    return RankingHistoryPoint(
      position: json['position'] as int?,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
    );
  }
}
