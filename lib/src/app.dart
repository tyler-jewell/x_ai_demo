import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/service_locator.dart';
import 'features/home/presentation/screens/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ServiceLocator.providers,
      child: MaterialApp(
        title: 'Flutter MVVM App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
