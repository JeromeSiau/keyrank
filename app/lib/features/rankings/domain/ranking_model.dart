class Ranking {
  final int id;
  final int keywordId;
  final String keyword;
  final String storefront;
  final int? popularity;
  final int? position;
  final int? previousPosition;
  final int? change;
  final DateTime recordedAt;

  Ranking({
    required this.id,
    required this.keywordId,
    required this.keyword,
    required this.storefront,
    this.popularity,
    this.position,
    this.previousPosition,
    this.change,
    required this.recordedAt,
  });

  factory Ranking.fromJson(Map<String, dynamic> json) {
    return Ranking(
      id: json['id'] as int,
      keywordId: json['keyword_id'] as int,
      keyword: json['keyword'] as String,
      storefront: json['storefront'] as String,
      popularity: json['popularity'] as int?,
      position: json['position'] as int?,
      previousPosition: json['previous_position'] as int?,
      change: json['change'] as int?,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
    );
  }

  bool get isRanked => position != null;
  bool get hasImproved => change != null && change! > 0;
  bool get hasDeclined => change != null && change! < 0;
}

class RankingHistory {
  final int? position;
  final DateTime recordedAt;

  RankingHistory({
    this.position,
    required this.recordedAt,
  });

  factory RankingHistory.fromJson(Map<String, dynamic> json) {
    return RankingHistory(
      position: json['position'] as int?,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
    );
  }
}

class Mover {
  final String appName;
  final String? appIcon;
  final String keyword;
  final String storefront;
  final int currentPosition;
  final int previousPosition;
  final int change;

  Mover({
    required this.appName,
    this.appIcon,
    required this.keyword,
    required this.storefront,
    required this.currentPosition,
    required this.previousPosition,
    required this.change,
  });

  factory Mover.fromJson(Map<String, dynamic> json) {
    return Mover(
      appName: json['app_name'] as String,
      appIcon: json['app_icon'] as String?,
      keyword: json['keyword'] as String,
      storefront: json['storefront'] as String,
      currentPosition: json['current_position'] as int,
      previousPosition: json['previous_position'] as int,
      change: json['change'] as int,
    );
  }
}
