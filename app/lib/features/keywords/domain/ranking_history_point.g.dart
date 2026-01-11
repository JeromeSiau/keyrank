// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_history_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RankingHistoryPointImpl _$$RankingHistoryPointImplFromJson(
  Map<String, dynamic> json,
) => _$RankingHistoryPointImpl(
  type: json['type'] as String,
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  periodStart: json['period_start'] == null
      ? null
      : DateTime.parse(json['period_start'] as String),
  position: (json['position'] as num?)?.toInt(),
  avg: (json['avg'] as num?)?.toDouble(),
  min: (json['min'] as num?)?.toInt(),
  max: (json['max'] as num?)?.toInt(),
  dataPoints: (json['data_points'] as num?)?.toInt(),
);

Map<String, dynamic> _$$RankingHistoryPointImplToJson(
  _$RankingHistoryPointImpl instance,
) => <String, dynamic>{
  'type': instance.type,
  'date': instance.date?.toIso8601String(),
  'period_start': instance.periodStart?.toIso8601String(),
  'position': instance.position,
  'avg': instance.avg,
  'min': instance.min,
  'max': instance.max,
  'data_points': instance.dataPoints,
};
