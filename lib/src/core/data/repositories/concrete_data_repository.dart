import '../../domain/models/item.dart';
import '../local/database_service.dart';
import './data_repository.dart';

class ConcreteDataRepository implements DataRepository {
  final DatabaseService _database;

  const ConcreteDataRepository({required DatabaseService database})
      : _database = database;

  @override
  Future<List<Item>> getItems() async =>
      (await _database.getItems()).map(Item.fromJson).toList();

  @override
  Future<void> insertItem(Item item) => _database.insertItem(item.toJson());
}
