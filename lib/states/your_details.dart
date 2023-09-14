import 'package:flutter/material.dart';

class YourDetails with ChangeNotifier {
  String _selectedValue = 'Limited'; // Default value

  String get selectedValue => _selectedValue;

  set selectedValue(String value) {
    _selectedValue = value;
    notifyListeners();
  }
}
