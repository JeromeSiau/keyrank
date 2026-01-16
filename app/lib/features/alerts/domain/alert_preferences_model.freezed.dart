// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_preferences_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AlertDelivery _$AlertDeliveryFromJson(Map<String, dynamic> json) {
  return _AlertDelivery.fromJson(json);
}

/// @nodoc
mixin _$AlertDelivery {
  bool get push => throw _privateConstructorUsedError;
  bool get email => throw _privateConstructorUsedError;
  bool get digest => throw _privateConstructorUsedError;

  /// Serializes this AlertDelivery to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlertDelivery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertDeliveryCopyWith<AlertDelivery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertDeliveryCopyWith<$Res> {
  factory $AlertDeliveryCopyWith(
    AlertDelivery value,
    $Res Function(AlertDelivery) then,
  ) = _$AlertDeliveryCopyWithImpl<$Res, AlertDelivery>;
  @useResult
  $Res call({bool push, bool email, bool digest});
}

/// @nodoc
class _$AlertDeliveryCopyWithImpl<$Res, $Val extends AlertDelivery>
    implements $AlertDeliveryCopyWith<$Res> {
  _$AlertDeliveryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertDelivery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? push = null,
    Object? email = null,
    Object? digest = null,
  }) {
    return _then(
      _value.copyWith(
            push: null == push
                ? _value.push
                : push // ignore: cast_nullable_to_non_nullable
                      as bool,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as bool,
            digest: null == digest
                ? _value.digest
                : digest // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlertDeliveryImplCopyWith<$Res>
    implements $AlertDeliveryCopyWith<$Res> {
  factory _$$AlertDeliveryImplCopyWith(
    _$AlertDeliveryImpl value,
    $Res Function(_$AlertDeliveryImpl) then,
  ) = __$$AlertDeliveryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool push, bool email, bool digest});
}

/// @nodoc
class __$$AlertDeliveryImplCopyWithImpl<$Res>
    extends _$AlertDeliveryCopyWithImpl<$Res, _$AlertDeliveryImpl>
    implements _$$AlertDeliveryImplCopyWith<$Res> {
  __$$AlertDeliveryImplCopyWithImpl(
    _$AlertDeliveryImpl _value,
    $Res Function(_$AlertDeliveryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AlertDelivery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? push = null,
    Object? email = null,
    Object? digest = null,
  }) {
    return _then(
      _$AlertDeliveryImpl(
        push: null == push
            ? _value.push
            : push // ignore: cast_nullable_to_non_nullable
                  as bool,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as bool,
        digest: null == digest
            ? _value.digest
            : digest // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertDeliveryImpl implements _AlertDelivery {
  const _$AlertDeliveryImpl({
    this.push = true,
    this.email = false,
    this.digest = false,
  });

  factory _$AlertDeliveryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertDeliveryImplFromJson(json);

  @override
  @JsonKey()
  final bool push;
  @override
  @JsonKey()
  final bool email;
  @override
  @JsonKey()
  final bool digest;

  @override
  String toString() {
    return 'AlertDelivery(push: $push, email: $email, digest: $digest)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertDeliveryImpl &&
            (identical(other.push, push) || other.push == push) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.digest, digest) || other.digest == digest));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, push, email, digest);

  /// Create a copy of AlertDelivery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertDeliveryImplCopyWith<_$AlertDeliveryImpl> get copyWith =>
      __$$AlertDeliveryImplCopyWithImpl<_$AlertDeliveryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertDeliveryImplToJson(this);
  }
}

abstract class _AlertDelivery implements AlertDelivery {
  const factory _AlertDelivery({
    final bool push,
    final bool email,
    final bool digest,
  }) = _$AlertDeliveryImpl;

  factory _AlertDelivery.fromJson(Map<String, dynamic> json) =
      _$AlertDeliveryImpl.fromJson;

  @override
  bool get push;
  @override
  bool get email;
  @override
  bool get digest;

  /// Create a copy of AlertDelivery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertDeliveryImplCopyWith<_$AlertDeliveryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AlertPreferences _$AlertPreferencesFromJson(Map<String, dynamic> json) {
  return _AlertPreferences.fromJson(json);
}

/// @nodoc
mixin _$AlertPreferences {
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'email_notifications_enabled')
  bool get emailNotificationsEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_by_type')
  Map<String, AlertDelivery> get deliveryByType =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'digest_time')
  String get digestTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'weekly_digest_day')
  String get weeklyDigestDay => throw _privateConstructorUsedError;

  /// Serializes this AlertPreferences to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlertPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertPreferencesCopyWith<AlertPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertPreferencesCopyWith<$Res> {
  factory $AlertPreferencesCopyWith(
    AlertPreferences value,
    $Res Function(AlertPreferences) then,
  ) = _$AlertPreferencesCopyWithImpl<$Res, AlertPreferences>;
  @useResult
  $Res call({
    String email,
    @JsonKey(name: 'email_notifications_enabled')
    bool emailNotificationsEnabled,
    @JsonKey(name: 'delivery_by_type')
    Map<String, AlertDelivery> deliveryByType,
    @JsonKey(name: 'digest_time') String digestTime,
    @JsonKey(name: 'weekly_digest_day') String weeklyDigestDay,
  });
}

