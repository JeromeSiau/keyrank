// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppModel _$AppModelFromJson(Map<String, dynamic> json) {
  return _AppModel.fromJson(json);
}

/// @nodoc
mixin _$AppModel {
  int get id => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'bundle_id')
  String? get bundleId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  String? get developer => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String>? get screenshots => throw _privateConstructorUsedError;
  String? get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'release_date')
  DateTime? get releaseDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_date')
  DateTime? get updatedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'size_bytes', fromJson: _parseInt)
  int? get sizeBytes => throw _privateConstructorUsedError;
  @JsonKey(name: 'minimum_os')
  String? get minimumOs => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_url')
  String? get storeUrl => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get price => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
  int get ratingCount => throw _privateConstructorUsedError;
  String? get storefront => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'secondary_category_id')
  String? get secondaryCategoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'tracked_keywords_count', fromJson: _parseInt)
  int? get trackedKeywordsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'best_rank', fromJson: _parseInt)
  int? get bestRank => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_favorite')
  bool get isFavorite => throw _privateConstructorUsedError;
  @JsonKey(name: 'favorited_at')
  DateTime? get favoritedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_owner')
  bool get isOwner => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_competitor')
  bool get isCompetitor => throw _privateConstructorUsedError;

  /// Serializes this AppModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppModelCopyWith<AppModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppModelCopyWith<$Res> {
  factory $AppModelCopyWith(AppModel value, $Res Function(AppModel) then) =
      _$AppModelCopyWithImpl<$Res, AppModel>;
  @useResult
  $Res call({
    int id,
    String platform,
    @JsonKey(name: 'store_id') String storeId,
    @JsonKey(name: 'bundle_id') String? bundleId,
    String name,
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
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero) int ratingCount,
    String? storefront,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'secondary_category_id') String? secondaryCategoryId,
    @JsonKey(name: 'tracked_keywords_count', fromJson: _parseInt)
    int? trackedKeywordsCount,
    @JsonKey(name: 'best_rank', fromJson: _parseInt) int? bestRank,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'is_favorite') bool isFavorite,
    @JsonKey(name: 'favorited_at') DateTime? favoritedAt,
    @JsonKey(name: 'is_owner') bool isOwner,
    @JsonKey(name: 'is_competitor') bool isCompetitor,
  });
}

/// @nodoc
class _$AppModelCopyWithImpl<$Res, $Val extends AppModel>
    implements $AppModelCopyWith<$Res> {
  _$AppModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? platform = null,
    Object? storeId = null,
    Object? bundleId = freezed,
    Object? name = null,
    Object? iconUrl = freezed,
    Object? developer = freezed,
    Object? description = freezed,
    Object? screenshots = freezed,
    Object? version = freezed,
    Object? releaseDate = freezed,
    Object? updatedDate = freezed,
    Object? sizeBytes = freezed,
    Object? minimumOs = freezed,
    Object? storeUrl = freezed,
    Object? price = freezed,
    Object? currency = freezed,
    Object? rating = freezed,
    Object? ratingCount = null,
    Object? storefront = freezed,
    Object? categoryId = freezed,
    Object? secondaryCategoryId = freezed,
    Object? trackedKeywordsCount = freezed,
    Object? bestRank = freezed,
    Object? createdAt = null,
    Object? isFavorite = null,
    Object? favoritedAt = freezed,
    Object? isOwner = null,
    Object? isCompetitor = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            platform: null == platform
                ? _value.platform
                : platform // ignore: cast_nullable_to_non_nullable
                      as String,
            storeId: null == storeId
                ? _value.storeId
                : storeId // ignore: cast_nullable_to_non_nullable
                      as String,
            bundleId: freezed == bundleId
                ? _value.bundleId
                : bundleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            developer: freezed == developer
                ? _value.developer
                : developer // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            screenshots: freezed == screenshots
                ? _value.screenshots
                : screenshots // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            version: freezed == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String?,
            releaseDate: freezed == releaseDate
                ? _value.releaseDate
                : releaseDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedDate: freezed == updatedDate
                ? _value.updatedDate
                : updatedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            sizeBytes: freezed == sizeBytes
                ? _value.sizeBytes
                : sizeBytes // ignore: cast_nullable_to_non_nullable
                      as int?,
            minimumOs: freezed == minimumOs
                ? _value.minimumOs
                : minimumOs // ignore: cast_nullable_to_non_nullable
                      as String?,
            storeUrl: freezed == storeUrl
                ? _value.storeUrl
                : storeUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double?,
            currency: freezed == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String?,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
            ratingCount: null == ratingCount
                ? _value.ratingCount
                : ratingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            storefront: freezed == storefront
                ? _value.storefront
                : storefront // ignore: cast_nullable_to_non_nullable
                      as String?,
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            secondaryCategoryId: freezed == secondaryCategoryId
                ? _value.secondaryCategoryId
                : secondaryCategoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            trackedKeywordsCount: freezed == trackedKeywordsCount
                ? _value.trackedKeywordsCount
                : trackedKeywordsCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            bestRank: freezed == bestRank
                ? _value.bestRank
                : bestRank // ignore: cast_nullable_to_non_nullable
                      as int?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isFavorite: null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
            favoritedAt: freezed == favoritedAt
                ? _value.favoritedAt
                : favoritedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isOwner: null == isOwner
                ? _value.isOwner
                : isOwner // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCompetitor: null == isCompetitor
                ? _value.isCompetitor
                : isCompetitor // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppModelImplCopyWith<$Res>
    implements $AppModelCopyWith<$Res> {
  factory _$$AppModelImplCopyWith(
    _$AppModelImpl value,
    $Res Function(_$AppModelImpl) then,
  ) = __$$AppModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String platform,
    @JsonKey(name: 'store_id') String storeId,
    @JsonKey(name: 'bundle_id') String? bundleId,
    String name,
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
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero) int ratingCount,
    String? storefront,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'secondary_category_id') String? secondaryCategoryId,
    @JsonKey(name: 'tracked_keywords_count', fromJson: _parseInt)
    int? trackedKeywordsCount,
    @JsonKey(name: 'best_rank', fromJson: _parseInt) int? bestRank,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'is_favorite') bool isFavorite,
    @JsonKey(name: 'favorited_at') DateTime? favoritedAt,
    @JsonKey(name: 'is_owner') bool isOwner,
    @JsonKey(name: 'is_competitor') bool isCompetitor,
  });
}

