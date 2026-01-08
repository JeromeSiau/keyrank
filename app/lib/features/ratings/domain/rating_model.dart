class CountryRating {
  final String country;
  final double? rating;
  final int ratingCount;
  final DateTime recordedAt;

  CountryRating({
    required this.country,
    this.rating,
    required this.ratingCount,
    required this.recordedAt,
  });

  factory CountryRating.fromJson(Map<String, dynamic> json) {
    return CountryRating(
      country: json['country'] as String,
      rating: _parseDouble(json['rating']),
      ratingCount: json['rating_count'] as int? ?? 0,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class AppRatingsResponse {
  final int appId;
  final int totalRatings;
  final double? averageRating;
  final List<CountryRating> ratings;
  final DateTime? lastUpdated;

  AppRatingsResponse({
    required this.appId,
    required this.totalRatings,
    this.averageRating,
    required this.ratings,
    this.lastUpdated,
  });

  factory AppRatingsResponse.fromJson(Map<String, dynamic> json) {
    return AppRatingsResponse(
      appId: json['app_id'] as int,
      totalRatings: json['total_ratings'] as int? ?? 0,
      averageRating: CountryRating._parseDouble(json['average_rating']),
      ratings: (json['ratings'] as List<dynamic>?)
              ?.map((e) => CountryRating.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'] as String)
          : null,
    );
  }
}
