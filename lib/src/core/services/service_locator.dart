import 'package:provider/provider.dart';

import '../../features/home/presentation/view_models/home_view_model.dart';
import '../data/local/database_service.dart';
import '../data/repositories/concrete_data_repository.dart';

abstract class ServiceLocator {
  static final providers = [
    Provider(create: (_) => DatabaseService()),
    ProxyProvider<DatabaseService, ConcreteDataRepository>(
      update: (_, db, __) => ConcreteDataRepository(database: db),
    ),
    ChangeNotifierProxyProvider<ConcreteDataRepository, HomeViewModel>(
      create: (context) => HomeViewModel(
        repository: context.read<ConcreteDataRepository>(),
      ),
      update: (_, repo, previous) =>
          previous ?? HomeViewModel(repository: repo),
    ),
  ];
}