/// @nodoc
class __$$AppModelImplCopyWithImpl<$Res>
    extends _$AppModelCopyWithImpl<$Res, _$AppModelImpl>
    implements _$$AppModelImplCopyWith<$Res> {
  __$$AppModelImplCopyWithImpl(
    _$AppModelImpl _value,
    $Res Function(_$AppModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? platform = null,
    Object? storeId = null,
    Object? bundleId = freezed,
    Object? name = null,
    Object? iconUrl = freezed,
    Object? developer = freezed,
    Object? description = freezed,
    Object? screenshots = freezed,
    Object? version = freezed,
    Object? releaseDate = freezed,
    Object? updatedDate = freezed,
    Object? sizeBytes = freezed,
    Object? minimumOs = freezed,
    Object? storeUrl = freezed,
    Object? price = freezed,
    Object? currency = freezed,
    Object? rating = freezed,
    Object? ratingCount = null,
    Object? storefront = freezed,
    Object? categoryId = freezed,
    Object? secondaryCategoryId = freezed,
    Object? trackedKeywordsCount = freezed,
    Object? bestRank = freezed,
    Object? createdAt = null,
    Object? isFavorite = null,
    Object? favoritedAt = freezed,
    Object? isOwner = null,
    Object? isCompetitor = null,
  }) {
    return _then(
      _$AppModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        platform: null == platform
            ? _value.platform
            : platform // ignore: cast_nullable_to_non_nullable
                  as String,
        storeId: null == storeId
            ? _value.storeId
            : storeId // ignore: cast_nullable_to_non_nullable
                  as String,
        bundleId: freezed == bundleId
            ? _value.bundleId
            : bundleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        developer: freezed == developer
            ? _value.developer
            : developer // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        screenshots: freezed == screenshots
            ? _value._screenshots
            : screenshots // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        version: freezed == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String?,
        releaseDate: freezed == releaseDate
            ? _value.releaseDate
            : releaseDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedDate: freezed == updatedDate
            ? _value.updatedDate
            : updatedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        sizeBytes: freezed == sizeBytes
            ? _value.sizeBytes
            : sizeBytes // ignore: cast_nullable_to_non_nullable
                  as int?,
        minimumOs: freezed == minimumOs
            ? _value.minimumOs
            : minimumOs // ignore: cast_nullable_to_non_nullable
                  as String?,
        storeUrl: freezed == storeUrl
            ? _value.storeUrl
            : storeUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double?,
        currency: freezed == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String?,
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
        ratingCount: null == ratingCount
            ? _value.ratingCount
            : ratingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        storefront: freezed == storefront
            ? _value.storefront
            : storefront // ignore: cast_nullable_to_non_nullable
                  as String?,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        secondaryCategoryId: freezed == secondaryCategoryId
            ? _value.secondaryCategoryId
            : secondaryCategoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        trackedKeywordsCount: freezed == trackedKeywordsCount
            ? _value.trackedKeywordsCount
            : trackedKeywordsCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        bestRank: freezed == bestRank
            ? _value.bestRank
            : bestRank // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isFavorite: null == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
        favoritedAt: freezed == favoritedAt
            ? _value.favoritedAt
            : favoritedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isOwner: null == isOwner
            ? _value.isOwner
            : isOwner // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCompetitor: null == isCompetitor
            ? _value.isCompetitor
            : isCompetitor // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppModelImpl extends _AppModel {
  const _$AppModelImpl({
    required this.id,
    required this.platform,
    @JsonKey(name: 'store_id') required this.storeId,
    @JsonKey(name: 'bundle_id') this.bundleId,
    required this.name,
    @JsonKey(name: 'icon_url') this.iconUrl,
    this.developer,
    this.description,
    final List<String>? screenshots,
    this.version,
    @JsonKey(name: 'release_date') this.releaseDate,
    @JsonKey(name: 'updated_date') this.updatedDate,
    @JsonKey(name: 'size_bytes', fromJson: _parseInt) this.sizeBytes,
    @JsonKey(name: 'minimum_os') this.minimumOs,
    @JsonKey(name: 'store_url') this.storeUrl,
    @JsonKey(fromJson: _parseDouble) this.price,
    this.currency,
    @JsonKey(fromJson: _parseDouble) this.rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
    required this.ratingCount,
    this.storefront,
    @JsonKey(name: 'category_id') this.categoryId,
    @JsonKey(name: 'secondary_category_id') this.secondaryCategoryId,
    @JsonKey(name: 'tracked_keywords_count', fromJson: _parseInt)
    this.trackedKeywordsCount,
    @JsonKey(name: 'best_rank', fromJson: _parseInt) this.bestRank,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'is_favorite') this.isFavorite = false,
    @JsonKey(name: 'favorited_at') this.favoritedAt,
    @JsonKey(name: 'is_owner') this.isOwner = false,
    @JsonKey(name: 'is_competitor') this.isCompetitor = false,
  }) : _screenshots = screenshots,
       super._();

  factory _$AppModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppModelImplFromJson(json);

  @override
  final int id;
  @override
  final String platform;
  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  @JsonKey(name: 'bundle_id')
  final String? bundleId;
  @override
  final String name;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  final String? developer;
  @override
  final String? description;
  final List<String>? _screenshots;
  @override
  List<String>? get screenshots {
    final value = _screenshots;
    if (value == null) return null;
    if (_screenshots is EqualUnmodifiableListView) return _screenshots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? version;
  @override
  @JsonKey(name: 'release_date')
  final DateTime? releaseDate;
  @override
  @JsonKey(name: 'updated_date')
  final DateTime? updatedDate;
  @override
  @JsonKey(name: 'size_bytes', fromJson: _parseInt)
  final int? sizeBytes;
  @override
  @JsonKey(name: 'minimum_os')
  final String? minimumOs;
  @override
  @JsonKey(name: 'store_url')
  final String? storeUrl;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double? price;
  @override
  final String? currency;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double? rating;
  @override
  @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
  final int ratingCount;
  @override
  final String? storefront;
  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @override
  @JsonKey(name: 'secondary_category_id')
  final String? secondaryCategoryId;
  @override
  @JsonKey(name: 'tracked_keywords_count', fromJson: _parseInt)
  final int? trackedKeywordsCount;
  @override
  @JsonKey(name: 'best_rank', fromJson: _parseInt)
  final int? bestRank;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'is_favorite')
  final bool isFavorite;
  @override
  @JsonKey(name: 'favorited_at')
  final DateTime? favoritedAt;
  @override
  @JsonKey(name: 'is_owner')
  final bool isOwner;
  @override
  @JsonKey(name: 'is_competitor')
  final bool isCompetitor;

  @override
  String toString() {
    return 'AppModel(id: $id, platform: $platform, storeId: $storeId, bundleId: $bundleId, name: $name, iconUrl: $iconUrl, developer: $developer, description: $description, screenshots: $screenshots, version: $version, releaseDate: $releaseDate, updatedDate: $updatedDate, sizeBytes: $sizeBytes, minimumOs: $minimumOs, storeUrl: $storeUrl, price: $price, currency: $currency, rating: $rating, ratingCount: $ratingCount, storefront: $storefront, categoryId: $categoryId, secondaryCategoryId: $secondaryCategoryId, trackedKeywordsCount: $trackedKeywordsCount, bestRank: $bestRank, createdAt: $createdAt, isFavorite: $isFavorite, favoritedAt: $favoritedAt, isOwner: $isOwner, isCompetitor: $isCompetitor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.bundleId, bundleId) ||
                other.bundleId == bundleId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.developer, developer) ||
                other.developer == developer) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._screenshots,
              _screenshots,
            ) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.updatedDate, updatedDate) ||
                other.updatedDate == updatedDate) &&
            (identical(other.sizeBytes, sizeBytes) ||
                other.sizeBytes == sizeBytes) &&
            (identical(other.minimumOs, minimumOs) ||
                other.minimumOs == minimumOs) &&
            (identical(other.storeUrl, storeUrl) ||
                other.storeUrl == storeUrl) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.storefront, storefront) ||
                other.storefront == storefront) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.secondaryCategoryId, secondaryCategoryId) ||
                other.secondaryCategoryId == secondaryCategoryId) &&
            (identical(other.trackedKeywordsCount, trackedKeywordsCount) ||
                other.trackedKeywordsCount == trackedKeywordsCount) &&
            (identical(other.bestRank, bestRank) ||
                other.bestRank == bestRank) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.favoritedAt, favoritedAt) ||
                other.favoritedAt == favoritedAt) &&
            (identical(other.isOwner, isOwner) || other.isOwner == isOwner) &&
            (identical(other.isCompetitor, isCompetitor) ||
                other.isCompetitor == isCompetitor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    platform,
    storeId,
    bundleId,
    name,
    iconUrl,
    developer,
    description,
    const DeepCollectionEquality().hash(_screenshots),
    version,
    releaseDate,
    updatedDate,
    sizeBytes,
    minimumOs,
    storeUrl,
    price,
    currency,
    rating,
    ratingCount,
    storefront,
    categoryId,
    secondaryCategoryId,
    trackedKeywordsCount,
    bestRank,
    createdAt,
    isFavorite,
    favoritedAt,
    isOwner,
    isCompetitor,
  ]);

  /// Create a copy of AppModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppModelImplCopyWith<_$AppModelImpl> get copyWith =>
      __$$AppModelImplCopyWithImpl<_$AppModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppModelImplToJson(this);
  }
}

