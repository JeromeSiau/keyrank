// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competitor_metadata_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompetitorMetadataHistoryResponseImpl
_$$CompetitorMetadataHistoryResponseImplFromJson(Map<String, dynamic> json) =>
    _$CompetitorMetadataHistoryResponseImpl(
      competitor: CompetitorInfo.fromJson(
        json['competitor'] as Map<String, dynamic>,
      ),
      locale: json['locale'] as String,
      currentMetadata: json['current_metadata'] == null
          ? null
          : MetadataSnapshot.fromJson(
              json['current_metadata'] as Map<String, dynamic>,
            ),
      summary: MetadataHistorySummary.fromJson(
        json['summary'] as Map<String, dynamic>,
      ),
      timeline: (json['timeline'] as List<dynamic>)
          .map((e) => MetadataTimelineEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CompetitorMetadataHistoryResponseImplToJson(
  _$CompetitorMetadataHistoryResponseImpl instance,
) => <String, dynamic>{
  'competitor': instance.competitor,
  'locale': instance.locale,
  'current_metadata': instance.currentMetadata,
  'summary': instance.summary,
  'timeline': instance.timeline,
};

_$CompetitorInfoImpl _$$CompetitorInfoImplFromJson(Map<String, dynamic> json) =>
    _$CompetitorInfoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$$CompetitorInfoImplToJson(
  _$CompetitorInfoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'icon_url': instance.iconUrl,
  'platform': instance.platform,
};

_$MetadataSnapshotImpl _$$MetadataSnapshotImplFromJson(
  Map<String, dynamic> json,
) => _$MetadataSnapshotImpl(
  title: json['title'] as String?,
  subtitle: json['subtitle'] as String?,
  shortDescription: json['short_description'] as String?,
  description: json['description'] as String?,
  keywords: json['keywords'] as String?,
  whatsNew: json['whats_new'] as String?,
  version: json['version'] as String?,
  lastUpdated: json['last_updated'] as String?,
);

Map<String, dynamic> _$$MetadataSnapshotImplToJson(
  _$MetadataSnapshotImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'subtitle': instance.subtitle,
  'short_description': instance.shortDescription,
  'description': instance.description,
  'keywords': instance.keywords,
  'whats_new': instance.whatsNew,
  'version': instance.version,
  'last_updated': instance.lastUpdated,
};

_$MetadataHistorySummaryImpl _$$MetadataHistorySummaryImplFromJson(
  Map<String, dynamic> json,
) => _$MetadataHistorySummaryImpl(
  totalSnapshots: (json['total_snapshots'] as num).toInt(),
  totalChanges: (json['total_changes'] as num).toInt(),
  changesByField: Map<String, int>.from(json['changes_by_field'] as Map),
  periodDays: (json['period_days'] as num).toInt(),
);

Map<String, dynamic> _$$MetadataHistorySummaryImplToJson(
  _$MetadataHistorySummaryImpl instance,
) => <String, dynamic>{
  'total_snapshots': instance.totalSnapshots,
  'total_changes': instance.totalChanges,
  'changes_by_field': instance.changesByField,
  'period_days': instance.periodDays,
};

_$MetadataTimelineEntryImpl _$$MetadataTimelineEntryImplFromJson(
  Map<String, dynamic> json,
) => _$MetadataTimelineEntryImpl(
  id: (json['id'] as num).toInt(),
  date: json['date'] as String,
  version: json['version'] as String?,
  hasChanges: json['has_changes'] as bool,
  changedFields: (json['changed_fields'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  changes: (json['changes'] as List<dynamic>?)
      ?.map((e) => MetadataChange.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$MetadataTimelineEntryImplToJson(
  _$MetadataTimelineEntryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date,
  'version': instance.version,
  'has_changes': instance.hasChanges,
  'changed_fields': instance.changedFields,
  'changes': instance.changes,
};

_$MetadataChangeImpl _$$MetadataChangeImplFromJson(Map<String, dynamic> json) =>
    _$MetadataChangeImpl(
      field: json['field'] as String,
      oldValue: json['old_value'] as String?,
      newValue: json['new_value'] as String?,
      charDiff: (json['char_diff'] as num?)?.toInt(),
      keywordAnalysis: json['keyword_analysis'] == null
          ? null
          : KeywordAnalysis.fromJson(
              json['keyword_analysis'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$$MetadataChangeImplToJson(
  _$MetadataChangeImpl instance,
) => <String, dynamic>{
  'field': instance.field,
  'old_value': instance.oldValue,
  'new_value': instance.newValue,
  'char_diff': instance.charDiff,
  'keyword_analysis': instance.keywordAnalysis,
};

_$KeywordAnalysisImpl _$$KeywordAnalysisImplFromJson(
  Map<String, dynamic> json,
) => _$KeywordAnalysisImpl(
  added: (json['added'] as List<dynamic>).map((e) => e as String).toList(),
  removed: (json['removed'] as List<dynamic>).map((e) => e as String).toList(),
  unchanged: (json['unchanged'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$KeywordAnalysisImplToJson(
  _$KeywordAnalysisImpl instance,
) => <String, dynamic>{
  'added': instance.added,
  'removed': instance.removed,
  'unchanged': instance.unchanged,
};

_$MetadataInsightsResponseImpl _$$MetadataInsightsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$MetadataInsightsResponseImpl(
  competitor: CompetitorBasicInfo.fromJson(
    json['competitor'] as Map<String, dynamic>,
  ),
  insights: json['insights'] == null
      ? null
      : MetadataInsights.fromJson(json['insights'] as Map<String, dynamic>),
  analyzedChanges: (json['analyzed_changes'] as num).toInt(),
  periodDays: (json['period_days'] as num).toInt(),
  generatedAt: json['generated_at'] as String,
  message: json['message'] as String?,
  error: json['error'] as String?,
);

Map<String, dynamic> _$$MetadataInsightsResponseImplToJson(
  _$MetadataInsightsResponseImpl instance,
) => <String, dynamic>{
  'competitor': instance.competitor,
  'insights': instance.insights,
  'analyzed_changes': instance.analyzedChanges,
  'period_days': instance.periodDays,
  'generated_at': instance.generatedAt,
  'message': instance.message,
  'error': instance.error,
};

_$CompetitorBasicInfoImpl _$$CompetitorBasicInfoImplFromJson(
  Map<String, dynamic> json,
) => _$CompetitorBasicInfoImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
);

Map<String, dynamic> _$$CompetitorBasicInfoImplToJson(
  _$CompetitorBasicInfoImpl instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

_$MetadataInsightsImpl _$$MetadataInsightsImplFromJson(
  Map<String, dynamic> json,
) => _$MetadataInsightsImpl(
  strategySummary: json['strategy_summary'] as String,
  keyFindings: (json['key_findings'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  keywordFocus: (json['keyword_focus'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  recommendations: (json['recommendations'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  trend: json['trend'] as String,
);

Map<String, dynamic> _$$MetadataInsightsImplToJson(
  _$MetadataInsightsImpl instance,
) => <String, dynamic>{
  'strategy_summary': instance.strategySummary,
  'key_findings': instance.keyFindings,
  'keyword_focus': instance.keywordFocus,
  'recommendations': instance.recommendations,
  'trend': instance.trend,
};
