import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../domain/integration_model.dart';

final integrationsRepositoryProvider =
    Provider<IntegrationsRepository>((ref) {
  return IntegrationsRepository(ref.watch(dioProvider));
});

class IntegrationsRepository {
  final Dio dio;

  IntegrationsRepository(this.dio);

  Future<List<Integration>> getIntegrations() async {
    try {
      final response = await dio.get('/integrations');
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => Integration.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Integration> getIntegration(int id) async {
    try {
      final response = await dio.get('/integrations/$id');
      return Integration.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> deleteIntegration(int id) async {
    try {
      await dio.delete('/integrations/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<ConnectAppStoreResult> connectAppStore({
    required String keyId,
    required String issuerId,
    required String privateKey,
  }) async {
    try {
      final response = await dio.post('/integrations/app-store-connect', data: {
        'key_id': keyId,
        'issuer_id': issuerId,
        'private_key': privateKey,
      });
      return ConnectAppStoreResult.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<ConnectGooglePlayResult> connectGooglePlay({
    required String serviceAccountJson,
    required List<String> packageNames,
  }) async {
    try {
      final response = await dio.post('/integrations/google-play', data: {
        'service_account_json': serviceAccountJson,
        'package_names': packageNames,
      });
      return ConnectGooglePlayResult.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<({int appsDiscovered, int appsImported})> refreshIntegration(
      int id) async {
    try {
      final response = await dio.post('/integrations/$id/refresh');
      final data = response.data['data'] as Map<String, dynamic>;
      return (
        appsDiscovered: data['apps_discovered'] as int? ?? 0,
        appsImported: data['apps_imported'] as int? ?? 0,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<IntegrationApp>> getIntegrationApps(int id) async {
    try {
      final response = await dio.get('/integrations/$id/apps');
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => IntegrationApp.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