abstract class _AppModel extends AppModel {
  const factory _AppModel({
    required final int id,
    required final String platform,
    @JsonKey(name: 'store_id') required final String storeId,
    @JsonKey(name: 'bundle_id') final String? bundleId,
    required final String name,
    @JsonKey(name: 'icon_url') final String? iconUrl,
    final String? developer,
    final String? description,
    final List<String>? screenshots,
    final String? version,
    @JsonKey(name: 'release_date') final DateTime? releaseDate,
    @JsonKey(name: 'updated_date') final DateTime? updatedDate,
    @JsonKey(name: 'size_bytes', fromJson: _parseInt) final int? sizeBytes,
    @JsonKey(name: 'minimum_os') final String? minimumOs,
    @JsonKey(name: 'store_url') final String? storeUrl,
    @JsonKey(fromJson: _parseDouble) final double? price,
    final String? currency,
    @JsonKey(fromJson: _parseDouble) final double? rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
    required final int ratingCount,
    final String? storefront,
    @JsonKey(name: 'category_id') final String? categoryId,
    @JsonKey(name: 'secondary_category_id') final String? secondaryCategoryId,
    @JsonKey(name: 'tracked_keywords_count', fromJson: _parseInt)
    final int? trackedKeywordsCount,
    @JsonKey(name: 'best_rank', fromJson: _parseInt) final int? bestRank,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'is_favorite') final bool isFavorite,
    @JsonKey(name: 'favorited_at') final DateTime? favoritedAt,
    @JsonKey(name: 'is_owner') final bool isOwner,
    @JsonKey(name: 'is_competitor') final bool isCompetitor,
  }) = _$AppModelImpl;
  const _AppModel._() : super._();

  factory _AppModel.fromJson(Map<String, dynamic> json) =
      _$AppModelImpl.fromJson;

  @override
  int get id;
  @override
  String get platform;
  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  @JsonKey(name: 'bundle_id')
  String? get bundleId;
  @override
  String get name;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  String? get developer;
  @override
  String? get description;
  @override
  List<String>? get screenshots;
  @override
  String? get version;
  @override
  @JsonKey(name: 'release_date')
  DateTime? get releaseDate;
  @override
  @JsonKey(name: 'updated_date')
  DateTime? get updatedDate;
  @override
  @JsonKey(name: 'size_bytes', fromJson: _parseInt)
  int? get sizeBytes;
  @override
  @JsonKey(name: 'minimum_os')
  String? get minimumOs;
  @override
  @JsonKey(name: 'store_url')
  String? get storeUrl;
  @override
  @JsonKey(fromJson: _parseDouble)
  double? get price;
  @override
  String? get currency;
  @override
  @JsonKey(fromJson: _parseDouble)
  double? get rating;
  @override
  @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
  int get ratingCount;
  @override
  String? get storefront;
  @override
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override
  @JsonKey(name: 'secondary_category_id')
  String? get secondaryCategoryId;
  @override
  @JsonKey(name: 'tracked_keywords_count', fromJson: _parseInt)
  int? get trackedKeywordsCount;
  @override
  @JsonKey(name: 'best_rank', fromJson: _parseInt)
  int? get bestRank;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'is_favorite')
  bool get isFavorite;
  @override
  @JsonKey(name: 'favorited_at')
  DateTime? get favoritedAt;
  @override
  @JsonKey(name: 'is_owner')
  bool get isOwner;
  @override
  @JsonKey(name: 'is_competitor')
  bool get isCompetitor;

  /// Create a copy of AppModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppModelImplCopyWith<_$AppModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppSearchResult _$AppSearchResultFromJson(Map<String, dynamic> json) {
  return _AppSearchResult.fromJson(json);
}

