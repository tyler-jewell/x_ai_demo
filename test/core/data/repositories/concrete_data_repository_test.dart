import 'package:flutter_app/src/core/data/repositories/concrete_data_repository.dart';
import 'package:flutter_app/src/core/domain/models/item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mock_database_service.mocks.dart';

void main() {
  late MockDatabaseService mockDatabase;
  late ConcreteDataRepository repository;

  setUp(() {
    mockDatabase = MockDatabaseService();
    repository = ConcreteDataRepository(database: mockDatabase);
  });

  group('ConcreteDataRepository', () {
    test('getItems maps database response to domain models', () async {
      final now = DateTime.now();
      when(mockDatabase.getItems()).thenAnswer((_) async => [
            {
              'id': 1,
              'title': 'Test Title',
              'description': 'Test Description',
              'createdAt': now.toIso8601String(),
            }
          ]);

      final result = await repository.getItems();

      expect(result.length, 1);
      expect(result.first, isA<Item>());
      expect(result.first.id, 1);
      expect(result.first.title, 'Test Title');
    });

    test('insertItem converts domain model to json', () async {
      final item = Item(
        id: 1,
        title: 'Test',
        description: 'Test Description',
        createdAt: DateTime.now(),
      );

      await repository.insertItem(item);

      verify(mockDatabase.insertItem(any)).called(1);
    });

    test('getItems handles empty response', () async {
      when(mockDatabase.getItems()).thenAnswer((_) async => []);
      final result = await repository.getItems();
      expect(result, isEmpty);
    });
  });
}
