// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'actionable_insight_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActionableInsight _$ActionableInsightFromJson(Map<String, dynamic> json) {
  return _ActionableInsight.fromJson(json);
}

/// @nodoc
mixin _$ActionableInsight {
  int get id => throw _privateConstructorUsedError;
  InsightType get type => throw _privateConstructorUsedError;
  InsightPriority get priority => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_text')
  String? get actionText => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_url')
  String? get actionUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_refs')
  Map<String, dynamic>? get dataRefs => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_dismissed')
  bool get isDismissed => throw _privateConstructorUsedError;
  @JsonKey(name: 'generated_at')
  DateTime get generatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  InsightApp? get app => throw _privateConstructorUsedError;

  /// Serializes this ActionableInsight to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActionableInsight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActionableInsightCopyWith<ActionableInsight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionableInsightCopyWith<$Res> {
  factory $ActionableInsightCopyWith(
    ActionableInsight value,
    $Res Function(ActionableInsight) then,
  ) = _$ActionableInsightCopyWithImpl<$Res, ActionableInsight>;
  @useResult
  $Res call({
    int id,
    InsightType type,
    InsightPriority priority,
    String title,
    String description,
    @JsonKey(name: 'action_text') String? actionText,
    @JsonKey(name: 'action_url') String? actionUrl,
    @JsonKey(name: 'data_refs') Map<String, dynamic>? dataRefs,
    @JsonKey(name: 'is_read') bool isRead,
    @JsonKey(name: 'is_dismissed') bool isDismissed,
    @JsonKey(name: 'generated_at') DateTime generatedAt,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    InsightApp? app,
  });

  $InsightAppCopyWith<$Res>? get app;
}

