import 'package:flutter_app/core/data/repositories/item_repository_impl.dart';
import 'package:flutter_app/core/domain/models/item.dart';
import 'package:flutter_app/core/domain/repositories/item_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mock_data_source.mocks.dart';

void main() {
  late MockItemDataSource mockDataSource;
  late ItemRepository repository;

  setUp(() {
    mockDataSource = MockItemDataSource();
    repository = ItemRepositoryImpl(dataSource: mockDataSource);
  });

  group('ItemRepository', () {
    test('getItems maps data source response to domain models', () async {
      final now = DateTime.now();
      when(mockDataSource.getItems()).thenAnswer((_) async => [
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

      verify(mockDataSource.insertItem(any)).called(1);
    });
  });
}
