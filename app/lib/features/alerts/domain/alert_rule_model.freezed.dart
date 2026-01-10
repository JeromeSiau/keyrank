// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_rule_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AlertRuleModel _$AlertRuleModelFromJson(Map<String, dynamic> json) {
  return _AlertRuleModel.fromJson(json);
}

/// @nodoc
mixin _$AlertRuleModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'scope_type')
  String get scopeType => throw _privateConstructorUsedError;
  @JsonKey(name: 'scope_id')
  int? get scopeId => throw _privateConstructorUsedError;
  Map<String, dynamic> get conditions => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_template')
  bool get isTemplate => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AlertRuleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlertRuleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertRuleModelCopyWith<AlertRuleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertRuleModelCopyWith<$Res> {
  factory $AlertRuleModelCopyWith(
    AlertRuleModel value,
    $Res Function(AlertRuleModel) then,
  ) = _$AlertRuleModelCopyWithImpl<$Res, AlertRuleModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'user_id') int userId,
    String name,
    String type,
    @JsonKey(name: 'scope_type') String scopeType,
    @JsonKey(name: 'scope_id') int? scopeId,
    Map<String, dynamic> conditions,
    @JsonKey(name: 'is_template') bool isTemplate,
    @JsonKey(name: 'is_active') bool isActive,
    int priority,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$AlertRuleModelCopyWithImpl<$Res, $Val extends AlertRuleModel>
    implements $AlertRuleModelCopyWith<$Res> {
  _$AlertRuleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertRuleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? type = null,
    Object? scopeType = null,
    Object? scopeId = freezed,
    Object? conditions = null,
    Object? isTemplate = null,
    Object? isActive = null,
    Object? priority = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            scopeType: null == scopeType
                ? _value.scopeType
                : scopeType // ignore: cast_nullable_to_non_nullable
                      as String,
            scopeId: freezed == scopeId
                ? _value.scopeId
                : scopeId // ignore: cast_nullable_to_non_nullable
                      as int?,
            conditions: null == conditions
                ? _value.conditions
                : conditions // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            isTemplate: null == isTemplate
                ? _value.isTemplate
                : isTemplate // ignore: cast_nullable_to_non_nullable
                      as bool,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlertRuleModelImplCopyWith<$Res>
    implements $AlertRuleModelCopyWith<$Res> {
  factory _$$AlertRuleModelImplCopyWith(
    _$AlertRuleModelImpl value,
    $Res Function(_$AlertRuleModelImpl) then,
  ) = __$$AlertRuleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'user_id') int userId,
    String name,
    String type,
    @JsonKey(name: 'scope_type') String scopeType,
    @JsonKey(name: 'scope_id') int? scopeId,
    Map<String, dynamic> conditions,
    @JsonKey(name: 'is_template') bool isTemplate,
    @JsonKey(name: 'is_active') bool isActive,
    int priority,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$AlertRuleModelImplCopyWithImpl<$Res>
    extends _$AlertRuleModelCopyWithImpl<$Res, _$AlertRuleModelImpl>
    implements _$$AlertRuleModelImplCopyWith<$Res> {
  __$$AlertRuleModelImplCopyWithImpl(
    _$AlertRuleModelImpl _value,
    $Res Function(_$AlertRuleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AlertRuleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? type = null,
    Object? scopeType = null,
    Object? scopeId = freezed,
    Object? conditions = null,
    Object? isTemplate = null,
    Object? isActive = null,
    Object? priority = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$AlertRuleModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        scopeType: null == scopeType
            ? _value.scopeType
            : scopeType // ignore: cast_nullable_to_non_nullable
                  as String,
        scopeId: freezed == scopeId
            ? _value.scopeId
            : scopeId // ignore: cast_nullable_to_non_nullable
                  as int?,
        conditions: null == conditions
            ? _value._conditions
            : conditions // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        isTemplate: null == isTemplate
            ? _value.isTemplate
            : isTemplate // ignore: cast_nullable_to_non_nullable
                  as bool,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertRuleModelImpl implements _AlertRuleModel {
  const _$AlertRuleModelImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    required this.name,
    required this.type,
    @JsonKey(name: 'scope_type') required this.scopeType,
    @JsonKey(name: 'scope_id') this.scopeId,
    required final Map<String, dynamic> conditions,
    @JsonKey(name: 'is_template') required this.isTemplate,
    @JsonKey(name: 'is_active') required this.isActive,
    required this.priority,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _conditions = conditions;

  factory _$AlertRuleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertRuleModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'user_id')
  final int userId;
  @override
  final String name;
  @override
  final String type;
  @override
  @JsonKey(name: 'scope_type')
  final String scopeType;
  @override
  @JsonKey(name: 'scope_id')
  final int? scopeId;
  final Map<String, dynamic> _conditions;
  @override
  Map<String, dynamic> get conditions {
    if (_conditions is EqualUnmodifiableMapView) return _conditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_conditions);
  }

  @override
  @JsonKey(name: 'is_template')
  final bool isTemplate;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  final int priority;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'AlertRuleModel(id: $id, userId: $userId, name: $name, type: $type, scopeType: $scopeType, scopeId: $scopeId, conditions: $conditions, isTemplate: $isTemplate, isActive: $isActive, priority: $priority, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertRuleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.scopeType, scopeType) ||
                other.scopeType == scopeType) &&
            (identical(other.scopeId, scopeId) || other.scopeId == scopeId) &&
            const DeepCollectionEquality().equals(
              other._conditions,
              _conditions,
            ) &&
            (identical(other.isTemplate, isTemplate) ||
                other.isTemplate == isTemplate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    name,
    type,
    scopeType,
    scopeId,
    const DeepCollectionEquality().hash(_conditions),
    isTemplate,
    isActive,
    priority,
    createdAt,
    updatedAt,
  );

  /// Create a copy of AlertRuleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertRuleModelImplCopyWith<_$AlertRuleModelImpl> get copyWith =>
      __$$AlertRuleModelImplCopyWithImpl<_$AlertRuleModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertRuleModelImplToJson(this);
  }
}

