class Keyword {
  final int id;
  final String keyword;
  final String storefront;
  final int? popularity;
  final int? position;
  final int? change;
  final DateTime? lastUpdated;
  final DateTime? trackedSince;

  Keyword({
    required this.id,
    required this.keyword,
    required this.storefront,
    this.popularity,
    this.position,
    this.change,
    this.lastUpdated,
    this.trackedSince,
  });

  factory Keyword.fromJson(Map<String, dynamic> json) {
    return Keyword(
      id: json['id'] as int,
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

  TopCompetitor({
    required this.name,
    required this.position,
    this.rating,
  });

  factory TopCompetitor.fromJson(Map<String, dynamic> json) {
    return TopCompetitor(
      name: json['name'] as String,
      position: json['position'] as int,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
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
