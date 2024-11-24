import 'package:flutter_app/core/domain/models/item.dart';
import 'package:flutter_app/features/home/presentation/view_models/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks/mock_data_source.mocks.dart';

void main() {
  late MockItemRepository mockRepository;
  late HomeViewModel viewModel;
  final testItem = Item(
    id: 1,
    title: 'Test',
    description: 'Description',
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockRepository = MockItemRepository();
    when(mockRepository.getItems()).thenAnswer((_) async => []);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('HomeViewModel', () {
    test('loads items on initialization', () async {
      when(mockRepository.getItems()).thenAnswer((_) async => []);
      viewModel = HomeViewModel(repository: mockRepository);
      await Future.delayed(const Duration(milliseconds: 50));
      verify(mockRepository.getItems()).called(1);
    });

    test('loadItems updates state correctly', () async {
      when(mockRepository.getItems()).thenAnswer((_) async => [testItem]);
      viewModel = HomeViewModel(repository: mockRepository);
      await Future.delayed(const Duration(milliseconds: 50));

      clearInteractions(mockRepository);
      when(mockRepository.getItems()).thenAnswer((_) async => [testItem]);

      await viewModel.loadItems();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(viewModel.items, [testItem]);
      expect(viewModel.error, isNull);
      expect(viewModel.isLoading, false);
      verify(mockRepository.getItems()).called(1);
    });

    test('loadItems handles error', () async {
      when(mockRepository.getItems()).thenAnswer((_) async => []);
      viewModel = HomeViewModel(repository: mockRepository);
      await Future.delayed(const Duration(milliseconds: 50));

      clearInteractions(mockRepository);
      when(mockRepository.getItems()).thenThrow('Test error');

      await viewModel.loadItems();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(viewModel.error, isNotNull);
      expect(viewModel.isLoading, false);
    });

    test('addItem creates and saves item', () async {
      when(mockRepository.getItems()).thenAnswer((_) async => []);
      viewModel = HomeViewModel(repository: mockRepository);
      await Future.delayed(const Duration(milliseconds: 50));

      clearInteractions(mockRepository);
      when(mockRepository.insertItem(any)).thenAnswer((_) async {});
      when(mockRepository.getItems()).thenAnswer((_) async => [testItem]);

      await viewModel.addItem('New Title', 'New Description');
      await Future.delayed(const Duration(milliseconds: 50));

      verify(mockRepository.insertItem(any)).called(1);
      verify(mockRepository.getItems()).called(1);
      expect(viewModel.items, [testItem]);
    });
  });
}
