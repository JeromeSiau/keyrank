// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnalyticsSummary _$AnalyticsSummaryFromJson(Map<String, dynamic> json) {
  return _AnalyticsSummary.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsSummary {
  String get period => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_downloads')
  int get totalDownloads => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_revenue')
  double get totalRevenue => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_proceeds')
  double get totalProceeds => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_subscribers')
  int get activeSubscribers => throw _privateConstructorUsedError;
  @JsonKey(name: 'downloads_change_pct')
  double? get downloadsChangePct => throw _privateConstructorUsedError;
  @JsonKey(name: 'revenue_change_pct')
  double? get revenueChangePct => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscribers_change_pct')
  double? get subscribersChangePct => throw _privateConstructorUsedError;
  @JsonKey(name: 'computed_at')
  DateTime? get computedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_data')
  bool get hasData => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsSummaryCopyWith<AnalyticsSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsSummaryCopyWith<$Res> {
  factory $AnalyticsSummaryCopyWith(
    AnalyticsSummary value,
    $Res Function(AnalyticsSummary) then,
  ) = _$AnalyticsSummaryCopyWithImpl<$Res, AnalyticsSummary>;
  @useResult
  $Res call({
    String period,
    @JsonKey(name: 'total_downloads') int totalDownloads,
    @JsonKey(name: 'total_revenue') double totalRevenue,
    @JsonKey(name: 'total_proceeds') double totalProceeds,
    @JsonKey(name: 'active_subscribers') int activeSubscribers,
    @JsonKey(name: 'downloads_change_pct') double? downloadsChangePct,
    @JsonKey(name: 'revenue_change_pct') double? revenueChangePct,
    @JsonKey(name: 'subscribers_change_pct') double? subscribersChangePct,
    @JsonKey(name: 'computed_at') DateTime? computedAt,
    @JsonKey(name: 'has_data') bool hasData,
  });
}

/// @nodoc
class _$AnalyticsSummaryCopyWithImpl<$Res, $Val extends AnalyticsSummary>
    implements $AnalyticsSummaryCopyWith<$Res> {
  _$AnalyticsSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? totalDownloads = null,
    Object? totalRevenue = null,
    Object? totalProceeds = null,
    Object? activeSubscribers = null,
    Object? downloadsChangePct = freezed,
    Object? revenueChangePct = freezed,
    Object? subscribersChangePct = freezed,
    Object? computedAt = freezed,
    Object? hasData = null,
  }) {
    return _then(
      _value.copyWith(
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as String,
            totalDownloads: null == totalDownloads
                ? _value.totalDownloads
                : totalDownloads // ignore: cast_nullable_to_non_nullable
                      as int,
            totalRevenue: null == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
            totalProceeds: null == totalProceeds
                ? _value.totalProceeds
                : totalProceeds // ignore: cast_nullable_to_non_nullable
                      as double,
            activeSubscribers: null == activeSubscribers
                ? _value.activeSubscribers
                : activeSubscribers // ignore: cast_nullable_to_non_nullable
                      as int,
            downloadsChangePct: freezed == downloadsChangePct
                ? _value.downloadsChangePct
                : downloadsChangePct // ignore: cast_nullable_to_non_nullable
                      as double?,
            revenueChangePct: freezed == revenueChangePct
                ? _value.revenueChangePct
                : revenueChangePct // ignore: cast_nullable_to_non_nullable
                      as double?,
            subscribersChangePct: freezed == subscribersChangePct
                ? _value.subscribersChangePct
                : subscribersChangePct // ignore: cast_nullable_to_non_nullable
                      as double?,
            computedAt: freezed == computedAt
                ? _value.computedAt
                : computedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            hasData: null == hasData
                ? _value.hasData
                : hasData // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnalyticsSummaryImplCopyWith<$Res>
    implements $AnalyticsSummaryCopyWith<$Res> {
  factory _$$AnalyticsSummaryImplCopyWith(
    _$AnalyticsSummaryImpl value,
    $Res Function(_$AnalyticsSummaryImpl) then,
  ) = __$$AnalyticsSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String period,
    @JsonKey(name: 'total_downloads') int totalDownloads,
    @JsonKey(name: 'total_revenue') double totalRevenue,
    @JsonKey(name: 'total_proceeds') double totalProceeds,
    @JsonKey(name: 'active_subscribers') int activeSubscribers,
    @JsonKey(name: 'downloads_change_pct') double? downloadsChangePct,
    @JsonKey(name: 'revenue_change_pct') double? revenueChangePct,
    @JsonKey(name: 'subscribers_change_pct') double? subscribersChangePct,
    @JsonKey(name: 'computed_at') DateTime? computedAt,
    @JsonKey(name: 'has_data') bool hasData,
  });
}

/// @nodoc
class __$$AnalyticsSummaryImplCopyWithImpl<$Res>
    extends _$AnalyticsSummaryCopyWithImpl<$Res, _$AnalyticsSummaryImpl>
    implements _$$AnalyticsSummaryImplCopyWith<$Res> {
  __$$AnalyticsSummaryImplCopyWithImpl(
    _$AnalyticsSummaryImpl _value,
    $Res Function(_$AnalyticsSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalyticsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? totalDownloads = null,
    Object? totalRevenue = null,
    Object? totalProceeds = null,
    Object? activeSubscribers = null,
    Object? downloadsChangePct = freezed,
    Object? revenueChangePct = freezed,
    Object? subscribersChangePct = freezed,
    Object? computedAt = freezed,
    Object? hasData = null,
  }) {
    return _then(
      _$AnalyticsSummaryImpl(
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as String,
        totalDownloads: null == totalDownloads
            ? _value.totalDownloads
            : totalDownloads // ignore: cast_nullable_to_non_nullable
                  as int,
        totalRevenue: null == totalRevenue
            ? _value.totalRevenue
            : totalRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
        totalProceeds: null == totalProceeds
            ? _value.totalProceeds
            : totalProceeds // ignore: cast_nullable_to_non_nullable
                  as double,
        activeSubscribers: null == activeSubscribers
            ? _value.activeSubscribers
            : activeSubscribers // ignore: cast_nullable_to_non_nullable
                  as int,
        downloadsChangePct: freezed == downloadsChangePct
            ? _value.downloadsChangePct
            : downloadsChangePct // ignore: cast_nullable_to_non_nullable
                  as double?,
        revenueChangePct: freezed == revenueChangePct
            ? _value.revenueChangePct
            : revenueChangePct // ignore: cast_nullable_to_non_nullable
                  as double?,
        subscribersChangePct: freezed == subscribersChangePct
            ? _value.subscribersChangePct
            : subscribersChangePct // ignore: cast_nullable_to_non_nullable
                  as double?,
        computedAt: freezed == computedAt
            ? _value.computedAt
            : computedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        hasData: null == hasData
            ? _value.hasData
            : hasData // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsSummaryImpl implements _AnalyticsSummary {
  const _$AnalyticsSummaryImpl({
    required this.period,
    @JsonKey(name: 'total_downloads') required this.totalDownloads,
    @JsonKey(name: 'total_revenue') required this.totalRevenue,
    @JsonKey(name: 'total_proceeds') required this.totalProceeds,
    @JsonKey(name: 'active_subscribers') required this.activeSubscribers,
    @JsonKey(name: 'downloads_change_pct') this.downloadsChangePct,
    @JsonKey(name: 'revenue_change_pct') this.revenueChangePct,
    @JsonKey(name: 'subscribers_change_pct') this.subscribersChangePct,
    @JsonKey(name: 'computed_at') this.computedAt,
    @JsonKey(name: 'has_data') this.hasData = false,
  });

  factory _$AnalyticsSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsSummaryImplFromJson(json);

  @override
  final String period;
  @override
  @JsonKey(name: 'total_downloads')
  final int totalDownloads;
  @override
  @JsonKey(name: 'total_revenue')
  final double totalRevenue;
  @override
  @JsonKey(name: 'total_proceeds')
  final double totalProceeds;
  @override
  @JsonKey(name: 'active_subscribers')
  final int activeSubscribers;
  @override
  @JsonKey(name: 'downloads_change_pct')
  final double? downloadsChangePct;
  @override
  @JsonKey(name: 'revenue_change_pct')
  final double? revenueChangePct;
  @override
  @JsonKey(name: 'subscribers_change_pct')
  final double? subscribersChangePct;
  @override
  @JsonKey(name: 'computed_at')
  final DateTime? computedAt;
  @override
  @JsonKey(name: 'has_data')
  final bool hasData;

  @override
  String toString() {
    return 'AnalyticsSummary(period: $period, totalDownloads: $totalDownloads, totalRevenue: $totalRevenue, totalProceeds: $totalProceeds, activeSubscribers: $activeSubscribers, downloadsChangePct: $downloadsChangePct, revenueChangePct: $revenueChangePct, subscribersChangePct: $subscribersChangePct, computedAt: $computedAt, hasData: $hasData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsSummaryImpl &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.totalDownloads, totalDownloads) ||
                other.totalDownloads == totalDownloads) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.totalProceeds, totalProceeds) ||
                other.totalProceeds == totalProceeds) &&
            (identical(other.activeSubscribers, activeSubscribers) ||
                other.activeSubscribers == activeSubscribers) &&
            (identical(other.downloadsChangePct, downloadsChangePct) ||
                other.downloadsChangePct == downloadsChangePct) &&
            (identical(other.revenueChangePct, revenueChangePct) ||
                other.revenueChangePct == revenueChangePct) &&
            (identical(other.subscribersChangePct, subscribersChangePct) ||
                other.subscribersChangePct == subscribersChangePct) &&
            (identical(other.computedAt, computedAt) ||
                other.computedAt == computedAt) &&
            (identical(other.hasData, hasData) || other.hasData == hasData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    period,
    totalDownloads,
    totalRevenue,
    totalProceeds,
    activeSubscribers,
    downloadsChangePct,
    revenueChangePct,
    subscribersChangePct,
    computedAt,
    hasData,
  );

  /// Create a copy of AnalyticsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsSummaryImplCopyWith<_$AnalyticsSummaryImpl> get copyWith =>
      __$$AnalyticsSummaryImplCopyWithImpl<_$AnalyticsSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsSummaryImplToJson(this);
  }
}

abstract class _AnalyticsSummary implements AnalyticsSummary {
  const factory _AnalyticsSummary({
    required final String period,
    @JsonKey(name: 'total_downloads') required final int totalDownloads,
    @JsonKey(name: 'total_revenue') required final double totalRevenue,
    @JsonKey(name: 'total_proceeds') required final double totalProceeds,
    @JsonKey(name: 'active_subscribers') required final int activeSubscribers,
    @JsonKey(name: 'downloads_change_pct') final double? downloadsChangePct,
    @JsonKey(name: 'revenue_change_pct') final double? revenueChangePct,
    @JsonKey(name: 'subscribers_change_pct') final double? subscribersChangePct,
    @JsonKey(name: 'computed_at') final DateTime? computedAt,
    @JsonKey(name: 'has_data') final bool hasData,
  }) = _$AnalyticsSummaryImpl;

  factory _AnalyticsSummary.fromJson(Map<String, dynamic> json) =
      _$AnalyticsSummaryImpl.fromJson;

  @override
  String get period;
  @override
  @JsonKey(name: 'total_downloads')
  int get totalDownloads;
  @override
  @JsonKey(name: 'total_revenue')
  double get totalRevenue;
  @override
  @JsonKey(name: 'total_proceeds')
  double get totalProceeds;
  @override
  @JsonKey(name: 'active_subscribers')
  int get activeSubscribers;
  @override
  @JsonKey(name: 'downloads_change_pct')
  double? get downloadsChangePct;
  @override
  @JsonKey(name: 'revenue_change_pct')
  double? get revenueChangePct;
  @override
  @JsonKey(name: 'subscribers_change_pct')
  double? get subscribersChangePct;
  @override
  @JsonKey(name: 'computed_at')
  DateTime? get computedAt;
  @override
  @JsonKey(name: 'has_data')
  bool get hasData;

  /// Create a copy of AnalyticsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsSummaryImplCopyWith<_$AnalyticsSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DownloadsDataPoint _$DownloadsDataPointFromJson(Map<String, dynamic> json) {
  return _DownloadsDataPoint.fromJson(json);
}

/// @nodoc
mixin _$DownloadsDataPoint {
  String get date => throw _privateConstructorUsedError;
  int get downloads => throw _privateConstructorUsedError;

  /// Serializes this DownloadsDataPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DownloadsDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DownloadsDataPointCopyWith<DownloadsDataPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DownloadsDataPointCopyWith<$Res> {
  factory $DownloadsDataPointCopyWith(
    DownloadsDataPoint value,
    $Res Function(DownloadsDataPoint) then,
  ) = _$DownloadsDataPointCopyWithImpl<$Res, DownloadsDataPoint>;
  @useResult
  $Res call({String date, int downloads});
}

/// @nodoc
class _$DownloadsDataPointCopyWithImpl<$Res, $Val extends DownloadsDataPoint>
    implements $DownloadsDataPointCopyWith<$Res> {
  _$DownloadsDataPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DownloadsDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? downloads = null}) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            downloads: null == downloads
                ? _value.downloads
                : downloads // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DownloadsDataPointImplCopyWith<$Res>
    implements $DownloadsDataPointCopyWith<$Res> {
  factory _$$DownloadsDataPointImplCopyWith(
    _$DownloadsDataPointImpl value,
    $Res Function(_$DownloadsDataPointImpl) then,
  ) = __$$DownloadsDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date, int downloads});
}

