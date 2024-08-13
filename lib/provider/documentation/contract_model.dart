import 'package:flutter/material.dart';

class ContractModel extends ChangeNotifier {
  bool isSubmitting = false;
  bool agree = false;

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }

  void setAgree(bool value) {
    agree = value;
    notifyListeners();
  }
}
