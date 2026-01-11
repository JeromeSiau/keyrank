// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IntegrationImpl _$$IntegrationImplFromJson(Map<String, dynamic> json) =>
    _$IntegrationImpl(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      status: json['status'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
      lastSyncAt: json['last_sync_at'] == null
          ? null
          : DateTime.parse(json['last_sync_at'] as String),
      errorMessage: json['error_message'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$IntegrationImplToJson(_$IntegrationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'status': instance.status,
      'metadata': instance.metadata,
      'last_sync_at': instance.lastSyncAt?.toIso8601String(),
      'error_message': instance.errorMessage,
      'created_at': instance.createdAt.toIso8601String(),
    };

_$IntegrationAppImpl _$$IntegrationAppImplFromJson(Map<String, dynamic> json) =>
    _$IntegrationAppImpl(
      id: (json['id'] as num).toInt(),
      storeId: json['store_id'] as String,
      bundleId: json['bundle_id'] as String?,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$$IntegrationAppImplToJson(
  _$IntegrationAppImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'store_id': instance.storeId,
  'bundle_id': instance.bundleId,
  'name': instance.name,
  'icon_url': instance.iconUrl,
  'platform': instance.platform,
};

_$ConnectAppStoreResultImpl _$$ConnectAppStoreResultImplFromJson(
  Map<String, dynamic> json,
) => _$ConnectAppStoreResultImpl(
  id: (json['id'] as num).toInt(),
  type: json['type'] as String,
  status: json['status'] as String,
  appsDiscovered: (json['apps_discovered'] as num).toInt(),
  appsImported: (json['apps_imported'] as num).toInt(),
);

Map<String, dynamic> _$$ConnectAppStoreResultImplToJson(
  _$ConnectAppStoreResultImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'status': instance.status,
  'apps_discovered': instance.appsDiscovered,
  'apps_imported': instance.appsImported,
};

_$ConnectGooglePlayResultImpl _$$ConnectGooglePlayResultImplFromJson(
  Map<String, dynamic> json,
) => _$ConnectGooglePlayResultImpl(
  id: (json['id'] as num).toInt(),
  type: json['type'] as String,
  status: json['status'] as String,
  appsImported: (json['apps_imported'] as num).toInt(),
);

Map<String, dynamic> _$$ConnectGooglePlayResultImplToJson(
  _$ConnectGooglePlayResultImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'status': instance.status,
  'apps_imported': instance.appsImported,
};
