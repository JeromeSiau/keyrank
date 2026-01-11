import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../domain/store_connection_model.dart';

final storeConnectionsRepositoryProvider =
    Provider<StoreConnectionsRepository>((ref) {
  return StoreConnectionsRepository(ref.watch(dioProvider));
});

class StoreConnectionsRepository {
  final Dio dio;

  StoreConnectionsRepository(this.dio);

  Future<List<StoreConnection>> getConnections() async {
    try {
      final response = await dio.get('/store-connections');
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => StoreConnection.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<StoreConnection> createConnection({
    required String platform,
    required String name,
    required Map<String, dynamic> credentials,
  }) async {
    try {
      final response = await dio.post('/store-connections', data: {
        'platform': platform,
        'name': name,
        ...credentials,
      });
      return StoreConnection.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> deleteConnection(int id) async {
    try {
      await dio.delete('/store-connections/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<({bool valid, String status})> validateConnection(int id) async {
    try {
      final response = await dio.post('/store-connections/$id/validate');
      return (
        valid: response.data['valid'] as bool,
        status: response.data['status'] as String,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
