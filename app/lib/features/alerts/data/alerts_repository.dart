import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/alert_preferences_model.dart';
import '../domain/alert_rule_model.dart';

final alertsRepositoryProvider = Provider<AlertsRepository>((ref) {
  return AlertsRepository(dio: ref.watch(dioProvider));
});

class AlertsRepository {
  final Dio dio;

  AlertsRepository({required this.dio});

  Future<List<AlertTemplateModel>> getTemplates() async {
    try {
      final response = await dio.get(ApiConstants.alertTemplates);
      final data = response.data['data'] as List;
      return data.map((e) => AlertTemplateModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<AlertRuleModel>> getRules() async {
    try {
      final response = await dio.get(ApiConstants.alertRules);
      final data = response.data['data'] as List;
      return data.map((e) => AlertRuleModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<AlertRuleModel> createRule({
    required String name,
    required String type,
    required String scopeType,
    int? scopeId,
    required Map<String, dynamic> conditions,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.alertRules,
        data: {
          'name': name,
          'type': type,
          'scope_type': scopeType,
          if (scopeId != null) 'scope_id': scopeId,
          'conditions': conditions,
        },
      );
      return AlertRuleModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<AlertRuleModel> updateRule(int id, {
    String? name,
    Map<String, dynamic>? conditions,
    bool? isActive,
  }) async {
    try {
      final response = await dio.put(
        '${ApiConstants.alertRules}/$id',
        data: {
          if (name != null) 'name': name,
          if (conditions != null) 'conditions': conditions,
          if (isActive != null) 'is_active': isActive,
        },
      );
      return AlertRuleModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> toggleRule(int id) async {
    try {
      await dio.patch('${ApiConstants.alertRules}/$id/toggle');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> deleteRule(int id) async {
    try {
      await dio.delete('${ApiConstants.alertRules}/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // ============================================
  // Alert Preferences (Email/Push/Digest settings)
  // ============================================

  Future<AlertPreferences> getPreferences() async {
    try {
      final response = await dio.get(ApiConstants.alertPreferences);
      return AlertPreferences.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<AlertPreferences> updatePreferences({
    bool? emailNotificationsEnabled,
    Map<String, AlertDelivery>? deliveryByType,
    String? digestTime,
    String? weeklyDigestDay,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (emailNotificationsEnabled != null) {
        data['email_notifications_enabled'] = emailNotificationsEnabled;
      }

      if (deliveryByType != null) {
        data['delivery_by_type'] = deliveryByType.map(
          (key, value) => MapEntry(key, {
            'push': value.push,
            'email': value.email,
            'digest': value.digest,
          }),
        );
      }

      if (digestTime != null) {
        data['digest_time'] = digestTime;
      }

      if (weeklyDigestDay != null) {
        data['weekly_digest_day'] = weeklyDigestDay;
      }

      final response = await dio.put(ApiConstants.alertPreferences, data: data);
      return AlertPreferences.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<AlertTypeInfo>> getAlertTypes() async {
    try {
      final response = await dio.get(ApiConstants.alertTypes);
      final data = response.data['data'] as List;
      return data.map((e) => AlertTypeInfo.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
