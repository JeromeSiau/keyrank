import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../domain/billing_models.dart';

final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  return BillingRepository(ref.watch(dioProvider));
});

class BillingRepository {
  final Dio dio;

  BillingRepository(this.dio);

  /// Get subscription status
  Future<SubscriptionStatus> getStatus() async {
    try {
      final response = await dio.get('/billing/status');
      return SubscriptionStatus.fromJson(
        response.data['subscription'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get available plans
  Future<List<SubscriptionPlan>> getPlans() async {
    try {
      final response = await dio.get('/billing/plans');
      final plans = response.data['plans'] as List<dynamic>;
      return plans
          .map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Create checkout session
  Future<CheckoutResponse> checkout({
    required String plan,
    required String billingPeriod,
  }) async {
    try {
      final response = await dio.post(
        '/billing/checkout',
        data: {
          'plan': plan,
          'billing_period': billingPeriod,
        },
      );
      return CheckoutResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get customer portal URL
  Future<PortalResponse> getPortalUrl() async {
    try {
      final response = await dio.get('/billing/portal');
      return PortalResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Cancel subscription
  Future<SubscriptionStatus> cancel() async {
    try {
      final response = await dio.post('/billing/cancel');
      return SubscriptionStatus.fromJson(
        response.data['subscription'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Resume canceled subscription
  Future<SubscriptionStatus> resume() async {
    try {
      final response = await dio.post('/billing/resume');
      return SubscriptionStatus.fromJson(
        response.data['subscription'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
