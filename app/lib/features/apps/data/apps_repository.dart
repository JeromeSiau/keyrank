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
    required String platform,
    required String storeId,
    String country = 'us',
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.apps,
        data: {
          'platform': platform,
          'store_id': storeId,
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

  Future<void> toggleFavorite(int appId, bool isFavorite) async {
    try {
      await dio.patch(
        '${ApiConstants.apps}/$appId/favorite',
        data: {'is_favorite': isFavorite},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<AppPreview> getAppPreview({
    required String platform,
    required String storeId,
    String country = 'us',
  }) async {
    try {
      final response = await dio.get(
        '${ApiConstants.appsPreview}/$platform/$storeId',
        queryParameters: {'country': country},
      );
      return AppPreview.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<DeveloperAppsResult> getDeveloperApps(int appId) async {
    try {
      final response = await dio.get('${ApiConstants.apps}/$appId/developer-apps');
      final data = response.data['data'] as List;
      final apps = data.map((e) => DeveloperApp.fromJson(e as Map<String, dynamic>)).toList();
      return DeveloperAppsResult(
        developer: response.data['developer'] as String?,
        apps: apps,
        total: response.data['total'] as int? ?? apps.length,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

/// Result of fetching apps from the same developer
class DeveloperAppsResult {
  final String? developer;
  final List<DeveloperApp> apps;
  final int total;

  DeveloperAppsResult({
    required this.developer,
    required this.apps,
    required this.total,
  });
}

/// Simplified app model for developer apps list
class DeveloperApp {
  final int id;
  final String platform;
  final String storeId;
  final String name;
  final String? iconUrl;
  final double? rating;
  final int ratingCount;
  final String? categoryId;
  final bool isTracked;

  DeveloperApp({
    required this.id,
    required this.platform,
    required this.storeId,
    required this.name,
    this.iconUrl,
    this.rating,
    required this.ratingCount,
    this.categoryId,
    required this.isTracked,
  });

  factory DeveloperApp.fromJson(Map<String, dynamic> json) {
    return DeveloperApp(
      id: json['id'] as int,
      platform: json['platform'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      rating: _parseDouble(json['rating']),
      ratingCount: _parseInt(json['rating_count']) ?? 0,
      categoryId: json['category_id'] as String?,
      isTracked: json['is_tracked'] as bool? ?? false,
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  bool get isIos => platform == 'ios';
  bool get isAndroid => platform == 'android';
}