/// @nodoc
class _$AlertPreferencesCopyWithImpl<$Res, $Val extends AlertPreferences>
    implements $AlertPreferencesCopyWith<$Res> {
  _$AlertPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? emailNotificationsEnabled = null,
    Object? deliveryByType = null,
    Object? digestTime = null,
    Object? weeklyDigestDay = null,
  }) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            emailNotificationsEnabled: null == emailNotificationsEnabled
                ? _value.emailNotificationsEnabled
                : emailNotificationsEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            deliveryByType: null == deliveryByType
                ? _value.deliveryByType
                : deliveryByType // ignore: cast_nullable_to_non_nullable
                      as Map<String, AlertDelivery>,
            digestTime: null == digestTime
                ? _value.digestTime
                : digestTime // ignore: cast_nullable_to_non_nullable
                      as String,
            weeklyDigestDay: null == weeklyDigestDay
                ? _value.weeklyDigestDay
                : weeklyDigestDay // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlertPreferencesImplCopyWith<$Res>
    implements $AlertPreferencesCopyWith<$Res> {
  factory _$$AlertPreferencesImplCopyWith(
    _$AlertPreferencesImpl value,
    $Res Function(_$AlertPreferencesImpl) then,
  ) = __$$AlertPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String email,
    @JsonKey(name: 'email_notifications_enabled')
    bool emailNotificationsEnabled,
    @JsonKey(name: 'delivery_by_type')
    Map<String, AlertDelivery> deliveryByType,
    @JsonKey(name: 'digest_time') String digestTime,
    @JsonKey(name: 'weekly_digest_day') String weeklyDigestDay,
  });
}

/// @nodoc
class __$$AlertPreferencesImplCopyWithImpl<$Res>
    extends _$AlertPreferencesCopyWithImpl<$Res, _$AlertPreferencesImpl>
    implements _$$AlertPreferencesImplCopyWith<$Res> {
  __$$AlertPreferencesImplCopyWithImpl(
    _$AlertPreferencesImpl _value,
    $Res Function(_$AlertPreferencesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AlertPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? emailNotificationsEnabled = null,
    Object? deliveryByType = null,
    Object? digestTime = null,
    Object? weeklyDigestDay = null,
  }) {
    return _then(
      _$AlertPreferencesImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        emailNotificationsEnabled: null == emailNotificationsEnabled
            ? _value.emailNotificationsEnabled
            : emailNotificationsEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        deliveryByType: null == deliveryByType
            ? _value._deliveryByType
            : deliveryByType // ignore: cast_nullable_to_non_nullable
                  as Map<String, AlertDelivery>,
        digestTime: null == digestTime
            ? _value.digestTime
            : digestTime // ignore: cast_nullable_to_non_nullable
                  as String,
        weeklyDigestDay: null == weeklyDigestDay
            ? _value.weeklyDigestDay
            : weeklyDigestDay // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertPreferencesImpl extends _AlertPreferences {
  const _$AlertPreferencesImpl({
    required this.email,
    @JsonKey(name: 'email_notifications_enabled')
    this.emailNotificationsEnabled = true,
    @JsonKey(name: 'delivery_by_type')
    required final Map<String, AlertDelivery> deliveryByType,
    @JsonKey(name: 'digest_time') this.digestTime = '09:00',
    @JsonKey(name: 'weekly_digest_day') this.weeklyDigestDay = 'monday',
  }) : _deliveryByType = deliveryByType,
       super._();

  factory _$AlertPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertPreferencesImplFromJson(json);

  @override
  final String email;
  @override
  @JsonKey(name: 'email_notifications_enabled')
  final bool emailNotificationsEnabled;
  final Map<String, AlertDelivery> _deliveryByType;
  @override
  @JsonKey(name: 'delivery_by_type')
  Map<String, AlertDelivery> get deliveryByType {
    if (_deliveryByType is EqualUnmodifiableMapView) return _deliveryByType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_deliveryByType);
  }

  @override
  @JsonKey(name: 'digest_time')
  final String digestTime;
  @override
  @JsonKey(name: 'weekly_digest_day')
  final String weeklyDigestDay;

  @override
  String toString() {
    return 'AlertPreferences(email: $email, emailNotificationsEnabled: $emailNotificationsEnabled, deliveryByType: $deliveryByType, digestTime: $digestTime, weeklyDigestDay: $weeklyDigestDay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertPreferencesImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(
                  other.emailNotificationsEnabled,
                  emailNotificationsEnabled,
                ) ||
                other.emailNotificationsEnabled == emailNotificationsEnabled) &&
            const DeepCollectionEquality().equals(
              other._deliveryByType,
              _deliveryByType,
            ) &&
            (identical(other.digestTime, digestTime) ||
                other.digestTime == digestTime) &&
            (identical(other.weeklyDigestDay, weeklyDigestDay) ||
                other.weeklyDigestDay == weeklyDigestDay));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    email,
    emailNotificationsEnabled,
    const DeepCollectionEquality().hash(_deliveryByType),
    digestTime,
    weeklyDigestDay,
  );

  /// Create a copy of AlertPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertPreferencesImplCopyWith<_$AlertPreferencesImpl> get copyWith =>
      __$$AlertPreferencesImplCopyWithImpl<_$AlertPreferencesImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertPreferencesImplToJson(this);
  }
}