/// @nodoc
class _$ActionableInsightCopyWithImpl<$Res, $Val extends ActionableInsight>
    implements $ActionableInsightCopyWith<$Res> {
  _$ActionableInsightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActionableInsight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? priority = null,
    Object? title = null,
    Object? description = null,
    Object? actionText = freezed,
    Object? actionUrl = freezed,
    Object? dataRefs = freezed,
    Object? isRead = null,
    Object? isDismissed = null,
    Object? generatedAt = null,
    Object? expiresAt = freezed,
    Object? app = freezed,
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
                      as InsightType,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as InsightPriority,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            actionText: freezed == actionText
                ? _value.actionText
                : actionText // ignore: cast_nullable_to_non_nullable
                      as String?,
            actionUrl: freezed == actionUrl
                ? _value.actionUrl
                : actionUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            dataRefs: freezed == dataRefs
                ? _value.dataRefs
                : dataRefs // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            isRead: null == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as bool,
            isDismissed: null == isDismissed
                ? _value.isDismissed
                : isDismissed // ignore: cast_nullable_to_non_nullable
                      as bool,
            generatedAt: null == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            app: freezed == app
                ? _value.app
                : app // ignore: cast_nullable_to_non_nullable
                      as InsightApp?,
          )
          as $Val,
    );
  }

  /// Create a copy of ActionableInsight
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InsightAppCopyWith<$Res>? get app {
    if (_value.app == null) {
      return null;
    }

    return $InsightAppCopyWith<$Res>(_value.app!, (value) {
      return _then(_value.copyWith(app: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActionableInsightImplCopyWith<$Res>
    implements $ActionableInsightCopyWith<$Res> {
  factory _$$ActionableInsightImplCopyWith(
    _$ActionableInsightImpl value,
    $Res Function(_$ActionableInsightImpl) then,
  ) = __$$ActionableInsightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    InsightType type,
    InsightPriority priority,
    String title,
    String description,
    @JsonKey(name: 'action_text') String? actionText,
    @JsonKey(name: 'action_url') String? actionUrl,
    @JsonKey(name: 'data_refs') Map<String, dynamic>? dataRefs,
    @JsonKey(name: 'is_read') bool isRead,
    @JsonKey(name: 'is_dismissed') bool isDismissed,
    @JsonKey(name: 'generated_at') DateTime generatedAt,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    InsightApp? app,
  });

  @override
  $InsightAppCopyWith<$Res>? get app;
}

/// @nodoc
class __$$ActionableInsightImplCopyWithImpl<$Res>
    extends _$ActionableInsightCopyWithImpl<$Res, _$ActionableInsightImpl>
    implements _$$ActionableInsightImplCopyWith<$Res> {
  __$$ActionableInsightImplCopyWithImpl(
    _$ActionableInsightImpl _value,
    $Res Function(_$ActionableInsightImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActionableInsight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? priority = null,
    Object? title = null,
    Object? description = null,
    Object? actionText = freezed,
    Object? actionUrl = freezed,
    Object? dataRefs = freezed,
    Object? isRead = null,
    Object? isDismissed = null,
    Object? generatedAt = null,
    Object? expiresAt = freezed,
    Object? app = freezed,
  }) {
    return _then(
      _$ActionableInsightImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as InsightType,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as InsightPriority,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        actionText: freezed == actionText
            ? _value.actionText
            : actionText // ignore: cast_nullable_to_non_nullable
                  as String?,
        actionUrl: freezed == actionUrl
            ? _value.actionUrl
            : actionUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        dataRefs: freezed == dataRefs
            ? _value._dataRefs
            : dataRefs // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        isRead: null == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as bool,
        isDismissed: null == isDismissed
            ? _value.isDismissed
            : isDismissed // ignore: cast_nullable_to_non_nullable
                  as bool,
        generatedAt: null == generatedAt
            ? _value.generatedAt
            : generatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        app: freezed == app
            ? _value.app
            : app // ignore: cast_nullable_to_non_nullable
                  as InsightApp?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActionableInsightImpl implements _ActionableInsight {
  const _$ActionableInsightImpl({
    required this.id,
    required this.type,
    required this.priority,
    required this.title,
    required this.description,
    @JsonKey(name: 'action_text') this.actionText,
    @JsonKey(name: 'action_url') this.actionUrl,
    @JsonKey(name: 'data_refs') final Map<String, dynamic>? dataRefs,
    @JsonKey(name: 'is_read') this.isRead = false,
    @JsonKey(name: 'is_dismissed') this.isDismissed = false,
    @JsonKey(name: 'generated_at') required this.generatedAt,
    @JsonKey(name: 'expires_at') this.expiresAt,
    this.app,
  }) : _dataRefs = dataRefs;

  factory _$ActionableInsightImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActionableInsightImplFromJson(json);

  @override
  final int id;
  @override
  final InsightType type;
  @override
  final InsightPriority priority;
  @override
  final String title;
  @override
  final String description;
  @override
  @JsonKey(name: 'action_text')
  final String? actionText;
  @override
  @JsonKey(name: 'action_url')
  final String? actionUrl;
  final Map<String, dynamic>? _dataRefs;
  @override
  @JsonKey(name: 'data_refs')
  Map<String, dynamic>? get dataRefs {
    final value = _dataRefs;
    if (value == null) return null;
    if (_dataRefs is EqualUnmodifiableMapView) return _dataRefs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey(name: 'is_dismissed')
  final bool isDismissed;
  @override
  @JsonKey(name: 'generated_at')
  final DateTime generatedAt;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;
  @override
  final InsightApp? app;

  @override
  String toString() {
    return 'ActionableInsight(id: $id, type: $type, priority: $priority, title: $title, description: $description, actionText: $actionText, actionUrl: $actionUrl, dataRefs: $dataRefs, isRead: $isRead, isDismissed: $isDismissed, generatedAt: $generatedAt, expiresAt: $expiresAt, app: $app)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionableInsightImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.actionText, actionText) ||
                other.actionText == actionText) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            const DeepCollectionEquality().equals(other._dataRefs, _dataRefs) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isDismissed, isDismissed) ||
                other.isDismissed == isDismissed) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.app, app) || other.app == app));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    priority,
    title,
    description,
    actionText,
    actionUrl,
    const DeepCollectionEquality().hash(_dataRefs),
    isRead,
    isDismissed,
    generatedAt,
    expiresAt,
    app,
  );

  /// Create a copy of ActionableInsight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionableInsightImplCopyWith<_$ActionableInsightImpl> get copyWith =>
      __$$ActionableInsightImplCopyWithImpl<_$ActionableInsightImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActionableInsightImplToJson(this);
  }
}

