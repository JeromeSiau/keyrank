// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  alertRuleId: (json['alert_rule_id'] as num?)?.toInt(),
  type: json['type'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  data: json['data'] as Map<String, dynamic>?,
  isRead: json['is_read'] as bool,
  readAt: json['read_at'] == null
      ? null
      : DateTime.parse(json['read_at'] as String),
  sentAt: json['sent_at'] == null
      ? null
      : DateTime.parse(json['sent_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'alert_rule_id': instance.alertRuleId,
  'type': instance.type,
  'title': instance.title,
  'body': instance.body,
  'data': instance.data,
  'is_read': instance.isRead,
  'read_at': instance.readAt?.toIso8601String(),
  'sent_at': instance.sentAt?.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
};

_$NotificationsPageImpl _$$NotificationsPageImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationsPageImpl(
  data: (json['data'] as List<dynamic>)
      .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  currentPage: (json['current_page'] as num).toInt(),
  lastPage: (json['last_page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$$NotificationsPageImplToJson(
  _$NotificationsPageImpl instance,
) => <String, dynamic>{
  'data': instance.data,
  'current_page': instance.currentPage,
  'last_page': instance.lastPage,
  'total': instance.total,
};
