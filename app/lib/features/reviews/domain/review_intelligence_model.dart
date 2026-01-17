import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_intelligence_model.freezed.dart';
part 'review_intelligence_model.g.dart';

/// Complete review intelligence dashboard data
@freezed
class ReviewIntelligence with _$ReviewIntelligence {
  const factory ReviewIntelligence({
    @JsonKey(name: 'feature_requests')
    required List<InsightItem> featureRequests,
    @JsonKey(name: 'bug_reports') required List<InsightItem> bugReports,
    @JsonKey(name: 'version_sentiment')
    required List<VersionSentiment> versionSentiment,
    @JsonKey(name: 'version_insight') String? versionInsight,
    required ReviewIntelligenceSummary summary,
  }) = _ReviewIntelligence;

  factory ReviewIntelligence.fromJson(Map<String, dynamic> json) =>
      _$ReviewIntelligenceFromJson(json);
}

/// A single insight item (feature request or bug report)
@freezed
class InsightItem with _$InsightItem {
  const InsightItem._();

  const factory InsightItem({
    required int id,
    required String type,
    required String title,
    String? description,
    @Default([]) List<String> keywords,
    @JsonKey(name: 'mention_count') required int mentionCount,
    required String priority,
    required String status,
    String? platform,
    @JsonKey(name: 'affected_version') String? affectedVersion,
    @JsonKey(name: 'first_mentioned_at') required DateTime firstMentionedAt,
    @JsonKey(name: 'last_mentioned_at') required DateTime lastMentionedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _InsightItem;

  factory InsightItem.fromJson(Map<String, dynamic> json) =>
      _$InsightItemFromJson(json);

  bool get isFeatureRequest => type == 'feature_request';
  bool get isBugReport => type == 'bug_report';
  bool get isOpen => status == 'open';
  bool get isHighPriority => priority == 'high' || priority == 'critical';
  bool get isCritical => priority == 'critical';
}

/// Sentiment data for a specific app version
@freezed
class VersionSentiment with _$VersionSentiment {
  const VersionSentiment._();

  const factory VersionSentiment({
    required String version,
    @JsonKey(name: 'review_count') required int reviewCount,
    @JsonKey(name: 'sentiment_percent') required double sentimentPercent,
    @JsonKey(name: 'avg_rating') required double avgRating,
    @JsonKey(name: 'first_review') required String firstReview,
    @JsonKey(name: 'last_review') required String lastReview,
  }) = _VersionSentiment;

  factory VersionSentiment.fromJson(Map<String, dynamic> json) =>
      _$VersionSentimentFromJson(json);

  /// Returns sentiment as a value between 0 and 1
  double get sentimentRatio => sentimentPercent / 100;

  /// Returns true if sentiment is above 70%
  bool get isPositive => sentimentPercent >= 70;

  /// Returns true if sentiment is below 50%
  bool get isNegative => sentimentPercent < 50;
}

/// Summary statistics for review intelligence
@freezed
class ReviewIntelligenceSummary with _$ReviewIntelligenceSummary {
  const factory ReviewIntelligenceSummary({
    @JsonKey(name: 'total_feature_requests') required int totalFeatureRequests,
    @JsonKey(name: 'total_bug_reports') required int totalBugReports,
    @JsonKey(name: 'open_feature_requests') required int openFeatureRequests,
    @JsonKey(name: 'open_bug_reports') required int openBugReports,
    @JsonKey(name: 'high_priority_bugs') required int highPriorityBugs,
  }) = _ReviewIntelligenceSummary;

  factory ReviewIntelligenceSummary.fromJson(Map<String, dynamic> json) =>
      _$ReviewIntelligenceSummaryFromJson(json);
}

/// Priority levels for insights
enum InsightPriority {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
  @JsonValue('critical')
  critical,
}

/// Status values for insights
enum InsightStatus {
  @JsonValue('open')
  open,
  @JsonValue('planned')
  planned,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('resolved')
  resolved,
  @JsonValue('wont_fix')
  wontFix,
}

/// Extension for InsightPriority display
extension InsightPriorityExtension on InsightPriority {
  String get displayName {
    switch (this) {
      case InsightPriority.low:
        return 'Low';
      case InsightPriority.medium:
        return 'Medium';
      case InsightPriority.high:
        return 'High';
      case InsightPriority.critical:
        return 'Critical';
    }
  }
}

/// Extension for InsightStatus display
extension InsightStatusExtension on InsightStatus {
  String get displayName {
    switch (this) {
      case InsightStatus.open:
        return 'Open';
      case InsightStatus.planned:
        return 'Planned';
      case InsightStatus.inProgress:
        return 'In Progress';
      case InsightStatus.resolved:
        return 'Resolved';
      case InsightStatus.wontFix:
        return "Won't Fix";
    }
  }
}