abstract class _ActionableInsight implements ActionableInsight {
  const factory _ActionableInsight({
    required final int id,
    required final InsightType type,
    required final InsightPriority priority,
    required final String title,
    required final String description,
    @JsonKey(name: 'action_text') final String? actionText,
    @JsonKey(name: 'action_url') final String? actionUrl,
    @JsonKey(name: 'data_refs') final Map<String, dynamic>? dataRefs,
    @JsonKey(name: 'is_read') final bool isRead,
    @JsonKey(name: 'is_dismissed') final bool isDismissed,
    @JsonKey(name: 'generated_at') required final DateTime generatedAt,
    @JsonKey(name: 'expires_at') final DateTime? expiresAt,
    final InsightApp? app,
  }) = _$ActionableInsightImpl;

  factory _ActionableInsight.fromJson(Map<String, dynamic> json) =
      _$ActionableInsightImpl.fromJson;

  @override
  int get id;
  @override
  InsightType get type;
  @override
  InsightPriority get priority;
  @override
  String get title;
  @override
  String get description;
  @override
  @JsonKey(name: 'action_text')
  String? get actionText;
  @override
  @JsonKey(name: 'action_url')
  String? get actionUrl;
  @override
  @JsonKey(name: 'data_refs')
  Map<String, dynamic>? get dataRefs;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  @JsonKey(name: 'is_dismissed')
  bool get isDismissed;
  @override
  @JsonKey(name: 'generated_at')
  DateTime get generatedAt;
  @override
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt;
  @override
  InsightApp? get app;

