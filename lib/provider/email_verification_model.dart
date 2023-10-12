import 'package:flutter/material.dart';

class EmailVerificationModel extends ChangeNotifier {
  bool isSubmitting = false;

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }
}
