// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'keyword_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Keyword _$KeywordFromJson(Map<String, dynamic> json) {
  return _Keyword.fromJson(json);
}

/// @nodoc
mixin _$Keyword {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'tracked_keyword_id')
  int? get trackedKeywordId => throw _privateConstructorUsedError;
  String get keyword => throw _privateConstructorUsedError;
  String get storefront => throw _privateConstructorUsedError;
  int? get popularity => throw _privateConstructorUsedError;
  int? get position => throw _privateConstructorUsedError;
  int? get change => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_updated')
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  @JsonKey(name: 'tracked_since')
  DateTime? get trackedSince => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_favorite')
  bool get isFavorite => throw _privateConstructorUsedError;
  @JsonKey(name: 'favorited_at')
  DateTime? get favoritedAt => throw _privateConstructorUsedError;
  List<TagModel> get tags => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  int? get difficulty => throw _privateConstructorUsedError;
  @JsonKey(name: 'difficulty_label')
  String? get difficultyLabel => throw _privateConstructorUsedError;
  int? get competition => throw _privateConstructorUsedError;
  @JsonKey(name: 'top_competitors')
  List<TopCompetitor>? get topCompetitors => throw _privateConstructorUsedError;

  /// Serializes this Keyword to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Keyword
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KeywordCopyWith<Keyword> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KeywordCopyWith<$Res> {
  factory $KeywordCopyWith(Keyword value, $Res Function(Keyword) then) =
      _$KeywordCopyWithImpl<$Res, Keyword>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'tracked_keyword_id') int? trackedKeywordId,
    String keyword,
    String storefront,
    int? popularity,
    int? position,
    int? change,
    @JsonKey(name: 'last_updated') DateTime? lastUpdated,
    @JsonKey(name: 'tracked_since') DateTime? trackedSince,
    @JsonKey(name: 'is_favorite') bool isFavorite,
    @JsonKey(name: 'favorited_at') DateTime? favoritedAt,
    List<TagModel> tags,
    String? note,
    int? difficulty,
    @JsonKey(name: 'difficulty_label') String? difficultyLabel,
    int? competition,
    @JsonKey(name: 'top_competitors') List<TopCompetitor>? topCompetitors,
  });
}

/// @nodoc
class _$KeywordCopyWithImpl<$Res, $Val extends Keyword>
    implements $KeywordCopyWith<$Res> {
  _$KeywordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Keyword
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trackedKeywordId = freezed,
    Object? keyword = null,
    Object? storefront = null,
    Object? popularity = freezed,
    Object? position = freezed,
    Object? change = freezed,
    Object? lastUpdated = freezed,
    Object? trackedSince = freezed,
    Object? isFavorite = null,
    Object? favoritedAt = freezed,
    Object? tags = null,
    Object? note = freezed,
    Object? difficulty = freezed,
    Object? difficultyLabel = freezed,
    Object? competition = freezed,
    Object? topCompetitors = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            trackedKeywordId: freezed == trackedKeywordId
                ? _value.trackedKeywordId
                : trackedKeywordId // ignore: cast_nullable_to_non_nullable
                      as int?,
            keyword: null == keyword
                ? _value.keyword
                : keyword // ignore: cast_nullable_to_non_nullable
                      as String,
            storefront: null == storefront
                ? _value.storefront
                : storefront // ignore: cast_nullable_to_non_nullable
                      as String,
            popularity: freezed == popularity
                ? _value.popularity
                : popularity // ignore: cast_nullable_to_non_nullable
                      as int?,
            position: freezed == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int?,
            change: freezed == change
                ? _value.change
                : change // ignore: cast_nullable_to_non_nullable
                      as int?,
            lastUpdated: freezed == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            trackedSince: freezed == trackedSince
                ? _value.trackedSince
                : trackedSince // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isFavorite: null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
            favoritedAt: freezed == favoritedAt
                ? _value.favoritedAt
                : favoritedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<TagModel>,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
            difficulty: freezed == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as int?,
            difficultyLabel: freezed == difficultyLabel
                ? _value.difficultyLabel
                : difficultyLabel // ignore: cast_nullable_to_non_nullable
                      as String?,
            competition: freezed == competition
                ? _value.competition
                : competition // ignore: cast_nullable_to_non_nullable
                      as int?,
            topCompetitors: freezed == topCompetitors
                ? _value.topCompetitors
                : topCompetitors // ignore: cast_nullable_to_non_nullable
                      as List<TopCompetitor>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KeywordImplCopyWith<$Res> implements $KeywordCopyWith<$Res> {
  factory _$$KeywordImplCopyWith(
    _$KeywordImpl value,
    $Res Function(_$KeywordImpl) then,
  ) = __$$KeywordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'tracked_keyword_id') int? trackedKeywordId,
    String keyword,
    String storefront,
    int? popularity,
    int? position,
    int? change,
    @JsonKey(name: 'last_updated') DateTime? lastUpdated,
    @JsonKey(name: 'tracked_since') DateTime? trackedSince,
    @JsonKey(name: 'is_favorite') bool isFavorite,
    @JsonKey(name: 'favorited_at') DateTime? favoritedAt,
    List<TagModel> tags,
    String? note,
    int? difficulty,
    @JsonKey(name: 'difficulty_label') String? difficultyLabel,
    int? competition,
    @JsonKey(name: 'top_competitors') List<TopCompetitor>? topCompetitors,
  });
}

