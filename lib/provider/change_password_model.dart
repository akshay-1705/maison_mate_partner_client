import 'package:flutter/material.dart';

class ChangePasswordModel extends ChangeNotifier {
  bool isSubmitting = false;

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }
}
