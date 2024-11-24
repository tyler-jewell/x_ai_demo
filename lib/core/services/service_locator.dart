import 'package:flutter_app/core/data/datasources/local/shared_prefs_data_source.dart';
import 'package:flutter_app/core/data/repositories/item_repository_impl.dart';
import 'package:flutter_app/core/domain/repositories/item_repository.dart';
import 'package:flutter_app/features/home/presentation/view_models/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ServiceLocator {
  static final providers = [
    Provider(create: (_) async {
      final prefs = await SharedPreferences.getInstance();
      return SharedPrefsDataSource(prefs: prefs);
    }),
    ProxyProvider<SharedPrefsDataSource, ItemRepository>(
      update: (_, dataSource, __) => ItemRepositoryImpl(dataSource: dataSource),
    ),
    ChangeNotifierProxyProvider<ItemRepository, HomeViewModel>(
      create: (context) => HomeViewModel(
        repository: context.read<ItemRepository>(),
      ),
      update: (_, repo, previous) =>
          previous ?? HomeViewModel(repository: repo),
    ),
  ];
}
