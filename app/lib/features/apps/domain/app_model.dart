class AppModel {
  final int id;
  final String platform;
  final String storeId;
  final String? bundleId;
  final String name;
  final String? iconUrl;
  final String? developer;
  final double? rating;
  final int ratingCount;
  final String? storefront;
  final int? trackedKeywordsCount;
  final int? bestRank;
  final DateTime createdAt;
  final bool isFavorite;
  final DateTime? favoritedAt;

  AppModel({
    required this.id,
    required this.platform,
    required this.storeId,
    this.bundleId,
    required this.name,
    this.iconUrl,
    this.developer,
    this.rating,
    required this.ratingCount,
    this.storefront,
    this.trackedKeywordsCount,
    this.bestRank,
    required this.createdAt,
    this.isFavorite = false,
    this.favoritedAt,
  });

  bool get isIos => platform == 'ios';
  bool get isAndroid => platform == 'android';

  AppModel copyWith({
    int? id,
    String? platform,
    String? storeId,
    String? bundleId,
    String? name,
    String? iconUrl,
    String? developer,
    double? rating,
    int? ratingCount,
    String? storefront,
    int? trackedKeywordsCount,
    int? bestRank,
    DateTime? createdAt,
    bool? isFavorite,
    DateTime? favoritedAt,
  }) {
    return AppModel(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      storeId: storeId ?? this.storeId,
      bundleId: bundleId ?? this.bundleId,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      developer: developer ?? this.developer,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      storefront: storefront ?? this.storefront,
      trackedKeywordsCount: trackedKeywordsCount ?? this.trackedKeywordsCount,
      bestRank: bestRank ?? this.bestRank,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      favoritedAt: favoritedAt ?? this.favoritedAt,
    );
  }

  factory AppModel.fromJson(Map<String, dynamic> json) {
    return AppModel(
      id: json['id'] as int,
      platform: json['platform'] as String,
      storeId: json['store_id'] as String,
      bundleId: json['bundle_id'] as String?,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      developer: json['developer'] as String?,
      rating: _parseDouble(json['rating']),
      ratingCount: _parseInt(json['rating_count']) ?? 0,
      storefront: json['storefront'] as String?,
      trackedKeywordsCount: _parseInt(json['tracked_keywords_count']),
      bestRank: _parseInt(json['best_rank']),
      createdAt: DateTime.parse(json['created_at'] as String),
      isFavorite: json['is_favorite'] as bool? ?? false,
      favoritedAt: json['favorited_at'] != null
          ? DateTime.parse(json['favorited_at'] as String)
          : null,
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