/// @nodoc
mixin _$AppSearchResult {
  int get position => throw _privateConstructorUsedError;
  @JsonKey(name: 'apple_id')
  String get appleId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'bundle_id')
  String? get bundleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  String? get developer => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDoubleOrZero)
  double get price => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
  int get ratingCount => throw _privateConstructorUsedError;

  /// Serializes this AppSearchResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSearchResultCopyWith<AppSearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSearchResultCopyWith<$Res> {
  factory $AppSearchResultCopyWith(
    AppSearchResult value,
    $Res Function(AppSearchResult) then,
  ) = _$AppSearchResultCopyWithImpl<$Res, AppSearchResult>;
  @useResult
  $Res call({
    int position,
    @JsonKey(name: 'apple_id') String appleId,
    String name,
    @JsonKey(name: 'bundle_id') String? bundleId,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? developer,
    @JsonKey(fromJson: _parseDoubleOrZero) double price,
    @JsonKey(fromJson: _parseDouble) double? rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero) int ratingCount,
  });
}

/// @nodoc
class _$AppSearchResultCopyWithImpl<$Res, $Val extends AppSearchResult>
    implements $AppSearchResultCopyWith<$Res> {
  _$AppSearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? appleId = null,
    Object? name = null,
    Object? bundleId = freezed,
    Object? iconUrl = freezed,
    Object? developer = freezed,
    Object? price = null,
    Object? rating = freezed,
    Object? ratingCount = null,
  }) {
    return _then(
      _value.copyWith(
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int,
            appleId: null == appleId
                ? _value.appleId
                : appleId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            bundleId: freezed == bundleId
                ? _value.bundleId
                : bundleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            developer: freezed == developer
                ? _value.developer
                : developer // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
            ratingCount: null == ratingCount
                ? _value.ratingCount
                : ratingCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppSearchResultImplCopyWith<$Res>
    implements $AppSearchResultCopyWith<$Res> {
  factory _$$AppSearchResultImplCopyWith(
    _$AppSearchResultImpl value,
    $Res Function(_$AppSearchResultImpl) then,
  ) = __$$AppSearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int position,
    @JsonKey(name: 'apple_id') String appleId,
    String name,
    @JsonKey(name: 'bundle_id') String? bundleId,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? developer,
    @JsonKey(fromJson: _parseDoubleOrZero) double price,
    @JsonKey(fromJson: _parseDouble) double? rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero) int ratingCount,
  });
}

