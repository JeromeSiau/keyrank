// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'integration_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Integration _$IntegrationFromJson(Map<String, dynamic> json) {
  return _Integration.fromJson(json);
}

/// @nodoc
mixin _$Integration {
  int get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_sync_at')
  DateTime? get lastSyncAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'error_message')
  String? get errorMessage => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Integration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Integration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IntegrationCopyWith<Integration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IntegrationCopyWith<$Res> {
  factory $IntegrationCopyWith(
    Integration value,
    $Res Function(Integration) then,
  ) = _$IntegrationCopyWithImpl<$Res, Integration>;
  @useResult
  $Res call({
    int id,
    String type,
    String status,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'last_sync_at') DateTime? lastSyncAt,
    @JsonKey(name: 'error_message') String? errorMessage,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$IntegrationCopyWithImpl<$Res, $Val extends Integration>
    implements $IntegrationCopyWith<$Res> {
  _$IntegrationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Integration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? status = null,
    Object? metadata = freezed,
    Object? lastSyncAt = freezed,
    Object? errorMessage = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            lastSyncAt: freezed == lastSyncAt
                ? _value.lastSyncAt
                : lastSyncAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IntegrationImplCopyWith<$Res>
    implements $IntegrationCopyWith<$Res> {
  factory _$$IntegrationImplCopyWith(
    _$IntegrationImpl value,
    $Res Function(_$IntegrationImpl) then,
  ) = __$$IntegrationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String type,
    String status,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'last_sync_at') DateTime? lastSyncAt,
    @JsonKey(name: 'error_message') String? errorMessage,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$IntegrationImplCopyWithImpl<$Res>
    extends _$IntegrationCopyWithImpl<$Res, _$IntegrationImpl>
    implements _$$IntegrationImplCopyWith<$Res> {
  __$$IntegrationImplCopyWithImpl(
    _$IntegrationImpl _value,
    $Res Function(_$IntegrationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Integration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? status = null,
    Object? metadata = freezed,
    Object? lastSyncAt = freezed,
    Object? errorMessage = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$IntegrationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        lastSyncAt: freezed == lastSyncAt
            ? _value.lastSyncAt
            : lastSyncAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IntegrationImpl extends _Integration {
  const _$IntegrationImpl({
    required this.id,
    required this.type,
    required this.status,
    final Map<String, dynamic>? metadata,
    @JsonKey(name: 'last_sync_at') this.lastSyncAt,
    @JsonKey(name: 'error_message') this.errorMessage,
    @JsonKey(name: 'created_at') required this.createdAt,
  }) : _metadata = metadata,
       super._();

  factory _$IntegrationImpl.fromJson(Map<String, dynamic> json) =>
      _$$IntegrationImplFromJson(json);

  @override
  final int id;
  @override
  final String type;
  @override
  final String status;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'last_sync_at')
  final DateTime? lastSyncAt;
  @override
  @JsonKey(name: 'error_message')
  final String? errorMessage;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'Integration(id: $id, type: $type, status: $status, metadata: $metadata, lastSyncAt: $lastSyncAt, errorMessage: $errorMessage, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IntegrationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.lastSyncAt, lastSyncAt) ||
                other.lastSyncAt == lastSyncAt) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    status,
    const DeepCollectionEquality().hash(_metadata),
    lastSyncAt,
    errorMessage,
    createdAt,
  );

  /// Create a copy of Integration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IntegrationImplCopyWith<_$IntegrationImpl> get copyWith =>
      __$$IntegrationImplCopyWithImpl<_$IntegrationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IntegrationImplToJson(this);
  }
}

abstract class _Integration extends Integration {
  const factory _Integration({
    required final int id,
    required final String type,
    required final String status,
    final Map<String, dynamic>? metadata,
    @JsonKey(name: 'last_sync_at') final DateTime? lastSyncAt,
    @JsonKey(name: 'error_message') final String? errorMessage,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$IntegrationImpl;
  const _Integration._() : super._();

  factory _Integration.fromJson(Map<String, dynamic> json) =
      _$IntegrationImpl.fromJson;

  @override
  int get id;
  @override
  String get type;
  @override
  String get status;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(name: 'last_sync_at')
  DateTime? get lastSyncAt;
  @override
  @JsonKey(name: 'error_message')
  String? get errorMessage;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of Integration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IntegrationImplCopyWith<_$IntegrationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IntegrationApp _$IntegrationAppFromJson(Map<String, dynamic> json) {
  return _IntegrationApp.fromJson(json);
}

/// @nodoc
mixin _$IntegrationApp {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'bundle_id')
  String? get bundleId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;

  /// Serializes this IntegrationApp to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IntegrationApp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IntegrationAppCopyWith<IntegrationApp> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IntegrationAppCopyWith<$Res> {
  factory $IntegrationAppCopyWith(
    IntegrationApp value,
    $Res Function(IntegrationApp) then,
  ) = _$IntegrationAppCopyWithImpl<$Res, IntegrationApp>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'store_id') String storeId,
    @JsonKey(name: 'bundle_id') String? bundleId,
    String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String platform,
  });
}

/// @nodoc
class _$IntegrationAppCopyWithImpl<$Res, $Val extends IntegrationApp>
    implements $IntegrationAppCopyWith<$Res> {
  _$IntegrationAppCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IntegrationApp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? bundleId = freezed,
    Object? name = null,
    Object? iconUrl = freezed,
    Object? platform = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            storeId: null == storeId
                ? _value.storeId
                : storeId // ignore: cast_nullable_to_non_nullable
                      as String,
            bundleId: freezed == bundleId
                ? _value.bundleId
                : bundleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            platform: null == platform
                ? _value.platform
                : platform // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IntegrationAppImplCopyWith<$Res>
    implements $IntegrationAppCopyWith<$Res> {
  factory _$$IntegrationAppImplCopyWith(
    _$IntegrationAppImpl value,
    $Res Function(_$IntegrationAppImpl) then,
  ) = __$$IntegrationAppImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'store_id') String storeId,
    @JsonKey(name: 'bundle_id') String? bundleId,
    String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String platform,
  });
}

