import 'package:flutter/material.dart';

class OnDutyModel extends ChangeNotifier {
  bool onDuty = true;
  bool offDutyAllowed = false;

  void setOnDuty(bool value) {
    onDuty = value;
    notifyListeners();
  }

  void setOffDutyAllowed(bool value) {
    offDutyAllowed = value;
    notifyListeners();
  }
}