/// @nodoc
class __$$AppSearchResultImplCopyWithImpl<$Res>
    extends _$AppSearchResultCopyWithImpl<$Res, _$AppSearchResultImpl>
    implements _$$AppSearchResultImplCopyWith<$Res> {
  __$$AppSearchResultImplCopyWithImpl(
    _$AppSearchResultImpl _value,
    $Res Function(_$AppSearchResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? appleId = null,
    Object? name = null,
    Object? bundleId = freezed,
    Object? iconUrl = freezed,
    Object? developer = freezed,
    Object? price = null,
    Object? rating = freezed,
    Object? ratingCount = null,
  }) {
    return _then(
      _$AppSearchResultImpl(
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
        appleId: null == appleId
            ? _value.appleId
            : appleId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        bundleId: freezed == bundleId
            ? _value.bundleId
            : bundleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        developer: freezed == developer
            ? _value.developer
            : developer // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
        ratingCount: null == ratingCount
            ? _value.ratingCount
            : ratingCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSearchResultImpl implements _AppSearchResult {
  const _$AppSearchResultImpl({
    required this.position,
    @JsonKey(name: 'apple_id') required this.appleId,
    required this.name,
    @JsonKey(name: 'bundle_id') this.bundleId,
    @JsonKey(name: 'icon_url') this.iconUrl,
    this.developer,
    @JsonKey(fromJson: _parseDoubleOrZero) required this.price,
    @JsonKey(fromJson: _parseDouble) this.rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
    required this.ratingCount,
  });

  factory _$AppSearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSearchResultImplFromJson(json);

  @override
  final int position;
  @override
  @JsonKey(name: 'apple_id')
  final String appleId;
  @override
  final String name;
  @override
  @JsonKey(name: 'bundle_id')
  final String? bundleId;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  final String? developer;
  @override
  @JsonKey(fromJson: _parseDoubleOrZero)
  final double price;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double? rating;
  @override
  @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
  final int ratingCount;

  @override
  String toString() {
    return 'AppSearchResult(position: $position, appleId: $appleId, name: $name, bundleId: $bundleId, iconUrl: $iconUrl, developer: $developer, price: $price, rating: $rating, ratingCount: $ratingCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSearchResultImpl &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.appleId, appleId) || other.appleId == appleId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.bundleId, bundleId) ||
                other.bundleId == bundleId) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.developer, developer) ||
                other.developer == developer) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    position,
    appleId,
    name,
    bundleId,
    iconUrl,
    developer,
    price,
    rating,
    ratingCount,
  );

  /// Create a copy of AppSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSearchResultImplCopyWith<_$AppSearchResultImpl> get copyWith =>
      __$$AppSearchResultImplCopyWithImpl<_$AppSearchResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSearchResultImplToJson(this);
  }
}

abstract class _AppSearchResult implements AppSearchResult {
  const factory _AppSearchResult({
    required final int position,
    @JsonKey(name: 'apple_id') required final String appleId,
    required final String name,
    @JsonKey(name: 'bundle_id') final String? bundleId,
    @JsonKey(name: 'icon_url') final String? iconUrl,
    final String? developer,
    @JsonKey(fromJson: _parseDoubleOrZero) required final double price,
    @JsonKey(fromJson: _parseDouble) final double? rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
    required final int ratingCount,
  }) = _$AppSearchResultImpl;

  factory _AppSearchResult.fromJson(Map<String, dynamic> json) =
      _$AppSearchResultImpl.fromJson;

  @override
  int get position;
  @override
  @JsonKey(name: 'apple_id')
  String get appleId;
  @override
  String get name;
  @override
  @JsonKey(name: 'bundle_id')
  String? get bundleId;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  String? get developer;
  @override
  @JsonKey(fromJson: _parseDoubleOrZero)
  double get price;
  @override
  @JsonKey(fromJson: _parseDouble)
  double? get rating;
  @override
  @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
  int get ratingCount;

  /// Create a copy of AppSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSearchResultImplCopyWith<_$AppSearchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AndroidSearchResult _$AndroidSearchResultFromJson(Map<String, dynamic> json) {
  return _AndroidSearchResult.fromJson(json);
}

/// @nodoc
mixin _$AndroidSearchResult {
  int get position => throw _privateConstructorUsedError;
  @JsonKey(name: 'google_play_id')
  String get googlePlayId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  String? get developer => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
  int get ratingCount => throw _privateConstructorUsedError;
  bool get free => throw _privateConstructorUsedError;

  /// Serializes this AndroidSearchResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AndroidSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AndroidSearchResultCopyWith<AndroidSearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AndroidSearchResultCopyWith<$Res> {
  factory $AndroidSearchResultCopyWith(
    AndroidSearchResult value,
    $Res Function(AndroidSearchResult) then,
  ) = _$AndroidSearchResultCopyWithImpl<$Res, AndroidSearchResult>;
  @useResult
  $Res call({
    int position,
    @JsonKey(name: 'google_play_id') String googlePlayId,
    String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? developer,
    @JsonKey(fromJson: _parseDouble) double? rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero) int ratingCount,
    bool free,
  });
}

