// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ranking_history_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RankingHistoryPoint _$RankingHistoryPointFromJson(Map<String, dynamic> json) {
  return _RankingHistoryPoint.fromJson(json);
}

/// @nodoc
mixin _$RankingHistoryPoint {
  /// Type de donnée: 'daily', 'weekly', 'monthly'
  String get type => throw _privateConstructorUsedError;

  /// Date pour les données daily (null pour aggregates)
  DateTime? get date => throw _privateConstructorUsedError;

  /// Début de période pour les aggregates (null pour daily)
  @JsonKey(name: 'period_start')
  DateTime? get periodStart => throw _privateConstructorUsedError;

  /// Position exacte (daily uniquement)
  int? get position => throw _privateConstructorUsedError;

  /// Position moyenne (aggregates uniquement)
  double? get avg => throw _privateConstructorUsedError;

  /// Position minimum (aggregates uniquement)
  int? get min => throw _privateConstructorUsedError;

  /// Position maximum (aggregates uniquement)
  int? get max => throw _privateConstructorUsedError;

  /// Nombre de jours de données (aggregates uniquement)
  @JsonKey(name: 'data_points')
  int? get dataPoints => throw _privateConstructorUsedError;

  /// Serializes this RankingHistoryPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RankingHistoryPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RankingHistoryPointCopyWith<RankingHistoryPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankingHistoryPointCopyWith<$Res> {
  factory $RankingHistoryPointCopyWith(
    RankingHistoryPoint value,
    $Res Function(RankingHistoryPoint) then,
  ) = _$RankingHistoryPointCopyWithImpl<$Res, RankingHistoryPoint>;
  @useResult
  $Res call({
    String type,
    DateTime? date,
    @JsonKey(name: 'period_start') DateTime? periodStart,
    int? position,
    double? avg,
    int? min,
    int? max,
    @JsonKey(name: 'data_points') int? dataPoints,
  });
}

/// @nodoc
class _$RankingHistoryPointCopyWithImpl<$Res, $Val extends RankingHistoryPoint>
    implements $RankingHistoryPointCopyWith<$Res> {
  _$RankingHistoryPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RankingHistoryPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? date = freezed,
    Object? periodStart = freezed,
    Object? position = freezed,
    Object? avg = freezed,
    Object? min = freezed,
    Object? max = freezed,
    Object? dataPoints = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            periodStart: freezed == periodStart
                ? _value.periodStart
                : periodStart // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            position: freezed == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int?,
            avg: freezed == avg
                ? _value.avg
                : avg // ignore: cast_nullable_to_non_nullable
                      as double?,
            min: freezed == min
                ? _value.min
                : min // ignore: cast_nullable_to_non_nullable
                      as int?,
            max: freezed == max
                ? _value.max
                : max // ignore: cast_nullable_to_non_nullable
                      as int?,
            dataPoints: freezed == dataPoints
                ? _value.dataPoints
                : dataPoints // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RankingHistoryPointImplCopyWith<$Res>
    implements $RankingHistoryPointCopyWith<$Res> {
  factory _$$RankingHistoryPointImplCopyWith(
    _$RankingHistoryPointImpl value,
    $Res Function(_$RankingHistoryPointImpl) then,
  ) = __$$RankingHistoryPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String type,
    DateTime? date,
    @JsonKey(name: 'period_start') DateTime? periodStart,
    int? position,
    double? avg,
    int? min,
    int? max,
    @JsonKey(name: 'data_points') int? dataPoints,
  });
}

