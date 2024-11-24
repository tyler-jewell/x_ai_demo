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
    test('getItems should map database items to domain models', () async {
      // Arrange
      final now = DateTime.now();
      final mockData = [
        {
          'id': 1,
          'title': 'Test Title',
          'description': 'Test Description',
          'createdAt': now.toIso8601String(),
        }
      ];
      when(mockDatabase.getItems()).thenAnswer((_) async => mockData);

      // Act
      final result = await repository.getItems();

      // Assert
      expect(result, isA<List<Item>>());
      expect(result.length, 1);
      expect(result.first.id, 1);
      expect(result.first.title, 'Test Title');
      expect(result.first.description, 'Test Description');
      expect(result.first.createdAt.toIso8601String(), now.toIso8601String());
    });

    test('insertItem should convert domain model to json', () async {
      // Arrange
      final now = DateTime.now();
      final item = Item(
        id: 1,
        title: 'Test',
        description: 'Test Description',
        createdAt: now,
      );
      when(mockDatabase.insertItem(any)).thenAnswer((_) async {});

      // Act
      await repository.insertItem(item);

      // Assert
      verify(mockDatabase.insertItem({
        'id': 1,
        'title': 'Test',
        'description': 'Test Description',
        'createdAt': now.toIso8601String(),
      })).called(1);
    });

    test('getItems should handle empty database response', () async {
      // Arrange
      when(mockDatabase.getItems()).thenAnswer((_) async => []);

      // Act
      final result = await repository.getItems();

      // Assert
      expect(result, isEmpty);
    });
  });
}
