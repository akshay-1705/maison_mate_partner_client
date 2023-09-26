import 'package:flutter/material.dart';

class Onboarding extends ChangeNotifier {
  int currentIndex = 0;

  void setCurrentIndex(value) {
    currentIndex = value;
    notifyListeners();
  }
}
