import 'dart:convert';

import 'package:flutter_app/core/data/datasources/item_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalItemDataSource implements ItemDataSource {
  static const _itemsKey = 'items';

  final SharedPreferences prefs;

  LocalItemDataSource({required this.prefs});

  @override
  Future<List<Map<String, dynamic>>> getItems() async {
    final items = prefs.getStringList(_itemsKey) ?? [];
    return items
        .map((item) => json.decode(item) as Map<String, dynamic>)
        .toList();
  }

  @override
  Future<void> insertItem(Map<String, dynamic> item) async {
    final items = prefs.getStringList(_itemsKey) ?? [];
    await prefs.setStringList(_itemsKey, [...items, json.encode(item)]);
  }
}
