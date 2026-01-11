import 'package:freezed_annotation/freezed_annotation.dart';

part 'actionable_insight_model.freezed.dart';
part 'actionable_insight_model.g.dart';

enum InsightType {
  opportunity,
  warning,
  win,
  @JsonValue('competitor_move')
  competitorMove,
  theme,
  suggestion,
}

enum InsightPriority {
  high,
  medium,
  low,
}

@freezed
class ActionableInsight with _$ActionableInsight {
  const factory ActionableInsight({
    required int id,
    required InsightType type,
    required InsightPriority priority,
    required String title,
    required String description,
    @JsonKey(name: 'action_text') String? actionText,
    @JsonKey(name: 'action_url') String? actionUrl,
    @JsonKey(name: 'data_refs') Map<String, dynamic>? dataRefs,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'is_dismissed') @Default(false) bool isDismissed,
    @JsonKey(name: 'generated_at') required DateTime generatedAt,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    InsightApp? app,
  }) = _ActionableInsight;

  factory ActionableInsight.fromJson(Map<String, dynamic> json) =>
      _$ActionableInsightFromJson(json);
}

@freezed
class InsightApp with _$InsightApp {
  const factory InsightApp({
    required int id,
    required String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    required String platform,
  }) = _InsightApp;

  factory InsightApp.fromJson(Map<String, dynamic> json) =>
      _$InsightAppFromJson(json);
}

@freezed
class InsightsSummary with _$InsightsSummary {
  const factory InsightsSummary({
    required List<ActionableInsight> insights,
    @JsonKey(name: 'unread_count') required int unreadCount,
    @JsonKey(name: 'by_type') required Map<String, int> byType,
  }) = _InsightsSummary;

  factory InsightsSummary.fromJson(Map<String, dynamic> json) =>
      _$InsightsSummaryFromJson(json);
}

@freezed
class InsightsUnreadCount with _$InsightsUnreadCount {
  const factory InsightsUnreadCount({
    required int total,
    @JsonKey(name: 'high_priority') required int highPriority,
  }) = _InsightsUnreadCount;

  factory InsightsUnreadCount.fromJson(Map<String, dynamic> json) =>
      _$InsightsUnreadCountFromJson(json);
}
