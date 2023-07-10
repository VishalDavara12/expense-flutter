import 'package:flutter/material.dart';

class HistoryProvider with ChangeNotifier {
  String _selectedCategory = "All Categories";

  String get selectedCategory => _selectedCategory;

  updateCategoriesValue(String value) {
    _selectedCategory = value;
    notifyListeners();
  }
}
