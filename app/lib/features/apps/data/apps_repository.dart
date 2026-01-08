import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/app_model.dart';

final appsRepositoryProvider = Provider<AppsRepository>((ref) {
  return AppsRepository(dio: ref.watch(dioProvider));
});

class AppsRepository {
  final Dio dio;

  AppsRepository({required this.dio});

  Future<List<AppModel>> getMyApps() async {
    try {
      final response = await dio.get(ApiConstants.apps);
      final data = response.data['data'] as List;
      return data.map((e) => AppModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<AppSearchResult>> searchApps({
    required String query,
    String country = 'us',
    int limit = 20,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.appsSearch,
        queryParameters: {
          'q': query,
          'country': country,
          'limit': limit,
        },
      );
      final data = response.data['data'] as List;
      return data.map((e) => AppSearchResult.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<AndroidSearchResult>> searchAndroidApps({
    required String query,
    String country = 'us',
    int limit = 30,
  }) async {
    try {
      final response = await dio.get(
        '${ApiConstants.appsSearch}/android',
        queryParameters: {
          'q': query,
          'country': country,
          'limit': limit,
        },
      );
      final data = response.data['data'] as List;
      return data.map((e) => AndroidSearchResult.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<AppModel> addApp({
    String? appleId,
    String? googlePlayId,
    String country = 'us',
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.apps,
        data: {
          if (appleId != null) 'apple_id': appleId,
          if (googlePlayId != null) 'google_play_id': googlePlayId,
          'country': country,
        },
      );
      return AppModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<AppModel> linkAndroid({
    required int appId,
    required String googlePlayId,
    String country = 'us',
  }) async {
    try {
      final response = await dio.post(
        '${ApiConstants.apps}/$appId/link-android',
        data: {
          'google_play_id': googlePlayId,
          'country': country,
        },
      );
      return AppModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<AppModel> getApp(int id) async {
    try {
      final response = await dio.get('${ApiConstants.apps}/$id');
      return AppModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> deleteApp(int id) async {
    try {
      await dio.delete('${ApiConstants.apps}/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> refreshApp(int id) async {
    try {
      await dio.post('${ApiConstants.apps}/$id/refresh');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
