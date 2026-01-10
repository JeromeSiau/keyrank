import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/notification_model.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepository(dio: ref.watch(dioProvider));
});

class NotificationsRepository {
  final Dio dio;

  NotificationsRepository({required this.dio});

  Future<NotificationsPage> getNotifications({int page = 1}) async {
    try {
      final response = await dio.get(
        ApiConstants.notifications,
        queryParameters: {'page': page},
      );
      return NotificationsPage.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await dio.get(ApiConstants.notificationsUnreadCount);
      return response.data['count'] as int;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await dio.patch('${ApiConstants.notifications}/$id/read');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await dio.post(ApiConstants.notificationsMarkAllRead);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> delete(int id) async {
    try {
      await dio.delete('${ApiConstants.notifications}/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
