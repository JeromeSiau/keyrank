class CategoryScore {
  final double score;
  final String summary;

  CategoryScore({
    required this.score,
    required this.summary,
  });

  factory CategoryScore.fromJson(Map<String, dynamic> json) {
    return CategoryScore(
      score: (json['score'] as num).toDouble(),
      summary: json['summary'] as String? ?? '',
    );
  }
}

class EmergentTheme {
  final String label;
  final String sentiment;
  final int frequency;
  final String summary;
  final List<String> exampleQuotes;

  EmergentTheme({
    required this.label,
    required this.sentiment,
    required this.frequency,
    required this.summary,
    required this.exampleQuotes,
  });

  factory EmergentTheme.fromJson(Map<String, dynamic> json) {
    return EmergentTheme(
      label: json['label'] as String? ?? '',
      sentiment: json['sentiment'] as String? ?? 'mixed',
      frequency: json['frequency'] as int? ?? 0,
      summary: json['summary'] as String? ?? '',
      exampleQuotes: (json['example_quotes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

class AppInsight {
  final int id;
  final int reviewsCount;
  final List<String> countries;
  final DateTime periodStart;
  final DateTime periodEnd;
  final Map<String, CategoryScore> categoryScores;
  final List<EmergentTheme> emergentThemes;
  final List<String> overallStrengths;
  final List<String> overallWeaknesses;
  final List<String> opportunities;
  final DateTime analyzedAt;
  final String? note;

  AppInsight({
    required this.id,
    required this.reviewsCount,
    required this.countries,
    required this.periodStart,
    required this.periodEnd,
    required this.categoryScores,
    required this.emergentThemes,
    required this.overallStrengths,
    required this.overallWeaknesses,
    required this.opportunities,
    required this.analyzedAt,
    this.note,
  });

  AppInsight copyWith({String? note}) {
    return AppInsight(
      id: id,
      reviewsCount: reviewsCount,
      countries: countries,
      periodStart: periodStart,
      periodEnd: periodEnd,
      categoryScores: categoryScores,
      emergentThemes: emergentThemes,
      overallStrengths: overallStrengths,
      overallWeaknesses: overallWeaknesses,
      opportunities: opportunities,
      analyzedAt: analyzedAt,
      note: note ?? this.note,
    );
  }

  factory AppInsight.fromJson(Map<String, dynamic> json) {
    final scoresJson = json['category_scores'] as Map<String, dynamic>? ?? {};
    final scores = <String, CategoryScore>{};
    scoresJson.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        scores[key] = CategoryScore.fromJson(value);
      }
    });

    return AppInsight(
      id: json['id'] as int,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      countries: (json['countries'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      periodStart: DateTime.parse(json['period_start'] as String),
      periodEnd: DateTime.parse(json['period_end'] as String),
      categoryScores: scores,
      emergentThemes: (json['emergent_themes'] as List<dynamic>?)
              ?.map((e) => EmergentTheme.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      overallStrengths: (json['overall_strengths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      overallWeaknesses: (json['overall_weaknesses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      opportunities: (json['opportunities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      analyzedAt: DateTime.parse(json['analyzed_at'] as String),
      note: json['note'] as String?,
    );
  }
}

class InsightComparison {
  final int appId;
  final String appName;
  final String? iconUrl;
  final String platform;
  final AppInsight? insight;

  InsightComparison({
    required this.appId,
    required this.appName,
    this.iconUrl,
    required this.platform,
    this.insight,
  });

  factory InsightComparison.fromJson(Map<String, dynamic> json) {
    final appJson = json['app'] as Map<String, dynamic>;
    final insightJson = json['insight'] as Map<String, dynamic>?;

    return InsightComparison(
      appId: appJson['id'] as int,
      appName: appJson['name'] as String,
      iconUrl: appJson['icon_url'] as String?,
      platform: appJson['platform'] as String,
      insight: insightJson != null ? AppInsight.fromJson(insightJson) : null,
    );
  }
}
