import '../../../../core/data/repositories/data_repository.dart';
import '../../../../core/domain/models/item.dart';
import '../../../../core/presentation/view_models/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  final DataRepository _repository;
  List<Item> _items = [];

  HomeViewModel({required DataRepository repository})
      : _repository = repository {
    loadItems();
  }

  List<Item> get items => _items;

  Future<void> loadItems() async {
    final items = await handleAsync(() => _repository.getItems());
    if (items != null) {
      _items = items;
    }
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
      await loadItems();
    });
  }
}
