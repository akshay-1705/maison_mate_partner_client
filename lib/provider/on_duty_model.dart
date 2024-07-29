import 'package:flutter/material.dart';

class OnDutyModel extends ChangeNotifier {
  bool onDuty = true;
  bool offDutyAllowed = false;
  int todayActivity = 0;
  int originalActivity = 0;
  bool showOffer = false;

  void setOnDuty(bool value) {
    onDuty = value;
    notifyListeners();
  }

  void setOffDutyAllowed(bool value) {
    offDutyAllowed = value;
    notifyListeners();
  }

  void setTodayActivity(int value) {
    todayActivity = value;
    notifyListeners();
  }

  void setOriginalActivity(int value) {
    originalActivity = value;
    notifyListeners();
  }

  void setShowOffer(bool value) {
    showOffer = value;
    notifyListeners();
  }
}