abstract class _AlertRuleModel implements AlertRuleModel {
  const factory _AlertRuleModel({
    required final int id,
    @JsonKey(name: 'user_id') required final int userId,
    required final String name,
    required final String type,
    @JsonKey(name: 'scope_type') required final String scopeType,
    @JsonKey(name: 'scope_id') final int? scopeId,
    required final Map<String, dynamic> conditions,
    @JsonKey(name: 'is_template') required final bool isTemplate,
    @JsonKey(name: 'is_active') required final bool isActive,
    required final int priority,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$AlertRuleModelImpl;

  factory _AlertRuleModel.fromJson(Map<String, dynamic> json) =
      _$AlertRuleModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'user_id')
  int get userId;
  @override
  String get name;
  @override
  String get type;
  @override
  @JsonKey(name: 'scope_type')
  String get scopeType;
  @override
  @JsonKey(name: 'scope_id')
  int? get scopeId;
  @override
  Map<String, dynamic> get conditions;
  @override
  @JsonKey(name: 'is_template')
  bool get isTemplate;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  int get priority;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of AlertRuleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertRuleModelImplCopyWith<_$AlertRuleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AlertTemplateModel _$AlertTemplateModelFromJson(Map<String, dynamic> json) {
  return _AlertTemplateModel.fromJson(json);
}

/// @nodoc
mixin _$AlertTemplateModel {
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'default_conditions')
  Map<String, dynamic> get defaultConditions =>
      throw _privateConstructorUsedError;

  /// Serializes this AlertTemplateModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlertTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertTemplateModelCopyWith<AlertTemplateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertTemplateModelCopyWith<$Res> {
  factory $AlertTemplateModelCopyWith(
    AlertTemplateModel value,
    $Res Function(AlertTemplateModel) then,
  ) = _$AlertTemplateModelCopyWithImpl<$Res, AlertTemplateModel>;
  @useResult
  $Res call({
    String name,
    String type,
    String icon,
    String description,
    @JsonKey(name: 'default_conditions') Map<String, dynamic> defaultConditions,
  });
}

/// @nodoc
class _$AlertTemplateModelCopyWithImpl<$Res, $Val extends AlertTemplateModel>
    implements $AlertTemplateModelCopyWith<$Res> {
  _$AlertTemplateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? icon = null,
    Object? description = null,
    Object? defaultConditions = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            defaultConditions: null == defaultConditions
                ? _value.defaultConditions
                : defaultConditions // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlertTemplateModelImplCopyWith<$Res>
    implements $AlertTemplateModelCopyWith<$Res> {
  factory _$$AlertTemplateModelImplCopyWith(
    _$AlertTemplateModelImpl value,
    $Res Function(_$AlertTemplateModelImpl) then,
  ) = __$$AlertTemplateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String type,
    String icon,
    String description,
    @JsonKey(name: 'default_conditions') Map<String, dynamic> defaultConditions,
  });
}

