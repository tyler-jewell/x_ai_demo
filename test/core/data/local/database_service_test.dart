import 'dart:convert';

import 'package:flutter_app/src/core/data/local/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late DatabaseService database;

  setUp(() {
    database = DatabaseService();
  });

  group('DatabaseService', () {
    test('getItems returns empty list when no items exist', () async {
      SharedPreferences.setMockInitialValues({});
      expect(await database.getItems(), isEmpty);
    });

    test('getItems returns decoded items', () async {
      final testItem = {
        'id': 1,
        'title': 'Test',
        'description': 'Test',
        'createdAt': '2024-03-20'
      };
      SharedPreferences.setMockInitialValues({
        'items': [json.encode(testItem)],
      });

      final result = await database.getItems();
      expect(result.length, 1);
      expect(result.first, equals(testItem));
    });

    test('insertItem adds new item', () async {
      SharedPreferences.setMockInitialValues({'items': []});
      final testItem = {
        'id': 1,
        'title': 'Test',
        'description': 'Test',
        'createdAt': '2024-03-20'
      };

      await database.insertItem(testItem);
      final items = await database.getItems();

      expect(items.length, 1);
      expect(items.first, equals(testItem));
    });
  });
}
