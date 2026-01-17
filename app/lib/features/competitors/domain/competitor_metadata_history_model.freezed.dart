// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competitor_metadata_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CompetitorMetadataHistoryResponse _$CompetitorMetadataHistoryResponseFromJson(
  Map<String, dynamic> json,
) {
  return _CompetitorMetadataHistoryResponse.fromJson(json);
}

/// @nodoc
mixin _$CompetitorMetadataHistoryResponse {
  CompetitorInfo get competitor => throw _privateConstructorUsedError;
  String get locale => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_metadata')
  MetadataSnapshot? get currentMetadata => throw _privateConstructorUsedError;
  MetadataHistorySummary get summary => throw _privateConstructorUsedError;
  List<MetadataTimelineEntry> get timeline =>
      throw _privateConstructorUsedError;

  /// Serializes this CompetitorMetadataHistoryResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompetitorMetadataHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompetitorMetadataHistoryResponseCopyWith<CompetitorMetadataHistoryResponse>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompetitorMetadataHistoryResponseCopyWith<$Res> {
  factory $CompetitorMetadataHistoryResponseCopyWith(
    CompetitorMetadataHistoryResponse value,
    $Res Function(CompetitorMetadataHistoryResponse) then,
  ) =
      _$CompetitorMetadataHistoryResponseCopyWithImpl<
        $Res,
        CompetitorMetadataHistoryResponse
      >;
  @useResult
  $Res call({
    CompetitorInfo competitor,
    String locale,
    @JsonKey(name: 'current_metadata') MetadataSnapshot? currentMetadata,
    MetadataHistorySummary summary,
    List<MetadataTimelineEntry> timeline,
  });

  $CompetitorInfoCopyWith<$Res> get competitor;
  $MetadataSnapshotCopyWith<$Res>? get currentMetadata;
  $MetadataHistorySummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$CompetitorMetadataHistoryResponseCopyWithImpl<
  $Res,
  $Val extends CompetitorMetadataHistoryResponse
>
    implements $CompetitorMetadataHistoryResponseCopyWith<$Res> {
  _$CompetitorMetadataHistoryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompetitorMetadataHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? competitor = null,
    Object? locale = null,
    Object? currentMetadata = freezed,
    Object? summary = null,
    Object? timeline = null,
  }) {
    return _then(
      _value.copyWith(
            competitor: null == competitor
                ? _value.competitor
                : competitor // ignore: cast_nullable_to_non_nullable
                      as CompetitorInfo,
            locale: null == locale
                ? _value.locale
                : locale // ignore: cast_nullable_to_non_nullable
                      as String,
            currentMetadata: freezed == currentMetadata
                ? _value.currentMetadata
                : currentMetadata // ignore: cast_nullable_to_non_nullable
                      as MetadataSnapshot?,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as MetadataHistorySummary,
            timeline: null == timeline
                ? _value.timeline
                : timeline // ignore: cast_nullable_to_non_nullable
                      as List<MetadataTimelineEntry>,
          )
          as $Val,
    );
  }

  /// Create a copy of CompetitorMetadataHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompetitorInfoCopyWith<$Res> get competitor {
    return $CompetitorInfoCopyWith<$Res>(_value.competitor, (value) {
      return _then(_value.copyWith(competitor: value) as $Val);
    });
  }

  /// Create a copy of CompetitorMetadataHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetadataSnapshotCopyWith<$Res>? get currentMetadata {
    if (_value.currentMetadata == null) {
      return null;
    }

    return $MetadataSnapshotCopyWith<$Res>(_value.currentMetadata!, (value) {
      return _then(_value.copyWith(currentMetadata: value) as $Val);
    });
  }

  /// Create a copy of CompetitorMetadataHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetadataHistorySummaryCopyWith<$Res> get summary {
    return $MetadataHistorySummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CompetitorMetadataHistoryResponseImplCopyWith<$Res>
    implements $CompetitorMetadataHistoryResponseCopyWith<$Res> {
  factory _$$CompetitorMetadataHistoryResponseImplCopyWith(
    _$CompetitorMetadataHistoryResponseImpl value,
    $Res Function(_$CompetitorMetadataHistoryResponseImpl) then,
  ) = __$$CompetitorMetadataHistoryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    CompetitorInfo competitor,
    String locale,
    @JsonKey(name: 'current_metadata') MetadataSnapshot? currentMetadata,
    MetadataHistorySummary summary,
    List<MetadataTimelineEntry> timeline,
  });

  @override
  $CompetitorInfoCopyWith<$Res> get competitor;
  @override
  $MetadataSnapshotCopyWith<$Res>? get currentMetadata;
  @override
  $MetadataHistorySummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$CompetitorMetadataHistoryResponseImplCopyWithImpl<$Res>
    extends
        _$CompetitorMetadataHistoryResponseCopyWithImpl<
          $Res,
          _$CompetitorMetadataHistoryResponseImpl
        >
    implements _$$CompetitorMetadataHistoryResponseImplCopyWith<$Res> {
  __$$CompetitorMetadataHistoryResponseImplCopyWithImpl(
    _$CompetitorMetadataHistoryResponseImpl _value,
    $Res Function(_$CompetitorMetadataHistoryResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompetitorMetadataHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? competitor = null,
    Object? locale = null,
    Object? currentMetadata = freezed,
    Object? summary = null,
    Object? timeline = null,
  }) {
    return _then(
      _$CompetitorMetadataHistoryResponseImpl(
        competitor: null == competitor
            ? _value.competitor
            : competitor // ignore: cast_nullable_to_non_nullable
                  as CompetitorInfo,
        locale: null == locale
            ? _value.locale
            : locale // ignore: cast_nullable_to_non_nullable
                  as String,
        currentMetadata: freezed == currentMetadata
            ? _value.currentMetadata
            : currentMetadata // ignore: cast_nullable_to_non_nullable
                  as MetadataSnapshot?,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as MetadataHistorySummary,
        timeline: null == timeline
            ? _value._timeline
            : timeline // ignore: cast_nullable_to_non_nullable
                  as List<MetadataTimelineEntry>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CompetitorMetadataHistoryResponseImpl
    implements _CompetitorMetadataHistoryResponse {
  const _$CompetitorMetadataHistoryResponseImpl({
    required this.competitor,
    required this.locale,
    @JsonKey(name: 'current_metadata') this.currentMetadata,
    required this.summary,
    required final List<MetadataTimelineEntry> timeline,
  }) : _timeline = timeline;

  factory _$CompetitorMetadataHistoryResponseImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CompetitorMetadataHistoryResponseImplFromJson(json);

  @override
  final CompetitorInfo competitor;
  @override
  final String locale;
  @override
  @JsonKey(name: 'current_metadata')
  final MetadataSnapshot? currentMetadata;
  @override
  final MetadataHistorySummary summary;
  final List<MetadataTimelineEntry> _timeline;
  @override
  List<MetadataTimelineEntry> get timeline {
    if (_timeline is EqualUnmodifiableListView) return _timeline;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timeline);
  }

  @override
  String toString() {
    return 'CompetitorMetadataHistoryResponse(competitor: $competitor, locale: $locale, currentMetadata: $currentMetadata, summary: $summary, timeline: $timeline)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompetitorMetadataHistoryResponseImpl &&
            (identical(other.competitor, competitor) ||
                other.competitor == competitor) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.currentMetadata, currentMetadata) ||
                other.currentMetadata == currentMetadata) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(other._timeline, _timeline));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    competitor,
    locale,
    currentMetadata,
    summary,
    const DeepCollectionEquality().hash(_timeline),
  );

  /// Create a copy of CompetitorMetadataHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompetitorMetadataHistoryResponseImplCopyWith<
    _$CompetitorMetadataHistoryResponseImpl
  >
  get copyWith =>
      __$$CompetitorMetadataHistoryResponseImplCopyWithImpl<
        _$CompetitorMetadataHistoryResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompetitorMetadataHistoryResponseImplToJson(this);
  }
}

