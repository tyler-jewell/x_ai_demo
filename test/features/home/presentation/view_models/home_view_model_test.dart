import 'package:flutter_app/core/domain/models/item.dart';
import 'package:flutter_app/features/home/presentation/view_models/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks/mock_item_service.mocks.dart';

void main() {
  late MockItemService mockService;
  late HomeViewModel viewModel;
  final testItem = Item(
    id: 1,
    title: 'Test',
    description: 'Description',
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockService = MockItemService();
    when(mockService.getItems()).thenAnswer((_) async => []);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('HomeViewModel', () {
    test('loads items on initialization', () async {
      when(mockService.getItems()).thenAnswer((_) async => []);
      viewModel = HomeViewModel(service: mockService);
      await Future.delayed(const Duration(milliseconds: 50));
      verify(mockService.getItems()).called(1);
    });

    test('loadItems updates state correctly', () async {
      when(mockService.getItems()).thenAnswer((_) async => [testItem]);
      viewModel = HomeViewModel(service: mockService);
      await Future.delayed(const Duration(milliseconds: 50));

      clearInteractions(mockService);
      when(mockService.getItems()).thenAnswer((_) async => [testItem]);

      await viewModel.loadItems();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(viewModel.items, [testItem]);
      expect(viewModel.error, isNull);
      expect(viewModel.isLoading, false);
      verify(mockService.getItems()).called(1);
    });

    test('loadItems handles error', () async {
      when(mockService.getItems()).thenAnswer((_) async => []);
      viewModel = HomeViewModel(service: mockService);
      await Future.delayed(const Duration(milliseconds: 50));

      clearInteractions(mockService);
      when(mockService.getItems()).thenThrow('Test error');

      await viewModel.loadItems();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(viewModel.error, isNotNull);
      expect(viewModel.isLoading, false);
    });

    test('addItem creates and saves item', () async {
      when(mockService.getItems()).thenAnswer((_) async => []);
      viewModel = HomeViewModel(service: mockService);
      await Future.delayed(const Duration(milliseconds: 50));

      clearInteractions(mockService);
      when(mockService.addItem(any)).thenAnswer((_) async {});
      when(mockService.getItems()).thenAnswer((_) async => [testItem]);

      await viewModel.addItem('New Title', 'New Description');
      await Future.delayed(const Duration(milliseconds: 50));

      verify(mockService.addItem(any)).called(1);
      verify(mockService.getItems()).called(1);
      expect(viewModel.items, [testItem]);
    });
  });
}
