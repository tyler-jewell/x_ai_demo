import 'dart:convert';

import 'package:flutter_app/core/domain/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemService {
  static const _itemsKey = 'items';
  final SharedPreferences _prefs;

  ItemService(this._prefs);

  Future<List<Item>> getItems() async {
    final items = _prefs.getStringList(_itemsKey) ?? [];
    return items.map((item) => Item.fromJson(json.decode(item))).toList();
  }

  Future<void> addItem(Item item) async {
    final items = _prefs.getStringList(_itemsKey) ?? [];
    await _prefs
        .setStringList(_itemsKey, [...items, json.encode(item.toJson())]);
  }
}
