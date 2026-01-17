import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversion_funnel_model.freezed.dart';
part 'conversion_funnel_model.g.dart';

/// Main conversion funnel response from API
@freezed
class ConversionFunnel with _$ConversionFunnel {
  const factory ConversionFunnel({
    required FunnelSummary summary,
    @JsonKey(name: 'by_source') required List<SourceConversion> bySource,
    required List<FunnelDataPoint> trend,
    required FunnelComparison comparison,
    @JsonKey(name: 'has_data') @Default(true) bool hasData,
    String? message,
  }) = _ConversionFunnel;

  factory ConversionFunnel.fromJson(Map<String, dynamic> json) =>
      _$ConversionFunnelFromJson(json);

  /// Empty funnel for when no data is available
  factory ConversionFunnel.empty() => const ConversionFunnel(
        summary: FunnelSummary(
          impressions: 0,
          pageViews: 0,
          downloads: 0,
          impressionToPageViewRate: 0,
          pageViewToDownloadRate: 0,
          overallConversionRate: 0,
        ),
        bySource: [],
        trend: [],
        comparison: FunnelComparison(
          impressionsChange: null,
          pageViewsChange: null,
          downloadsChange: null,
          conversionRateChange: null,
        ),
        hasData: false,
        message: 'No funnel data available',
      );
}

/// Summary metrics for the funnel
@freezed
class FunnelSummary with _$FunnelSummary {
  const factory FunnelSummary({
    required int impressions,
    @JsonKey(name: 'page_views') required int pageViews,
    required int downloads,
    @JsonKey(name: 'impression_to_page_view_rate')
    required double impressionToPageViewRate,
    @JsonKey(name: 'page_view_to_download_rate')
    required double pageViewToDownloadRate,
    @JsonKey(name: 'overall_conversion_rate') required double overallConversionRate,
    @JsonKey(name: 'category_average') double? categoryAverage,
    @JsonKey(name: 'vs_category') String? vsCategory,
  }) = _FunnelSummary;

  factory FunnelSummary.fromJson(Map<String, dynamic> json) =>
      _$FunnelSummaryFromJson(json);
}

/// Conversion data for a specific source (search, browse, referral, etc.)
@freezed
class SourceConversion with _$SourceConversion {
  const factory SourceConversion({
    required String source,
    @JsonKey(name: 'source_label') required String sourceLabel,
    required int impressions,
    @JsonKey(name: 'page_views') required int pageViews,
    required int downloads,
    @JsonKey(name: 'conversion_rate') required double conversionRate,
    @JsonKey(name: 'percentage_of_total') required double percentageOfTotal,
  }) = _SourceConversion;

  factory SourceConversion.fromJson(Map<String, dynamic> json) =>
      _$SourceConversionFromJson(json);
}

/// Daily data point for trend chart
@freezed
class FunnelDataPoint with _$FunnelDataPoint {
  const factory FunnelDataPoint({
    required String date,
    required int impressions,
    @JsonKey(name: 'page_views') required int pageViews,
    required int downloads,
    @JsonKey(name: 'conversion_rate') required double conversionRate,
  }) = _FunnelDataPoint;

  factory FunnelDataPoint.fromJson(Map<String, dynamic> json) =>
      _$FunnelDataPointFromJson(json);
}

/// Comparison with previous period
@freezed
class FunnelComparison with _$FunnelComparison {
  const factory FunnelComparison({
    @JsonKey(name: 'impressions_change') double? impressionsChange,
    @JsonKey(name: 'page_views_change') double? pageViewsChange,
    @JsonKey(name: 'downloads_change') double? downloadsChange,
    @JsonKey(name: 'conversion_rate_change') double? conversionRateChange,
  }) = _FunnelComparison;

  factory FunnelComparison.fromJson(Map<String, dynamic> json) =>
      _$FunnelComparisonFromJson(json);
}
