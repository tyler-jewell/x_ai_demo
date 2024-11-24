import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  static const String _itemsKey = 'items';

  Future<List<Map<String, dynamic>>> getItems() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = prefs.getStringList(_itemsKey) ?? [];
    return itemsJson
        .map((item) => json.decode(item) as Map<String, dynamic>)
        .toList();
  }

  Future<void> insertItem(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = prefs.getStringList(_itemsKey) ?? [];
    itemsJson.add(json.encode(item));
    await prefs.setStringList(_itemsKey, itemsJson);
  }
}
