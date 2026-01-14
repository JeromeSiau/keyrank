/// Represents a competitor app with its relationship metadata.
class CompetitorModel {
  final int id;
  final String platform;
  final String storeId;
  final String name;
  final String? iconUrl;
  final String? developer;
  final double? rating;
  final int ratingCount;
  final String competitorType; // 'global' or 'contextual'
  final String? source; // 'manual', 'auto_discovered', 'keyword_overlap'
  final DateTime? linkedAt;

  CompetitorModel({
    required this.id,
    required this.platform,
    required this.storeId,
    required this.name,
    this.iconUrl,
    this.developer,
    this.rating,
    required this.ratingCount,
    required this.competitorType,
    this.source,
    this.linkedAt,
  });

  bool get isGlobal => competitorType == 'global';
  bool get isContextual => competitorType == 'contextual';
  bool get isIos => platform == 'ios';
  bool get isAndroid => platform == 'android';

  factory CompetitorModel.fromJson(Map<String, dynamic> json) {
    return CompetitorModel(
      id: json['id'] as int,
      platform: json['platform'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      developer: json['developer'] as String?,
      rating: _parseDouble(json['rating']),
      ratingCount: _parseInt(json['rating_count']) ?? 0,
      competitorType: json['competitor_type'] as String? ?? 'global',
      source: json['source'] as String?,
      linkedAt: json['linked_at'] != null
          ? DateTime.tryParse(json['linked_at'] as String)
          : null,
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
