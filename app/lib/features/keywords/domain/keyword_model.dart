import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../features/tags/domain/tag_model.dart';

part 'keyword_model.freezed.dart';
part 'keyword_model.g.dart';

@freezed
class Keyword with _$Keyword {
  const Keyword._();

  const factory Keyword({
    required int id,
    @JsonKey(name: 'tracked_keyword_id') int? trackedKeywordId,
    required String keyword,
    required String storefront,
    int? popularity,
    int? position,
    int? change,
    @JsonKey(name: 'last_updated') DateTime? lastUpdated,
    @JsonKey(name: 'tracked_since') DateTime? trackedSince,
    @JsonKey(name: 'is_favorite') @Default(false) bool isFavorite,
    @JsonKey(name: 'favorited_at') DateTime? favoritedAt,
    @Default([]) List<TagModel> tags,
    String? note,
    int? difficulty,
    @JsonKey(name: 'difficulty_label') String? difficultyLabel,
    int? competition,
    @JsonKey(name: 'top_competitors') List<TopCompetitor>? topCompetitors,
  }) = _Keyword;

  factory Keyword.fromJson(Map<String, dynamic> json) => _$KeywordFromJson(json);

  bool get isRanked => position != null;
  bool get hasImproved => change != null && change! > 0;
  bool get hasDeclined => change != null && change! < 0;
}

@freezed
class KeywordSearchResponse with _$KeywordSearchResponse {
  const factory KeywordSearchResponse({
    required KeywordInfo keyword,
    required List<KeywordSearchResult> results,
    @JsonKey(name: 'total_results') required int totalResults,
  }) = _KeywordSearchResponse;

  factory KeywordSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$KeywordSearchResponseFromJson(json);
}

@freezed
class KeywordInfo with _$KeywordInfo {
  const factory KeywordInfo({
    required int id,
    required String keyword,
    required String storefront,
    int? popularity,
  }) = _KeywordInfo;

  factory KeywordInfo.fromJson(Map<String, dynamic> json) =>
      _$KeywordInfoFromJson(json);
}

@freezed
class KeywordSearchResult with _$KeywordSearchResult {
  const KeywordSearchResult._();

  const factory KeywordSearchResult({
    required int position,
    @JsonKey(name: 'apple_id') String? appleId,
    @JsonKey(name: 'google_play_id') String? googlePlayId,
    required String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? developer,
    @JsonKey(fromJson: _parseDouble) double? rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero) required int ratingCount,
  }) = _KeywordSearchResult;

  factory KeywordSearchResult.fromJson(Map<String, dynamic> json) =>
      _$KeywordSearchResultFromJson(json);

  String get appId => appleId ?? googlePlayId ?? '';
  bool get isIos => appleId != null;
  bool get isAndroid => googlePlayId != null;
}

@freezed
class TopCompetitor with _$TopCompetitor {
  const factory TopCompetitor({
    required String name,
    required int position,
    @JsonKey(fromJson: _parseDouble) double? rating,
    @JsonKey(name: 'icon_url') String? iconUrl,
  }) = _TopCompetitor;

  factory TopCompetitor.fromJson(Map<String, dynamic> json) =>
      _$TopCompetitorFromJson(json);
}

// Non-freezed classes with complex parsing logic

class KeywordSuggestion {
  final String keyword;
  final String source;
  final String category;
  final int? position;
  final int? popularity;
  final int competition;
  final int difficulty;
  final String difficultyLabel;
  final String? reason;
  final String? basedOn;
  final String? competitorName;
  final List<TopCompetitor> topCompetitors;

  KeywordSuggestion({
    required this.keyword,
    required this.source,
    this.category = 'high_opportunity',
    this.position,
    this.popularity,
    required this.competition,
    required this.difficulty,
    required this.difficultyLabel,
    this.reason,
    this.basedOn,
    this.competitorName,
    required this.topCompetitors,
  });

  factory KeywordSuggestion.fromJson(Map<String, dynamic> json) {
    final metrics = json['metrics'] as Map<String, dynamic>;
    return KeywordSuggestion(
      keyword: json['keyword'] as String,
      source: json['source'] as String,
      category: json['category'] as String? ?? 'high_opportunity',
      position: metrics['position'] as int?,
      popularity: metrics['popularity'] as int?,
      competition: metrics['competition'] as int? ?? 0,
      difficulty: metrics['difficulty'] as int? ?? 0,
      difficultyLabel: metrics['difficulty_label'] as String? ?? 'easy',
      reason: json['reason'] as String?,
      basedOn: json['based_on'] as String?,
      competitorName: json['competitor_name'] as String?,
      topCompetitors: (json['top_competitors'] as List?)
              ?.map((e) => TopCompetitor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String get categoryDisplayName {
    switch (category) {
      case 'high_opportunity':
        return 'High Opportunity';
      case 'competitor':
        return 'Competitor Keywords';
      case 'long_tail':
        return 'Long-tail';
      case 'trending':
        return 'Trending';
      case 'related':
        return 'Related';
      default:
        return category;
    }
  }

  String get categoryIcon {
    switch (category) {
      case 'high_opportunity':
        return '🔥';
      case 'competitor':
        return '👀';
      case 'long_tail':
        return '📝';
      case 'trending':
        return '📈';
      case 'related':
        return '🔗';
      default:
        return '💡';
    }
  }
}

class KeywordSuggestionsResponse {
  final List<KeywordSuggestion> suggestions;
  final Map<String, List<KeywordSuggestion>> categories;
  final String appId;
  final String country;
  final int total;
  final Map<String, int> byCategory;
  final DateTime? generatedAt;
  final bool isGenerating;

  KeywordSuggestionsResponse({
    required this.suggestions,
    required this.categories,
    required this.appId,
    required this.country,
    required this.total,
    required this.byCategory,
    this.generatedAt,
    this.isGenerating = false,
  });

  factory KeywordSuggestionsResponse.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>;
    final categoriesJson = json['categories'] as Map<String, dynamic>? ?? {};

    final categories = <String, List<KeywordSuggestion>>{};
    for (final entry in categoriesJson.entries) {
      categories[entry.key] = (entry.value as List)
          .map((e) => KeywordSuggestion.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final byCategoryJson = meta['by_category'] as Map<String, dynamic>? ?? {};
    final byCategory = byCategoryJson.map((k, v) => MapEntry(k, v as int));

    return KeywordSuggestionsResponse(
      suggestions: (json['data'] as List)
          .map((e) => KeywordSuggestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: categories,
      appId: meta['app_id'] as String,
      country: meta['country'] as String,
      total: meta['total'] as int,
      byCategory: byCategory,
      generatedAt: meta['generated_at'] != null
          ? DateTime.parse(meta['generated_at'] as String)
          : null,
      isGenerating: meta['is_generating'] as bool? ?? false,
    );
  }

  List<KeywordSuggestion> forCategory(String category) {
    return categories[category] ?? [];
  }

  static const categoryOrder = [
    'high_opportunity',
    'competitor',
    'long_tail',
    'trending',
    'related',
  ];

  List<String> get nonEmptyCategories {
    return categoryOrder.where((cat) => (byCategory[cat] ?? 0) > 0).toList();
  }
}

// JSON parsing helpers
double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int _parseIntOrZero(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
