abstract class ItemDataSource {
  Future<List<Map<String, dynamic>>> getItems();
  Future<void> insertItem(Map<String, dynamic> item);
}
