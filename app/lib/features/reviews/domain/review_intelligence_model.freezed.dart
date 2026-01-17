// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_intelligence_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReviewIntelligence _$ReviewIntelligenceFromJson(Map<String, dynamic> json) {
  return _ReviewIntelligence.fromJson(json);
}

/// @nodoc
mixin _$ReviewIntelligence {
  @JsonKey(name: 'feature_requests')
  List<InsightItem> get featureRequests => throw _privateConstructorUsedError;
  @JsonKey(name: 'bug_reports')
  List<InsightItem> get bugReports => throw _privateConstructorUsedError;
  @JsonKey(name: 'version_sentiment')
  List<VersionSentiment> get versionSentiment =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'version_insight')
  String? get versionInsight => throw _privateConstructorUsedError;
  ReviewIntelligenceSummary get summary => throw _privateConstructorUsedError;

  /// Serializes this ReviewIntelligence to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewIntelligenceCopyWith<ReviewIntelligence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewIntelligenceCopyWith<$Res> {
  factory $ReviewIntelligenceCopyWith(
    ReviewIntelligence value,
    $Res Function(ReviewIntelligence) then,
  ) = _$ReviewIntelligenceCopyWithImpl<$Res, ReviewIntelligence>;
  @useResult
  $Res call({
    @JsonKey(name: 'feature_requests') List<InsightItem> featureRequests,
    @JsonKey(name: 'bug_reports') List<InsightItem> bugReports,
    @JsonKey(name: 'version_sentiment') List<VersionSentiment> versionSentiment,
    @JsonKey(name: 'version_insight') String? versionInsight,
    ReviewIntelligenceSummary summary,
  });

  $ReviewIntelligenceSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$ReviewIntelligenceCopyWithImpl<$Res, $Val extends ReviewIntelligence>
    implements $ReviewIntelligenceCopyWith<$Res> {
  _$ReviewIntelligenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? featureRequests = null,
    Object? bugReports = null,
    Object? versionSentiment = null,
    Object? versionInsight = freezed,
    Object? summary = null,
  }) {
    return _then(
      _value.copyWith(
            featureRequests: null == featureRequests
                ? _value.featureRequests
                : featureRequests // ignore: cast_nullable_to_non_nullable
                      as List<InsightItem>,
            bugReports: null == bugReports
                ? _value.bugReports
                : bugReports // ignore: cast_nullable_to_non_nullable
                      as List<InsightItem>,
            versionSentiment: null == versionSentiment
                ? _value.versionSentiment
                : versionSentiment // ignore: cast_nullable_to_non_nullable
                      as List<VersionSentiment>,
            versionInsight: freezed == versionInsight
                ? _value.versionInsight
                : versionInsight // ignore: cast_nullable_to_non_nullable
                      as String?,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as ReviewIntelligenceSummary,
          )
          as $Val,
    );
  }

  /// Create a copy of ReviewIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReviewIntelligenceSummaryCopyWith<$Res> get summary {
    return $ReviewIntelligenceSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReviewIntelligenceImplCopyWith<$Res>
    implements $ReviewIntelligenceCopyWith<$Res> {
  factory _$$ReviewIntelligenceImplCopyWith(
    _$ReviewIntelligenceImpl value,
    $Res Function(_$ReviewIntelligenceImpl) then,
  ) = __$$ReviewIntelligenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'feature_requests') List<InsightItem> featureRequests,
    @JsonKey(name: 'bug_reports') List<InsightItem> bugReports,
    @JsonKey(name: 'version_sentiment') List<VersionSentiment> versionSentiment,
    @JsonKey(name: 'version_insight') String? versionInsight,
    ReviewIntelligenceSummary summary,
  });

  @override
  $ReviewIntelligenceSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$ReviewIntelligenceImplCopyWithImpl<$Res>
    extends _$ReviewIntelligenceCopyWithImpl<$Res, _$ReviewIntelligenceImpl>
    implements _$$ReviewIntelligenceImplCopyWith<$Res> {
  __$$ReviewIntelligenceImplCopyWithImpl(
    _$ReviewIntelligenceImpl _value,
    $Res Function(_$ReviewIntelligenceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? featureRequests = null,
    Object? bugReports = null,
    Object? versionSentiment = null,
    Object? versionInsight = freezed,
    Object? summary = null,
  }) {
    return _then(
      _$ReviewIntelligenceImpl(
        featureRequests: null == featureRequests
            ? _value._featureRequests
            : featureRequests // ignore: cast_nullable_to_non_nullable
                  as List<InsightItem>,
        bugReports: null == bugReports
            ? _value._bugReports
            : bugReports // ignore: cast_nullable_to_non_nullable
                  as List<InsightItem>,
        versionSentiment: null == versionSentiment
            ? _value._versionSentiment
            : versionSentiment // ignore: cast_nullable_to_non_nullable
                  as List<VersionSentiment>,
        versionInsight: freezed == versionInsight
            ? _value.versionInsight
            : versionInsight // ignore: cast_nullable_to_non_nullable
                  as String?,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as ReviewIntelligenceSummary,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewIntelligenceImpl implements _ReviewIntelligence {
  const _$ReviewIntelligenceImpl({
    @JsonKey(name: 'feature_requests')
    required final List<InsightItem> featureRequests,
    @JsonKey(name: 'bug_reports') required final List<InsightItem> bugReports,
    @JsonKey(name: 'version_sentiment')
    required final List<VersionSentiment> versionSentiment,
    @JsonKey(name: 'version_insight') this.versionInsight,
    required this.summary,
  }) : _featureRequests = featureRequests,
       _bugReports = bugReports,
       _versionSentiment = versionSentiment;

  factory _$ReviewIntelligenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewIntelligenceImplFromJson(json);

  final List<InsightItem> _featureRequests;
  @override
  @JsonKey(name: 'feature_requests')
  List<InsightItem> get featureRequests {
    if (_featureRequests is EqualUnmodifiableListView) return _featureRequests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_featureRequests);
  }

  final List<InsightItem> _bugReports;
  @override
  @JsonKey(name: 'bug_reports')
  List<InsightItem> get bugReports {
    if (_bugReports is EqualUnmodifiableListView) return _bugReports;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bugReports);
  }

  final List<VersionSentiment> _versionSentiment;
  @override
  @JsonKey(name: 'version_sentiment')
  List<VersionSentiment> get versionSentiment {
    if (_versionSentiment is EqualUnmodifiableListView)
      return _versionSentiment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_versionSentiment);
  }

  @override
  @JsonKey(name: 'version_insight')
  final String? versionInsight;
  @override
  final ReviewIntelligenceSummary summary;

  @override
  String toString() {
    return 'ReviewIntelligence(featureRequests: $featureRequests, bugReports: $bugReports, versionSentiment: $versionSentiment, versionInsight: $versionInsight, summary: $summary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewIntelligenceImpl &&
            const DeepCollectionEquality().equals(
              other._featureRequests,
              _featureRequests,
            ) &&
            const DeepCollectionEquality().equals(
              other._bugReports,
              _bugReports,
            ) &&
            const DeepCollectionEquality().equals(
              other._versionSentiment,
              _versionSentiment,
            ) &&
            (identical(other.versionInsight, versionInsight) ||
                other.versionInsight == versionInsight) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_featureRequests),
    const DeepCollectionEquality().hash(_bugReports),
    const DeepCollectionEquality().hash(_versionSentiment),
    versionInsight,
    summary,
  );

  /// Create a copy of ReviewIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewIntelligenceImplCopyWith<_$ReviewIntelligenceImpl> get copyWith =>
      __$$ReviewIntelligenceImplCopyWithImpl<_$ReviewIntelligenceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewIntelligenceImplToJson(this);
  }
}