/// @nodoc
class _$AndroidSearchResultCopyWithImpl<$Res, $Val extends AndroidSearchResult>
    implements $AndroidSearchResultCopyWith<$Res> {
  _$AndroidSearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AndroidSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? googlePlayId = null,
    Object? name = null,
    Object? iconUrl = freezed,
    Object? developer = freezed,
    Object? rating = freezed,
    Object? ratingCount = null,
    Object? free = null,
  }) {
    return _then(
      _value.copyWith(
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int,
            googlePlayId: null == googlePlayId
                ? _value.googlePlayId
                : googlePlayId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            developer: freezed == developer
                ? _value.developer
                : developer // ignore: cast_nullable_to_non_nullable
                      as String?,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
            ratingCount: null == ratingCount
                ? _value.ratingCount
                : ratingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            free: null == free
                ? _value.free
                : free // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AndroidSearchResultImplCopyWith<$Res>
    implements $AndroidSearchResultCopyWith<$Res> {
  factory _$$AndroidSearchResultImplCopyWith(
    _$AndroidSearchResultImpl value,
    $Res Function(_$AndroidSearchResultImpl) then,
  ) = __$$AndroidSearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int position,
    @JsonKey(name: 'google_play_id') String googlePlayId,
    String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? developer,
    @JsonKey(fromJson: _parseDouble) double? rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero) int ratingCount,
    bool free,
  });
}

/// @nodoc
class __$$AndroidSearchResultImplCopyWithImpl<$Res>
    extends _$AndroidSearchResultCopyWithImpl<$Res, _$AndroidSearchResultImpl>
    implements _$$AndroidSearchResultImplCopyWith<$Res> {
  __$$AndroidSearchResultImplCopyWithImpl(
    _$AndroidSearchResultImpl _value,
    $Res Function(_$AndroidSearchResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AndroidSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? googlePlayId = null,
    Object? name = null,
    Object? iconUrl = freezed,
    Object? developer = freezed,
    Object? rating = freezed,
    Object? ratingCount = null,
    Object? free = null,
  }) {
    return _then(
      _$AndroidSearchResultImpl(
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
        googlePlayId: null == googlePlayId
            ? _value.googlePlayId
            : googlePlayId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        developer: freezed == developer
            ? _value.developer
            : developer // ignore: cast_nullable_to_non_nullable
                  as String?,
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
        ratingCount: null == ratingCount
            ? _value.ratingCount
            : ratingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        free: null == free
            ? _value.free
            : free // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AndroidSearchResultImpl implements _AndroidSearchResult {
  const _$AndroidSearchResultImpl({
    required this.position,
    @JsonKey(name: 'google_play_id') required this.googlePlayId,
    required this.name,
    @JsonKey(name: 'icon_url') this.iconUrl,
    this.developer,
    @JsonKey(fromJson: _parseDouble) this.rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
    required this.ratingCount,
    this.free = true,
  });

  factory _$AndroidSearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$AndroidSearchResultImplFromJson(json);

  @override
  final int position;
  @override
  @JsonKey(name: 'google_play_id')
  final String googlePlayId;
  @override
  final String name;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  final String? developer;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double? rating;
  @override
  @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
  final int ratingCount;
  @override
  @JsonKey()
  final bool free;

  @override
  String toString() {
    return 'AndroidSearchResult(position: $position, googlePlayId: $googlePlayId, name: $name, iconUrl: $iconUrl, developer: $developer, rating: $rating, ratingCount: $ratingCount, free: $free)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AndroidSearchResultImpl &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.googlePlayId, googlePlayId) ||
                other.googlePlayId == googlePlayId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.developer, developer) ||
                other.developer == developer) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.free, free) || other.free == free));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    position,
    googlePlayId,
    name,
    iconUrl,
    developer,
    rating,
    ratingCount,
    free,
  );

  /// Create a copy of AndroidSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AndroidSearchResultImplCopyWith<_$AndroidSearchResultImpl> get copyWith =>
      __$$AndroidSearchResultImplCopyWithImpl<_$AndroidSearchResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AndroidSearchResultImplToJson(this);
  }
}

abstract class _AndroidSearchResult implements AndroidSearchResult {
  const factory _AndroidSearchResult({
    required final int position,
    @JsonKey(name: 'google_play_id') required final String googlePlayId,
    required final String name,
    @JsonKey(name: 'icon_url') final String? iconUrl,
    final String? developer,
    @JsonKey(fromJson: _parseDouble) final double? rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
    required final int ratingCount,
    final bool free,
  }) = _$AndroidSearchResultImpl;

  factory _AndroidSearchResult.fromJson(Map<String, dynamic> json) =
      _$AndroidSearchResultImpl.fromJson;

  @override
  int get position;
  @override
  @JsonKey(name: 'google_play_id')
  String get googlePlayId;
  @override
  String get name;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  String? get developer;
  @override
  @JsonKey(fromJson: _parseDouble)
  double? get rating;
  @override
  @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
  int get ratingCount;
  @override
  bool get free;

  /// Create a copy of AndroidSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AndroidSearchResultImplCopyWith<_$AndroidSearchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppPreview _$AppPreviewFromJson(Map<String, dynamic> json) {
  return _AppPreview.fromJson(json);
}

