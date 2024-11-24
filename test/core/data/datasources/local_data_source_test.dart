import 'package:flutter_app/core/data/datasources/local_item_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalItemDataSource dataSource;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    dataSource = LocalItemDataSource(prefs: prefs);
  });

  group('SharedPrefsDataSource', () {
    test('should return empty list when no items stored', () async {
      final items = await dataSource.getItems();
      expect(items, isEmpty);
    });

    test('should store and retrieve items', () async {
      final testItem = {
        'id': 1,
        'title': 'Test Title',
        'description': 'Test Description',
        'createdAt': DateTime.now().toIso8601String(),
      };

      await dataSource.insertItem(testItem);

      final items = await dataSource.getItems();
      expect(items.length, 1);
      expect(items.first['id'], testItem['id']);
      expect(items.first['title'], testItem['title']);
      expect(items.first['description'], testItem['description']);
      expect(items.first['createdAt'], testItem['createdAt']);
    });

    test('should append new items to existing list', () async {
      final testItem1 = {
        'id': 1,
        'title': 'Test Title 1',
        'description': 'Test Description 1',
        'createdAt': DateTime.now().toIso8601String(),
      };

      final testItem2 = {
        'id': 2,
        'title': 'Test Title 2',
        'description': 'Test Description 2',
        'createdAt': DateTime.now().toIso8601String(),
      };

      await dataSource.insertItem(testItem1);
      await dataSource.insertItem(testItem2);

      final items = await dataSource.getItems();
      expect(items.length, 2);
      expect(items[0]['id'], testItem1['id']);
      expect(items[1]['id'], testItem2['id']);
    });
  });
}