/// @nodoc
class __$$RankingHistoryPointImplCopyWithImpl<$Res>
    extends _$RankingHistoryPointCopyWithImpl<$Res, _$RankingHistoryPointImpl>
    implements _$$RankingHistoryPointImplCopyWith<$Res> {
  __$$RankingHistoryPointImplCopyWithImpl(
    _$RankingHistoryPointImpl _value,
    $Res Function(_$RankingHistoryPointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RankingHistoryPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? date = freezed,
    Object? periodStart = freezed,
    Object? position = freezed,
    Object? avg = freezed,
    Object? min = freezed,
    Object? max = freezed,
    Object? dataPoints = freezed,
  }) {
    return _then(
      _$RankingHistoryPointImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        periodStart: freezed == periodStart
            ? _value.periodStart
            : periodStart // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        position: freezed == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int?,
        avg: freezed == avg
            ? _value.avg
            : avg // ignore: cast_nullable_to_non_nullable
                  as double?,
        min: freezed == min
            ? _value.min
            : min // ignore: cast_nullable_to_non_nullable
                  as int?,
        max: freezed == max
            ? _value.max
            : max // ignore: cast_nullable_to_non_nullable
                  as int?,
        dataPoints: freezed == dataPoints
            ? _value.dataPoints
            : dataPoints // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RankingHistoryPointImpl extends _RankingHistoryPoint {
  const _$RankingHistoryPointImpl({
    required this.type,
    this.date,
    @JsonKey(name: 'period_start') this.periodStart,
    this.position,
    this.avg,
    this.min,
    this.max,
    @JsonKey(name: 'data_points') this.dataPoints,
  }) : super._();

  factory _$RankingHistoryPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$RankingHistoryPointImplFromJson(json);

  /// Type de donnée: 'daily', 'weekly', 'monthly'
  @override
  final String type;

  /// Date pour les données daily (null pour aggregates)
  @override
  final DateTime? date;

  /// Début de période pour les aggregates (null pour daily)
  @override
  @JsonKey(name: 'period_start')
  final DateTime? periodStart;

  /// Position exacte (daily uniquement)
  @override
  final int? position;

  /// Position moyenne (aggregates uniquement)
  @override
  final double? avg;

  /// Position minimum (aggregates uniquement)
  @override
  final int? min;

  /// Position maximum (aggregates uniquement)
  @override
  final int? max;

  /// Nombre de jours de données (aggregates uniquement)
  @override
  @JsonKey(name: 'data_points')
  final int? dataPoints;

  @override
  String toString() {
    return 'RankingHistoryPoint(type: $type, date: $date, periodStart: $periodStart, position: $position, avg: $avg, min: $min, max: $max, dataPoints: $dataPoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RankingHistoryPointImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.avg, avg) || other.avg == avg) &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.dataPoints, dataPoints) ||
                other.dataPoints == dataPoints));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    date,
    periodStart,
    position,
    avg,
    min,
    max,
    dataPoints,
  );

  /// Create a copy of RankingHistoryPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RankingHistoryPointImplCopyWith<_$RankingHistoryPointImpl> get copyWith =>
      __$$RankingHistoryPointImplCopyWithImpl<_$RankingHistoryPointImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RankingHistoryPointImplToJson(this);
  }
}

abstract class _RankingHistoryPoint extends RankingHistoryPoint {
  const factory _RankingHistoryPoint({
    required final String type,
    final DateTime? date,
    @JsonKey(name: 'period_start') final DateTime? periodStart,
    final int? position,
    final double? avg,
    final int? min,
    final int? max,
    @JsonKey(name: 'data_points') final int? dataPoints,
  }) = _$RankingHistoryPointImpl;
  const _RankingHistoryPoint._() : super._();

  factory _RankingHistoryPoint.fromJson(Map<String, dynamic> json) =
      _$RankingHistoryPointImpl.fromJson;

  /// Type de donnée: 'daily', 'weekly', 'monthly'
  @override
  String get type;

  /// Date pour les données daily (null pour aggregates)
  @override
  DateTime? get date;

  /// Début de période pour les aggregates (null pour daily)
  @override
  @JsonKey(name: 'period_start')
  DateTime? get periodStart;

  /// Position exacte (daily uniquement)
  @override
  int? get position;

  /// Position moyenne (aggregates uniquement)
  @override
  double? get avg;

  /// Position minimum (aggregates uniquement)
  @override
  int? get min;

  /// Position maximum (aggregates uniquement)
  @override
  int? get max;

  /// Nombre de jours de données (aggregates uniquement)
  @override
  @JsonKey(name: 'data_points')
  int? get dataPoints;

  /// Create a copy of RankingHistoryPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RankingHistoryPointImplCopyWith<_$RankingHistoryPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
