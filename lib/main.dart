import 'package:flutter/material.dart';
import 'package:flutter_app/app.dart';
import 'package:provider/provider.dart';

import 'core/services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: ServiceLocator.providers,
      child: const App(),
    ),
  );
}