/// @nodoc
class __$$IntegrationAppImplCopyWithImpl<$Res>
    extends _$IntegrationAppCopyWithImpl<$Res, _$IntegrationAppImpl>
    implements _$$IntegrationAppImplCopyWith<$Res> {
  __$$IntegrationAppImplCopyWithImpl(
    _$IntegrationAppImpl _value,
    $Res Function(_$IntegrationAppImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IntegrationApp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? bundleId = freezed,
    Object? name = null,
    Object? iconUrl = freezed,
    Object? platform = null,
  }) {
    return _then(
      _$IntegrationAppImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        storeId: null == storeId
            ? _value.storeId
            : storeId // ignore: cast_nullable_to_non_nullable
                  as String,
        bundleId: freezed == bundleId
            ? _value.bundleId
            : bundleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        platform: null == platform
            ? _value.platform
            : platform // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IntegrationAppImpl implements _IntegrationApp {
  const _$IntegrationAppImpl({
    required this.id,
    @JsonKey(name: 'store_id') required this.storeId,
    @JsonKey(name: 'bundle_id') this.bundleId,
    required this.name,
    @JsonKey(name: 'icon_url') this.iconUrl,
    required this.platform,
  });

  factory _$IntegrationAppImpl.fromJson(Map<String, dynamic> json) =>
      _$$IntegrationAppImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  @JsonKey(name: 'bundle_id')
  final String? bundleId;
  @override
  final String name;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  final String platform;

  @override
  String toString() {
    return 'IntegrationApp(id: $id, storeId: $storeId, bundleId: $bundleId, name: $name, iconUrl: $iconUrl, platform: $platform)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IntegrationAppImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.bundleId, bundleId) ||
                other.bundleId == bundleId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.platform, platform) ||
                other.platform == platform));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, storeId, bundleId, name, iconUrl, platform);

  /// Create a copy of IntegrationApp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IntegrationAppImplCopyWith<_$IntegrationAppImpl> get copyWith =>
      __$$IntegrationAppImplCopyWithImpl<_$IntegrationAppImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$IntegrationAppImplToJson(this);
  }
}

abstract class _IntegrationApp implements IntegrationApp {
  const factory _IntegrationApp({
    required final int id,
    @JsonKey(name: 'store_id') required final String storeId,
    @JsonKey(name: 'bundle_id') final String? bundleId,
    required final String name,
    @JsonKey(name: 'icon_url') final String? iconUrl,
    required final String platform,
  }) = _$IntegrationAppImpl;

  factory _IntegrationApp.fromJson(Map<String, dynamic> json) =
      _$IntegrationAppImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  @JsonKey(name: 'bundle_id')
  String? get bundleId;
  @override
  String get name;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  String get platform;

  /// Create a copy of IntegrationApp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IntegrationAppImplCopyWith<_$IntegrationAppImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConnectAppStoreResult _$ConnectAppStoreResultFromJson(
  Map<String, dynamic> json,
) {
  return _ConnectAppStoreResult.fromJson(json);
}

