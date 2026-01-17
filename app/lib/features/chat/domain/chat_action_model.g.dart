// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_action_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatActionImpl _$$ChatActionImplFromJson(Map<String, dynamic> json) =>
    _$ChatActionImpl(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      parameters: json['parameters'] as Map<String, dynamic>,
      status: json['status'] as String,
      explanation: json['explanation'] as String,
      reversible: json['reversible'] as bool? ?? true,
      result: json['result'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ChatActionImplToJson(_$ChatActionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'parameters': instance.parameters,
      'status': instance.status,
      'explanation': instance.explanation,
      'reversible': instance.reversible,
      'result': instance.result,
      'created_at': instance.createdAt.toIso8601String(),
    };
