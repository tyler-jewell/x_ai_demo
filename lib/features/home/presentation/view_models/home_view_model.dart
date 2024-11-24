import 'package:flutter_app/core/domain/models/item.dart';
import 'package:flutter_app/core/domain/repositories/item_repository.dart';
import 'package:flutter_app/core/presentation/view_models/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  final ItemRepository _repository;
  List<Item> _items = [];

  HomeViewModel({required ItemRepository repository})
      : _repository = repository {
    loadItems();
  }

  List<Item> get items => List.unmodifiable(_items);

  Future<void> loadItems() async {
    final result = await handleAsync(_repository.getItems);
    if (result != null) _items = result;
  }

  Future<void> addItem(String title, String description) async {
    final item = Item(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );

    await handleAsync(() async {
      await _repository.insertItem(item);
      _items = await _repository.getItems();
    });
  }
}