/// @nodoc
class __$$DownloadsDataPointImplCopyWithImpl<$Res>
    extends _$DownloadsDataPointCopyWithImpl<$Res, _$DownloadsDataPointImpl>
    implements _$$DownloadsDataPointImplCopyWith<$Res> {
  __$$DownloadsDataPointImplCopyWithImpl(
    _$DownloadsDataPointImpl _value,
    $Res Function(_$DownloadsDataPointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DownloadsDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? downloads = null}) {
    return _then(
      _$DownloadsDataPointImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        downloads: null == downloads
            ? _value.downloads
            : downloads // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DownloadsDataPointImpl implements _DownloadsDataPoint {
  const _$DownloadsDataPointImpl({required this.date, required this.downloads});

  factory _$DownloadsDataPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$DownloadsDataPointImplFromJson(json);

  @override
  final String date;
  @override
  final int downloads;

  @override
  String toString() {
    return 'DownloadsDataPoint(date: $date, downloads: $downloads)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DownloadsDataPointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.downloads, downloads) ||
                other.downloads == downloads));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, downloads);

  /// Create a copy of DownloadsDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadsDataPointImplCopyWith<_$DownloadsDataPointImpl> get copyWith =>
      __$$DownloadsDataPointImplCopyWithImpl<_$DownloadsDataPointImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DownloadsDataPointImplToJson(this);
  }
}

