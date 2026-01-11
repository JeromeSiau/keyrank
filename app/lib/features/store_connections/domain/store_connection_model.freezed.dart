// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_connection_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StoreConnection _$StoreConnectionFromJson(Map<String, dynamic> json) {
  return _StoreConnection.fromJson(json);
}

/// @nodoc
mixin _$StoreConnection {
  int get id => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'connected_at')
  DateTime get connectedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_sync_at')
  DateTime? get lastSyncAt => throw _privateConstructorUsedError;

  /// Serializes this StoreConnection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreConnection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreConnectionCopyWith<StoreConnection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreConnectionCopyWith<$Res> {
  factory $StoreConnectionCopyWith(
    StoreConnection value,
    $Res Function(StoreConnection) then,
  ) = _$StoreConnectionCopyWithImpl<$Res, StoreConnection>;
  @useResult
  $Res call({
    int id,
    String platform,
    String status,
    @JsonKey(name: 'connected_at') DateTime connectedAt,
    @JsonKey(name: 'last_sync_at') DateTime? lastSyncAt,
  });
}

/// @nodoc
class _$StoreConnectionCopyWithImpl<$Res, $Val extends StoreConnection>
    implements $StoreConnectionCopyWith<$Res> {
  _$StoreConnectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreConnection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? platform = null,
    Object? status = null,
    Object? connectedAt = null,
    Object? lastSyncAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            platform: null == platform
                ? _value.platform
                : platform // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            connectedAt: null == connectedAt
                ? _value.connectedAt
                : connectedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastSyncAt: freezed == lastSyncAt
                ? _value.lastSyncAt
                : lastSyncAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StoreConnectionImplCopyWith<$Res>
    implements $StoreConnectionCopyWith<$Res> {
  factory _$$StoreConnectionImplCopyWith(
    _$StoreConnectionImpl value,
    $Res Function(_$StoreConnectionImpl) then,
  ) = __$$StoreConnectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String platform,
    String status,
    @JsonKey(name: 'connected_at') DateTime connectedAt,
    @JsonKey(name: 'last_sync_at') DateTime? lastSyncAt,
  });
}

/// @nodoc
class __$$StoreConnectionImplCopyWithImpl<$Res>
    extends _$StoreConnectionCopyWithImpl<$Res, _$StoreConnectionImpl>
    implements _$$StoreConnectionImplCopyWith<$Res> {
  __$$StoreConnectionImplCopyWithImpl(
    _$StoreConnectionImpl _value,
    $Res Function(_$StoreConnectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StoreConnection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? platform = null,
    Object? status = null,
    Object? connectedAt = null,
    Object? lastSyncAt = freezed,
  }) {
    return _then(
      _$StoreConnectionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        platform: null == platform
            ? _value.platform
            : platform // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        connectedAt: null == connectedAt
            ? _value.connectedAt
            : connectedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastSyncAt: freezed == lastSyncAt
            ? _value.lastSyncAt
            : lastSyncAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreConnectionImpl implements _StoreConnection {
  const _$StoreConnectionImpl({
    required this.id,
    required this.platform,
    required this.status,
    @JsonKey(name: 'connected_at') required this.connectedAt,
    @JsonKey(name: 'last_sync_at') this.lastSyncAt,
  });

  factory _$StoreConnectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreConnectionImplFromJson(json);

  @override
  final int id;
  @override
  final String platform;
  @override
  final String status;
  @override
  @JsonKey(name: 'connected_at')
  final DateTime connectedAt;
  @override
  @JsonKey(name: 'last_sync_at')
  final DateTime? lastSyncAt;

  @override
  String toString() {
    return 'StoreConnection(id: $id, platform: $platform, status: $status, connectedAt: $connectedAt, lastSyncAt: $lastSyncAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreConnectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.connectedAt, connectedAt) ||
                other.connectedAt == connectedAt) &&
            (identical(other.lastSyncAt, lastSyncAt) ||
                other.lastSyncAt == lastSyncAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, platform, status, connectedAt, lastSyncAt);

  /// Create a copy of StoreConnection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreConnectionImplCopyWith<_$StoreConnectionImpl> get copyWith =>
      __$$StoreConnectionImplCopyWithImpl<_$StoreConnectionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreConnectionImplToJson(this);
  }
}

abstract class _StoreConnection implements StoreConnection {
  const factory _StoreConnection({
    required final int id,
    required final String platform,
    required final String status,
    @JsonKey(name: 'connected_at') required final DateTime connectedAt,
    @JsonKey(name: 'last_sync_at') final DateTime? lastSyncAt,
  }) = _$StoreConnectionImpl;

  factory _StoreConnection.fromJson(Map<String, dynamic> json) =
      _$StoreConnectionImpl.fromJson;

  @override
  int get id;
  @override
  String get platform;
  @override
  String get status;
  @override
  @JsonKey(name: 'connected_at')
  DateTime get connectedAt;
  @override
  @JsonKey(name: 'last_sync_at')
  DateTime? get lastSyncAt;

  /// Create a copy of StoreConnection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreConnectionImplCopyWith<_$StoreConnectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
