// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hero_metrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HeroMetrics _$HeroMetricsFromJson(Map<String, dynamic> json) {
  return _HeroMetrics.fromJson(json);
}

/// @nodoc
mixin _$HeroMetrics {
  @JsonKey(name: 'total_apps')
  int get totalApps => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_apps_this_month')
  int get newAppsThisMonth => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_rating')
  double get avgRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'rating_change')
  double get ratingChange => throw _privateConstructorUsedError;
  @JsonKey(name: 'rating_history')
  List<double> get ratingHistory => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_keywords')
  int get totalKeywords => throw _privateConstructorUsedError;
  @JsonKey(name: 'keywords_in_top_10')
  int get keywordsInTop10 => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_reviews')
  int get totalReviews => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviews_need_reply')
  int get reviewsNeedReply => throw _privateConstructorUsedError;

  /// Serializes this HeroMetrics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HeroMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HeroMetricsCopyWith<HeroMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeroMetricsCopyWith<$Res> {
  factory $HeroMetricsCopyWith(
    HeroMetrics value,
    $Res Function(HeroMetrics) then,
  ) = _$HeroMetricsCopyWithImpl<$Res, HeroMetrics>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_apps') int totalApps,
    @JsonKey(name: 'new_apps_this_month') int newAppsThisMonth,
    @JsonKey(name: 'avg_rating') double avgRating,
    @JsonKey(name: 'rating_change') double ratingChange,
    @JsonKey(name: 'rating_history') List<double> ratingHistory,
    @JsonKey(name: 'total_keywords') int totalKeywords,
    @JsonKey(name: 'keywords_in_top_10') int keywordsInTop10,
    @JsonKey(name: 'total_reviews') int totalReviews,
    @JsonKey(name: 'reviews_need_reply') int reviewsNeedReply,
  });
}

