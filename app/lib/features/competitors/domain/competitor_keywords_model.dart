import 'package:freezed_annotation/freezed_annotation.dart';

part 'competitor_keywords_model.freezed.dart';
part 'competitor_keywords_model.g.dart';

@freezed
class CompetitorKeywordsResponse with _$CompetitorKeywordsResponse {
  const factory CompetitorKeywordsResponse({
    required CompetitorInfo competitor,
    required KeywordComparisonSummary summary,
    required List<KeywordComparison> keywords,
  }) = _CompetitorKeywordsResponse;

  factory CompetitorKeywordsResponse.fromJson(Map<String, dynamic> json) =>
      _$CompetitorKeywordsResponseFromJson(json);
}

@freezed
class CompetitorInfo with _$CompetitorInfo {
  const factory CompetitorInfo({
    required int id,
    required String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
  }) = _CompetitorInfo;

  factory CompetitorInfo.fromJson(Map<String, dynamic> json) =>
      _$CompetitorInfoFromJson(json);
}

@freezed
class KeywordComparisonSummary with _$KeywordComparisonSummary {
  const factory KeywordComparisonSummary({
    @JsonKey(name: 'total_keywords') required int totalKeywords,
    @JsonKey(name: 'you_win') required int youWin,
    @JsonKey(name: 'they_win') required int theyWin,
    required int tied,
    required int gaps,
  }) = _KeywordComparisonSummary;

  factory KeywordComparisonSummary.fromJson(Map<String, dynamic> json) =>
      _$KeywordComparisonSummaryFromJson(json);
}

@freezed
class KeywordComparison with _$KeywordComparison {
  const KeywordComparison._();

  const factory KeywordComparison({
    @JsonKey(name: 'keyword_id') required int keywordId,
    required String keyword,
    @JsonKey(name: 'your_position') int? yourPosition,
    @JsonKey(name: 'competitor_position') int? competitorPosition,
    int? gap,
    int? popularity,
    @JsonKey(name: 'is_tracking') required bool isTracking,
  }) = _KeywordComparison;

  factory KeywordComparison.fromJson(Map<String, dynamic> json) =>
      _$KeywordComparisonFromJson(json);

  bool get isGap => yourPosition == null;
  bool get youWin => gap != null && gap! > 0;
  bool get theyWin => gap != null && gap! < 0;
  bool get isTied => gap == 0;
}
