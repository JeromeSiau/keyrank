// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competitor_keywords_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CompetitorKeywordsResponse _$CompetitorKeywordsResponseFromJson(
  Map<String, dynamic> json,
) {
  return _CompetitorKeywordsResponse.fromJson(json);
}

/// @nodoc
mixin _$CompetitorKeywordsResponse {
  CompetitorInfo get competitor => throw _privateConstructorUsedError;
  KeywordComparisonSummary get summary => throw _privateConstructorUsedError;
  List<KeywordComparison> get keywords => throw _privateConstructorUsedError;

  /// Serializes this CompetitorKeywordsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompetitorKeywordsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompetitorKeywordsResponseCopyWith<CompetitorKeywordsResponse>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompetitorKeywordsResponseCopyWith<$Res> {
  factory $CompetitorKeywordsResponseCopyWith(
    CompetitorKeywordsResponse value,
    $Res Function(CompetitorKeywordsResponse) then,
  ) =
      _$CompetitorKeywordsResponseCopyWithImpl<
        $Res,
        CompetitorKeywordsResponse
      >;
  @useResult
  $Res call({
    CompetitorInfo competitor,
    KeywordComparisonSummary summary,
    List<KeywordComparison> keywords,
  });

  $CompetitorInfoCopyWith<$Res> get competitor;
  $KeywordComparisonSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$CompetitorKeywordsResponseCopyWithImpl<
  $Res,
  $Val extends CompetitorKeywordsResponse
>
    implements $CompetitorKeywordsResponseCopyWith<$Res> {
  _$CompetitorKeywordsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompetitorKeywordsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? competitor = null,
    Object? summary = null,
    Object? keywords = null,
  }) {
    return _then(
      _value.copyWith(
            competitor: null == competitor
                ? _value.competitor
                : competitor // ignore: cast_nullable_to_non_nullable
                      as CompetitorInfo,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as KeywordComparisonSummary,
            keywords: null == keywords
                ? _value.keywords
                : keywords // ignore: cast_nullable_to_non_nullable
                      as List<KeywordComparison>,
          )
          as $Val,
    );
  }

  /// Create a copy of CompetitorKeywordsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompetitorInfoCopyWith<$Res> get competitor {
    return $CompetitorInfoCopyWith<$Res>(_value.competitor, (value) {
      return _then(_value.copyWith(competitor: value) as $Val);
    });
  }

  /// Create a copy of CompetitorKeywordsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $KeywordComparisonSummaryCopyWith<$Res> get summary {
    return $KeywordComparisonSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CompetitorKeywordsResponseImplCopyWith<$Res>
    implements $CompetitorKeywordsResponseCopyWith<$Res> {
  factory _$$CompetitorKeywordsResponseImplCopyWith(
    _$CompetitorKeywordsResponseImpl value,
    $Res Function(_$CompetitorKeywordsResponseImpl) then,
  ) = __$$CompetitorKeywordsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    CompetitorInfo competitor,
    KeywordComparisonSummary summary,
    List<KeywordComparison> keywords,
  });

  @override
  $CompetitorInfoCopyWith<$Res> get competitor;
  @override
  $KeywordComparisonSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$CompetitorKeywordsResponseImplCopyWithImpl<$Res>
    extends
        _$CompetitorKeywordsResponseCopyWithImpl<
          $Res,
          _$CompetitorKeywordsResponseImpl
        >
    implements _$$CompetitorKeywordsResponseImplCopyWith<$Res> {
  __$$CompetitorKeywordsResponseImplCopyWithImpl(
    _$CompetitorKeywordsResponseImpl _value,
    $Res Function(_$CompetitorKeywordsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompetitorKeywordsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? competitor = null,
    Object? summary = null,
    Object? keywords = null,
  }) {
    return _then(
      _$CompetitorKeywordsResponseImpl(
        competitor: null == competitor
            ? _value.competitor
            : competitor // ignore: cast_nullable_to_non_nullable
                  as CompetitorInfo,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as KeywordComparisonSummary,
        keywords: null == keywords
            ? _value._keywords
            : keywords // ignore: cast_nullable_to_non_nullable
                  as List<KeywordComparison>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CompetitorKeywordsResponseImpl implements _CompetitorKeywordsResponse {
  const _$CompetitorKeywordsResponseImpl({
    required this.competitor,
    required this.summary,
    required final List<KeywordComparison> keywords,
  }) : _keywords = keywords;

  factory _$CompetitorKeywordsResponseImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CompetitorKeywordsResponseImplFromJson(json);

  @override
  final CompetitorInfo competitor;
  @override
  final KeywordComparisonSummary summary;
  final List<KeywordComparison> _keywords;
  @override
  List<KeywordComparison> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  @override
  String toString() {
    return 'CompetitorKeywordsResponse(competitor: $competitor, summary: $summary, keywords: $keywords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompetitorKeywordsResponseImpl &&
            (identical(other.competitor, competitor) ||
                other.competitor == competitor) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    competitor,
    summary,
    const DeepCollectionEquality().hash(_keywords),
  );

  /// Create a copy of CompetitorKeywordsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompetitorKeywordsResponseImplCopyWith<_$CompetitorKeywordsResponseImpl>
  get copyWith =>
      __$$CompetitorKeywordsResponseImplCopyWithImpl<
        _$CompetitorKeywordsResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompetitorKeywordsResponseImplToJson(this);
  }
}

abstract class _CompetitorKeywordsResponse
    implements CompetitorKeywordsResponse {
  const factory _CompetitorKeywordsResponse({
    required final CompetitorInfo competitor,
    required final KeywordComparisonSummary summary,
    required final List<KeywordComparison> keywords,
  }) = _$CompetitorKeywordsResponseImpl;

  factory _CompetitorKeywordsResponse.fromJson(Map<String, dynamic> json) =
      _$CompetitorKeywordsResponseImpl.fromJson;

  @override
  CompetitorInfo get competitor;
  @override
  KeywordComparisonSummary get summary;
  @override
  List<KeywordComparison> get keywords;

  /// Create a copy of CompetitorKeywordsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompetitorKeywordsResponseImplCopyWith<_$CompetitorKeywordsResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CompetitorInfo _$CompetitorInfoFromJson(Map<String, dynamic> json) {
  return _CompetitorInfo.fromJson(json);
}

/// @nodoc
mixin _$CompetitorInfo {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;

  /// Serializes this CompetitorInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompetitorInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompetitorInfoCopyWith<CompetitorInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompetitorInfoCopyWith<$Res> {
  factory $CompetitorInfoCopyWith(
    CompetitorInfo value,
    $Res Function(CompetitorInfo) then,
  ) = _$CompetitorInfoCopyWithImpl<$Res, CompetitorInfo>;
  @useResult
  $Res call({int id, String name, @JsonKey(name: 'icon_url') String? iconUrl});
}

/// @nodoc
class _$CompetitorInfoCopyWithImpl<$Res, $Val extends CompetitorInfo>
    implements $CompetitorInfoCopyWith<$Res> {
  _$CompetitorInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompetitorInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iconUrl = freezed,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CompetitorInfoImplCopyWith<$Res>
    implements $CompetitorInfoCopyWith<$Res> {
  factory _$$CompetitorInfoImplCopyWith(
    _$CompetitorInfoImpl value,
    $Res Function(_$CompetitorInfoImpl) then,
  ) = __$$CompetitorInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, @JsonKey(name: 'icon_url') String? iconUrl});
}

/// @nodoc
class __$$CompetitorInfoImplCopyWithImpl<$Res>
    extends _$CompetitorInfoCopyWithImpl<$Res, _$CompetitorInfoImpl>
    implements _$$CompetitorInfoImplCopyWith<$Res> {
  __$$CompetitorInfoImplCopyWithImpl(
    _$CompetitorInfoImpl _value,
    $Res Function(_$CompetitorInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompetitorInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iconUrl = freezed,
  }) {
    return _then(
      _$CompetitorInfoImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CompetitorInfoImpl implements _CompetitorInfo {
  const _$CompetitorInfoImpl({
    required this.id,
    required this.name,
    @JsonKey(name: 'icon_url') this.iconUrl,
  });

  factory _$CompetitorInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompetitorInfoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;

  @override
  String toString() {
    return 'CompetitorInfo(id: $id, name: $name, iconUrl: $iconUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompetitorInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, iconUrl);

  /// Create a copy of CompetitorInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompetitorInfoImplCopyWith<_$CompetitorInfoImpl> get copyWith =>
      __$$CompetitorInfoImplCopyWithImpl<_$CompetitorInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CompetitorInfoImplToJson(this);
  }
}

abstract class _CompetitorInfo implements CompetitorInfo {
  const factory _CompetitorInfo({
    required final int id,
    required final String name,
    @JsonKey(name: 'icon_url') final String? iconUrl,
  }) = _$CompetitorInfoImpl;

  factory _CompetitorInfo.fromJson(Map<String, dynamic> json) =
      _$CompetitorInfoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;

  /// Create a copy of CompetitorInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompetitorInfoImplCopyWith<_$CompetitorInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KeywordComparisonSummary _$KeywordComparisonSummaryFromJson(
  Map<String, dynamic> json,
) {
  return _KeywordComparisonSummary.fromJson(json);
}

/// @nodoc
mixin _$KeywordComparisonSummary {
  @JsonKey(name: 'total_keywords')
  int get totalKeywords => throw _privateConstructorUsedError;
  @JsonKey(name: 'you_win')
  int get youWin => throw _privateConstructorUsedError;
  @JsonKey(name: 'they_win')
  int get theyWin => throw _privateConstructorUsedError;
  int get tied => throw _privateConstructorUsedError;
  int get gaps => throw _privateConstructorUsedError;

  /// Serializes this KeywordComparisonSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KeywordComparisonSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KeywordComparisonSummaryCopyWith<KeywordComparisonSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KeywordComparisonSummaryCopyWith<$Res> {
  factory $KeywordComparisonSummaryCopyWith(
    KeywordComparisonSummary value,
    $Res Function(KeywordComparisonSummary) then,
  ) = _$KeywordComparisonSummaryCopyWithImpl<$Res, KeywordComparisonSummary>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_keywords') int totalKeywords,
    @JsonKey(name: 'you_win') int youWin,
    @JsonKey(name: 'they_win') int theyWin,
    int tied,
    int gaps,
  });
}

/// @nodoc
class _$KeywordComparisonSummaryCopyWithImpl<
  $Res,
  $Val extends KeywordComparisonSummary
>
    implements $KeywordComparisonSummaryCopyWith<$Res> {
  _$KeywordComparisonSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KeywordComparisonSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalKeywords = null,
    Object? youWin = null,
    Object? theyWin = null,
    Object? tied = null,
    Object? gaps = null,
  }) {
    return _then(
      _value.copyWith(
            totalKeywords: null == totalKeywords
                ? _value.totalKeywords
                : totalKeywords // ignore: cast_nullable_to_non_nullable
                      as int,
            youWin: null == youWin
                ? _value.youWin
                : youWin // ignore: cast_nullable_to_non_nullable
                      as int,
            theyWin: null == theyWin
                ? _value.theyWin
                : theyWin // ignore: cast_nullable_to_non_nullable
                      as int,
            tied: null == tied
                ? _value.tied
                : tied // ignore: cast_nullable_to_non_nullable
                      as int,
            gaps: null == gaps
                ? _value.gaps
                : gaps // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KeywordComparisonSummaryImplCopyWith<$Res>
    implements $KeywordComparisonSummaryCopyWith<$Res> {
  factory _$$KeywordComparisonSummaryImplCopyWith(
    _$KeywordComparisonSummaryImpl value,
    $Res Function(_$KeywordComparisonSummaryImpl) then,
  ) = __$$KeywordComparisonSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_keywords') int totalKeywords,
    @JsonKey(name: 'you_win') int youWin,
    @JsonKey(name: 'they_win') int theyWin,
    int tied,
    int gaps,
  });
}

/// @nodoc
class __$$KeywordComparisonSummaryImplCopyWithImpl<$Res>
    extends
        _$KeywordComparisonSummaryCopyWithImpl<
          $Res,
          _$KeywordComparisonSummaryImpl
        >
    implements _$$KeywordComparisonSummaryImplCopyWith<$Res> {
  __$$KeywordComparisonSummaryImplCopyWithImpl(
    _$KeywordComparisonSummaryImpl _value,
    $Res Function(_$KeywordComparisonSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KeywordComparisonSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalKeywords = null,
    Object? youWin = null,
    Object? theyWin = null,
    Object? tied = null,
    Object? gaps = null,
  }) {
    return _then(
      _$KeywordComparisonSummaryImpl(
        totalKeywords: null == totalKeywords
            ? _value.totalKeywords
            : totalKeywords // ignore: cast_nullable_to_non_nullable
                  as int,
        youWin: null == youWin
            ? _value.youWin
            : youWin // ignore: cast_nullable_to_non_nullable
                  as int,
        theyWin: null == theyWin
            ? _value.theyWin
            : theyWin // ignore: cast_nullable_to_non_nullable
                  as int,
        tied: null == tied
            ? _value.tied
            : tied // ignore: cast_nullable_to_non_nullable
                  as int,
        gaps: null == gaps
            ? _value.gaps
            : gaps // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KeywordComparisonSummaryImpl implements _KeywordComparisonSummary {
  const _$KeywordComparisonSummaryImpl({
    @JsonKey(name: 'total_keywords') required this.totalKeywords,
    @JsonKey(name: 'you_win') required this.youWin,
    @JsonKey(name: 'they_win') required this.theyWin,
    required this.tied,
    required this.gaps,
  });

  factory _$KeywordComparisonSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$KeywordComparisonSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'total_keywords')
  final int totalKeywords;
  @override
  @JsonKey(name: 'you_win')
  final int youWin;
  @override
  @JsonKey(name: 'they_win')
  final int theyWin;
  @override
  final int tied;
  @override
  final int gaps;

  @override
  String toString() {
    return 'KeywordComparisonSummary(totalKeywords: $totalKeywords, youWin: $youWin, theyWin: $theyWin, tied: $tied, gaps: $gaps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KeywordComparisonSummaryImpl &&
            (identical(other.totalKeywords, totalKeywords) ||
                other.totalKeywords == totalKeywords) &&
            (identical(other.youWin, youWin) || other.youWin == youWin) &&
            (identical(other.theyWin, theyWin) || other.theyWin == theyWin) &&
            (identical(other.tied, tied) || other.tied == tied) &&
            (identical(other.gaps, gaps) || other.gaps == gaps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalKeywords, youWin, theyWin, tied, gaps);

  /// Create a copy of KeywordComparisonSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KeywordComparisonSummaryImplCopyWith<_$KeywordComparisonSummaryImpl>
  get copyWith =>
      __$$KeywordComparisonSummaryImplCopyWithImpl<
        _$KeywordComparisonSummaryImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KeywordComparisonSummaryImplToJson(this);
  }
}

abstract class _KeywordComparisonSummary implements KeywordComparisonSummary {
  const factory _KeywordComparisonSummary({
    @JsonKey(name: 'total_keywords') required final int totalKeywords,
    @JsonKey(name: 'you_win') required final int youWin,
    @JsonKey(name: 'they_win') required final int theyWin,
    required final int tied,
    required final int gaps,
  }) = _$KeywordComparisonSummaryImpl;

  factory _KeywordComparisonSummary.fromJson(Map<String, dynamic> json) =
      _$KeywordComparisonSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'total_keywords')
  int get totalKeywords;
  @override
  @JsonKey(name: 'you_win')
  int get youWin;
  @override
  @JsonKey(name: 'they_win')
  int get theyWin;
  @override
  int get tied;
  @override
  int get gaps;

  /// Create a copy of KeywordComparisonSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KeywordComparisonSummaryImplCopyWith<_$KeywordComparisonSummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

KeywordComparison _$KeywordComparisonFromJson(Map<String, dynamic> json) {
  return _KeywordComparison.fromJson(json);
}

/// @nodoc
mixin _$KeywordComparison {
  @JsonKey(name: 'keyword_id')
  int get keywordId => throw _privateConstructorUsedError;
  String get keyword => throw _privateConstructorUsedError;
  @JsonKey(name: 'your_position')
  int? get yourPosition => throw _privateConstructorUsedError;
  @JsonKey(name: 'competitor_position')
  int? get competitorPosition => throw _privateConstructorUsedError;
  int? get gap => throw _privateConstructorUsedError;
  int? get popularity => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_tracking')
  bool get isTracking => throw _privateConstructorUsedError;

  /// Serializes this KeywordComparison to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KeywordComparison
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KeywordComparisonCopyWith<KeywordComparison> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KeywordComparisonCopyWith<$Res> {
  factory $KeywordComparisonCopyWith(
    KeywordComparison value,
    $Res Function(KeywordComparison) then,
  ) = _$KeywordComparisonCopyWithImpl<$Res, KeywordComparison>;
  @useResult
  $Res call({
    @JsonKey(name: 'keyword_id') int keywordId,
    String keyword,
    @JsonKey(name: 'your_position') int? yourPosition,
    @JsonKey(name: 'competitor_position') int? competitorPosition,
    int? gap,
    int? popularity,
    @JsonKey(name: 'is_tracking') bool isTracking,
  });
}

/// @nodoc
class _$KeywordComparisonCopyWithImpl<$Res, $Val extends KeywordComparison>
    implements $KeywordComparisonCopyWith<$Res> {
  _$KeywordComparisonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KeywordComparison
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keywordId = null,
    Object? keyword = null,
    Object? yourPosition = freezed,
    Object? competitorPosition = freezed,
    Object? gap = freezed,
    Object? popularity = freezed,
    Object? isTracking = null,
  }) {
    return _then(
      _value.copyWith(
            keywordId: null == keywordId
                ? _value.keywordId
                : keywordId // ignore: cast_nullable_to_non_nullable
                      as int,
            keyword: null == keyword
                ? _value.keyword
                : keyword // ignore: cast_nullable_to_non_nullable
                      as String,
            yourPosition: freezed == yourPosition
                ? _value.yourPosition
                : yourPosition // ignore: cast_nullable_to_non_nullable
                      as int?,
            competitorPosition: freezed == competitorPosition
                ? _value.competitorPosition
                : competitorPosition // ignore: cast_nullable_to_non_nullable
                      as int?,
            gap: freezed == gap
                ? _value.gap
                : gap // ignore: cast_nullable_to_non_nullable
                      as int?,
            popularity: freezed == popularity
                ? _value.popularity
                : popularity // ignore: cast_nullable_to_non_nullable
                      as int?,
            isTracking: null == isTracking
                ? _value.isTracking
                : isTracking // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KeywordComparisonImplCopyWith<$Res>
    implements $KeywordComparisonCopyWith<$Res> {
  factory _$$KeywordComparisonImplCopyWith(
    _$KeywordComparisonImpl value,
    $Res Function(_$KeywordComparisonImpl) then,
  ) = __$$KeywordComparisonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'keyword_id') int keywordId,
    String keyword,
    @JsonKey(name: 'your_position') int? yourPosition,
    @JsonKey(name: 'competitor_position') int? competitorPosition,
    int? gap,
    int? popularity,
    @JsonKey(name: 'is_tracking') bool isTracking,
  });
}

/// @nodoc
class __$$KeywordComparisonImplCopyWithImpl<$Res>
    extends _$KeywordComparisonCopyWithImpl<$Res, _$KeywordComparisonImpl>
    implements _$$KeywordComparisonImplCopyWith<$Res> {
  __$$KeywordComparisonImplCopyWithImpl(
    _$KeywordComparisonImpl _value,
    $Res Function(_$KeywordComparisonImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KeywordComparison
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keywordId = null,
    Object? keyword = null,
    Object? yourPosition = freezed,
    Object? competitorPosition = freezed,
    Object? gap = freezed,
    Object? popularity = freezed,
    Object? isTracking = null,
  }) {
    return _then(
      _$KeywordComparisonImpl(
        keywordId: null == keywordId
            ? _value.keywordId
            : keywordId // ignore: cast_nullable_to_non_nullable
                  as int,
        keyword: null == keyword
            ? _value.keyword
            : keyword // ignore: cast_nullable_to_non_nullable
                  as String,
        yourPosition: freezed == yourPosition
            ? _value.yourPosition
            : yourPosition // ignore: cast_nullable_to_non_nullable
                  as int?,
        competitorPosition: freezed == competitorPosition
            ? _value.competitorPosition
            : competitorPosition // ignore: cast_nullable_to_non_nullable
                  as int?,
        gap: freezed == gap
            ? _value.gap
            : gap // ignore: cast_nullable_to_non_nullable
                  as int?,
        popularity: freezed == popularity
            ? _value.popularity
            : popularity // ignore: cast_nullable_to_non_nullable
                  as int?,
        isTracking: null == isTracking
            ? _value.isTracking
            : isTracking // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KeywordComparisonImpl extends _KeywordComparison {
  const _$KeywordComparisonImpl({
    @JsonKey(name: 'keyword_id') required this.keywordId,
    required this.keyword,
    @JsonKey(name: 'your_position') this.yourPosition,
    @JsonKey(name: 'competitor_position') this.competitorPosition,
    this.gap,
    this.popularity,
    @JsonKey(name: 'is_tracking') required this.isTracking,
  }) : super._();

  factory _$KeywordComparisonImpl.fromJson(Map<String, dynamic> json) =>
      _$$KeywordComparisonImplFromJson(json);

  @override
  @JsonKey(name: 'keyword_id')
  final int keywordId;
  @override
  final String keyword;
  @override
  @JsonKey(name: 'your_position')
  final int? yourPosition;
  @override
  @JsonKey(name: 'competitor_position')
  final int? competitorPosition;
  @override
  final int? gap;
  @override
  final int? popularity;
  @override
  @JsonKey(name: 'is_tracking')
  final bool isTracking;

  @override
  String toString() {
    return 'KeywordComparison(keywordId: $keywordId, keyword: $keyword, yourPosition: $yourPosition, competitorPosition: $competitorPosition, gap: $gap, popularity: $popularity, isTracking: $isTracking)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KeywordComparisonImpl &&
            (identical(other.keywordId, keywordId) ||
                other.keywordId == keywordId) &&
            (identical(other.keyword, keyword) || other.keyword == keyword) &&
            (identical(other.yourPosition, yourPosition) ||
                other.yourPosition == yourPosition) &&
            (identical(other.competitorPosition, competitorPosition) ||
                other.competitorPosition == competitorPosition) &&
            (identical(other.gap, gap) || other.gap == gap) &&
            (identical(other.popularity, popularity) ||
                other.popularity == popularity) &&
            (identical(other.isTracking, isTracking) ||
                other.isTracking == isTracking));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    keywordId,
    keyword,
    yourPosition,
    competitorPosition,
    gap,
    popularity,
    isTracking,
  );

  /// Create a copy of KeywordComparison
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KeywordComparisonImplCopyWith<_$KeywordComparisonImpl> get copyWith =>
      __$$KeywordComparisonImplCopyWithImpl<_$KeywordComparisonImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$KeywordComparisonImplToJson(this);
  }
}

abstract class _KeywordComparison extends KeywordComparison {
  const factory _KeywordComparison({
    @JsonKey(name: 'keyword_id') required final int keywordId,
    required final String keyword,
    @JsonKey(name: 'your_position') final int? yourPosition,
    @JsonKey(name: 'competitor_position') final int? competitorPosition,
    final int? gap,
    final int? popularity,
    @JsonKey(name: 'is_tracking') required final bool isTracking,
  }) = _$KeywordComparisonImpl;
  const _KeywordComparison._() : super._();

  factory _KeywordComparison.fromJson(Map<String, dynamic> json) =
      _$KeywordComparisonImpl.fromJson;

  @override
  @JsonKey(name: 'keyword_id')
  int get keywordId;
  @override
  String get keyword;
  @override
  @JsonKey(name: 'your_position')
  int? get yourPosition;
  @override
  @JsonKey(name: 'competitor_position')
  int? get competitorPosition;
  @override
  int? get gap;
  @override
  int? get popularity;
  @override
  @JsonKey(name: 'is_tracking')
  bool get isTracking;

  /// Create a copy of KeywordComparison
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KeywordComparisonImplCopyWith<_$KeywordComparisonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
