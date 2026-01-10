// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_rule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlertRuleModelImpl _$$AlertRuleModelImplFromJson(Map<String, dynamic> json) =>
    _$AlertRuleModelImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      name: json['name'] as String,
      type: json['type'] as String,
      scopeType: json['scope_type'] as String,
      scopeId: (json['scope_id'] as num?)?.toInt(),
      conditions: json['conditions'] as Map<String, dynamic>,
      isTemplate: json['is_template'] as bool,
      isActive: json['is_active'] as bool,
      priority: (json['priority'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$AlertRuleModelImplToJson(
  _$AlertRuleModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'name': instance.name,
  'type': instance.type,
  'scope_type': instance.scopeType,
  'scope_id': instance.scopeId,
  'conditions': instance.conditions,
  'is_template': instance.isTemplate,
  'is_active': instance.isActive,
  'priority': instance.priority,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

_$AlertTemplateModelImpl _$$AlertTemplateModelImplFromJson(
  Map<String, dynamic> json,
) => _$AlertTemplateModelImpl(
  name: json['name'] as String,
  type: json['type'] as String,
  icon: json['icon'] as String,
  description: json['description'] as String,
  defaultConditions: json['default_conditions'] as Map<String, dynamic>,
);

Map<String, dynamic> _$$AlertTemplateModelImplToJson(
  _$AlertTemplateModelImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'type': instance.type,
  'icon': instance.icon,
  'description': instance.description,
  'default_conditions': instance.defaultConditions,
};
