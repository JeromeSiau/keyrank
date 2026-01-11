// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actionable_insight_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActionableInsightImpl _$$ActionableInsightImplFromJson(
  Map<String, dynamic> json,
) => _$ActionableInsightImpl(
  id: (json['id'] as num).toInt(),
  type: $enumDecode(_$InsightTypeEnumMap, json['type']),
  priority: $enumDecode(_$InsightPriorityEnumMap, json['priority']),
  title: json['title'] as String,
  description: json['description'] as String,
  actionText: json['action_text'] as String?,
  actionUrl: json['action_url'] as String?,
  dataRefs: json['data_refs'] as Map<String, dynamic>?,
  isRead: json['is_read'] as bool? ?? false,
  isDismissed: json['is_dismissed'] as bool? ?? false,
  generatedAt: DateTime.parse(json['generated_at'] as String),
  expiresAt: json['expires_at'] == null
      ? null
      : DateTime.parse(json['expires_at'] as String),
  app: json['app'] == null
      ? null
      : InsightApp.fromJson(json['app'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$ActionableInsightImplToJson(
  _$ActionableInsightImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$InsightTypeEnumMap[instance.type]!,
  'priority': _$InsightPriorityEnumMap[instance.priority]!,
  'title': instance.title,
  'description': instance.description,
  'action_text': instance.actionText,
  'action_url': instance.actionUrl,
  'data_refs': instance.dataRefs,
  'is_read': instance.isRead,
  'is_dismissed': instance.isDismissed,
  'generated_at': instance.generatedAt.toIso8601String(),
  'expires_at': instance.expiresAt?.toIso8601String(),
  'app': instance.app,
};

const _$InsightTypeEnumMap = {
  InsightType.opportunity: 'opportunity',
  InsightType.warning: 'warning',
  InsightType.win: 'win',
  InsightType.competitorMove: 'competitor_move',
  InsightType.theme: 'theme',
  InsightType.suggestion: 'suggestion',
};

const _$InsightPriorityEnumMap = {
  InsightPriority.high: 'high',
  InsightPriority.medium: 'medium',
  InsightPriority.low: 'low',
};

_$InsightAppImpl _$$InsightAppImplFromJson(Map<String, dynamic> json) =>
    _$InsightAppImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$$InsightAppImplToJson(_$InsightAppImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon_url': instance.iconUrl,
      'platform': instance.platform,
    };

_$InsightsSummaryImpl _$$InsightsSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$InsightsSummaryImpl(
  insights: (json['insights'] as List<dynamic>)
      .map((e) => ActionableInsight.fromJson(e as Map<String, dynamic>))
      .toList(),
  unreadCount: (json['unread_count'] as num).toInt(),
  byType: Map<String, int>.from(json['by_type'] as Map),
);

Map<String, dynamic> _$$InsightsSummaryImplToJson(
  _$InsightsSummaryImpl instance,
) => <String, dynamic>{
  'insights': instance.insights,
  'unread_count': instance.unreadCount,
  'by_type': instance.byType,
};

_$InsightsUnreadCountImpl _$$InsightsUnreadCountImplFromJson(
  Map<String, dynamic> json,
) => _$InsightsUnreadCountImpl(
  total: (json['total'] as num).toInt(),
  highPriority: (json['high_priority'] as num).toInt(),
);

Map<String, dynamic> _$$InsightsUnreadCountImplToJson(
  _$InsightsUnreadCountImpl instance,
) => <String, dynamic>{
  'total': instance.total,
  'high_priority': instance.highPriority,
};
