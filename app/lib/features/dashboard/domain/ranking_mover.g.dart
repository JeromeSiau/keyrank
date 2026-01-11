// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_mover.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RankingMoverImpl _$$RankingMoverImplFromJson(Map<String, dynamic> json) =>
    _$RankingMoverImpl(
      keyword: json['keyword'] as String,
      keywordId: (json['keyword_id'] as num).toInt(),
      appName: json['app_name'] as String,
      appId: (json['app_id'] as num).toInt(),
      appIcon: json['app_icon'] as String?,
      oldPosition: (json['old_position'] as num).toInt(),
      newPosition: (json['new_position'] as num).toInt(),
      change: (json['change'] as num).toInt(),
    );

Map<String, dynamic> _$$RankingMoverImplToJson(_$RankingMoverImpl instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'keyword_id': instance.keywordId,
      'app_name': instance.appName,
      'app_id': instance.appId,
      'app_icon': instance.appIcon,
      'old_position': instance.oldPosition,
      'new_position': instance.newPosition,
      'change': instance.change,
    };

_$RankingMoversDataImpl _$$RankingMoversDataImplFromJson(
  Map<String, dynamic> json,
) => _$RankingMoversDataImpl(
  improving: (json['improving'] as List<dynamic>)
      .map((e) => RankingMover.fromJson(e as Map<String, dynamic>))
      .toList(),
  declining: (json['declining'] as List<dynamic>)
      .map((e) => RankingMover.fromJson(e as Map<String, dynamic>))
      .toList(),
  period: json['period'] as String,
);

Map<String, dynamic> _$$RankingMoversDataImplToJson(
  _$RankingMoversDataImpl instance,
) => <String, dynamic>{
  'improving': instance.improving,
  'declining': instance.declining,
  'period': instance.period,
};
