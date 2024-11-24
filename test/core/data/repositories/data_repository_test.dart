import 'package:flutter_app/src/core/data/repositories/concrete_data_repository.dart';
import 'package:flutter_app/src/core/data/repositories/data_repository.dart';
import 'package:flutter_app/src/core/domain/models/item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mock_database_service.mocks.dart';

void main() {
  late MockDatabaseService mockDatabase;
  late DataRepository repository;

  setUp(() {
    mockDatabase = MockDatabaseService();
    repository = ConcreteDataRepository(database: mockDatabase);
  });

  group('DataRepository', () {
    test('getItems should return list of items', () async {
      // Arrange
      final mockData = [
        {
          'id': 1,
          'title': 'Test Title',
          'description': 'Test Description',
          'createdAt': DateTime.now().toIso8601String(),
        }
      ];
      when(mockDatabase.getItems()).thenAnswer((_) async => mockData);

      // Act
      final result = await repository.getItems();

      // Assert
      expect(result, isA<List<Item>>());
      expect(result.length, 1);
      expect(result.first.title, 'Test Title');
      verify(mockDatabase.getItems()).called(1);
    });

    test('insertItem should call database insertItem', () async {
      // Arrange
      final item = Item(
        id: 1,
        title: 'Test',
        description: 'Test Description',
        createdAt: DateTime.now(),
      );
      when(mockDatabase.insertItem(any)).thenAnswer((_) async {
        return;
      });

      // Act
      await repository.insertItem(item);

      // Assert
      verify(mockDatabase.insertItem(any)).called(1);
    });
  });
}