abstract class _DownloadsDataPoint implements DownloadsDataPoint {
  const factory _DownloadsDataPoint({
    required final String date,
    required final int downloads,
  }) = _$DownloadsDataPointImpl;

  factory _DownloadsDataPoint.fromJson(Map<String, dynamic> json) =
      _$DownloadsDataPointImpl.fromJson;

  @override
  String get date;
  @override
  int get downloads;

  /// Create a copy of DownloadsDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DownloadsDataPointImplCopyWith<_$DownloadsDataPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RevenueDataPoint _$RevenueDataPointFromJson(Map<String, dynamic> json) {
  return _RevenueDataPoint.fromJson(json);
}

/// @nodoc
mixin _$RevenueDataPoint {
  String get date => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;
  double get proceeds => throw _privateConstructorUsedError;

  /// Serializes this RevenueDataPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RevenueDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RevenueDataPointCopyWith<RevenueDataPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RevenueDataPointCopyWith<$Res> {
  factory $RevenueDataPointCopyWith(
    RevenueDataPoint value,
    $Res Function(RevenueDataPoint) then,
  ) = _$RevenueDataPointCopyWithImpl<$Res, RevenueDataPoint>;
  @useResult
  $Res call({String date, double revenue, double proceeds});
}

/// @nodoc
class _$RevenueDataPointCopyWithImpl<$Res, $Val extends RevenueDataPoint>
    implements $RevenueDataPointCopyWith<$Res> {
  _$RevenueDataPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RevenueDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? revenue = null,
    Object? proceeds = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            revenue: null == revenue
                ? _value.revenue
                : revenue // ignore: cast_nullable_to_non_nullable
                      as double,
            proceeds: null == proceeds
                ? _value.proceeds
                : proceeds // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RevenueDataPointImplCopyWith<$Res>
    implements $RevenueDataPointCopyWith<$Res> {
  factory _$$RevenueDataPointImplCopyWith(
    _$RevenueDataPointImpl value,
    $Res Function(_$RevenueDataPointImpl) then,
  ) = __$$RevenueDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date, double revenue, double proceeds});
}