  /// Create a copy of ActionableInsight
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActionableInsightImplCopyWith<_$ActionableInsightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InsightApp _$InsightAppFromJson(Map<String, dynamic> json) {
  return _InsightApp.fromJson(json);
}

/// @nodoc
mixin _$InsightApp {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;

  /// Serializes this InsightApp to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InsightApp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsightAppCopyWith<InsightApp> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightAppCopyWith<$Res> {
  factory $InsightAppCopyWith(
    InsightApp value,
    $Res Function(InsightApp) then,
  ) = _$InsightAppCopyWithImpl<$Res, InsightApp>;
  @useResult
  $Res call({
    int id,
    String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String platform,
  });
}

/// @nodoc
class _$InsightAppCopyWithImpl<$Res, $Val extends InsightApp>
    implements $InsightAppCopyWith<$Res> {
  _$InsightAppCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InsightApp
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
abstract class _$$InsightAppImplCopyWith<$Res>
    implements $InsightAppCopyWith<$Res> {
  factory _$$InsightAppImplCopyWith(
    _$InsightAppImpl value,
    $Res Function(_$InsightAppImpl) then,
  ) = __$$InsightAppImplCopyWithImpl<$Res>;
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
class __$$InsightAppImplCopyWithImpl<$Res>
    extends _$InsightAppCopyWithImpl<$Res, _$InsightAppImpl>
    implements _$$InsightAppImplCopyWith<$Res> {
  __$$InsightAppImplCopyWithImpl(
    _$InsightAppImpl _value,
    $Res Function(_$InsightAppImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InsightApp
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
      _$InsightAppImpl(
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
class _$InsightAppImpl implements _InsightApp {
  const _$InsightAppImpl({
    required this.id,
    required this.name,
    @JsonKey(name: 'icon_url') this.iconUrl,
    required this.platform,
  });

  factory _$InsightAppImpl.fromJson(Map<String, dynamic> json) =>
      _$$InsightAppImplFromJson(json);

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
    return 'InsightApp(id: $id, name: $name, iconUrl: $iconUrl, platform: $platform)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightAppImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.platform, platform) ||
                other.platform == platform));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, iconUrl, platform);

  /// Create a copy of InsightApp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightAppImplCopyWith<_$InsightAppImpl> get copyWith =>
      __$$InsightAppImplCopyWithImpl<_$InsightAppImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InsightAppImplToJson(this);
  }
}

abstract class _InsightApp implements InsightApp {
  const factory _InsightApp({
    required final int id,
    required final String name,
    @JsonKey(name: 'icon_url') final String? iconUrl,
    required final String platform,
  }) = _$InsightAppImpl;

  factory _InsightApp.fromJson(Map<String, dynamic> json) =
      _$InsightAppImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  String get platform;

  /// Create a copy of InsightApp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsightAppImplCopyWith<_$InsightAppImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InsightsSummary _$InsightsSummaryFromJson(Map<String, dynamic> json) {
  return _InsightsSummary.fromJson(json);
}

/// @nodoc
mixin _$InsightsSummary {
  List<ActionableInsight> get insights => throw _privateConstructorUsedError;
  @JsonKey(name: 'unread_count')
  int get unreadCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'by_type')
  Map<String, int> get byType => throw _privateConstructorUsedError;

  /// Serializes this InsightsSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InsightsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsightsSummaryCopyWith<InsightsSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightsSummaryCopyWith<$Res> {
  factory $InsightsSummaryCopyWith(
    InsightsSummary value,
    $Res Function(InsightsSummary) then,
  ) = _$InsightsSummaryCopyWithImpl<$Res, InsightsSummary>;
  @useResult
  $Res call({
    List<ActionableInsight> insights,
    @JsonKey(name: 'unread_count') int unreadCount,
    @JsonKey(name: 'by_type') Map<String, int> byType,
  });
}

/// @nodoc
class _$InsightsSummaryCopyWithImpl<$Res, $Val extends InsightsSummary>
    implements $InsightsSummaryCopyWith<$Res> {
  _$InsightsSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InsightsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? insights = null,
    Object? unreadCount = null,
    Object? byType = null,
  }) {
    return _then(
      _value.copyWith(
            insights: null == insights
                ? _value.insights
                : insights // ignore: cast_nullable_to_non_nullable
                      as List<ActionableInsight>,
            unreadCount: null == unreadCount
                ? _value.unreadCount
                : unreadCount // ignore: cast_nullable_to_non_nullable
                      as int,
            byType: null == byType
                ? _value.byType
                : byType // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InsightsSummaryImplCopyWith<$Res>
    implements $InsightsSummaryCopyWith<$Res> {
  factory _$$InsightsSummaryImplCopyWith(
    _$InsightsSummaryImpl value,
    $Res Function(_$InsightsSummaryImpl) then,
  ) = __$$InsightsSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<ActionableInsight> insights,
    @JsonKey(name: 'unread_count') int unreadCount,
    @JsonKey(name: 'by_type') Map<String, int> byType,
  });
}

/// @nodoc
class __$$InsightsSummaryImplCopyWithImpl<$Res>
    extends _$InsightsSummaryCopyWithImpl<$Res, _$InsightsSummaryImpl>
    implements _$$InsightsSummaryImplCopyWith<$Res> {
  __$$InsightsSummaryImplCopyWithImpl(
    _$InsightsSummaryImpl _value,
    $Res Function(_$InsightsSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InsightsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? insights = null,
    Object? unreadCount = null,
    Object? byType = null,
  }) {
    return _then(
      _$InsightsSummaryImpl(
        insights: null == insights
            ? _value._insights
            : insights // ignore: cast_nullable_to_non_nullable
                  as List<ActionableInsight>,
        unreadCount: null == unreadCount
            ? _value.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
        byType: null == byType
            ? _value._byType
            : byType // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InsightsSummaryImpl implements _InsightsSummary {
  const _$InsightsSummaryImpl({
    required final List<ActionableInsight> insights,
    @JsonKey(name: 'unread_count') required this.unreadCount,
    @JsonKey(name: 'by_type') required final Map<String, int> byType,
  }) : _insights = insights,
       _byType = byType;

  factory _$InsightsSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$InsightsSummaryImplFromJson(json);

  final List<ActionableInsight> _insights;
  @override
  List<ActionableInsight> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  @override
  @JsonKey(name: 'unread_count')
  final int unreadCount;
  final Map<String, int> _byType;
  @override
  @JsonKey(name: 'by_type')
  Map<String, int> get byType {
    if (_byType is EqualUnmodifiableMapView) return _byType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_byType);
  }

  @override
  String toString() {
    return 'InsightsSummary(insights: $insights, unreadCount: $unreadCount, byType: $byType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsSummaryImpl &&
            const DeepCollectionEquality().equals(other._insights, _insights) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            const DeepCollectionEquality().equals(other._byType, _byType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_insights),
    unreadCount,
    const DeepCollectionEquality().hash(_byType),
  );

  /// Create a copy of InsightsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightsSummaryImplCopyWith<_$InsightsSummaryImpl> get copyWith =>
      __$$InsightsSummaryImplCopyWithImpl<_$InsightsSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InsightsSummaryImplToJson(this);
  }
}

abstract class _InsightsSummary implements InsightsSummary {
  const factory _InsightsSummary({
    required final List<ActionableInsight> insights,
    @JsonKey(name: 'unread_count') required final int unreadCount,
    @JsonKey(name: 'by_type') required final Map<String, int> byType,
  }) = _$InsightsSummaryImpl;

  factory _InsightsSummary.fromJson(Map<String, dynamic> json) =
      _$InsightsSummaryImpl.fromJson;

  @override
  List<ActionableInsight> get insights;
  @override
  @JsonKey(name: 'unread_count')
  int get unreadCount;
  @override
  @JsonKey(name: 'by_type')
  Map<String, int> get byType;

  /// Create a copy of InsightsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsightsSummaryImplCopyWith<_$InsightsSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InsightsUnreadCount _$InsightsUnreadCountFromJson(Map<String, dynamic> json) {
  return _InsightsUnreadCount.fromJson(json);
}

/// @nodoc
mixin _$InsightsUnreadCount {
  int get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'high_priority')
  int get highPriority => throw _privateConstructorUsedError;

  /// Serializes this InsightsUnreadCount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InsightsUnreadCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsightsUnreadCountCopyWith<InsightsUnreadCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightsUnreadCountCopyWith<$Res> {
  factory $InsightsUnreadCountCopyWith(
    InsightsUnreadCount value,
    $Res Function(InsightsUnreadCount) then,
  ) = _$InsightsUnreadCountCopyWithImpl<$Res, InsightsUnreadCount>;
  @useResult
  $Res call({int total, @JsonKey(name: 'high_priority') int highPriority});
}

/// @nodoc
class _$InsightsUnreadCountCopyWithImpl<$Res, $Val extends InsightsUnreadCount>
    implements $InsightsUnreadCountCopyWith<$Res> {
  _$InsightsUnreadCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InsightsUnreadCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? total = null, Object? highPriority = null}) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            highPriority: null == highPriority
                ? _value.highPriority
                : highPriority // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InsightsUnreadCountImplCopyWith<$Res>
    implements $InsightsUnreadCountCopyWith<$Res> {
  factory _$$InsightsUnreadCountImplCopyWith(
    _$InsightsUnreadCountImpl value,
    $Res Function(_$InsightsUnreadCountImpl) then,
  ) = __$$InsightsUnreadCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int total, @JsonKey(name: 'high_priority') int highPriority});
}

