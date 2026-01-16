// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'aso_score_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AsoScore _$AsoScoreFromJson(Map<String, dynamic> json) {
  return _AsoScore.fromJson(json);
}

/// @nodoc
mixin _$AsoScore {
  int get score => throw _privateConstructorUsedError;
  AsoScoreBreakdown get breakdown => throw _privateConstructorUsedError;
  AsoScoreTrend get trend => throw _privateConstructorUsedError;
  List<AsoScoreRecommendation> get recommendations =>
      throw _privateConstructorUsedError;

  /// Serializes this AsoScore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AsoScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AsoScoreCopyWith<AsoScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AsoScoreCopyWith<$Res> {
  factory $AsoScoreCopyWith(AsoScore value, $Res Function(AsoScore) then) =
      _$AsoScoreCopyWithImpl<$Res, AsoScore>;
  @useResult
  $Res call({
    int score,
    AsoScoreBreakdown breakdown,
    AsoScoreTrend trend,
    List<AsoScoreRecommendation> recommendations,
  });

  $AsoScoreBreakdownCopyWith<$Res> get breakdown;
  $AsoScoreTrendCopyWith<$Res> get trend;
}

/// @nodoc
class _$AsoScoreCopyWithImpl<$Res, $Val extends AsoScore>
    implements $AsoScoreCopyWith<$Res> {
  _$AsoScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AsoScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? breakdown = null,
    Object? trend = null,
    Object? recommendations = null,
  }) {
    return _then(
      _value.copyWith(
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int,
            breakdown: null == breakdown
                ? _value.breakdown
                : breakdown // ignore: cast_nullable_to_non_nullable
                      as AsoScoreBreakdown,
            trend: null == trend
                ? _value.trend
                : trend // ignore: cast_nullable_to_non_nullable
                      as AsoScoreTrend,
            recommendations: null == recommendations
                ? _value.recommendations
                : recommendations // ignore: cast_nullable_to_non_nullable
                      as List<AsoScoreRecommendation>,
          )
          as $Val,
    );
  }

  /// Create a copy of AsoScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AsoScoreBreakdownCopyWith<$Res> get breakdown {
    return $AsoScoreBreakdownCopyWith<$Res>(_value.breakdown, (value) {
      return _then(_value.copyWith(breakdown: value) as $Val);
    });
  }

  /// Create a copy of AsoScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AsoScoreTrendCopyWith<$Res> get trend {
    return $AsoScoreTrendCopyWith<$Res>(_value.trend, (value) {
      return _then(_value.copyWith(trend: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AsoScoreImplCopyWith<$Res>
    implements $AsoScoreCopyWith<$Res> {
  factory _$$AsoScoreImplCopyWith(
    _$AsoScoreImpl value,
    $Res Function(_$AsoScoreImpl) then,
  ) = __$$AsoScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int score,
    AsoScoreBreakdown breakdown,
    AsoScoreTrend trend,
    List<AsoScoreRecommendation> recommendations,
  });

  @override
  $AsoScoreBreakdownCopyWith<$Res> get breakdown;
  @override
  $AsoScoreTrendCopyWith<$Res> get trend;
}

/// @nodoc
class __$$AsoScoreImplCopyWithImpl<$Res>
    extends _$AsoScoreCopyWithImpl<$Res, _$AsoScoreImpl>
    implements _$$AsoScoreImplCopyWith<$Res> {
  __$$AsoScoreImplCopyWithImpl(
    _$AsoScoreImpl _value,
    $Res Function(_$AsoScoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AsoScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? breakdown = null,
    Object? trend = null,
    Object? recommendations = null,
  }) {
    return _then(
      _$AsoScoreImpl(
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int,
        breakdown: null == breakdown
            ? _value.breakdown
            : breakdown // ignore: cast_nullable_to_non_nullable
                  as AsoScoreBreakdown,
        trend: null == trend
            ? _value.trend
            : trend // ignore: cast_nullable_to_non_nullable
                  as AsoScoreTrend,
        recommendations: null == recommendations
            ? _value._recommendations
            : recommendations // ignore: cast_nullable_to_non_nullable
                  as List<AsoScoreRecommendation>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AsoScoreImpl extends _AsoScore {
  const _$AsoScoreImpl({
    required this.score,
    required this.breakdown,
    required this.trend,
    required final List<AsoScoreRecommendation> recommendations,
  }) : _recommendations = recommendations,
       super._();

  factory _$AsoScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$AsoScoreImplFromJson(json);

  @override
  final int score;
  @override
  final AsoScoreBreakdown breakdown;
  @override
  final AsoScoreTrend trend;
  final List<AsoScoreRecommendation> _recommendations;
  @override
  List<AsoScoreRecommendation> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  @override
  String toString() {
    return 'AsoScore(score: $score, breakdown: $breakdown, trend: $trend, recommendations: $recommendations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AsoScoreImpl &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.breakdown, breakdown) ||
                other.breakdown == breakdown) &&
            (identical(other.trend, trend) || other.trend == trend) &&
            const DeepCollectionEquality().equals(
              other._recommendations,
              _recommendations,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    score,
    breakdown,
    trend,
    const DeepCollectionEquality().hash(_recommendations),
  );

  /// Create a copy of AsoScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AsoScoreImplCopyWith<_$AsoScoreImpl> get copyWith =>
      __$$AsoScoreImplCopyWithImpl<_$AsoScoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AsoScoreImplToJson(this);
  }
}

abstract class _AsoScore extends AsoScore {
  const factory _AsoScore({
    required final int score,
    required final AsoScoreBreakdown breakdown,
    required final AsoScoreTrend trend,
    required final List<AsoScoreRecommendation> recommendations,
  }) = _$AsoScoreImpl;
  const _AsoScore._() : super._();

  factory _AsoScore.fromJson(Map<String, dynamic> json) =
      _$AsoScoreImpl.fromJson;

  @override
  int get score;
  @override
  AsoScoreBreakdown get breakdown;
  @override
  AsoScoreTrend get trend;
  @override
  List<AsoScoreRecommendation> get recommendations;

  /// Create a copy of AsoScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AsoScoreImplCopyWith<_$AsoScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AsoScoreBreakdown _$AsoScoreBreakdownFromJson(Map<String, dynamic> json) {
  return _AsoScoreBreakdown.fromJson(json);
}

/// @nodoc
mixin _$AsoScoreBreakdown {
  AsoScoreCategory get metadata => throw _privateConstructorUsedError;
  AsoScoreCategory get keywords => throw _privateConstructorUsedError;
  AsoScoreCategory get reviews => throw _privateConstructorUsedError;
  AsoScoreCategory get ratings => throw _privateConstructorUsedError;

  /// Serializes this AsoScoreBreakdown to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AsoScoreBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AsoScoreBreakdownCopyWith<AsoScoreBreakdown> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AsoScoreBreakdownCopyWith<$Res> {
  factory $AsoScoreBreakdownCopyWith(
    AsoScoreBreakdown value,
    $Res Function(AsoScoreBreakdown) then,
  ) = _$AsoScoreBreakdownCopyWithImpl<$Res, AsoScoreBreakdown>;
  @useResult
  $Res call({
    AsoScoreCategory metadata,
    AsoScoreCategory keywords,
    AsoScoreCategory reviews,
    AsoScoreCategory ratings,
  });

  $AsoScoreCategoryCopyWith<$Res> get metadata;
  $AsoScoreCategoryCopyWith<$Res> get keywords;
  $AsoScoreCategoryCopyWith<$Res> get reviews;
  $AsoScoreCategoryCopyWith<$Res> get ratings;
}

/// @nodoc
class _$AsoScoreBreakdownCopyWithImpl<$Res, $Val extends AsoScoreBreakdown>
    implements $AsoScoreBreakdownCopyWith<$Res> {
  _$AsoScoreBreakdownCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AsoScoreBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metadata = null,
    Object? keywords = null,
    Object? reviews = null,
    Object? ratings = null,
  }) {
    return _then(
      _value.copyWith(
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as AsoScoreCategory,
            keywords: null == keywords
                ? _value.keywords
                : keywords // ignore: cast_nullable_to_non_nullable
                      as AsoScoreCategory,
            reviews: null == reviews
                ? _value.reviews
                : reviews // ignore: cast_nullable_to_non_nullable
                      as AsoScoreCategory,
            ratings: null == ratings
                ? _value.ratings
                : ratings // ignore: cast_nullable_to_non_nullable
                      as AsoScoreCategory,
          )
          as $Val,
    );
  }

  /// Create a copy of AsoScoreBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AsoScoreCategoryCopyWith<$Res> get metadata {
    return $AsoScoreCategoryCopyWith<$Res>(_value.metadata, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }

  /// Create a copy of AsoScoreBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AsoScoreCategoryCopyWith<$Res> get keywords {
    return $AsoScoreCategoryCopyWith<$Res>(_value.keywords, (value) {
      return _then(_value.copyWith(keywords: value) as $Val);
    });
  }

  /// Create a copy of AsoScoreBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AsoScoreCategoryCopyWith<$Res> get reviews {
    return $AsoScoreCategoryCopyWith<$Res>(_value.reviews, (value) {
      return _then(_value.copyWith(reviews: value) as $Val);
    });
  }

  /// Create a copy of AsoScoreBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AsoScoreCategoryCopyWith<$Res> get ratings {
    return $AsoScoreCategoryCopyWith<$Res>(_value.ratings, (value) {
      return _then(_value.copyWith(ratings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AsoScoreBreakdownImplCopyWith<$Res>
    implements $AsoScoreBreakdownCopyWith<$Res> {
  factory _$$AsoScoreBreakdownImplCopyWith(
    _$AsoScoreBreakdownImpl value,
    $Res Function(_$AsoScoreBreakdownImpl) then,
  ) = __$$AsoScoreBreakdownImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AsoScoreCategory metadata,
    AsoScoreCategory keywords,
    AsoScoreCategory reviews,
    AsoScoreCategory ratings,
  });

  @override
  $AsoScoreCategoryCopyWith<$Res> get metadata;
  @override
  $AsoScoreCategoryCopyWith<$Res> get keywords;
  @override
  $AsoScoreCategoryCopyWith<$Res> get reviews;
  @override
  $AsoScoreCategoryCopyWith<$Res> get ratings;
}

/// @nodoc
class __$$AsoScoreBreakdownImplCopyWithImpl<$Res>
    extends _$AsoScoreBreakdownCopyWithImpl<$Res, _$AsoScoreBreakdownImpl>
    implements _$$AsoScoreBreakdownImplCopyWith<$Res> {
  __$$AsoScoreBreakdownImplCopyWithImpl(
    _$AsoScoreBreakdownImpl _value,
    $Res Function(_$AsoScoreBreakdownImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AsoScoreBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metadata = null,
    Object? keywords = null,
    Object? reviews = null,
    Object? ratings = null,
  }) {
    return _then(
      _$AsoScoreBreakdownImpl(
        metadata: null == metadata
            ? _value.metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as AsoScoreCategory,
        keywords: null == keywords
            ? _value.keywords
            : keywords // ignore: cast_nullable_to_non_nullable
                  as AsoScoreCategory,
        reviews: null == reviews
            ? _value.reviews
            : reviews // ignore: cast_nullable_to_non_nullable
                  as AsoScoreCategory,
        ratings: null == ratings
            ? _value.ratings
            : ratings // ignore: cast_nullable_to_non_nullable
                  as AsoScoreCategory,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AsoScoreBreakdownImpl implements _AsoScoreBreakdown {
  const _$AsoScoreBreakdownImpl({
    required this.metadata,
    required this.keywords,
    required this.reviews,
    required this.ratings,
  });

  factory _$AsoScoreBreakdownImpl.fromJson(Map<String, dynamic> json) =>
      _$$AsoScoreBreakdownImplFromJson(json);

  @override
  final AsoScoreCategory metadata;
  @override
  final AsoScoreCategory keywords;
  @override
  final AsoScoreCategory reviews;
  @override
  final AsoScoreCategory ratings;

  @override
  String toString() {
    return 'AsoScoreBreakdown(metadata: $metadata, keywords: $keywords, reviews: $reviews, ratings: $ratings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AsoScoreBreakdownImpl &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata) &&
            (identical(other.keywords, keywords) ||
                other.keywords == keywords) &&
            (identical(other.reviews, reviews) || other.reviews == reviews) &&
            (identical(other.ratings, ratings) || other.ratings == ratings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, metadata, keywords, reviews, ratings);

  /// Create a copy of AsoScoreBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AsoScoreBreakdownImplCopyWith<_$AsoScoreBreakdownImpl> get copyWith =>
      __$$AsoScoreBreakdownImplCopyWithImpl<_$AsoScoreBreakdownImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AsoScoreBreakdownImplToJson(this);
  }
}

abstract class _AsoScoreBreakdown implements AsoScoreBreakdown {
  const factory _AsoScoreBreakdown({
    required final AsoScoreCategory metadata,
    required final AsoScoreCategory keywords,
    required final AsoScoreCategory reviews,
    required final AsoScoreCategory ratings,
  }) = _$AsoScoreBreakdownImpl;

  factory _AsoScoreBreakdown.fromJson(Map<String, dynamic> json) =
      _$AsoScoreBreakdownImpl.fromJson;

  @override
  AsoScoreCategory get metadata;
  @override
  AsoScoreCategory get keywords;
  @override
  AsoScoreCategory get reviews;
  @override
  AsoScoreCategory get ratings;

  /// Create a copy of AsoScoreBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AsoScoreBreakdownImplCopyWith<_$AsoScoreBreakdownImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AsoScoreCategory _$AsoScoreCategoryFromJson(Map<String, dynamic> json) {
  return _AsoScoreCategory.fromJson(json);
}

/// @nodoc
mixin _$AsoScoreCategory {
  int get score => throw _privateConstructorUsedError;
  int get max => throw _privateConstructorUsedError;
  int get percent => throw _privateConstructorUsedError;
  Map<String, dynamic> get details => throw _privateConstructorUsedError;

  /// Serializes this AsoScoreCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AsoScoreCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AsoScoreCategoryCopyWith<AsoScoreCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AsoScoreCategoryCopyWith<$Res> {
  factory $AsoScoreCategoryCopyWith(
    AsoScoreCategory value,
    $Res Function(AsoScoreCategory) then,
  ) = _$AsoScoreCategoryCopyWithImpl<$Res, AsoScoreCategory>;
  @useResult
  $Res call({int score, int max, int percent, Map<String, dynamic> details});
}

/// @nodoc
class _$AsoScoreCategoryCopyWithImpl<$Res, $Val extends AsoScoreCategory>
    implements $AsoScoreCategoryCopyWith<$Res> {
  _$AsoScoreCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AsoScoreCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? max = null,
    Object? percent = null,
    Object? details = null,
  }) {
    return _then(
      _value.copyWith(
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int,
            max: null == max
                ? _value.max
                : max // ignore: cast_nullable_to_non_nullable
                      as int,
            percent: null == percent
                ? _value.percent
                : percent // ignore: cast_nullable_to_non_nullable
                      as int,
            details: null == details
                ? _value.details
                : details // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AsoScoreCategoryImplCopyWith<$Res>
    implements $AsoScoreCategoryCopyWith<$Res> {
  factory _$$AsoScoreCategoryImplCopyWith(
    _$AsoScoreCategoryImpl value,
    $Res Function(_$AsoScoreCategoryImpl) then,
  ) = __$$AsoScoreCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int score, int max, int percent, Map<String, dynamic> details});
}

/// @nodoc
class __$$AsoScoreCategoryImplCopyWithImpl<$Res>
    extends _$AsoScoreCategoryCopyWithImpl<$Res, _$AsoScoreCategoryImpl>
    implements _$$AsoScoreCategoryImplCopyWith<$Res> {
  __$$AsoScoreCategoryImplCopyWithImpl(
    _$AsoScoreCategoryImpl _value,
    $Res Function(_$AsoScoreCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AsoScoreCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? max = null,
    Object? percent = null,
    Object? details = null,
  }) {
    return _then(
      _$AsoScoreCategoryImpl(
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int,
        max: null == max
            ? _value.max
            : max // ignore: cast_nullable_to_non_nullable
                  as int,
        percent: null == percent
            ? _value.percent
            : percent // ignore: cast_nullable_to_non_nullable
                  as int,
        details: null == details
            ? _value._details
            : details // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AsoScoreCategoryImpl extends _AsoScoreCategory {
  const _$AsoScoreCategoryImpl({
    required this.score,
    required this.max,
    required this.percent,
    required final Map<String, dynamic> details,
  }) : _details = details,
       super._();

  factory _$AsoScoreCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AsoScoreCategoryImplFromJson(json);

  @override
  final int score;
  @override
  final int max;
  @override
  final int percent;
  final Map<String, dynamic> _details;
  @override
  Map<String, dynamic> get details {
    if (_details is EqualUnmodifiableMapView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_details);
  }

  @override
  String toString() {
    return 'AsoScoreCategory(score: $score, max: $max, percent: $percent, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AsoScoreCategoryImpl &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.percent, percent) || other.percent == percent) &&
            const DeepCollectionEquality().equals(other._details, _details));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    score,
    max,
    percent,
    const DeepCollectionEquality().hash(_details),
  );

  /// Create a copy of AsoScoreCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AsoScoreCategoryImplCopyWith<_$AsoScoreCategoryImpl> get copyWith =>
      __$$AsoScoreCategoryImplCopyWithImpl<_$AsoScoreCategoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AsoScoreCategoryImplToJson(this);
  }
}

abstract class _AsoScoreCategory extends AsoScoreCategory {
  const factory _AsoScoreCategory({
    required final int score,
    required final int max,
    required final int percent,
    required final Map<String, dynamic> details,
  }) = _$AsoScoreCategoryImpl;
  const _AsoScoreCategory._() : super._();

  factory _AsoScoreCategory.fromJson(Map<String, dynamic> json) =
      _$AsoScoreCategoryImpl.fromJson;

  @override
  int get score;
  @override
  int get max;
  @override
  int get percent;
  @override
  Map<String, dynamic> get details;

  /// Create a copy of AsoScoreCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AsoScoreCategoryImplCopyWith<_$AsoScoreCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AsoScoreTrend _$AsoScoreTrendFromJson(Map<String, dynamic> json) {
  return _AsoScoreTrend.fromJson(json);
}

/// @nodoc
mixin _$AsoScoreTrend {
  int get change => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  String get direction => throw _privateConstructorUsedError;
  List<String> get indicators => throw _privateConstructorUsedError;

  /// Serializes this AsoScoreTrend to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AsoScoreTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AsoScoreTrendCopyWith<AsoScoreTrend> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AsoScoreTrendCopyWith<$Res> {
  factory $AsoScoreTrendCopyWith(
    AsoScoreTrend value,
    $Res Function(AsoScoreTrend) then,
  ) = _$AsoScoreTrendCopyWithImpl<$Res, AsoScoreTrend>;
  @useResult
  $Res call({
    int change,
    String period,
    String direction,
    List<String> indicators,
  });
}

/// @nodoc
class _$AsoScoreTrendCopyWithImpl<$Res, $Val extends AsoScoreTrend>
    implements $AsoScoreTrendCopyWith<$Res> {
  _$AsoScoreTrendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AsoScoreTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? change = null,
    Object? period = null,
    Object? direction = null,
    Object? indicators = null,
  }) {
    return _then(
      _value.copyWith(
            change: null == change
                ? _value.change
                : change // ignore: cast_nullable_to_non_nullable
                      as int,
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as String,
            direction: null == direction
                ? _value.direction
                : direction // ignore: cast_nullable_to_non_nullable
                      as String,
            indicators: null == indicators
                ? _value.indicators
                : indicators // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AsoScoreTrendImplCopyWith<$Res>
    implements $AsoScoreTrendCopyWith<$Res> {
  factory _$$AsoScoreTrendImplCopyWith(
    _$AsoScoreTrendImpl value,
    $Res Function(_$AsoScoreTrendImpl) then,
  ) = __$$AsoScoreTrendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int change,
    String period,
    String direction,
    List<String> indicators,
  });
}

/// @nodoc
class __$$AsoScoreTrendImplCopyWithImpl<$Res>
    extends _$AsoScoreTrendCopyWithImpl<$Res, _$AsoScoreTrendImpl>
    implements _$$AsoScoreTrendImplCopyWith<$Res> {
  __$$AsoScoreTrendImplCopyWithImpl(
    _$AsoScoreTrendImpl _value,
    $Res Function(_$AsoScoreTrendImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AsoScoreTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? change = null,
    Object? period = null,
    Object? direction = null,
    Object? indicators = null,
  }) {
    return _then(
      _$AsoScoreTrendImpl(
        change: null == change
            ? _value.change
            : change // ignore: cast_nullable_to_non_nullable
                  as int,
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as String,
        direction: null == direction
            ? _value.direction
            : direction // ignore: cast_nullable_to_non_nullable
                  as String,
        indicators: null == indicators
            ? _value._indicators
            : indicators // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AsoScoreTrendImpl extends _AsoScoreTrend {
  const _$AsoScoreTrendImpl({
    required this.change,
    required this.period,
    required this.direction,
    final List<String> indicators = const [],
  }) : _indicators = indicators,
       super._();

  factory _$AsoScoreTrendImpl.fromJson(Map<String, dynamic> json) =>
      _$$AsoScoreTrendImplFromJson(json);

  @override
  final int change;
  @override
  final String period;
  @override
  final String direction;
  final List<String> _indicators;
  @override
  @JsonKey()
  List<String> get indicators {
    if (_indicators is EqualUnmodifiableListView) return _indicators;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_indicators);
  }

  @override
  String toString() {
    return 'AsoScoreTrend(change: $change, period: $period, direction: $direction, indicators: $indicators)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AsoScoreTrendImpl &&
            (identical(other.change, change) || other.change == change) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            const DeepCollectionEquality().equals(
              other._indicators,
              _indicators,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    change,
    period,
    direction,
    const DeepCollectionEquality().hash(_indicators),
  );

  /// Create a copy of AsoScoreTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AsoScoreTrendImplCopyWith<_$AsoScoreTrendImpl> get copyWith =>
      __$$AsoScoreTrendImplCopyWithImpl<_$AsoScoreTrendImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AsoScoreTrendImplToJson(this);
  }
}

abstract class _AsoScoreTrend extends AsoScoreTrend {
  const factory _AsoScoreTrend({
    required final int change,
    required final String period,
    required final String direction,
    final List<String> indicators,
  }) = _$AsoScoreTrendImpl;
  const _AsoScoreTrend._() : super._();

  factory _AsoScoreTrend.fromJson(Map<String, dynamic> json) =
      _$AsoScoreTrendImpl.fromJson;

  @override
  int get change;
  @override
  String get period;
  @override
  String get direction;
  @override
  List<String> get indicators;

  /// Create a copy of AsoScoreTrend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AsoScoreTrendImplCopyWith<_$AsoScoreTrendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AsoScoreRecommendation _$AsoScoreRecommendationFromJson(
  Map<String, dynamic> json,
) {
  return _AsoScoreRecommendation.fromJson(json);
}

/// @nodoc
mixin _$AsoScoreRecommendation {
  String get category => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String get impact => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;

  /// Serializes this AsoScoreRecommendation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AsoScoreRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AsoScoreRecommendationCopyWith<AsoScoreRecommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AsoScoreRecommendationCopyWith<$Res> {
  factory $AsoScoreRecommendationCopyWith(
    AsoScoreRecommendation value,
    $Res Function(AsoScoreRecommendation) then,
  ) = _$AsoScoreRecommendationCopyWithImpl<$Res, AsoScoreRecommendation>;
  @useResult
  $Res call({String category, String action, String impact, String priority});
}

/// @nodoc
class _$AsoScoreRecommendationCopyWithImpl<
  $Res,
  $Val extends AsoScoreRecommendation
>
    implements $AsoScoreRecommendationCopyWith<$Res> {
  _$AsoScoreRecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AsoScoreRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? action = null,
    Object? impact = null,
    Object? priority = null,
  }) {
    return _then(
      _value.copyWith(
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            action: null == action
                ? _value.action
                : action // ignore: cast_nullable_to_non_nullable
                      as String,
            impact: null == impact
                ? _value.impact
                : impact // ignore: cast_nullable_to_non_nullable
                      as String,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AsoScoreRecommendationImplCopyWith<$Res>
    implements $AsoScoreRecommendationCopyWith<$Res> {
  factory _$$AsoScoreRecommendationImplCopyWith(
    _$AsoScoreRecommendationImpl value,
    $Res Function(_$AsoScoreRecommendationImpl) then,
  ) = __$$AsoScoreRecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String category, String action, String impact, String priority});
}

/// @nodoc
class __$$AsoScoreRecommendationImplCopyWithImpl<$Res>
    extends
        _$AsoScoreRecommendationCopyWithImpl<$Res, _$AsoScoreRecommendationImpl>
    implements _$$AsoScoreRecommendationImplCopyWith<$Res> {
  __$$AsoScoreRecommendationImplCopyWithImpl(
    _$AsoScoreRecommendationImpl _value,
    $Res Function(_$AsoScoreRecommendationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AsoScoreRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? action = null,
    Object? impact = null,
    Object? priority = null,
  }) {
    return _then(
      _$AsoScoreRecommendationImpl(
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        action: null == action
            ? _value.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        impact: null == impact
            ? _value.impact
            : impact // ignore: cast_nullable_to_non_nullable
                  as String,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AsoScoreRecommendationImpl implements _AsoScoreRecommendation {
  const _$AsoScoreRecommendationImpl({
    required this.category,
    required this.action,
    required this.impact,
    required this.priority,
  });

  factory _$AsoScoreRecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$AsoScoreRecommendationImplFromJson(json);

  @override
  final String category;
  @override
  final String action;
  @override
  final String impact;
  @override
  final String priority;

  @override
  String toString() {
    return 'AsoScoreRecommendation(category: $category, action: $action, impact: $impact, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AsoScoreRecommendationImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.impact, impact) || other.impact == impact) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, category, action, impact, priority);

  /// Create a copy of AsoScoreRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AsoScoreRecommendationImplCopyWith<_$AsoScoreRecommendationImpl>
  get copyWith =>
      __$$AsoScoreRecommendationImplCopyWithImpl<_$AsoScoreRecommendationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AsoScoreRecommendationImplToJson(this);
  }
}

abstract class _AsoScoreRecommendation implements AsoScoreRecommendation {
  const factory _AsoScoreRecommendation({
    required final String category,
    required final String action,
    required final String impact,
    required final String priority,
  }) = _$AsoScoreRecommendationImpl;

  factory _AsoScoreRecommendation.fromJson(Map<String, dynamic> json) =
      _$AsoScoreRecommendationImpl.fromJson;

  @override
  String get category;
  @override
  String get action;
  @override
  String get impact;
  @override
  String get priority;

  /// Create a copy of AsoScoreRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AsoScoreRecommendationImplCopyWith<_$AsoScoreRecommendationImpl>
  get copyWith => throw _privateConstructorUsedError;
}