abstract class _ReviewIntelligence implements ReviewIntelligence {
  const factory _ReviewIntelligence({
    @JsonKey(name: 'feature_requests')
    required final List<InsightItem> featureRequests,
    @JsonKey(name: 'bug_reports') required final List<InsightItem> bugReports,
    @JsonKey(name: 'version_sentiment')
    required final List<VersionSentiment> versionSentiment,
    @JsonKey(name: 'version_insight') final String? versionInsight,
    required final ReviewIntelligenceSummary summary,
  }) = _$ReviewIntelligenceImpl;

  factory _ReviewIntelligence.fromJson(Map<String, dynamic> json) =
      _$ReviewIntelligenceImpl.fromJson;

  @override
  @JsonKey(name: 'feature_requests')
  List<InsightItem> get featureRequests;
  @override
  @JsonKey(name: 'bug_reports')
  List<InsightItem> get bugReports;
  @override
  @JsonKey(name: 'version_sentiment')
  List<VersionSentiment> get versionSentiment;
  @override
  @JsonKey(name: 'version_insight')
  String? get versionInsight;
  @override
  ReviewIntelligenceSummary get summary;

  /// Create a copy of ReviewIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewIntelligenceImplCopyWith<_$ReviewIntelligenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InsightItem _$InsightItemFromJson(Map<String, dynamic> json) {
  return _InsightItem.fromJson(json);
}