/// @nodoc
mixin _$AppPreview {
  String get platform => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  String? get developer => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String>? get screenshots => throw _privateConstructorUsedError;
  String? get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'release_date')
  DateTime? get releaseDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_date')
  DateTime? get updatedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'size_bytes', fromJson: _parseInt)
  int? get sizeBytes => throw _privateConstructorUsedError;
  @JsonKey(name: 'minimum_os')
  String? get minimumOs => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_url')
  String? get storeUrl => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get price => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
  int get ratingCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_name')
  String? get categoryName => throw _privateConstructorUsedError;

  /// Serializes this AppPreview to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppPreview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppPreviewCopyWith<AppPreview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppPreviewCopyWith<$Res> {
  factory $AppPreviewCopyWith(
    AppPreview value,
    $Res Function(AppPreview) then,
  ) = _$AppPreviewCopyWithImpl<$Res, AppPreview>;
  @useResult
  $Res call({
    String platform,
    @JsonKey(name: 'store_id') String storeId,
    String name,
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
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero) int ratingCount,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'category_name') String? categoryName,
  });
}

/// @nodoc
class _$AppPreviewCopyWithImpl<$Res, $Val extends AppPreview>
    implements $AppPreviewCopyWith<$Res> {
  _$AppPreviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppPreview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platform = null,
    Object? storeId = null,
    Object? name = null,
    Object? iconUrl = freezed,
    Object? developer = freezed,
    Object? description = freezed,
    Object? screenshots = freezed,
    Object? version = freezed,
    Object? releaseDate = freezed,
    Object? updatedDate = freezed,
    Object? sizeBytes = freezed,
    Object? minimumOs = freezed,
    Object? storeUrl = freezed,
    Object? price = freezed,
    Object? currency = freezed,
    Object? rating = freezed,
    Object? ratingCount = null,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
  }) {
    return _then(
      _value.copyWith(
            platform: null == platform
                ? _value.platform
                : platform // ignore: cast_nullable_to_non_nullable
                      as String,
            storeId: null == storeId
                ? _value.storeId
                : storeId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            developer: freezed == developer
                ? _value.developer
                : developer // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            screenshots: freezed == screenshots
                ? _value.screenshots
                : screenshots // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            version: freezed == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String?,
            releaseDate: freezed == releaseDate
                ? _value.releaseDate
                : releaseDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedDate: freezed == updatedDate
                ? _value.updatedDate
                : updatedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            sizeBytes: freezed == sizeBytes
                ? _value.sizeBytes
                : sizeBytes // ignore: cast_nullable_to_non_nullable
                      as int?,
            minimumOs: freezed == minimumOs
                ? _value.minimumOs
                : minimumOs // ignore: cast_nullable_to_non_nullable
                      as String?,
            storeUrl: freezed == storeUrl
                ? _value.storeUrl
                : storeUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double?,
            currency: freezed == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String?,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
            ratingCount: null == ratingCount
                ? _value.ratingCount
                : ratingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            categoryName: freezed == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppPreviewImplCopyWith<$Res>
    implements $AppPreviewCopyWith<$Res> {
  factory _$$AppPreviewImplCopyWith(
    _$AppPreviewImpl value,
    $Res Function(_$AppPreviewImpl) then,
  ) = __$$AppPreviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String platform,
    @JsonKey(name: 'store_id') String storeId,
    String name,
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
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero) int ratingCount,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'category_name') String? categoryName,
  });
}

