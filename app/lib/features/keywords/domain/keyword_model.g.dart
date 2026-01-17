// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyword_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KeywordImpl _$$KeywordImplFromJson(Map<String, dynamic> json) =>
    _$KeywordImpl(
      id: (json['id'] as num).toInt(),
      trackedKeywordId: (json['tracked_keyword_id'] as num?)?.toInt(),
      keyword: json['keyword'] as String,
      storefront: json['storefront'] as String,
      popularity: (json['popularity'] as num?)?.toInt(),
      position: (json['position'] as num?)?.toInt(),
      change: (json['change'] as num?)?.toInt(),
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
      trackedSince: json['tracked_since'] == null
          ? null
          : DateTime.parse(json['tracked_since'] as String),
      isFavorite: json['is_favorite'] as bool? ?? false,
      favoritedAt: json['favorited_at'] == null
          ? null
          : DateTime.parse(json['favorited_at'] as String),
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((e) => TagModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      note: json['note'] as String?,
      difficulty: (json['difficulty'] as num?)?.toInt(),
      difficultyLabel: json['difficulty_label'] as String?,
      competition: (json['competition'] as num?)?.toInt(),
      topCompetitors: (json['top_competitors'] as List<dynamic>?)
          ?.map((e) => TopCompetitor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$KeywordImplToJson(_$KeywordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tracked_keyword_id': instance.trackedKeywordId,
      'keyword': instance.keyword,
      'storefront': instance.storefront,
      'popularity': instance.popularity,
      'position': instance.position,
      'change': instance.change,
      'last_updated': instance.lastUpdated?.toIso8601String(),
      'tracked_since': instance.trackedSince?.toIso8601String(),
      'is_favorite': instance.isFavorite,
      'favorited_at': instance.favoritedAt?.toIso8601String(),
      'tags': instance.tags,
      'note': instance.note,
      'difficulty': instance.difficulty,
      'difficulty_label': instance.difficultyLabel,
      'competition': instance.competition,
      'top_competitors': instance.topCompetitors,
    };

_$KeywordSearchResponseImpl _$$KeywordSearchResponseImplFromJson(
  Map<String, dynamic> json,
) => _$KeywordSearchResponseImpl(
  keyword: KeywordInfo.fromJson(json['keyword'] as Map<String, dynamic>),
  results: (json['results'] as List<dynamic>)
      .map((e) => KeywordSearchResult.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalResults: (json['total_results'] as num).toInt(),
);

Map<String, dynamic> _$$KeywordSearchResponseImplToJson(
  _$KeywordSearchResponseImpl instance,
) => <String, dynamic>{
  'keyword': instance.keyword,
  'results': instance.results,
  'total_results': instance.totalResults,
};

_$KeywordInfoImpl _$$KeywordInfoImplFromJson(Map<String, dynamic> json) =>
    _$KeywordInfoImpl(
      id: (json['id'] as num).toInt(),
      keyword: json['keyword'] as String,
      storefront: json['storefront'] as String,
      popularity: (json['popularity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$KeywordInfoImplToJson(_$KeywordInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'keyword': instance.keyword,
      'storefront': instance.storefront,
      'popularity': instance.popularity,
    };

_$KeywordSearchResultImpl _$$KeywordSearchResultImplFromJson(
  Map<String, dynamic> json,
) => _$KeywordSearchResultImpl(
  position: (json['position'] as num).toInt(),
  appleId: json['apple_id'] as String?,
  googlePlayId: json['google_play_id'] as String?,
  name: json['name'] as String,
  iconUrl: json['icon_url'] as String?,
  developer: json['developer'] as String?,
  rating: _parseDouble(json['rating']),
  ratingCount: _parseIntOrZero(json['rating_count']),
);

Map<String, dynamic> _$$KeywordSearchResultImplToJson(
  _$KeywordSearchResultImpl instance,
) => <String, dynamic>{
  'position': instance.position,
  'apple_id': instance.appleId,
  'google_play_id': instance.googlePlayId,
  'name': instance.name,
  'icon_url': instance.iconUrl,
  'developer': instance.developer,
  'rating': instance.rating,
  'rating_count': instance.ratingCount,
};

_$TopCompetitorImpl _$$TopCompetitorImplFromJson(Map<String, dynamic> json) =>
    _$TopCompetitorImpl(
      name: json['name'] as String,
      position: (json['position'] as num).toInt(),
      rating: _parseDouble(json['rating']),
      iconUrl: json['icon_url'] as String?,
    );

Map<String, dynamic> _$$TopCompetitorImplToJson(_$TopCompetitorImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'position': instance.position,
      'rating': instance.rating,
      'icon_url': instance.iconUrl,
    };
