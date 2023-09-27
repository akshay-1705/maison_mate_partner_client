import 'package:flutter/material.dart';

class OnboardingModel extends ChangeNotifier {
  int currentIndex = 0;

  void setCurrentIndex(value) {
    currentIndex = value;
    notifyListeners();
  }
}
