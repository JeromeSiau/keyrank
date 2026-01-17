// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversion_funnel_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ConversionFunnel _$ConversionFunnelFromJson(Map<String, dynamic> json) {
  return _ConversionFunnel.fromJson(json);
}

/// @nodoc
mixin _$ConversionFunnel {
  FunnelSummary get summary => throw _privateConstructorUsedError;
  @JsonKey(name: 'by_source')
  List<SourceConversion> get bySource => throw _privateConstructorUsedError;
  List<FunnelDataPoint> get trend => throw _privateConstructorUsedError;
  FunnelComparison get comparison => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_data')
  bool get hasData => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this ConversionFunnel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversionFunnel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversionFunnelCopyWith<ConversionFunnel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversionFunnelCopyWith<$Res> {
  factory $ConversionFunnelCopyWith(
    ConversionFunnel value,
    $Res Function(ConversionFunnel) then,
  ) = _$ConversionFunnelCopyWithImpl<$Res, ConversionFunnel>;
  @useResult
  $Res call({
    FunnelSummary summary,
    @JsonKey(name: 'by_source') List<SourceConversion> bySource,
    List<FunnelDataPoint> trend,
    FunnelComparison comparison,
    @JsonKey(name: 'has_data') bool hasData,
    String? message,
  });

  $FunnelSummaryCopyWith<$Res> get summary;
  $FunnelComparisonCopyWith<$Res> get comparison;
}

/// @nodoc
class _$ConversionFunnelCopyWithImpl<$Res, $Val extends ConversionFunnel>
    implements $ConversionFunnelCopyWith<$Res> {
  _$ConversionFunnelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversionFunnel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? bySource = null,
    Object? trend = null,
    Object? comparison = null,
    Object? hasData = null,
    Object? message = freezed,
  }) {
    return _then(
      _value.copyWith(
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as FunnelSummary,
            bySource: null == bySource
                ? _value.bySource
                : bySource // ignore: cast_nullable_to_non_nullable
                      as List<SourceConversion>,
            trend: null == trend
                ? _value.trend
                : trend // ignore: cast_nullable_to_non_nullable
                      as List<FunnelDataPoint>,
            comparison: null == comparison
                ? _value.comparison
                : comparison // ignore: cast_nullable_to_non_nullable
                      as FunnelComparison,
            hasData: null == hasData
                ? _value.hasData
                : hasData // ignore: cast_nullable_to_non_nullable
                      as bool,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of ConversionFunnel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FunnelSummaryCopyWith<$Res> get summary {
    return $FunnelSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }

  /// Create a copy of ConversionFunnel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FunnelComparisonCopyWith<$Res> get comparison {
    return $FunnelComparisonCopyWith<$Res>(_value.comparison, (value) {
      return _then(_value.copyWith(comparison: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversionFunnelImplCopyWith<$Res>
    implements $ConversionFunnelCopyWith<$Res> {
  factory _$$ConversionFunnelImplCopyWith(
    _$ConversionFunnelImpl value,
    $Res Function(_$ConversionFunnelImpl) then,
  ) = __$$ConversionFunnelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    FunnelSummary summary,
    @JsonKey(name: 'by_source') List<SourceConversion> bySource,
    List<FunnelDataPoint> trend,
    FunnelComparison comparison,
    @JsonKey(name: 'has_data') bool hasData,
    String? message,
  });

  @override
  $FunnelSummaryCopyWith<$Res> get summary;
  @override
  $FunnelComparisonCopyWith<$Res> get comparison;
}

/// @nodoc
class __$$ConversionFunnelImplCopyWithImpl<$Res>
    extends _$ConversionFunnelCopyWithImpl<$Res, _$ConversionFunnelImpl>
    implements _$$ConversionFunnelImplCopyWith<$Res> {
  __$$ConversionFunnelImplCopyWithImpl(
    _$ConversionFunnelImpl _value,
    $Res Function(_$ConversionFunnelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConversionFunnel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? bySource = null,
    Object? trend = null,
    Object? comparison = null,
    Object? hasData = null,
    Object? message = freezed,
  }) {
    return _then(
      _$ConversionFunnelImpl(
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as FunnelSummary,
        bySource: null == bySource
            ? _value._bySource
            : bySource // ignore: cast_nullable_to_non_nullable
                  as List<SourceConversion>,
        trend: null == trend
            ? _value._trend
            : trend // ignore: cast_nullable_to_non_nullable
                  as List<FunnelDataPoint>,
        comparison: null == comparison
            ? _value.comparison
            : comparison // ignore: cast_nullable_to_non_nullable
                  as FunnelComparison,
        hasData: null == hasData
            ? _value.hasData
            : hasData // ignore: cast_nullable_to_non_nullable
                  as bool,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversionFunnelImpl implements _ConversionFunnel {
  const _$ConversionFunnelImpl({
    required this.summary,
    @JsonKey(name: 'by_source') required final List<SourceConversion> bySource,
    required final List<FunnelDataPoint> trend,
    required this.comparison,
    @JsonKey(name: 'has_data') this.hasData = true,
    this.message,
  }) : _bySource = bySource,
       _trend = trend;

  factory _$ConversionFunnelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversionFunnelImplFromJson(json);

  @override
  final FunnelSummary summary;
  final List<SourceConversion> _bySource;
  @override
  @JsonKey(name: 'by_source')
  List<SourceConversion> get bySource {
    if (_bySource is EqualUnmodifiableListView) return _bySource;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bySource);
  }

  final List<FunnelDataPoint> _trend;
  @override
  List<FunnelDataPoint> get trend {
    if (_trend is EqualUnmodifiableListView) return _trend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trend);
  }

  @override
  final FunnelComparison comparison;
  @override
  @JsonKey(name: 'has_data')
  final bool hasData;
  @override
  final String? message;

  @override
  String toString() {
    return 'ConversionFunnel(summary: $summary, bySource: $bySource, trend: $trend, comparison: $comparison, hasData: $hasData, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversionFunnelImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(other._bySource, _bySource) &&
            const DeepCollectionEquality().equals(other._trend, _trend) &&
            (identical(other.comparison, comparison) ||
                other.comparison == comparison) &&
            (identical(other.hasData, hasData) || other.hasData == hasData) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    summary,
    const DeepCollectionEquality().hash(_bySource),
    const DeepCollectionEquality().hash(_trend),
    comparison,
    hasData,
    message,
  );

  /// Create a copy of ConversionFunnel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversionFunnelImplCopyWith<_$ConversionFunnelImpl> get copyWith =>
      __$$ConversionFunnelImplCopyWithImpl<_$ConversionFunnelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversionFunnelImplToJson(this);
  }
}

abstract class _ConversionFunnel implements ConversionFunnel {
  const factory _ConversionFunnel({
    required final FunnelSummary summary,
    @JsonKey(name: 'by_source') required final List<SourceConversion> bySource,
    required final List<FunnelDataPoint> trend,
    required final FunnelComparison comparison,
    @JsonKey(name: 'has_data') final bool hasData,
    final String? message,
  }) = _$ConversionFunnelImpl;

  factory _ConversionFunnel.fromJson(Map<String, dynamic> json) =
      _$ConversionFunnelImpl.fromJson;

  @override
  FunnelSummary get summary;
  @override
  @JsonKey(name: 'by_source')
  List<SourceConversion> get bySource;
  @override
  List<FunnelDataPoint> get trend;
  @override
  FunnelComparison get comparison;
  @override
  @JsonKey(name: 'has_data')
  bool get hasData;
  @override
  String? get message;

  /// Create a copy of ConversionFunnel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversionFunnelImplCopyWith<_$ConversionFunnelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FunnelSummary _$FunnelSummaryFromJson(Map<String, dynamic> json) {
  return _FunnelSummary.fromJson(json);
}

/// @nodoc
mixin _$FunnelSummary {
  int get impressions => throw _privateConstructorUsedError;
  @JsonKey(name: 'page_views')
  int get pageViews => throw _privateConstructorUsedError;
  int get downloads => throw _privateConstructorUsedError;
  @JsonKey(name: 'impression_to_page_view_rate')
  double get impressionToPageViewRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'page_view_to_download_rate')
  double get pageViewToDownloadRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'overall_conversion_rate')
  double get overallConversionRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_average')
  double? get categoryAverage => throw _privateConstructorUsedError;
  @JsonKey(name: 'vs_category')
  String? get vsCategory => throw _privateConstructorUsedError;

  /// Serializes this FunnelSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FunnelSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FunnelSummaryCopyWith<FunnelSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FunnelSummaryCopyWith<$Res> {
  factory $FunnelSummaryCopyWith(
    FunnelSummary value,
    $Res Function(FunnelSummary) then,
  ) = _$FunnelSummaryCopyWithImpl<$Res, FunnelSummary>;
  @useResult
  $Res call({
    int impressions,
    @JsonKey(name: 'page_views') int pageViews,
    int downloads,
    @JsonKey(name: 'impression_to_page_view_rate')
    double impressionToPageViewRate,
    @JsonKey(name: 'page_view_to_download_rate') double pageViewToDownloadRate,
    @JsonKey(name: 'overall_conversion_rate') double overallConversionRate,
    @JsonKey(name: 'category_average') double? categoryAverage,
    @JsonKey(name: 'vs_category') String? vsCategory,
  });
}

/// @nodoc
class _$FunnelSummaryCopyWithImpl<$Res, $Val extends FunnelSummary>
    implements $FunnelSummaryCopyWith<$Res> {
  _$FunnelSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FunnelSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? impressions = null,
    Object? pageViews = null,
    Object? downloads = null,
    Object? impressionToPageViewRate = null,
    Object? pageViewToDownloadRate = null,
    Object? overallConversionRate = null,
    Object? categoryAverage = freezed,
    Object? vsCategory = freezed,
  }) {
    return _then(
      _value.copyWith(
            impressions: null == impressions
                ? _value.impressions
                : impressions // ignore: cast_nullable_to_non_nullable
                      as int,
            pageViews: null == pageViews
                ? _value.pageViews
                : pageViews // ignore: cast_nullable_to_non_nullable
                      as int,
            downloads: null == downloads
                ? _value.downloads
                : downloads // ignore: cast_nullable_to_non_nullable
                      as int,
            impressionToPageViewRate: null == impressionToPageViewRate
                ? _value.impressionToPageViewRate
                : impressionToPageViewRate // ignore: cast_nullable_to_non_nullable
                      as double,
            pageViewToDownloadRate: null == pageViewToDownloadRate
                ? _value.pageViewToDownloadRate
                : pageViewToDownloadRate // ignore: cast_nullable_to_non_nullable
                      as double,
            overallConversionRate: null == overallConversionRate
                ? _value.overallConversionRate
                : overallConversionRate // ignore: cast_nullable_to_non_nullable
                      as double,
            categoryAverage: freezed == categoryAverage
                ? _value.categoryAverage
                : categoryAverage // ignore: cast_nullable_to_non_nullable
                      as double?,
            vsCategory: freezed == vsCategory
                ? _value.vsCategory
                : vsCategory // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FunnelSummaryImplCopyWith<$Res>
    implements $FunnelSummaryCopyWith<$Res> {
  factory _$$FunnelSummaryImplCopyWith(
    _$FunnelSummaryImpl value,
    $Res Function(_$FunnelSummaryImpl) then,
  ) = __$$FunnelSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int impressions,
    @JsonKey(name: 'page_views') int pageViews,
    int downloads,
    @JsonKey(name: 'impression_to_page_view_rate')
    double impressionToPageViewRate,
    @JsonKey(name: 'page_view_to_download_rate') double pageViewToDownloadRate,
    @JsonKey(name: 'overall_conversion_rate') double overallConversionRate,
    @JsonKey(name: 'category_average') double? categoryAverage,
    @JsonKey(name: 'vs_category') String? vsCategory,
  });
}

/// @nodoc
class __$$FunnelSummaryImplCopyWithImpl<$Res>
    extends _$FunnelSummaryCopyWithImpl<$Res, _$FunnelSummaryImpl>
    implements _$$FunnelSummaryImplCopyWith<$Res> {
  __$$FunnelSummaryImplCopyWithImpl(
    _$FunnelSummaryImpl _value,
    $Res Function(_$FunnelSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FunnelSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? impressions = null,
    Object? pageViews = null,
    Object? downloads = null,
    Object? impressionToPageViewRate = null,
    Object? pageViewToDownloadRate = null,
    Object? overallConversionRate = null,
    Object? categoryAverage = freezed,
    Object? vsCategory = freezed,
  }) {
    return _then(
      _$FunnelSummaryImpl(
        impressions: null == impressions
            ? _value.impressions
            : impressions // ignore: cast_nullable_to_non_nullable
                  as int,
        pageViews: null == pageViews
            ? _value.pageViews
            : pageViews // ignore: cast_nullable_to_non_nullable
                  as int,
        downloads: null == downloads
            ? _value.downloads
            : downloads // ignore: cast_nullable_to_non_nullable
                  as int,
        impressionToPageViewRate: null == impressionToPageViewRate
            ? _value.impressionToPageViewRate
            : impressionToPageViewRate // ignore: cast_nullable_to_non_nullable
                  as double,
        pageViewToDownloadRate: null == pageViewToDownloadRate
            ? _value.pageViewToDownloadRate
            : pageViewToDownloadRate // ignore: cast_nullable_to_non_nullable
                  as double,
        overallConversionRate: null == overallConversionRate
            ? _value.overallConversionRate
            : overallConversionRate // ignore: cast_nullable_to_non_nullable
                  as double,
        categoryAverage: freezed == categoryAverage
            ? _value.categoryAverage
            : categoryAverage // ignore: cast_nullable_to_non_nullable
                  as double?,
        vsCategory: freezed == vsCategory
            ? _value.vsCategory
            : vsCategory // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FunnelSummaryImpl implements _FunnelSummary {
  const _$FunnelSummaryImpl({
    required this.impressions,
    @JsonKey(name: 'page_views') required this.pageViews,
    required this.downloads,
    @JsonKey(name: 'impression_to_page_view_rate')
    required this.impressionToPageViewRate,
    @JsonKey(name: 'page_view_to_download_rate')
    required this.pageViewToDownloadRate,
    @JsonKey(name: 'overall_conversion_rate')
    required this.overallConversionRate,
    @JsonKey(name: 'category_average') this.categoryAverage,
    @JsonKey(name: 'vs_category') this.vsCategory,
  });

  factory _$FunnelSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$FunnelSummaryImplFromJson(json);

  @override
  final int impressions;
  @override
  @JsonKey(name: 'page_views')
  final int pageViews;
  @override
  final int downloads;
  @override
  @JsonKey(name: 'impression_to_page_view_rate')
  final double impressionToPageViewRate;
  @override
  @JsonKey(name: 'page_view_to_download_rate')
  final double pageViewToDownloadRate;
  @override
  @JsonKey(name: 'overall_conversion_rate')
  final double overallConversionRate;
  @override
  @JsonKey(name: 'category_average')
  final double? categoryAverage;
  @override
  @JsonKey(name: 'vs_category')
  final String? vsCategory;

  @override
  String toString() {
    return 'FunnelSummary(impressions: $impressions, pageViews: $pageViews, downloads: $downloads, impressionToPageViewRate: $impressionToPageViewRate, pageViewToDownloadRate: $pageViewToDownloadRate, overallConversionRate: $overallConversionRate, categoryAverage: $categoryAverage, vsCategory: $vsCategory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FunnelSummaryImpl &&
            (identical(other.impressions, impressions) ||
                other.impressions == impressions) &&
            (identical(other.pageViews, pageViews) ||
                other.pageViews == pageViews) &&
            (identical(other.downloads, downloads) ||
                other.downloads == downloads) &&
            (identical(
                  other.impressionToPageViewRate,
                  impressionToPageViewRate,
                ) ||
                other.impressionToPageViewRate == impressionToPageViewRate) &&
            (identical(other.pageViewToDownloadRate, pageViewToDownloadRate) ||
                other.pageViewToDownloadRate == pageViewToDownloadRate) &&
            (identical(other.overallConversionRate, overallConversionRate) ||
                other.overallConversionRate == overallConversionRate) &&
            (identical(other.categoryAverage, categoryAverage) ||
                other.categoryAverage == categoryAverage) &&
            (identical(other.vsCategory, vsCategory) ||
                other.vsCategory == vsCategory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    impressions,
    pageViews,
    downloads,
    impressionToPageViewRate,
    pageViewToDownloadRate,
    overallConversionRate,
    categoryAverage,
    vsCategory,
  );

  /// Create a copy of FunnelSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FunnelSummaryImplCopyWith<_$FunnelSummaryImpl> get copyWith =>
      __$$FunnelSummaryImplCopyWithImpl<_$FunnelSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FunnelSummaryImplToJson(this);
  }
}

abstract class _FunnelSummary implements FunnelSummary {
  const factory _FunnelSummary({
    required final int impressions,
    @JsonKey(name: 'page_views') required final int pageViews,
    required final int downloads,
    @JsonKey(name: 'impression_to_page_view_rate')
    required final double impressionToPageViewRate,
    @JsonKey(name: 'page_view_to_download_rate')
    required final double pageViewToDownloadRate,
    @JsonKey(name: 'overall_conversion_rate')
    required final double overallConversionRate,
    @JsonKey(name: 'category_average') final double? categoryAverage,
    @JsonKey(name: 'vs_category') final String? vsCategory,
  }) = _$FunnelSummaryImpl;

  factory _FunnelSummary.fromJson(Map<String, dynamic> json) =
      _$FunnelSummaryImpl.fromJson;

  @override
  int get impressions;
  @override
  @JsonKey(name: 'page_views')
  int get pageViews;
  @override
  int get downloads;
  @override
  @JsonKey(name: 'impression_to_page_view_rate')
  double get impressionToPageViewRate;
  @override
  @JsonKey(name: 'page_view_to_download_rate')
  double get pageViewToDownloadRate;
  @override
  @JsonKey(name: 'overall_conversion_rate')
  double get overallConversionRate;
  @override
  @JsonKey(name: 'category_average')
  double? get categoryAverage;
  @override
  @JsonKey(name: 'vs_category')
  String? get vsCategory;

  /// Create a copy of FunnelSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FunnelSummaryImplCopyWith<_$FunnelSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SourceConversion _$SourceConversionFromJson(Map<String, dynamic> json) {
  return _SourceConversion.fromJson(json);
}

/// @nodoc
mixin _$SourceConversion {
  String get source => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_label')
  String get sourceLabel => throw _privateConstructorUsedError;
  int get impressions => throw _privateConstructorUsedError;
  @JsonKey(name: 'page_views')
  int get pageViews => throw _privateConstructorUsedError;
  int get downloads => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversion_rate')
  double get conversionRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'percentage_of_total')
  double get percentageOfTotal => throw _privateConstructorUsedError;

  /// Serializes this SourceConversion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SourceConversion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SourceConversionCopyWith<SourceConversion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SourceConversionCopyWith<$Res> {
  factory $SourceConversionCopyWith(
    SourceConversion value,
    $Res Function(SourceConversion) then,
  ) = _$SourceConversionCopyWithImpl<$Res, SourceConversion>;
  @useResult
  $Res call({
    String source,
    @JsonKey(name: 'source_label') String sourceLabel,
    int impressions,
    @JsonKey(name: 'page_views') int pageViews,
    int downloads,
    @JsonKey(name: 'conversion_rate') double conversionRate,
    @JsonKey(name: 'percentage_of_total') double percentageOfTotal,
  });
}

/// @nodoc
class _$SourceConversionCopyWithImpl<$Res, $Val extends SourceConversion>
    implements $SourceConversionCopyWith<$Res> {
  _$SourceConversionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SourceConversion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? source = null,
    Object? sourceLabel = null,
    Object? impressions = null,
    Object? pageViews = null,
    Object? downloads = null,
    Object? conversionRate = null,
    Object? percentageOfTotal = null,
  }) {
    return _then(
      _value.copyWith(
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as String,
            sourceLabel: null == sourceLabel
                ? _value.sourceLabel
                : sourceLabel // ignore: cast_nullable_to_non_nullable
                      as String,
            impressions: null == impressions
                ? _value.impressions
                : impressions // ignore: cast_nullable_to_non_nullable
                      as int,
            pageViews: null == pageViews
                ? _value.pageViews
                : pageViews // ignore: cast_nullable_to_non_nullable
                      as int,
            downloads: null == downloads
                ? _value.downloads
                : downloads // ignore: cast_nullable_to_non_nullable
                      as int,
            conversionRate: null == conversionRate
                ? _value.conversionRate
                : conversionRate // ignore: cast_nullable_to_non_nullable
                      as double,
            percentageOfTotal: null == percentageOfTotal
                ? _value.percentageOfTotal
                : percentageOfTotal // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SourceConversionImplCopyWith<$Res>
    implements $SourceConversionCopyWith<$Res> {
  factory _$$SourceConversionImplCopyWith(
    _$SourceConversionImpl value,
    $Res Function(_$SourceConversionImpl) then,
  ) = __$$SourceConversionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String source,
    @JsonKey(name: 'source_label') String sourceLabel,
    int impressions,
    @JsonKey(name: 'page_views') int pageViews,
    int downloads,
    @JsonKey(name: 'conversion_rate') double conversionRate,
    @JsonKey(name: 'percentage_of_total') double percentageOfTotal,
  });
}

/// @nodoc
class __$$SourceConversionImplCopyWithImpl<$Res>
    extends _$SourceConversionCopyWithImpl<$Res, _$SourceConversionImpl>
    implements _$$SourceConversionImplCopyWith<$Res> {
  __$$SourceConversionImplCopyWithImpl(
    _$SourceConversionImpl _value,
    $Res Function(_$SourceConversionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SourceConversion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? source = null,
    Object? sourceLabel = null,
    Object? impressions = null,
    Object? pageViews = null,
    Object? downloads = null,
    Object? conversionRate = null,
    Object? percentageOfTotal = null,
  }) {
    return _then(
      _$SourceConversionImpl(
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String,
        sourceLabel: null == sourceLabel
            ? _value.sourceLabel
            : sourceLabel // ignore: cast_nullable_to_non_nullable
                  as String,
        impressions: null == impressions
            ? _value.impressions
            : impressions // ignore: cast_nullable_to_non_nullable
                  as int,
        pageViews: null == pageViews
            ? _value.pageViews
            : pageViews // ignore: cast_nullable_to_non_nullable
                  as int,
        downloads: null == downloads
            ? _value.downloads
            : downloads // ignore: cast_nullable_to_non_nullable
                  as int,
        conversionRate: null == conversionRate
            ? _value.conversionRate
            : conversionRate // ignore: cast_nullable_to_non_nullable
                  as double,
        percentageOfTotal: null == percentageOfTotal
            ? _value.percentageOfTotal
            : percentageOfTotal // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SourceConversionImpl implements _SourceConversion {
  const _$SourceConversionImpl({
    required this.source,
    @JsonKey(name: 'source_label') required this.sourceLabel,
    required this.impressions,
    @JsonKey(name: 'page_views') required this.pageViews,
    required this.downloads,
    @JsonKey(name: 'conversion_rate') required this.conversionRate,
    @JsonKey(name: 'percentage_of_total') required this.percentageOfTotal,
  });

  factory _$SourceConversionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SourceConversionImplFromJson(json);

  @override
  final String source;
  @override
  @JsonKey(name: 'source_label')
  final String sourceLabel;
  @override
  final int impressions;
  @override
  @JsonKey(name: 'page_views')
  final int pageViews;
  @override
  final int downloads;
  @override
  @JsonKey(name: 'conversion_rate')
  final double conversionRate;
  @override
  @JsonKey(name: 'percentage_of_total')
  final double percentageOfTotal;

  @override
  String toString() {
    return 'SourceConversion(source: $source, sourceLabel: $sourceLabel, impressions: $impressions, pageViews: $pageViews, downloads: $downloads, conversionRate: $conversionRate, percentageOfTotal: $percentageOfTotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SourceConversionImpl &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.sourceLabel, sourceLabel) ||
                other.sourceLabel == sourceLabel) &&
            (identical(other.impressions, impressions) ||
                other.impressions == impressions) &&
            (identical(other.pageViews, pageViews) ||
                other.pageViews == pageViews) &&
            (identical(other.downloads, downloads) ||
                other.downloads == downloads) &&
            (identical(other.conversionRate, conversionRate) ||
                other.conversionRate == conversionRate) &&
            (identical(other.percentageOfTotal, percentageOfTotal) ||
                other.percentageOfTotal == percentageOfTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    source,
    sourceLabel,
    impressions,
    pageViews,
    downloads,
    conversionRate,
    percentageOfTotal,
  );

  /// Create a copy of SourceConversion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SourceConversionImplCopyWith<_$SourceConversionImpl> get copyWith =>
      __$$SourceConversionImplCopyWithImpl<_$SourceConversionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SourceConversionImplToJson(this);
  }
}

abstract class _SourceConversion implements SourceConversion {
  const factory _SourceConversion({
    required final String source,
    @JsonKey(name: 'source_label') required final String sourceLabel,
    required final int impressions,
    @JsonKey(name: 'page_views') required final int pageViews,
    required final int downloads,
    @JsonKey(name: 'conversion_rate') required final double conversionRate,
    @JsonKey(name: 'percentage_of_total')
    required final double percentageOfTotal,
  }) = _$SourceConversionImpl;

  factory _SourceConversion.fromJson(Map<String, dynamic> json) =
      _$SourceConversionImpl.fromJson;

  @override
  String get source;
  @override
  @JsonKey(name: 'source_label')
  String get sourceLabel;
  @override
  int get impressions;
  @override
  @JsonKey(name: 'page_views')
  int get pageViews;
  @override
  int get downloads;
  @override
  @JsonKey(name: 'conversion_rate')
  double get conversionRate;
  @override
  @JsonKey(name: 'percentage_of_total')
  double get percentageOfTotal;

  /// Create a copy of SourceConversion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SourceConversionImplCopyWith<_$SourceConversionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FunnelDataPoint _$FunnelDataPointFromJson(Map<String, dynamic> json) {
  return _FunnelDataPoint.fromJson(json);
}

/// @nodoc
mixin _$FunnelDataPoint {
  String get date => throw _privateConstructorUsedError;
  int get impressions => throw _privateConstructorUsedError;
  @JsonKey(name: 'page_views')
  int get pageViews => throw _privateConstructorUsedError;
  int get downloads => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversion_rate')
  double get conversionRate => throw _privateConstructorUsedError;

  /// Serializes this FunnelDataPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FunnelDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FunnelDataPointCopyWith<FunnelDataPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FunnelDataPointCopyWith<$Res> {
  factory $FunnelDataPointCopyWith(
    FunnelDataPoint value,
    $Res Function(FunnelDataPoint) then,
  ) = _$FunnelDataPointCopyWithImpl<$Res, FunnelDataPoint>;
  @useResult
  $Res call({
    String date,
    int impressions,
    @JsonKey(name: 'page_views') int pageViews,
    int downloads,
    @JsonKey(name: 'conversion_rate') double conversionRate,
  });
}

/// @nodoc
class _$FunnelDataPointCopyWithImpl<$Res, $Val extends FunnelDataPoint>
    implements $FunnelDataPointCopyWith<$Res> {
  _$FunnelDataPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FunnelDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? impressions = null,
    Object? pageViews = null,
    Object? downloads = null,
    Object? conversionRate = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            impressions: null == impressions
                ? _value.impressions
                : impressions // ignore: cast_nullable_to_non_nullable
                      as int,
            pageViews: null == pageViews
                ? _value.pageViews
                : pageViews // ignore: cast_nullable_to_non_nullable
                      as int,
            downloads: null == downloads
                ? _value.downloads
                : downloads // ignore: cast_nullable_to_non_nullable
                      as int,
            conversionRate: null == conversionRate
                ? _value.conversionRate
                : conversionRate // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FunnelDataPointImplCopyWith<$Res>
    implements $FunnelDataPointCopyWith<$Res> {
  factory _$$FunnelDataPointImplCopyWith(
    _$FunnelDataPointImpl value,
    $Res Function(_$FunnelDataPointImpl) then,
  ) = __$$FunnelDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String date,
    int impressions,
    @JsonKey(name: 'page_views') int pageViews,
    int downloads,
    @JsonKey(name: 'conversion_rate') double conversionRate,
  });
}

/// @nodoc
class __$$FunnelDataPointImplCopyWithImpl<$Res>
    extends _$FunnelDataPointCopyWithImpl<$Res, _$FunnelDataPointImpl>
    implements _$$FunnelDataPointImplCopyWith<$Res> {
  __$$FunnelDataPointImplCopyWithImpl(
    _$FunnelDataPointImpl _value,
    $Res Function(_$FunnelDataPointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FunnelDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? impressions = null,
    Object? pageViews = null,
    Object? downloads = null,
    Object? conversionRate = null,
  }) {
    return _then(
      _$FunnelDataPointImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        impressions: null == impressions
            ? _value.impressions
            : impressions // ignore: cast_nullable_to_non_nullable
                  as int,
        pageViews: null == pageViews
            ? _value.pageViews
            : pageViews // ignore: cast_nullable_to_non_nullable
                  as int,
        downloads: null == downloads
            ? _value.downloads
            : downloads // ignore: cast_nullable_to_non_nullable
                  as int,
        conversionRate: null == conversionRate
            ? _value.conversionRate
            : conversionRate // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FunnelDataPointImpl implements _FunnelDataPoint {
  const _$FunnelDataPointImpl({
    required this.date,
    required this.impressions,
    @JsonKey(name: 'page_views') required this.pageViews,
    required this.downloads,
    @JsonKey(name: 'conversion_rate') required this.conversionRate,
  });

  factory _$FunnelDataPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$FunnelDataPointImplFromJson(json);

  @override
  final String date;
  @override
  final int impressions;
  @override
  @JsonKey(name: 'page_views')
  final int pageViews;
  @override
  final int downloads;
  @override
  @JsonKey(name: 'conversion_rate')
  final double conversionRate;

  @override
  String toString() {
    return 'FunnelDataPoint(date: $date, impressions: $impressions, pageViews: $pageViews, downloads: $downloads, conversionRate: $conversionRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FunnelDataPointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.impressions, impressions) ||
                other.impressions == impressions) &&
            (identical(other.pageViews, pageViews) ||
                other.pageViews == pageViews) &&
            (identical(other.downloads, downloads) ||
                other.downloads == downloads) &&
            (identical(other.conversionRate, conversionRate) ||
                other.conversionRate == conversionRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    impressions,
    pageViews,
    downloads,
    conversionRate,
  );

  /// Create a copy of FunnelDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FunnelDataPointImplCopyWith<_$FunnelDataPointImpl> get copyWith =>
      __$$FunnelDataPointImplCopyWithImpl<_$FunnelDataPointImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FunnelDataPointImplToJson(this);
  }
}

abstract class _FunnelDataPoint implements FunnelDataPoint {
  const factory _FunnelDataPoint({
    required final String date,
    required final int impressions,
    @JsonKey(name: 'page_views') required final int pageViews,
    required final int downloads,
    @JsonKey(name: 'conversion_rate') required final double conversionRate,
  }) = _$FunnelDataPointImpl;

  factory _FunnelDataPoint.fromJson(Map<String, dynamic> json) =
      _$FunnelDataPointImpl.fromJson;

  @override
  String get date;
  @override
  int get impressions;
  @override
  @JsonKey(name: 'page_views')
  int get pageViews;
  @override
  int get downloads;
  @override
  @JsonKey(name: 'conversion_rate')
  double get conversionRate;

  /// Create a copy of FunnelDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FunnelDataPointImplCopyWith<_$FunnelDataPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FunnelComparison _$FunnelComparisonFromJson(Map<String, dynamic> json) {
  return _FunnelComparison.fromJson(json);
}

/// @nodoc
mixin _$FunnelComparison {
  @JsonKey(name: 'impressions_change')
  double? get impressionsChange => throw _privateConstructorUsedError;
  @JsonKey(name: 'page_views_change')
  double? get pageViewsChange => throw _privateConstructorUsedError;
  @JsonKey(name: 'downloads_change')
  double? get downloadsChange => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversion_rate_change')
  double? get conversionRateChange => throw _privateConstructorUsedError;

  /// Serializes this FunnelComparison to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FunnelComparison
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FunnelComparisonCopyWith<FunnelComparison> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FunnelComparisonCopyWith<$Res> {
  factory $FunnelComparisonCopyWith(
    FunnelComparison value,
    $Res Function(FunnelComparison) then,
  ) = _$FunnelComparisonCopyWithImpl<$Res, FunnelComparison>;
  @useResult
  $Res call({
    @JsonKey(name: 'impressions_change') double? impressionsChange,
    @JsonKey(name: 'page_views_change') double? pageViewsChange,
    @JsonKey(name: 'downloads_change') double? downloadsChange,
    @JsonKey(name: 'conversion_rate_change') double? conversionRateChange,
  });
}

/// @nodoc
class _$FunnelComparisonCopyWithImpl<$Res, $Val extends FunnelComparison>
    implements $FunnelComparisonCopyWith<$Res> {
  _$FunnelComparisonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FunnelComparison
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? impressionsChange = freezed,
    Object? pageViewsChange = freezed,
    Object? downloadsChange = freezed,
    Object? conversionRateChange = freezed,
  }) {
    return _then(
      _value.copyWith(
            impressionsChange: freezed == impressionsChange
                ? _value.impressionsChange
                : impressionsChange // ignore: cast_nullable_to_non_nullable
                      as double?,
            pageViewsChange: freezed == pageViewsChange
                ? _value.pageViewsChange
                : pageViewsChange // ignore: cast_nullable_to_non_nullable
                      as double?,
            downloadsChange: freezed == downloadsChange
                ? _value.downloadsChange
                : downloadsChange // ignore: cast_nullable_to_non_nullable
                      as double?,
            conversionRateChange: freezed == conversionRateChange
                ? _value.conversionRateChange
                : conversionRateChange // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FunnelComparisonImplCopyWith<$Res>
    implements $FunnelComparisonCopyWith<$Res> {
  factory _$$FunnelComparisonImplCopyWith(
    _$FunnelComparisonImpl value,
    $Res Function(_$FunnelComparisonImpl) then,
  ) = __$$FunnelComparisonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'impressions_change') double? impressionsChange,
    @JsonKey(name: 'page_views_change') double? pageViewsChange,
    @JsonKey(name: 'downloads_change') double? downloadsChange,
    @JsonKey(name: 'conversion_rate_change') double? conversionRateChange,
  });
}

/// @nodoc
class __$$FunnelComparisonImplCopyWithImpl<$Res>
    extends _$FunnelComparisonCopyWithImpl<$Res, _$FunnelComparisonImpl>
    implements _$$FunnelComparisonImplCopyWith<$Res> {
  __$$FunnelComparisonImplCopyWithImpl(
    _$FunnelComparisonImpl _value,
    $Res Function(_$FunnelComparisonImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FunnelComparison
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? impressionsChange = freezed,
    Object? pageViewsChange = freezed,
    Object? downloadsChange = freezed,
    Object? conversionRateChange = freezed,
  }) {
    return _then(
      _$FunnelComparisonImpl(
        impressionsChange: freezed == impressionsChange
            ? _value.impressionsChange
            : impressionsChange // ignore: cast_nullable_to_non_nullable
                  as double?,
        pageViewsChange: freezed == pageViewsChange
            ? _value.pageViewsChange
            : pageViewsChange // ignore: cast_nullable_to_non_nullable
                  as double?,
        downloadsChange: freezed == downloadsChange
            ? _value.downloadsChange
            : downloadsChange // ignore: cast_nullable_to_non_nullable
                  as double?,
        conversionRateChange: freezed == conversionRateChange
            ? _value.conversionRateChange
            : conversionRateChange // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FunnelComparisonImpl implements _FunnelComparison {
  const _$FunnelComparisonImpl({
    @JsonKey(name: 'impressions_change') this.impressionsChange,
    @JsonKey(name: 'page_views_change') this.pageViewsChange,
    @JsonKey(name: 'downloads_change') this.downloadsChange,
    @JsonKey(name: 'conversion_rate_change') this.conversionRateChange,
  });

  factory _$FunnelComparisonImpl.fromJson(Map<String, dynamic> json) =>
      _$$FunnelComparisonImplFromJson(json);

  @override
  @JsonKey(name: 'impressions_change')
  final double? impressionsChange;
  @override
  @JsonKey(name: 'page_views_change')
  final double? pageViewsChange;
  @override
  @JsonKey(name: 'downloads_change')
  final double? downloadsChange;
  @override
  @JsonKey(name: 'conversion_rate_change')
  final double? conversionRateChange;

  @override
  String toString() {
    return 'FunnelComparison(impressionsChange: $impressionsChange, pageViewsChange: $pageViewsChange, downloadsChange: $downloadsChange, conversionRateChange: $conversionRateChange)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FunnelComparisonImpl &&
            (identical(other.impressionsChange, impressionsChange) ||
                other.impressionsChange == impressionsChange) &&
            (identical(other.pageViewsChange, pageViewsChange) ||
                other.pageViewsChange == pageViewsChange) &&
            (identical(other.downloadsChange, downloadsChange) ||
                other.downloadsChange == downloadsChange) &&
            (identical(other.conversionRateChange, conversionRateChange) ||
                other.conversionRateChange == conversionRateChange));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    impressionsChange,
    pageViewsChange,
    downloadsChange,
    conversionRateChange,
  );

  /// Create a copy of FunnelComparison
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FunnelComparisonImplCopyWith<_$FunnelComparisonImpl> get copyWith =>
      __$$FunnelComparisonImplCopyWithImpl<_$FunnelComparisonImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FunnelComparisonImplToJson(this);
  }
}

abstract class _FunnelComparison implements FunnelComparison {
  const factory _FunnelComparison({
    @JsonKey(name: 'impressions_change') final double? impressionsChange,
    @JsonKey(name: 'page_views_change') final double? pageViewsChange,
    @JsonKey(name: 'downloads_change') final double? downloadsChange,
    @JsonKey(name: 'conversion_rate_change') final double? conversionRateChange,
  }) = _$FunnelComparisonImpl;

  factory _FunnelComparison.fromJson(Map<String, dynamic> json) =
      _$FunnelComparisonImpl.fromJson;

  @override
  @JsonKey(name: 'impressions_change')
  double? get impressionsChange;
  @override
  @JsonKey(name: 'page_views_change')
  double? get pageViewsChange;
  @override
  @JsonKey(name: 'downloads_change')
  double? get downloadsChange;
  @override
  @JsonKey(name: 'conversion_rate_change')
  double? get conversionRateChange;

  /// Create a copy of FunnelComparison
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FunnelComparisonImplCopyWith<_$FunnelComparisonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
