class AppModel {
  final int id;
  final int userId;
  final String? appleId;
  final String? googlePlayId;
  final String? bundleId;
  final String name;
  final String? iconUrl;
  final String? googleIconUrl;
  final String? developer;
  final double? rating;
  final int ratingCount;
  final double? googleRating;
  final int googleRatingCount;
  final String? storefront;
  final int? trackedKeywordsCount;
  final DateTime createdAt;

  AppModel({
    required this.id,
    required this.userId,
    this.appleId,
    this.googlePlayId,
    this.bundleId,
    required this.name,
    this.iconUrl,
    this.googleIconUrl,
    this.developer,
    this.rating,
    required this.ratingCount,
    this.googleRating,
    required this.googleRatingCount,
    this.storefront,
    this.trackedKeywordsCount,
    required this.createdAt,
  });

  bool get hasIos => appleId != null && appleId!.isNotEmpty;
  bool get hasAndroid => googlePlayId != null && googlePlayId!.isNotEmpty;

  /// Returns the best icon URL based on available platforms
  /// Prioritizes iOS icon if available, falls back to Android icon
  String? get displayIconUrl {
    if (hasIos && iconUrl != null) return iconUrl;
    if (hasAndroid && googleIconUrl != null) return googleIconUrl;
    return iconUrl ?? googleIconUrl;
  }

  List<String> get platforms {
    final list = <String>[];
    if (hasIos) list.add('ios');
    if (hasAndroid) list.add('android');
    return list;
  }

  factory AppModel.fromJson(Map<String, dynamic> json) {
    return AppModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      appleId: json['apple_id'] as String?,
      googlePlayId: json['google_play_id'] as String?,
      bundleId: json['bundle_id'] as String?,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      googleIconUrl: json['google_icon_url'] as String?,
      developer: json['developer'] as String?,
      rating: _parseDouble(json['rating']),
      ratingCount: _parseInt(json['rating_count']) ?? 0,
      googleRating: _parseDouble(json['google_rating']),
      googleRatingCount: _parseInt(json['google_rating_count']) ?? 0,
      storefront: json['storefront'] as String?,
      trackedKeywordsCount: _parseInt(json['tracked_keywords_count']),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class AppSearchResult {
  final int position;
  final String appleId;
  final String name;
  final String? bundleId;
  final String? iconUrl;
  final String? developer;
  final double price;
  final double? rating;
  final int ratingCount;

  AppSearchResult({
    required this.position,
    required this.appleId,
    required this.name,
    this.bundleId,
    this.iconUrl,
    this.developer,
    required this.price,
    this.rating,
    required this.ratingCount,
  });

  factory AppSearchResult.fromJson(Map<String, dynamic> json) {
    return AppSearchResult(
      position: json['position'] as int,
      appleId: json['apple_id'] as String,
      name: json['name'] as String,
      bundleId: json['bundle_id'] as String?,
      iconUrl: json['icon_url'] as String?,
      developer: json['developer'] as String?,
      price: AppModel._parseDouble(json['price']) ?? 0.0,
      rating: AppModel._parseDouble(json['rating']),
      ratingCount: AppModel._parseInt(json['rating_count']) ?? 0,
    );
  }
}

class AndroidSearchResult {
  final int position;
  final String googlePlayId;
  final String name;
  final String? iconUrl;
  final String? developer;
  final double? rating;
  final int ratingCount;
  final bool free;

  AndroidSearchResult({
    required this.position,
    required this.googlePlayId,
    required this.name,
    this.iconUrl,
    this.developer,
    this.rating,
    required this.ratingCount,
    required this.free,
  });

  factory AndroidSearchResult.fromJson(Map<String, dynamic> json) {
    return AndroidSearchResult(
      position: json['position'] as int,
      googlePlayId: json['google_play_id'] as String,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      developer: json['developer'] as String?,
      rating: AppModel._parseDouble(json['rating']),
      ratingCount: AppModel._parseInt(json['rating_count']) ?? 0,
      free: json['free'] as bool? ?? true,
    );
  }
}
