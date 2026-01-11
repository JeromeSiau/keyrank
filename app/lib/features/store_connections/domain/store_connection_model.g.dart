// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_connection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoreConnectionImpl _$$StoreConnectionImplFromJson(
  Map<String, dynamic> json,
) => _$StoreConnectionImpl(
  id: (json['id'] as num).toInt(),
  platform: json['platform'] as String,
  status: json['status'] as String,
  connectedAt: DateTime.parse(json['connected_at'] as String),
  lastSyncAt: json['last_sync_at'] == null
      ? null
      : DateTime.parse(json['last_sync_at'] as String),
);

Map<String, dynamic> _$$StoreConnectionImplToJson(
  _$StoreConnectionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'platform': instance.platform,
  'status': instance.status,
  'connected_at': instance.connectedAt.toIso8601String(),
  'last_sync_at': instance.lastSyncAt?.toIso8601String(),
};
