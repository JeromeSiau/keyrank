import '../../../features/tags/domain/tag_model.dart';

class Keyword {
  final int id;
  final int? trackedKeywordId;
  final String keyword;
  final String storefront;
  final int? popularity;
  final int? position;
  final int? change;
  final DateTime? lastUpdated;
  final DateTime? trackedSince;
  final bool isFavorite;
  final DateTime? favoritedAt;
  final List<TagModel> tags;
  final String? note;
  final int? difficulty;
  final String? difficultyLabel;
  final int? competition;
  final List<TopCompetitor>? topCompetitors;

  Keyword({
    required this.id,
    this.trackedKeywordId,
    required this.keyword,
    required this.storefront,
    this.popularity,
    this.position,
    this.change,
    this.lastUpdated,
    this.trackedSince,
    this.isFavorite = false,
    this.favoritedAt,
    this.tags = const [],
    this.note,
    this.difficulty,
    this.difficultyLabel,
    this.competition,
    this.topCompetitors,
  });

  factory Keyword.fromJson(Map<String, dynamic> json) {
    return Keyword(
      id: json['id'] as int,
      trackedKeywordId: json['tracked_keyword_id'] as int?,
      keyword: json['keyword'] as String,
      storefront: json['storefront'] as String,
      popularity: json['popularity'] as int?,
      position: json['position'] as int?,
      change: json['change'] as int?,
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'] as String)
          : null,
      trackedSince: json['tracked_since'] != null
          ? DateTime.parse(json['tracked_since'] as String)
          : null,
      isFavorite: json['is_favorite'] as bool? ?? false,
      favoritedAt: json['favorited_at'] != null
          ? DateTime.parse(json['favorited_at'] as String)
          : null,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => TagModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      note: json['note'] as String?,
      difficulty: json['difficulty'] as int?,
      difficultyLabel: json['difficulty_label'] as String?,
      competition: json['competition'] as int?,
      topCompetitors: (json['top_competitors'] as List<dynamic>?)
          ?.map((e) => TopCompetitor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Keyword copyWith({
    int? id,
    int? trackedKeywordId,
    String? keyword,
    String? storefront,
    int? popularity,
    int? position,
    int? change,
    DateTime? lastUpdated,
    DateTime? trackedSince,
    bool? isFavorite,
    DateTime? favoritedAt,
    List<TagModel>? tags,
    String? note,
    int? difficulty,
    String? difficultyLabel,
    int? competition,
    List<TopCompetitor>? topCompetitors,
  }) {
    return Keyword(
      id: id ?? this.id,
      trackedKeywordId: trackedKeywordId ?? this.trackedKeywordId,
      keyword: keyword ?? this.keyword,
      storefront: storefront ?? this.storefront,
      popularity: popularity ?? this.popularity,
      position: position ?? this.position,
      change: change ?? this.change,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      trackedSince: trackedSince ?? this.trackedSince,
      isFavorite: isFavorite ?? this.isFavorite,
      favoritedAt: favoritedAt ?? this.favoritedAt,
      tags: tags ?? this.tags,
      note: note ?? this.note,
      difficulty: difficulty ?? this.difficulty,
      difficultyLabel: difficultyLabel ?? this.difficultyLabel,
      competition: competition ?? this.competition,
      topCompetitors: topCompetitors ?? this.topCompetitors,
    );
  }

  bool get isRanked => position != null;

  bool get hasImproved => change != null && change! > 0;
  bool get hasDeclined => change != null && change! < 0;
}

class KeywordSearchResponse {
  final KeywordInfo keyword;
  final List<KeywordSearchResult> results;
  final int totalResults;

  KeywordSearchResponse({
    required this.keyword,
    required this.results,
    required this.totalResults,
  });

  factory KeywordSearchResponse.fromJson(Map<String, dynamic> json) {
    return KeywordSearchResponse(
      keyword: KeywordInfo.fromJson(json['keyword'] as Map<String, dynamic>),
      results: (json['results'] as List)
          .map((e) => KeywordSearchResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalResults: json['total_results'] as int,
    );
  }
}

class KeywordInfo {
  final int id;
  final String keyword;
  final String storefront;
  final int? popularity;

  KeywordInfo({
    required this.id,
    required this.keyword,
    required this.storefront,
    this.popularity,
  });

  factory KeywordInfo.fromJson(Map<String, dynamic> json) {
    return KeywordInfo(
      id: json['id'] as int,
      keyword: json['keyword'] as String,
      storefront: json['storefront'] as String,
      popularity: json['popularity'] as int?,
    );
  }
}

class KeywordSearchResult {
  final int position;
  final String? appleId;
  final String? googlePlayId;
  final String name;
  final String? iconUrl;
  final String? developer;
  final double? rating;
  final int ratingCount;

  KeywordSearchResult({
    required this.position,
    this.appleId,
    this.googlePlayId,
    required this.name,
    this.iconUrl,
    this.developer,
    this.rating,
    required this.ratingCount,
  });

  String get appId => appleId ?? googlePlayId ?? '';
  bool get isIos => appleId != null;
  bool get isAndroid => googlePlayId != null;

  factory KeywordSearchResult.fromJson(Map<String, dynamic> json) {
    return KeywordSearchResult(
      position: json['position'] as int,
      appleId: json['apple_id'] as String?,
      googlePlayId: json['google_play_id'] as String?,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      developer: json['developer'] as String?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      ratingCount: json['rating_count'] as int? ?? 0,
    );
  }
}

class KeywordSuggestion {
  final String keyword;
  final String source;
  final int? position;
  final int competition;
  final int difficulty;
  final String difficultyLabel;
  final List<TopCompetitor> topCompetitors;

  KeywordSuggestion({
    required this.keyword,
    required this.source,
    this.position,
    required this.competition,
    required this.difficulty,
    required this.difficultyLabel,
    required this.topCompetitors,
  });

  factory KeywordSuggestion.fromJson(Map<String, dynamic> json) {
    final metrics = json['metrics'] as Map<String, dynamic>;
    return KeywordSuggestion(
      keyword: json['keyword'] as String,
      source: json['source'] as String,
      position: metrics['position'] as int?,
      competition: metrics['competition'] as int? ?? 0,
      difficulty: metrics['difficulty'] as int? ?? 0,
      difficultyLabel: metrics['difficulty_label'] as String? ?? 'easy',
      topCompetitors: (json['top_competitors'] as List?)
              ?.map((e) => TopCompetitor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class TopCompetitor {
  final String name;
  final int position;
  final double? rating;
  final String? iconUrl;

  TopCompetitor({
    required this.name,
    required this.position,
    this.rating,
    this.iconUrl,
  });

  factory TopCompetitor.fromJson(Map<String, dynamic> json) {
    return TopCompetitor(
      name: json['name'] as String,
      position: json['position'] as int,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      iconUrl: json['icon_url'] as String?,
    );
  }
}

class KeywordSuggestionsResponse {
  final List<KeywordSuggestion> suggestions;
  final String appId;
  final String country;
  final int total;
  final DateTime generatedAt;

  KeywordSuggestionsResponse({
    required this.suggestions,
    required this.appId,
    required this.country,
    required this.total,
    required this.generatedAt,
  });

  factory KeywordSuggestionsResponse.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>;
    return KeywordSuggestionsResponse(
      suggestions: (json['data'] as List)
          .map((e) => KeywordSuggestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      appId: meta['app_id'] as String,
      country: meta['country'] as String,
      total: meta['total'] as int,
      generatedAt: DateTime.parse(meta['generated_at'] as String),
    );
  }
}
