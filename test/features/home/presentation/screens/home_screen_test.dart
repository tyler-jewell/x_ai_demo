import 'package:flutter/material.dart';
import 'package:flutter_app/src/core/domain/models/item.dart';
import 'package:flutter_app/src/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_app/src/features/home/presentation/view_models/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../../mocks/mock_database_service.mocks.dart';

void main() {
  late MockDataRepository mockRepository;

  setUp(() {
    mockRepository = MockDataRepository();
  });

  Widget createHomeScreen() {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => HomeViewModel(repository: mockRepository),
        child: const HomeScreen(),
      ),
    );
  }

  group('HomeScreen', () {
    testWidgets('should show loading indicator when loading',
        (WidgetTester tester) async {
      // Arrange
      when(mockRepository.getItems()).thenAnswer(
        (_) async => [],
      );

      // Act
      await tester.pumpWidget(createHomeScreen());

      // Assert - verify loading indicator appears initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the loading to complete
      await tester.pumpAndSettle();
    });

    testWidgets('should show items when loaded', (WidgetTester tester) async {
      // Arrange
      final mockItems = [
        Item(
          id: 1,
          title: 'Test Title',
          description: 'Test Description',
          createdAt: DateTime.now(),
        ),
      ];
      when(mockRepository.getItems()).thenAnswer((_) async => mockItems);

      // Act
      await tester.pumpWidget(createHomeScreen());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('should show add item dialog when FAB is tapped',
        (WidgetTester tester) async {
      // Arrange
      when(mockRepository.getItems()).thenAnswer((_) async => []);

      // Act
      await tester.pumpWidget(createHomeScreen());
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Add New Item'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('should show error message when loading fails',
        (WidgetTester tester) async {
      // Arrange
      when(mockRepository.getItems())
          .thenThrow(Exception('Failed to load items'));

      // Act
      await tester.pumpWidget(createHomeScreen());
      await tester.pumpAndSettle();

      // Assert
      expect(
          find.text('Error: Exception: Failed to load items'), findsOneWidget);
    });

    testWidgets('should show empty state message when no items',
        (WidgetTester tester) async {
      // Arrange
      when(mockRepository.getItems()).thenAnswer((_) async => []);

      // Act
      await tester.pumpWidget(createHomeScreen());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No items yet'), findsOneWidget);
    });
  });
}
