// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_preferences_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlertDeliveryImpl _$$AlertDeliveryImplFromJson(Map<String, dynamic> json) =>
    _$AlertDeliveryImpl(
      push: json['push'] as bool? ?? true,
      email: json['email'] as bool? ?? false,
      digest: json['digest'] as bool? ?? false,
    );

Map<String, dynamic> _$$AlertDeliveryImplToJson(_$AlertDeliveryImpl instance) =>
    <String, dynamic>{
      'push': instance.push,
      'email': instance.email,
      'digest': instance.digest,
    };

_$AlertPreferencesImpl _$$AlertPreferencesImplFromJson(
  Map<String, dynamic> json,
) => _$AlertPreferencesImpl(
  email: json['email'] as String,
  emailNotificationsEnabled:
      json['email_notifications_enabled'] as bool? ?? true,
  deliveryByType: (json['delivery_by_type'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, AlertDelivery.fromJson(e as Map<String, dynamic>)),
  ),
  digestTime: json['digest_time'] as String? ?? '09:00',
  weeklyDigestDay: json['weekly_digest_day'] as String? ?? 'monday',
);

Map<String, dynamic> _$$AlertPreferencesImplToJson(
  _$AlertPreferencesImpl instance,
) => <String, dynamic>{
  'email': instance.email,
  'email_notifications_enabled': instance.emailNotificationsEnabled,
  'delivery_by_type': instance.deliveryByType,
  'digest_time': instance.digestTime,
  'weekly_digest_day': instance.weeklyDigestDay,
};

_$AlertTypeInfoImpl _$$AlertTypeInfoImplFromJson(Map<String, dynamic> json) =>
    _$AlertTypeInfoImpl(
      type: json['type'] as String,
      label: json['label'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$$AlertTypeInfoImplToJson(_$AlertTypeInfoImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'label': instance.label,
      'description': instance.description,
      'icon': instance.icon,
    };
