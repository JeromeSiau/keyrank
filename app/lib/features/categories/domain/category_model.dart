class AppCategory {
  final String id;
  final String name;

  AppCategory({
    required this.id,
    required this.name,
  });

  factory AppCategory.fromJson(Map<String, dynamic> json) {
    return AppCategory(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppCategory && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class CategoriesResponse {
  final List<AppCategory> ios;
  final List<AppCategory> android;

  CategoriesResponse({
    required this.ios,
    required this.android,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    return CategoriesResponse(
      ios: (json['ios'] as List)
          .map((e) => AppCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      android: (json['android'] as List)
          .map((e) => AppCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TopApp {
  final int position;
  final String storeId;
  final String name;
  final String? iconUrl;
  final String? developer;
  final double? rating;
  final int? ratingCount;
  final double? price;
  final bool? free;

  TopApp({
    required this.position,
    required this.storeId,
    required this.name,
    this.iconUrl,
    this.developer,
    this.rating,
    this.ratingCount,
    this.price,
    this.free,
  });

  factory TopApp.fromJson(Map<String, dynamic> json, String platform) {
    // iOS uses apple_id, Android uses google_play_id
    final storeId = platform == 'ios'
        ? json['apple_id'] as String? ?? ''
        : json['google_play_id'] as String? ?? '';

    return TopApp(
      position: json['position'] as int,
      storeId: storeId,
      name: json['name'] as String? ?? '',
      iconUrl: json['icon_url'] as String?,
      developer: json['developer'] as String?,
      rating: _parseDouble(json['rating']),
      ratingCount: _parseInt(json['rating_count']),
      price: _parseDouble(json['price']),
      free: json['free'] as bool?,
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
