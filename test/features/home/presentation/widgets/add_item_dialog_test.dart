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

  Widget createDialog() {
    return MaterialApp(
      home: ChangeNotifierProvider.value(
        value: viewModel,
        child: const Material(child: AddItemDialog()),
      ),
    );
  }

  setUp(() {
    mockRepository = MockDataRepository();
    when(mockRepository.getItems()).thenAnswer((_) async => []);
    viewModel = HomeViewModel(repository: mockRepository);
  });

  group('AddItemDialog', () {
    testWidgets('validates empty fields', (tester) async {
      await tester.pumpWidget(createDialog());
      await tester.tap(find.text('Add'));
      await tester.pump();

      expect(find.text('Please enter a title'), findsOneWidget);
      expect(find.text('Please enter a description'), findsOneWidget);
    });

    testWidgets('submits valid form', (tester) async {
      when(mockRepository.insertItem(any)).thenAnswer((_) async {});
      await tester.pumpWidget(createDialog());

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Title'), 'Test Title');
      await tester.enterText(find.widgetWithText(TextFormField, 'Description'),
          'Test Description');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      verify(mockRepository.insertItem(any)).called(1);
      expect(find.byType(AddItemDialog), findsNothing);
    });

    testWidgets('closes on cancel', (tester) async {
      await tester.pumpWidget(createDialog());
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AddItemDialog), findsNothing);
    });
  });
}
