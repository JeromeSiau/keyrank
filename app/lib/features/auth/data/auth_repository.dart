import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dio: ref.watch(dioProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

class AuthRepository {
  final Dio dio;
  final FlutterSecureStorage storage;

  AuthRepository({required this.dio, required this.storage});

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);
      await storage.write(key: 'auth_token', value: authResponse.token);
      return authResponse;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);
      await storage.write(key: 'auth_token', value: authResponse.token);
      return authResponse;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> logout() async {
    try {
      await dio.post(ApiConstants.logout);
    } catch (_) {
      // Ignore errors on logout
    } finally {
      await storage.delete(key: 'auth_token');
    }
  }

  Future<User?> getCurrentUser() async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) return null;

    try {
      final response = await dio.get(ApiConstants.me);
      return User.fromJson(response.data['user']);
    } on DioException {
      return null;
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await storage.read(key: 'auth_token');
    return token != null;
  }
}