/// @nodoc
class __$$RevenueDataPointImplCopyWithImpl<$Res>
    extends _$RevenueDataPointCopyWithImpl<$Res, _$RevenueDataPointImpl>
    implements _$$RevenueDataPointImplCopyWith<$Res> {
  __$$RevenueDataPointImplCopyWithImpl(
    _$RevenueDataPointImpl _value,
    $Res Function(_$RevenueDataPointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RevenueDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? revenue = null,
    Object? proceeds = null,
  }) {
    return _then(
      _$RevenueDataPointImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        revenue: null == revenue
            ? _value.revenue
            : revenue // ignore: cast_nullable_to_non_nullable
                  as double,
        proceeds: null == proceeds
            ? _value.proceeds
            : proceeds // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RevenueDataPointImpl implements _RevenueDataPoint {
  const _$RevenueDataPointImpl({
    required this.date,
    required this.revenue,
    required this.proceeds,
  });

  factory _$RevenueDataPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$RevenueDataPointImplFromJson(json);

  @override
  final String date;
  @override
  final double revenue;
  @override
  final double proceeds;

  @override
  String toString() {
    return 'RevenueDataPoint(date: $date, revenue: $revenue, proceeds: $proceeds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RevenueDataPointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.proceeds, proceeds) ||
                other.proceeds == proceeds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, revenue, proceeds);

  /// Create a copy of RevenueDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RevenueDataPointImplCopyWith<_$RevenueDataPointImpl> get copyWith =>
      __$$RevenueDataPointImplCopyWithImpl<_$RevenueDataPointImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RevenueDataPointImplToJson(this);
  }
}

abstract class _RevenueDataPoint implements RevenueDataPoint {
  const factory _RevenueDataPoint({
    required final String date,
    required final double revenue,
    required final double proceeds,
  }) = _$RevenueDataPointImpl;

  factory _RevenueDataPoint.fromJson(Map<String, dynamic> json) =
      _$RevenueDataPointImpl.fromJson;

  @override
  String get date;
  @override
  double get revenue;
  @override
  double get proceeds;

  /// Create a copy of RevenueDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RevenueDataPointImplCopyWith<_$RevenueDataPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubscribersDataPoint _$SubscribersDataPointFromJson(Map<String, dynamic> json) {
  return _SubscribersDataPoint.fromJson(json);
}

/// @nodoc
mixin _$SubscribersDataPoint {
  String get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscribers_new')
  int get subscribersNew => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscribers_cancelled')
  int get subscribersCancelled => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscribers_active')
  int get subscribersActive => throw _privateConstructorUsedError;

  /// Serializes this SubscribersDataPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubscribersDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscribersDataPointCopyWith<SubscribersDataPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscribersDataPointCopyWith<$Res> {
  factory $SubscribersDataPointCopyWith(
    SubscribersDataPoint value,
    $Res Function(SubscribersDataPoint) then,
  ) = _$SubscribersDataPointCopyWithImpl<$Res, SubscribersDataPoint>;
  @useResult
  $Res call({
    String date,
    @JsonKey(name: 'subscribers_new') int subscribersNew,
    @JsonKey(name: 'subscribers_cancelled') int subscribersCancelled,
    @JsonKey(name: 'subscribers_active') int subscribersActive,
  });
}

/// @nodoc
class _$SubscribersDataPointCopyWithImpl<
  $Res,
  $Val extends SubscribersDataPoint
>
    implements $SubscribersDataPointCopyWith<$Res> {
  _$SubscribersDataPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscribersDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? subscribersNew = null,
    Object? subscribersCancelled = null,
    Object? subscribersActive = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            subscribersNew: null == subscribersNew
                ? _value.subscribersNew
                : subscribersNew // ignore: cast_nullable_to_non_nullable
                      as int,
            subscribersCancelled: null == subscribersCancelled
                ? _value.subscribersCancelled
                : subscribersCancelled // ignore: cast_nullable_to_non_nullable
                      as int,
            subscribersActive: null == subscribersActive
                ? _value.subscribersActive
                : subscribersActive // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubscribersDataPointImplCopyWith<$Res>
    implements $SubscribersDataPointCopyWith<$Res> {
  factory _$$SubscribersDataPointImplCopyWith(
    _$SubscribersDataPointImpl value,
    $Res Function(_$SubscribersDataPointImpl) then,
  ) = __$$SubscribersDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String date,
    @JsonKey(name: 'subscribers_new') int subscribersNew,
    @JsonKey(name: 'subscribers_cancelled') int subscribersCancelled,
    @JsonKey(name: 'subscribers_active') int subscribersActive,
  });
}

