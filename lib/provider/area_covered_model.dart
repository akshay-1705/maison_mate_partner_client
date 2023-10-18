import 'package:flutter/material.dart';

class AreaCoveredModel extends ChangeNotifier {
  bool isSubmitting = false;
  int selectedRadius = 50;

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }

  void setSelectedRadius(int value) {
    selectedRadius = value;
    notifyListeners();
  }
}
