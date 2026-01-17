// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_intelligence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewIntelligenceImpl _$$ReviewIntelligenceImplFromJson(
  Map<String, dynamic> json,
) => _$ReviewIntelligenceImpl(
  featureRequests: (json['feature_requests'] as List<dynamic>)
      .map((e) => InsightItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  bugReports: (json['bug_reports'] as List<dynamic>)
      .map((e) => InsightItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  versionSentiment: (json['version_sentiment'] as List<dynamic>)
      .map((e) => VersionSentiment.fromJson(e as Map<String, dynamic>))
      .toList(),
  versionInsight: json['version_insight'] as String?,
  summary: ReviewIntelligenceSummary.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$ReviewIntelligenceImplToJson(
  _$ReviewIntelligenceImpl instance,
) => <String, dynamic>{
  'feature_requests': instance.featureRequests,
  'bug_reports': instance.bugReports,
  'version_sentiment': instance.versionSentiment,
  'version_insight': instance.versionInsight,
  'summary': instance.summary,
};

_$InsightItemImpl _$$InsightItemImplFromJson(Map<String, dynamic> json) =>
    _$InsightItemImpl(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      keywords:
          (json['keywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      mentionCount: (json['mention_count'] as num).toInt(),
      priority: json['priority'] as String,
      status: json['status'] as String,
      platform: json['platform'] as String?,
      affectedVersion: json['affected_version'] as String?,
      firstMentionedAt: DateTime.parse(json['first_mentioned_at'] as String),
      lastMentionedAt: DateTime.parse(json['last_mentioned_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$InsightItemImplToJson(_$InsightItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'description': instance.description,
      'keywords': instance.keywords,
      'mention_count': instance.mentionCount,
      'priority': instance.priority,
      'status': instance.status,
      'platform': instance.platform,
      'affected_version': instance.affectedVersion,
      'first_mentioned_at': instance.firstMentionedAt.toIso8601String(),
      'last_mentioned_at': instance.lastMentionedAt.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$VersionSentimentImpl _$$VersionSentimentImplFromJson(
  Map<String, dynamic> json,
) => _$VersionSentimentImpl(
  version: json['version'] as String,
  reviewCount: (json['review_count'] as num).toInt(),
  sentimentPercent: (json['sentiment_percent'] as num).toDouble(),
  avgRating: (json['avg_rating'] as num).toDouble(),
  firstReview: json['first_review'] as String,
  lastReview: json['last_review'] as String,
);

Map<String, dynamic> _$$VersionSentimentImplToJson(
  _$VersionSentimentImpl instance,
) => <String, dynamic>{
  'version': instance.version,
  'review_count': instance.reviewCount,
  'sentiment_percent': instance.sentimentPercent,
  'avg_rating': instance.avgRating,
  'first_review': instance.firstReview,
  'last_review': instance.lastReview,
};

_$ReviewIntelligenceSummaryImpl _$$ReviewIntelligenceSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$ReviewIntelligenceSummaryImpl(
  totalFeatureRequests: (json['total_feature_requests'] as num).toInt(),
  totalBugReports: (json['total_bug_reports'] as num).toInt(),
  openFeatureRequests: (json['open_feature_requests'] as num).toInt(),
  openBugReports: (json['open_bug_reports'] as num).toInt(),
  highPriorityBugs: (json['high_priority_bugs'] as num).toInt(),
);

Map<String, dynamic> _$$ReviewIntelligenceSummaryImplToJson(
  _$ReviewIntelligenceSummaryImpl instance,
) => <String, dynamic>{
  'total_feature_requests': instance.totalFeatureRequests,
  'total_bug_reports': instance.totalBugReports,
  'open_feature_requests': instance.openFeatureRequests,
  'open_bug_reports': instance.openBugReports,
  'high_priority_bugs': instance.highPriorityBugs,
};
