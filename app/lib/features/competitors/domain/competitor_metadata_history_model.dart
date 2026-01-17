import 'package:freezed_annotation/freezed_annotation.dart';

part 'competitor_metadata_history_model.freezed.dart';
part 'competitor_metadata_history_model.g.dart';

/// Response from the metadata history endpoint
@freezed
class CompetitorMetadataHistoryResponse with _$CompetitorMetadataHistoryResponse {
  const factory CompetitorMetadataHistoryResponse({
    required CompetitorInfo competitor,
    required String locale,
    @JsonKey(name: 'current_metadata') MetadataSnapshot? currentMetadata,
    required MetadataHistorySummary summary,
    required List<MetadataTimelineEntry> timeline,
  }) = _CompetitorMetadataHistoryResponse;

  factory CompetitorMetadataHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CompetitorMetadataHistoryResponseFromJson(json);
}

/// Basic competitor info
@freezed
class CompetitorInfo with _$CompetitorInfo {
  const factory CompetitorInfo({
    required int id,
    required String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    required String platform,
  }) = _CompetitorInfo;

  factory CompetitorInfo.fromJson(Map<String, dynamic> json) =>
      _$CompetitorInfoFromJson(json);
}

/// Current metadata snapshot
@freezed
class MetadataSnapshot with _$MetadataSnapshot {
  const factory MetadataSnapshot({
    String? title,
    String? subtitle,
    @JsonKey(name: 'short_description') String? shortDescription,
    String? description,
    String? keywords,
    @JsonKey(name: 'whats_new') String? whatsNew,
    String? version,
    @JsonKey(name: 'last_updated') String? lastUpdated,
  }) = _MetadataSnapshot;

  factory MetadataSnapshot.fromJson(Map<String, dynamic> json) =>
      _$MetadataSnapshotFromJson(json);
}

/// Summary of metadata history
@freezed
class MetadataHistorySummary with _$MetadataHistorySummary {
  const factory MetadataHistorySummary({
    @JsonKey(name: 'total_snapshots') required int totalSnapshots,
    @JsonKey(name: 'total_changes') required int totalChanges,
    @JsonKey(name: 'changes_by_field') required Map<String, int> changesByField,
    @JsonKey(name: 'period_days') required int periodDays,
  }) = _MetadataHistorySummary;

  factory MetadataHistorySummary.fromJson(Map<String, dynamic> json) =>
      _$MetadataHistorySummaryFromJson(json);
}

/// A single entry in the metadata timeline
@freezed
class MetadataTimelineEntry with _$MetadataTimelineEntry {
  const factory MetadataTimelineEntry({
    required int id,
    required String date,
    String? version,
    @JsonKey(name: 'has_changes') required bool hasChanges,
    @JsonKey(name: 'changed_fields') required List<String> changedFields,
    List<MetadataChange>? changes,
  }) = _MetadataTimelineEntry;

  factory MetadataTimelineEntry.fromJson(Map<String, dynamic> json) =>
      _$MetadataTimelineEntryFromJson(json);
}

/// A single metadata change
@freezed
class MetadataChange with _$MetadataChange {
  const factory MetadataChange({
    required String field,
    @JsonKey(name: 'old_value') String? oldValue,
    @JsonKey(name: 'new_value') String? newValue,
    @JsonKey(name: 'char_diff') int? charDiff,
    @JsonKey(name: 'keyword_analysis') KeywordAnalysis? keywordAnalysis,
  }) = _MetadataChange;

  factory MetadataChange.fromJson(Map<String, dynamic> json) =>
      _$MetadataChangeFromJson(json);
}

/// Analysis of keyword changes
@freezed
class KeywordAnalysis with _$KeywordAnalysis {
  const factory KeywordAnalysis({
    required List<String> added,
    required List<String> removed,
    required List<String> unchanged,
  }) = _KeywordAnalysis;

  factory KeywordAnalysis.fromJson(Map<String, dynamic> json) =>
      _$KeywordAnalysisFromJson(json);
}

/// Helper functions for metadata field formatting
String metadataFieldDisplayName(String field) {
  switch (field) {
    case 'title':
      return 'Title';
    case 'subtitle':
      return 'Subtitle';
    case 'short_description':
      return 'Short Description';
    case 'description':
      return 'Description';
    case 'keywords':
      return 'Keywords';
    case 'whats_new':
      return "What's New";
    default:
      return field;
  }
}

/// Get the change type icon based on old/new values
String metadataChangeIcon(String? oldValue, String? newValue) {
  if (oldValue == null && newValue != null) return '+'; // Added
  if (oldValue != null && newValue == null) return '-'; // Removed
  return '~'; // Modified
}

/// Parse a date string to DateTime
DateTime parseMetadataDate(String date) => DateTime.parse(date);

/// Get a formatted date string
String formatMetadataDate(String date) {
  final dt = DateTime.parse(date);
  final months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
}

/// Get a summary of what changed
String metadataChangeSummary(bool hasChanges, List<String> changedFields) {
  if (!hasChanges || changedFields.isEmpty) return 'No changes';
  if (changedFields.length == 1) {
    return '${metadataFieldDisplayName(changedFields.first)} changed';
  }
  return '${changedFields.length} fields changed';
}

/// Response from the metadata insights endpoint
@freezed
class MetadataInsightsResponse with _$MetadataInsightsResponse {
  const factory MetadataInsightsResponse({
    required CompetitorBasicInfo competitor,
    MetadataInsights? insights,
    @JsonKey(name: 'analyzed_changes') required int analyzedChanges,
    @JsonKey(name: 'period_days') required int periodDays,
    @JsonKey(name: 'generated_at') required String generatedAt,
    String? message,
    String? error,
  }) = _MetadataInsightsResponse;

  factory MetadataInsightsResponse.fromJson(Map<String, dynamic> json) =>
      _$MetadataInsightsResponseFromJson(json);
}

/// Basic competitor info for insights
@freezed
class CompetitorBasicInfo with _$CompetitorBasicInfo {
  const factory CompetitorBasicInfo({
    required int id,
    required String name,
  }) = _CompetitorBasicInfo;

  factory CompetitorBasicInfo.fromJson(Map<String, dynamic> json) =>
      _$CompetitorBasicInfoFromJson(json);
}

/// AI-generated metadata insights
@freezed
class MetadataInsights with _$MetadataInsights {
  const factory MetadataInsights({
    @JsonKey(name: 'strategy_summary') required String strategySummary,
    @JsonKey(name: 'key_findings') required List<String> keyFindings,
    @JsonKey(name: 'keyword_focus') required List<String> keywordFocus,
    required List<String> recommendations,
    required String trend,
  }) = _MetadataInsights;

  factory MetadataInsights.fromJson(Map<String, dynamic> json) =>
      _$MetadataInsightsFromJson(json);
}