/// @nodoc
class __$$KeywordImplCopyWithImpl<$Res>
    extends _$KeywordCopyWithImpl<$Res, _$KeywordImpl>
    implements _$$KeywordImplCopyWith<$Res> {
  __$$KeywordImplCopyWithImpl(
    _$KeywordImpl _value,
    $Res Function(_$KeywordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Keyword
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trackedKeywordId = freezed,
    Object? keyword = null,
    Object? storefront = null,
    Object? popularity = freezed,
    Object? position = freezed,
    Object? change = freezed,
    Object? lastUpdated = freezed,
    Object? trackedSince = freezed,
    Object? isFavorite = null,
    Object? favoritedAt = freezed,
    Object? tags = null,
    Object? note = freezed,
    Object? difficulty = freezed,
    Object? difficultyLabel = freezed,
    Object? competition = freezed,
    Object? topCompetitors = freezed,
  }) {
    return _then(
      _$KeywordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        trackedKeywordId: freezed == trackedKeywordId
            ? _value.trackedKeywordId
            : trackedKeywordId // ignore: cast_nullable_to_non_nullable
                  as int?,
        keyword: null == keyword
            ? _value.keyword
            : keyword // ignore: cast_nullable_to_non_nullable
                  as String,
        storefront: null == storefront
            ? _value.storefront
            : storefront // ignore: cast_nullable_to_non_nullable
                  as String,
        popularity: freezed == popularity
            ? _value.popularity
            : popularity // ignore: cast_nullable_to_non_nullable
                  as int?,
        position: freezed == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int?,
        change: freezed == change
            ? _value.change
            : change // ignore: cast_nullable_to_non_nullable
                  as int?,
        lastUpdated: freezed == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        trackedSince: freezed == trackedSince
            ? _value.trackedSince
            : trackedSince // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isFavorite: null == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
        favoritedAt: freezed == favoritedAt
            ? _value.favoritedAt
            : favoritedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<TagModel>,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
        difficulty: freezed == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as int?,
        difficultyLabel: freezed == difficultyLabel
            ? _value.difficultyLabel
            : difficultyLabel // ignore: cast_nullable_to_non_nullable
                  as String?,
        competition: freezed == competition
            ? _value.competition
            : competition // ignore: cast_nullable_to_non_nullable
                  as int?,
        topCompetitors: freezed == topCompetitors
            ? _value._topCompetitors
            : topCompetitors // ignore: cast_nullable_to_non_nullable
                  as List<TopCompetitor>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KeywordImpl extends _Keyword {
  const _$KeywordImpl({
    required this.id,
    @JsonKey(name: 'tracked_keyword_id') this.trackedKeywordId,
    required this.keyword,
    required this.storefront,
    this.popularity,
    this.position,
    this.change,
    @JsonKey(name: 'last_updated') this.lastUpdated,
    @JsonKey(name: 'tracked_since') this.trackedSince,
    @JsonKey(name: 'is_favorite') this.isFavorite = false,
    @JsonKey(name: 'favorited_at') this.favoritedAt,
    final List<TagModel> tags = const [],
    this.note,
    this.difficulty,
    @JsonKey(name: 'difficulty_label') this.difficultyLabel,
    this.competition,
    @JsonKey(name: 'top_competitors') final List<TopCompetitor>? topCompetitors,
  }) : _tags = tags,
       _topCompetitors = topCompetitors,
       super._();

  factory _$KeywordImpl.fromJson(Map<String, dynamic> json) =>
      _$$KeywordImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'tracked_keyword_id')
  final int? trackedKeywordId;
  @override
  final String keyword;
  @override
  final String storefront;
  @override
  final int? popularity;
  @override
  final int? position;
  @override
  final int? change;
  @override
  @JsonKey(name: 'last_updated')
  final DateTime? lastUpdated;
  @override
  @JsonKey(name: 'tracked_since')
  final DateTime? trackedSince;
  @override
  @JsonKey(name: 'is_favorite')
  final bool isFavorite;
  @override
  @JsonKey(name: 'favorited_at')
  final DateTime? favoritedAt;
  final List<TagModel> _tags;
  @override
  @JsonKey()
  List<TagModel> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? note;
  @override
  final int? difficulty;
  @override
  @JsonKey(name: 'difficulty_label')
  final String? difficultyLabel;
  @override
  final int? competition;
  final List<TopCompetitor>? _topCompetitors;
  @override
  @JsonKey(name: 'top_competitors')
  List<TopCompetitor>? get topCompetitors {
    final value = _topCompetitors;
    if (value == null) return null;
    if (_topCompetitors is EqualUnmodifiableListView) return _topCompetitors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Keyword(id: $id, trackedKeywordId: $trackedKeywordId, keyword: $keyword, storefront: $storefront, popularity: $popularity, position: $position, change: $change, lastUpdated: $lastUpdated, trackedSince: $trackedSince, isFavorite: $isFavorite, favoritedAt: $favoritedAt, tags: $tags, note: $note, difficulty: $difficulty, difficultyLabel: $difficultyLabel, competition: $competition, topCompetitors: $topCompetitors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KeywordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.trackedKeywordId, trackedKeywordId) ||
                other.trackedKeywordId == trackedKeywordId) &&
            (identical(other.keyword, keyword) || other.keyword == keyword) &&
            (identical(other.storefront, storefront) ||
                other.storefront == storefront) &&
            (identical(other.popularity, popularity) ||
                other.popularity == popularity) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.change, change) || other.change == change) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.trackedSince, trackedSince) ||
                other.trackedSince == trackedSince) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.favoritedAt, favoritedAt) ||
                other.favoritedAt == favoritedAt) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.difficultyLabel, difficultyLabel) ||
                other.difficultyLabel == difficultyLabel) &&
            (identical(other.competition, competition) ||
                other.competition == competition) &&
            const DeepCollectionEquality().equals(
              other._topCompetitors,
              _topCompetitors,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    trackedKeywordId,
    keyword,
    storefront,
    popularity,
    position,
    change,
    lastUpdated,
    trackedSince,
    isFavorite,
    favoritedAt,
    const DeepCollectionEquality().hash(_tags),
    note,
    difficulty,
    difficultyLabel,
    competition,
    const DeepCollectionEquality().hash(_topCompetitors),
  );

  /// Create a copy of Keyword
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KeywordImplCopyWith<_$KeywordImpl> get copyWith =>
      __$$KeywordImplCopyWithImpl<_$KeywordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KeywordImplToJson(this);
  }
}

