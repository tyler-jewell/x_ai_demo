import 'package:flutter_app/core/domain/models/item.dart';

abstract class ItemRepository {
  Future<List<Item>> getItems();
  Future<void> insertItem(Item item);
}
