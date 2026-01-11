import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_summary_model.freezed.dart';
part 'analytics_summary_model.g.dart';

@freezed
class AnalyticsSummary with _$AnalyticsSummary {
  const factory AnalyticsSummary({
    required String period,
    @JsonKey(name: 'total_downloads') required int totalDownloads,
    @JsonKey(name: 'total_revenue') required double totalRevenue,
    @JsonKey(name: 'total_proceeds') required double totalProceeds,
    @JsonKey(name: 'active_subscribers') required int activeSubscribers,
    @JsonKey(name: 'downloads_change_pct') double? downloadsChangePct,
    @JsonKey(name: 'revenue_change_pct') double? revenueChangePct,
    @JsonKey(name: 'subscribers_change_pct') double? subscribersChangePct,
    @JsonKey(name: 'computed_at') DateTime? computedAt,
    @JsonKey(name: 'has_data') @Default(false) bool hasData,
  }) = _AnalyticsSummary;

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsSummaryFromJson(json);
}

@freezed
class DownloadsDataPoint with _$DownloadsDataPoint {
  const factory DownloadsDataPoint({
    required String date,
    required int downloads,
  }) = _DownloadsDataPoint;

  factory DownloadsDataPoint.fromJson(Map<String, dynamic> json) =>
      _$DownloadsDataPointFromJson(json);
}

@freezed
class RevenueDataPoint with _$RevenueDataPoint {
  const factory RevenueDataPoint({
    required String date,
    required double revenue,
    required double proceeds,
  }) = _RevenueDataPoint;

  factory RevenueDataPoint.fromJson(Map<String, dynamic> json) =>
      _$RevenueDataPointFromJson(json);
}

@freezed
class SubscribersDataPoint with _$SubscribersDataPoint {
  const factory SubscribersDataPoint({
    required String date,
    @JsonKey(name: 'subscribers_new') required int subscribersNew,
    @JsonKey(name: 'subscribers_cancelled') required int subscribersCancelled,
    @JsonKey(name: 'subscribers_active') required int subscribersActive,
  }) = _SubscribersDataPoint;

  factory SubscribersDataPoint.fromJson(Map<String, dynamic> json) =>
      _$SubscribersDataPointFromJson(json);
}

@freezed
class CountryAnalytics with _$CountryAnalytics {
  const factory CountryAnalytics({
    @JsonKey(name: 'country_code') required String countryCode,
    required int downloads,
    required double revenue,
    required double proceeds,
  }) = _CountryAnalytics;

  factory CountryAnalytics.fromJson(Map<String, dynamic> json) =>
      _$CountryAnalyticsFromJson(json);
}

@freezed
class DownloadsChartData with _$DownloadsChartData {
  const factory DownloadsChartData({
    required List<DownloadsDataPoint> current,
    required List<DownloadsDataPoint> previous,
  }) = _DownloadsChartData;

  factory DownloadsChartData.fromJson(Map<String, dynamic> json) =>
      _$DownloadsChartDataFromJson(json);
}

@freezed
class RevenueChartData with _$RevenueChartData {
  const factory RevenueChartData({
    required List<RevenueDataPoint> current,
    required List<RevenueDataPoint> previous,
  }) = _RevenueChartData;

  factory RevenueChartData.fromJson(Map<String, dynamic> json) =>
      _$RevenueChartDataFromJson(json);
}
