import 'package:flutter_app/src/core/domain/models/item.dart';
import 'package:flutter_app/src/features/home/presentation/view_models/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks/mock_database_service.mocks.dart';

void main() {
  late MockDataRepository mockRepository;
  late HomeViewModel viewModel;
  final testItem = Item(
    id: 1,
    title: 'Test',
    description: 'Description',
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockRepository = MockDataRepository();
    when(mockRepository.getItems()).thenAnswer((_) async => []);
  });

  tearDown(() => viewModel.dispose());

  Future<void> initViewModel() async {
    viewModel = HomeViewModel(repository: mockRepository);
    await Future.delayed(Duration.zero);
  }

  group('HomeViewModel', () {
    test('loads items on initialization', () async {
      await initViewModel();
      verify(mockRepository.getItems()).called(1);
    });

    test('loadItems updates state correctly', () async {
      when(mockRepository.getItems()).thenAnswer((_) async => [testItem]);
      await initViewModel();
      clearInteractions(mockRepository);

      await viewModel.loadItems();

      expect(viewModel.items, [testItem]);
      expect(viewModel.error, isNull);
      expect(viewModel.isLoading, false);
      verify(mockRepository.getItems()).called(1);
    });

    test('loadItems handles error', () async {
      when(mockRepository.getItems()).thenThrow('Test error');
      await initViewModel();
      clearInteractions(mockRepository);

      await viewModel.loadItems();

      expect(viewModel.error, isNotNull);
      expect(viewModel.isLoading, false);
    });

    test('addItem creates and saves item', () async {
      when(mockRepository.insertItem(any)).thenAnswer((_) async {});
      when(mockRepository.getItems()).thenAnswer((_) async => [testItem]);

      await initViewModel();
      clearInteractions(mockRepository);

      await viewModel.addItem('New Title', 'New Description');

      verify(mockRepository.insertItem(any)).called(1);
      verify(mockRepository.getItems()).called(1);
      expect(viewModel.items, [testItem]);
    });
  });
}