/// @nodoc
class __$$InsightsUnreadCountImplCopyWithImpl<$Res>
    extends _$InsightsUnreadCountCopyWithImpl<$Res, _$InsightsUnreadCountImpl>
    implements _$$InsightsUnreadCountImplCopyWith<$Res> {
  __$$InsightsUnreadCountImplCopyWithImpl(
    _$InsightsUnreadCountImpl _value,
    $Res Function(_$InsightsUnreadCountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InsightsUnreadCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? total = null, Object? highPriority = null}) {
    return _then(
      _$InsightsUnreadCountImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        highPriority: null == highPriority
            ? _value.highPriority
            : highPriority // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InsightsUnreadCountImpl implements _InsightsUnreadCount {
  const _$InsightsUnreadCountImpl({
    required this.total,
    @JsonKey(name: 'high_priority') required this.highPriority,
  });

  factory _$InsightsUnreadCountImpl.fromJson(Map<String, dynamic> json) =>
      _$$InsightsUnreadCountImplFromJson(json);

  @override
  final int total;
  @override
  @JsonKey(name: 'high_priority')
  final int highPriority;

  @override
  String toString() {
    return 'InsightsUnreadCount(total: $total, highPriority: $highPriority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsUnreadCountImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.highPriority, highPriority) ||
                other.highPriority == highPriority));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, total, highPriority);

  /// Create a copy of InsightsUnreadCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightsUnreadCountImplCopyWith<_$InsightsUnreadCountImpl> get copyWith =>
      __$$InsightsUnreadCountImplCopyWithImpl<_$InsightsUnreadCountImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InsightsUnreadCountImplToJson(this);
  }
}

abstract class _InsightsUnreadCount implements InsightsUnreadCount {
  const factory _InsightsUnreadCount({
    required final int total,
    @JsonKey(name: 'high_priority') required final int highPriority,
  }) = _$InsightsUnreadCountImpl;

  factory _InsightsUnreadCount.fromJson(Map<String, dynamic> json) =
      _$InsightsUnreadCountImpl.fromJson;

  @override
  int get total;
  @override
  @JsonKey(name: 'high_priority')
  int get highPriority;

  /// Create a copy of InsightsUnreadCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsightsUnreadCountImplCopyWith<_$InsightsUnreadCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
