import '../../domain/models/item.dart';

abstract class DataRepository {
  Future<List<Item>> getItems();
  Future<void> insertItem(Item item);
}
