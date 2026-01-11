// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return _Review.fromJson(json);
}

/// @nodoc
mixin _$Review {
  int get id => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  String? get version => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  String? get sentiment => throw _privateConstructorUsedError;
  @JsonKey(name: 'our_response')
  String? get ourResponse => throw _privateConstructorUsedError;
  @JsonKey(name: 'responded_at')
  DateTime? get respondedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviewed_at')
  DateTime get reviewedAt => throw _privateConstructorUsedError;
  ReviewApp? get app => throw _privateConstructorUsedError;

  /// Serializes this Review to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewCopyWith<Review> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewCopyWith<$Res> {
  factory $ReviewCopyWith(Review value, $Res Function(Review) then) =
      _$ReviewCopyWithImpl<$Res, Review>;
  @useResult
  $Res call({
    int id,
    String author,
    String? title,
    String content,
    int rating,
    String? version,
    String country,
    String? sentiment,
    @JsonKey(name: 'our_response') String? ourResponse,
    @JsonKey(name: 'responded_at') DateTime? respondedAt,
    @JsonKey(name: 'reviewed_at') DateTime reviewedAt,
    ReviewApp? app,
  });

  $ReviewAppCopyWith<$Res>? get app;
}

/// @nodoc
class _$ReviewCopyWithImpl<$Res, $Val extends Review>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? title = freezed,
    Object? content = null,
    Object? rating = null,
    Object? version = freezed,
    Object? country = null,
    Object? sentiment = freezed,
    Object? ourResponse = freezed,
    Object? respondedAt = freezed,
    Object? reviewedAt = null,
    Object? app = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            author: null == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as String,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as int,
            version: freezed == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String?,
            country: null == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as String,
            sentiment: freezed == sentiment
                ? _value.sentiment
                : sentiment // ignore: cast_nullable_to_non_nullable
                      as String?,
            ourResponse: freezed == ourResponse
                ? _value.ourResponse
                : ourResponse // ignore: cast_nullable_to_non_nullable
                      as String?,
            respondedAt: freezed == respondedAt
                ? _value.respondedAt
                : respondedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            reviewedAt: null == reviewedAt
                ? _value.reviewedAt
                : reviewedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            app: freezed == app
                ? _value.app
                : app // ignore: cast_nullable_to_non_nullable
                      as ReviewApp?,
          )
          as $Val,
    );
  }

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReviewAppCopyWith<$Res>? get app {
    if (_value.app == null) {
      return null;
    }

    return $ReviewAppCopyWith<$Res>(_value.app!, (value) {
      return _then(_value.copyWith(app: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReviewImplCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$$ReviewImplCopyWith(
    _$ReviewImpl value,
    $Res Function(_$ReviewImpl) then,
  ) = __$$ReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String author,
    String? title,
    String content,
    int rating,
    String? version,
    String country,
    String? sentiment,
    @JsonKey(name: 'our_response') String? ourResponse,
    @JsonKey(name: 'responded_at') DateTime? respondedAt,
    @JsonKey(name: 'reviewed_at') DateTime reviewedAt,
    ReviewApp? app,
  });

  @override
  $ReviewAppCopyWith<$Res>? get app;
}

/// @nodoc
class __$$ReviewImplCopyWithImpl<$Res>
    extends _$ReviewCopyWithImpl<$Res, _$ReviewImpl>
    implements _$$ReviewImplCopyWith<$Res> {
  __$$ReviewImplCopyWithImpl(
    _$ReviewImpl _value,
    $Res Function(_$ReviewImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? title = freezed,
    Object? content = null,
    Object? rating = null,
    Object? version = freezed,
    Object? country = null,
    Object? sentiment = freezed,
    Object? ourResponse = freezed,
    Object? respondedAt = freezed,
    Object? reviewedAt = null,
    Object? app = freezed,
  }) {
    return _then(
      _$ReviewImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        author: null == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as String,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as int,
        version: freezed == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String?,
        country: null == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String,
        sentiment: freezed == sentiment
            ? _value.sentiment
            : sentiment // ignore: cast_nullable_to_non_nullable
                  as String?,
        ourResponse: freezed == ourResponse
            ? _value.ourResponse
            : ourResponse // ignore: cast_nullable_to_non_nullable
                  as String?,
        respondedAt: freezed == respondedAt
            ? _value.respondedAt
            : respondedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reviewedAt: null == reviewedAt
            ? _value.reviewedAt
            : reviewedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        app: freezed == app
            ? _value.app
            : app // ignore: cast_nullable_to_non_nullable
                  as ReviewApp?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewImpl extends _Review {
  const _$ReviewImpl({
    required this.id,
    required this.author,
    this.title,
    required this.content,
    required this.rating,
    this.version,
    required this.country,
    this.sentiment,
    @JsonKey(name: 'our_response') this.ourResponse,
    @JsonKey(name: 'responded_at') this.respondedAt,
    @JsonKey(name: 'reviewed_at') required this.reviewedAt,
    this.app,
  }) : super._();

  factory _$ReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewImplFromJson(json);

  @override
  final int id;
  @override
  final String author;
  @override
  final String? title;
  @override
  final String content;
  @override
  final int rating;
  @override
  final String? version;
  @override
  final String country;
  @override
  final String? sentiment;
  @override
  @JsonKey(name: 'our_response')
  final String? ourResponse;
  @override
  @JsonKey(name: 'responded_at')
  final DateTime? respondedAt;
  @override
  @JsonKey(name: 'reviewed_at')
  final DateTime reviewedAt;
  @override
  final ReviewApp? app;

  @override
  String toString() {
    return 'Review(id: $id, author: $author, title: $title, content: $content, rating: $rating, version: $version, country: $country, sentiment: $sentiment, ourResponse: $ourResponse, respondedAt: $respondedAt, reviewedAt: $reviewedAt, app: $app)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.sentiment, sentiment) ||
                other.sentiment == sentiment) &&
            (identical(other.ourResponse, ourResponse) ||
                other.ourResponse == ourResponse) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.app, app) || other.app == app));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    author,
    title,
    content,
    rating,
    version,
    country,
    sentiment,
    ourResponse,
    respondedAt,
    reviewedAt,
    app,
  );

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      __$$ReviewImplCopyWithImpl<_$ReviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewImplToJson(this);
  }
}

