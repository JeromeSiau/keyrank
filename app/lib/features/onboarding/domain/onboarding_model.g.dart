// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnboardingStatusImpl _$$OnboardingStatusImplFromJson(
  Map<String, dynamic> json,
) => _$OnboardingStatusImpl(
  currentStep: json['current_step'] as String,
  isCompleted: json['is_completed'] as bool,
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  steps: (json['steps'] as List<dynamic>).map((e) => e as String).toList(),
  progress: (json['progress'] as num).toInt(),
);

Map<String, dynamic> _$$OnboardingStatusImplToJson(
  _$OnboardingStatusImpl instance,
) => <String, dynamic>{
  'current_step': instance.currentStep,
  'is_completed': instance.isCompleted,
  'completed_at': instance.completedAt?.toIso8601String(),
  'steps': instance.steps,
  'progress': instance.progress,
};
