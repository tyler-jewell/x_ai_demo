import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  static const _itemsKey = 'items';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<List<Map<String, dynamic>>> getItems() async =>
      (await _prefs)
          .getStringList(_itemsKey)
          ?.map((item) => json.decode(item) as Map<String, dynamic>)
          .toList() ??
      [];

  Future<void> insertItem(Map<String, dynamic> item) async {
    final prefs = await _prefs;
    final items = prefs.getStringList(_itemsKey) ?? [];
    await prefs.setStringList(_itemsKey, [...items, json.encode(item)]);
  }
}
