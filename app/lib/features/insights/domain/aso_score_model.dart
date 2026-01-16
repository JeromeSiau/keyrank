import 'package:freezed_annotation/freezed_annotation.dart';

part 'aso_score_model.freezed.dart';
part 'aso_score_model.g.dart';

@freezed
class AsoScore with _$AsoScore {
  const AsoScore._();

  const factory AsoScore({
    required int score,
    required AsoScoreBreakdown breakdown,
    required AsoScoreTrend trend,
    required List<AsoScoreRecommendation> recommendations,
  }) = _AsoScore;

  factory AsoScore.fromJson(Map<String, dynamic> json) =>
      _$AsoScoreFromJson(json);

  /// Get a label for the overall score
  String get label {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    if (score >= 20) return 'Needs Work';
    return 'Poor';
  }

  /// Get color-coded status
  String get status {
    if (score >= 80) return 'excellent';
    if (score >= 60) return 'good';
    if (score >= 40) return 'fair';
    return 'needs_work';
  }
}

@freezed
class AsoScoreBreakdown with _$AsoScoreBreakdown {
  const factory AsoScoreBreakdown({
    required AsoScoreCategory metadata,
    required AsoScoreCategory keywords,
    required AsoScoreCategory reviews,
    required AsoScoreCategory ratings,
  }) = _AsoScoreBreakdown;

  factory AsoScoreBreakdown.fromJson(Map<String, dynamic> json) =>
      _$AsoScoreBreakdownFromJson(json);
}

@freezed
class AsoScoreCategory with _$AsoScoreCategory {
  const AsoScoreCategory._();

  const factory AsoScoreCategory({
    required int score,
    required int max,
    required int percent,
    required Map<String, dynamic> details,
  }) = _AsoScoreCategory;

  factory AsoScoreCategory.fromJson(Map<String, dynamic> json) =>
      _$AsoScoreCategoryFromJson(json);

  /// Get status based on percentage
  String get status {
    if (percent >= 80) return 'excellent';
    if (percent >= 60) return 'good';
    if (percent >= 40) return 'fair';
    return 'needs_work';
  }
}

@freezed
class AsoScoreTrend with _$AsoScoreTrend {
  const AsoScoreTrend._();

  const factory AsoScoreTrend({
    required int change,
    required String period,
    required String direction,
    @Default([]) List<String> indicators,
  }) = _AsoScoreTrend;

  factory AsoScoreTrend.fromJson(Map<String, dynamic> json) =>
      _$AsoScoreTrendFromJson(json);

  bool get isPositive => direction == 'up';
  bool get isNegative => direction == 'down';
  bool get isStable => direction == 'stable';
}

@freezed
class AsoScoreRecommendation with _$AsoScoreRecommendation {
  const factory AsoScoreRecommendation({
    required String category,
    required String action,
    required String impact,
    required String priority,
  }) = _AsoScoreRecommendation;

  factory AsoScoreRecommendation.fromJson(Map<String, dynamic> json) =>
      _$AsoScoreRecommendationFromJson(json);
}