/// @nodoc
class __$$AppPreviewImplCopyWithImpl<$Res>
    extends _$AppPreviewCopyWithImpl<$Res, _$AppPreviewImpl>
    implements _$$AppPreviewImplCopyWith<$Res> {
  __$$AppPreviewImplCopyWithImpl(
    _$AppPreviewImpl _value,
    $Res Function(_$AppPreviewImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppPreview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platform = null,
    Object? storeId = null,
    Object? name = null,
    Object? iconUrl = freezed,
    Object? developer = freezed,
    Object? description = freezed,
    Object? screenshots = freezed,
    Object? version = freezed,
    Object? releaseDate = freezed,
    Object? updatedDate = freezed,
    Object? sizeBytes = freezed,
    Object? minimumOs = freezed,
    Object? storeUrl = freezed,
    Object? price = freezed,
    Object? currency = freezed,
    Object? rating = freezed,
    Object? ratingCount = null,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
  }) {
    return _then(
      _$AppPreviewImpl(
        platform: null == platform
            ? _value.platform
            : platform // ignore: cast_nullable_to_non_nullable
                  as String,
        storeId: null == storeId
            ? _value.storeId
            : storeId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        developer: freezed == developer
            ? _value.developer
            : developer // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        screenshots: freezed == screenshots
            ? _value._screenshots
            : screenshots // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        version: freezed == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String?,
        releaseDate: freezed == releaseDate
            ? _value.releaseDate
            : releaseDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedDate: freezed == updatedDate
            ? _value.updatedDate
            : updatedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        sizeBytes: freezed == sizeBytes
            ? _value.sizeBytes
            : sizeBytes // ignore: cast_nullable_to_non_nullable
                  as int?,
        minimumOs: freezed == minimumOs
            ? _value.minimumOs
            : minimumOs // ignore: cast_nullable_to_non_nullable
                  as String?,
        storeUrl: freezed == storeUrl
            ? _value.storeUrl
            : storeUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double?,
        currency: freezed == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String?,
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
        ratingCount: null == ratingCount
            ? _value.ratingCount
            : ratingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        categoryName: freezed == categoryName
            ? _value.categoryName
            : categoryName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppPreviewImpl extends _AppPreview {
  const _$AppPreviewImpl({
    required this.platform,
    @JsonKey(name: 'store_id') required this.storeId,
    required this.name,
    @JsonKey(name: 'icon_url') this.iconUrl,
    this.developer,
    this.description,
    final List<String>? screenshots,
    this.version,
    @JsonKey(name: 'release_date') this.releaseDate,
    @JsonKey(name: 'updated_date') this.updatedDate,
    @JsonKey(name: 'size_bytes', fromJson: _parseInt) this.sizeBytes,
    @JsonKey(name: 'minimum_os') this.minimumOs,
    @JsonKey(name: 'store_url') this.storeUrl,
    @JsonKey(fromJson: _parseDouble) this.price,
    this.currency,
    @JsonKey(fromJson: _parseDouble) this.rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
    required this.ratingCount,
    @JsonKey(name: 'category_id') this.categoryId,
    @JsonKey(name: 'category_name') this.categoryName,
  }) : _screenshots = screenshots,
       super._();

  factory _$AppPreviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppPreviewImplFromJson(json);

  @override
  final String platform;
  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  final String name;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  final String? developer;
  @override
  final String? description;
  final List<String>? _screenshots;
  @override
  List<String>? get screenshots {
    final value = _screenshots;
    if (value == null) return null;
    if (_screenshots is EqualUnmodifiableListView) return _screenshots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? version;
  @override
  @JsonKey(name: 'release_date')
  final DateTime? releaseDate;
  @override
  @JsonKey(name: 'updated_date')
  final DateTime? updatedDate;
  @override
  @JsonKey(name: 'size_bytes', fromJson: _parseInt)
  final int? sizeBytes;
  @override
  @JsonKey(name: 'minimum_os')
  final String? minimumOs;
  @override
  @JsonKey(name: 'store_url')
  final String? storeUrl;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double? price;
  @override
  final String? currency;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double? rating;
  @override
  @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
  final int ratingCount;
  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @override
  @JsonKey(name: 'category_name')
  final String? categoryName;

  @override
  String toString() {
    return 'AppPreview(platform: $platform, storeId: $storeId, name: $name, iconUrl: $iconUrl, developer: $developer, description: $description, screenshots: $screenshots, version: $version, releaseDate: $releaseDate, updatedDate: $updatedDate, sizeBytes: $sizeBytes, minimumOs: $minimumOs, storeUrl: $storeUrl, price: $price, currency: $currency, rating: $rating, ratingCount: $ratingCount, categoryId: $categoryId, categoryName: $categoryName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppPreviewImpl &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.developer, developer) ||
                other.developer == developer) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._screenshots,
              _screenshots,
            ) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.updatedDate, updatedDate) ||
                other.updatedDate == updatedDate) &&
            (identical(other.sizeBytes, sizeBytes) ||
                other.sizeBytes == sizeBytes) &&
            (identical(other.minimumOs, minimumOs) ||
                other.minimumOs == minimumOs) &&
            (identical(other.storeUrl, storeUrl) ||
                other.storeUrl == storeUrl) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    platform,
    storeId,
    name,
    iconUrl,
    developer,
    description,
    const DeepCollectionEquality().hash(_screenshots),
    version,
    releaseDate,
    updatedDate,
    sizeBytes,
    minimumOs,
    storeUrl,
    price,
    currency,
    rating,
    ratingCount,
    categoryId,
    categoryName,
  ]);

  /// Create a copy of AppPreview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppPreviewImplCopyWith<_$AppPreviewImpl> get copyWith =>
      __$$AppPreviewImplCopyWithImpl<_$AppPreviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppPreviewImplToJson(this);
  }
}

abstract class _AppPreview extends AppPreview {
  const factory _AppPreview({
    required final String platform,
    @JsonKey(name: 'store_id') required final String storeId,
    required final String name,
    @JsonKey(name: 'icon_url') final String? iconUrl,
    final String? developer,
    final String? description,
    final List<String>? screenshots,
    final String? version,
    @JsonKey(name: 'release_date') final DateTime? releaseDate,
    @JsonKey(name: 'updated_date') final DateTime? updatedDate,
    @JsonKey(name: 'size_bytes', fromJson: _parseInt) final int? sizeBytes,
    @JsonKey(name: 'minimum_os') final String? minimumOs,
    @JsonKey(name: 'store_url') final String? storeUrl,
    @JsonKey(fromJson: _parseDouble) final double? price,
    final String? currency,
    @JsonKey(fromJson: _parseDouble) final double? rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
    required final int ratingCount,
    @JsonKey(name: 'category_id') final String? categoryId,
    @JsonKey(name: 'category_name') final String? categoryName,
  }) = _$AppPreviewImpl;
  const _AppPreview._() : super._();

  factory _AppPreview.fromJson(Map<String, dynamic> json) =
      _$AppPreviewImpl.fromJson;

  @override
  String get platform;
  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  String get name;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  String? get developer;
  @override
  String? get description;
  @override
  List<String>? get screenshots;
  @override
  String? get version;
  @override
  @JsonKey(name: 'release_date')
  DateTime? get releaseDate;
  @override
  @JsonKey(name: 'updated_date')
  DateTime? get updatedDate;
  @override
  @JsonKey(name: 'size_bytes', fromJson: _parseInt)
  int? get sizeBytes;
  @override
  @JsonKey(name: 'minimum_os')
  String? get minimumOs;
  @override
  @JsonKey(name: 'store_url')
  String? get storeUrl;
  @override
  @JsonKey(fromJson: _parseDouble)
  double? get price;
  @override
  String? get currency;
  @override
  @JsonKey(fromJson: _parseDouble)
  double? get rating;
  @override
  @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
  int get ratingCount;
  @override
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override
  @JsonKey(name: 'category_name')
  String? get categoryName;

  /// Create a copy of AppPreview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppPreviewImplCopyWith<_$AppPreviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
