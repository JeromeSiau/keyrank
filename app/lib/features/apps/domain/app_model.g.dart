// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppModelImpl _$$AppModelImplFromJson(Map<String, dynamic> json) =>
    _$AppModelImpl(
      id: (json['id'] as num).toInt(),
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
      releaseDate: json['release_date'] == null
          ? null
          : DateTime.parse(json['release_date'] as String),
      updatedDate: json['updated_date'] == null
          ? null
          : DateTime.parse(json['updated_date'] as String),
      sizeBytes: _parseInt(json['size_bytes']),
      minimumOs: json['minimum_os'] as String?,
      storeUrl: json['store_url'] as String?,
      price: _parseDouble(json['price']),
      currency: json['currency'] as String?,
      rating: _parseDouble(json['rating']),
      ratingCount: _parseIntOrZero(json['rating_count']),
      storefront: json['storefront'] as String?,
      categoryId: json['category_id'] as String?,
      secondaryCategoryId: json['secondary_category_id'] as String?,
      trackedKeywordsCount: _parseInt(json['tracked_keywords_count']),
      bestRank: _parseInt(json['best_rank']),
      createdAt: DateTime.parse(json['created_at'] as String),
      isFavorite: json['is_favorite'] as bool? ?? false,
      favoritedAt: json['favorited_at'] == null
          ? null
          : DateTime.parse(json['favorited_at'] as String),
      isOwner: json['is_owner'] as bool? ?? false,
      isCompetitor: json['is_competitor'] as bool? ?? false,
    );

Map<String, dynamic> _$$AppModelImplToJson(_$AppModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'platform': instance.platform,
      'store_id': instance.storeId,
      'bundle_id': instance.bundleId,
      'name': instance.name,
      'icon_url': instance.iconUrl,
      'developer': instance.developer,
      'description': instance.description,
      'screenshots': instance.screenshots,
      'version': instance.version,
      'release_date': instance.releaseDate?.toIso8601String(),
      'updated_date': instance.updatedDate?.toIso8601String(),
      'size_bytes': instance.sizeBytes,
      'minimum_os': instance.minimumOs,
      'store_url': instance.storeUrl,
      'price': instance.price,
      'currency': instance.currency,
      'rating': instance.rating,
      'rating_count': instance.ratingCount,
      'storefront': instance.storefront,
      'category_id': instance.categoryId,
      'secondary_category_id': instance.secondaryCategoryId,
      'tracked_keywords_count': instance.trackedKeywordsCount,
      'best_rank': instance.bestRank,
      'created_at': instance.createdAt.toIso8601String(),
      'is_favorite': instance.isFavorite,
      'favorited_at': instance.favoritedAt?.toIso8601String(),
      'is_owner': instance.isOwner,
      'is_competitor': instance.isCompetitor,
    };

_$AppSearchResultImpl _$$AppSearchResultImplFromJson(
  Map<String, dynamic> json,
) => _$AppSearchResultImpl(
  position: (json['position'] as num).toInt(),
  appleId: json['apple_id'] as String,
  name: json['name'] as String,
  bundleId: json['bundle_id'] as String?,
  iconUrl: json['icon_url'] as String?,
  developer: json['developer'] as String?,
  price: _parseDoubleOrZero(json['price']),
  rating: _parseDouble(json['rating']),
  ratingCount: _parseIntOrZero(json['rating_count']),
);

Map<String, dynamic> _$$AppSearchResultImplToJson(
  _$AppSearchResultImpl instance,
) => <String, dynamic>{
  'position': instance.position,
  'apple_id': instance.appleId,
  'name': instance.name,
  'bundle_id': instance.bundleId,
  'icon_url': instance.iconUrl,
  'developer': instance.developer,
  'price': instance.price,
  'rating': instance.rating,
  'rating_count': instance.ratingCount,
};

_$AndroidSearchResultImpl _$$AndroidSearchResultImplFromJson(
  Map<String, dynamic> json,
) => _$AndroidSearchResultImpl(
  position: (json['position'] as num).toInt(),
  googlePlayId: json['google_play_id'] as String,
  name: json['name'] as String,
  iconUrl: json['icon_url'] as String?,
  developer: json['developer'] as String?,
  rating: _parseDouble(json['rating']),
  ratingCount: _parseIntOrZero(json['rating_count']),
  free: json['free'] as bool? ?? true,
);

Map<String, dynamic> _$$AndroidSearchResultImplToJson(
  _$AndroidSearchResultImpl instance,
) => <String, dynamic>{
  'position': instance.position,
  'google_play_id': instance.googlePlayId,
  'name': instance.name,
  'icon_url': instance.iconUrl,
  'developer': instance.developer,
  'rating': instance.rating,
  'rating_count': instance.ratingCount,
  'free': instance.free,
};

_$AppPreviewImpl _$$AppPreviewImplFromJson(Map<String, dynamic> json) =>
    _$AppPreviewImpl(
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
      releaseDate: json['release_date'] == null
          ? null
          : DateTime.parse(json['release_date'] as String),
      updatedDate: json['updated_date'] == null
          ? null
          : DateTime.parse(json['updated_date'] as String),
      sizeBytes: _parseInt(json['size_bytes']),
      minimumOs: json['minimum_os'] as String?,
      storeUrl: json['store_url'] as String?,
      price: _parseDouble(json['price']),
      currency: json['currency'] as String?,
      rating: _parseDouble(json['rating']),
      ratingCount: _parseIntOrZero(json['rating_count']),
      categoryId: json['category_id'] as String?,
      categoryName: json['category_name'] as String?,
    );

Map<String, dynamic> _$$AppPreviewImplToJson(_$AppPreviewImpl instance) =>
    <String, dynamic>{
      'platform': instance.platform,
      'store_id': instance.storeId,
      'name': instance.name,
      'icon_url': instance.iconUrl,
      'developer': instance.developer,
      'description': instance.description,
      'screenshots': instance.screenshots,
      'version': instance.version,
      'release_date': instance.releaseDate?.toIso8601String(),
      'updated_date': instance.updatedDate?.toIso8601String(),
      'size_bytes': instance.sizeBytes,
      'minimum_os': instance.minimumOs,
      'store_url': instance.storeUrl,
      'price': instance.price,
      'currency': instance.currency,
      'rating': instance.rating,
      'rating_count': instance.ratingCount,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
    };
