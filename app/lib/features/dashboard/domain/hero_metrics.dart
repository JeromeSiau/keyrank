import 'package:freezed_annotation/freezed_annotation.dart';

part 'hero_metrics.freezed.dart';
part 'hero_metrics.g.dart';

@freezed
class HeroMetrics with _$HeroMetrics {
  const factory HeroMetrics({
    @JsonKey(name: 'total_apps') required int totalApps,
    @JsonKey(name: 'new_apps_this_month') required int newAppsThisMonth,
    @JsonKey(name: 'avg_rating') required double avgRating,
    @JsonKey(name: 'rating_change') required double ratingChange,
    @JsonKey(name: 'rating_history') required List<double> ratingHistory,
    @JsonKey(name: 'total_keywords') required int totalKeywords,
    @JsonKey(name: 'keywords_in_top_10') required int keywordsInTop10,
    @JsonKey(name: 'total_reviews') required int totalReviews,
    @JsonKey(name: 'reviews_need_reply') required int reviewsNeedReply,
  }) = _HeroMetrics;

  factory HeroMetrics.fromJson(Map<String, dynamic> json) =>
      _$HeroMetricsFromJson(json);
}
