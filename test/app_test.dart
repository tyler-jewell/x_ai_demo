import 'package:flutter/material.dart';
import 'package:flutter_app/src/app.dart';
import 'package:flutter_app/src/features/home/presentation/view_models/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mocks/mock_database_service.mocks.dart';

void main() {
  testWidgets('App initializes with correct theme and home screen',
      (tester) async {
    final mockRepository = MockDataRepository();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<MockDataRepository>.value(value: mockRepository),
          ChangeNotifierProvider(
            create: (_) => HomeViewModel(repository: mockRepository),
          ),
        ],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('MVVM Demo'), findsOneWidget);
  });
}
