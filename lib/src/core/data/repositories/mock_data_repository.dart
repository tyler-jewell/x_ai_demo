import '../../domain/models/item.dart';
import './data_repository.dart';

class MockDataRepository implements DataRepository {
  final List<Item> _items = [];

  @override
  Future<List<Item>> getItems() async {
    return Future.value(_items);
  }

  @override
  Future<void> insertItem(Item item) async {
    _items.add(item);
  }
}