/// @nodoc
class __$$AlertTemplateModelImplCopyWithImpl<$Res>
    extends _$AlertTemplateModelCopyWithImpl<$Res, _$AlertTemplateModelImpl>
    implements _$$AlertTemplateModelImplCopyWith<$Res> {
  __$$AlertTemplateModelImplCopyWithImpl(
    _$AlertTemplateModelImpl _value,
    $Res Function(_$AlertTemplateModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AlertTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? icon = null,
    Object? description = null,
    Object? defaultConditions = null,
  }) {
    return _then(
      _$AlertTemplateModelImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        defaultConditions: null == defaultConditions
            ? _value._defaultConditions
            : defaultConditions // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertTemplateModelImpl implements _AlertTemplateModel {
  const _$AlertTemplateModelImpl({
    required this.name,
    required this.type,
    required this.icon,
    required this.description,
    @JsonKey(name: 'default_conditions')
    required final Map<String, dynamic> defaultConditions,
  }) : _defaultConditions = defaultConditions;

  factory _$AlertTemplateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertTemplateModelImplFromJson(json);

  @override
  final String name;
  @override
  final String type;
  @override
  final String icon;
  @override
  final String description;
  final Map<String, dynamic> _defaultConditions;
  @override
  @JsonKey(name: 'default_conditions')
  Map<String, dynamic> get defaultConditions {
    if (_defaultConditions is EqualUnmodifiableMapView)
      return _defaultConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_defaultConditions);
  }

  @override
  String toString() {
    return 'AlertTemplateModel(name: $name, type: $type, icon: $icon, description: $description, defaultConditions: $defaultConditions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertTemplateModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._defaultConditions,
              _defaultConditions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    type,
    icon,
    description,
    const DeepCollectionEquality().hash(_defaultConditions),
  );

  /// Create a copy of AlertTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertTemplateModelImplCopyWith<_$AlertTemplateModelImpl> get copyWith =>
      __$$AlertTemplateModelImplCopyWithImpl<_$AlertTemplateModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertTemplateModelImplToJson(this);
  }
}

abstract class _AlertTemplateModel implements AlertTemplateModel {
  const factory _AlertTemplateModel({
    required final String name,
    required final String type,
    required final String icon,
    required final String description,
    @JsonKey(name: 'default_conditions')
    required final Map<String, dynamic> defaultConditions,
  }) = _$AlertTemplateModelImpl;

  factory _AlertTemplateModel.fromJson(Map<String, dynamic> json) =
      _$AlertTemplateModelImpl.fromJson;

  @override
  String get name;
  @override
  String get type;
  @override
  String get icon;
  @override
  String get description;
  @override
  @JsonKey(name: 'default_conditions')
  Map<String, dynamic> get defaultConditions;

  /// Create a copy of AlertTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertTemplateModelImplCopyWith<_$AlertTemplateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
