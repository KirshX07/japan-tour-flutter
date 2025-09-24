import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/planner_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlannerProvider with ChangeNotifier {
  List<PlannerItem> _plannerItems = [];
  static const _plannerKey = 'planner_items';

  PlannerProvider() {
    _loadPlannerItems();
  }

  List<PlannerItem> get plannerItems => _plannerItems;

  /// Groups items by date for the UI, sorted chronologically.
  Map<DateTime, List<PlannerItem>> get itemsByDate {
    final Map<DateTime, List<PlannerItem>> groupedItems = {};
    for (var item in _plannerItems) {
      // Normalize the date to ignore time, ensuring items on the same day are grouped.
      final dateOnly = DateTime(item.date.year, item.date.month, item.date.day);
      if (groupedItems[dateOnly] == null) {
        groupedItems[dateOnly] = [];
      }
      groupedItems[dateOnly]!.add(item);
    }
    // Sort the map by date keys.
    var sortedKeys = groupedItems.keys.toList()..sort();
    return {for (var key in sortedKeys) key: groupedItems[key]!};
  }

  bool isInPlanner(PlannerItem item) {
    return _plannerItems.contains(item);
  }

  Future<void> addItem(PlannerItem item) async {
    if (!isInPlanner(item)) {
      _plannerItems.add(item);
      await _savePlannerItems();
      notifyListeners();
    }
  }

  Future<void> removeItem(PlannerItem item) async {
    _plannerItems.removeWhere((i) => i.id == item.id);
    await _savePlannerItems();
    notifyListeners();
  }

  Future<void> updateItemDate(PlannerItem item, DateTime newDate) async {
    // Create a new item with the updated date
    final newItem = PlannerItem(place: item.place, date: newDate);

    // Check if an item for the same place already exists on the new date,
    // excluding the current item itself from the check.
    if (_plannerItems.any((i) => i.id == newItem.id && i.id != item.id)) {
      // An item for this place already exists on the target date. Do nothing.
      return;
    }

    // Find the index of the old item to replace it.
    final index = _plannerItems.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _plannerItems[index] = newItem;
      await _savePlannerItems();
      notifyListeners();
    }
  }

  Future<void> _savePlannerItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> plannerJson = _plannerItems.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_plannerKey, plannerJson);
  }

  Future<void> _loadPlannerItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? plannerJson = prefs.getStringList(_plannerKey);
    if (plannerJson != null) {
      _plannerItems = plannerJson.map((jsonString) => PlannerItem.fromJson(jsonDecode(jsonString))).toList();
    }
    notifyListeners();
  }
}