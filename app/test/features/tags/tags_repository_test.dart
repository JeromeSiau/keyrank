// app/test/features/tags/tags_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:aso_app/features/tags/domain/tag_model.dart';

void main() {
  group('TagModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 1,
        'name': 'Important',
        'color': '#ef4444',
        'created_at': '2026-01-10T00:00:00.000Z',
      };

      final tag = TagModel.fromJson(json);

      expect(tag.id, 1);
      expect(tag.name, 'Important');
      expect(tag.color, '#ef4444');
    });

    test('colorValue returns correct Color', () {
      final tag = TagModel(id: 1, name: 'Test', color: '#ef4444');

      expect(tag.colorValue.toARGB32(), 0xFFef4444);
    });
  });
}
