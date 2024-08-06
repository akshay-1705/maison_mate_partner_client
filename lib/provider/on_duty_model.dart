import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OnDutyModel extends ChangeNotifier {
  bool onDuty = true;
  bool offDutyAllowed = false;
  int todayActivity = 0;
  int originalActivity = 0;
  bool showOffer = false;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  void setOnDuty(bool value) {
    onDuty = value;
    notifyListeners();
  }

  void setOffDutyAllowed(bool value) {
    offDutyAllowed = value;
    notifyListeners();
  }

  void setTodayActivity(int value) async {
    todayActivity = value;
    notifyListeners();
    await secureStorage.write(key: 'todayActivity', value: value.toString());
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
