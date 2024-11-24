import 'package:flutter_app/core/domain/models/item.dart';
import 'package:flutter_app/core/presentation/view_models/base_view_model.dart';
import 'package:flutter_app/core/services/item_service.dart';

class HomeViewModel extends BaseViewModel {
  final ItemService _service;
  List<Item> _items = [];

  HomeViewModel({required ItemService service}) : _service = service {
    loadItems();
  }

  List<Item> get items => List.unmodifiable(_items);

  Future<void> loadItems() async {
    final result = await handleAsync(_service.getItems);
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
      await _service.addItem(item);
      _items = await _service.getItems();
    });
  }
}
