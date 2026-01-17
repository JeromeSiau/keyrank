import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/onboarding_repository.dart';
import '../domain/onboarding_model.dart';

final onboardingStatusProvider =
    AsyncNotifierProvider<OnboardingNotifier, OnboardingStatus>(
  OnboardingNotifier.new,
);

class OnboardingNotifier extends AsyncNotifier<OnboardingStatus> {
  @override
  Future<OnboardingStatus> build() async {
    // Watch auth state - this will refetch when user logs in/out
    final authState = ref.watch(authStateProvider);

    // If not authenticated, return a default completed status
    // (so we don't try to fetch from API without auth)
    if (authState.valueOrNull == null) {
      return const OnboardingStatus(
        currentStep: 'completed',
        isCompleted: true,
        steps: ['completed'],
        progress: 100,
      );
    }

    return _fetchStatus();
  }

  Future<OnboardingStatus> _fetchStatus() async {
    final repository = ref.read(onboardingRepositoryProvider);
    return repository.getStatus();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchStatus());
  }

  Future<void> goToStep(String step) async {
    final repository = ref.read(onboardingRepositoryProvider);
    final updatedStatus = await repository.updateStep(step);
    state = AsyncData(updatedStatus);
  }

  Future<void> nextStep() async {
    final currentStatus = state.valueOrNull;
    if (currentStatus == null) return;

    final nextStep = currentStatus.nextStep;
    if (nextStep != null) {
      await goToStep(nextStep);
    }
  }

  Future<void> complete() async {
    final repository = ref.read(onboardingRepositoryProvider);
    final completedAt = await repository.complete();

    final currentStatus = state.valueOrNull;
    if (currentStatus != null) {
      state = AsyncData(currentStatus.copyWith(
        currentStep: 'completed',
        isCompleted: true,
        completedAt: completedAt,
        progress: 100,
      ));
    }
  }

  Future<void> skip() async {
    final repository = ref.read(onboardingRepositoryProvider);
    await repository.skip();

    final currentStatus = state.valueOrNull;
    if (currentStatus != null) {
      state = AsyncData(currentStatus.copyWith(
        currentStep: 'completed',
        isCompleted: true,
        completedAt: DateTime.now(),
        progress: 100,
      ));
    }
  }
}

final needsOnboardingProvider = Provider<bool>((ref) {
  final status = ref.watch(onboardingStatusProvider);
  return status.maybeWhen(
    data: (s) => !s.isCompleted,
    orElse: () => false,
  );
});

final currentOnboardingStepProvider = Provider<OnboardingStep?>((ref) {
  final status = ref.watch(onboardingStatusProvider);
  return status.maybeWhen(
    data: (s) {
      if (s.isCompleted) return null;
      return OnboardingStep.values.firstWhere(
        (step) => step.name == s.currentStep,
        orElse: () => OnboardingStep.welcome,
      );
    },
    orElse: () => null,
  );
});
