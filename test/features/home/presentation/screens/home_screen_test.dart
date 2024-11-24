import 'package:flutter/material.dart';
import 'package:flutter_app/core/domain/models/item.dart';
import 'package:flutter_app/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_app/features/home/presentation/view_models/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../../mocks/mock_data_source.mocks.dart';

void main() {
  late MockItemRepository mockRepository;

  Widget createHomeScreen() {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => HomeViewModel(repository: mockRepository),
        child: const HomeScreen(),
      ),
    );
  }

  setUp(() {
    mockRepository = MockItemRepository();
    when(mockRepository.getItems()).thenAnswer((_) async => []);
  });

  group('HomeScreen', () {
    testWidgets('shows loading state initially', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows items when loaded', (tester) async {
      final mockItem = Item(
        id: 1,
        title: 'Test Title',
        description: 'Test Description',
        createdAt: DateTime.now(),
      );
      when(mockRepository.getItems()).thenAnswer((_) async => [mockItem]);

      await tester.pumpWidget(createHomeScreen());
      await tester.pumpAndSettle();

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('shows error state', (tester) async {
      when(mockRepository.getItems()).thenThrow('Test error');

      await tester.pumpWidget(createHomeScreen());
      await tester.pumpAndSettle();

      expect(find.textContaining('Error:'), findsOneWidget);
    });

    testWidgets('shows empty state', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.pumpAndSettle();

      expect(find.text('No items yet'), findsOneWidget);
    });

    testWidgets('shows add item dialog', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Add New Item'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });
  });
}
