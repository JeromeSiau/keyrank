// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_action_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChatAction _$ChatActionFromJson(Map<String, dynamic> json) {
  return _ChatAction.fromJson(json);
}

/// @nodoc
mixin _$ChatAction {
  int get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  Map<String, dynamic> get parameters => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get explanation => throw _privateConstructorUsedError;
  bool get reversible => throw _privateConstructorUsedError;
  Map<String, dynamic>? get result => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ChatAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatActionCopyWith<ChatAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatActionCopyWith<$Res> {
  factory $ChatActionCopyWith(
    ChatAction value,
    $Res Function(ChatAction) then,
  ) = _$ChatActionCopyWithImpl<$Res, ChatAction>;
  @useResult
  $Res call({
    int id,
    String type,
    Map<String, dynamic> parameters,
    String status,
    String explanation,
    bool reversible,
    Map<String, dynamic>? result,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$ChatActionCopyWithImpl<$Res, $Val extends ChatAction>
    implements $ChatActionCopyWith<$Res> {
  _$ChatActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? parameters = null,
    Object? status = null,
    Object? explanation = null,
    Object? reversible = null,
    Object? result = freezed,
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
            parameters: null == parameters
                ? _value.parameters
                : parameters // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            explanation: null == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                      as String,
            reversible: null == reversible
                ? _value.reversible
                : reversible // ignore: cast_nullable_to_non_nullable
                      as bool,
            result: freezed == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
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
abstract class _$$ChatActionImplCopyWith<$Res>
    implements $ChatActionCopyWith<$Res> {
  factory _$$ChatActionImplCopyWith(
    _$ChatActionImpl value,
    $Res Function(_$ChatActionImpl) then,
  ) = __$$ChatActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String type,
    Map<String, dynamic> parameters,
    String status,
    String explanation,
    bool reversible,
    Map<String, dynamic>? result,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$ChatActionImplCopyWithImpl<$Res>
    extends _$ChatActionCopyWithImpl<$Res, _$ChatActionImpl>
    implements _$$ChatActionImplCopyWith<$Res> {
  __$$ChatActionImplCopyWithImpl(
    _$ChatActionImpl _value,
    $Res Function(_$ChatActionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? parameters = null,
    Object? status = null,
    Object? explanation = null,
    Object? reversible = null,
    Object? result = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$ChatActionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        parameters: null == parameters
            ? _value._parameters
            : parameters // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        explanation: null == explanation
            ? _value.explanation
            : explanation // ignore: cast_nullable_to_non_nullable
                  as String,
        reversible: null == reversible
            ? _value.reversible
            : reversible // ignore: cast_nullable_to_non_nullable
                  as bool,
        result: freezed == result
            ? _value._result
            : result // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
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
class _$ChatActionImpl extends _ChatAction {
  const _$ChatActionImpl({
    required this.id,
    required this.type,
    required final Map<String, dynamic> parameters,
    required this.status,
    required this.explanation,
    this.reversible = true,
    final Map<String, dynamic>? result,
    @JsonKey(name: 'created_at') required this.createdAt,
  }) : _parameters = parameters,
       _result = result,
       super._();

  factory _$ChatActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatActionImplFromJson(json);

  @override
  final int id;
  @override
  final String type;
  final Map<String, dynamic> _parameters;
  @override
  Map<String, dynamic> get parameters {
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_parameters);
  }

  @override
  final String status;
  @override
  final String explanation;
  @override
  @JsonKey()
  final bool reversible;
  final Map<String, dynamic>? _result;
  @override
  Map<String, dynamic>? get result {
    final value = _result;
    if (value == null) return null;
    if (_result is EqualUnmodifiableMapView) return _result;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'ChatAction(id: $id, type: $type, parameters: $parameters, status: $status, explanation: $explanation, reversible: $reversible, result: $result, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatActionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(
              other._parameters,
              _parameters,
            ) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            (identical(other.reversible, reversible) ||
                other.reversible == reversible) &&
            const DeepCollectionEquality().equals(other._result, _result) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    const DeepCollectionEquality().hash(_parameters),
    status,
    explanation,
    reversible,
    const DeepCollectionEquality().hash(_result),
    createdAt,
  );

  /// Create a copy of ChatAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatActionImplCopyWith<_$ChatActionImpl> get copyWith =>
      __$$ChatActionImplCopyWithImpl<_$ChatActionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatActionImplToJson(this);
  }
}

abstract class _ChatAction extends ChatAction {
  const factory _ChatAction({
    required final int id,
    required final String type,
    required final Map<String, dynamic> parameters,
    required final String status,
    required final String explanation,
    final bool reversible,
    final Map<String, dynamic>? result,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$ChatActionImpl;
  const _ChatAction._() : super._();

  factory _ChatAction.fromJson(Map<String, dynamic> json) =
      _$ChatActionImpl.fromJson;

  @override
  int get id;
  @override
  String get type;
  @override
  Map<String, dynamic> get parameters;
  @override
  String get status;
  @override
  String get explanation;
  @override
  bool get reversible;
  @override
  Map<String, dynamic>? get result;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of ChatAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatActionImplCopyWith<_$ChatActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
