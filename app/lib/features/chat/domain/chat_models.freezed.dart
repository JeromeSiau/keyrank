// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChatConversation _$ChatConversationFromJson(Map<String, dynamic> json) {
  return _ChatConversation.fromJson(json);
}

/// @nodoc
mixin _$ChatConversation {
  int get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  ChatApp? get app => throw _privateConstructorUsedError;
  List<ChatMessage> get messages => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ChatConversation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatConversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatConversationCopyWith<ChatConversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatConversationCopyWith<$Res> {
  factory $ChatConversationCopyWith(
    ChatConversation value,
    $Res Function(ChatConversation) then,
  ) = _$ChatConversationCopyWithImpl<$Res, ChatConversation>;
  @useResult
  $Res call({
    int id,
    String? title,
    ChatApp? app,
    List<ChatMessage> messages,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });

  $ChatAppCopyWith<$Res>? get app;
}

/// @nodoc
class _$ChatConversationCopyWithImpl<$Res, $Val extends ChatConversation>
    implements $ChatConversationCopyWith<$Res> {
  _$ChatConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatConversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? app = freezed,
    Object? messages = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            app: freezed == app
                ? _value.app
                : app // ignore: cast_nullable_to_non_nullable
                      as ChatApp?,
            messages: null == messages
                ? _value.messages
                : messages // ignore: cast_nullable_to_non_nullable
                      as List<ChatMessage>,
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

  /// Create a copy of ChatConversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatAppCopyWith<$Res>? get app {
    if (_value.app == null) {
      return null;
    }

    return $ChatAppCopyWith<$Res>(_value.app!, (value) {
      return _then(_value.copyWith(app: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatConversationImplCopyWith<$Res>
    implements $ChatConversationCopyWith<$Res> {
  factory _$$ChatConversationImplCopyWith(
    _$ChatConversationImpl value,
    $Res Function(_$ChatConversationImpl) then,
  ) = __$$ChatConversationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String? title,
    ChatApp? app,
    List<ChatMessage> messages,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });

  @override
  $ChatAppCopyWith<$Res>? get app;
}

/// @nodoc
class __$$ChatConversationImplCopyWithImpl<$Res>
    extends _$ChatConversationCopyWithImpl<$Res, _$ChatConversationImpl>
    implements _$$ChatConversationImplCopyWith<$Res> {
  __$$ChatConversationImplCopyWithImpl(
    _$ChatConversationImpl _value,
    $Res Function(_$ChatConversationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatConversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? app = freezed,
    Object? messages = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ChatConversationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        app: freezed == app
            ? _value.app
            : app // ignore: cast_nullable_to_non_nullable
                  as ChatApp?,
        messages: null == messages
            ? _value._messages
            : messages // ignore: cast_nullable_to_non_nullable
                  as List<ChatMessage>,
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
class _$ChatConversationImpl extends _ChatConversation {
  const _$ChatConversationImpl({
    required this.id,
    this.title,
    this.app,
    final List<ChatMessage> messages = const [],
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _messages = messages,
       super._();

  factory _$ChatConversationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatConversationImplFromJson(json);

  @override
  final int id;
  @override
  final String? title;
  @override
  final ChatApp? app;
  final List<ChatMessage> _messages;
  @override
  @JsonKey()
  List<ChatMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ChatConversation(id: $id, title: $title, app: $app, messages: $messages, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatConversationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.app, app) || other.app == app) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
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
    title,
    app,
    const DeepCollectionEquality().hash(_messages),
    createdAt,
    updatedAt,
  );

  /// Create a copy of ChatConversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatConversationImplCopyWith<_$ChatConversationImpl> get copyWith =>
      __$$ChatConversationImplCopyWithImpl<_$ChatConversationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatConversationImplToJson(this);
  }
}

abstract class _ChatConversation extends ChatConversation {
  const factory _ChatConversation({
    required final int id,
    final String? title,
    final ChatApp? app,
    final List<ChatMessage> messages,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$ChatConversationImpl;
  const _ChatConversation._() : super._();

  factory _ChatConversation.fromJson(Map<String, dynamic> json) =
      _$ChatConversationImpl.fromJson;

  @override
  int get id;
  @override
  String? get title;
  @override
  ChatApp? get app;
  @override
  List<ChatMessage> get messages;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of ChatConversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatConversationImplCopyWith<_$ChatConversationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  int get id => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_sources_used')
  List<String>? get dataSourcesUsed => throw _privateConstructorUsedError;
  List<ChatAction> get actions => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
    ChatMessage value,
    $Res Function(ChatMessage) then,
  ) = _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call({
    int id,
    String role,
    String content,
    @JsonKey(name: 'data_sources_used') List<String>? dataSourcesUsed,
    List<ChatAction> actions,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? dataSourcesUsed = freezed,
    Object? actions = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            dataSourcesUsed: freezed == dataSourcesUsed
                ? _value.dataSourcesUsed
                : dataSourcesUsed // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            actions: null == actions
                ? _value.actions
                : actions // ignore: cast_nullable_to_non_nullable
                      as List<ChatAction>,
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
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
    _$ChatMessageImpl value,
    $Res Function(_$ChatMessageImpl) then,
  ) = __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String role,
    String content,
    @JsonKey(name: 'data_sources_used') List<String>? dataSourcesUsed,
    List<ChatAction> actions,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
    _$ChatMessageImpl _value,
    $Res Function(_$ChatMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? dataSourcesUsed = freezed,
    Object? actions = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$ChatMessageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        dataSourcesUsed: freezed == dataSourcesUsed
            ? _value._dataSourcesUsed
            : dataSourcesUsed // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        actions: null == actions
            ? _value._actions
            : actions // ignore: cast_nullable_to_non_nullable
                  as List<ChatAction>,
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
class _$ChatMessageImpl extends _ChatMessage {
  const _$ChatMessageImpl({
    required this.id,
    required this.role,
    required this.content,
    @JsonKey(name: 'data_sources_used') final List<String>? dataSourcesUsed,
    final List<ChatAction> actions = const [],
    @JsonKey(name: 'created_at') required this.createdAt,
  }) : _dataSourcesUsed = dataSourcesUsed,
       _actions = actions,
       super._();

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  final int id;
  @override
  final String role;
  @override
  final String content;
  final List<String>? _dataSourcesUsed;
  @override
  @JsonKey(name: 'data_sources_used')
  List<String>? get dataSourcesUsed {
    final value = _dataSourcesUsed;
    if (value == null) return null;
    if (_dataSourcesUsed is EqualUnmodifiableListView) return _dataSourcesUsed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ChatAction> _actions;
  @override
  @JsonKey()
  List<ChatAction> get actions {
    if (_actions is EqualUnmodifiableListView) return _actions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actions);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'ChatMessage(id: $id, role: $role, content: $content, dataSourcesUsed: $dataSourcesUsed, actions: $actions, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(
              other._dataSourcesUsed,
              _dataSourcesUsed,
            ) &&
            const DeepCollectionEquality().equals(other._actions, _actions) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    role,
    content,
    const DeepCollectionEquality().hash(_dataSourcesUsed),
    const DeepCollectionEquality().hash(_actions),
    createdAt,
  );

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(this);
  }
}

abstract class _ChatMessage extends ChatMessage {
  const factory _ChatMessage({
    required final int id,
    required final String role,
    required final String content,
    @JsonKey(name: 'data_sources_used') final List<String>? dataSourcesUsed,
    final List<ChatAction> actions,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$ChatMessageImpl;
  const _ChatMessage._() : super._();

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  int get id;
  @override
  String get role;
  @override
  String get content;
  @override
  @JsonKey(name: 'data_sources_used')
  List<String>? get dataSourcesUsed;
  @override
  List<ChatAction> get actions;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatApp _$ChatAppFromJson(Map<String, dynamic> json) {
  return _ChatApp.fromJson(json);
}

/// @nodoc
mixin _$ChatApp {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;

  /// Serializes this ChatApp to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatApp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatAppCopyWith<ChatApp> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatAppCopyWith<$Res> {
  factory $ChatAppCopyWith(ChatApp value, $Res Function(ChatApp) then) =
      _$ChatAppCopyWithImpl<$Res, ChatApp>;
  @useResult
  $Res call({
    int id,
    String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String platform,
  });
}

/// @nodoc
class _$ChatAppCopyWithImpl<$Res, $Val extends ChatApp>
    implements $ChatAppCopyWith<$Res> {
  _$ChatAppCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatApp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
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
abstract class _$$ChatAppImplCopyWith<$Res> implements $ChatAppCopyWith<$Res> {
  factory _$$ChatAppImplCopyWith(
    _$ChatAppImpl value,
    $Res Function(_$ChatAppImpl) then,
  ) = __$$ChatAppImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String platform,
  });
}

/// @nodoc
class __$$ChatAppImplCopyWithImpl<$Res>
    extends _$ChatAppCopyWithImpl<$Res, _$ChatAppImpl>
    implements _$$ChatAppImplCopyWith<$Res> {
  __$$ChatAppImplCopyWithImpl(
    _$ChatAppImpl _value,
    $Res Function(_$ChatAppImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatApp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iconUrl = freezed,
    Object? platform = null,
  }) {
    return _then(
      _$ChatAppImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$ChatAppImpl implements _ChatApp {
  const _$ChatAppImpl({
    required this.id,
    required this.name,
    @JsonKey(name: 'icon_url') this.iconUrl,
    required this.platform,
  });

  factory _$ChatAppImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatAppImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  final String platform;

  @override
  String toString() {
    return 'ChatApp(id: $id, name: $name, iconUrl: $iconUrl, platform: $platform)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatAppImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.platform, platform) ||
                other.platform == platform));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, iconUrl, platform);

  /// Create a copy of ChatApp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatAppImplCopyWith<_$ChatAppImpl> get copyWith =>
      __$$ChatAppImplCopyWithImpl<_$ChatAppImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatAppImplToJson(this);
  }
}

abstract class _ChatApp implements ChatApp {
  const factory _ChatApp({
    required final int id,
    required final String name,
    @JsonKey(name: 'icon_url') final String? iconUrl,
    required final String platform,
  }) = _$ChatAppImpl;

  factory _ChatApp.fromJson(Map<String, dynamic> json) = _$ChatAppImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  String get platform;

  /// Create a copy of ChatApp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatAppImplCopyWith<_$ChatAppImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatQuota _$ChatQuotaFromJson(Map<String, dynamic> json) {
  return _ChatQuota.fromJson(json);
}

/// @nodoc
mixin _$ChatQuota {
  int get used => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get remaining => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_quota')
  bool get hasQuota => throw _privateConstructorUsedError;

  /// Serializes this ChatQuota to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatQuota
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatQuotaCopyWith<ChatQuota> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatQuotaCopyWith<$Res> {
  factory $ChatQuotaCopyWith(ChatQuota value, $Res Function(ChatQuota) then) =
      _$ChatQuotaCopyWithImpl<$Res, ChatQuota>;
  @useResult
  $Res call({
    int used,
    int limit,
    int remaining,
    @JsonKey(name: 'has_quota') bool hasQuota,
  });
}

/// @nodoc
class _$ChatQuotaCopyWithImpl<$Res, $Val extends ChatQuota>
    implements $ChatQuotaCopyWith<$Res> {
  _$ChatQuotaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatQuota
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? used = null,
    Object? limit = null,
    Object? remaining = null,
    Object? hasQuota = null,
  }) {
    return _then(
      _value.copyWith(
            used: null == used
                ? _value.used
                : used // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            remaining: null == remaining
                ? _value.remaining
                : remaining // ignore: cast_nullable_to_non_nullable
                      as int,
            hasQuota: null == hasQuota
                ? _value.hasQuota
                : hasQuota // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatQuotaImplCopyWith<$Res>
    implements $ChatQuotaCopyWith<$Res> {
  factory _$$ChatQuotaImplCopyWith(
    _$ChatQuotaImpl value,
    $Res Function(_$ChatQuotaImpl) then,
  ) = __$$ChatQuotaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int used,
    int limit,
    int remaining,
    @JsonKey(name: 'has_quota') bool hasQuota,
  });
}

/// @nodoc
class __$$ChatQuotaImplCopyWithImpl<$Res>
    extends _$ChatQuotaCopyWithImpl<$Res, _$ChatQuotaImpl>
    implements _$$ChatQuotaImplCopyWith<$Res> {
  __$$ChatQuotaImplCopyWithImpl(
    _$ChatQuotaImpl _value,
    $Res Function(_$ChatQuotaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatQuota
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? used = null,
    Object? limit = null,
    Object? remaining = null,
    Object? hasQuota = null,
  }) {
    return _then(
      _$ChatQuotaImpl(
        used: null == used
            ? _value.used
            : used // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        remaining: null == remaining
            ? _value.remaining
            : remaining // ignore: cast_nullable_to_non_nullable
                  as int,
        hasQuota: null == hasQuota
            ? _value.hasQuota
            : hasQuota // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatQuotaImpl extends _ChatQuota {
  const _$ChatQuotaImpl({
    required this.used,
    required this.limit,
    required this.remaining,
    @JsonKey(name: 'has_quota') required this.hasQuota,
  }) : super._();

  factory _$ChatQuotaImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatQuotaImplFromJson(json);

  @override
  final int used;
  @override
  final int limit;
  @override
  final int remaining;
  @override
  @JsonKey(name: 'has_quota')
  final bool hasQuota;

  @override
  String toString() {
    return 'ChatQuota(used: $used, limit: $limit, remaining: $remaining, hasQuota: $hasQuota)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatQuotaImpl &&
            (identical(other.used, used) || other.used == used) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.remaining, remaining) ||
                other.remaining == remaining) &&
            (identical(other.hasQuota, hasQuota) ||
                other.hasQuota == hasQuota));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, used, limit, remaining, hasQuota);

  /// Create a copy of ChatQuota
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatQuotaImplCopyWith<_$ChatQuotaImpl> get copyWith =>
      __$$ChatQuotaImplCopyWithImpl<_$ChatQuotaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatQuotaImplToJson(this);
  }
}

abstract class _ChatQuota extends ChatQuota {
  const factory _ChatQuota({
    required final int used,
    required final int limit,
    required final int remaining,
    @JsonKey(name: 'has_quota') required final bool hasQuota,
  }) = _$ChatQuotaImpl;
  const _ChatQuota._() : super._();

  factory _ChatQuota.fromJson(Map<String, dynamic> json) =
      _$ChatQuotaImpl.fromJson;

  @override
  int get used;
  @override
  int get limit;
  @override
  int get remaining;
  @override
  @JsonKey(name: 'has_quota')
  bool get hasQuota;

  /// Create a copy of ChatQuota
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatQuotaImplCopyWith<_$ChatQuotaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuickAskResponse _$QuickAskResponseFromJson(Map<String, dynamic> json) {
  return _QuickAskResponse.fromJson(json);
}

/// @nodoc
mixin _$QuickAskResponse {
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_sources_used')
  List<String>? get dataSourcesUsed => throw _privateConstructorUsedError;
  @JsonKey(name: 'tokens_used')
  int? get tokensUsed => throw _privateConstructorUsedError;

  /// Serializes this QuickAskResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuickAskResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuickAskResponseCopyWith<QuickAskResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuickAskResponseCopyWith<$Res> {
  factory $QuickAskResponseCopyWith(
    QuickAskResponse value,
    $Res Function(QuickAskResponse) then,
  ) = _$QuickAskResponseCopyWithImpl<$Res, QuickAskResponse>;
  @useResult
  $Res call({
    String content,
    @JsonKey(name: 'data_sources_used') List<String>? dataSourcesUsed,
    @JsonKey(name: 'tokens_used') int? tokensUsed,
  });
}

/// @nodoc
class _$QuickAskResponseCopyWithImpl<$Res, $Val extends QuickAskResponse>
    implements $QuickAskResponseCopyWith<$Res> {
  _$QuickAskResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuickAskResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? dataSourcesUsed = freezed,
    Object? tokensUsed = freezed,
  }) {
    return _then(
      _value.copyWith(
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            dataSourcesUsed: freezed == dataSourcesUsed
                ? _value.dataSourcesUsed
                : dataSourcesUsed // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            tokensUsed: freezed == tokensUsed
                ? _value.tokensUsed
                : tokensUsed // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuickAskResponseImplCopyWith<$Res>
    implements $QuickAskResponseCopyWith<$Res> {
  factory _$$QuickAskResponseImplCopyWith(
    _$QuickAskResponseImpl value,
    $Res Function(_$QuickAskResponseImpl) then,
  ) = __$$QuickAskResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String content,
    @JsonKey(name: 'data_sources_used') List<String>? dataSourcesUsed,
    @JsonKey(name: 'tokens_used') int? tokensUsed,
  });
}

/// @nodoc
class __$$QuickAskResponseImplCopyWithImpl<$Res>
    extends _$QuickAskResponseCopyWithImpl<$Res, _$QuickAskResponseImpl>
    implements _$$QuickAskResponseImplCopyWith<$Res> {
  __$$QuickAskResponseImplCopyWithImpl(
    _$QuickAskResponseImpl _value,
    $Res Function(_$QuickAskResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuickAskResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? dataSourcesUsed = freezed,
    Object? tokensUsed = freezed,
  }) {
    return _then(
      _$QuickAskResponseImpl(
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        dataSourcesUsed: freezed == dataSourcesUsed
            ? _value._dataSourcesUsed
            : dataSourcesUsed // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        tokensUsed: freezed == tokensUsed
            ? _value.tokensUsed
            : tokensUsed // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuickAskResponseImpl implements _QuickAskResponse {
  const _$QuickAskResponseImpl({
    required this.content,
    @JsonKey(name: 'data_sources_used') final List<String>? dataSourcesUsed,
    @JsonKey(name: 'tokens_used') this.tokensUsed,
  }) : _dataSourcesUsed = dataSourcesUsed;

  factory _$QuickAskResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuickAskResponseImplFromJson(json);

  @override
  final String content;
  final List<String>? _dataSourcesUsed;
  @override
  @JsonKey(name: 'data_sources_used')
  List<String>? get dataSourcesUsed {
    final value = _dataSourcesUsed;
    if (value == null) return null;
    if (_dataSourcesUsed is EqualUnmodifiableListView) return _dataSourcesUsed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'tokens_used')
  final int? tokensUsed;

  @override
  String toString() {
    return 'QuickAskResponse(content: $content, dataSourcesUsed: $dataSourcesUsed, tokensUsed: $tokensUsed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuickAskResponseImpl &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(
              other._dataSourcesUsed,
              _dataSourcesUsed,
            ) &&
            (identical(other.tokensUsed, tokensUsed) ||
                other.tokensUsed == tokensUsed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    content,
    const DeepCollectionEquality().hash(_dataSourcesUsed),
    tokensUsed,
  );

  /// Create a copy of QuickAskResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuickAskResponseImplCopyWith<_$QuickAskResponseImpl> get copyWith =>
      __$$QuickAskResponseImplCopyWithImpl<_$QuickAskResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QuickAskResponseImplToJson(this);
  }
}

abstract class _QuickAskResponse implements QuickAskResponse {
  const factory _QuickAskResponse({
    required final String content,
    @JsonKey(name: 'data_sources_used') final List<String>? dataSourcesUsed,
    @JsonKey(name: 'tokens_used') final int? tokensUsed,
  }) = _$QuickAskResponseImpl;

  factory _QuickAskResponse.fromJson(Map<String, dynamic> json) =
      _$QuickAskResponseImpl.fromJson;

  @override
  String get content;
  @override
  @JsonKey(name: 'data_sources_used')
  List<String>? get dataSourcesUsed;
  @override
  @JsonKey(name: 'tokens_used')
  int? get tokensUsed;

  /// Create a copy of QuickAskResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuickAskResponseImplCopyWith<_$QuickAskResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SuggestedQuestions _$SuggestedQuestionsFromJson(Map<String, dynamic> json) {
  return _SuggestedQuestions.fromJson(json);
}

/// @nodoc
mixin _$SuggestedQuestions {
  String get category => throw _privateConstructorUsedError;
  List<String> get questions => throw _privateConstructorUsedError;

  /// Serializes this SuggestedQuestions to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SuggestedQuestions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SuggestedQuestionsCopyWith<SuggestedQuestions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestedQuestionsCopyWith<$Res> {
  factory $SuggestedQuestionsCopyWith(
    SuggestedQuestions value,
    $Res Function(SuggestedQuestions) then,
  ) = _$SuggestedQuestionsCopyWithImpl<$Res, SuggestedQuestions>;
  @useResult
  $Res call({String category, List<String> questions});
}

/// @nodoc
class _$SuggestedQuestionsCopyWithImpl<$Res, $Val extends SuggestedQuestions>
    implements $SuggestedQuestionsCopyWith<$Res> {
  _$SuggestedQuestionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SuggestedQuestions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? category = null, Object? questions = null}) {
    return _then(
      _value.copyWith(
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            questions: null == questions
                ? _value.questions
                : questions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SuggestedQuestionsImplCopyWith<$Res>
    implements $SuggestedQuestionsCopyWith<$Res> {
  factory _$$SuggestedQuestionsImplCopyWith(
    _$SuggestedQuestionsImpl value,
    $Res Function(_$SuggestedQuestionsImpl) then,
  ) = __$$SuggestedQuestionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String category, List<String> questions});
}

/// @nodoc
class __$$SuggestedQuestionsImplCopyWithImpl<$Res>
    extends _$SuggestedQuestionsCopyWithImpl<$Res, _$SuggestedQuestionsImpl>
    implements _$$SuggestedQuestionsImplCopyWith<$Res> {
  __$$SuggestedQuestionsImplCopyWithImpl(
    _$SuggestedQuestionsImpl _value,
    $Res Function(_$SuggestedQuestionsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SuggestedQuestions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? category = null, Object? questions = null}) {
    return _then(
      _$SuggestedQuestionsImpl(
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        questions: null == questions
            ? _value._questions
            : questions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SuggestedQuestionsImpl implements _SuggestedQuestions {
  const _$SuggestedQuestionsImpl({
    required this.category,
    required final List<String> questions,
  }) : _questions = questions;

  factory _$SuggestedQuestionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuggestedQuestionsImplFromJson(json);

  @override
  final String category;
  final List<String> _questions;
  @override
  List<String> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  String toString() {
    return 'SuggestedQuestions(category: $category, questions: $questions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestedQuestionsImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(
              other._questions,
              _questions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    category,
    const DeepCollectionEquality().hash(_questions),
  );

  /// Create a copy of SuggestedQuestions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestedQuestionsImplCopyWith<_$SuggestedQuestionsImpl> get copyWith =>
      __$$SuggestedQuestionsImplCopyWithImpl<_$SuggestedQuestionsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SuggestedQuestionsImplToJson(this);
  }
}

abstract class _SuggestedQuestions implements SuggestedQuestions {
  const factory _SuggestedQuestions({
    required final String category,
    required final List<String> questions,
  }) = _$SuggestedQuestionsImpl;

  factory _SuggestedQuestions.fromJson(Map<String, dynamic> json) =
      _$SuggestedQuestionsImpl.fromJson;

  @override
  String get category;
  @override
  List<String> get questions;

  /// Create a copy of SuggestedQuestions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuggestedQuestionsImplCopyWith<_$SuggestedQuestionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
