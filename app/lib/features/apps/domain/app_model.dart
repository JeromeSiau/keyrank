import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_model.freezed.dart';
part 'app_model.g.dart';

@freezed
class AppModel with _$AppModel {
  const AppModel._();

  const factory AppModel({
    required int id,
    required String platform,
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'bundle_id') String? bundleId,
    required String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? developer,
    String? description,
    List<String>? screenshots,
    String? version,
    @JsonKey(name: 'release_date') DateTime? releaseDate,
    @JsonKey(name: 'updated_date') DateTime? updatedDate,
    @JsonKey(name: 'size_bytes', fromJson: _parseInt) int? sizeBytes,
    @JsonKey(name: 'minimum_os') String? minimumOs,
    @JsonKey(name: 'store_url') String? storeUrl,
    @JsonKey(fromJson: _parseDouble) double? price,
    String? currency,
    @JsonKey(fromJson: _parseDouble) double? rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero) required int ratingCount,
    String? storefront,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'secondary_category_id') String? secondaryCategoryId,
    @JsonKey(name: 'tracked_keywords_count', fromJson: _parseInt) int? trackedKeywordsCount,
    @JsonKey(name: 'best_rank', fromJson: _parseInt) int? bestRank,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'is_favorite') @Default(false) bool isFavorite,
    @JsonKey(name: 'favorited_at') DateTime? favoritedAt,
    @JsonKey(name: 'is_owner') @Default(false) bool isOwner,
    @JsonKey(name: 'is_competitor') @Default(false) bool isCompetitor,
  }) = _AppModel;

  factory AppModel.fromJson(Map<String, dynamic> json) => _$AppModelFromJson(json);

  bool get isIos => platform == 'ios';
  bool get isAndroid => platform == 'android';
}

@freezed
class AppSearchResult with _$AppSearchResult {
  const factory AppSearchResult({
    required int position,
    @JsonKey(name: 'apple_id') required String appleId,
    required String name,
    @JsonKey(name: 'bundle_id') String? bundleId,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? developer,
    @JsonKey(fromJson: _parseDoubleOrZero) required double price,
    @JsonKey(fromJson: _parseDouble) double? rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero) required int ratingCount,
  }) = _AppSearchResult;

  factory AppSearchResult.fromJson(Map<String, dynamic> json) =>
      _$AppSearchResultFromJson(json);
}

@freezed
class AndroidSearchResult with _$AndroidSearchResult {
  const factory AndroidSearchResult({
    required int position,
    @JsonKey(name: 'google_play_id') required String googlePlayId,
    required String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? developer,
    @JsonKey(fromJson: _parseDouble) double? rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero) required int ratingCount,
    @Default(true) bool free,
  }) = _AndroidSearchResult;

  factory AndroidSearchResult.fromJson(Map<String, dynamic> json) =>
      _$AndroidSearchResultFromJson(json);
}

/// Preview of an app that is not yet tracked by the user
@freezed
class AppPreview with _$AppPreview {
  const AppPreview._();

  const factory AppPreview({
    required String platform,
    @JsonKey(name: 'store_id') required String storeId,
    required String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? developer,
    String? description,
    List<String>? screenshots,
    String? version,
    @JsonKey(name: 'release_date') DateTime? releaseDate,
    @JsonKey(name: 'updated_date') DateTime? updatedDate,
    @JsonKey(name: 'size_bytes', fromJson: _parseInt) int? sizeBytes,
    @JsonKey(name: 'minimum_os') String? minimumOs,
    @JsonKey(name: 'store_url') String? storeUrl,
    @JsonKey(fromJson: _parseDouble) double? price,
    String? currency,
    @JsonKey(fromJson: _parseDouble) double? rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero) required int ratingCount,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'category_name') String? categoryName,
  }) = _AppPreview;

  factory AppPreview.fromJson(Map<String, dynamic> json) => _$AppPreviewFromJson(json);

  bool get isIos => platform == 'ios';
  bool get isAndroid => platform == 'android';
}

// JSON parsing helpers
double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

double _parseDoubleOrZero(dynamic value) => _parseDouble(value) ?? 0.0;

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

int _parseIntOrZero(dynamic value) => _parseInt(value) ?? 0;