/// @nodoc
class _$HeroMetricsCopyWithImpl<$Res, $Val extends HeroMetrics>
    implements $HeroMetricsCopyWith<$Res> {
  _$HeroMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HeroMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalApps = null,
    Object? newAppsThisMonth = null,
    Object? avgRating = null,
    Object? ratingChange = null,
    Object? ratingHistory = null,
    Object? totalKeywords = null,
    Object? keywordsInTop10 = null,
    Object? totalReviews = null,
    Object? reviewsNeedReply = null,
  }) {
    return _then(
      _value.copyWith(
            totalApps: null == totalApps
                ? _value.totalApps
                : totalApps // ignore: cast_nullable_to_non_nullable
                      as int,
            newAppsThisMonth: null == newAppsThisMonth
                ? _value.newAppsThisMonth
                : newAppsThisMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            avgRating: null == avgRating
                ? _value.avgRating
                : avgRating // ignore: cast_nullable_to_non_nullable
                      as double,
            ratingChange: null == ratingChange
                ? _value.ratingChange
                : ratingChange // ignore: cast_nullable_to_non_nullable
                      as double,
            ratingHistory: null == ratingHistory
                ? _value.ratingHistory
                : ratingHistory // ignore: cast_nullable_to_non_nullable
                      as List<double>,
            totalKeywords: null == totalKeywords
                ? _value.totalKeywords
                : totalKeywords // ignore: cast_nullable_to_non_nullable
                      as int,
            keywordsInTop10: null == keywordsInTop10
                ? _value.keywordsInTop10
                : keywordsInTop10 // ignore: cast_nullable_to_non_nullable
                      as int,
            totalReviews: null == totalReviews
                ? _value.totalReviews
                : totalReviews // ignore: cast_nullable_to_non_nullable
                      as int,
            reviewsNeedReply: null == reviewsNeedReply
                ? _value.reviewsNeedReply
                : reviewsNeedReply // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HeroMetricsImplCopyWith<$Res>
    implements $HeroMetricsCopyWith<$Res> {
  factory _$$HeroMetricsImplCopyWith(
    _$HeroMetricsImpl value,
    $Res Function(_$HeroMetricsImpl) then,
  ) = __$$HeroMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_apps') int totalApps,
    @JsonKey(name: 'new_apps_this_month') int newAppsThisMonth,
    @JsonKey(name: 'avg_rating') double avgRating,
    @JsonKey(name: 'rating_change') double ratingChange,
    @JsonKey(name: 'rating_history') List<double> ratingHistory,
    @JsonKey(name: 'total_keywords') int totalKeywords,
    @JsonKey(name: 'keywords_in_top_10') int keywordsInTop10,
    @JsonKey(name: 'total_reviews') int totalReviews,
    @JsonKey(name: 'reviews_need_reply') int reviewsNeedReply,
  });
}

/// @nodoc
class __$$HeroMetricsImplCopyWithImpl<$Res>
    extends _$HeroMetricsCopyWithImpl<$Res, _$HeroMetricsImpl>
    implements _$$HeroMetricsImplCopyWith<$Res> {
  __$$HeroMetricsImplCopyWithImpl(
    _$HeroMetricsImpl _value,
    $Res Function(_$HeroMetricsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HeroMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalApps = null,
    Object? newAppsThisMonth = null,
    Object? avgRating = null,
    Object? ratingChange = null,
    Object? ratingHistory = null,
    Object? totalKeywords = null,
    Object? keywordsInTop10 = null,
    Object? totalReviews = null,
    Object? reviewsNeedReply = null,
  }) {
    return _then(
      _$HeroMetricsImpl(
        totalApps: null == totalApps
            ? _value.totalApps
            : totalApps // ignore: cast_nullable_to_non_nullable
                  as int,
        newAppsThisMonth: null == newAppsThisMonth
            ? _value.newAppsThisMonth
            : newAppsThisMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        avgRating: null == avgRating
            ? _value.avgRating
            : avgRating // ignore: cast_nullable_to_non_nullable
                  as double,
        ratingChange: null == ratingChange
            ? _value.ratingChange
            : ratingChange // ignore: cast_nullable_to_non_nullable
                  as double,
        ratingHistory: null == ratingHistory
            ? _value._ratingHistory
            : ratingHistory // ignore: cast_nullable_to_non_nullable
                  as List<double>,
        totalKeywords: null == totalKeywords
            ? _value.totalKeywords
            : totalKeywords // ignore: cast_nullable_to_non_nullable
                  as int,
        keywordsInTop10: null == keywordsInTop10
            ? _value.keywordsInTop10
            : keywordsInTop10 // ignore: cast_nullable_to_non_nullable
                  as int,
        totalReviews: null == totalReviews
            ? _value.totalReviews
            : totalReviews // ignore: cast_nullable_to_non_nullable
                  as int,
        reviewsNeedReply: null == reviewsNeedReply
            ? _value.reviewsNeedReply
            : reviewsNeedReply // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HeroMetricsImpl implements _HeroMetrics {
  const _$HeroMetricsImpl({
    @JsonKey(name: 'total_apps') required this.totalApps,
    @JsonKey(name: 'new_apps_this_month') required this.newAppsThisMonth,
    @JsonKey(name: 'avg_rating') required this.avgRating,
    @JsonKey(name: 'rating_change') required this.ratingChange,
    @JsonKey(name: 'rating_history') required final List<double> ratingHistory,
    @JsonKey(name: 'total_keywords') required this.totalKeywords,
    @JsonKey(name: 'keywords_in_top_10') required this.keywordsInTop10,
    @JsonKey(name: 'total_reviews') required this.totalReviews,
    @JsonKey(name: 'reviews_need_reply') required this.reviewsNeedReply,
  }) : _ratingHistory = ratingHistory;

  factory _$HeroMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeroMetricsImplFromJson(json);

  @override
  @JsonKey(name: 'total_apps')
  final int totalApps;
  @override
  @JsonKey(name: 'new_apps_this_month')
  final int newAppsThisMonth;
  @override
  @JsonKey(name: 'avg_rating')
  final double avgRating;
  @override
  @JsonKey(name: 'rating_change')
  final double ratingChange;
  final List<double> _ratingHistory;
  @override
  @JsonKey(name: 'rating_history')
  List<double> get ratingHistory {
    if (_ratingHistory is EqualUnmodifiableListView) return _ratingHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ratingHistory);
  }

  @override
  @JsonKey(name: 'total_keywords')
  final int totalKeywords;
  @override
  @JsonKey(name: 'keywords_in_top_10')
  final int keywordsInTop10;
  @override
  @JsonKey(name: 'total_reviews')
  final int totalReviews;
  @override
  @JsonKey(name: 'reviews_need_reply')
  final int reviewsNeedReply;

  @override
  String toString() {
    return 'HeroMetrics(totalApps: $totalApps, newAppsThisMonth: $newAppsThisMonth, avgRating: $avgRating, ratingChange: $ratingChange, ratingHistory: $ratingHistory, totalKeywords: $totalKeywords, keywordsInTop10: $keywordsInTop10, totalReviews: $totalReviews, reviewsNeedReply: $reviewsNeedReply)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeroMetricsImpl &&
            (identical(other.totalApps, totalApps) ||
                other.totalApps == totalApps) &&
            (identical(other.newAppsThisMonth, newAppsThisMonth) ||
                other.newAppsThisMonth == newAppsThisMonth) &&
            (identical(other.avgRating, avgRating) ||
                other.avgRating == avgRating) &&
            (identical(other.ratingChange, ratingChange) ||
                other.ratingChange == ratingChange) &&
            const DeepCollectionEquality().equals(
              other._ratingHistory,
              _ratingHistory,
            ) &&
            (identical(other.totalKeywords, totalKeywords) ||
                other.totalKeywords == totalKeywords) &&
            (identical(other.keywordsInTop10, keywordsInTop10) ||
                other.keywordsInTop10 == keywordsInTop10) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.reviewsNeedReply, reviewsNeedReply) ||
                other.reviewsNeedReply == reviewsNeedReply));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalApps,
    newAppsThisMonth,
    avgRating,
    ratingChange,
    const DeepCollectionEquality().hash(_ratingHistory),
    totalKeywords,
    keywordsInTop10,
    totalReviews,
    reviewsNeedReply,
  );

  /// Create a copy of HeroMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HeroMetricsImplCopyWith<_$HeroMetricsImpl> get copyWith =>
      __$$HeroMetricsImplCopyWithImpl<_$HeroMetricsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HeroMetricsImplToJson(this);
  }
}

