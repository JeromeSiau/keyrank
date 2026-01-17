import 'package:freezed_annotation/freezed_annotation.dart';

part 'optimization_model.freezed.dart';
part 'optimization_model.g.dart';

/// Response from the optimization API
@freezed
class OptimizationResponse with _$OptimizationResponse {
  const factory OptimizationResponse({
    required String field,
    required String locale,
    @JsonKey(name: 'current_value') required String currentValue,
    @JsonKey(name: 'character_limit') required int characterLimit,
    required List<OptimizationSuggestion> suggestions,
    required OptimizationContext context,
  }) = _OptimizationResponse;

  factory OptimizationResponse.fromJson(Map<String, dynamic> json) =>
      _$OptimizationResponseFromJson(json);
}

/// A single optimization suggestion
@freezed
class OptimizationSuggestion with _$OptimizationSuggestion {
  const factory OptimizationSuggestion({
    required String option,
    required String value,
    @JsonKey(name: 'character_count') required int characterCount,
    @JsonKey(name: 'character_limit') required int characterLimit,
    required String reasoning,
    @JsonKey(name: 'keywords_added') @Default([]) List<String> keywordsAdded,
    @JsonKey(name: 'keywords_removed') @Default([]) List<String> keywordsRemoved,
    @JsonKey(name: 'estimated_impact') @Default(0) int estimatedImpact,
    @JsonKey(name: 'is_recommended') @Default(false) bool isRecommended,
  }) = _OptimizationSuggestion;

  factory OptimizationSuggestion.fromJson(Map<String, dynamic> json) =>
      _$OptimizationSuggestionFromJson(json);
}

/// Context information about the optimization
@freezed
class OptimizationContext with _$OptimizationContext {
  const factory OptimizationContext({
    @JsonKey(name: 'tracked_keywords_count') @Default(0) int trackedKeywordsCount,
    @JsonKey(name: 'competitors_count') @Default(0) int competitorsCount,
    @JsonKey(name: 'top_keywords') @Default([]) List<String> topKeywords,
  }) = _OptimizationContext;

  factory OptimizationContext.fromJson(Map<String, dynamic> json) =>
      _$OptimizationContextFromJson(json);
}

/// Wizard step definition
enum WizardStep {
  title,
  subtitle,
  keywords,
  description,
  review;

  String get displayName {
    switch (this) {
      case WizardStep.title:
        return 'Title';
      case WizardStep.subtitle:
        return 'Subtitle';
      case WizardStep.keywords:
        return 'Keywords';
      case WizardStep.description:
        return 'Description';
      case WizardStep.review:
        return 'Review';
    }
  }

  String get field {
    switch (this) {
      case WizardStep.title:
        return 'title';
      case WizardStep.subtitle:
        return 'subtitle';
      case WizardStep.keywords:
        return 'keywords';
      case WizardStep.description:
        return 'description';
      case WizardStep.review:
        return '';
    }
  }

  bool get isMetadataField => this != WizardStep.review;

  int get stepNumber {
    switch (this) {
      case WizardStep.title:
        return 1;
      case WizardStep.subtitle:
        return 2;
      case WizardStep.keywords:
        return 3;
      case WizardStep.description:
        return 4;
      case WizardStep.review:
        return 5;
    }
  }

  static List<WizardStep> forPlatform(String platform) {
    if (platform == 'android') {
      // Android doesn't have keywords field
      return [
        WizardStep.title,
        WizardStep.subtitle,
        WizardStep.description,
        WizardStep.review,
      ];
    }
    return WizardStep.values;
  }
}

/// State for the optimization wizard
@freezed
class WizardState with _$WizardState {
  const factory WizardState({
    required WizardStep currentStep,
    required String locale,
    required String platform,
    @Default({}) Map<String, String> selectedValues,
    @Default({}) Map<String, OptimizationResponse?> suggestions,
    @Default(false) bool isLoading,
    String? error,
  }) = _WizardState;

  const WizardState._();

  bool get canGoBack => currentStep != WizardStep.title;

  bool get canGoNext {
    if (currentStep == WizardStep.review) return false;
    final steps = WizardStep.forPlatform(platform);
    final currentIndex = steps.indexOf(currentStep);
    return currentIndex < steps.length - 1;
  }

  WizardStep? get nextStep {
    final steps = WizardStep.forPlatform(platform);
    final currentIndex = steps.indexOf(currentStep);
    if (currentIndex < steps.length - 1) {
      return steps[currentIndex + 1];
    }
    return null;
  }

  WizardStep? get previousStep {
    final steps = WizardStep.forPlatform(platform);
    final currentIndex = steps.indexOf(currentStep);
    if (currentIndex > 0) {
      return steps[currentIndex - 1];
    }
    return null;
  }

  double get progress {
    final steps = WizardStep.forPlatform(platform);
    final currentIndex = steps.indexOf(currentStep);
    return (currentIndex + 1) / steps.length;
  }

  int get totalSteps => WizardStep.forPlatform(platform).length;

  int get currentStepNumber {
    final steps = WizardStep.forPlatform(platform);
    return steps.indexOf(currentStep) + 1;
  }
}
