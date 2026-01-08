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
      return KeywordSearchResponse.fromJson(response.data);
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
