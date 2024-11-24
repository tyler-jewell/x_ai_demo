import 'package:flutter_app/src/core/data/local/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late DatabaseService databaseService;

  setUp(() {
    databaseService = DatabaseService();
  });

  group('DatabaseService', () {
    test('getItems should return empty list when no items exist', () async {
      SharedPreferences.setMockInitialValues({});
      final result = await databaseService.getItems();
      expect(result, isEmpty);
    });

    test('getItems should return list of items when items exist', () async {
      final testItems = [
        '{"id":1,"title":"Test","description":"Test","createdAt":"2024-03-20"}'
      ];
      SharedPreferences.setMockInitialValues({
        'items': testItems,
      });
      final result = await databaseService.getItems();
      expect(result.length, 1);
      expect(result.first['id'], 1);
    });

    test('insertItem should add item to storage', () async {
      SharedPreferences.setMockInitialValues({'items': []});
      final prefs = await SharedPreferences.getInstance();
      final testItem = {
        'id': 1,
        'title': 'Test',
        'description': 'Test',
        'createdAt': '2024-03-20'
      };

      await databaseService.insertItem(testItem);

      final storedItems = prefs.getStringList('items');
      expect(storedItems, isNotNull);
      expect(storedItems!.length, 1);
    });

    test('insertItem should append to existing items', () async {
      final existingItems = ['{"id":1,"title":"Test"}'];
      SharedPreferences.setMockInitialValues({
        'items': existingItems,
      });

      final testItem = {
        'id': 2,
        'title': 'Test 2',
        'description': 'Test',
        'createdAt': '2024-03-20'
      };

      await databaseService.insertItem(testItem);

      final prefs = await SharedPreferences.getInstance();
      final storedItems = prefs.getStringList('items');
      expect(storedItems?.length, 2);
    });
  });
}
