import 'package:flutter_app/core/domain/models/item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Item', () {
    test('should create Item instance from json', () {
      final json = {
        'id': 1,
        'title': 'Test Title',
        'description': 'Test Description',
        'createdAt': '2024-03-20T10:00:00.000Z',
      };

      final item = Item.fromJson(json);

      expect(item.id, 1);
      expect(item.title, 'Test Title');
      expect(item.description, 'Test Description');
      expect(item.createdAt.toIso8601String(), '2024-03-20T10:00:00.000Z');
    });

    test('should convert Item to json', () {
      final date = DateTime.parse('2024-03-20T10:00:00.000Z');
      final item = Item(
        id: 1,
        title: 'Test Title',
        description: 'Test Description',
        createdAt: date,
      );

      final json = item.toJson();

      expect(json['id'], 1);
      expect(json['title'], 'Test Title');
      expect(json['description'], 'Test Description');
      expect(json['createdAt'], date.toIso8601String());
    });
  });
}
