// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
  id: (json['id'] as num).toInt(),
  author: json['author'] as String? ?? 'Anonymous',
  title: json['title'] as String?,
  content: json['content'] as String? ?? '',
  rating: (json['rating'] as num).toInt(),
  version: json['version'] as String?,
  country: json['country'] as String? ?? 'US',
  sentiment: json['sentiment'] as String?,
  ourResponse: json['our_response'] as String?,
  respondedAt: json['responded_at'] == null
      ? null
      : DateTime.parse(json['responded_at'] as String),
  reviewedAt: DateTime.parse(json['reviewed_at'] as String),
  canReply: json['can_reply'] as bool? ?? false,
  app: json['app'] == null
      ? null
      : ReviewApp.fromJson(json['app'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'title': instance.title,
      'content': instance.content,
      'rating': instance.rating,
      'version': instance.version,
      'country': instance.country,
      'sentiment': instance.sentiment,
      'our_response': instance.ourResponse,
      'responded_at': instance.respondedAt?.toIso8601String(),
      'reviewed_at': instance.reviewedAt.toIso8601String(),
      'can_reply': instance.canReply,
      'app': instance.app,
    };

_$ReviewAppImpl _$$ReviewAppImplFromJson(Map<String, dynamic> json) =>
    _$ReviewAppImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      platform: json['platform'] as String,
      isOwned: json['is_owned'] as bool? ?? false,
    );

Map<String, dynamic> _$$ReviewAppImplToJson(_$ReviewAppImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon_url': instance.iconUrl,
      'platform': instance.platform,
      'is_owned': instance.isOwned,
    };

_$ReplySuggestionImpl _$$ReplySuggestionImplFromJson(
  Map<String, dynamic> json,
) => _$ReplySuggestionImpl(
  tone: $enumDecode(_$ReplyToneEnumMap, json['tone']),
  content: json['content'] as String,
);

Map<String, dynamic> _$$ReplySuggestionImplToJson(
  _$ReplySuggestionImpl instance,
) => <String, dynamic>{
  'tone': _$ReplyToneEnumMap[instance.tone]!,
  'content': instance.content,
};

const _$ReplyToneEnumMap = {
  ReplyTone.professional: 'professional',
  ReplyTone.empathetic: 'empathetic',
  ReplyTone.brief: 'brief',
};

_$AiReplyResponseImpl _$$AiReplyResponseImplFromJson(
  Map<String, dynamic> json,
) => _$AiReplyResponseImpl(
  suggestions: (json['suggestions'] as List<dynamic>)
      .map((e) => ReplySuggestion.fromJson(e as Map<String, dynamic>))
      .toList(),
  detectedIssues:
      (json['detected_issues'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  sentiment: json['sentiment'] as String?,
);

Map<String, dynamic> _$$AiReplyResponseImplToJson(
  _$AiReplyResponseImpl instance,
) => <String, dynamic>{
  'suggestions': instance.suggestions,
  'detected_issues': instance.detectedIssues,
  'sentiment': instance.sentiment,
};
