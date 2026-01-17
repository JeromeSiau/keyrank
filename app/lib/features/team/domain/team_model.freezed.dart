// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TeamModel _$TeamModelFromJson(Map<String, dynamic> json) {
  return _TeamModel.fromJson(json);
}

/// @nodoc
mixin _$TeamModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  int get ownerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'members_count')
  int get membersCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'my_role')
  String get myRole => throw _privateConstructorUsedError;
  List<String> get permissions => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TeamModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamModelCopyWith<TeamModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamModelCopyWith<$Res> {
  factory $TeamModelCopyWith(TeamModel value, $Res Function(TeamModel) then) =
      _$TeamModelCopyWithImpl<$Res, TeamModel>;
  @useResult
  $Res call({
    int id,
    String name,
    String slug,
    String? description,
    @JsonKey(name: 'owner_id') int ownerId,
    @JsonKey(name: 'members_count') int membersCount,
    @JsonKey(name: 'my_role') String myRole,
    List<String> permissions,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class _$TeamModelCopyWithImpl<$Res, $Val extends TeamModel>
    implements $TeamModelCopyWith<$Res> {
  _$TeamModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? ownerId = null,
    Object? membersCount = null,
    Object? myRole = null,
    Object? permissions = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as int,
            membersCount: null == membersCount
                ? _value.membersCount
                : membersCount // ignore: cast_nullable_to_non_nullable
                      as int,
            myRole: null == myRole
                ? _value.myRole
                : myRole // ignore: cast_nullable_to_non_nullable
                      as String,
            permissions: null == permissions
                ? _value.permissions
                : permissions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeamModelImplCopyWith<$Res>
    implements $TeamModelCopyWith<$Res> {
  factory _$$TeamModelImplCopyWith(
    _$TeamModelImpl value,
    $Res Function(_$TeamModelImpl) then,
  ) = __$$TeamModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String slug,
    String? description,
    @JsonKey(name: 'owner_id') int ownerId,
    @JsonKey(name: 'members_count') int membersCount,
    @JsonKey(name: 'my_role') String myRole,
    List<String> permissions,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class __$$TeamModelImplCopyWithImpl<$Res>
    extends _$TeamModelCopyWithImpl<$Res, _$TeamModelImpl>
    implements _$$TeamModelImplCopyWith<$Res> {
  __$$TeamModelImplCopyWithImpl(
    _$TeamModelImpl _value,
    $Res Function(_$TeamModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? ownerId = null,
    Object? membersCount = null,
    Object? myRole = null,
    Object? permissions = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$TeamModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as int,
        membersCount: null == membersCount
            ? _value.membersCount
            : membersCount // ignore: cast_nullable_to_non_nullable
                  as int,
        myRole: null == myRole
            ? _value.myRole
            : myRole // ignore: cast_nullable_to_non_nullable
                  as String,
        permissions: null == permissions
            ? _value._permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamModelImpl extends _TeamModel {
  const _$TeamModelImpl({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    @JsonKey(name: 'owner_id') required this.ownerId,
    @JsonKey(name: 'members_count') required this.membersCount,
    @JsonKey(name: 'my_role') required this.myRole,
    required final List<String> permissions,
    @JsonKey(name: 'created_at') required this.createdAt,
  }) : _permissions = permissions,
       super._();

  factory _$TeamModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final String? description;
  @override
  @JsonKey(name: 'owner_id')
  final int ownerId;
  @override
  @JsonKey(name: 'members_count')
  final int membersCount;
  @override
  @JsonKey(name: 'my_role')
  final String myRole;
  final List<String> _permissions;
  @override
  List<String> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'TeamModel(id: $id, name: $name, slug: $slug, description: $description, ownerId: $ownerId, membersCount: $membersCount, myRole: $myRole, permissions: $permissions, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.membersCount, membersCount) ||
                other.membersCount == membersCount) &&
            (identical(other.myRole, myRole) || other.myRole == myRole) &&
            const DeepCollectionEquality().equals(
              other._permissions,
              _permissions,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    slug,
    description,
    ownerId,
    membersCount,
    myRole,
    const DeepCollectionEquality().hash(_permissions),
    createdAt,
  );

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamModelImplCopyWith<_$TeamModelImpl> get copyWith =>
      __$$TeamModelImplCopyWithImpl<_$TeamModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamModelImplToJson(this);
  }
}

abstract class _TeamModel extends TeamModel {
  const factory _TeamModel({
    required final int id,
    required final String name,
    required final String slug,
    final String? description,
    @JsonKey(name: 'owner_id') required final int ownerId,
    @JsonKey(name: 'members_count') required final int membersCount,
    @JsonKey(name: 'my_role') required final String myRole,
    required final List<String> permissions,
    @JsonKey(name: 'created_at') required final String createdAt,
  }) = _$TeamModelImpl;
  const _TeamModel._() : super._();

  factory _TeamModel.fromJson(Map<String, dynamic> json) =
      _$TeamModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  String? get description;
  @override
  @JsonKey(name: 'owner_id')
  int get ownerId;
  @override
  @JsonKey(name: 'members_count')
  int get membersCount;
  @override
  @JsonKey(name: 'my_role')
  String get myRole;
  @override
  List<String> get permissions;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamModelImplCopyWith<_$TeamModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamMemberModel _$TeamMemberModelFromJson(Map<String, dynamic> json) {
  return _TeamMemberModel.fromJson(json);
}

/// @nodoc
mixin _$TeamMemberModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'joined_at')
  String? get joinedAt => throw _privateConstructorUsedError;

  /// Serializes this TeamMemberModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamMemberModelCopyWith<TeamMemberModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamMemberModelCopyWith<$Res> {
  factory $TeamMemberModelCopyWith(
    TeamMemberModel value,
    $Res Function(TeamMemberModel) then,
  ) = _$TeamMemberModelCopyWithImpl<$Res, TeamMemberModel>;
  @useResult
  $Res call({
    int id,
    String name,
    String email,
    String role,
    @JsonKey(name: 'joined_at') String? joinedAt,
  });
}

/// @nodoc
class _$TeamMemberModelCopyWithImpl<$Res, $Val extends TeamMemberModel>
    implements $TeamMemberModelCopyWith<$Res> {
  _$TeamMemberModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? role = null,
    Object? joinedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            joinedAt: freezed == joinedAt
                ? _value.joinedAt
                : joinedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeamMemberModelImplCopyWith<$Res>
    implements $TeamMemberModelCopyWith<$Res> {
  factory _$$TeamMemberModelImplCopyWith(
    _$TeamMemberModelImpl value,
    $Res Function(_$TeamMemberModelImpl) then,
  ) = __$$TeamMemberModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String email,
    String role,
    @JsonKey(name: 'joined_at') String? joinedAt,
  });
}

/// @nodoc
class __$$TeamMemberModelImplCopyWithImpl<$Res>
    extends _$TeamMemberModelCopyWithImpl<$Res, _$TeamMemberModelImpl>
    implements _$$TeamMemberModelImplCopyWith<$Res> {
  __$$TeamMemberModelImplCopyWithImpl(
    _$TeamMemberModelImpl _value,
    $Res Function(_$TeamMemberModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? role = null,
    Object? joinedAt = freezed,
  }) {
    return _then(
      _$TeamMemberModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        joinedAt: freezed == joinedAt
            ? _value.joinedAt
            : joinedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamMemberModelImpl extends _TeamMemberModel {
  const _$TeamMemberModelImpl({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    @JsonKey(name: 'joined_at') this.joinedAt,
  }) : super._();

  factory _$TeamMemberModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamMemberModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String role;
  @override
  @JsonKey(name: 'joined_at')
  final String? joinedAt;

  @override
  String toString() {
    return 'TeamMemberModel(id: $id, name: $name, email: $email, role: $role, joinedAt: $joinedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamMemberModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, email, role, joinedAt);

  /// Create a copy of TeamMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamMemberModelImplCopyWith<_$TeamMemberModelImpl> get copyWith =>
      __$$TeamMemberModelImplCopyWithImpl<_$TeamMemberModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamMemberModelImplToJson(this);
  }
}

abstract class _TeamMemberModel extends TeamMemberModel {
  const factory _TeamMemberModel({
    required final int id,
    required final String name,
    required final String email,
    required final String role,
    @JsonKey(name: 'joined_at') final String? joinedAt,
  }) = _$TeamMemberModelImpl;
  const _TeamMemberModel._() : super._();

  factory _TeamMemberModel.fromJson(Map<String, dynamic> json) =
      _$TeamMemberModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String get role;
  @override
  @JsonKey(name: 'joined_at')
  String? get joinedAt;

  /// Create a copy of TeamMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamMemberModelImplCopyWith<_$TeamMemberModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamInvitationModel _$TeamInvitationModelFromJson(Map<String, dynamic> json) {
  return _TeamInvitationModel.fromJson(json);
}

/// @nodoc
mixin _$TeamInvitationModel {
  int get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  String get expiresAt => throw _privateConstructorUsedError;
  InviterInfo get inviter => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  TeamBasicInfo? get team => throw _privateConstructorUsedError;

  /// Serializes this TeamInvitationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamInvitationModelCopyWith<TeamInvitationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamInvitationModelCopyWith<$Res> {
  factory $TeamInvitationModelCopyWith(
    TeamInvitationModel value,
    $Res Function(TeamInvitationModel) then,
  ) = _$TeamInvitationModelCopyWithImpl<$Res, TeamInvitationModel>;
  @useResult
  $Res call({
    int id,
    String email,
    String role,
    String status,
    String token,
    @JsonKey(name: 'expires_at') String expiresAt,
    InviterInfo inviter,
    @JsonKey(name: 'created_at') String createdAt,
    TeamBasicInfo? team,
  });

  $InviterInfoCopyWith<$Res> get inviter;
  $TeamBasicInfoCopyWith<$Res>? get team;
}

/// @nodoc
class _$TeamInvitationModelCopyWithImpl<$Res, $Val extends TeamInvitationModel>
    implements $TeamInvitationModelCopyWith<$Res> {
  _$TeamInvitationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? role = null,
    Object? status = null,
    Object? token = null,
    Object? expiresAt = null,
    Object? inviter = null,
    Object? createdAt = null,
    Object? team = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as String,
            inviter: null == inviter
                ? _value.inviter
                : inviter // ignore: cast_nullable_to_non_nullable
                      as InviterInfo,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            team: freezed == team
                ? _value.team
                : team // ignore: cast_nullable_to_non_nullable
                      as TeamBasicInfo?,
          )
          as $Val,
    );
  }

  /// Create a copy of TeamInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InviterInfoCopyWith<$Res> get inviter {
    return $InviterInfoCopyWith<$Res>(_value.inviter, (value) {
      return _then(_value.copyWith(inviter: value) as $Val);
    });
  }

  /// Create a copy of TeamInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamBasicInfoCopyWith<$Res>? get team {
    if (_value.team == null) {
      return null;
    }

    return $TeamBasicInfoCopyWith<$Res>(_value.team!, (value) {
      return _then(_value.copyWith(team: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TeamInvitationModelImplCopyWith<$Res>
    implements $TeamInvitationModelCopyWith<$Res> {
  factory _$$TeamInvitationModelImplCopyWith(
    _$TeamInvitationModelImpl value,
    $Res Function(_$TeamInvitationModelImpl) then,
  ) = __$$TeamInvitationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String email,
    String role,
    String status,
    String token,
    @JsonKey(name: 'expires_at') String expiresAt,
    InviterInfo inviter,
    @JsonKey(name: 'created_at') String createdAt,
    TeamBasicInfo? team,
  });

  @override
  $InviterInfoCopyWith<$Res> get inviter;
  @override
  $TeamBasicInfoCopyWith<$Res>? get team;
}

/// @nodoc
class __$$TeamInvitationModelImplCopyWithImpl<$Res>
    extends _$TeamInvitationModelCopyWithImpl<$Res, _$TeamInvitationModelImpl>
    implements _$$TeamInvitationModelImplCopyWith<$Res> {
  __$$TeamInvitationModelImplCopyWithImpl(
    _$TeamInvitationModelImpl _value,
    $Res Function(_$TeamInvitationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? role = null,
    Object? status = null,
    Object? token = null,
    Object? expiresAt = null,
    Object? inviter = null,
    Object? createdAt = null,
    Object? team = freezed,
  }) {
    return _then(
      _$TeamInvitationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as String,
        inviter: null == inviter
            ? _value.inviter
            : inviter // ignore: cast_nullable_to_non_nullable
                  as InviterInfo,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        team: freezed == team
            ? _value.team
            : team // ignore: cast_nullable_to_non_nullable
                  as TeamBasicInfo?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamInvitationModelImpl extends _TeamInvitationModel {
  const _$TeamInvitationModelImpl({
    required this.id,
    required this.email,
    required this.role,
    required this.status,
    required this.token,
    @JsonKey(name: 'expires_at') required this.expiresAt,
    required this.inviter,
    @JsonKey(name: 'created_at') required this.createdAt,
    this.team,
  }) : super._();

  factory _$TeamInvitationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamInvitationModelImplFromJson(json);

  @override
  final int id;
  @override
  final String email;
  @override
  final String role;
  @override
  final String status;
  @override
  final String token;
  @override
  @JsonKey(name: 'expires_at')
  final String expiresAt;
  @override
  final InviterInfo inviter;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  final TeamBasicInfo? team;

  @override
  String toString() {
    return 'TeamInvitationModel(id: $id, email: $email, role: $role, status: $status, token: $token, expiresAt: $expiresAt, inviter: $inviter, createdAt: $createdAt, team: $team)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamInvitationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.inviter, inviter) || other.inviter == inviter) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.team, team) || other.team == team));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    role,
    status,
    token,
    expiresAt,
    inviter,
    createdAt,
    team,
  );

  /// Create a copy of TeamInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamInvitationModelImplCopyWith<_$TeamInvitationModelImpl> get copyWith =>
      __$$TeamInvitationModelImplCopyWithImpl<_$TeamInvitationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamInvitationModelImplToJson(this);
  }
}

abstract class _TeamInvitationModel extends TeamInvitationModel {
  const factory _TeamInvitationModel({
    required final int id,
    required final String email,
    required final String role,
    required final String status,
    required final String token,
    @JsonKey(name: 'expires_at') required final String expiresAt,
    required final InviterInfo inviter,
    @JsonKey(name: 'created_at') required final String createdAt,
    final TeamBasicInfo? team,
  }) = _$TeamInvitationModelImpl;
  const _TeamInvitationModel._() : super._();

  factory _TeamInvitationModel.fromJson(Map<String, dynamic> json) =
      _$TeamInvitationModelImpl.fromJson;

  @override
  int get id;
  @override
  String get email;
  @override
  String get role;
  @override
  String get status;
  @override
  String get token;
  @override
  @JsonKey(name: 'expires_at')
  String get expiresAt;
  @override
  InviterInfo get inviter;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  TeamBasicInfo? get team;

  /// Create a copy of TeamInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamInvitationModelImplCopyWith<_$TeamInvitationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InviterInfo _$InviterInfoFromJson(Map<String, dynamic> json) {
  return _InviterInfo.fromJson(json);
}

/// @nodoc
mixin _$InviterInfo {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this InviterInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InviterInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InviterInfoCopyWith<InviterInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InviterInfoCopyWith<$Res> {
  factory $InviterInfoCopyWith(
    InviterInfo value,
    $Res Function(InviterInfo) then,
  ) = _$InviterInfoCopyWithImpl<$Res, InviterInfo>;
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class _$InviterInfoCopyWithImpl<$Res, $Val extends InviterInfo>
    implements $InviterInfoCopyWith<$Res> {
  _$InviterInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InviterInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InviterInfoImplCopyWith<$Res>
    implements $InviterInfoCopyWith<$Res> {
  factory _$$InviterInfoImplCopyWith(
    _$InviterInfoImpl value,
    $Res Function(_$InviterInfoImpl) then,
  ) = __$$InviterInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class __$$InviterInfoImplCopyWithImpl<$Res>
    extends _$InviterInfoCopyWithImpl<$Res, _$InviterInfoImpl>
    implements _$$InviterInfoImplCopyWith<$Res> {
  __$$InviterInfoImplCopyWithImpl(
    _$InviterInfoImpl _value,
    $Res Function(_$InviterInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InviterInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$InviterInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InviterInfoImpl implements _InviterInfo {
  const _$InviterInfoImpl({required this.id, required this.name});

  factory _$InviterInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InviterInfoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'InviterInfo(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InviterInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of InviterInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InviterInfoImplCopyWith<_$InviterInfoImpl> get copyWith =>
      __$$InviterInfoImplCopyWithImpl<_$InviterInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InviterInfoImplToJson(this);
  }
}

abstract class _InviterInfo implements InviterInfo {
  const factory _InviterInfo({
    required final int id,
    required final String name,
  }) = _$InviterInfoImpl;

  factory _InviterInfo.fromJson(Map<String, dynamic> json) =
      _$InviterInfoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;

  /// Create a copy of InviterInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InviterInfoImplCopyWith<_$InviterInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamBasicInfo _$TeamBasicInfoFromJson(Map<String, dynamic> json) {
  return _TeamBasicInfo.fromJson(json);
}

/// @nodoc
mixin _$TeamBasicInfo {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this TeamBasicInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamBasicInfoCopyWith<TeamBasicInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamBasicInfoCopyWith<$Res> {
  factory $TeamBasicInfoCopyWith(
    TeamBasicInfo value,
    $Res Function(TeamBasicInfo) then,
  ) = _$TeamBasicInfoCopyWithImpl<$Res, TeamBasicInfo>;
  @useResult
  $Res call({int id, String name, String? description});
}

/// @nodoc
class _$TeamBasicInfoCopyWithImpl<$Res, $Val extends TeamBasicInfo>
    implements $TeamBasicInfoCopyWith<$Res> {
  _$TeamBasicInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeamBasicInfoImplCopyWith<$Res>
    implements $TeamBasicInfoCopyWith<$Res> {
  factory _$$TeamBasicInfoImplCopyWith(
    _$TeamBasicInfoImpl value,
    $Res Function(_$TeamBasicInfoImpl) then,
  ) = __$$TeamBasicInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String? description});
}

/// @nodoc
class __$$TeamBasicInfoImplCopyWithImpl<$Res>
    extends _$TeamBasicInfoCopyWithImpl<$Res, _$TeamBasicInfoImpl>
    implements _$$TeamBasicInfoImplCopyWith<$Res> {
  __$$TeamBasicInfoImplCopyWithImpl(
    _$TeamBasicInfoImpl _value,
    $Res Function(_$TeamBasicInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(
      _$TeamBasicInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamBasicInfoImpl implements _TeamBasicInfo {
  const _$TeamBasicInfoImpl({
    required this.id,
    required this.name,
    this.description,
  });

  factory _$TeamBasicInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamBasicInfoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? description;

  @override
  String toString() {
    return 'TeamBasicInfo(id: $id, name: $name, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamBasicInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description);

  /// Create a copy of TeamBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamBasicInfoImplCopyWith<_$TeamBasicInfoImpl> get copyWith =>
      __$$TeamBasicInfoImplCopyWithImpl<_$TeamBasicInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamBasicInfoImplToJson(this);
  }
}

abstract class _TeamBasicInfo implements TeamBasicInfo {
  const factory _TeamBasicInfo({
    required final int id,
    required final String name,
    final String? description,
  }) = _$TeamBasicInfoImpl;

  factory _TeamBasicInfo.fromJson(Map<String, dynamic> json) =
      _$TeamBasicInfoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get description;

  /// Create a copy of TeamBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamBasicInfoImplCopyWith<_$TeamBasicInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamsResponse _$TeamsResponseFromJson(Map<String, dynamic> json) {
  return _TeamsResponse.fromJson(json);
}

/// @nodoc
mixin _$TeamsResponse {
  List<TeamModel> get teams => throw _privateConstructorUsedError;

  /// Serializes this TeamsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamsResponseCopyWith<TeamsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamsResponseCopyWith<$Res> {
  factory $TeamsResponseCopyWith(
    TeamsResponse value,
    $Res Function(TeamsResponse) then,
  ) = _$TeamsResponseCopyWithImpl<$Res, TeamsResponse>;
  @useResult
  $Res call({List<TeamModel> teams});
}

/// @nodoc
class _$TeamsResponseCopyWithImpl<$Res, $Val extends TeamsResponse>
    implements $TeamsResponseCopyWith<$Res> {
  _$TeamsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? teams = null}) {
    return _then(
      _value.copyWith(
            teams: null == teams
                ? _value.teams
                : teams // ignore: cast_nullable_to_non_nullable
                      as List<TeamModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeamsResponseImplCopyWith<$Res>
    implements $TeamsResponseCopyWith<$Res> {
  factory _$$TeamsResponseImplCopyWith(
    _$TeamsResponseImpl value,
    $Res Function(_$TeamsResponseImpl) then,
  ) = __$$TeamsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TeamModel> teams});
}

/// @nodoc
class __$$TeamsResponseImplCopyWithImpl<$Res>
    extends _$TeamsResponseCopyWithImpl<$Res, _$TeamsResponseImpl>
    implements _$$TeamsResponseImplCopyWith<$Res> {
  __$$TeamsResponseImplCopyWithImpl(
    _$TeamsResponseImpl _value,
    $Res Function(_$TeamsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? teams = null}) {
    return _then(
      _$TeamsResponseImpl(
        teams: null == teams
            ? _value._teams
            : teams // ignore: cast_nullable_to_non_nullable
                  as List<TeamModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamsResponseImpl implements _TeamsResponse {
  const _$TeamsResponseImpl({required final List<TeamModel> teams})
    : _teams = teams;

  factory _$TeamsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamsResponseImplFromJson(json);

  final List<TeamModel> _teams;
  @override
  List<TeamModel> get teams {
    if (_teams is EqualUnmodifiableListView) return _teams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_teams);
  }

  @override
  String toString() {
    return 'TeamsResponse(teams: $teams)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamsResponseImpl &&
            const DeepCollectionEquality().equals(other._teams, _teams));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_teams));

  /// Create a copy of TeamsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamsResponseImplCopyWith<_$TeamsResponseImpl> get copyWith =>
      __$$TeamsResponseImplCopyWithImpl<_$TeamsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamsResponseImplToJson(this);
  }
}

abstract class _TeamsResponse implements TeamsResponse {
  const factory _TeamsResponse({required final List<TeamModel> teams}) =
      _$TeamsResponseImpl;

  factory _TeamsResponse.fromJson(Map<String, dynamic> json) =
      _$TeamsResponseImpl.fromJson;

  @override
  List<TeamModel> get teams;

  /// Create a copy of TeamsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamsResponseImplCopyWith<_$TeamsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamResponse _$TeamResponseFromJson(Map<String, dynamic> json) {
  return _TeamResponse.fromJson(json);
}

/// @nodoc
mixin _$TeamResponse {
  TeamModel get team => throw _privateConstructorUsedError;

  /// Serializes this TeamResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamResponseCopyWith<TeamResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamResponseCopyWith<$Res> {
  factory $TeamResponseCopyWith(
    TeamResponse value,
    $Res Function(TeamResponse) then,
  ) = _$TeamResponseCopyWithImpl<$Res, TeamResponse>;
  @useResult
  $Res call({TeamModel team});

  $TeamModelCopyWith<$Res> get team;
}

/// @nodoc
class _$TeamResponseCopyWithImpl<$Res, $Val extends TeamResponse>
    implements $TeamResponseCopyWith<$Res> {
  _$TeamResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? team = null}) {
    return _then(
      _value.copyWith(
            team: null == team
                ? _value.team
                : team // ignore: cast_nullable_to_non_nullable
                      as TeamModel,
          )
          as $Val,
    );
  }

  /// Create a copy of TeamResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamModelCopyWith<$Res> get team {
    return $TeamModelCopyWith<$Res>(_value.team, (value) {
      return _then(_value.copyWith(team: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TeamResponseImplCopyWith<$Res>
    implements $TeamResponseCopyWith<$Res> {
  factory _$$TeamResponseImplCopyWith(
    _$TeamResponseImpl value,
    $Res Function(_$TeamResponseImpl) then,
  ) = __$$TeamResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TeamModel team});

  @override
  $TeamModelCopyWith<$Res> get team;
}

/// @nodoc
class __$$TeamResponseImplCopyWithImpl<$Res>
    extends _$TeamResponseCopyWithImpl<$Res, _$TeamResponseImpl>
    implements _$$TeamResponseImplCopyWith<$Res> {
  __$$TeamResponseImplCopyWithImpl(
    _$TeamResponseImpl _value,
    $Res Function(_$TeamResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? team = null}) {
    return _then(
      _$TeamResponseImpl(
        team: null == team
            ? _value.team
            : team // ignore: cast_nullable_to_non_nullable
                  as TeamModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamResponseImpl implements _TeamResponse {
  const _$TeamResponseImpl({required this.team});

  factory _$TeamResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamResponseImplFromJson(json);

  @override
  final TeamModel team;

  @override
  String toString() {
    return 'TeamResponse(team: $team)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamResponseImpl &&
            (identical(other.team, team) || other.team == team));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, team);

  /// Create a copy of TeamResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamResponseImplCopyWith<_$TeamResponseImpl> get copyWith =>
      __$$TeamResponseImplCopyWithImpl<_$TeamResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamResponseImplToJson(this);
  }
}

abstract class _TeamResponse implements TeamResponse {
  const factory _TeamResponse({required final TeamModel team}) =
      _$TeamResponseImpl;

  factory _TeamResponse.fromJson(Map<String, dynamic> json) =
      _$TeamResponseImpl.fromJson;

  @override
  TeamModel get team;

  /// Create a copy of TeamResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamResponseImplCopyWith<_$TeamResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamMembersResponse _$TeamMembersResponseFromJson(Map<String, dynamic> json) {
  return _TeamMembersResponse.fromJson(json);
}

/// @nodoc
mixin _$TeamMembersResponse {
  List<TeamMemberModel> get members => throw _privateConstructorUsedError;

  /// Serializes this TeamMembersResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamMembersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamMembersResponseCopyWith<TeamMembersResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamMembersResponseCopyWith<$Res> {
  factory $TeamMembersResponseCopyWith(
    TeamMembersResponse value,
    $Res Function(TeamMembersResponse) then,
  ) = _$TeamMembersResponseCopyWithImpl<$Res, TeamMembersResponse>;
  @useResult
  $Res call({List<TeamMemberModel> members});
}

/// @nodoc
class _$TeamMembersResponseCopyWithImpl<$Res, $Val extends TeamMembersResponse>
    implements $TeamMembersResponseCopyWith<$Res> {
  _$TeamMembersResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamMembersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? members = null}) {
    return _then(
      _value.copyWith(
            members: null == members
                ? _value.members
                : members // ignore: cast_nullable_to_non_nullable
                      as List<TeamMemberModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeamMembersResponseImplCopyWith<$Res>
    implements $TeamMembersResponseCopyWith<$Res> {
  factory _$$TeamMembersResponseImplCopyWith(
    _$TeamMembersResponseImpl value,
    $Res Function(_$TeamMembersResponseImpl) then,
  ) = __$$TeamMembersResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TeamMemberModel> members});
}

/// @nodoc
class __$$TeamMembersResponseImplCopyWithImpl<$Res>
    extends _$TeamMembersResponseCopyWithImpl<$Res, _$TeamMembersResponseImpl>
    implements _$$TeamMembersResponseImplCopyWith<$Res> {
  __$$TeamMembersResponseImplCopyWithImpl(
    _$TeamMembersResponseImpl _value,
    $Res Function(_$TeamMembersResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamMembersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? members = null}) {
    return _then(
      _$TeamMembersResponseImpl(
        members: null == members
            ? _value._members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<TeamMemberModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamMembersResponseImpl implements _TeamMembersResponse {
  const _$TeamMembersResponseImpl({
    required final List<TeamMemberModel> members,
  }) : _members = members;

  factory _$TeamMembersResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamMembersResponseImplFromJson(json);

  final List<TeamMemberModel> _members;
  @override
  List<TeamMemberModel> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  String toString() {
    return 'TeamMembersResponse(members: $members)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamMembersResponseImpl &&
            const DeepCollectionEquality().equals(other._members, _members));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_members));

  /// Create a copy of TeamMembersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamMembersResponseImplCopyWith<_$TeamMembersResponseImpl> get copyWith =>
      __$$TeamMembersResponseImplCopyWithImpl<_$TeamMembersResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamMembersResponseImplToJson(this);
  }
}

abstract class _TeamMembersResponse implements TeamMembersResponse {
  const factory _TeamMembersResponse({
    required final List<TeamMemberModel> members,
  }) = _$TeamMembersResponseImpl;

  factory _TeamMembersResponse.fromJson(Map<String, dynamic> json) =
      _$TeamMembersResponseImpl.fromJson;

  @override
  List<TeamMemberModel> get members;

  /// Create a copy of TeamMembersResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamMembersResponseImplCopyWith<_$TeamMembersResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamInvitationsResponse _$TeamInvitationsResponseFromJson(
  Map<String, dynamic> json,
) {
  return _TeamInvitationsResponse.fromJson(json);
}

/// @nodoc
mixin _$TeamInvitationsResponse {
  List<TeamInvitationModel> get invitations =>
      throw _privateConstructorUsedError;

  /// Serializes this TeamInvitationsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamInvitationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamInvitationsResponseCopyWith<TeamInvitationsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamInvitationsResponseCopyWith<$Res> {
  factory $TeamInvitationsResponseCopyWith(
    TeamInvitationsResponse value,
    $Res Function(TeamInvitationsResponse) then,
  ) = _$TeamInvitationsResponseCopyWithImpl<$Res, TeamInvitationsResponse>;
  @useResult
  $Res call({List<TeamInvitationModel> invitations});
}

/// @nodoc
class _$TeamInvitationsResponseCopyWithImpl<
  $Res,
  $Val extends TeamInvitationsResponse
>
    implements $TeamInvitationsResponseCopyWith<$Res> {
  _$TeamInvitationsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamInvitationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? invitations = null}) {
    return _then(
      _value.copyWith(
            invitations: null == invitations
                ? _value.invitations
                : invitations // ignore: cast_nullable_to_non_nullable
                      as List<TeamInvitationModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeamInvitationsResponseImplCopyWith<$Res>
    implements $TeamInvitationsResponseCopyWith<$Res> {
  factory _$$TeamInvitationsResponseImplCopyWith(
    _$TeamInvitationsResponseImpl value,
    $Res Function(_$TeamInvitationsResponseImpl) then,
  ) = __$$TeamInvitationsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TeamInvitationModel> invitations});
}

/// @nodoc
class __$$TeamInvitationsResponseImplCopyWithImpl<$Res>
    extends
        _$TeamInvitationsResponseCopyWithImpl<
          $Res,
          _$TeamInvitationsResponseImpl
        >
    implements _$$TeamInvitationsResponseImplCopyWith<$Res> {
  __$$TeamInvitationsResponseImplCopyWithImpl(
    _$TeamInvitationsResponseImpl _value,
    $Res Function(_$TeamInvitationsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamInvitationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? invitations = null}) {
    return _then(
      _$TeamInvitationsResponseImpl(
        invitations: null == invitations
            ? _value._invitations
            : invitations // ignore: cast_nullable_to_non_nullable
                  as List<TeamInvitationModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamInvitationsResponseImpl implements _TeamInvitationsResponse {
  const _$TeamInvitationsResponseImpl({
    required final List<TeamInvitationModel> invitations,
  }) : _invitations = invitations;

  factory _$TeamInvitationsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamInvitationsResponseImplFromJson(json);

  final List<TeamInvitationModel> _invitations;
  @override
  List<TeamInvitationModel> get invitations {
    if (_invitations is EqualUnmodifiableListView) return _invitations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_invitations);
  }

  @override
  String toString() {
    return 'TeamInvitationsResponse(invitations: $invitations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamInvitationsResponseImpl &&
            const DeepCollectionEquality().equals(
              other._invitations,
              _invitations,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_invitations),
  );

  /// Create a copy of TeamInvitationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamInvitationsResponseImplCopyWith<_$TeamInvitationsResponseImpl>
  get copyWith =>
      __$$TeamInvitationsResponseImplCopyWithImpl<
        _$TeamInvitationsResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamInvitationsResponseImplToJson(this);
  }
}

abstract class _TeamInvitationsResponse implements TeamInvitationsResponse {
  const factory _TeamInvitationsResponse({
    required final List<TeamInvitationModel> invitations,
  }) = _$TeamInvitationsResponseImpl;

  factory _TeamInvitationsResponse.fromJson(Map<String, dynamic> json) =
      _$TeamInvitationsResponseImpl.fromJson;

  @override
  List<TeamInvitationModel> get invitations;

  /// Create a copy of TeamInvitationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamInvitationsResponseImplCopyWith<_$TeamInvitationsResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

InvitationResponse _$InvitationResponseFromJson(Map<String, dynamic> json) {
  return _InvitationResponse.fromJson(json);
}

/// @nodoc
mixin _$InvitationResponse {
  TeamInvitationModel get invitation => throw _privateConstructorUsedError;

  /// Serializes this InvitationResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InvitationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvitationResponseCopyWith<InvitationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvitationResponseCopyWith<$Res> {
  factory $InvitationResponseCopyWith(
    InvitationResponse value,
    $Res Function(InvitationResponse) then,
  ) = _$InvitationResponseCopyWithImpl<$Res, InvitationResponse>;
  @useResult
  $Res call({TeamInvitationModel invitation});

  $TeamInvitationModelCopyWith<$Res> get invitation;
}

/// @nodoc
class _$InvitationResponseCopyWithImpl<$Res, $Val extends InvitationResponse>
    implements $InvitationResponseCopyWith<$Res> {
  _$InvitationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InvitationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? invitation = null}) {
    return _then(
      _value.copyWith(
            invitation: null == invitation
                ? _value.invitation
                : invitation // ignore: cast_nullable_to_non_nullable
                      as TeamInvitationModel,
          )
          as $Val,
    );
  }

  /// Create a copy of InvitationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamInvitationModelCopyWith<$Res> get invitation {
    return $TeamInvitationModelCopyWith<$Res>(_value.invitation, (value) {
      return _then(_value.copyWith(invitation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InvitationResponseImplCopyWith<$Res>
    implements $InvitationResponseCopyWith<$Res> {
  factory _$$InvitationResponseImplCopyWith(
    _$InvitationResponseImpl value,
    $Res Function(_$InvitationResponseImpl) then,
  ) = __$$InvitationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TeamInvitationModel invitation});

  @override
  $TeamInvitationModelCopyWith<$Res> get invitation;
}

/// @nodoc
class __$$InvitationResponseImplCopyWithImpl<$Res>
    extends _$InvitationResponseCopyWithImpl<$Res, _$InvitationResponseImpl>
    implements _$$InvitationResponseImplCopyWith<$Res> {
  __$$InvitationResponseImplCopyWithImpl(
    _$InvitationResponseImpl _value,
    $Res Function(_$InvitationResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InvitationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? invitation = null}) {
    return _then(
      _$InvitationResponseImpl(
        invitation: null == invitation
            ? _value.invitation
            : invitation // ignore: cast_nullable_to_non_nullable
                  as TeamInvitationModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InvitationResponseImpl implements _InvitationResponse {
  const _$InvitationResponseImpl({required this.invitation});

  factory _$InvitationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvitationResponseImplFromJson(json);

  @override
  final TeamInvitationModel invitation;

  @override
  String toString() {
    return 'InvitationResponse(invitation: $invitation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvitationResponseImpl &&
            (identical(other.invitation, invitation) ||
                other.invitation == invitation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, invitation);

  /// Create a copy of InvitationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvitationResponseImplCopyWith<_$InvitationResponseImpl> get copyWith =>
      __$$InvitationResponseImplCopyWithImpl<_$InvitationResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InvitationResponseImplToJson(this);
  }
}

abstract class _InvitationResponse implements InvitationResponse {
  const factory _InvitationResponse({
    required final TeamInvitationModel invitation,
  }) = _$InvitationResponseImpl;

  factory _InvitationResponse.fromJson(Map<String, dynamic> json) =
      _$InvitationResponseImpl.fromJson;

  @override
  TeamInvitationModel get invitation;

  /// Create a copy of InvitationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvitationResponseImplCopyWith<_$InvitationResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateTeamRequest _$CreateTeamRequestFromJson(Map<String, dynamic> json) {
  return _CreateTeamRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateTeamRequest {
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this CreateTeamRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateTeamRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateTeamRequestCopyWith<CreateTeamRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateTeamRequestCopyWith<$Res> {
  factory $CreateTeamRequestCopyWith(
    CreateTeamRequest value,
    $Res Function(CreateTeamRequest) then,
  ) = _$CreateTeamRequestCopyWithImpl<$Res, CreateTeamRequest>;
  @useResult
  $Res call({String name, String? description});
}

/// @nodoc
class _$CreateTeamRequestCopyWithImpl<$Res, $Val extends CreateTeamRequest>
    implements $CreateTeamRequestCopyWith<$Res> {
  _$CreateTeamRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateTeamRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? description = freezed}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateTeamRequestImplCopyWith<$Res>
    implements $CreateTeamRequestCopyWith<$Res> {
  factory _$$CreateTeamRequestImplCopyWith(
    _$CreateTeamRequestImpl value,
    $Res Function(_$CreateTeamRequestImpl) then,
  ) = __$$CreateTeamRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String? description});
}

/// @nodoc
class __$$CreateTeamRequestImplCopyWithImpl<$Res>
    extends _$CreateTeamRequestCopyWithImpl<$Res, _$CreateTeamRequestImpl>
    implements _$$CreateTeamRequestImplCopyWith<$Res> {
  __$$CreateTeamRequestImplCopyWithImpl(
    _$CreateTeamRequestImpl _value,
    $Res Function(_$CreateTeamRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateTeamRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? description = freezed}) {
    return _then(
      _$CreateTeamRequestImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateTeamRequestImpl implements _CreateTeamRequest {
  const _$CreateTeamRequestImpl({required this.name, this.description});

  factory _$CreateTeamRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateTeamRequestImplFromJson(json);

  @override
  final String name;
  @override
  final String? description;

  @override
  String toString() {
    return 'CreateTeamRequest(name: $name, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateTeamRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, description);

  /// Create a copy of CreateTeamRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateTeamRequestImplCopyWith<_$CreateTeamRequestImpl> get copyWith =>
      __$$CreateTeamRequestImplCopyWithImpl<_$CreateTeamRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateTeamRequestImplToJson(this);
  }
}

abstract class _CreateTeamRequest implements CreateTeamRequest {
  const factory _CreateTeamRequest({
    required final String name,
    final String? description,
  }) = _$CreateTeamRequestImpl;

  factory _CreateTeamRequest.fromJson(Map<String, dynamic> json) =
      _$CreateTeamRequestImpl.fromJson;

  @override
  String get name;
  @override
  String? get description;

  /// Create a copy of CreateTeamRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateTeamRequestImplCopyWith<_$CreateTeamRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateTeamRequest _$UpdateTeamRequestFromJson(Map<String, dynamic> json) {
  return _UpdateTeamRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateTeamRequest {
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this UpdateTeamRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateTeamRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateTeamRequestCopyWith<UpdateTeamRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateTeamRequestCopyWith<$Res> {
  factory $UpdateTeamRequestCopyWith(
    UpdateTeamRequest value,
    $Res Function(UpdateTeamRequest) then,
  ) = _$UpdateTeamRequestCopyWithImpl<$Res, UpdateTeamRequest>;
  @useResult
  $Res call({String? name, String? description});
}

/// @nodoc
class _$UpdateTeamRequestCopyWithImpl<$Res, $Val extends UpdateTeamRequest>
    implements $UpdateTeamRequestCopyWith<$Res> {
  _$UpdateTeamRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateTeamRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = freezed, Object? description = freezed}) {
    return _then(
      _value.copyWith(
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateTeamRequestImplCopyWith<$Res>
    implements $UpdateTeamRequestCopyWith<$Res> {
  factory _$$UpdateTeamRequestImplCopyWith(
    _$UpdateTeamRequestImpl value,
    $Res Function(_$UpdateTeamRequestImpl) then,
  ) = __$$UpdateTeamRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, String? description});
}

/// @nodoc
class __$$UpdateTeamRequestImplCopyWithImpl<$Res>
    extends _$UpdateTeamRequestCopyWithImpl<$Res, _$UpdateTeamRequestImpl>
    implements _$$UpdateTeamRequestImplCopyWith<$Res> {
  __$$UpdateTeamRequestImplCopyWithImpl(
    _$UpdateTeamRequestImpl _value,
    $Res Function(_$UpdateTeamRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateTeamRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = freezed, Object? description = freezed}) {
    return _then(
      _$UpdateTeamRequestImpl(
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateTeamRequestImpl implements _UpdateTeamRequest {
  const _$UpdateTeamRequestImpl({this.name, this.description});

  factory _$UpdateTeamRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateTeamRequestImplFromJson(json);

  @override
  final String? name;
  @override
  final String? description;

  @override
  String toString() {
    return 'UpdateTeamRequest(name: $name, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateTeamRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, description);

  /// Create a copy of UpdateTeamRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateTeamRequestImplCopyWith<_$UpdateTeamRequestImpl> get copyWith =>
      __$$UpdateTeamRequestImplCopyWithImpl<_$UpdateTeamRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateTeamRequestImplToJson(this);
  }
}

abstract class _UpdateTeamRequest implements UpdateTeamRequest {
  const factory _UpdateTeamRequest({
    final String? name,
    final String? description,
  }) = _$UpdateTeamRequestImpl;

  factory _UpdateTeamRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateTeamRequestImpl.fromJson;

  @override
  String? get name;
  @override
  String? get description;

  /// Create a copy of UpdateTeamRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateTeamRequestImplCopyWith<_$UpdateTeamRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InviteMemberRequest _$InviteMemberRequestFromJson(Map<String, dynamic> json) {
  return _InviteMemberRequest.fromJson(json);
}

/// @nodoc
mixin _$InviteMemberRequest {
  String get email => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;

  /// Serializes this InviteMemberRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InviteMemberRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InviteMemberRequestCopyWith<InviteMemberRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InviteMemberRequestCopyWith<$Res> {
  factory $InviteMemberRequestCopyWith(
    InviteMemberRequest value,
    $Res Function(InviteMemberRequest) then,
  ) = _$InviteMemberRequestCopyWithImpl<$Res, InviteMemberRequest>;
  @useResult
  $Res call({String email, String role});
}

/// @nodoc
class _$InviteMemberRequestCopyWithImpl<$Res, $Val extends InviteMemberRequest>
    implements $InviteMemberRequestCopyWith<$Res> {
  _$InviteMemberRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InviteMemberRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? role = null}) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InviteMemberRequestImplCopyWith<$Res>
    implements $InviteMemberRequestCopyWith<$Res> {
  factory _$$InviteMemberRequestImplCopyWith(
    _$InviteMemberRequestImpl value,
    $Res Function(_$InviteMemberRequestImpl) then,
  ) = __$$InviteMemberRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String role});
}

/// @nodoc
class __$$InviteMemberRequestImplCopyWithImpl<$Res>
    extends _$InviteMemberRequestCopyWithImpl<$Res, _$InviteMemberRequestImpl>
    implements _$$InviteMemberRequestImplCopyWith<$Res> {
  __$$InviteMemberRequestImplCopyWithImpl(
    _$InviteMemberRequestImpl _value,
    $Res Function(_$InviteMemberRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InviteMemberRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? role = null}) {
    return _then(
      _$InviteMemberRequestImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InviteMemberRequestImpl implements _InviteMemberRequest {
  const _$InviteMemberRequestImpl({required this.email, required this.role});

  factory _$InviteMemberRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$InviteMemberRequestImplFromJson(json);

  @override
  final String email;
  @override
  final String role;

  @override
  String toString() {
    return 'InviteMemberRequest(email: $email, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InviteMemberRequestImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, role);

  /// Create a copy of InviteMemberRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InviteMemberRequestImplCopyWith<_$InviteMemberRequestImpl> get copyWith =>
      __$$InviteMemberRequestImplCopyWithImpl<_$InviteMemberRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InviteMemberRequestImplToJson(this);
  }
}

abstract class _InviteMemberRequest implements InviteMemberRequest {
  const factory _InviteMemberRequest({
    required final String email,
    required final String role,
  }) = _$InviteMemberRequestImpl;

  factory _InviteMemberRequest.fromJson(Map<String, dynamic> json) =
      _$InviteMemberRequestImpl.fromJson;

  @override
  String get email;
  @override
  String get role;

  /// Create a copy of InviteMemberRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InviteMemberRequestImplCopyWith<_$InviteMemberRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateMemberRoleRequest _$UpdateMemberRoleRequestFromJson(
  Map<String, dynamic> json,
) {
  return _UpdateMemberRoleRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateMemberRoleRequest {
  String get role => throw _privateConstructorUsedError;

  /// Serializes this UpdateMemberRoleRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateMemberRoleRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateMemberRoleRequestCopyWith<UpdateMemberRoleRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateMemberRoleRequestCopyWith<$Res> {
  factory $UpdateMemberRoleRequestCopyWith(
    UpdateMemberRoleRequest value,
    $Res Function(UpdateMemberRoleRequest) then,
  ) = _$UpdateMemberRoleRequestCopyWithImpl<$Res, UpdateMemberRoleRequest>;
  @useResult
  $Res call({String role});
}

/// @nodoc
class _$UpdateMemberRoleRequestCopyWithImpl<
  $Res,
  $Val extends UpdateMemberRoleRequest
>
    implements $UpdateMemberRoleRequestCopyWith<$Res> {
  _$UpdateMemberRoleRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateMemberRoleRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? role = null}) {
    return _then(
      _value.copyWith(
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateMemberRoleRequestImplCopyWith<$Res>
    implements $UpdateMemberRoleRequestCopyWith<$Res> {
  factory _$$UpdateMemberRoleRequestImplCopyWith(
    _$UpdateMemberRoleRequestImpl value,
    $Res Function(_$UpdateMemberRoleRequestImpl) then,
  ) = __$$UpdateMemberRoleRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String role});
}

/// @nodoc
class __$$UpdateMemberRoleRequestImplCopyWithImpl<$Res>
    extends
        _$UpdateMemberRoleRequestCopyWithImpl<
          $Res,
          _$UpdateMemberRoleRequestImpl
        >
    implements _$$UpdateMemberRoleRequestImplCopyWith<$Res> {
  __$$UpdateMemberRoleRequestImplCopyWithImpl(
    _$UpdateMemberRoleRequestImpl _value,
    $Res Function(_$UpdateMemberRoleRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateMemberRoleRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? role = null}) {
    return _then(
      _$UpdateMemberRoleRequestImpl(
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateMemberRoleRequestImpl implements _UpdateMemberRoleRequest {
  const _$UpdateMemberRoleRequestImpl({required this.role});

  factory _$UpdateMemberRoleRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateMemberRoleRequestImplFromJson(json);

  @override
  final String role;

  @override
  String toString() {
    return 'UpdateMemberRoleRequest(role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateMemberRoleRequestImpl &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, role);

  /// Create a copy of UpdateMemberRoleRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateMemberRoleRequestImplCopyWith<_$UpdateMemberRoleRequestImpl>
  get copyWith =>
      __$$UpdateMemberRoleRequestImplCopyWithImpl<
        _$UpdateMemberRoleRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateMemberRoleRequestImplToJson(this);
  }
}

abstract class _UpdateMemberRoleRequest implements UpdateMemberRoleRequest {
  const factory _UpdateMemberRoleRequest({required final String role}) =
      _$UpdateMemberRoleRequestImpl;

  factory _UpdateMemberRoleRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateMemberRoleRequestImpl.fromJson;

  @override
  String get role;

  /// Create a copy of UpdateMemberRoleRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateMemberRoleRequestImplCopyWith<_$UpdateMemberRoleRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

TransferOwnershipRequest _$TransferOwnershipRequestFromJson(
  Map<String, dynamic> json,
) {
  return _TransferOwnershipRequest.fromJson(json);
}

/// @nodoc
mixin _$TransferOwnershipRequest {
  @JsonKey(name: 'user_id')
  int get userId => throw _privateConstructorUsedError;

  /// Serializes this TransferOwnershipRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferOwnershipRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferOwnershipRequestCopyWith<TransferOwnershipRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferOwnershipRequestCopyWith<$Res> {
  factory $TransferOwnershipRequestCopyWith(
    TransferOwnershipRequest value,
    $Res Function(TransferOwnershipRequest) then,
  ) = _$TransferOwnershipRequestCopyWithImpl<$Res, TransferOwnershipRequest>;
  @useResult
  $Res call({@JsonKey(name: 'user_id') int userId});
}

/// @nodoc
class _$TransferOwnershipRequestCopyWithImpl<
  $Res,
  $Val extends TransferOwnershipRequest
>
    implements $TransferOwnershipRequestCopyWith<$Res> {
  _$TransferOwnershipRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferOwnershipRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null}) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransferOwnershipRequestImplCopyWith<$Res>
    implements $TransferOwnershipRequestCopyWith<$Res> {
  factory _$$TransferOwnershipRequestImplCopyWith(
    _$TransferOwnershipRequestImpl value,
    $Res Function(_$TransferOwnershipRequestImpl) then,
  ) = __$$TransferOwnershipRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'user_id') int userId});
}

/// @nodoc
class __$$TransferOwnershipRequestImplCopyWithImpl<$Res>
    extends
        _$TransferOwnershipRequestCopyWithImpl<
          $Res,
          _$TransferOwnershipRequestImpl
        >
    implements _$$TransferOwnershipRequestImplCopyWith<$Res> {
  __$$TransferOwnershipRequestImplCopyWithImpl(
    _$TransferOwnershipRequestImpl _value,
    $Res Function(_$TransferOwnershipRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransferOwnershipRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null}) {
    return _then(
      _$TransferOwnershipRequestImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferOwnershipRequestImpl implements _TransferOwnershipRequest {
  const _$TransferOwnershipRequestImpl({
    @JsonKey(name: 'user_id') required this.userId,
  });

  factory _$TransferOwnershipRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferOwnershipRequestImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final int userId;

  @override
  String toString() {
    return 'TransferOwnershipRequest(userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferOwnershipRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId);

  /// Create a copy of TransferOwnershipRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferOwnershipRequestImplCopyWith<_$TransferOwnershipRequestImpl>
  get copyWith =>
      __$$TransferOwnershipRequestImplCopyWithImpl<
        _$TransferOwnershipRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferOwnershipRequestImplToJson(this);
  }
}

abstract class _TransferOwnershipRequest implements TransferOwnershipRequest {
  const factory _TransferOwnershipRequest({
    @JsonKey(name: 'user_id') required final int userId,
  }) = _$TransferOwnershipRequestImpl;

  factory _TransferOwnershipRequest.fromJson(Map<String, dynamic> json) =
      _$TransferOwnershipRequestImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  int get userId;

  /// Create a copy of TransferOwnershipRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferOwnershipRequestImplCopyWith<_$TransferOwnershipRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CurrentTeamResponse _$CurrentTeamResponseFromJson(Map<String, dynamic> json) {
  return _CurrentTeamResponse.fromJson(json);
}

/// @nodoc
mixin _$CurrentTeamResponse {
  @JsonKey(name: 'current_team')
  TeamModel get currentTeam => throw _privateConstructorUsedError;

  /// Serializes this CurrentTeamResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CurrentTeamResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrentTeamResponseCopyWith<CurrentTeamResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentTeamResponseCopyWith<$Res> {
  factory $CurrentTeamResponseCopyWith(
    CurrentTeamResponse value,
    $Res Function(CurrentTeamResponse) then,
  ) = _$CurrentTeamResponseCopyWithImpl<$Res, CurrentTeamResponse>;
  @useResult
  $Res call({@JsonKey(name: 'current_team') TeamModel currentTeam});

  $TeamModelCopyWith<$Res> get currentTeam;
}

/// @nodoc
class _$CurrentTeamResponseCopyWithImpl<$Res, $Val extends CurrentTeamResponse>
    implements $CurrentTeamResponseCopyWith<$Res> {
  _$CurrentTeamResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrentTeamResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? currentTeam = null}) {
    return _then(
      _value.copyWith(
            currentTeam: null == currentTeam
                ? _value.currentTeam
                : currentTeam // ignore: cast_nullable_to_non_nullable
                      as TeamModel,
          )
          as $Val,
    );
  }

  /// Create a copy of CurrentTeamResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamModelCopyWith<$Res> get currentTeam {
    return $TeamModelCopyWith<$Res>(_value.currentTeam, (value) {
      return _then(_value.copyWith(currentTeam: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CurrentTeamResponseImplCopyWith<$Res>
    implements $CurrentTeamResponseCopyWith<$Res> {
  factory _$$CurrentTeamResponseImplCopyWith(
    _$CurrentTeamResponseImpl value,
    $Res Function(_$CurrentTeamResponseImpl) then,
  ) = __$$CurrentTeamResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'current_team') TeamModel currentTeam});

  @override
  $TeamModelCopyWith<$Res> get currentTeam;
}

/// @nodoc
class __$$CurrentTeamResponseImplCopyWithImpl<$Res>
    extends _$CurrentTeamResponseCopyWithImpl<$Res, _$CurrentTeamResponseImpl>
    implements _$$CurrentTeamResponseImplCopyWith<$Res> {
  __$$CurrentTeamResponseImplCopyWithImpl(
    _$CurrentTeamResponseImpl _value,
    $Res Function(_$CurrentTeamResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CurrentTeamResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? currentTeam = null}) {
    return _then(
      _$CurrentTeamResponseImpl(
        currentTeam: null == currentTeam
            ? _value.currentTeam
            : currentTeam // ignore: cast_nullable_to_non_nullable
                  as TeamModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrentTeamResponseImpl implements _CurrentTeamResponse {
  const _$CurrentTeamResponseImpl({
    @JsonKey(name: 'current_team') required this.currentTeam,
  });

  factory _$CurrentTeamResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrentTeamResponseImplFromJson(json);

  @override
  @JsonKey(name: 'current_team')
  final TeamModel currentTeam;

  @override
  String toString() {
    return 'CurrentTeamResponse(currentTeam: $currentTeam)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrentTeamResponseImpl &&
            (identical(other.currentTeam, currentTeam) ||
                other.currentTeam == currentTeam));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currentTeam);

  /// Create a copy of CurrentTeamResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrentTeamResponseImplCopyWith<_$CurrentTeamResponseImpl> get copyWith =>
      __$$CurrentTeamResponseImplCopyWithImpl<_$CurrentTeamResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrentTeamResponseImplToJson(this);
  }
}

abstract class _CurrentTeamResponse implements CurrentTeamResponse {
  const factory _CurrentTeamResponse({
    @JsonKey(name: 'current_team') required final TeamModel currentTeam,
  }) = _$CurrentTeamResponseImpl;

  factory _CurrentTeamResponse.fromJson(Map<String, dynamic> json) =
      _$CurrentTeamResponseImpl.fromJson;

  @override
  @JsonKey(name: 'current_team')
  TeamModel get currentTeam;

  /// Create a copy of CurrentTeamResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrentTeamResponseImplCopyWith<_$CurrentTeamResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MemberResponse _$MemberResponseFromJson(Map<String, dynamic> json) {
  return _MemberResponse.fromJson(json);
}

/// @nodoc
mixin _$MemberResponse {
  TeamMemberModel get member => throw _privateConstructorUsedError;

  /// Serializes this MemberResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberResponseCopyWith<MemberResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberResponseCopyWith<$Res> {
  factory $MemberResponseCopyWith(
    MemberResponse value,
    $Res Function(MemberResponse) then,
  ) = _$MemberResponseCopyWithImpl<$Res, MemberResponse>;
  @useResult
  $Res call({TeamMemberModel member});

  $TeamMemberModelCopyWith<$Res> get member;
}

/// @nodoc
class _$MemberResponseCopyWithImpl<$Res, $Val extends MemberResponse>
    implements $MemberResponseCopyWith<$Res> {
  _$MemberResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? member = null}) {
    return _then(
      _value.copyWith(
            member: null == member
                ? _value.member
                : member // ignore: cast_nullable_to_non_nullable
                      as TeamMemberModel,
          )
          as $Val,
    );
  }

  /// Create a copy of MemberResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamMemberModelCopyWith<$Res> get member {
    return $TeamMemberModelCopyWith<$Res>(_value.member, (value) {
      return _then(_value.copyWith(member: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MemberResponseImplCopyWith<$Res>
    implements $MemberResponseCopyWith<$Res> {
  factory _$$MemberResponseImplCopyWith(
    _$MemberResponseImpl value,
    $Res Function(_$MemberResponseImpl) then,
  ) = __$$MemberResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TeamMemberModel member});

  @override
  $TeamMemberModelCopyWith<$Res> get member;
}

/// @nodoc
class __$$MemberResponseImplCopyWithImpl<$Res>
    extends _$MemberResponseCopyWithImpl<$Res, _$MemberResponseImpl>
    implements _$$MemberResponseImplCopyWith<$Res> {
  __$$MemberResponseImplCopyWithImpl(
    _$MemberResponseImpl _value,
    $Res Function(_$MemberResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemberResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? member = null}) {
    return _then(
      _$MemberResponseImpl(
        member: null == member
            ? _value.member
            : member // ignore: cast_nullable_to_non_nullable
                  as TeamMemberModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberResponseImpl implements _MemberResponse {
  const _$MemberResponseImpl({required this.member});

  factory _$MemberResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberResponseImplFromJson(json);

  @override
  final TeamMemberModel member;

  @override
  String toString() {
    return 'MemberResponse(member: $member)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberResponseImpl &&
            (identical(other.member, member) || other.member == member));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, member);

  /// Create a copy of MemberResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberResponseImplCopyWith<_$MemberResponseImpl> get copyWith =>
      __$$MemberResponseImplCopyWithImpl<_$MemberResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberResponseImplToJson(this);
  }
}

abstract class _MemberResponse implements MemberResponse {
  const factory _MemberResponse({required final TeamMemberModel member}) =
      _$MemberResponseImpl;

  factory _MemberResponse.fromJson(Map<String, dynamic> json) =
      _$MemberResponseImpl.fromJson;

  @override
  TeamMemberModel get member;

  /// Create a copy of MemberResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberResponseImplCopyWith<_$MemberResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