abstract class _CompetitorMetadataHistoryResponse
    implements CompetitorMetadataHistoryResponse {
  const factory _CompetitorMetadataHistoryResponse({
    required final CompetitorInfo competitor,
    required final String locale,
    @JsonKey(name: 'current_metadata') final MetadataSnapshot? currentMetadata,
    required final MetadataHistorySummary summary,
    required final List<MetadataTimelineEntry> timeline,
  }) = _$CompetitorMetadataHistoryResponseImpl;

  factory _CompetitorMetadataHistoryResponse.fromJson(
    Map<String, dynamic> json,
  ) = _$CompetitorMetadataHistoryResponseImpl.fromJson;

  @override
  CompetitorInfo get competitor;
  @override
  String get locale;
  @override
  @JsonKey(name: 'current_metadata')
  MetadataSnapshot? get currentMetadata;
  @override
  MetadataHistorySummary get summary;
  @override
  List<MetadataTimelineEntry> get timeline;

  /// Create a copy of CompetitorMetadataHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompetitorMetadataHistoryResponseImplCopyWith<
    _$CompetitorMetadataHistoryResponseImpl
  >
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
  String get platform => throw _privateConstructorUsedError;

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
  $Res call({
    int id,
    String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String platform,
  });
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
abstract class _$$CompetitorInfoImplCopyWith<$Res>
    implements $CompetitorInfoCopyWith<$Res> {
  factory _$$CompetitorInfoImplCopyWith(
    _$CompetitorInfoImpl value,
    $Res Function(_$CompetitorInfoImpl) then,
  ) = __$$CompetitorInfoImplCopyWithImpl<$Res>;
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
    Object? platform = null,
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
class _$CompetitorInfoImpl implements _CompetitorInfo {
  const _$CompetitorInfoImpl({
    required this.id,
    required this.name,
    @JsonKey(name: 'icon_url') this.iconUrl,
    required this.platform,
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
  final String platform;

  @override
  String toString() {
    return 'CompetitorInfo(id: $id, name: $name, iconUrl: $iconUrl, platform: $platform)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompetitorInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.platform, platform) ||
                other.platform == platform));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, iconUrl, platform);

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
    required final String platform,
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
  @override
  String get platform;

  /// Create a copy of CompetitorInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompetitorInfoImplCopyWith<_$CompetitorInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MetadataSnapshot _$MetadataSnapshotFromJson(Map<String, dynamic> json) {
  return _MetadataSnapshot.fromJson(json);
}

/// @nodoc
mixin _$MetadataSnapshot {
  String? get title => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'short_description')
  String? get shortDescription => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get keywords => throw _privateConstructorUsedError;
  @JsonKey(name: 'whats_new')
  String? get whatsNew => throw _privateConstructorUsedError;
  String? get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_updated')
  String? get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this MetadataSnapshot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MetadataSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetadataSnapshotCopyWith<MetadataSnapshot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetadataSnapshotCopyWith<$Res> {
  factory $MetadataSnapshotCopyWith(
    MetadataSnapshot value,
    $Res Function(MetadataSnapshot) then,
  ) = _$MetadataSnapshotCopyWithImpl<$Res, MetadataSnapshot>;
  @useResult
  $Res call({
    String? title,
    String? subtitle,
    @JsonKey(name: 'short_description') String? shortDescription,
    String? description,
    String? keywords,
    @JsonKey(name: 'whats_new') String? whatsNew,
    String? version,
    @JsonKey(name: 'last_updated') String? lastUpdated,
  });
}

/// @nodoc
class _$MetadataSnapshotCopyWithImpl<$Res, $Val extends MetadataSnapshot>
    implements $MetadataSnapshotCopyWith<$Res> {
  _$MetadataSnapshotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetadataSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? subtitle = freezed,
    Object? shortDescription = freezed,
    Object? description = freezed,
    Object? keywords = freezed,
    Object? whatsNew = freezed,
    Object? version = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            subtitle: freezed == subtitle
                ? _value.subtitle
                : subtitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            shortDescription: freezed == shortDescription
                ? _value.shortDescription
                : shortDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            keywords: freezed == keywords
                ? _value.keywords
                : keywords // ignore: cast_nullable_to_non_nullable
                      as String?,
            whatsNew: freezed == whatsNew
                ? _value.whatsNew
                : whatsNew // ignore: cast_nullable_to_non_nullable
                      as String?,
            version: freezed == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastUpdated: freezed == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MetadataSnapshotImplCopyWith<$Res>
    implements $MetadataSnapshotCopyWith<$Res> {
  factory _$$MetadataSnapshotImplCopyWith(
    _$MetadataSnapshotImpl value,
    $Res Function(_$MetadataSnapshotImpl) then,
  ) = __$$MetadataSnapshotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? title,
    String? subtitle,
    @JsonKey(name: 'short_description') String? shortDescription,
    String? description,
    String? keywords,
    @JsonKey(name: 'whats_new') String? whatsNew,
    String? version,
    @JsonKey(name: 'last_updated') String? lastUpdated,
  });
}

/// @nodoc
class __$$MetadataSnapshotImplCopyWithImpl<$Res>
    extends _$MetadataSnapshotCopyWithImpl<$Res, _$MetadataSnapshotImpl>
    implements _$$MetadataSnapshotImplCopyWith<$Res> {
  __$$MetadataSnapshotImplCopyWithImpl(
    _$MetadataSnapshotImpl _value,
    $Res Function(_$MetadataSnapshotImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? subtitle = freezed,
    Object? shortDescription = freezed,
    Object? description = freezed,
    Object? keywords = freezed,
    Object? whatsNew = freezed,
    Object? version = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _$MetadataSnapshotImpl(
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        subtitle: freezed == subtitle
            ? _value.subtitle
            : subtitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        shortDescription: freezed == shortDescription
            ? _value.shortDescription
            : shortDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        keywords: freezed == keywords
            ? _value.keywords
            : keywords // ignore: cast_nullable_to_non_nullable
                  as String?,
        whatsNew: freezed == whatsNew
            ? _value.whatsNew
            : whatsNew // ignore: cast_nullable_to_non_nullable
                  as String?,
        version: freezed == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastUpdated: freezed == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MetadataSnapshotImpl implements _MetadataSnapshot {
  const _$MetadataSnapshotImpl({
    this.title,
    this.subtitle,
    @JsonKey(name: 'short_description') this.shortDescription,
    this.description,
    this.keywords,
    @JsonKey(name: 'whats_new') this.whatsNew,
    this.version,
    @JsonKey(name: 'last_updated') this.lastUpdated,
  });

  factory _$MetadataSnapshotImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetadataSnapshotImplFromJson(json);

  @override
  final String? title;
  @override
  final String? subtitle;
  @override
  @JsonKey(name: 'short_description')
  final String? shortDescription;
  @override
  final String? description;
  @override
  final String? keywords;
  @override
  @JsonKey(name: 'whats_new')
  final String? whatsNew;
  @override
  final String? version;
  @override
  @JsonKey(name: 'last_updated')
  final String? lastUpdated;

  @override
  String toString() {
    return 'MetadataSnapshot(title: $title, subtitle: $subtitle, shortDescription: $shortDescription, description: $description, keywords: $keywords, whatsNew: $whatsNew, version: $version, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataSnapshotImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.keywords, keywords) ||
                other.keywords == keywords) &&
            (identical(other.whatsNew, whatsNew) ||
                other.whatsNew == whatsNew) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    subtitle,
    shortDescription,
    description,
    keywords,
    whatsNew,
    version,
    lastUpdated,
  );

  /// Create a copy of MetadataSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataSnapshotImplCopyWith<_$MetadataSnapshotImpl> get copyWith =>
      __$$MetadataSnapshotImplCopyWithImpl<_$MetadataSnapshotImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MetadataSnapshotImplToJson(this);
  }
}

abstract class _MetadataSnapshot implements MetadataSnapshot {
  const factory _MetadataSnapshot({
    final String? title,
    final String? subtitle,
    @JsonKey(name: 'short_description') final String? shortDescription,
    final String? description,
    final String? keywords,
    @JsonKey(name: 'whats_new') final String? whatsNew,
    final String? version,
    @JsonKey(name: 'last_updated') final String? lastUpdated,
  }) = _$MetadataSnapshotImpl;

  factory _MetadataSnapshot.fromJson(Map<String, dynamic> json) =
      _$MetadataSnapshotImpl.fromJson;

  @override
  String? get title;
  @override
  String? get subtitle;
  @override
  @JsonKey(name: 'short_description')
  String? get shortDescription;
  @override
  String? get description;
  @override
  String? get keywords;
  @override
  @JsonKey(name: 'whats_new')
  String? get whatsNew;
  @override
  String? get version;
  @override
  @JsonKey(name: 'last_updated')
  String? get lastUpdated;

  /// Create a copy of MetadataSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataSnapshotImplCopyWith<_$MetadataSnapshotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MetadataHistorySummary _$MetadataHistorySummaryFromJson(
  Map<String, dynamic> json,
) {
  return _MetadataHistorySummary.fromJson(json);
}

/// @nodoc
mixin _$MetadataHistorySummary {
  @JsonKey(name: 'total_snapshots')
  int get totalSnapshots => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_changes')
  int get totalChanges => throw _privateConstructorUsedError;
  @JsonKey(name: 'changes_by_field')
  Map<String, int> get changesByField => throw _privateConstructorUsedError;
  @JsonKey(name: 'period_days')
  int get periodDays => throw _privateConstructorUsedError;

  /// Serializes this MetadataHistorySummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MetadataHistorySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetadataHistorySummaryCopyWith<MetadataHistorySummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetadataHistorySummaryCopyWith<$Res> {
  factory $MetadataHistorySummaryCopyWith(
    MetadataHistorySummary value,
    $Res Function(MetadataHistorySummary) then,
  ) = _$MetadataHistorySummaryCopyWithImpl<$Res, MetadataHistorySummary>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_snapshots') int totalSnapshots,
    @JsonKey(name: 'total_changes') int totalChanges,
    @JsonKey(name: 'changes_by_field') Map<String, int> changesByField,
    @JsonKey(name: 'period_days') int periodDays,
  });
}

/// @nodoc
class _$MetadataHistorySummaryCopyWithImpl<
  $Res,
  $Val extends MetadataHistorySummary
>
    implements $MetadataHistorySummaryCopyWith<$Res> {
  _$MetadataHistorySummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetadataHistorySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSnapshots = null,
    Object? totalChanges = null,
    Object? changesByField = null,
    Object? periodDays = null,
  }) {
    return _then(
      _value.copyWith(
            totalSnapshots: null == totalSnapshots
                ? _value.totalSnapshots
                : totalSnapshots // ignore: cast_nullable_to_non_nullable
                      as int,
            totalChanges: null == totalChanges
                ? _value.totalChanges
                : totalChanges // ignore: cast_nullable_to_non_nullable
                      as int,
            changesByField: null == changesByField
                ? _value.changesByField
                : changesByField // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            periodDays: null == periodDays
                ? _value.periodDays
                : periodDays // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MetadataHistorySummaryImplCopyWith<$Res>
    implements $MetadataHistorySummaryCopyWith<$Res> {
  factory _$$MetadataHistorySummaryImplCopyWith(
    _$MetadataHistorySummaryImpl value,
    $Res Function(_$MetadataHistorySummaryImpl) then,
  ) = __$$MetadataHistorySummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_snapshots') int totalSnapshots,
    @JsonKey(name: 'total_changes') int totalChanges,
    @JsonKey(name: 'changes_by_field') Map<String, int> changesByField,
    @JsonKey(name: 'period_days') int periodDays,
  });
}

/// @nodoc
class __$$MetadataHistorySummaryImplCopyWithImpl<$Res>
    extends
        _$MetadataHistorySummaryCopyWithImpl<$Res, _$MetadataHistorySummaryImpl>
    implements _$$MetadataHistorySummaryImplCopyWith<$Res> {
  __$$MetadataHistorySummaryImplCopyWithImpl(
    _$MetadataHistorySummaryImpl _value,
    $Res Function(_$MetadataHistorySummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataHistorySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSnapshots = null,
    Object? totalChanges = null,
    Object? changesByField = null,
    Object? periodDays = null,
  }) {
    return _then(
      _$MetadataHistorySummaryImpl(
        totalSnapshots: null == totalSnapshots
            ? _value.totalSnapshots
            : totalSnapshots // ignore: cast_nullable_to_non_nullable
                  as int,
        totalChanges: null == totalChanges
            ? _value.totalChanges
            : totalChanges // ignore: cast_nullable_to_non_nullable
                  as int,
        changesByField: null == changesByField
            ? _value._changesByField
            : changesByField // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        periodDays: null == periodDays
            ? _value.periodDays
            : periodDays // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MetadataHistorySummaryImpl implements _MetadataHistorySummary {
  const _$MetadataHistorySummaryImpl({
    @JsonKey(name: 'total_snapshots') required this.totalSnapshots,
    @JsonKey(name: 'total_changes') required this.totalChanges,
    @JsonKey(name: 'changes_by_field')
    required final Map<String, int> changesByField,
    @JsonKey(name: 'period_days') required this.periodDays,
  }) : _changesByField = changesByField;

  factory _$MetadataHistorySummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetadataHistorySummaryImplFromJson(json);

  @override
  @JsonKey(name: 'total_snapshots')
  final int totalSnapshots;
  @override
  @JsonKey(name: 'total_changes')
  final int totalChanges;
  final Map<String, int> _changesByField;
  @override
  @JsonKey(name: 'changes_by_field')
  Map<String, int> get changesByField {
    if (_changesByField is EqualUnmodifiableMapView) return _changesByField;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_changesByField);
  }

  @override
  @JsonKey(name: 'period_days')
  final int periodDays;

  @override
  String toString() {
    return 'MetadataHistorySummary(totalSnapshots: $totalSnapshots, totalChanges: $totalChanges, changesByField: $changesByField, periodDays: $periodDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataHistorySummaryImpl &&
            (identical(other.totalSnapshots, totalSnapshots) ||
                other.totalSnapshots == totalSnapshots) &&
            (identical(other.totalChanges, totalChanges) ||
                other.totalChanges == totalChanges) &&
            const DeepCollectionEquality().equals(
              other._changesByField,
              _changesByField,
            ) &&
            (identical(other.periodDays, periodDays) ||
                other.periodDays == periodDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalSnapshots,
    totalChanges,
    const DeepCollectionEquality().hash(_changesByField),
    periodDays,
  );

  /// Create a copy of MetadataHistorySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataHistorySummaryImplCopyWith<_$MetadataHistorySummaryImpl>
  get copyWith =>
      __$$MetadataHistorySummaryImplCopyWithImpl<_$MetadataHistorySummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MetadataHistorySummaryImplToJson(this);
  }
}

abstract class _MetadataHistorySummary implements MetadataHistorySummary {
  const factory _MetadataHistorySummary({
    @JsonKey(name: 'total_snapshots') required final int totalSnapshots,
    @JsonKey(name: 'total_changes') required final int totalChanges,
    @JsonKey(name: 'changes_by_field')
    required final Map<String, int> changesByField,
    @JsonKey(name: 'period_days') required final int periodDays,
  }) = _$MetadataHistorySummaryImpl;

  factory _MetadataHistorySummary.fromJson(Map<String, dynamic> json) =
      _$MetadataHistorySummaryImpl.fromJson;

  @override
  @JsonKey(name: 'total_snapshots')
  int get totalSnapshots;
  @override
  @JsonKey(name: 'total_changes')
  int get totalChanges;
  @override
  @JsonKey(name: 'changes_by_field')
  Map<String, int> get changesByField;
  @override
  @JsonKey(name: 'period_days')
  int get periodDays;

  /// Create a copy of MetadataHistorySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataHistorySummaryImplCopyWith<_$MetadataHistorySummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

MetadataTimelineEntry _$MetadataTimelineEntryFromJson(
  Map<String, dynamic> json,
) {
  return _MetadataTimelineEntry.fromJson(json);
}

/// @nodoc
mixin _$MetadataTimelineEntry {
  int get id => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String? get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_changes')
  bool get hasChanges => throw _privateConstructorUsedError;
  @JsonKey(name: 'changed_fields')
  List<String> get changedFields => throw _privateConstructorUsedError;
  List<MetadataChange>? get changes => throw _privateConstructorUsedError;

  /// Serializes this MetadataTimelineEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MetadataTimelineEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetadataTimelineEntryCopyWith<MetadataTimelineEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetadataTimelineEntryCopyWith<$Res> {
  factory $MetadataTimelineEntryCopyWith(
    MetadataTimelineEntry value,
    $Res Function(MetadataTimelineEntry) then,
  ) = _$MetadataTimelineEntryCopyWithImpl<$Res, MetadataTimelineEntry>;
  @useResult
  $Res call({
    int id,
    String date,
    String? version,
    @JsonKey(name: 'has_changes') bool hasChanges,
    @JsonKey(name: 'changed_fields') List<String> changedFields,
    List<MetadataChange>? changes,
  });
}

/// @nodoc
class _$MetadataTimelineEntryCopyWithImpl<
  $Res,
  $Val extends MetadataTimelineEntry
>
    implements $MetadataTimelineEntryCopyWith<$Res> {
  _$MetadataTimelineEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetadataTimelineEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? version = freezed,
    Object? hasChanges = null,
    Object? changedFields = null,
    Object? changes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            version: freezed == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String?,
            hasChanges: null == hasChanges
                ? _value.hasChanges
                : hasChanges // ignore: cast_nullable_to_non_nullable
                      as bool,
            changedFields: null == changedFields
                ? _value.changedFields
                : changedFields // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            changes: freezed == changes
                ? _value.changes
                : changes // ignore: cast_nullable_to_non_nullable
                      as List<MetadataChange>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MetadataTimelineEntryImplCopyWith<$Res>
    implements $MetadataTimelineEntryCopyWith<$Res> {
  factory _$$MetadataTimelineEntryImplCopyWith(
    _$MetadataTimelineEntryImpl value,
    $Res Function(_$MetadataTimelineEntryImpl) then,
  ) = __$$MetadataTimelineEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String date,
    String? version,
    @JsonKey(name: 'has_changes') bool hasChanges,
    @JsonKey(name: 'changed_fields') List<String> changedFields,
    List<MetadataChange>? changes,
  });
}

/// @nodoc
class __$$MetadataTimelineEntryImplCopyWithImpl<$Res>
    extends
        _$MetadataTimelineEntryCopyWithImpl<$Res, _$MetadataTimelineEntryImpl>
    implements _$$MetadataTimelineEntryImplCopyWith<$Res> {
  __$$MetadataTimelineEntryImplCopyWithImpl(
    _$MetadataTimelineEntryImpl _value,
    $Res Function(_$MetadataTimelineEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataTimelineEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? version = freezed,
    Object? hasChanges = null,
    Object? changedFields = null,
    Object? changes = freezed,
  }) {
    return _then(
      _$MetadataTimelineEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        version: freezed == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String?,
        hasChanges: null == hasChanges
            ? _value.hasChanges
            : hasChanges // ignore: cast_nullable_to_non_nullable
                  as bool,
        changedFields: null == changedFields
            ? _value._changedFields
            : changedFields // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        changes: freezed == changes
            ? _value._changes
            : changes // ignore: cast_nullable_to_non_nullable
                  as List<MetadataChange>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MetadataTimelineEntryImpl implements _MetadataTimelineEntry {
  const _$MetadataTimelineEntryImpl({
    required this.id,
    required this.date,
    this.version,
    @JsonKey(name: 'has_changes') required this.hasChanges,
    @JsonKey(name: 'changed_fields') required final List<String> changedFields,
    final List<MetadataChange>? changes,
  }) : _changedFields = changedFields,
       _changes = changes;

  factory _$MetadataTimelineEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetadataTimelineEntryImplFromJson(json);

  @override
  final int id;
  @override
  final String date;
  @override
  final String? version;
  @override
  @JsonKey(name: 'has_changes')
  final bool hasChanges;
  final List<String> _changedFields;
  @override
  @JsonKey(name: 'changed_fields')
  List<String> get changedFields {
    if (_changedFields is EqualUnmodifiableListView) return _changedFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_changedFields);
  }

  final List<MetadataChange>? _changes;
  @override
  List<MetadataChange>? get changes {
    final value = _changes;
    if (value == null) return null;
    if (_changes is EqualUnmodifiableListView) return _changes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'MetadataTimelineEntry(id: $id, date: $date, version: $version, hasChanges: $hasChanges, changedFields: $changedFields, changes: $changes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataTimelineEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.hasChanges, hasChanges) ||
                other.hasChanges == hasChanges) &&
            const DeepCollectionEquality().equals(
              other._changedFields,
              _changedFields,
            ) &&
            const DeepCollectionEquality().equals(other._changes, _changes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    date,
    version,
    hasChanges,
    const DeepCollectionEquality().hash(_changedFields),
    const DeepCollectionEquality().hash(_changes),
  );

  /// Create a copy of MetadataTimelineEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataTimelineEntryImplCopyWith<_$MetadataTimelineEntryImpl>
  get copyWith =>
      __$$MetadataTimelineEntryImplCopyWithImpl<_$MetadataTimelineEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MetadataTimelineEntryImplToJson(this);
  }
}

abstract class _MetadataTimelineEntry implements MetadataTimelineEntry {
  const factory _MetadataTimelineEntry({
    required final int id,
    required final String date,
    final String? version,
    @JsonKey(name: 'has_changes') required final bool hasChanges,
    @JsonKey(name: 'changed_fields') required final List<String> changedFields,
    final List<MetadataChange>? changes,
  }) = _$MetadataTimelineEntryImpl;

  factory _MetadataTimelineEntry.fromJson(Map<String, dynamic> json) =
      _$MetadataTimelineEntryImpl.fromJson;

  @override
  int get id;
  @override
  String get date;
  @override
  String? get version;
  @override
  @JsonKey(name: 'has_changes')
  bool get hasChanges;
  @override
  @JsonKey(name: 'changed_fields')
  List<String> get changedFields;
  @override
  List<MetadataChange>? get changes;

  /// Create a copy of MetadataTimelineEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataTimelineEntryImplCopyWith<_$MetadataTimelineEntryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

MetadataChange _$MetadataChangeFromJson(Map<String, dynamic> json) {
  return _MetadataChange.fromJson(json);
}

/// @nodoc
mixin _$MetadataChange {
  String get field => throw _privateConstructorUsedError;
  @JsonKey(name: 'old_value')
  String? get oldValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_value')
  String? get newValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'char_diff')
  int? get charDiff => throw _privateConstructorUsedError;
  @JsonKey(name: 'keyword_analysis')
  KeywordAnalysis? get keywordAnalysis => throw _privateConstructorUsedError;

  /// Serializes this MetadataChange to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MetadataChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetadataChangeCopyWith<MetadataChange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetadataChangeCopyWith<$Res> {
  factory $MetadataChangeCopyWith(
    MetadataChange value,
    $Res Function(MetadataChange) then,
  ) = _$MetadataChangeCopyWithImpl<$Res, MetadataChange>;
  @useResult
  $Res call({
    String field,
    @JsonKey(name: 'old_value') String? oldValue,
    @JsonKey(name: 'new_value') String? newValue,
    @JsonKey(name: 'char_diff') int? charDiff,
    @JsonKey(name: 'keyword_analysis') KeywordAnalysis? keywordAnalysis,
  });

  $KeywordAnalysisCopyWith<$Res>? get keywordAnalysis;
}

/// @nodoc
class _$MetadataChangeCopyWithImpl<$Res, $Val extends MetadataChange>
    implements $MetadataChangeCopyWith<$Res> {
  _$MetadataChangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetadataChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? oldValue = freezed,
    Object? newValue = freezed,
    Object? charDiff = freezed,
    Object? keywordAnalysis = freezed,
  }) {
    return _then(
      _value.copyWith(
            field: null == field
                ? _value.field
                : field // ignore: cast_nullable_to_non_nullable
                      as String,
            oldValue: freezed == oldValue
                ? _value.oldValue
                : oldValue // ignore: cast_nullable_to_non_nullable
                      as String?,
            newValue: freezed == newValue
                ? _value.newValue
                : newValue // ignore: cast_nullable_to_non_nullable
                      as String?,
            charDiff: freezed == charDiff
                ? _value.charDiff
                : charDiff // ignore: cast_nullable_to_non_nullable
                      as int?,
            keywordAnalysis: freezed == keywordAnalysis
                ? _value.keywordAnalysis
                : keywordAnalysis // ignore: cast_nullable_to_non_nullable
                      as KeywordAnalysis?,
          )
          as $Val,
    );
  }

  /// Create a copy of MetadataChange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $KeywordAnalysisCopyWith<$Res>? get keywordAnalysis {
    if (_value.keywordAnalysis == null) {
      return null;
    }

    return $KeywordAnalysisCopyWith<$Res>(_value.keywordAnalysis!, (value) {
      return _then(_value.copyWith(keywordAnalysis: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MetadataChangeImplCopyWith<$Res>
    implements $MetadataChangeCopyWith<$Res> {
  factory _$$MetadataChangeImplCopyWith(
    _$MetadataChangeImpl value,
    $Res Function(_$MetadataChangeImpl) then,
  ) = __$$MetadataChangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String field,
    @JsonKey(name: 'old_value') String? oldValue,
    @JsonKey(name: 'new_value') String? newValue,
    @JsonKey(name: 'char_diff') int? charDiff,
    @JsonKey(name: 'keyword_analysis') KeywordAnalysis? keywordAnalysis,
  });

  @override
  $KeywordAnalysisCopyWith<$Res>? get keywordAnalysis;
}

/// @nodoc
class __$$MetadataChangeImplCopyWithImpl<$Res>
    extends _$MetadataChangeCopyWithImpl<$Res, _$MetadataChangeImpl>
    implements _$$MetadataChangeImplCopyWith<$Res> {
  __$$MetadataChangeImplCopyWithImpl(
    _$MetadataChangeImpl _value,
    $Res Function(_$MetadataChangeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? oldValue = freezed,
    Object? newValue = freezed,
    Object? charDiff = freezed,
    Object? keywordAnalysis = freezed,
  }) {
    return _then(
      _$MetadataChangeImpl(
        field: null == field
            ? _value.field
            : field // ignore: cast_nullable_to_non_nullable
                  as String,
        oldValue: freezed == oldValue
            ? _value.oldValue
            : oldValue // ignore: cast_nullable_to_non_nullable
                  as String?,
        newValue: freezed == newValue
            ? _value.newValue
            : newValue // ignore: cast_nullable_to_non_nullable
                  as String?,
        charDiff: freezed == charDiff
            ? _value.charDiff
            : charDiff // ignore: cast_nullable_to_non_nullable
                  as int?,
        keywordAnalysis: freezed == keywordAnalysis
            ? _value.keywordAnalysis
            : keywordAnalysis // ignore: cast_nullable_to_non_nullable
                  as KeywordAnalysis?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MetadataChangeImpl implements _MetadataChange {
  const _$MetadataChangeImpl({
    required this.field,
    @JsonKey(name: 'old_value') this.oldValue,
    @JsonKey(name: 'new_value') this.newValue,
    @JsonKey(name: 'char_diff') this.charDiff,
    @JsonKey(name: 'keyword_analysis') this.keywordAnalysis,
  });

  factory _$MetadataChangeImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetadataChangeImplFromJson(json);

  @override
  final String field;
  @override
  @JsonKey(name: 'old_value')
  final String? oldValue;
  @override
  @JsonKey(name: 'new_value')
  final String? newValue;
  @override
  @JsonKey(name: 'char_diff')
  final int? charDiff;
  @override
  @JsonKey(name: 'keyword_analysis')
  final KeywordAnalysis? keywordAnalysis;

  @override
  String toString() {
    return 'MetadataChange(field: $field, oldValue: $oldValue, newValue: $newValue, charDiff: $charDiff, keywordAnalysis: $keywordAnalysis)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataChangeImpl &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.oldValue, oldValue) ||
                other.oldValue == oldValue) &&
            (identical(other.newValue, newValue) ||
                other.newValue == newValue) &&
            (identical(other.charDiff, charDiff) ||
                other.charDiff == charDiff) &&
            (identical(other.keywordAnalysis, keywordAnalysis) ||
                other.keywordAnalysis == keywordAnalysis));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    field,
    oldValue,
    newValue,
    charDiff,
    keywordAnalysis,
  );

  /// Create a copy of MetadataChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataChangeImplCopyWith<_$MetadataChangeImpl> get copyWith =>
      __$$MetadataChangeImplCopyWithImpl<_$MetadataChangeImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MetadataChangeImplToJson(this);
  }
}

abstract class _MetadataChange implements MetadataChange {
  const factory _MetadataChange({
    required final String field,
    @JsonKey(name: 'old_value') final String? oldValue,
    @JsonKey(name: 'new_value') final String? newValue,
    @JsonKey(name: 'char_diff') final int? charDiff,
    @JsonKey(name: 'keyword_analysis') final KeywordAnalysis? keywordAnalysis,
  }) = _$MetadataChangeImpl;

  factory _MetadataChange.fromJson(Map<String, dynamic> json) =
      _$MetadataChangeImpl.fromJson;

  @override
  String get field;
  @override
  @JsonKey(name: 'old_value')
  String? get oldValue;
  @override
  @JsonKey(name: 'new_value')
  String? get newValue;
  @override
  @JsonKey(name: 'char_diff')
  int? get charDiff;
  @override
  @JsonKey(name: 'keyword_analysis')
  KeywordAnalysis? get keywordAnalysis;

  /// Create a copy of MetadataChange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataChangeImplCopyWith<_$MetadataChangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KeywordAnalysis _$KeywordAnalysisFromJson(Map<String, dynamic> json) {
  return _KeywordAnalysis.fromJson(json);
}

/// @nodoc
mixin _$KeywordAnalysis {
  List<String> get added => throw _privateConstructorUsedError;
  List<String> get removed => throw _privateConstructorUsedError;
  List<String> get unchanged => throw _privateConstructorUsedError;

  /// Serializes this KeywordAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KeywordAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KeywordAnalysisCopyWith<KeywordAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KeywordAnalysisCopyWith<$Res> {
  factory $KeywordAnalysisCopyWith(
    KeywordAnalysis value,
    $Res Function(KeywordAnalysis) then,
  ) = _$KeywordAnalysisCopyWithImpl<$Res, KeywordAnalysis>;
  @useResult
  $Res call({List<String> added, List<String> removed, List<String> unchanged});
}

/// @nodoc
class _$KeywordAnalysisCopyWithImpl<$Res, $Val extends KeywordAnalysis>
    implements $KeywordAnalysisCopyWith<$Res> {
  _$KeywordAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KeywordAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? added = null,
    Object? removed = null,
    Object? unchanged = null,
  }) {
    return _then(
      _value.copyWith(
            added: null == added
                ? _value.added
                : added // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            removed: null == removed
                ? _value.removed
                : removed // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            unchanged: null == unchanged
                ? _value.unchanged
                : unchanged // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KeywordAnalysisImplCopyWith<$Res>
    implements $KeywordAnalysisCopyWith<$Res> {
  factory _$$KeywordAnalysisImplCopyWith(
    _$KeywordAnalysisImpl value,
    $Res Function(_$KeywordAnalysisImpl) then,
  ) = __$$KeywordAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> added, List<String> removed, List<String> unchanged});
}

/// @nodoc
class __$$KeywordAnalysisImplCopyWithImpl<$Res>
    extends _$KeywordAnalysisCopyWithImpl<$Res, _$KeywordAnalysisImpl>
    implements _$$KeywordAnalysisImplCopyWith<$Res> {
  __$$KeywordAnalysisImplCopyWithImpl(
    _$KeywordAnalysisImpl _value,
    $Res Function(_$KeywordAnalysisImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KeywordAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? added = null,
    Object? removed = null,
    Object? unchanged = null,
  }) {
    return _then(
      _$KeywordAnalysisImpl(
        added: null == added
            ? _value._added
            : added // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        removed: null == removed
            ? _value._removed
            : removed // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        unchanged: null == unchanged
            ? _value._unchanged
            : unchanged // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KeywordAnalysisImpl implements _KeywordAnalysis {
  const _$KeywordAnalysisImpl({
    required final List<String> added,
    required final List<String> removed,
    required final List<String> unchanged,
  }) : _added = added,
       _removed = removed,
       _unchanged = unchanged;

  factory _$KeywordAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$KeywordAnalysisImplFromJson(json);

  final List<String> _added;
  @override
  List<String> get added {
    if (_added is EqualUnmodifiableListView) return _added;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_added);
  }

  final List<String> _removed;
  @override
  List<String> get removed {
    if (_removed is EqualUnmodifiableListView) return _removed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_removed);
  }

  final List<String> _unchanged;
  @override
  List<String> get unchanged {
    if (_unchanged is EqualUnmodifiableListView) return _unchanged;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unchanged);
  }

  @override
  String toString() {
    return 'KeywordAnalysis(added: $added, removed: $removed, unchanged: $unchanged)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KeywordAnalysisImpl &&
            const DeepCollectionEquality().equals(other._added, _added) &&
            const DeepCollectionEquality().equals(other._removed, _removed) &&
            const DeepCollectionEquality().equals(
              other._unchanged,
              _unchanged,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_added),
    const DeepCollectionEquality().hash(_removed),
    const DeepCollectionEquality().hash(_unchanged),
  );

  /// Create a copy of KeywordAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KeywordAnalysisImplCopyWith<_$KeywordAnalysisImpl> get copyWith =>
      __$$KeywordAnalysisImplCopyWithImpl<_$KeywordAnalysisImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$KeywordAnalysisImplToJson(this);
  }
}

abstract class _KeywordAnalysis implements KeywordAnalysis {
  const factory _KeywordAnalysis({
    required final List<String> added,
    required final List<String> removed,
    required final List<String> unchanged,
  }) = _$KeywordAnalysisImpl;

  factory _KeywordAnalysis.fromJson(Map<String, dynamic> json) =
      _$KeywordAnalysisImpl.fromJson;

  @override
  List<String> get added;
  @override
  List<String> get removed;
  @override
  List<String> get unchanged;

  /// Create a copy of KeywordAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KeywordAnalysisImplCopyWith<_$KeywordAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MetadataInsightsResponse _$MetadataInsightsResponseFromJson(
  Map<String, dynamic> json,
) {
  return _MetadataInsightsResponse.fromJson(json);
}

/// @nodoc
mixin _$MetadataInsightsResponse {
  CompetitorBasicInfo get competitor => throw _privateConstructorUsedError;
  MetadataInsights? get insights => throw _privateConstructorUsedError;
  @JsonKey(name: 'analyzed_changes')
  int get analyzedChanges => throw _privateConstructorUsedError;
  @JsonKey(name: 'period_days')
  int get periodDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'generated_at')
  String get generatedAt => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this MetadataInsightsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MetadataInsightsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetadataInsightsResponseCopyWith<MetadataInsightsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetadataInsightsResponseCopyWith<$Res> {
  factory $MetadataInsightsResponseCopyWith(
    MetadataInsightsResponse value,
    $Res Function(MetadataInsightsResponse) then,
  ) = _$MetadataInsightsResponseCopyWithImpl<$Res, MetadataInsightsResponse>;
  @useResult
  $Res call({
    CompetitorBasicInfo competitor,
    MetadataInsights? insights,
    @JsonKey(name: 'analyzed_changes') int analyzedChanges,
    @JsonKey(name: 'period_days') int periodDays,
    @JsonKey(name: 'generated_at') String generatedAt,
    String? message,
    String? error,
  });

  $CompetitorBasicInfoCopyWith<$Res> get competitor;
  $MetadataInsightsCopyWith<$Res>? get insights;
}

/// @nodoc
class _$MetadataInsightsResponseCopyWithImpl<
  $Res,
  $Val extends MetadataInsightsResponse
>
    implements $MetadataInsightsResponseCopyWith<$Res> {
  _$MetadataInsightsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetadataInsightsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? competitor = null,
    Object? insights = freezed,
    Object? analyzedChanges = null,
    Object? periodDays = null,
    Object? generatedAt = null,
    Object? message = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            competitor: null == competitor
                ? _value.competitor
                : competitor // ignore: cast_nullable_to_non_nullable
                      as CompetitorBasicInfo,
            insights: freezed == insights
                ? _value.insights
                : insights // ignore: cast_nullable_to_non_nullable
                      as MetadataInsights?,
            analyzedChanges: null == analyzedChanges
                ? _value.analyzedChanges
                : analyzedChanges // ignore: cast_nullable_to_non_nullable
                      as int,
            periodDays: null == periodDays
                ? _value.periodDays
                : periodDays // ignore: cast_nullable_to_non_nullable
                      as int,
            generatedAt: null == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of MetadataInsightsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompetitorBasicInfoCopyWith<$Res> get competitor {
    return $CompetitorBasicInfoCopyWith<$Res>(_value.competitor, (value) {
      return _then(_value.copyWith(competitor: value) as $Val);
    });
  }

  /// Create a copy of MetadataInsightsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetadataInsightsCopyWith<$Res>? get insights {
    if (_value.insights == null) {
      return null;
    }

    return $MetadataInsightsCopyWith<$Res>(_value.insights!, (value) {
      return _then(_value.copyWith(insights: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MetadataInsightsResponseImplCopyWith<$Res>
    implements $MetadataInsightsResponseCopyWith<$Res> {
  factory _$$MetadataInsightsResponseImplCopyWith(
    _$MetadataInsightsResponseImpl value,
    $Res Function(_$MetadataInsightsResponseImpl) then,
  ) = __$$MetadataInsightsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    CompetitorBasicInfo competitor,
    MetadataInsights? insights,
    @JsonKey(name: 'analyzed_changes') int analyzedChanges,
    @JsonKey(name: 'period_days') int periodDays,
    @JsonKey(name: 'generated_at') String generatedAt,
    String? message,
    String? error,
  });

  @override
  $CompetitorBasicInfoCopyWith<$Res> get competitor;
  @override
  $MetadataInsightsCopyWith<$Res>? get insights;
}

/// @nodoc
class __$$MetadataInsightsResponseImplCopyWithImpl<$Res>
    extends
        _$MetadataInsightsResponseCopyWithImpl<
          $Res,
          _$MetadataInsightsResponseImpl
        >
    implements _$$MetadataInsightsResponseImplCopyWith<$Res> {
  __$$MetadataInsightsResponseImplCopyWithImpl(
    _$MetadataInsightsResponseImpl _value,
    $Res Function(_$MetadataInsightsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataInsightsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? competitor = null,
    Object? insights = freezed,
    Object? analyzedChanges = null,
    Object? periodDays = null,
    Object? generatedAt = null,
    Object? message = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _$MetadataInsightsResponseImpl(
        competitor: null == competitor
            ? _value.competitor
            : competitor // ignore: cast_nullable_to_non_nullable
                  as CompetitorBasicInfo,
        insights: freezed == insights
            ? _value.insights
            : insights // ignore: cast_nullable_to_non_nullable
                  as MetadataInsights?,
        analyzedChanges: null == analyzedChanges
            ? _value.analyzedChanges
            : analyzedChanges // ignore: cast_nullable_to_non_nullable
                  as int,
        periodDays: null == periodDays
            ? _value.periodDays
            : periodDays // ignore: cast_nullable_to_non_nullable
                  as int,
        generatedAt: null == generatedAt
            ? _value.generatedAt
            : generatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MetadataInsightsResponseImpl implements _MetadataInsightsResponse {
  const _$MetadataInsightsResponseImpl({
    required this.competitor,
    this.insights,
    @JsonKey(name: 'analyzed_changes') required this.analyzedChanges,
    @JsonKey(name: 'period_days') required this.periodDays,
    @JsonKey(name: 'generated_at') required this.generatedAt,
    this.message,
    this.error,
  });

  factory _$MetadataInsightsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetadataInsightsResponseImplFromJson(json);

  @override
  final CompetitorBasicInfo competitor;
  @override
  final MetadataInsights? insights;
  @override
  @JsonKey(name: 'analyzed_changes')
  final int analyzedChanges;
  @override
  @JsonKey(name: 'period_days')
  final int periodDays;
  @override
  @JsonKey(name: 'generated_at')
  final String generatedAt;
  @override
  final String? message;
  @override
  final String? error;

  @override
  String toString() {
    return 'MetadataInsightsResponse(competitor: $competitor, insights: $insights, analyzedChanges: $analyzedChanges, periodDays: $periodDays, generatedAt: $generatedAt, message: $message, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataInsightsResponseImpl &&
            (identical(other.competitor, competitor) ||
                other.competitor == competitor) &&
            (identical(other.insights, insights) ||
                other.insights == insights) &&
            (identical(other.analyzedChanges, analyzedChanges) ||
                other.analyzedChanges == analyzedChanges) &&
            (identical(other.periodDays, periodDays) ||
                other.periodDays == periodDays) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    competitor,
    insights,
    analyzedChanges,
    periodDays,
    generatedAt,
    message,
    error,
  );

  /// Create a copy of MetadataInsightsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataInsightsResponseImplCopyWith<_$MetadataInsightsResponseImpl>
  get copyWith =>
      __$$MetadataInsightsResponseImplCopyWithImpl<
        _$MetadataInsightsResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetadataInsightsResponseImplToJson(this);
  }
}

abstract class _MetadataInsightsResponse implements MetadataInsightsResponse {
  const factory _MetadataInsightsResponse({
    required final CompetitorBasicInfo competitor,
    final MetadataInsights? insights,
    @JsonKey(name: 'analyzed_changes') required final int analyzedChanges,
    @JsonKey(name: 'period_days') required final int periodDays,
    @JsonKey(name: 'generated_at') required final String generatedAt,
    final String? message,
    final String? error,
  }) = _$MetadataInsightsResponseImpl;

  factory _MetadataInsightsResponse.fromJson(Map<String, dynamic> json) =
      _$MetadataInsightsResponseImpl.fromJson;

  @override
  CompetitorBasicInfo get competitor;
  @override
  MetadataInsights? get insights;
  @override
  @JsonKey(name: 'analyzed_changes')
  int get analyzedChanges;
  @override
  @JsonKey(name: 'period_days')
  int get periodDays;
  @override
  @JsonKey(name: 'generated_at')
  String get generatedAt;
  @override
  String? get message;
  @override
  String? get error;

  /// Create a copy of MetadataInsightsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataInsightsResponseImplCopyWith<_$MetadataInsightsResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CompetitorBasicInfo _$CompetitorBasicInfoFromJson(Map<String, dynamic> json) {
  return _CompetitorBasicInfo.fromJson(json);
}

/// @nodoc
mixin _$CompetitorBasicInfo {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this CompetitorBasicInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompetitorBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompetitorBasicInfoCopyWith<CompetitorBasicInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompetitorBasicInfoCopyWith<$Res> {
  factory $CompetitorBasicInfoCopyWith(
    CompetitorBasicInfo value,
    $Res Function(CompetitorBasicInfo) then,
  ) = _$CompetitorBasicInfoCopyWithImpl<$Res, CompetitorBasicInfo>;
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class _$CompetitorBasicInfoCopyWithImpl<$Res, $Val extends CompetitorBasicInfo>
    implements $CompetitorBasicInfoCopyWith<$Res> {
  _$CompetitorBasicInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompetitorBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CompetitorBasicInfoImplCopyWith<$Res>
    implements $CompetitorBasicInfoCopyWith<$Res> {
  factory _$$CompetitorBasicInfoImplCopyWith(
    _$CompetitorBasicInfoImpl value,
    $Res Function(_$CompetitorBasicInfoImpl) then,
  ) = __$$CompetitorBasicInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class __$$CompetitorBasicInfoImplCopyWithImpl<$Res>
    extends _$CompetitorBasicInfoCopyWithImpl<$Res, _$CompetitorBasicInfoImpl>
    implements _$$CompetitorBasicInfoImplCopyWith<$Res> {
  __$$CompetitorBasicInfoImplCopyWithImpl(
    _$CompetitorBasicInfoImpl _value,
    $Res Function(_$CompetitorBasicInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompetitorBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$CompetitorBasicInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CompetitorBasicInfoImpl implements _CompetitorBasicInfo {
  const _$CompetitorBasicInfoImpl({required this.id, required this.name});

  factory _$CompetitorBasicInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompetitorBasicInfoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'CompetitorBasicInfo(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompetitorBasicInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of CompetitorBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompetitorBasicInfoImplCopyWith<_$CompetitorBasicInfoImpl> get copyWith =>
      __$$CompetitorBasicInfoImplCopyWithImpl<_$CompetitorBasicInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CompetitorBasicInfoImplToJson(this);
  }
}

abstract class _CompetitorBasicInfo implements CompetitorBasicInfo {
  const factory _CompetitorBasicInfo({
    required final int id,
    required final String name,
  }) = _$CompetitorBasicInfoImpl;

  factory _CompetitorBasicInfo.fromJson(Map<String, dynamic> json) =
      _$CompetitorBasicInfoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;

  /// Create a copy of CompetitorBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompetitorBasicInfoImplCopyWith<_$CompetitorBasicInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MetadataInsights _$MetadataInsightsFromJson(Map<String, dynamic> json) {
  return _MetadataInsights.fromJson(json);
}

/// @nodoc
mixin _$MetadataInsights {
  @JsonKey(name: 'strategy_summary')
  String get strategySummary => throw _privateConstructorUsedError;
  @JsonKey(name: 'key_findings')
  List<String> get keyFindings => throw _privateConstructorUsedError;
  @JsonKey(name: 'keyword_focus')
  List<String> get keywordFocus => throw _privateConstructorUsedError;
  List<String> get recommendations => throw _privateConstructorUsedError;
  String get trend => throw _privateConstructorUsedError;

  /// Serializes this MetadataInsights to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MetadataInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetadataInsightsCopyWith<MetadataInsights> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetadataInsightsCopyWith<$Res> {
  factory $MetadataInsightsCopyWith(
    MetadataInsights value,
    $Res Function(MetadataInsights) then,
  ) = _$MetadataInsightsCopyWithImpl<$Res, MetadataInsights>;
  @useResult
  $Res call({
    @JsonKey(name: 'strategy_summary') String strategySummary,
    @JsonKey(name: 'key_findings') List<String> keyFindings,
    @JsonKey(name: 'keyword_focus') List<String> keywordFocus,
    List<String> recommendations,
    String trend,
  });
}

/// @nodoc
class _$MetadataInsightsCopyWithImpl<$Res, $Val extends MetadataInsights>
    implements $MetadataInsightsCopyWith<$Res> {
  _$MetadataInsightsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetadataInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? strategySummary = null,
    Object? keyFindings = null,
    Object? keywordFocus = null,
    Object? recommendations = null,
    Object? trend = null,
  }) {
    return _then(
      _value.copyWith(
            strategySummary: null == strategySummary
                ? _value.strategySummary
                : strategySummary // ignore: cast_nullable_to_non_nullable
                      as String,
            keyFindings: null == keyFindings
                ? _value.keyFindings
                : keyFindings // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            keywordFocus: null == keywordFocus
                ? _value.keywordFocus
                : keywordFocus // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            recommendations: null == recommendations
                ? _value.recommendations
                : recommendations // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            trend: null == trend
                ? _value.trend
                : trend // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MetadataInsightsImplCopyWith<$Res>
    implements $MetadataInsightsCopyWith<$Res> {
  factory _$$MetadataInsightsImplCopyWith(
    _$MetadataInsightsImpl value,
    $Res Function(_$MetadataInsightsImpl) then,
  ) = __$$MetadataInsightsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'strategy_summary') String strategySummary,
    @JsonKey(name: 'key_findings') List<String> keyFindings,
    @JsonKey(name: 'keyword_focus') List<String> keywordFocus,
    List<String> recommendations,
    String trend,
  });
}

/// @nodoc
class __$$MetadataInsightsImplCopyWithImpl<$Res>
    extends _$MetadataInsightsCopyWithImpl<$Res, _$MetadataInsightsImpl>
    implements _$$MetadataInsightsImplCopyWith<$Res> {
  __$$MetadataInsightsImplCopyWithImpl(
    _$MetadataInsightsImpl _value,
    $Res Function(_$MetadataInsightsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? strategySummary = null,
    Object? keyFindings = null,
    Object? keywordFocus = null,
    Object? recommendations = null,
    Object? trend = null,
  }) {
    return _then(
      _$MetadataInsightsImpl(
        strategySummary: null == strategySummary
            ? _value.strategySummary
            : strategySummary // ignore: cast_nullable_to_non_nullable
                  as String,
        keyFindings: null == keyFindings
            ? _value._keyFindings
            : keyFindings // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        keywordFocus: null == keywordFocus
            ? _value._keywordFocus
            : keywordFocus // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        recommendations: null == recommendations
            ? _value._recommendations
            : recommendations // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        trend: null == trend
            ? _value.trend
            : trend // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MetadataInsightsImpl implements _MetadataInsights {
  const _$MetadataInsightsImpl({
    @JsonKey(name: 'strategy_summary') required this.strategySummary,
    @JsonKey(name: 'key_findings') required final List<String> keyFindings,
    @JsonKey(name: 'keyword_focus') required final List<String> keywordFocus,
    required final List<String> recommendations,
    required this.trend,
  }) : _keyFindings = keyFindings,
       _keywordFocus = keywordFocus,
       _recommendations = recommendations;

  factory _$MetadataInsightsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetadataInsightsImplFromJson(json);

  @override
  @JsonKey(name: 'strategy_summary')
  final String strategySummary;
  final List<String> _keyFindings;
  @override
  @JsonKey(name: 'key_findings')
  List<String> get keyFindings {
    if (_keyFindings is EqualUnmodifiableListView) return _keyFindings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keyFindings);
  }

  final List<String> _keywordFocus;
  @override
  @JsonKey(name: 'keyword_focus')
  List<String> get keywordFocus {
    if (_keywordFocus is EqualUnmodifiableListView) return _keywordFocus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywordFocus);
  }

  final List<String> _recommendations;
  @override
  List<String> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  @override
  final String trend;

  @override
  String toString() {
    return 'MetadataInsights(strategySummary: $strategySummary, keyFindings: $keyFindings, keywordFocus: $keywordFocus, recommendations: $recommendations, trend: $trend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataInsightsImpl &&
            (identical(other.strategySummary, strategySummary) ||
                other.strategySummary == strategySummary) &&
            const DeepCollectionEquality().equals(
              other._keyFindings,
              _keyFindings,
            ) &&
            const DeepCollectionEquality().equals(
              other._keywordFocus,
              _keywordFocus,
            ) &&
            const DeepCollectionEquality().equals(
              other._recommendations,
              _recommendations,
            ) &&
            (identical(other.trend, trend) || other.trend == trend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    strategySummary,
    const DeepCollectionEquality().hash(_keyFindings),
    const DeepCollectionEquality().hash(_keywordFocus),
    const DeepCollectionEquality().hash(_recommendations),
    trend,
  );

  /// Create a copy of MetadataInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataInsightsImplCopyWith<_$MetadataInsightsImpl> get copyWith =>
      __$$MetadataInsightsImplCopyWithImpl<_$MetadataInsightsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MetadataInsightsImplToJson(this);
  }
}

abstract class _MetadataInsights implements MetadataInsights {
  const factory _MetadataInsights({
    @JsonKey(name: 'strategy_summary') required final String strategySummary,
    @JsonKey(name: 'key_findings') required final List<String> keyFindings,
    @JsonKey(name: 'keyword_focus') required final List<String> keywordFocus,
    required final List<String> recommendations,
    required final String trend,
  }) = _$MetadataInsightsImpl;

  factory _MetadataInsights.fromJson(Map<String, dynamic> json) =
      _$MetadataInsightsImpl.fromJson;

  @override
  @JsonKey(name: 'strategy_summary')
  String get strategySummary;
  @override
  @JsonKey(name: 'key_findings')
  List<String> get keyFindings;
  @override
  @JsonKey(name: 'keyword_focus')
  List<String> get keywordFocus;
  @override
  List<String> get recommendations;
  @override
  String get trend;

  /// Create a copy of MetadataInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataInsightsImplCopyWith<_$MetadataInsightsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
