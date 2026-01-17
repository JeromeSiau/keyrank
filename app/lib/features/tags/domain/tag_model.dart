import 'dart:ui';

class TagModel {
  final int id;
  final String name;
  final String color;
  final DateTime? createdAt;

  const TagModel({
    required this.id,
    required this.name,
    required this.color,
    this.createdAt,
  });

  Color get colorValue {
    final hex = color.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'] as int,
      name: json['name'] as String,
      color: json['color'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'color': color,
    if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
  };

  TagModel copyWith({
    int? id,
    String? name,
    String? color,
    DateTime? createdAt,
  }) {
    return TagModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
