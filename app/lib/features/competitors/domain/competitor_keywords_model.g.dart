// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competitor_keywords_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompetitorKeywordsResponseImpl _$$CompetitorKeywordsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$CompetitorKeywordsResponseImpl(
  competitor: CompetitorInfo.fromJson(
    json['competitor'] as Map<String, dynamic>,
  ),
  summary: KeywordComparisonSummary.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
  keywords: (json['keywords'] as List<dynamic>)
      .map((e) => KeywordComparison.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$CompetitorKeywordsResponseImplToJson(
  _$CompetitorKeywordsResponseImpl instance,
) => <String, dynamic>{
  'competitor': instance.competitor,
  'summary': instance.summary,
  'keywords': instance.keywords,
};

_$CompetitorInfoImpl _$$CompetitorInfoImplFromJson(Map<String, dynamic> json) =>
    _$CompetitorInfoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
    );

Map<String, dynamic> _$$CompetitorInfoImplToJson(
  _$CompetitorInfoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'icon_url': instance.iconUrl,
};

_$KeywordComparisonSummaryImpl _$$KeywordComparisonSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$KeywordComparisonSummaryImpl(
  totalKeywords: (json['total_keywords'] as num).toInt(),
  youWin: (json['you_win'] as num).toInt(),
  theyWin: (json['they_win'] as num).toInt(),
  tied: (json['tied'] as num).toInt(),
  gaps: (json['gaps'] as num).toInt(),
);

Map<String, dynamic> _$$KeywordComparisonSummaryImplToJson(
  _$KeywordComparisonSummaryImpl instance,
) => <String, dynamic>{
  'total_keywords': instance.totalKeywords,
  'you_win': instance.youWin,
  'they_win': instance.theyWin,
  'tied': instance.tied,
  'gaps': instance.gaps,
};

_$KeywordComparisonImpl _$$KeywordComparisonImplFromJson(
  Map<String, dynamic> json,
) => _$KeywordComparisonImpl(
  keywordId: (json['keyword_id'] as num).toInt(),
  keyword: json['keyword'] as String,
  yourPosition: (json['your_position'] as num?)?.toInt(),
  competitorPosition: (json['competitor_position'] as num?)?.toInt(),
  gap: (json['gap'] as num?)?.toInt(),
  popularity: (json['popularity'] as num?)?.toInt(),
  isTracking: json['is_tracking'] as bool,
);

Map<String, dynamic> _$$KeywordComparisonImplToJson(
  _$KeywordComparisonImpl instance,
) => <String, dynamic>{
  'keyword_id': instance.keywordId,
  'keyword': instance.keyword,
  'your_position': instance.yourPosition,
  'competitor_position': instance.competitorPosition,
  'gap': instance.gap,
  'popularity': instance.popularity,
  'is_tracking': instance.isTracking,
};