/// @nodoc
class __$$SubscribersDataPointImplCopyWithImpl<$Res>
    extends _$SubscribersDataPointCopyWithImpl<$Res, _$SubscribersDataPointImpl>
    implements _$$SubscribersDataPointImplCopyWith<$Res> {
  __$$SubscribersDataPointImplCopyWithImpl(
    _$SubscribersDataPointImpl _value,
    $Res Function(_$SubscribersDataPointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubscribersDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? subscribersNew = null,
    Object? subscribersCancelled = null,
    Object? subscribersActive = null,
  }) {
    return _then(
      _$SubscribersDataPointImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        subscribersNew: null == subscribersNew
            ? _value.subscribersNew
            : subscribersNew // ignore: cast_nullable_to_non_nullable
                  as int,
        subscribersCancelled: null == subscribersCancelled
            ? _value.subscribersCancelled
            : subscribersCancelled // ignore: cast_nullable_to_non_nullable
                  as int,
        subscribersActive: null == subscribersActive
            ? _value.subscribersActive
            : subscribersActive // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscribersDataPointImpl implements _SubscribersDataPoint {
  const _$SubscribersDataPointImpl({
    required this.date,
    @JsonKey(name: 'subscribers_new') required this.subscribersNew,
    @JsonKey(name: 'subscribers_cancelled') required this.subscribersCancelled,
    @JsonKey(name: 'subscribers_active') required this.subscribersActive,
  });

  factory _$SubscribersDataPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscribersDataPointImplFromJson(json);

  @override
  final String date;
  @override
  @JsonKey(name: 'subscribers_new')
  final int subscribersNew;
  @override
  @JsonKey(name: 'subscribers_cancelled')
  final int subscribersCancelled;
  @override
  @JsonKey(name: 'subscribers_active')
  final int subscribersActive;

  @override
  String toString() {
    return 'SubscribersDataPoint(date: $date, subscribersNew: $subscribersNew, subscribersCancelled: $subscribersCancelled, subscribersActive: $subscribersActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscribersDataPointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.subscribersNew, subscribersNew) ||
                other.subscribersNew == subscribersNew) &&
            (identical(other.subscribersCancelled, subscribersCancelled) ||
                other.subscribersCancelled == subscribersCancelled) &&
            (identical(other.subscribersActive, subscribersActive) ||
                other.subscribersActive == subscribersActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    subscribersNew,
    subscribersCancelled,
    subscribersActive,
  );

  /// Create a copy of SubscribersDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscribersDataPointImplCopyWith<_$SubscribersDataPointImpl>
  get copyWith =>
      __$$SubscribersDataPointImplCopyWithImpl<_$SubscribersDataPointImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscribersDataPointImplToJson(this);
  }
}

abstract class _SubscribersDataPoint implements SubscribersDataPoint {
  const factory _SubscribersDataPoint({
    required final String date,
    @JsonKey(name: 'subscribers_new') required final int subscribersNew,
    @JsonKey(name: 'subscribers_cancelled')
    required final int subscribersCancelled,
    @JsonKey(name: 'subscribers_active') required final int subscribersActive,
  }) = _$SubscribersDataPointImpl;

  factory _SubscribersDataPoint.fromJson(Map<String, dynamic> json) =
      _$SubscribersDataPointImpl.fromJson;

  @override
  String get date;
  @override
  @JsonKey(name: 'subscribers_new')
  int get subscribersNew;
  @override
  @JsonKey(name: 'subscribers_cancelled')
  int get subscribersCancelled;
  @override
  @JsonKey(name: 'subscribers_active')
  int get subscribersActive;

  /// Create a copy of SubscribersDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscribersDataPointImplCopyWith<_$SubscribersDataPointImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CountryAnalytics _$CountryAnalyticsFromJson(Map<String, dynamic> json) {
  return _CountryAnalytics.fromJson(json);
}

/// @nodoc
mixin _$CountryAnalytics {
  @JsonKey(name: 'country_code')
  String get countryCode => throw _privateConstructorUsedError;
  int get downloads => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;
  double get proceeds => throw _privateConstructorUsedError;

  /// Serializes this CountryAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CountryAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CountryAnalyticsCopyWith<CountryAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CountryAnalyticsCopyWith<$Res> {
  factory $CountryAnalyticsCopyWith(
    CountryAnalytics value,
    $Res Function(CountryAnalytics) then,
  ) = _$CountryAnalyticsCopyWithImpl<$Res, CountryAnalytics>;
  @useResult
  $Res call({
    @JsonKey(name: 'country_code') String countryCode,
    int downloads,
    double revenue,
    double proceeds,
  });
}

/// @nodoc
class _$CountryAnalyticsCopyWithImpl<$Res, $Val extends CountryAnalytics>
    implements $CountryAnalyticsCopyWith<$Res> {
  _$CountryAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CountryAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countryCode = null,
    Object? downloads = null,
    Object? revenue = null,
    Object? proceeds = null,
  }) {
    return _then(
      _value.copyWith(
            countryCode: null == countryCode
                ? _value.countryCode
                : countryCode // ignore: cast_nullable_to_non_nullable
                      as String,
            downloads: null == downloads
                ? _value.downloads
                : downloads // ignore: cast_nullable_to_non_nullable
                      as int,
            revenue: null == revenue
                ? _value.revenue
                : revenue // ignore: cast_nullable_to_non_nullable
                      as double,
            proceeds: null == proceeds
                ? _value.proceeds
                : proceeds // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CountryAnalyticsImplCopyWith<$Res>
    implements $CountryAnalyticsCopyWith<$Res> {
  factory _$$CountryAnalyticsImplCopyWith(
    _$CountryAnalyticsImpl value,
    $Res Function(_$CountryAnalyticsImpl) then,
  ) = __$$CountryAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'country_code') String countryCode,
    int downloads,
    double revenue,
    double proceeds,
  });
}

