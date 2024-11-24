import 'package:flutter_app/src/core/data/local/database_service.dart';

import '../../domain/models/item.dart';
import './data_repository.dart';

class ConcreteDataRepository implements DataRepository {
  final DatabaseService database;

  ConcreteDataRepository({required this.database});

  @override
  Future<List<Item>> getItems() async {
    final results = await database.getItems();
    return results.map((map) => Item.fromJson(map)).toList();
  }

  @override
  Future<void> insertItem(Item item) async {
    await database.insertItem(item.toJson());
  }
}
