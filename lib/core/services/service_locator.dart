import 'package:flutter_app/core/services/item_service.dart';
import 'package:flutter_app/features/home/presentation/view_models/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ServiceLocator {
  static final providers = [
    Provider(
      create: (_) async => ItemService(
        await SharedPreferences.getInstance(),
      ),
    ),
    ChangeNotifierProxyProvider<ItemService, HomeViewModel>(
      create: (context) => HomeViewModel(
        service: context.read<ItemService>(),
      ),
      update: (_, service, previous) =>
          previous ?? HomeViewModel(service: service),
    ),
  ];
}
