class AppModel {
  final int id;
  final String platform;
  final String storeId;
  final String? bundleId;
  final String name;
  final String? iconUrl;
  final String? developer;
  final String? description;
  final List<String>? screenshots;
  final String? version;
  final DateTime? releaseDate;
  final DateTime? updatedDate;
  final int? sizeBytes;
  final String? minimumOs;
  final String? storeUrl;
  final double? price;
  final String? currency;
  final double? rating;
  final int ratingCount;
  final String? storefront;
  final String? categoryId;
  final String? secondaryCategoryId;
  final int? trackedKeywordsCount;
  final int? bestRank;
  final DateTime createdAt;
  final bool isFavorite;
  final DateTime? favoritedAt;
  final bool isOwner;
  final bool isCompetitor;

  AppModel({
    required this.id,
    required this.platform,
    required this.storeId,
    this.bundleId,
    required this.name,
    this.iconUrl,
    this.developer,
    this.description,
    this.screenshots,
    this.version,
    this.releaseDate,
    this.updatedDate,
    this.sizeBytes,
    this.minimumOs,
    this.storeUrl,
    this.price,
    this.currency,
    this.rating,
    required this.ratingCount,
    this.storefront,
    this.categoryId,
    this.secondaryCategoryId,
    this.trackedKeywordsCount,
    this.bestRank,
    required this.createdAt,
    this.isFavorite = false,
    this.favoritedAt,
    this.isOwner = false,
    this.isCompetitor = false,
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
    String? description,
    List<String>? screenshots,
    String? version,
    DateTime? releaseDate,
    DateTime? updatedDate,
    int? sizeBytes,
    String? minimumOs,
    String? storeUrl,
    double? price,
    String? currency,
    double? rating,
    int? ratingCount,
    String? storefront,
    String? categoryId,
    String? secondaryCategoryId,
    int? trackedKeywordsCount,
    int? bestRank,
    DateTime? createdAt,
    bool? isFavorite,
    DateTime? favoritedAt,
    bool? isOwner,
    bool? isCompetitor,
  }) {
    return AppModel(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      storeId: storeId ?? this.storeId,
      bundleId: bundleId ?? this.bundleId,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      developer: developer ?? this.developer,
      description: description ?? this.description,
      screenshots: screenshots ?? this.screenshots,
      version: version ?? this.version,
      releaseDate: releaseDate ?? this.releaseDate,
      updatedDate: updatedDate ?? this.updatedDate,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      minimumOs: minimumOs ?? this.minimumOs,
      storeUrl: storeUrl ?? this.storeUrl,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      storefront: storefront ?? this.storefront,
      categoryId: categoryId ?? this.categoryId,
      secondaryCategoryId: secondaryCategoryId ?? this.secondaryCategoryId,
      trackedKeywordsCount: trackedKeywordsCount ?? this.trackedKeywordsCount,
      bestRank: bestRank ?? this.bestRank,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      favoritedAt: favoritedAt ?? this.favoritedAt,
      isOwner: isOwner ?? this.isOwner,
      isCompetitor: isCompetitor ?? this.isCompetitor,
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
      description: json['description'] as String?,
      screenshots: (json['screenshots'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      version: json['version'] as String?,
      releaseDate: json['release_date'] != null
          ? DateTime.tryParse(json['release_date'] as String)
          : null,
      updatedDate: json['updated_date'] != null
          ? DateTime.tryParse(json['updated_date'] as String)
          : null,
      sizeBytes: _parseInt(json['size_bytes']),
      minimumOs: json['minimum_os'] as String?,
      storeUrl: json['store_url'] as String?,
      price: _parseDouble(json['price']),
      currency: json['currency'] as String?,
      rating: _parseDouble(json['rating']),
      ratingCount: _parseInt(json['rating_count']) ?? 0,
      storefront: json['storefront'] as String?,
      categoryId: json['category_id'] as String?,
      secondaryCategoryId: json['secondary_category_id'] as String?,
      trackedKeywordsCount: _parseInt(json['tracked_keywords_count']),
      bestRank: _parseInt(json['best_rank']),
      createdAt: DateTime.parse(json['created_at'] as String),
      isFavorite: json['is_favorite'] as bool? ?? false,
      favoritedAt: json['favorited_at'] != null
          ? DateTime.parse(json['favorited_at'] as String)
          : null,
      isOwner: json['is_owner'] as bool? ?? false,
      isCompetitor: json['is_competitor'] as bool? ?? false,
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

/// Preview of an app that is not yet tracked by the user
class AppPreview {
  final String platform;
  final String storeId;
  final String name;
  final String? iconUrl;
  final String? developer;
  final String? description;
  final List<String>? screenshots;
  final String? version;
  final DateTime? releaseDate;
  final DateTime? updatedDate;
  final int? sizeBytes;
  final String? minimumOs;
  final String? storeUrl;
  final double? price;
  final String? currency;
  final double? rating;
  final int ratingCount;
  final String? categoryId;
  final String? categoryName;

  AppPreview({
    required this.platform,
    required this.storeId,
    required this.name,
    this.iconUrl,
    this.developer,
    this.description,
    this.screenshots,
    this.version,
    this.releaseDate,
    this.updatedDate,
    this.sizeBytes,
    this.minimumOs,
    this.storeUrl,
    this.price,
    this.currency,
    this.rating,
    required this.ratingCount,
    this.categoryId,
    this.categoryName,
  });

  bool get isIos => platform == 'ios';
  bool get isAndroid => platform == 'android';

  factory AppPreview.fromJson(Map<String, dynamic> json) {
    return AppPreview(
      platform: json['platform'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      developer: json['developer'] as String?,
      description: json['description'] as String?,
      screenshots: (json['screenshots'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      version: json['version'] as String?,
      releaseDate: json['release_date'] != null
          ? DateTime.tryParse(json['release_date'] as String)
          : null,
      updatedDate: json['updated_date'] != null
          ? DateTime.tryParse(json['updated_date'] as String)
          : null,
      sizeBytes: AppModel._parseInt(json['size_bytes']),
      minimumOs: json['minimum_os'] as String?,
      storeUrl: json['store_url'] as String?,
      price: AppModel._parseDouble(json['price']),
      currency: json['currency'] as String?,
      rating: AppModel._parseDouble(json['rating']),
      ratingCount: AppModel._parseInt(json['rating_count']) ?? 0,
      categoryId: json['category_id'] as String?,
      categoryName: json['category_name'] as String?,
    );
  }
}