/// @nodoc
mixin _$ConnectAppStoreResult {
  int get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'apps_discovered')
  int get appsDiscovered => throw _privateConstructorUsedError;
  @JsonKey(name: 'apps_imported')
  int get appsImported => throw _privateConstructorUsedError;

  /// Serializes this ConnectAppStoreResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConnectAppStoreResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConnectAppStoreResultCopyWith<ConnectAppStoreResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectAppStoreResultCopyWith<$Res> {
  factory $ConnectAppStoreResultCopyWith(
    ConnectAppStoreResult value,
    $Res Function(ConnectAppStoreResult) then,
  ) = _$ConnectAppStoreResultCopyWithImpl<$Res, ConnectAppStoreResult>;
  @useResult
  $Res call({
    int id,
    String type,
    String status,
    @JsonKey(name: 'apps_discovered') int appsDiscovered,
    @JsonKey(name: 'apps_imported') int appsImported,
  });
}

/// @nodoc
class _$ConnectAppStoreResultCopyWithImpl<
  $Res,
  $Val extends ConnectAppStoreResult
>
    implements $ConnectAppStoreResultCopyWith<$Res> {
  _$ConnectAppStoreResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConnectAppStoreResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? status = null,
    Object? appsDiscovered = null,
    Object? appsImported = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            appsDiscovered: null == appsDiscovered
                ? _value.appsDiscovered
                : appsDiscovered // ignore: cast_nullable_to_non_nullable
                      as int,
            appsImported: null == appsImported
                ? _value.appsImported
                : appsImported // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConnectAppStoreResultImplCopyWith<$Res>
    implements $ConnectAppStoreResultCopyWith<$Res> {
  factory _$$ConnectAppStoreResultImplCopyWith(
    _$ConnectAppStoreResultImpl value,
    $Res Function(_$ConnectAppStoreResultImpl) then,
  ) = __$$ConnectAppStoreResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String type,
    String status,
    @JsonKey(name: 'apps_discovered') int appsDiscovered,
    @JsonKey(name: 'apps_imported') int appsImported,
  });
}

/// @nodoc
class __$$ConnectAppStoreResultImplCopyWithImpl<$Res>
    extends
        _$ConnectAppStoreResultCopyWithImpl<$Res, _$ConnectAppStoreResultImpl>
    implements _$$ConnectAppStoreResultImplCopyWith<$Res> {
  __$$ConnectAppStoreResultImplCopyWithImpl(
    _$ConnectAppStoreResultImpl _value,
    $Res Function(_$ConnectAppStoreResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConnectAppStoreResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? status = null,
    Object? appsDiscovered = null,
    Object? appsImported = null,
  }) {
    return _then(
      _$ConnectAppStoreResultImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        appsDiscovered: null == appsDiscovered
            ? _value.appsDiscovered
            : appsDiscovered // ignore: cast_nullable_to_non_nullable
                  as int,
        appsImported: null == appsImported
            ? _value.appsImported
            : appsImported // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConnectAppStoreResultImpl implements _ConnectAppStoreResult {
  const _$ConnectAppStoreResultImpl({
    required this.id,
    required this.type,
    required this.status,
    @JsonKey(name: 'apps_discovered') required this.appsDiscovered,
    @JsonKey(name: 'apps_imported') required this.appsImported,
  });

  factory _$ConnectAppStoreResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConnectAppStoreResultImplFromJson(json);

  @override
  final int id;
  @override
  final String type;
  @override
  final String status;
  @override
  @JsonKey(name: 'apps_discovered')
  final int appsDiscovered;
  @override
  @JsonKey(name: 'apps_imported')
  final int appsImported;

  @override
  String toString() {
    return 'ConnectAppStoreResult(id: $id, type: $type, status: $status, appsDiscovered: $appsDiscovered, appsImported: $appsImported)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectAppStoreResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.appsDiscovered, appsDiscovered) ||
                other.appsDiscovered == appsDiscovered) &&
            (identical(other.appsImported, appsImported) ||
                other.appsImported == appsImported));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, type, status, appsDiscovered, appsImported);

  /// Create a copy of ConnectAppStoreResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectAppStoreResultImplCopyWith<_$ConnectAppStoreResultImpl>
  get copyWith =>
      __$$ConnectAppStoreResultImplCopyWithImpl<_$ConnectAppStoreResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ConnectAppStoreResultImplToJson(this);
  }
}

abstract class _ConnectAppStoreResult implements ConnectAppStoreResult {
  const factory _ConnectAppStoreResult({
    required final int id,
    required final String type,
    required final String status,
    @JsonKey(name: 'apps_discovered') required final int appsDiscovered,
    @JsonKey(name: 'apps_imported') required final int appsImported,
  }) = _$ConnectAppStoreResultImpl;

  factory _ConnectAppStoreResult.fromJson(Map<String, dynamic> json) =
      _$ConnectAppStoreResultImpl.fromJson;

  @override
  int get id;
  @override
  String get type;
  @override
  String get status;
  @override
  @JsonKey(name: 'apps_discovered')
  int get appsDiscovered;
  @override
  @JsonKey(name: 'apps_imported')
  int get appsImported;