abstract class _HeroMetrics implements HeroMetrics {
  const factory _HeroMetrics({
    @JsonKey(name: 'total_apps') required final int totalApps,
    @JsonKey(name: 'new_apps_this_month') required final int newAppsThisMonth,
    @JsonKey(name: 'avg_rating') required final double avgRating,
    @JsonKey(name: 'rating_change') required final double ratingChange,
    @JsonKey(name: 'rating_history') required final List<double> ratingHistory,
    @JsonKey(name: 'total_keywords') required final int totalKeywords,
    @JsonKey(name: 'keywords_in_top_10') required final int keywordsInTop10,
    @JsonKey(name: 'total_reviews') required final int totalReviews,
    @JsonKey(name: 'reviews_need_reply') required final int reviewsNeedReply,
  }) = _$HeroMetricsImpl;

  factory _HeroMetrics.fromJson(Map<String, dynamic> json) =
      _$HeroMetricsImpl.fromJson;

  @override
  @JsonKey(name: 'total_apps')
  int get totalApps;
  @override
  @JsonKey(name: 'new_apps_this_month')
  int get newAppsThisMonth;
  @override
  @JsonKey(name: 'avg_rating')
  double get avgRating;
  @override
  @JsonKey(name: 'rating_change')
  double get ratingChange;
  @override
  @JsonKey(name: 'rating_history')
  List<double> get ratingHistory;
  @override
  @JsonKey(name: 'total_keywords')
  int get totalKeywords;
  @override
  @JsonKey(name: 'keywords_in_top_10')
  int get keywordsInTop10;
  @override
  @JsonKey(name: 'total_reviews')
  int get totalReviews;
  @override
  @JsonKey(name: 'reviews_need_reply')
  int get reviewsNeedReply;

  /// Create a copy of HeroMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeroMetricsImplCopyWith<_$HeroMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
