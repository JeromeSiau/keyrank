// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversion_funnel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversionFunnelImpl _$$ConversionFunnelImplFromJson(
  Map<String, dynamic> json,
) => _$ConversionFunnelImpl(
  summary: FunnelSummary.fromJson(json['summary'] as Map<String, dynamic>),
  bySource: (json['by_source'] as List<dynamic>)
      .map((e) => SourceConversion.fromJson(e as Map<String, dynamic>))
      .toList(),
  trend: (json['trend'] as List<dynamic>)
      .map((e) => FunnelDataPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
  comparison: FunnelComparison.fromJson(
    json['comparison'] as Map<String, dynamic>,
  ),
  hasData: json['has_data'] as bool? ?? true,
  message: json['message'] as String?,
);

Map<String, dynamic> _$$ConversionFunnelImplToJson(
  _$ConversionFunnelImpl instance,
) => <String, dynamic>{
  'summary': instance.summary,
  'by_source': instance.bySource,
  'trend': instance.trend,
  'comparison': instance.comparison,
  'has_data': instance.hasData,
  'message': instance.message,
};

_$FunnelSummaryImpl _$$FunnelSummaryImplFromJson(Map<String, dynamic> json) =>
    _$FunnelSummaryImpl(
      impressions: (json['impressions'] as num).toInt(),
      pageViews: (json['page_views'] as num).toInt(),
      downloads: (json['downloads'] as num).toInt(),
      impressionToPageViewRate: (json['impression_to_page_view_rate'] as num)
          .toDouble(),
      pageViewToDownloadRate: (json['page_view_to_download_rate'] as num)
          .toDouble(),
      overallConversionRate: (json['overall_conversion_rate'] as num)
          .toDouble(),
      categoryAverage: (json['category_average'] as num?)?.toDouble(),
      vsCategory: json['vs_category'] as String?,
    );

Map<String, dynamic> _$$FunnelSummaryImplToJson(_$FunnelSummaryImpl instance) =>
    <String, dynamic>{
      'impressions': instance.impressions,
      'page_views': instance.pageViews,
      'downloads': instance.downloads,
      'impression_to_page_view_rate': instance.impressionToPageViewRate,
      'page_view_to_download_rate': instance.pageViewToDownloadRate,
      'overall_conversion_rate': instance.overallConversionRate,
      'category_average': instance.categoryAverage,
      'vs_category': instance.vsCategory,
    };

_$SourceConversionImpl _$$SourceConversionImplFromJson(
  Map<String, dynamic> json,
) => _$SourceConversionImpl(
  source: json['source'] as String,
  sourceLabel: json['source_label'] as String,
  impressions: (json['impressions'] as num).toInt(),
  pageViews: (json['page_views'] as num).toInt(),
  downloads: (json['downloads'] as num).toInt(),
  conversionRate: (json['conversion_rate'] as num).toDouble(),
  percentageOfTotal: (json['percentage_of_total'] as num).toDouble(),
);

Map<String, dynamic> _$$SourceConversionImplToJson(
  _$SourceConversionImpl instance,
) => <String, dynamic>{
  'source': instance.source,
  'source_label': instance.sourceLabel,
  'impressions': instance.impressions,
  'page_views': instance.pageViews,
  'downloads': instance.downloads,
  'conversion_rate': instance.conversionRate,
  'percentage_of_total': instance.percentageOfTotal,
};

_$FunnelDataPointImpl _$$FunnelDataPointImplFromJson(
  Map<String, dynamic> json,
) => _$FunnelDataPointImpl(
  date: json['date'] as String,
  impressions: (json['impressions'] as num).toInt(),
  pageViews: (json['page_views'] as num).toInt(),
  downloads: (json['downloads'] as num).toInt(),
  conversionRate: (json['conversion_rate'] as num).toDouble(),
);

Map<String, dynamic> _$$FunnelDataPointImplToJson(
  _$FunnelDataPointImpl instance,
) => <String, dynamic>{
  'date': instance.date,
  'impressions': instance.impressions,
  'page_views': instance.pageViews,
  'downloads': instance.downloads,
  'conversion_rate': instance.conversionRate,
};

_$FunnelComparisonImpl _$$FunnelComparisonImplFromJson(
  Map<String, dynamic> json,
) => _$FunnelComparisonImpl(
  impressionsChange: (json['impressions_change'] as num?)?.toDouble(),
  pageViewsChange: (json['page_views_change'] as num?)?.toDouble(),
  downloadsChange: (json['downloads_change'] as num?)?.toDouble(),
  conversionRateChange: (json['conversion_rate_change'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$FunnelComparisonImplToJson(
  _$FunnelComparisonImpl instance,
) => <String, dynamic>{
  'impressions_change': instance.impressionsChange,
  'page_views_change': instance.pageViewsChange,
  'downloads_change': instance.downloadsChange,
  'conversion_rate_change': instance.conversionRateChange,
};
