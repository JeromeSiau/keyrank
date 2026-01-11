import 'package:freezed_annotation/freezed_annotation.dart';

part 'ranking_history_point.freezed.dart';
part 'ranking_history_point.g.dart';

/// Représente un point d'historique de ranking (daily ou aggregate)
@freezed
class RankingHistoryPoint with _$RankingHistoryPoint {
  const factory RankingHistoryPoint({
    /// Type de donnée: 'daily', 'weekly', 'monthly'
    required String type,

    /// Date pour les données daily (null pour aggregates)
    DateTime? date,

    /// Début de période pour les aggregates (null pour daily)
    @JsonKey(name: 'period_start') DateTime? periodStart,

    /// Position exacte (daily uniquement)
    int? position,

    /// Position moyenne (aggregates uniquement)
    double? avg,

    /// Position minimum (aggregates uniquement)
    int? min,

    /// Position maximum (aggregates uniquement)
    int? max,

    /// Nombre de jours de données (aggregates uniquement)
    @JsonKey(name: 'data_points') int? dataPoints,
  }) = _RankingHistoryPoint;

  const RankingHistoryPoint._();

  factory RankingHistoryPoint.fromJson(Map<String, dynamic> json) =>
      _$RankingHistoryPointFromJson(json);

  /// Date effective pour le tri et l'affichage
  DateTime get effectiveDate => date ?? periodStart ?? DateTime.now();

  /// Est-ce une donnée agrégée ?
  bool get isAggregate => type == 'weekly' || type == 'monthly';

  /// Position à afficher (exacte ou moyenne)
  double? get displayPosition => isAggregate ? avg : position?.toDouble();

  /// Label pour le type de données
  String get typeLabel => switch (type) {
        'daily' => 'Daily',
        'weekly' => 'Weekly avg',
        'monthly' => 'Monthly avg',
        _ => type,
      };
}