  /// Create a copy of ConnectAppStoreResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConnectAppStoreResultImplCopyWith<_$ConnectAppStoreResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ConnectGooglePlayResult _$ConnectGooglePlayResultFromJson(
  Map<String, dynamic> json,
) {
  return _ConnectGooglePlayResult.fromJson(json);
}

/// @nodoc
mixin _$ConnectGooglePlayResult {
  int get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'apps_imported')
  int get appsImported => throw _privateConstructorUsedError;

  /// Serializes this ConnectGooglePlayResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConnectGooglePlayResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConnectGooglePlayResultCopyWith<ConnectGooglePlayResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectGooglePlayResultCopyWith<$Res> {
  factory $ConnectGooglePlayResultCopyWith(
    ConnectGooglePlayResult value,
    $Res Function(ConnectGooglePlayResult) then,
  ) = _$ConnectGooglePlayResultCopyWithImpl<$Res, ConnectGooglePlayResult>;
  @useResult
  $Res call({
    int id,
    String type,
    String status,
    @JsonKey(name: 'apps_imported') int appsImported,
  });
}

/// @nodoc
class _$ConnectGooglePlayResultCopyWithImpl<
  $Res,
  $Val extends ConnectGooglePlayResult
>
    implements $ConnectGooglePlayResultCopyWith<$Res> {
  _$ConnectGooglePlayResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConnectGooglePlayResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? status = null,
    Object? appsImported = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            appsImported: null == appsImported
                ? _value.appsImported
                : appsImported // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConnectGooglePlayResultImplCopyWith<$Res>
    implements $ConnectGooglePlayResultCopyWith<$Res> {
  factory _$$ConnectGooglePlayResultImplCopyWith(
    _$ConnectGooglePlayResultImpl value,
    $Res Function(_$ConnectGooglePlayResultImpl) then,
  ) = __$$ConnectGooglePlayResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String type,
    String status,
    @JsonKey(name: 'apps_imported') int appsImported,
  });
}

/// @nodoc
class __$$ConnectGooglePlayResultImplCopyWithImpl<$Res>
    extends
        _$ConnectGooglePlayResultCopyWithImpl<
          $Res,
          _$ConnectGooglePlayResultImpl
        >
    implements _$$ConnectGooglePlayResultImplCopyWith<$Res> {
  __$$ConnectGooglePlayResultImplCopyWithImpl(
    _$ConnectGooglePlayResultImpl _value,
    $Res Function(_$ConnectGooglePlayResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConnectGooglePlayResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? status = null,
    Object? appsImported = null,
  }) {
    return _then(
      _$ConnectGooglePlayResultImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        appsImported: null == appsImported
            ? _value.appsImported
            : appsImported // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConnectGooglePlayResultImpl implements _ConnectGooglePlayResult {
  const _$ConnectGooglePlayResultImpl({
    required this.id,
    required this.type,
    required this.status,
    @JsonKey(name: 'apps_imported') required this.appsImported,
  });

  factory _$ConnectGooglePlayResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConnectGooglePlayResultImplFromJson(json);

  @override
  final int id;
  @override
  final String type;
  @override
  final String status;
  @override
  @JsonKey(name: 'apps_imported')
  final int appsImported;

  @override
  String toString() {
    return 'ConnectGooglePlayResult(id: $id, type: $type, status: $status, appsImported: $appsImported)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectGooglePlayResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.appsImported, appsImported) ||
                other.appsImported == appsImported));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, status, appsImported);

  /// Create a copy of ConnectGooglePlayResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectGooglePlayResultImplCopyWith<_$ConnectGooglePlayResultImpl>
  get copyWith =>
      __$$ConnectGooglePlayResultImplCopyWithImpl<
        _$ConnectGooglePlayResultImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConnectGooglePlayResultImplToJson(this);
  }
}

abstract class _ConnectGooglePlayResult implements ConnectGooglePlayResult {
  const factory _ConnectGooglePlayResult({
    required final int id,
    required final String type,
    required final String status,
    @JsonKey(name: 'apps_imported') required final int appsImported,
  }) = _$ConnectGooglePlayResultImpl;

  factory _ConnectGooglePlayResult.fromJson(Map<String, dynamic> json) =
      _$ConnectGooglePlayResultImpl.fromJson;

  @override
  int get id;
  @override
  String get type;
  @override
  String get status;
  @override
  @JsonKey(name: 'apps_imported')
  int get appsImported;

  /// Create a copy of ConnectGooglePlayResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConnectGooglePlayResultImplCopyWith<_$ConnectGooglePlayResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}
