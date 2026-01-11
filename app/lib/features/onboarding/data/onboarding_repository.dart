import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../domain/onboarding_model.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository(ref.watch(dioProvider));
});

class OnboardingRepository {
  final Dio dio;

  OnboardingRepository(this.dio);

  Future<OnboardingStatus> getStatus() async {
    try {
      final response = await dio.get('/onboarding/status');
      return OnboardingStatus.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<OnboardingStatus> updateStep(String step) async {
    try {
      final response = await dio.post('/onboarding/step', data: {
        'step': step,
      });
      final data = response.data['data'] as Map<String, dynamic>;
      return OnboardingStatus(
        currentStep: data['current_step'] as String,
        isCompleted: false,
        completedAt: null,
        steps: const ['welcome', 'connect', 'apps', 'setup', 'completed'],
        progress: data['progress'] as int,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<DateTime> complete() async {
    try {
      final response = await dio.post('/onboarding/complete');
      final data = response.data['data'] as Map<String, dynamic>;
      return DateTime.parse(data['completed_at'] as String);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> skip() async {
    try {
      await dio.post('/onboarding/skip');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
