import 'package:flutter_app/src/core/data/repositories/concrete_data_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/home/presentation/view_models/home_view_model.dart';
import '../data/local/database_service.dart';

class ServiceLocator {
  static List<SingleChildWidget> get providers => [
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
        ProxyProvider<DatabaseService, ConcreteDataRepository>(
          update: (_, db, __) => ConcreteDataRepository(database: db),
        ),
        ChangeNotifierProxyProvider<ConcreteDataRepository, HomeViewModel>(
          create: (context) => HomeViewModel(
            repository: context.read<ConcreteDataRepository>(),
          ),
          update: (context, repository, previous) =>
              previous ?? HomeViewModel(repository: repository),
        ),
      ];
}
