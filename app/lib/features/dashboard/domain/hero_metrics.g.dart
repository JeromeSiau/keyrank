// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hero_metrics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HeroMetricsImpl _$$HeroMetricsImplFromJson(Map<String, dynamic> json) =>
    _$HeroMetricsImpl(
      totalApps: (json['total_apps'] as num).toInt(),
      newAppsThisMonth: (json['new_apps_this_month'] as num).toInt(),
      avgRating: (json['avg_rating'] as num).toDouble(),
      ratingChange: (json['rating_change'] as num).toDouble(),
      ratingHistory: (json['rating_history'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      totalKeywords: (json['total_keywords'] as num).toInt(),
      keywordsInTop10: (json['keywords_in_top_10'] as num).toInt(),
      totalReviews: (json['total_reviews'] as num).toInt(),
      reviewsNeedReply: (json['reviews_need_reply'] as num).toInt(),
    );

Map<String, dynamic> _$$HeroMetricsImplToJson(_$HeroMetricsImpl instance) =>
    <String, dynamic>{
      'total_apps': instance.totalApps,
      'new_apps_this_month': instance.newAppsThisMonth,
      'avg_rating': instance.avgRating,
      'rating_change': instance.ratingChange,
      'rating_history': instance.ratingHistory,
      'total_keywords': instance.totalKeywords,
      'keywords_in_top_10': instance.keywordsInTop10,
      'total_reviews': instance.totalReviews,
      'reviews_need_reply': instance.reviewsNeedReply,
    };