/// @nodoc
class __$$CountryAnalyticsImplCopyWithImpl<$Res>
    extends _$CountryAnalyticsCopyWithImpl<$Res, _$CountryAnalyticsImpl>
    implements _$$CountryAnalyticsImplCopyWith<$Res> {
  __$$CountryAnalyticsImplCopyWithImpl(
    _$CountryAnalyticsImpl _value,
    $Res Function(_$CountryAnalyticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CountryAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countryCode = null,
    Object? downloads = null,
    Object? revenue = null,
    Object? proceeds = null,
  }) {
    return _then(
      _$CountryAnalyticsImpl(
        countryCode: null == countryCode
            ? _value.countryCode
            : countryCode // ignore: cast_nullable_to_non_nullable
                  as String,
        downloads: null == downloads
            ? _value.downloads
            : downloads // ignore: cast_nullable_to_non_nullable
                  as int,
        revenue: null == revenue
            ? _value.revenue
            : revenue // ignore: cast_nullable_to_non_nullable
                  as double,
        proceeds: null == proceeds
            ? _value.proceeds
            : proceeds // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CountryAnalyticsImpl implements _CountryAnalytics {
  const _$CountryAnalyticsImpl({
    @JsonKey(name: 'country_code') required this.countryCode,
    required this.downloads,
    required this.revenue,
    required this.proceeds,
  });

  factory _$CountryAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CountryAnalyticsImplFromJson(json);

  @override
  @JsonKey(name: 'country_code')
  final String countryCode;
  @override
  final int downloads;
  @override
  final double revenue;
  @override
  final double proceeds;

  @override
  String toString() {
    return 'CountryAnalytics(countryCode: $countryCode, downloads: $downloads, revenue: $revenue, proceeds: $proceeds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CountryAnalyticsImpl &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.downloads, downloads) ||
                other.downloads == downloads) &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.proceeds, proceeds) ||
                other.proceeds == proceeds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, countryCode, downloads, revenue, proceeds);

  /// Create a copy of CountryAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CountryAnalyticsImplCopyWith<_$CountryAnalyticsImpl> get copyWith =>
      __$$CountryAnalyticsImplCopyWithImpl<_$CountryAnalyticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CountryAnalyticsImplToJson(this);
  }
}