abstract class _Review extends Review {
  const factory _Review({
    required final int id,
    required final String author,
    final String? title,
    required final String content,
    required final int rating,
    final String? version,
    required final String country,
    final String? sentiment,
    @JsonKey(name: 'our_response') final String? ourResponse,
    @JsonKey(name: 'responded_at') final DateTime? respondedAt,
    @JsonKey(name: 'reviewed_at') required final DateTime reviewedAt,
    final ReviewApp? app,
  }) = _$ReviewImpl;
  const _Review._() : super._();

  factory _Review.fromJson(Map<String, dynamic> json) = _$ReviewImpl.fromJson;

  @override
  int get id;
  @override
  String get author;
  @override
  String? get title;
  @override
  String get content;
  @override
  int get rating;
  @override
  String? get version;
  @override
  String get country;
  @override
  String? get sentiment;
  @override
  @JsonKey(name: 'our_response')
  String? get ourResponse;
  @override
  @JsonKey(name: 'responded_at')
  DateTime? get respondedAt;
  @override
  @JsonKey(name: 'reviewed_at')
  DateTime get reviewedAt;
  @override
  ReviewApp? get app;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReviewApp _$ReviewAppFromJson(Map<String, dynamic> json) {
  return _ReviewApp.fromJson(json);
}

/// @nodoc
mixin _$ReviewApp {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;

  /// Serializes this ReviewApp to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewApp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewAppCopyWith<ReviewApp> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewAppCopyWith<$Res> {
  factory $ReviewAppCopyWith(ReviewApp value, $Res Function(ReviewApp) then) =
      _$ReviewAppCopyWithImpl<$Res, ReviewApp>;
  @useResult
  $Res call({
    int id,
    String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String platform,
  });
}

/// @nodoc
class _$ReviewAppCopyWithImpl<$Res, $Val extends ReviewApp>
    implements $ReviewAppCopyWith<$Res> {
  _$ReviewAppCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewApp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iconUrl = freezed,
    Object? platform = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            platform: null == platform
                ? _value.platform
                : platform // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReviewAppImplCopyWith<$Res>
    implements $ReviewAppCopyWith<$Res> {
  factory _$$ReviewAppImplCopyWith(
    _$ReviewAppImpl value,
    $Res Function(_$ReviewAppImpl) then,
  ) = __$$ReviewAppImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String platform,
  });
}

/// @nodoc
class __$$ReviewAppImplCopyWithImpl<$Res>
    extends _$ReviewAppCopyWithImpl<$Res, _$ReviewAppImpl>
    implements _$$ReviewAppImplCopyWith<$Res> {
  __$$ReviewAppImplCopyWithImpl(
    _$ReviewAppImpl _value,
    $Res Function(_$ReviewAppImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewApp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iconUrl = freezed,
    Object? platform = null,
  }) {
    return _then(
      _$ReviewAppImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        platform: null == platform
            ? _value.platform
            : platform // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewAppImpl implements _ReviewApp {
  const _$ReviewAppImpl({
    required this.id,
    required this.name,
    @JsonKey(name: 'icon_url') this.iconUrl,
    required this.platform,
  });

  factory _$ReviewAppImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewAppImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  final String platform;

  @override
  String toString() {
    return 'ReviewApp(id: $id, name: $name, iconUrl: $iconUrl, platform: $platform)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewAppImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.platform, platform) ||
                other.platform == platform));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, iconUrl, platform);

  /// Create a copy of ReviewApp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewAppImplCopyWith<_$ReviewAppImpl> get copyWith =>
      __$$ReviewAppImplCopyWithImpl<_$ReviewAppImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewAppImplToJson(this);
  }
}

