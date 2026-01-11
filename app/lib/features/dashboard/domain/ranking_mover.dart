import 'package:freezed_annotation/freezed_annotation.dart';

part 'ranking_mover.freezed.dart';
part 'ranking_mover.g.dart';

@freezed
class RankingMover with _$RankingMover {
  const factory RankingMover({
    required String keyword,
    @JsonKey(name: 'keyword_id') required int keywordId,
    @JsonKey(name: 'app_name') required String appName,
    @JsonKey(name: 'app_id') required int appId,
    @JsonKey(name: 'app_icon') String? appIcon,
    @JsonKey(name: 'old_position') required int oldPosition,
    @JsonKey(name: 'new_position') required int newPosition,
    required int change,
  }) = _RankingMover;

  factory RankingMover.fromJson(Map<String, dynamic> json) =>
      _$RankingMoverFromJson(json);
}

@freezed
class RankingMoversData with _$RankingMoversData {
  const factory RankingMoversData({
    required List<RankingMover> improving,
    required List<RankingMover> declining,
    required String period,
  }) = _RankingMoversData;

  factory RankingMoversData.fromJson(Map<String, dynamic> json) =>
      _$RankingMoversDataFromJson(json);
}