abstract class _CountryAnalytics implements CountryAnalytics {
  const factory _CountryAnalytics({
    @JsonKey(name: 'country_code') required final String countryCode,
    required final int downloads,
    required final double revenue,
    required final double proceeds,
  }) = _$CountryAnalyticsImpl;

  factory _CountryAnalytics.fromJson(Map<String, dynamic> json) =
      _$CountryAnalyticsImpl.fromJson;

  @override
  @JsonKey(name: 'country_code')
  String get countryCode;
  @override
  int get downloads;
  @override
  double get revenue;
  @override
  double get proceeds;

  /// Create a copy of CountryAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CountryAnalyticsImplCopyWith<_$CountryAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DownloadsChartData _$DownloadsChartDataFromJson(Map<String, dynamic> json) {
  return _DownloadsChartData.fromJson(json);
}

/// @nodoc
mixin _$DownloadsChartData {
  List<DownloadsDataPoint> get current => throw _privateConstructorUsedError;
  List<DownloadsDataPoint> get previous => throw _privateConstructorUsedError;

  /// Serializes this DownloadsChartData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DownloadsChartData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DownloadsChartDataCopyWith<DownloadsChartData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DownloadsChartDataCopyWith<$Res> {
  factory $DownloadsChartDataCopyWith(
    DownloadsChartData value,
    $Res Function(DownloadsChartData) then,
  ) = _$DownloadsChartDataCopyWithImpl<$Res, DownloadsChartData>;
  @useResult
  $Res call({
    List<DownloadsDataPoint> current,
    List<DownloadsDataPoint> previous,
  });
}

/// @nodoc
class _$DownloadsChartDataCopyWithImpl<$Res, $Val extends DownloadsChartData>
    implements $DownloadsChartDataCopyWith<$Res> {
  _$DownloadsChartDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DownloadsChartData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? current = null, Object? previous = null}) {
    return _then(
      _value.copyWith(
            current: null == current
                ? _value.current
                : current // ignore: cast_nullable_to_non_nullable
                      as List<DownloadsDataPoint>,
            previous: null == previous
                ? _value.previous
                : previous // ignore: cast_nullable_to_non_nullable
                      as List<DownloadsDataPoint>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DownloadsChartDataImplCopyWith<$Res>
    implements $DownloadsChartDataCopyWith<$Res> {
  factory _$$DownloadsChartDataImplCopyWith(
    _$DownloadsChartDataImpl value,
    $Res Function(_$DownloadsChartDataImpl) then,
  ) = __$$DownloadsChartDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<DownloadsDataPoint> current,
    List<DownloadsDataPoint> previous,
  });
}

/// @nodoc
class __$$DownloadsChartDataImplCopyWithImpl<$Res>
    extends _$DownloadsChartDataCopyWithImpl<$Res, _$DownloadsChartDataImpl>
    implements _$$DownloadsChartDataImplCopyWith<$Res> {
  __$$DownloadsChartDataImplCopyWithImpl(
    _$DownloadsChartDataImpl _value,
    $Res Function(_$DownloadsChartDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DownloadsChartData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? current = null, Object? previous = null}) {
    return _then(
      _$DownloadsChartDataImpl(
        current: null == current
            ? _value._current
            : current // ignore: cast_nullable_to_non_nullable
                  as List<DownloadsDataPoint>,
        previous: null == previous
            ? _value._previous
            : previous // ignore: cast_nullable_to_non_nullable
                  as List<DownloadsDataPoint>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DownloadsChartDataImpl implements _DownloadsChartData {
  const _$DownloadsChartDataImpl({
    required final List<DownloadsDataPoint> current,
    required final List<DownloadsDataPoint> previous,
  }) : _current = current,
       _previous = previous;

  factory _$DownloadsChartDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$DownloadsChartDataImplFromJson(json);

  final List<DownloadsDataPoint> _current;
  @override
  List<DownloadsDataPoint> get current {
    if (_current is EqualUnmodifiableListView) return _current;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_current);
  }

  final List<DownloadsDataPoint> _previous;
  @override
  List<DownloadsDataPoint> get previous {
    if (_previous is EqualUnmodifiableListView) return _previous;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_previous);
  }

  @override
  String toString() {
    return 'DownloadsChartData(current: $current, previous: $previous)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DownloadsChartDataImpl &&
            const DeepCollectionEquality().equals(other._current, _current) &&
            const DeepCollectionEquality().equals(other._previous, _previous));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_current),
    const DeepCollectionEquality().hash(_previous),
  );

  /// Create a copy of DownloadsChartData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadsChartDataImplCopyWith<_$DownloadsChartDataImpl> get copyWith =>
      __$$DownloadsChartDataImplCopyWithImpl<_$DownloadsChartDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DownloadsChartDataImplToJson(this);
  }
}

