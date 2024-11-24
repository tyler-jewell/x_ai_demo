import 'package:flutter_app/src/core/domain/models/item.dart';
import 'package:flutter_app/src/features/home/presentation/view_models/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks/mock_database_service.mocks.dart';

void main() {
  group('HomeViewModel', () {
    late MockDataRepository mockDataRepository;
    late HomeViewModel viewModel;

    setUp(() {
      mockDataRepository = MockDataRepository();
      when(mockDataRepository.getItems()).thenAnswer((_) async => []);
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('loadItems should handle loading state', () async {
      // Arrange
      viewModel = HomeViewModel(repository: mockDataRepository);

      // Act
      await viewModel.loadItems();

      // Assert
      verify(mockDataRepository.getItems()).called(2);
      expect(viewModel.isLoading, false);
    });

    test('loadItems should handle error state', () async {
      // Arrange
      when(mockDataRepository.getItems()).thenThrow(Exception('Test error'));
      viewModel = HomeViewModel(repository: mockDataRepository);

      // Act
      await viewModel.loadItems();

      // Assert
      expect(viewModel.error, isNotNull);
      expect(viewModel.isLoading, false);
    });

    test('addItem should add item and reload list', () async {
      // Arrange
      when(mockDataRepository.insertItem(any)).thenAnswer((_) async {});
      viewModel = HomeViewModel(repository: mockDataRepository);
      clearInteractions(mockDataRepository); // Clear the initial load calls

      // Act
      await viewModel.addItem('Test Title', 'Test Description');

      // Assert
      verify(mockDataRepository.insertItem(any)).called(1);
      verify(mockDataRepository.getItems())
          .called(1); // Only expecting one call after clearing
    });

    test('addItem should handle error', () async {
      // Arrange
      when(mockDataRepository.insertItem(any))
          .thenThrow(Exception('Test error'));
      viewModel = HomeViewModel(repository: mockDataRepository);
      clearInteractions(mockDataRepository); // Clear the initial load calls

      // Act
      await viewModel.addItem('Test Title', 'Test Description');

      // Assert
      expect(viewModel.error, isNotNull);
      expect(viewModel.isLoading, false);
    });

    test('loadItems should update items list on success', () async {
      // Arrange
      final mockItems = [
        Item(
          id: 1,
          title: 'Test',
          description: 'Test Description',
          createdAt: DateTime.now(),
        ),
      ];
      when(mockDataRepository.getItems()).thenAnswer((_) async => mockItems);
      viewModel = HomeViewModel(repository: mockDataRepository);
      clearInteractions(mockDataRepository);

      // Act
      await viewModel.loadItems();

      // Assert
      expect(viewModel.items, equals(mockItems));
      expect(viewModel.error, isNull);
    });

    test('addItem should handle repository error', () async {
      // Arrange
      when(mockDataRepository.insertItem(any))
          .thenThrow(Exception('Failed to insert'));
      viewModel = HomeViewModel(repository: mockDataRepository);
      clearInteractions(mockDataRepository);

      // Act
      await viewModel.addItem('Test', 'Description');

      // Assert
      expect(viewModel.error, isNotNull);
      expect(viewModel.isLoading, false);
      verify(mockDataRepository.insertItem(any)).called(1);
    });
  });
}
