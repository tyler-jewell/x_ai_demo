import '../../domain/models/item.dart';
import './data_repository.dart';

class InMemoryDataRepository implements DataRepository {
  final _items = <Item>[];

  @override
  Future<List<Item>> getItems() async => _items;

  @override
  Future<void> insertItem(Item item) async => _items.add(item);
}