abstract class _ReviewApp implements ReviewApp {
  const factory _ReviewApp({
    required final int id,
    required final String name,
    @JsonKey(name: 'icon_url') final String? iconUrl,
    required final String platform,
  }) = _$ReviewAppImpl;

  factory _ReviewApp.fromJson(Map<String, dynamic> json) =
      _$ReviewAppImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  String get platform;

  /// Create a copy of ReviewApp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewAppImplCopyWith<_$ReviewAppImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PaginatedReviews {
  List<Review> get reviews => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get lastPage => throw _privateConstructorUsedError;
  int get perPage => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedReviews
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedReviewsCopyWith<PaginatedReviews> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedReviewsCopyWith<$Res> {
  factory $PaginatedReviewsCopyWith(
    PaginatedReviews value,
    $Res Function(PaginatedReviews) then,
  ) = _$PaginatedReviewsCopyWithImpl<$Res, PaginatedReviews>;
  @useResult
  $Res call({
    List<Review> reviews,
    int currentPage,
    int lastPage,
    int perPage,
    int total,
  });
}

/// @nodoc
class _$PaginatedReviewsCopyWithImpl<$Res, $Val extends PaginatedReviews>
    implements $PaginatedReviewsCopyWith<$Res> {
  _$PaginatedReviewsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedReviews
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reviews = null,
    Object? currentPage = null,
    Object? lastPage = null,
    Object? perPage = null,
    Object? total = null,
  }) {
    return _then(
      _value.copyWith(
            reviews: null == reviews
                ? _value.reviews
                : reviews // ignore: cast_nullable_to_non_nullable
                      as List<Review>,
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            lastPage: null == lastPage
                ? _value.lastPage
                : lastPage // ignore: cast_nullable_to_non_nullable
                      as int,
            perPage: null == perPage
                ? _value.perPage
                : perPage // ignore: cast_nullable_to_non_nullable
                      as int,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaginatedReviewsImplCopyWith<$Res>
    implements $PaginatedReviewsCopyWith<$Res> {
  factory _$$PaginatedReviewsImplCopyWith(
    _$PaginatedReviewsImpl value,
    $Res Function(_$PaginatedReviewsImpl) then,
  ) = __$$PaginatedReviewsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<Review> reviews,
    int currentPage,
    int lastPage,
    int perPage,
    int total,
  });
}

/// @nodoc
class __$$PaginatedReviewsImplCopyWithImpl<$Res>
    extends _$PaginatedReviewsCopyWithImpl<$Res, _$PaginatedReviewsImpl>
    implements _$$PaginatedReviewsImplCopyWith<$Res> {
  __$$PaginatedReviewsImplCopyWithImpl(
    _$PaginatedReviewsImpl _value,
    $Res Function(_$PaginatedReviewsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginatedReviews
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reviews = null,
    Object? currentPage = null,
    Object? lastPage = null,
    Object? perPage = null,
    Object? total = null,
  }) {
    return _then(
      _$PaginatedReviewsImpl(
        reviews: null == reviews
            ? _value._reviews
            : reviews // ignore: cast_nullable_to_non_nullable
                  as List<Review>,
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        lastPage: null == lastPage
            ? _value.lastPage
            : lastPage // ignore: cast_nullable_to_non_nullable
                  as int,
        perPage: null == perPage
            ? _value.perPage
            : perPage // ignore: cast_nullable_to_non_nullable
                  as int,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$PaginatedReviewsImpl implements _PaginatedReviews {
  const _$PaginatedReviewsImpl({
    required final List<Review> reviews,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  }) : _reviews = reviews;

  final List<Review> _reviews;
  @override
  List<Review> get reviews {
    if (_reviews is EqualUnmodifiableListView) return _reviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reviews);
  }

  @override
  final int currentPage;
  @override
  final int lastPage;
  @override
  final int perPage;
  @override
  final int total;

  @override
  String toString() {
    return 'PaginatedReviews(reviews: $reviews, currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedReviewsImpl &&
            const DeepCollectionEquality().equals(other._reviews, _reviews) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.lastPage, lastPage) ||
                other.lastPage == lastPage) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.total, total) || other.total == total));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_reviews),
    currentPage,
    lastPage,
    perPage,
    total,
  );

  /// Create a copy of PaginatedReviews
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedReviewsImplCopyWith<_$PaginatedReviewsImpl> get copyWith =>
      __$$PaginatedReviewsImplCopyWithImpl<_$PaginatedReviewsImpl>(
        this,
        _$identity,
      );
}

abstract class _PaginatedReviews implements PaginatedReviews {
  const factory _PaginatedReviews({
    required final List<Review> reviews,
    required final int currentPage,
    required final int lastPage,
    required final int perPage,
    required final int total,
  }) = _$PaginatedReviewsImpl;

  @override
  List<Review> get reviews;
  @override
  int get currentPage;
  @override
  int get lastPage;
  @override
  int get perPage;
  @override
  int get total;

  /// Create a copy of PaginatedReviews
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedReviewsImplCopyWith<_$PaginatedReviewsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
