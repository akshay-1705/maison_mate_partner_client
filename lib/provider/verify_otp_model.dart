import 'package:flutter/material.dart';

class VerifyOtpModel extends ChangeNotifier {
  bool isSubmitting = false;

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }
}
