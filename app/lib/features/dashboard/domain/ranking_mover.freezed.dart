// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ranking_mover.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RankingMover _$RankingMoverFromJson(Map<String, dynamic> json) {
  return _RankingMover.fromJson(json);
}

/// @nodoc
mixin _$RankingMover {
  String get keyword => throw _privateConstructorUsedError;
  @JsonKey(name: 'keyword_id')
  int get keywordId => throw _privateConstructorUsedError;
  @JsonKey(name: 'app_name')
  String get appName => throw _privateConstructorUsedError;
  @JsonKey(name: 'app_id')
  int get appId => throw _privateConstructorUsedError;
  @JsonKey(name: 'app_icon')
  String? get appIcon => throw _privateConstructorUsedError;
  @JsonKey(name: 'old_position')
  int get oldPosition => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_position')
  int get newPosition => throw _privateConstructorUsedError;
  int get change => throw _privateConstructorUsedError;

  /// Serializes this RankingMover to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RankingMover
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RankingMoverCopyWith<RankingMover> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankingMoverCopyWith<$Res> {
  factory $RankingMoverCopyWith(
    RankingMover value,
    $Res Function(RankingMover) then,
  ) = _$RankingMoverCopyWithImpl<$Res, RankingMover>;
  @useResult
  $Res call({
    String keyword,
    @JsonKey(name: 'keyword_id') int keywordId,
    @JsonKey(name: 'app_name') String appName,
    @JsonKey(name: 'app_id') int appId,
    @JsonKey(name: 'app_icon') String? appIcon,
    @JsonKey(name: 'old_position') int oldPosition,
    @JsonKey(name: 'new_position') int newPosition,
    int change,
  });
}

/// @nodoc
class _$RankingMoverCopyWithImpl<$Res, $Val extends RankingMover>
    implements $RankingMoverCopyWith<$Res> {
  _$RankingMoverCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RankingMover
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keyword = null,
    Object? keywordId = null,
    Object? appName = null,
    Object? appId = null,
    Object? appIcon = freezed,
    Object? oldPosition = null,
    Object? newPosition = null,
    Object? change = null,
  }) {
    return _then(
      _value.copyWith(
            keyword: null == keyword
                ? _value.keyword
                : keyword // ignore: cast_nullable_to_non_nullable
                      as String,
            keywordId: null == keywordId
                ? _value.keywordId
                : keywordId // ignore: cast_nullable_to_non_nullable
                      as int,
            appName: null == appName
                ? _value.appName
                : appName // ignore: cast_nullable_to_non_nullable
                      as String,
            appId: null == appId
                ? _value.appId
                : appId // ignore: cast_nullable_to_non_nullable
                      as int,
            appIcon: freezed == appIcon
                ? _value.appIcon
                : appIcon // ignore: cast_nullable_to_non_nullable
                      as String?,
            oldPosition: null == oldPosition
                ? _value.oldPosition
                : oldPosition // ignore: cast_nullable_to_non_nullable
                      as int,
            newPosition: null == newPosition
                ? _value.newPosition
                : newPosition // ignore: cast_nullable_to_non_nullable
                      as int,
            change: null == change
                ? _value.change
                : change // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RankingMoverImplCopyWith<$Res>
    implements $RankingMoverCopyWith<$Res> {
  factory _$$RankingMoverImplCopyWith(
    _$RankingMoverImpl value,
    $Res Function(_$RankingMoverImpl) then,
  ) = __$$RankingMoverImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String keyword,
    @JsonKey(name: 'keyword_id') int keywordId,
    @JsonKey(name: 'app_name') String appName,
    @JsonKey(name: 'app_id') int appId,
    @JsonKey(name: 'app_icon') String? appIcon,
    @JsonKey(name: 'old_position') int oldPosition,
    @JsonKey(name: 'new_position') int newPosition,
    int change,
  });
}

/// @nodoc
class __$$RankingMoverImplCopyWithImpl<$Res>
    extends _$RankingMoverCopyWithImpl<$Res, _$RankingMoverImpl>
    implements _$$RankingMoverImplCopyWith<$Res> {
  __$$RankingMoverImplCopyWithImpl(
    _$RankingMoverImpl _value,
    $Res Function(_$RankingMoverImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RankingMover
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keyword = null,
    Object? keywordId = null,
    Object? appName = null,
    Object? appId = null,
    Object? appIcon = freezed,
    Object? oldPosition = null,
    Object? newPosition = null,
    Object? change = null,
  }) {
    return _then(
      _$RankingMoverImpl(
        keyword: null == keyword
            ? _value.keyword
            : keyword // ignore: cast_nullable_to_non_nullable
                  as String,
        keywordId: null == keywordId
            ? _value.keywordId
            : keywordId // ignore: cast_nullable_to_non_nullable
                  as int,
        appName: null == appName
            ? _value.appName
            : appName // ignore: cast_nullable_to_non_nullable
                  as String,
        appId: null == appId
            ? _value.appId
            : appId // ignore: cast_nullable_to_non_nullable
                  as int,
        appIcon: freezed == appIcon
            ? _value.appIcon
            : appIcon // ignore: cast_nullable_to_non_nullable
                  as String?,
        oldPosition: null == oldPosition
            ? _value.oldPosition
            : oldPosition // ignore: cast_nullable_to_non_nullable
                  as int,
        newPosition: null == newPosition
            ? _value.newPosition
            : newPosition // ignore: cast_nullable_to_non_nullable
                  as int,
        change: null == change
            ? _value.change
            : change // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RankingMoverImpl implements _RankingMover {
  const _$RankingMoverImpl({
    required this.keyword,
    @JsonKey(name: 'keyword_id') required this.keywordId,
    @JsonKey(name: 'app_name') required this.appName,
    @JsonKey(name: 'app_id') required this.appId,
    @JsonKey(name: 'app_icon') this.appIcon,
    @JsonKey(name: 'old_position') required this.oldPosition,
    @JsonKey(name: 'new_position') required this.newPosition,
    required this.change,
  });

  factory _$RankingMoverImpl.fromJson(Map<String, dynamic> json) =>
      _$$RankingMoverImplFromJson(json);

  @override
  final String keyword;
  @override
  @JsonKey(name: 'keyword_id')
  final int keywordId;
  @override
  @JsonKey(name: 'app_name')
  final String appName;
  @override
  @JsonKey(name: 'app_id')
  final int appId;
  @override
  @JsonKey(name: 'app_icon')
  final String? appIcon;
  @override
  @JsonKey(name: 'old_position')
  final int oldPosition;
  @override
  @JsonKey(name: 'new_position')
  final int newPosition;
  @override
  final int change;

  @override
  String toString() {
    return 'RankingMover(keyword: $keyword, keywordId: $keywordId, appName: $appName, appId: $appId, appIcon: $appIcon, oldPosition: $oldPosition, newPosition: $newPosition, change: $change)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RankingMoverImpl &&
            (identical(other.keyword, keyword) || other.keyword == keyword) &&
            (identical(other.keywordId, keywordId) ||
                other.keywordId == keywordId) &&
            (identical(other.appName, appName) || other.appName == appName) &&
            (identical(other.appId, appId) || other.appId == appId) &&
            (identical(other.appIcon, appIcon) || other.appIcon == appIcon) &&
            (identical(other.oldPosition, oldPosition) ||
                other.oldPosition == oldPosition) &&
            (identical(other.newPosition, newPosition) ||
                other.newPosition == newPosition) &&
            (identical(other.change, change) || other.change == change));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    keyword,
    keywordId,
    appName,
    appId,
    appIcon,
    oldPosition,
    newPosition,
    change,
  );

  /// Create a copy of RankingMover
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RankingMoverImplCopyWith<_$RankingMoverImpl> get copyWith =>
      __$$RankingMoverImplCopyWithImpl<_$RankingMoverImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RankingMoverImplToJson(this);
  }
}

abstract class _RankingMover implements RankingMover {
  const factory _RankingMover({
    required final String keyword,
    @JsonKey(name: 'keyword_id') required final int keywordId,
    @JsonKey(name: 'app_name') required final String appName,
    @JsonKey(name: 'app_id') required final int appId,
    @JsonKey(name: 'app_icon') final String? appIcon,
    @JsonKey(name: 'old_position') required final int oldPosition,
    @JsonKey(name: 'new_position') required final int newPosition,
    required final int change,
  }) = _$RankingMoverImpl;

  factory _RankingMover.fromJson(Map<String, dynamic> json) =
      _$RankingMoverImpl.fromJson;

  @override
  String get keyword;
  @override
  @JsonKey(name: 'keyword_id')
  int get keywordId;
  @override
  @JsonKey(name: 'app_name')
  String get appName;
  @override
  @JsonKey(name: 'app_id')
  int get appId;
  @override
  @JsonKey(name: 'app_icon')
  String? get appIcon;
  @override
  @JsonKey(name: 'old_position')
  int get oldPosition;
  @override
  @JsonKey(name: 'new_position')
  int get newPosition;
  @override
  int get change;

  /// Create a copy of RankingMover
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RankingMoverImplCopyWith<_$RankingMoverImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RankingMoversData _$RankingMoversDataFromJson(Map<String, dynamic> json) {
  return _RankingMoversData.fromJson(json);
}

/// @nodoc
mixin _$RankingMoversData {
  List<RankingMover> get improving => throw _privateConstructorUsedError;
  List<RankingMover> get declining => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;

  /// Serializes this RankingMoversData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RankingMoversData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RankingMoversDataCopyWith<RankingMoversData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankingMoversDataCopyWith<$Res> {
  factory $RankingMoversDataCopyWith(
    RankingMoversData value,
    $Res Function(RankingMoversData) then,
  ) = _$RankingMoversDataCopyWithImpl<$Res, RankingMoversData>;
  @useResult
  $Res call({
    List<RankingMover> improving,
    List<RankingMover> declining,
    String period,
  });
}

/// @nodoc
class _$RankingMoversDataCopyWithImpl<$Res, $Val extends RankingMoversData>
    implements $RankingMoversDataCopyWith<$Res> {
  _$RankingMoversDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RankingMoversData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? improving = null,
    Object? declining = null,
    Object? period = null,
  }) {
    return _then(
      _value.copyWith(
            improving: null == improving
                ? _value.improving
                : improving // ignore: cast_nullable_to_non_nullable
                      as List<RankingMover>,
            declining: null == declining
                ? _value.declining
                : declining // ignore: cast_nullable_to_non_nullable
                      as List<RankingMover>,
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RankingMoversDataImplCopyWith<$Res>
    implements $RankingMoversDataCopyWith<$Res> {
  factory _$$RankingMoversDataImplCopyWith(
    _$RankingMoversDataImpl value,
    $Res Function(_$RankingMoversDataImpl) then,
  ) = __$$RankingMoversDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<RankingMover> improving,
    List<RankingMover> declining,
    String period,
  });
}

/// @nodoc
class __$$RankingMoversDataImplCopyWithImpl<$Res>
    extends _$RankingMoversDataCopyWithImpl<$Res, _$RankingMoversDataImpl>
    implements _$$RankingMoversDataImplCopyWith<$Res> {
  __$$RankingMoversDataImplCopyWithImpl(
    _$RankingMoversDataImpl _value,
    $Res Function(_$RankingMoversDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RankingMoversData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? improving = null,
    Object? declining = null,
    Object? period = null,
  }) {
    return _then(
      _$RankingMoversDataImpl(
        improving: null == improving
            ? _value._improving
            : improving // ignore: cast_nullable_to_non_nullable
                  as List<RankingMover>,
        declining: null == declining
            ? _value._declining
            : declining // ignore: cast_nullable_to_non_nullable
                  as List<RankingMover>,
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RankingMoversDataImpl implements _RankingMoversData {
  const _$RankingMoversDataImpl({
    required final List<RankingMover> improving,
    required final List<RankingMover> declining,
    required this.period,
  }) : _improving = improving,
       _declining = declining;

  factory _$RankingMoversDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RankingMoversDataImplFromJson(json);

  final List<RankingMover> _improving;
  @override
  List<RankingMover> get improving {
    if (_improving is EqualUnmodifiableListView) return _improving;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_improving);
  }

  final List<RankingMover> _declining;
  @override
  List<RankingMover> get declining {
    if (_declining is EqualUnmodifiableListView) return _declining;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_declining);
  }

  @override
  final String period;

  @override
  String toString() {
    return 'RankingMoversData(improving: $improving, declining: $declining, period: $period)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RankingMoversDataImpl &&
            const DeepCollectionEquality().equals(
              other._improving,
              _improving,
            ) &&
            const DeepCollectionEquality().equals(
              other._declining,
              _declining,
            ) &&
            (identical(other.period, period) || other.period == period));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_improving),
    const DeepCollectionEquality().hash(_declining),
    period,
  );

  /// Create a copy of RankingMoversData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RankingMoversDataImplCopyWith<_$RankingMoversDataImpl> get copyWith =>
      __$$RankingMoversDataImplCopyWithImpl<_$RankingMoversDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RankingMoversDataImplToJson(this);
  }
}

abstract class _RankingMoversData implements RankingMoversData {
  const factory _RankingMoversData({
    required final List<RankingMover> improving,
    required final List<RankingMover> declining,
    required final String period,
  }) = _$RankingMoversDataImpl;

  factory _RankingMoversData.fromJson(Map<String, dynamic> json) =
      _$RankingMoversDataImpl.fromJson;

  @override
  List<RankingMover> get improving;
  @override
  List<RankingMover> get declining;
  @override
  String get period;

  /// Create a copy of RankingMoversData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RankingMoversDataImplCopyWith<_$RankingMoversDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
