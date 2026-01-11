// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalyticsSummaryImpl _$$AnalyticsSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$AnalyticsSummaryImpl(
  period: json['period'] as String,
  totalDownloads: (json['total_downloads'] as num).toInt(),
  totalRevenue: (json['total_revenue'] as num).toDouble(),
  totalProceeds: (json['total_proceeds'] as num).toDouble(),
  activeSubscribers: (json['active_subscribers'] as num).toInt(),
  downloadsChangePct: (json['downloads_change_pct'] as num?)?.toDouble(),
  revenueChangePct: (json['revenue_change_pct'] as num?)?.toDouble(),
  subscribersChangePct: (json['subscribers_change_pct'] as num?)?.toDouble(),
  computedAt: json['computed_at'] == null
      ? null
      : DateTime.parse(json['computed_at'] as String),
  hasData: json['has_data'] as bool? ?? false,
);

Map<String, dynamic> _$$AnalyticsSummaryImplToJson(
  _$AnalyticsSummaryImpl instance,
) => <String, dynamic>{
  'period': instance.period,
  'total_downloads': instance.totalDownloads,
  'total_revenue': instance.totalRevenue,
  'total_proceeds': instance.totalProceeds,
  'active_subscribers': instance.activeSubscribers,
  'downloads_change_pct': instance.downloadsChangePct,
  'revenue_change_pct': instance.revenueChangePct,
  'subscribers_change_pct': instance.subscribersChangePct,
  'computed_at': instance.computedAt?.toIso8601String(),
  'has_data': instance.hasData,
};

_$DownloadsDataPointImpl _$$DownloadsDataPointImplFromJson(
  Map<String, dynamic> json,
) => _$DownloadsDataPointImpl(
  date: json['date'] as String,
  downloads: (json['downloads'] as num).toInt(),
);

Map<String, dynamic> _$$DownloadsDataPointImplToJson(
  _$DownloadsDataPointImpl instance,
) => <String, dynamic>{'date': instance.date, 'downloads': instance.downloads};

_$RevenueDataPointImpl _$$RevenueDataPointImplFromJson(
  Map<String, dynamic> json,
) => _$RevenueDataPointImpl(
  date: json['date'] as String,
  revenue: (json['revenue'] as num).toDouble(),
  proceeds: (json['proceeds'] as num).toDouble(),
);

Map<String, dynamic> _$$RevenueDataPointImplToJson(
  _$RevenueDataPointImpl instance,
) => <String, dynamic>{
  'date': instance.date,
  'revenue': instance.revenue,
  'proceeds': instance.proceeds,
};

_$SubscribersDataPointImpl _$$SubscribersDataPointImplFromJson(
  Map<String, dynamic> json,
) => _$SubscribersDataPointImpl(
  date: json['date'] as String,
  subscribersNew: (json['subscribers_new'] as num).toInt(),
  subscribersCancelled: (json['subscribers_cancelled'] as num).toInt(),
  subscribersActive: (json['subscribers_active'] as num).toInt(),
);

Map<String, dynamic> _$$SubscribersDataPointImplToJson(
  _$SubscribersDataPointImpl instance,
) => <String, dynamic>{
  'date': instance.date,
  'subscribers_new': instance.subscribersNew,
  'subscribers_cancelled': instance.subscribersCancelled,
  'subscribers_active': instance.subscribersActive,
};

_$CountryAnalyticsImpl _$$CountryAnalyticsImplFromJson(
  Map<String, dynamic> json,
) => _$CountryAnalyticsImpl(
  countryCode: json['country_code'] as String,
  downloads: (json['downloads'] as num).toInt(),
  revenue: (json['revenue'] as num).toDouble(),
  proceeds: (json['proceeds'] as num).toDouble(),
);

Map<String, dynamic> _$$CountryAnalyticsImplToJson(
  _$CountryAnalyticsImpl instance,
) => <String, dynamic>{
  'country_code': instance.countryCode,
  'downloads': instance.downloads,
  'revenue': instance.revenue,
  'proceeds': instance.proceeds,
};

_$DownloadsChartDataImpl _$$DownloadsChartDataImplFromJson(
  Map<String, dynamic> json,
) => _$DownloadsChartDataImpl(
  current: (json['current'] as List<dynamic>)
      .map((e) => DownloadsDataPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
  previous: (json['previous'] as List<dynamic>)
      .map((e) => DownloadsDataPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$DownloadsChartDataImplToJson(
  _$DownloadsChartDataImpl instance,
) => <String, dynamic>{
  'current': instance.current,
  'previous': instance.previous,
};

_$RevenueChartDataImpl _$$RevenueChartDataImplFromJson(
  Map<String, dynamic> json,
) => _$RevenueChartDataImpl(
  current: (json['current'] as List<dynamic>)
      .map((e) => RevenueDataPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
  previous: (json['previous'] as List<dynamic>)
      .map((e) => RevenueDataPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$RevenueChartDataImplToJson(
  _$RevenueChartDataImpl instance,
) => <String, dynamic>{
  'current': instance.current,
  'previous': instance.previous,
};
