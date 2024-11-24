import 'package:flutter_app/core/data/datasources/item_data_source.dart';
import 'package:flutter_app/core/domain/models/item.dart';
import 'package:flutter_app/core/domain/repositories/item_repository.dart';

class ItemRepositoryImpl implements ItemRepository {
  final ItemDataSource _dataSource;

  const ItemRepositoryImpl({required ItemDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<Item>> getItems() async =>
      (await _dataSource.getItems()).map(Item.fromJson).toList();

  @override
  Future<void> insertItem(Item item) => _dataSource.insertItem(item.toJson());
}
