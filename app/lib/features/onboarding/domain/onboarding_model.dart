import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_model.freezed.dart';
part 'onboarding_model.g.dart';

@freezed
class OnboardingStatus with _$OnboardingStatus {
  const OnboardingStatus._();

  const factory OnboardingStatus({
    @JsonKey(name: 'current_step') required String currentStep,
    @JsonKey(name: 'is_completed') required bool isCompleted,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    required List<String> steps,
    required int progress,
  }) = _OnboardingStatus;

  factory OnboardingStatus.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStatusFromJson(json);

  int get currentStepIndex => steps.indexOf(currentStep);
  bool get isFirstStep => currentStepIndex == 0;
  bool get isLastStep => currentStepIndex == steps.length - 1;

  String? get nextStep {
    if (isLastStep) return null;
    return steps[currentStepIndex + 1];
  }

  String? get previousStep {
    if (isFirstStep) return null;
    return steps[currentStepIndex - 1];
  }
}

enum OnboardingStep {
  welcome,
  connect,
  apps,
  setup,
  completed;

  String get label => switch (this) {
        OnboardingStep.welcome => 'Welcome',
        OnboardingStep.connect => 'Connect Store',
        OnboardingStep.apps => 'Your Apps',
        OnboardingStep.setup => 'Setup',
        OnboardingStep.completed => 'Ready!',
      };

  String get description => switch (this) {
        OnboardingStep.welcome => 'Welcome to Keyrank',
        OnboardingStep.connect =>
          'Connect your App Store Connect or Google Play Console',
        OnboardingStep.apps => 'Select the apps you want to track',
        OnboardingStep.setup => 'Configure your preferences',
        OnboardingStep.completed => 'You\'re all set!',
      };
}
