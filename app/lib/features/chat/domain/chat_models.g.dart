// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatConversationImpl _$$ChatConversationImplFromJson(
  Map<String, dynamic> json,
) => _$ChatConversationImpl(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String?,
  app: json['app'] == null
      ? null
      : ChatApp.fromJson(json['app'] as Map<String, dynamic>),
  messages:
      (json['messages'] as List<dynamic>?)
          ?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$ChatConversationImplToJson(
  _$ChatConversationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'app': instance.app,
  'messages': instance.messages,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: (json['id'] as num).toInt(),
      role: json['role'] as String,
      content: json['content'] as String,
      dataSourcesUsed: (json['data_sources_used'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'content': instance.content,
      'data_sources_used': instance.dataSourcesUsed,
      'created_at': instance.createdAt.toIso8601String(),
    };

_$ChatAppImpl _$$ChatAppImplFromJson(Map<String, dynamic> json) =>
    _$ChatAppImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$$ChatAppImplToJson(_$ChatAppImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon_url': instance.iconUrl,
      'platform': instance.platform,
    };

_$ChatQuotaImpl _$$ChatQuotaImplFromJson(Map<String, dynamic> json) =>
    _$ChatQuotaImpl(
      used: (json['used'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      remaining: (json['remaining'] as num).toInt(),
      hasQuota: json['has_quota'] as bool,
    );

Map<String, dynamic> _$$ChatQuotaImplToJson(_$ChatQuotaImpl instance) =>
    <String, dynamic>{
      'used': instance.used,
      'limit': instance.limit,
      'remaining': instance.remaining,
      'has_quota': instance.hasQuota,
    };

_$QuickAskResponseImpl _$$QuickAskResponseImplFromJson(
  Map<String, dynamic> json,
) => _$QuickAskResponseImpl(
  content: json['content'] as String,
  dataSourcesUsed: (json['data_sources_used'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  tokensUsed: (json['tokens_used'] as num?)?.toInt(),
);

Map<String, dynamic> _$$QuickAskResponseImplToJson(
  _$QuickAskResponseImpl instance,
) => <String, dynamic>{
  'content': instance.content,
  'data_sources_used': instance.dataSourcesUsed,
  'tokens_used': instance.tokensUsed,
};

_$SuggestedQuestionsImpl _$$SuggestedQuestionsImplFromJson(
  Map<String, dynamic> json,
) => _$SuggestedQuestionsImpl(
  category: json['category'] as String,
  questions: (json['questions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$SuggestedQuestionsImplToJson(
  _$SuggestedQuestionsImpl instance,
) => <String, dynamic>{
  'category': instance.category,
  'questions': instance.questions,
};