abstract class _Keyword extends Keyword {
  const factory _Keyword({
    required final int id,
    @JsonKey(name: 'tracked_keyword_id') final int? trackedKeywordId,
    required final String keyword,
    required final String storefront,
    final int? popularity,
    final int? position,
    final int? change,
    @JsonKey(name: 'last_updated') final DateTime? lastUpdated,
    @JsonKey(name: 'tracked_since') final DateTime? trackedSince,
    @JsonKey(name: 'is_favorite') final bool isFavorite,
    @JsonKey(name: 'favorited_at') final DateTime? favoritedAt,
    final List<TagModel> tags,
    final String? note,
    final int? difficulty,
    @JsonKey(name: 'difficulty_label') final String? difficultyLabel,
    final int? competition,
    @JsonKey(name: 'top_competitors') final List<TopCompetitor>? topCompetitors,
  }) = _$KeywordImpl;
  const _Keyword._() : super._();

  factory _Keyword.fromJson(Map<String, dynamic> json) = _$KeywordImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'tracked_keyword_id')
  int? get trackedKeywordId;
  @override
  String get keyword;
  @override
  String get storefront;
  @override
  int? get popularity;
  @override
  int? get position;
  @override
  int? get change;
  @override
  @JsonKey(name: 'last_updated')
  DateTime? get lastUpdated;
  @override
  @JsonKey(name: 'tracked_since')
  DateTime? get trackedSince;
  @override
  @JsonKey(name: 'is_favorite')
  bool get isFavorite;
  @override
  @JsonKey(name: 'favorited_at')
  DateTime? get favoritedAt;
  @override
  List<TagModel> get tags;
  @override
  String? get note;
  @override
  int? get difficulty;
  @override
  @JsonKey(name: 'difficulty_label')
  String? get difficultyLabel;
  @override
  int? get competition;
  @override
  @JsonKey(name: 'top_competitors')
  List<TopCompetitor>? get topCompetitors;

  /// Create a copy of Keyword
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KeywordImplCopyWith<_$KeywordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KeywordSearchResponse _$KeywordSearchResponseFromJson(
  Map<String, dynamic> json,
) {
  return _KeywordSearchResponse.fromJson(json);
}

