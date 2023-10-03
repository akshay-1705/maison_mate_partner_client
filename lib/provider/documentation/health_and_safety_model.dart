import 'package:flutter/material.dart';

class HealthAndSafetyModel extends ChangeNotifier {
  bool isSubmitting = false;
  String accidentsInFiveYears = '';
  String noticeInFiveYears = '';
  String injuryInThreeYears = '';
  String damageByCompanyEmployee = '';
  String everBankrupt = '';

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }

  void setAccidentsInFiveYears(String value) {
    accidentsInFiveYears = value;
    notifyListeners();
  }

  void setNoticeInFiveYears(String value) {
    noticeInFiveYears = value;
    notifyListeners();
  }

  void setInjuryInThreeYears(String value) {
    injuryInThreeYears = value;
    notifyListeners();
  }

  void setDamageByCompanyEmployee(String value) {
    damageByCompanyEmployee = value;
    notifyListeners();
  }

  void setEverBankrupt(String value) {
    everBankrupt = value;
    notifyListeners();
  }
}
