import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/home/presentation/view_models/home_view_model.dart';
import 'package:flutter_app/src/features/home/presentation/widgets/add_item_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../../mocks/mock_database_service.mocks.dart';

void main() {
  late MockDataRepository mockRepository;
  late HomeViewModel viewModel;

  setUp(() {
    mockRepository = MockDataRepository();
    when(mockRepository.getItems()).thenAnswer((_) async => []);
    viewModel = HomeViewModel(repository: mockRepository);
  });

  Widget createDialog() {
    return MaterialApp(
      home: ChangeNotifierProvider.value(
        value: viewModel,
        child: const Material(child: AddItemDialog()),
      ),
    );
  }

  group('AddItemDialog', () {
    testWidgets('should validate empty fields', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createDialog());

      // Act
      await tester.tap(find.text('Add'));
      await tester.pump();

      // Assert
      expect(find.text('Please enter a title'), findsOneWidget);
      expect(find.text('Please enter a description'), findsOneWidget);
    });

    testWidgets('should submit form when valid', (WidgetTester tester) async {
      // Arrange
      when(mockRepository.insertItem(any)).thenAnswer((_) async {});
      await tester.pumpWidget(createDialog());

      // Act
      await tester.enterText(find.byType(TextFormField).first, 'Test Title');
      await tester.enterText(
          find.byType(TextFormField).last, 'Test Description');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Assert
      verify(mockRepository.insertItem(any)).called(1);
    });

    testWidgets('should close dialog on cancel', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createDialog());

      // Act
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AddItemDialog), findsNothing);
    });

    testWidgets('should show validation errors on empty submission',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createDialog());

      // Act
      await tester.tap(find.text('Add'));
      await tester.pump();

      // Assert
      expect(find.text('Please enter a title'), findsOneWidget);
      expect(find.text('Please enter a description'), findsOneWidget);
    });

    testWidgets('should validate individual fields',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createDialog());

      // Act - enter only title
      await tester.enterText(find.byType(TextFormField).first, 'Test Title');
      await tester.tap(find.text('Add'));
      await tester.pump();

      // Assert
      expect(find.text('Please enter a title'), findsNothing);
      expect(find.text('Please enter a description'), findsOneWidget);
    });

    testWidgets('should handle submission error', (WidgetTester tester) async {
      // Arrange
      when(mockRepository.insertItem(any)).thenThrow(Exception('Test error'));
      await tester.pumpWidget(createDialog());

      // Act
      await tester.enterText(find.byType(TextFormField).first, 'Test Title');
      await tester.enterText(
          find.byType(TextFormField).last, 'Test Description');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Assert
      verify(mockRepository.insertItem(any)).called(1);
      expect(find.byType(AddItemDialog),
          findsNothing); // Dialog should close even on error
    });
  });
}
