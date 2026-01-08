class Keyword {
  final int id;
  final String keyword;
  final String storefront;
  final int? popularity;
  final int? position;
  final int? previousPosition;
  final int? change;
  final int? iosPosition;
  final int? iosChange;
  final int? androidPosition;
  final int? androidChange;
  final DateTime? lastUpdated;
  final DateTime? trackedSince;

  Keyword({
    required this.id,
    required this.keyword,
    required this.storefront,
    this.popularity,
    this.position,
    this.previousPosition,
    this.change,
    this.iosPosition,
    this.iosChange,
    this.androidPosition,
    this.androidChange,
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
      previousPosition: json['previous_position'] as int?,
      change: json['change'] as int?,
      iosPosition: json['ios_position'] as int?,
      iosChange: json['ios_change'] as int?,
      androidPosition: json['android_position'] as int?,
      androidChange: json['android_change'] as int?,
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'] as String)
          : null,
      trackedSince: json['tracked_since'] != null
          ? DateTime.parse(json['tracked_since'] as String)
          : null,
    );
  }

  bool get isRanked => iosPosition != null || androidPosition != null;

  bool get hasImproved => (iosChange != null && iosChange! > 0) || (androidChange != null && androidChange! > 0);
  bool get hasDeclined => (iosChange != null && iosChange! < 0) || (androidChange != null && androidChange! < 0);
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
