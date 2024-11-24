import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/core/domain/models/item.dart';
import 'package:flutter_app/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_app/features/home/presentation/view_models/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../../mocks/mock_item_service.mocks.dart';

void main() {
  late MockItemService mockService;
  late List<Item> testItems;

  setUp(() {
    mockService = MockItemService();
    testItems = [
      Item(
        id: 1,
        title: 'Test Item 1',
        description: 'Description 1',
        createdAt: DateTime.now(),
      ),
      Item(
        id: 2,
        title: 'Test Item 2',
        description: 'Description 2',
        createdAt: DateTime.now(),
      ),
    ];
  });

  Future<void> pumpHomeScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => HomeViewModel(service: mockService),
          child: const HomeScreen(),
        ),
      ),
    );
  }

  group('HomeScreen', () {
    testWidgets('shows loading indicator when loading', (tester) async {
      // Set up a delayed response to ensure we can catch the loading state
      final completer = Completer<List<Item>>();
      when(mockService.getItems()).thenAnswer((_) => completer.future);

      await pumpHomeScreen(tester);
      await tester.pump(); // Pump once to start the loading

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the future and verify the loading indicator goes away
      completer.complete(testItems);
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows items when loaded', (tester) async {
      when(mockService.getItems()).thenAnswer((_) async => testItems);

      await pumpHomeScreen(tester);
      await tester.pumpAndSettle();

      expect(find.text('Test Item 1'), findsOneWidget);
      expect(find.text('Test Item 2'), findsOneWidget);
    });

    testWidgets('shows error when loading fails', (tester) async {
      when(mockService.getItems())
          .thenAnswer((_) async => throw Exception('Test error'));

      await pumpHomeScreen(tester);
      await tester.pumpAndSettle();

      expect(find.textContaining('Error:'), findsOneWidget);
    });

    testWidgets('shows empty message when no items', (tester) async {
      when(mockService.getItems()).thenAnswer((_) async => []);

      await pumpHomeScreen(tester);
      await tester.pumpAndSettle();

      expect(find.text('No items yet'), findsOneWidget);
    });
  });
}
