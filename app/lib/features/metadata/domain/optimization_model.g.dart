// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'optimization_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OptimizationResponseImpl _$$OptimizationResponseImplFromJson(
  Map<String, dynamic> json,
) => _$OptimizationResponseImpl(
  field: json['field'] as String,
  locale: json['locale'] as String,
  currentValue: json['current_value'] as String,
  characterLimit: (json['character_limit'] as num).toInt(),
  suggestions: (json['suggestions'] as List<dynamic>)
      .map((e) => OptimizationSuggestion.fromJson(e as Map<String, dynamic>))
      .toList(),
  context: OptimizationContext.fromJson(
    json['context'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$OptimizationResponseImplToJson(
  _$OptimizationResponseImpl instance,
) => <String, dynamic>{
  'field': instance.field,
  'locale': instance.locale,
  'current_value': instance.currentValue,
  'character_limit': instance.characterLimit,
  'suggestions': instance.suggestions,
  'context': instance.context,
};

_$OptimizationSuggestionImpl _$$OptimizationSuggestionImplFromJson(
  Map<String, dynamic> json,
) => _$OptimizationSuggestionImpl(
  option: json['option'] as String,
  value: json['value'] as String,
  characterCount: (json['character_count'] as num).toInt(),
  characterLimit: (json['character_limit'] as num).toInt(),
  reasoning: json['reasoning'] as String,
  keywordsAdded:
      (json['keywords_added'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  keywordsRemoved:
      (json['keywords_removed'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  estimatedImpact: (json['estimated_impact'] as num?)?.toInt() ?? 0,
  isRecommended: json['is_recommended'] as bool? ?? false,
);

Map<String, dynamic> _$$OptimizationSuggestionImplToJson(
  _$OptimizationSuggestionImpl instance,
) => <String, dynamic>{
  'option': instance.option,
  'value': instance.value,
  'character_count': instance.characterCount,
  'character_limit': instance.characterLimit,
  'reasoning': instance.reasoning,
  'keywords_added': instance.keywordsAdded,
  'keywords_removed': instance.keywordsRemoved,
  'estimated_impact': instance.estimatedImpact,
  'is_recommended': instance.isRecommended,
};

_$OptimizationContextImpl _$$OptimizationContextImplFromJson(
  Map<String, dynamic> json,
) => _$OptimizationContextImpl(
  trackedKeywordsCount: (json['tracked_keywords_count'] as num?)?.toInt() ?? 0,
  competitorsCount: (json['competitors_count'] as num?)?.toInt() ?? 0,
  topKeywords:
      (json['top_keywords'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$OptimizationContextImplToJson(
  _$OptimizationContextImpl instance,
) => <String, dynamic>{
  'tracked_keywords_count': instance.trackedKeywordsCount,
  'competitors_count': instance.competitorsCount,
  'top_keywords': instance.topKeywords,
};