/// @nodoc
mixin _$InsightItem {
  int get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String> get keywords => throw _privateConstructorUsedError;
  @JsonKey(name: 'mention_count')
  int get mentionCount => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get platform => throw _privateConstructorUsedError;
  @JsonKey(name: 'affected_version')
  String? get affectedVersion => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_mentioned_at')
  DateTime get firstMentionedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_mentioned_at')
  DateTime get lastMentionedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this InsightItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InsightItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsightItemCopyWith<InsightItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightItemCopyWith<$Res> {
  factory $InsightItemCopyWith(
    InsightItem value,
    $Res Function(InsightItem) then,
  ) = _$InsightItemCopyWithImpl<$Res, InsightItem>;
  @useResult
  $Res call({
    int id,
    String type,
    String title,
    String? description,
    List<String> keywords,
    @JsonKey(name: 'mention_count') int mentionCount,
    String priority,
    String status,
    String? platform,
    @JsonKey(name: 'affected_version') String? affectedVersion,
    @JsonKey(name: 'first_mentioned_at') DateTime firstMentionedAt,
    @JsonKey(name: 'last_mentioned_at') DateTime lastMentionedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$InsightItemCopyWithImpl<$Res, $Val extends InsightItem>
    implements $InsightItemCopyWith<$Res> {
  _$InsightItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InsightItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? description = freezed,
    Object? keywords = null,
    Object? mentionCount = null,
    Object? priority = null,
    Object? status = null,
    Object? platform = freezed,
    Object? affectedVersion = freezed,
    Object? firstMentionedAt = null,
    Object? lastMentionedAt = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            keywords: null == keywords
                ? _value.keywords
                : keywords // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            mentionCount: null == mentionCount
                ? _value.mentionCount
                : mentionCount // ignore: cast_nullable_to_non_nullable
                      as int,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            platform: freezed == platform
                ? _value.platform
                : platform // ignore: cast_nullable_to_non_nullable
                      as String?,
            affectedVersion: freezed == affectedVersion
                ? _value.affectedVersion
                : affectedVersion // ignore: cast_nullable_to_non_nullable
                      as String?,
            firstMentionedAt: null == firstMentionedAt
                ? _value.firstMentionedAt
                : firstMentionedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastMentionedAt: null == lastMentionedAt
                ? _value.lastMentionedAt
                : lastMentionedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InsightItemImplCopyWith<$Res>
    implements $InsightItemCopyWith<$Res> {
  factory _$$InsightItemImplCopyWith(
    _$InsightItemImpl value,
    $Res Function(_$InsightItemImpl) then,
  ) = __$$InsightItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String type,
    String title,
    String? description,
    List<String> keywords,
    @JsonKey(name: 'mention_count') int mentionCount,
    String priority,
    String status,
    String? platform,
    @JsonKey(name: 'affected_version') String? affectedVersion,
    @JsonKey(name: 'first_mentioned_at') DateTime firstMentionedAt,
    @JsonKey(name: 'last_mentioned_at') DateTime lastMentionedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$InsightItemImplCopyWithImpl<$Res>
    extends _$InsightItemCopyWithImpl<$Res, _$InsightItemImpl>
    implements _$$InsightItemImplCopyWith<$Res> {
  __$$InsightItemImplCopyWithImpl(
    _$InsightItemImpl _value,
    $Res Function(_$InsightItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InsightItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? description = freezed,
    Object? keywords = null,
    Object? mentionCount = null,
    Object? priority = null,
    Object? status = null,
    Object? platform = freezed,
    Object? affectedVersion = freezed,
    Object? firstMentionedAt = null,
    Object? lastMentionedAt = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$InsightItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        keywords: null == keywords
            ? _value._keywords
            : keywords // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        mentionCount: null == mentionCount
            ? _value.mentionCount
            : mentionCount // ignore: cast_nullable_to_non_nullable
                  as int,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        platform: freezed == platform
            ? _value.platform
            : platform // ignore: cast_nullable_to_non_nullable
                  as String?,
        affectedVersion: freezed == affectedVersion
            ? _value.affectedVersion
            : affectedVersion // ignore: cast_nullable_to_non_nullable
                  as String?,
        firstMentionedAt: null == firstMentionedAt
            ? _value.firstMentionedAt
            : firstMentionedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastMentionedAt: null == lastMentionedAt
            ? _value.lastMentionedAt
            : lastMentionedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InsightItemImpl extends _InsightItem {
  const _$InsightItemImpl({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    final List<String> keywords = const [],
    @JsonKey(name: 'mention_count') required this.mentionCount,
    required this.priority,
    required this.status,
    this.platform,
    @JsonKey(name: 'affected_version') this.affectedVersion,
    @JsonKey(name: 'first_mentioned_at') required this.firstMentionedAt,
    @JsonKey(name: 'last_mentioned_at') required this.lastMentionedAt,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _keywords = keywords,
       super._();

  factory _$InsightItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$InsightItemImplFromJson(json);

  @override
  final int id;
  @override
  final String type;
  @override
  final String title;
  @override
  final String? description;
  final List<String> _keywords;
  @override
  @JsonKey()
  List<String> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  @override
  @JsonKey(name: 'mention_count')
  final int mentionCount;
  @override
  final String priority;
  @override
  final String status;
  @override
  final String? platform;
  @override
  @JsonKey(name: 'affected_version')
  final String? affectedVersion;
  @override
  @JsonKey(name: 'first_mentioned_at')
  final DateTime firstMentionedAt;
  @override
  @JsonKey(name: 'last_mentioned_at')
  final DateTime lastMentionedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'InsightItem(id: $id, type: $type, title: $title, description: $description, keywords: $keywords, mentionCount: $mentionCount, priority: $priority, status: $status, platform: $platform, affectedVersion: $affectedVersion, firstMentionedAt: $firstMentionedAt, lastMentionedAt: $lastMentionedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            (identical(other.mentionCount, mentionCount) ||
                other.mentionCount == mentionCount) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.affectedVersion, affectedVersion) ||
                other.affectedVersion == affectedVersion) &&
            (identical(other.firstMentionedAt, firstMentionedAt) ||
                other.firstMentionedAt == firstMentionedAt) &&
            (identical(other.lastMentionedAt, lastMentionedAt) ||
                other.lastMentionedAt == lastMentionedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    title,
    description,
    const DeepCollectionEquality().hash(_keywords),
    mentionCount,
    priority,
    status,
    platform,
    affectedVersion,
    firstMentionedAt,
    lastMentionedAt,
    createdAt,
    updatedAt,
  );

  /// Create a copy of InsightItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightItemImplCopyWith<_$InsightItemImpl> get copyWith =>
      __$$InsightItemImplCopyWithImpl<_$InsightItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InsightItemImplToJson(this);
  }
}

abstract class _InsightItem extends InsightItem {
  const factory _InsightItem({
    required final int id,
    required final String type,
    required final String title,
    final String? description,
    final List<String> keywords,
    @JsonKey(name: 'mention_count') required final int mentionCount,
    required final String priority,
    required final String status,
    final String? platform,
    @JsonKey(name: 'affected_version') final String? affectedVersion,
    @JsonKey(name: 'first_mentioned_at')
    required final DateTime firstMentionedAt,
    @JsonKey(name: 'last_mentioned_at') required final DateTime lastMentionedAt,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$InsightItemImpl;
  const _InsightItem._() : super._();

  factory _InsightItem.fromJson(Map<String, dynamic> json) =
      _$InsightItemImpl.fromJson;

  @override
  int get id;
  @override
  String get type;
  @override
  String get title;
  @override
  String? get description;
  @override
  List<String> get keywords;
  @override
  @JsonKey(name: 'mention_count')
  int get mentionCount;
  @override
  String get priority;
  @override
  String get status;
  @override
  String? get platform;
  @override
  @JsonKey(name: 'affected_version')
  String? get affectedVersion;
  @override
  @JsonKey(name: 'first_mentioned_at')
  DateTime get firstMentionedAt;
  @override
  @JsonKey(name: 'last_mentioned_at')
  DateTime get lastMentionedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of InsightItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsightItemImplCopyWith<_$InsightItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VersionSentiment _$VersionSentimentFromJson(Map<String, dynamic> json) {
  return _VersionSentiment.fromJson(json);
}

/// @nodoc
mixin _$VersionSentiment {
  String get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'review_count')
  int get reviewCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'sentiment_percent')
  double get sentimentPercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_rating')
  double get avgRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_review')
  String get firstReview => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_review')
  String get lastReview => throw _privateConstructorUsedError;

  /// Serializes this VersionSentiment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VersionSentiment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VersionSentimentCopyWith<VersionSentiment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VersionSentimentCopyWith<$Res> {
  factory $VersionSentimentCopyWith(
    VersionSentiment value,
    $Res Function(VersionSentiment) then,
  ) = _$VersionSentimentCopyWithImpl<$Res, VersionSentiment>;
  @useResult
  $Res call({
    String version,
    @JsonKey(name: 'review_count') int reviewCount,
    @JsonKey(name: 'sentiment_percent') double sentimentPercent,
    @JsonKey(name: 'avg_rating') double avgRating,
    @JsonKey(name: 'first_review') String firstReview,
    @JsonKey(name: 'last_review') String lastReview,
  });
}

/// @nodoc
class _$VersionSentimentCopyWithImpl<$Res, $Val extends VersionSentiment>
    implements $VersionSentimentCopyWith<$Res> {
  _$VersionSentimentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VersionSentiment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? reviewCount = null,
    Object? sentimentPercent = null,
    Object? avgRating = null,
    Object? firstReview = null,
    Object? lastReview = null,
  }) {
    return _then(
      _value.copyWith(
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String,
            reviewCount: null == reviewCount
                ? _value.reviewCount
                : reviewCount // ignore: cast_nullable_to_non_nullable
                      as int,
            sentimentPercent: null == sentimentPercent
                ? _value.sentimentPercent
                : sentimentPercent // ignore: cast_nullable_to_non_nullable
                      as double,
            avgRating: null == avgRating
                ? _value.avgRating
                : avgRating // ignore: cast_nullable_to_non_nullable
                      as double,
            firstReview: null == firstReview
                ? _value.firstReview
                : firstReview // ignore: cast_nullable_to_non_nullable
                      as String,
            lastReview: null == lastReview
                ? _value.lastReview
                : lastReview // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VersionSentimentImplCopyWith<$Res>
    implements $VersionSentimentCopyWith<$Res> {
  factory _$$VersionSentimentImplCopyWith(
    _$VersionSentimentImpl value,
    $Res Function(_$VersionSentimentImpl) then,
  ) = __$$VersionSentimentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String version,
    @JsonKey(name: 'review_count') int reviewCount,
    @JsonKey(name: 'sentiment_percent') double sentimentPercent,
    @JsonKey(name: 'avg_rating') double avgRating,
    @JsonKey(name: 'first_review') String firstReview,
    @JsonKey(name: 'last_review') String lastReview,
  });
}

/// @nodoc
class __$$VersionSentimentImplCopyWithImpl<$Res>
    extends _$VersionSentimentCopyWithImpl<$Res, _$VersionSentimentImpl>
    implements _$$VersionSentimentImplCopyWith<$Res> {
  __$$VersionSentimentImplCopyWithImpl(
    _$VersionSentimentImpl _value,
    $Res Function(_$VersionSentimentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VersionSentiment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? reviewCount = null,
    Object? sentimentPercent = null,
    Object? avgRating = null,
    Object? firstReview = null,
    Object? lastReview = null,
  }) {
    return _then(
      _$VersionSentimentImpl(
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String,
        reviewCount: null == reviewCount
            ? _value.reviewCount
            : reviewCount // ignore: cast_nullable_to_non_nullable
                  as int,
        sentimentPercent: null == sentimentPercent
            ? _value.sentimentPercent
            : sentimentPercent // ignore: cast_nullable_to_non_nullable
                  as double,
        avgRating: null == avgRating
            ? _value.avgRating
            : avgRating // ignore: cast_nullable_to_non_nullable
                  as double,
        firstReview: null == firstReview
            ? _value.firstReview
            : firstReview // ignore: cast_nullable_to_non_nullable
                  as String,
        lastReview: null == lastReview
            ? _value.lastReview
            : lastReview // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VersionSentimentImpl extends _VersionSentiment {
  const _$VersionSentimentImpl({
    required this.version,
    @JsonKey(name: 'review_count') required this.reviewCount,
    @JsonKey(name: 'sentiment_percent') required this.sentimentPercent,
    @JsonKey(name: 'avg_rating') required this.avgRating,
    @JsonKey(name: 'first_review') required this.firstReview,
    @JsonKey(name: 'last_review') required this.lastReview,
  }) : super._();

  factory _$VersionSentimentImpl.fromJson(Map<String, dynamic> json) =>
      _$$VersionSentimentImplFromJson(json);

  @override
  final String version;
  @override
  @JsonKey(name: 'review_count')
  final int reviewCount;
  @override
  @JsonKey(name: 'sentiment_percent')
  final double sentimentPercent;
  @override
  @JsonKey(name: 'avg_rating')
  final double avgRating;
  @override
  @JsonKey(name: 'first_review')
  final String firstReview;
  @override
  @JsonKey(name: 'last_review')
  final String lastReview;

  @override
  String toString() {
    return 'VersionSentiment(version: $version, reviewCount: $reviewCount, sentimentPercent: $sentimentPercent, avgRating: $avgRating, firstReview: $firstReview, lastReview: $lastReview)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VersionSentimentImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.sentimentPercent, sentimentPercent) ||
                other.sentimentPercent == sentimentPercent) &&
            (identical(other.avgRating, avgRating) ||
                other.avgRating == avgRating) &&
            (identical(other.firstReview, firstReview) ||
                other.firstReview == firstReview) &&
            (identical(other.lastReview, lastReview) ||
                other.lastReview == lastReview));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    version,
    reviewCount,
    sentimentPercent,
    avgRating,
    firstReview,
    lastReview,
  );

  /// Create a copy of VersionSentiment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VersionSentimentImplCopyWith<_$VersionSentimentImpl> get copyWith =>
      __$$VersionSentimentImplCopyWithImpl<_$VersionSentimentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VersionSentimentImplToJson(this);
  }
}

abstract class _VersionSentiment extends VersionSentiment {
  const factory _VersionSentiment({
    required final String version,
    @JsonKey(name: 'review_count') required final int reviewCount,
    @JsonKey(name: 'sentiment_percent') required final double sentimentPercent,
    @JsonKey(name: 'avg_rating') required final double avgRating,
    @JsonKey(name: 'first_review') required final String firstReview,
    @JsonKey(name: 'last_review') required final String lastReview,
  }) = _$VersionSentimentImpl;
  const _VersionSentiment._() : super._();

  factory _VersionSentiment.fromJson(Map<String, dynamic> json) =
      _$VersionSentimentImpl.fromJson;

  @override
  String get version;
  @override
  @JsonKey(name: 'review_count')
  int get reviewCount;
  @override
  @JsonKey(name: 'sentiment_percent')
  double get sentimentPercent;
  @override
  @JsonKey(name: 'avg_rating')
  double get avgRating;
  @override
  @JsonKey(name: 'first_review')
  String get firstReview;
  @override
  @JsonKey(name: 'last_review')
  String get lastReview;

  /// Create a copy of VersionSentiment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VersionSentimentImplCopyWith<_$VersionSentimentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReviewIntelligenceSummary _$ReviewIntelligenceSummaryFromJson(
  Map<String, dynamic> json,
) {
  return _ReviewIntelligenceSummary.fromJson(json);
}

/// @nodoc
mixin _$ReviewIntelligenceSummary {
  @JsonKey(name: 'total_feature_requests')
  int get totalFeatureRequests => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_bug_reports')
  int get totalBugReports => throw _privateConstructorUsedError;
  @JsonKey(name: 'open_feature_requests')
  int get openFeatureRequests => throw _privateConstructorUsedError;
  @JsonKey(name: 'open_bug_reports')
  int get openBugReports => throw _privateConstructorUsedError;
  @JsonKey(name: 'high_priority_bugs')
  int get highPriorityBugs => throw _privateConstructorUsedError;

  /// Serializes this ReviewIntelligenceSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewIntelligenceSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewIntelligenceSummaryCopyWith<ReviewIntelligenceSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewIntelligenceSummaryCopyWith<$Res> {
  factory $ReviewIntelligenceSummaryCopyWith(
    ReviewIntelligenceSummary value,
    $Res Function(ReviewIntelligenceSummary) then,
  ) = _$ReviewIntelligenceSummaryCopyWithImpl<$Res, ReviewIntelligenceSummary>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_feature_requests') int totalFeatureRequests,
    @JsonKey(name: 'total_bug_reports') int totalBugReports,
    @JsonKey(name: 'open_feature_requests') int openFeatureRequests,
    @JsonKey(name: 'open_bug_reports') int openBugReports,
    @JsonKey(name: 'high_priority_bugs') int highPriorityBugs,
  });
}

/// @nodoc
class _$ReviewIntelligenceSummaryCopyWithImpl<
  $Res,
  $Val extends ReviewIntelligenceSummary
>
    implements $ReviewIntelligenceSummaryCopyWith<$Res> {
  _$ReviewIntelligenceSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewIntelligenceSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalFeatureRequests = null,
    Object? totalBugReports = null,
    Object? openFeatureRequests = null,
    Object? openBugReports = null,
    Object? highPriorityBugs = null,
  }) {
    return _then(
      _value.copyWith(
            totalFeatureRequests: null == totalFeatureRequests
                ? _value.totalFeatureRequests
                : totalFeatureRequests // ignore: cast_nullable_to_non_nullable
                      as int,
            totalBugReports: null == totalBugReports
                ? _value.totalBugReports
                : totalBugReports // ignore: cast_nullable_to_non_nullable
                      as int,
            openFeatureRequests: null == openFeatureRequests
                ? _value.openFeatureRequests
                : openFeatureRequests // ignore: cast_nullable_to_non_nullable
                      as int,
            openBugReports: null == openBugReports
                ? _value.openBugReports
                : openBugReports // ignore: cast_nullable_to_non_nullable
                      as int,
            highPriorityBugs: null == highPriorityBugs
                ? _value.highPriorityBugs
                : highPriorityBugs // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReviewIntelligenceSummaryImplCopyWith<$Res>
    implements $ReviewIntelligenceSummaryCopyWith<$Res> {
  factory _$$ReviewIntelligenceSummaryImplCopyWith(
    _$ReviewIntelligenceSummaryImpl value,
    $Res Function(_$ReviewIntelligenceSummaryImpl) then,
  ) = __$$ReviewIntelligenceSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_feature_requests') int totalFeatureRequests,
    @JsonKey(name: 'total_bug_reports') int totalBugReports,
    @JsonKey(name: 'open_feature_requests') int openFeatureRequests,
    @JsonKey(name: 'open_bug_reports') int openBugReports,
    @JsonKey(name: 'high_priority_bugs') int highPriorityBugs,
  });
}

/// @nodoc
class __$$ReviewIntelligenceSummaryImplCopyWithImpl<$Res>
    extends
        _$ReviewIntelligenceSummaryCopyWithImpl<
          $Res,
          _$ReviewIntelligenceSummaryImpl
        >
    implements _$$ReviewIntelligenceSummaryImplCopyWith<$Res> {
  __$$ReviewIntelligenceSummaryImplCopyWithImpl(
    _$ReviewIntelligenceSummaryImpl _value,
    $Res Function(_$ReviewIntelligenceSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewIntelligenceSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalFeatureRequests = null,
    Object? totalBugReports = null,
    Object? openFeatureRequests = null,
    Object? openBugReports = null,
    Object? highPriorityBugs = null,
  }) {
    return _then(
      _$ReviewIntelligenceSummaryImpl(
        totalFeatureRequests: null == totalFeatureRequests
            ? _value.totalFeatureRequests
            : totalFeatureRequests // ignore: cast_nullable_to_non_nullable
                  as int,
        totalBugReports: null == totalBugReports
            ? _value.totalBugReports
            : totalBugReports // ignore: cast_nullable_to_non_nullable
                  as int,
        openFeatureRequests: null == openFeatureRequests
            ? _value.openFeatureRequests
            : openFeatureRequests // ignore: cast_nullable_to_non_nullable
                  as int,
        openBugReports: null == openBugReports
            ? _value.openBugReports
            : openBugReports // ignore: cast_nullable_to_non_nullable
                  as int,
        highPriorityBugs: null == highPriorityBugs
            ? _value.highPriorityBugs
            : highPriorityBugs // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewIntelligenceSummaryImpl implements _ReviewIntelligenceSummary {
  const _$ReviewIntelligenceSummaryImpl({
    @JsonKey(name: 'total_feature_requests') required this.totalFeatureRequests,
    @JsonKey(name: 'total_bug_reports') required this.totalBugReports,
    @JsonKey(name: 'open_feature_requests') required this.openFeatureRequests,
    @JsonKey(name: 'open_bug_reports') required this.openBugReports,
    @JsonKey(name: 'high_priority_bugs') required this.highPriorityBugs,
  });

  factory _$ReviewIntelligenceSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewIntelligenceSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'total_feature_requests')
  final int totalFeatureRequests;
  @override
  @JsonKey(name: 'total_bug_reports')
  final int totalBugReports;
  @override
  @JsonKey(name: 'open_feature_requests')
  final int openFeatureRequests;
  @override
  @JsonKey(name: 'open_bug_reports')
  final int openBugReports;
  @override
  @JsonKey(name: 'high_priority_bugs')
  final int highPriorityBugs;

  @override
  String toString() {
    return 'ReviewIntelligenceSummary(totalFeatureRequests: $totalFeatureRequests, totalBugReports: $totalBugReports, openFeatureRequests: $openFeatureRequests, openBugReports: $openBugReports, highPriorityBugs: $highPriorityBugs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewIntelligenceSummaryImpl &&
            (identical(other.totalFeatureRequests, totalFeatureRequests) ||
                other.totalFeatureRequests == totalFeatureRequests) &&
            (identical(other.totalBugReports, totalBugReports) ||
                other.totalBugReports == totalBugReports) &&
            (identical(other.openFeatureRequests, openFeatureRequests) ||
                other.openFeatureRequests == openFeatureRequests) &&
            (identical(other.openBugReports, openBugReports) ||
                other.openBugReports == openBugReports) &&
            (identical(other.highPriorityBugs, highPriorityBugs) ||
                other.highPriorityBugs == highPriorityBugs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalFeatureRequests,
    totalBugReports,
    openFeatureRequests,
    openBugReports,
    highPriorityBugs,
  );

  /// Create a copy of ReviewIntelligenceSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewIntelligenceSummaryImplCopyWith<_$ReviewIntelligenceSummaryImpl>
  get copyWith =>
      __$$ReviewIntelligenceSummaryImplCopyWithImpl<
        _$ReviewIntelligenceSummaryImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewIntelligenceSummaryImplToJson(this);
  }
}

abstract class _ReviewIntelligenceSummary implements ReviewIntelligenceSummary {
  const factory _ReviewIntelligenceSummary({
    @JsonKey(name: 'total_feature_requests')
    required final int totalFeatureRequests,
    @JsonKey(name: 'total_bug_reports') required final int totalBugReports,
    @JsonKey(name: 'open_feature_requests')
    required final int openFeatureRequests,
    @JsonKey(name: 'open_bug_reports') required final int openBugReports,
    @JsonKey(name: 'high_priority_bugs') required final int highPriorityBugs,
  }) = _$ReviewIntelligenceSummaryImpl;

  factory _ReviewIntelligenceSummary.fromJson(Map<String, dynamic> json) =
      _$ReviewIntelligenceSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'total_feature_requests')
  int get totalFeatureRequests;
  @override
  @JsonKey(name: 'total_bug_reports')
  int get totalBugReports;
  @override
  @JsonKey(name: 'open_feature_requests')
  int get openFeatureRequests;
  @override
  @JsonKey(name: 'open_bug_reports')
  int get openBugReports;
  @override
  @JsonKey(name: 'high_priority_bugs')
  int get highPriorityBugs;

  /// Create a copy of ReviewIntelligenceSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewIntelligenceSummaryImplCopyWith<_$ReviewIntelligenceSummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}