abstract class _AlertPreferences extends AlertPreferences {
  const factory _AlertPreferences({
    required final String email,
    @JsonKey(name: 'email_notifications_enabled')
    final bool emailNotificationsEnabled,
    @JsonKey(name: 'delivery_by_type')
    required final Map<String, AlertDelivery> deliveryByType,
    @JsonKey(name: 'digest_time') final String digestTime,
    @JsonKey(name: 'weekly_digest_day') final String weeklyDigestDay,
  }) = _$AlertPreferencesImpl;
  const _AlertPreferences._() : super._();

  factory _AlertPreferences.fromJson(Map<String, dynamic> json) =
      _$AlertPreferencesImpl.fromJson;

  @override
  String get email;
  @override
  @JsonKey(name: 'email_notifications_enabled')
  bool get emailNotificationsEnabled;
  @override
  @JsonKey(name: 'delivery_by_type')
  Map<String, AlertDelivery> get deliveryByType;
  @override
  @JsonKey(name: 'digest_time')
  String get digestTime;
  @override
  @JsonKey(name: 'weekly_digest_day')
  String get weeklyDigestDay;

  /// Create a copy of AlertPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertPreferencesImplCopyWith<_$AlertPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AlertTypeInfo _$AlertTypeInfoFromJson(Map<String, dynamic> json) {
  return _AlertTypeInfo.fromJson(json);
}

/// @nodoc
mixin _$AlertTypeInfo {
  String get type => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;

  /// Serializes this AlertTypeInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlertTypeInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertTypeInfoCopyWith<AlertTypeInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertTypeInfoCopyWith<$Res> {
  factory $AlertTypeInfoCopyWith(
    AlertTypeInfo value,
    $Res Function(AlertTypeInfo) then,
  ) = _$AlertTypeInfoCopyWithImpl<$Res, AlertTypeInfo>;
  @useResult
  $Res call({String type, String label, String description, String icon});
}

/// @nodoc
class _$AlertTypeInfoCopyWithImpl<$Res, $Val extends AlertTypeInfo>
    implements $AlertTypeInfoCopyWith<$Res> {
  _$AlertTypeInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertTypeInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? label = null,
    Object? description = null,
    Object? icon = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlertTypeInfoImplCopyWith<$Res>
    implements $AlertTypeInfoCopyWith<$Res> {
  factory _$$AlertTypeInfoImplCopyWith(
    _$AlertTypeInfoImpl value,
    $Res Function(_$AlertTypeInfoImpl) then,
  ) = __$$AlertTypeInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, String label, String description, String icon});
}

/// @nodoc
class __$$AlertTypeInfoImplCopyWithImpl<$Res>
    extends _$AlertTypeInfoCopyWithImpl<$Res, _$AlertTypeInfoImpl>
    implements _$$AlertTypeInfoImplCopyWith<$Res> {
  __$$AlertTypeInfoImplCopyWithImpl(
    _$AlertTypeInfoImpl _value,
    $Res Function(_$AlertTypeInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AlertTypeInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? label = null,
    Object? description = null,
    Object? icon = null,
  }) {
    return _then(
      _$AlertTypeInfoImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertTypeInfoImpl implements _AlertTypeInfo {
  const _$AlertTypeInfoImpl({
    required this.type,
    required this.label,
    required this.description,
    required this.icon,
  });

  factory _$AlertTypeInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertTypeInfoImplFromJson(json);

  @override
  final String type;
  @override
  final String label;
  @override
  final String description;
  @override
  final String icon;

  @override
  String toString() {
    return 'AlertTypeInfo(type: $type, label: $label, description: $description, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertTypeInfoImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, label, description, icon);

  /// Create a copy of AlertTypeInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertTypeInfoImplCopyWith<_$AlertTypeInfoImpl> get copyWith =>
      __$$AlertTypeInfoImplCopyWithImpl<_$AlertTypeInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertTypeInfoImplToJson(this);
  }
}

abstract class _AlertTypeInfo implements AlertTypeInfo {
  const factory _AlertTypeInfo({
    required final String type,
    required final String label,
    required final String description,
    required final String icon,
  }) = _$AlertTypeInfoImpl;

  factory _AlertTypeInfo.fromJson(Map<String, dynamic> json) =
      _$AlertTypeInfoImpl.fromJson;

  @override
  String get type;
  @override
  String get label;
  @override
  String get description;
  @override
  String get icon;

  /// Create a copy of AlertTypeInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertTypeInfoImplCopyWith<_$AlertTypeInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
