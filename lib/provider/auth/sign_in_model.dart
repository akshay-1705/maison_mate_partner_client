import 'package:flutter/material.dart';

class SignInModel extends ChangeNotifier {
  bool isSubmitting = false;

  void clearStates() {
    isSubmitting = false;
    notifyListeners();
  }

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }
}
