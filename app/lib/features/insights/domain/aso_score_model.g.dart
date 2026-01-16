// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aso_score_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AsoScoreImpl _$$AsoScoreImplFromJson(Map<String, dynamic> json) =>
    _$AsoScoreImpl(
      score: (json['score'] as num).toInt(),
      breakdown: AsoScoreBreakdown.fromJson(
        json['breakdown'] as Map<String, dynamic>,
      ),
      trend: AsoScoreTrend.fromJson(json['trend'] as Map<String, dynamic>),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map(
            (e) => AsoScoreRecommendation.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$$AsoScoreImplToJson(_$AsoScoreImpl instance) =>
    <String, dynamic>{
      'score': instance.score,
      'breakdown': instance.breakdown,
      'trend': instance.trend,
      'recommendations': instance.recommendations,
    };

_$AsoScoreBreakdownImpl _$$AsoScoreBreakdownImplFromJson(
  Map<String, dynamic> json,
) => _$AsoScoreBreakdownImpl(
  metadata: AsoScoreCategory.fromJson(json['metadata'] as Map<String, dynamic>),
  keywords: AsoScoreCategory.fromJson(json['keywords'] as Map<String, dynamic>),
  reviews: AsoScoreCategory.fromJson(json['reviews'] as Map<String, dynamic>),
  ratings: AsoScoreCategory.fromJson(json['ratings'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$AsoScoreBreakdownImplToJson(
  _$AsoScoreBreakdownImpl instance,
) => <String, dynamic>{
  'metadata': instance.metadata,
  'keywords': instance.keywords,
  'reviews': instance.reviews,
  'ratings': instance.ratings,
};

_$AsoScoreCategoryImpl _$$AsoScoreCategoryImplFromJson(
  Map<String, dynamic> json,
) => _$AsoScoreCategoryImpl(
  score: (json['score'] as num).toInt(),
  max: (json['max'] as num).toInt(),
  percent: (json['percent'] as num).toInt(),
  details: json['details'] as Map<String, dynamic>,
);

Map<String, dynamic> _$$AsoScoreCategoryImplToJson(
  _$AsoScoreCategoryImpl instance,
) => <String, dynamic>{
  'score': instance.score,
  'max': instance.max,
  'percent': instance.percent,
  'details': instance.details,
};

_$AsoScoreTrendImpl _$$AsoScoreTrendImplFromJson(Map<String, dynamic> json) =>
    _$AsoScoreTrendImpl(
      change: (json['change'] as num).toInt(),
      period: json['period'] as String,
      direction: json['direction'] as String,
      indicators:
          (json['indicators'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AsoScoreTrendImplToJson(_$AsoScoreTrendImpl instance) =>
    <String, dynamic>{
      'change': instance.change,
      'period': instance.period,
      'direction': instance.direction,
      'indicators': instance.indicators,
    };

_$AsoScoreRecommendationImpl _$$AsoScoreRecommendationImplFromJson(
  Map<String, dynamic> json,
) => _$AsoScoreRecommendationImpl(
  category: json['category'] as String,
  action: json['action'] as String,
  impact: json['impact'] as String,
  priority: json['priority'] as String,
);

Map<String, dynamic> _$$AsoScoreRecommendationImplToJson(
  _$AsoScoreRecommendationImpl instance,
) => <String, dynamic>{
  'category': instance.category,
  'action': instance.action,
  'impact': instance.impact,
  'priority': instance.priority,
};
