import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => HomePageState(),
        child: MaterialApp(
          title: 'Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        ),
      );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Demo'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
          child: Consumer<HomePageState>(
            builder: (context, state, _) => Text(
              state.counter.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read<HomePageState>().increment(),
          child: const Icon(Icons.add),
        ),
      );
}

class HomePageState extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }
}