/// @nodoc
mixin _$KeywordSearchResponse {
  KeywordInfo get keyword => throw _privateConstructorUsedError;
  List<KeywordSearchResult> get results => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_results')
  int get totalResults => throw _privateConstructorUsedError;

  /// Serializes this KeywordSearchResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KeywordSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KeywordSearchResponseCopyWith<KeywordSearchResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KeywordSearchResponseCopyWith<$Res> {
  factory $KeywordSearchResponseCopyWith(
    KeywordSearchResponse value,
    $Res Function(KeywordSearchResponse) then,
  ) = _$KeywordSearchResponseCopyWithImpl<$Res, KeywordSearchResponse>;
  @useResult
  $Res call({
    KeywordInfo keyword,
    List<KeywordSearchResult> results,
    @JsonKey(name: 'total_results') int totalResults,
  });

  $KeywordInfoCopyWith<$Res> get keyword;
}

/// @nodoc
class _$KeywordSearchResponseCopyWithImpl<
  $Res,
  $Val extends KeywordSearchResponse
>
    implements $KeywordSearchResponseCopyWith<$Res> {
  _$KeywordSearchResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KeywordSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keyword = null,
    Object? results = null,
    Object? totalResults = null,
  }) {
    return _then(
      _value.copyWith(
            keyword: null == keyword
                ? _value.keyword
                : keyword // ignore: cast_nullable_to_non_nullable
                      as KeywordInfo,
            results: null == results
                ? _value.results
                : results // ignore: cast_nullable_to_non_nullable
                      as List<KeywordSearchResult>,
            totalResults: null == totalResults
                ? _value.totalResults
                : totalResults // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of KeywordSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $KeywordInfoCopyWith<$Res> get keyword {
    return $KeywordInfoCopyWith<$Res>(_value.keyword, (value) {
      return _then(_value.copyWith(keyword: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$KeywordSearchResponseImplCopyWith<$Res>
    implements $KeywordSearchResponseCopyWith<$Res> {
  factory _$$KeywordSearchResponseImplCopyWith(
    _$KeywordSearchResponseImpl value,
    $Res Function(_$KeywordSearchResponseImpl) then,
  ) = __$$KeywordSearchResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    KeywordInfo keyword,
    List<KeywordSearchResult> results,
    @JsonKey(name: 'total_results') int totalResults,
  });

  @override
  $KeywordInfoCopyWith<$Res> get keyword;
}

/// @nodoc
class __$$KeywordSearchResponseImplCopyWithImpl<$Res>
    extends
        _$KeywordSearchResponseCopyWithImpl<$Res, _$KeywordSearchResponseImpl>
    implements _$$KeywordSearchResponseImplCopyWith<$Res> {
  __$$KeywordSearchResponseImplCopyWithImpl(
    _$KeywordSearchResponseImpl _value,
    $Res Function(_$KeywordSearchResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KeywordSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keyword = null,
    Object? results = null,
    Object? totalResults = null,
  }) {
    return _then(
      _$KeywordSearchResponseImpl(
        keyword: null == keyword
            ? _value.keyword
            : keyword // ignore: cast_nullable_to_non_nullable
                  as KeywordInfo,
        results: null == results
            ? _value._results
            : results // ignore: cast_nullable_to_non_nullable
                  as List<KeywordSearchResult>,
        totalResults: null == totalResults
            ? _value.totalResults
            : totalResults // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KeywordSearchResponseImpl implements _KeywordSearchResponse {
  const _$KeywordSearchResponseImpl({
    required this.keyword,
    required final List<KeywordSearchResult> results,
    @JsonKey(name: 'total_results') required this.totalResults,
  }) : _results = results;

  factory _$KeywordSearchResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$KeywordSearchResponseImplFromJson(json);

  @override
  final KeywordInfo keyword;
  final List<KeywordSearchResult> _results;
  @override
  List<KeywordSearchResult> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  @JsonKey(name: 'total_results')
  final int totalResults;

  @override
  String toString() {
    return 'KeywordSearchResponse(keyword: $keyword, results: $results, totalResults: $totalResults)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KeywordSearchResponseImpl &&
            (identical(other.keyword, keyword) || other.keyword == keyword) &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            (identical(other.totalResults, totalResults) ||
                other.totalResults == totalResults));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    keyword,
    const DeepCollectionEquality().hash(_results),
    totalResults,
  );

  /// Create a copy of KeywordSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KeywordSearchResponseImplCopyWith<_$KeywordSearchResponseImpl>
  get copyWith =>
      __$$KeywordSearchResponseImplCopyWithImpl<_$KeywordSearchResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$KeywordSearchResponseImplToJson(this);
  }
}

abstract class _KeywordSearchResponse implements KeywordSearchResponse {
  const factory _KeywordSearchResponse({
    required final KeywordInfo keyword,
    required final List<KeywordSearchResult> results,
    @JsonKey(name: 'total_results') required final int totalResults,
  }) = _$KeywordSearchResponseImpl;

  factory _KeywordSearchResponse.fromJson(Map<String, dynamic> json) =
      _$KeywordSearchResponseImpl.fromJson;

  @override
  KeywordInfo get keyword;
  @override
  List<KeywordSearchResult> get results;
  @override
  @JsonKey(name: 'total_results')
  int get totalResults;

  /// Create a copy of KeywordSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KeywordSearchResponseImplCopyWith<_$KeywordSearchResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

KeywordInfo _$KeywordInfoFromJson(Map<String, dynamic> json) {
  return _KeywordInfo.fromJson(json);
}

/// @nodoc
mixin _$KeywordInfo {
  int get id => throw _privateConstructorUsedError;
  String get keyword => throw _privateConstructorUsedError;
  String get storefront => throw _privateConstructorUsedError;
  int? get popularity => throw _privateConstructorUsedError;

  /// Serializes this KeywordInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KeywordInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KeywordInfoCopyWith<KeywordInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KeywordInfoCopyWith<$Res> {
  factory $KeywordInfoCopyWith(
    KeywordInfo value,
    $Res Function(KeywordInfo) then,
  ) = _$KeywordInfoCopyWithImpl<$Res, KeywordInfo>;
  @useResult
  $Res call({int id, String keyword, String storefront, int? popularity});
}

/// @nodoc
class _$KeywordInfoCopyWithImpl<$Res, $Val extends KeywordInfo>
    implements $KeywordInfoCopyWith<$Res> {
  _$KeywordInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KeywordInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? keyword = null,
    Object? storefront = null,
    Object? popularity = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            keyword: null == keyword
                ? _value.keyword
                : keyword // ignore: cast_nullable_to_non_nullable
                      as String,
            storefront: null == storefront
                ? _value.storefront
                : storefront // ignore: cast_nullable_to_non_nullable
                      as String,
            popularity: freezed == popularity
                ? _value.popularity
                : popularity // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KeywordInfoImplCopyWith<$Res>
    implements $KeywordInfoCopyWith<$Res> {
  factory _$$KeywordInfoImplCopyWith(
    _$KeywordInfoImpl value,
    $Res Function(_$KeywordInfoImpl) then,
  ) = __$$KeywordInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String keyword, String storefront, int? popularity});
}

/// @nodoc
class __$$KeywordInfoImplCopyWithImpl<$Res>
    extends _$KeywordInfoCopyWithImpl<$Res, _$KeywordInfoImpl>
    implements _$$KeywordInfoImplCopyWith<$Res> {
  __$$KeywordInfoImplCopyWithImpl(
    _$KeywordInfoImpl _value,
    $Res Function(_$KeywordInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KeywordInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? keyword = null,
    Object? storefront = null,
    Object? popularity = freezed,
  }) {
    return _then(
      _$KeywordInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        keyword: null == keyword
            ? _value.keyword
            : keyword // ignore: cast_nullable_to_non_nullable
                  as String,
        storefront: null == storefront
            ? _value.storefront
            : storefront // ignore: cast_nullable_to_non_nullable
                  as String,
        popularity: freezed == popularity
            ? _value.popularity
            : popularity // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KeywordInfoImpl implements _KeywordInfo {
  const _$KeywordInfoImpl({
    required this.id,
    required this.keyword,
    required this.storefront,
    this.popularity,
  });

  factory _$KeywordInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$KeywordInfoImplFromJson(json);

  @override
  final int id;
  @override
  final String keyword;
  @override
  final String storefront;
  @override
  final int? popularity;

  @override
  String toString() {
    return 'KeywordInfo(id: $id, keyword: $keyword, storefront: $storefront, popularity: $popularity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KeywordInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.keyword, keyword) || other.keyword == keyword) &&
            (identical(other.storefront, storefront) ||
                other.storefront == storefront) &&
            (identical(other.popularity, popularity) ||
                other.popularity == popularity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, keyword, storefront, popularity);

  /// Create a copy of KeywordInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KeywordInfoImplCopyWith<_$KeywordInfoImpl> get copyWith =>
      __$$KeywordInfoImplCopyWithImpl<_$KeywordInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KeywordInfoImplToJson(this);
  }
}

abstract class _KeywordInfo implements KeywordInfo {
  const factory _KeywordInfo({
    required final int id,
    required final String keyword,
    required final String storefront,
    final int? popularity,
  }) = _$KeywordInfoImpl;

  factory _KeywordInfo.fromJson(Map<String, dynamic> json) =
      _$KeywordInfoImpl.fromJson;

  @override
  int get id;
  @override
  String get keyword;
  @override
  String get storefront;
  @override
  int? get popularity;

  /// Create a copy of KeywordInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KeywordInfoImplCopyWith<_$KeywordInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KeywordSearchResult _$KeywordSearchResultFromJson(Map<String, dynamic> json) {
  return _KeywordSearchResult.fromJson(json);
}

/// @nodoc
mixin _$KeywordSearchResult {
  int get position => throw _privateConstructorUsedError;
  @JsonKey(name: 'apple_id')
  String? get appleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'google_play_id')
  String? get googlePlayId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  String? get developer => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
  int get ratingCount => throw _privateConstructorUsedError;

  /// Serializes this KeywordSearchResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KeywordSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KeywordSearchResultCopyWith<KeywordSearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KeywordSearchResultCopyWith<$Res> {
  factory $KeywordSearchResultCopyWith(
    KeywordSearchResult value,
    $Res Function(KeywordSearchResult) then,
  ) = _$KeywordSearchResultCopyWithImpl<$Res, KeywordSearchResult>;
  @useResult
  $Res call({
    int position,
    @JsonKey(name: 'apple_id') String? appleId,
    @JsonKey(name: 'google_play_id') String? googlePlayId,
    String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? developer,
    @JsonKey(fromJson: _parseDouble) double? rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero) int ratingCount,
  });
}

/// @nodoc
class _$KeywordSearchResultCopyWithImpl<$Res, $Val extends KeywordSearchResult>
    implements $KeywordSearchResultCopyWith<$Res> {
  _$KeywordSearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KeywordSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? appleId = freezed,
    Object? googlePlayId = freezed,
    Object? name = null,
    Object? iconUrl = freezed,
    Object? developer = freezed,
    Object? rating = freezed,
    Object? ratingCount = null,
  }) {
    return _then(
      _value.copyWith(
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int,
            appleId: freezed == appleId
                ? _value.appleId
                : appleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            googlePlayId: freezed == googlePlayId
                ? _value.googlePlayId
                : googlePlayId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$KeywordSearchResultImplCopyWith<$Res>
    implements $KeywordSearchResultCopyWith<$Res> {
  factory _$$KeywordSearchResultImplCopyWith(
    _$KeywordSearchResultImpl value,
    $Res Function(_$KeywordSearchResultImpl) then,
  ) = __$$KeywordSearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int position,
    @JsonKey(name: 'apple_id') String? appleId,
    @JsonKey(name: 'google_play_id') String? googlePlayId,
    String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? developer,
    @JsonKey(fromJson: _parseDouble) double? rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero) int ratingCount,
  });
}

/// @nodoc
class __$$KeywordSearchResultImplCopyWithImpl<$Res>
    extends _$KeywordSearchResultCopyWithImpl<$Res, _$KeywordSearchResultImpl>
    implements _$$KeywordSearchResultImplCopyWith<$Res> {
  __$$KeywordSearchResultImplCopyWithImpl(
    _$KeywordSearchResultImpl _value,
    $Res Function(_$KeywordSearchResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KeywordSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? appleId = freezed,
    Object? googlePlayId = freezed,
    Object? name = null,
    Object? iconUrl = freezed,
    Object? developer = freezed,
    Object? rating = freezed,
    Object? ratingCount = null,
  }) {
    return _then(
      _$KeywordSearchResultImpl(
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
        appleId: freezed == appleId
            ? _value.appleId
            : appleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        googlePlayId: freezed == googlePlayId
            ? _value.googlePlayId
            : googlePlayId // ignore: cast_nullable_to_non_nullable
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
class _$KeywordSearchResultImpl extends _KeywordSearchResult {
  const _$KeywordSearchResultImpl({
    required this.position,
    @JsonKey(name: 'apple_id') this.appleId,
    @JsonKey(name: 'google_play_id') this.googlePlayId,
    required this.name,
    @JsonKey(name: 'icon_url') this.iconUrl,
    this.developer,
    @JsonKey(fromJson: _parseDouble) this.rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
    required this.ratingCount,
  }) : super._();

  factory _$KeywordSearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$KeywordSearchResultImplFromJson(json);

  @override
  final int position;
  @override
  @JsonKey(name: 'apple_id')
  final String? appleId;
  @override
  @JsonKey(name: 'google_play_id')
  final String? googlePlayId;
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
  String toString() {
    return 'KeywordSearchResult(position: $position, appleId: $appleId, googlePlayId: $googlePlayId, name: $name, iconUrl: $iconUrl, developer: $developer, rating: $rating, ratingCount: $ratingCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KeywordSearchResultImpl &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.appleId, appleId) || other.appleId == appleId) &&
            (identical(other.googlePlayId, googlePlayId) ||
                other.googlePlayId == googlePlayId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.developer, developer) ||
                other.developer == developer) &&
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
    googlePlayId,
    name,
    iconUrl,
    developer,
    rating,
    ratingCount,
  );

  /// Create a copy of KeywordSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KeywordSearchResultImplCopyWith<_$KeywordSearchResultImpl> get copyWith =>
      __$$KeywordSearchResultImplCopyWithImpl<_$KeywordSearchResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$KeywordSearchResultImplToJson(this);
  }
}

abstract class _KeywordSearchResult extends KeywordSearchResult {
  const factory _KeywordSearchResult({
    required final int position,
    @JsonKey(name: 'apple_id') final String? appleId,
    @JsonKey(name: 'google_play_id') final String? googlePlayId,
    required final String name,
    @JsonKey(name: 'icon_url') final String? iconUrl,
    final String? developer,
    @JsonKey(fromJson: _parseDouble) final double? rating,
    @JsonKey(name: 'rating_count', fromJson: _parseIntOrZero)
    required final int ratingCount,
  }) = _$KeywordSearchResultImpl;
  const _KeywordSearchResult._() : super._();

  factory _KeywordSearchResult.fromJson(Map<String, dynamic> json) =
      _$KeywordSearchResultImpl.fromJson;

  @override
  int get position;
  @override
  @JsonKey(name: 'apple_id')
  String? get appleId;
  @override
  @JsonKey(name: 'google_play_id')
  String? get googlePlayId;
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

  /// Create a copy of KeywordSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KeywordSearchResultImplCopyWith<_$KeywordSearchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopCompetitor _$TopCompetitorFromJson(Map<String, dynamic> json) {
  return _TopCompetitor.fromJson(json);
}

/// @nodoc
mixin _$TopCompetitor {
  String get name => throw _privateConstructorUsedError;
  int get position => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;

  /// Serializes this TopCompetitor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopCompetitor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopCompetitorCopyWith<TopCompetitor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopCompetitorCopyWith<$Res> {
  factory $TopCompetitorCopyWith(
    TopCompetitor value,
    $Res Function(TopCompetitor) then,
  ) = _$TopCompetitorCopyWithImpl<$Res, TopCompetitor>;
  @useResult
  $Res call({
    String name,
    int position,
    @JsonKey(fromJson: _parseDouble) double? rating,
    @JsonKey(name: 'icon_url') String? iconUrl,
  });
}

/// @nodoc
class _$TopCompetitorCopyWithImpl<$Res, $Val extends TopCompetitor>
    implements $TopCompetitorCopyWith<$Res> {
  _$TopCompetitorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopCompetitor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? position = null,
    Object? rating = freezed,
    Object? iconUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
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
abstract class _$$TopCompetitorImplCopyWith<$Res>
    implements $TopCompetitorCopyWith<$Res> {
  factory _$$TopCompetitorImplCopyWith(
    _$TopCompetitorImpl value,
    $Res Function(_$TopCompetitorImpl) then,
  ) = __$$TopCompetitorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    int position,
    @JsonKey(fromJson: _parseDouble) double? rating,
    @JsonKey(name: 'icon_url') String? iconUrl,
  });
}

/// @nodoc
class __$$TopCompetitorImplCopyWithImpl<$Res>
    extends _$TopCompetitorCopyWithImpl<$Res, _$TopCompetitorImpl>
    implements _$$TopCompetitorImplCopyWith<$Res> {
  __$$TopCompetitorImplCopyWithImpl(
    _$TopCompetitorImpl _value,
    $Res Function(_$TopCompetitorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopCompetitor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? position = null,
    Object? rating = freezed,
    Object? iconUrl = freezed,
  }) {
    return _then(
      _$TopCompetitorImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
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
class _$TopCompetitorImpl implements _TopCompetitor {
  const _$TopCompetitorImpl({
    required this.name,
    required this.position,
    @JsonKey(fromJson: _parseDouble) this.rating,
    @JsonKey(name: 'icon_url') this.iconUrl,
  });

  factory _$TopCompetitorImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopCompetitorImplFromJson(json);

  @override
  final String name;
  @override
  final int position;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double? rating;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;

  @override
  String toString() {
    return 'TopCompetitor(name: $name, position: $position, rating: $rating, iconUrl: $iconUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopCompetitorImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, position, rating, iconUrl);

  /// Create a copy of TopCompetitor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopCompetitorImplCopyWith<_$TopCompetitorImpl> get copyWith =>
      __$$TopCompetitorImplCopyWithImpl<_$TopCompetitorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopCompetitorImplToJson(this);
  }
}

abstract class _TopCompetitor implements TopCompetitor {
  const factory _TopCompetitor({
    required final String name,
    required final int position,
    @JsonKey(fromJson: _parseDouble) final double? rating,
    @JsonKey(name: 'icon_url') final String? iconUrl,
  }) = _$TopCompetitorImpl;

  factory _TopCompetitor.fromJson(Map<String, dynamic> json) =
      _$TopCompetitorImpl.fromJson;

  @override
  String get name;
  @override
  int get position;
  @override
  @JsonKey(fromJson: _parseDouble)
  double? get rating;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;

  /// Create a copy of TopCompetitor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopCompetitorImplCopyWith<_$TopCompetitorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