abstract class _DownloadsChartData implements DownloadsChartData {
  const factory _DownloadsChartData({
    required final List<DownloadsDataPoint> current,
    required final List<DownloadsDataPoint> previous,
  }) = _$DownloadsChartDataImpl;

  factory _DownloadsChartData.fromJson(Map<String, dynamic> json) =
      _$DownloadsChartDataImpl.fromJson;

  @override
  List<DownloadsDataPoint> get current;
  @override
  List<DownloadsDataPoint> get previous;

  /// Create a copy of DownloadsChartData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DownloadsChartDataImplCopyWith<_$DownloadsChartDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RevenueChartData _$RevenueChartDataFromJson(Map<String, dynamic> json) {
  return _RevenueChartData.fromJson(json);
}

/// @nodoc
mixin _$RevenueChartData {
  List<RevenueDataPoint> get current => throw _privateConstructorUsedError;
  List<RevenueDataPoint> get previous => throw _privateConstructorUsedError;

  /// Serializes this RevenueChartData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RevenueChartData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RevenueChartDataCopyWith<RevenueChartData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RevenueChartDataCopyWith<$Res> {
  factory $RevenueChartDataCopyWith(
    RevenueChartData value,
    $Res Function(RevenueChartData) then,
  ) = _$RevenueChartDataCopyWithImpl<$Res, RevenueChartData>;
  @useResult
  $Res call({List<RevenueDataPoint> current, List<RevenueDataPoint> previous});
}

/// @nodoc
class _$RevenueChartDataCopyWithImpl<$Res, $Val extends RevenueChartData>
    implements $RevenueChartDataCopyWith<$Res> {
  _$RevenueChartDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RevenueChartData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? current = null, Object? previous = null}) {
    return _then(
      _value.copyWith(
            current: null == current
                ? _value.current
                : current // ignore: cast_nullable_to_non_nullable
                      as List<RevenueDataPoint>,
            previous: null == previous
                ? _value.previous
                : previous // ignore: cast_nullable_to_non_nullable
                      as List<RevenueDataPoint>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RevenueChartDataImplCopyWith<$Res>
    implements $RevenueChartDataCopyWith<$Res> {
  factory _$$RevenueChartDataImplCopyWith(
    _$RevenueChartDataImpl value,
    $Res Function(_$RevenueChartDataImpl) then,
  ) = __$$RevenueChartDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<RevenueDataPoint> current, List<RevenueDataPoint> previous});
}

/// @nodoc
class __$$RevenueChartDataImplCopyWithImpl<$Res>
    extends _$RevenueChartDataCopyWithImpl<$Res, _$RevenueChartDataImpl>
    implements _$$RevenueChartDataImplCopyWith<$Res> {
  __$$RevenueChartDataImplCopyWithImpl(
    _$RevenueChartDataImpl _value,
    $Res Function(_$RevenueChartDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RevenueChartData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? current = null, Object? previous = null}) {
    return _then(
      _$RevenueChartDataImpl(
        current: null == current
            ? _value._current
            : current // ignore: cast_nullable_to_non_nullable
                  as List<RevenueDataPoint>,
        previous: null == previous
            ? _value._previous
            : previous // ignore: cast_nullable_to_non_nullable
                  as List<RevenueDataPoint>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RevenueChartDataImpl implements _RevenueChartData {
  const _$RevenueChartDataImpl({
    required final List<RevenueDataPoint> current,
    required final List<RevenueDataPoint> previous,
  }) : _current = current,
       _previous = previous;

  factory _$RevenueChartDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RevenueChartDataImplFromJson(json);

  final List<RevenueDataPoint> _current;
  @override
  List<RevenueDataPoint> get current {
    if (_current is EqualUnmodifiableListView) return _current;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_current);
  }

  final List<RevenueDataPoint> _previous;
  @override
  List<RevenueDataPoint> get previous {
    if (_previous is EqualUnmodifiableListView) return _previous;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_previous);
  }

  @override
  String toString() {
    return 'RevenueChartData(current: $current, previous: $previous)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RevenueChartDataImpl &&
            const DeepCollectionEquality().equals(other._current, _current) &&
            const DeepCollectionEquality().equals(other._previous, _previous));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_current),
    const DeepCollectionEquality().hash(_previous),
  );

  /// Create a copy of RevenueChartData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RevenueChartDataImplCopyWith<_$RevenueChartDataImpl> get copyWith =>
      __$$RevenueChartDataImplCopyWithImpl<_$RevenueChartDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RevenueChartDataImplToJson(this);
  }
}

abstract class _RevenueChartData implements RevenueChartData {
  const factory _RevenueChartData({
    required final List<RevenueDataPoint> current,
    required final List<RevenueDataPoint> previous,
  }) = _$RevenueChartDataImpl;

  factory _RevenueChartData.fromJson(Map<String, dynamic> json) =
      _$RevenueChartDataImpl.fromJson;

  @override
  List<RevenueDataPoint> get current;
  @override
  List<RevenueDataPoint> get previous;

  /// Create a copy of RevenueChartData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RevenueChartDataImplCopyWith<_$RevenueChartDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
