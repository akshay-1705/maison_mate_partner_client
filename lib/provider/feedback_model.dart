import 'package:flutter/material.dart';

class FeedbackModel extends ChangeNotifier {
  bool isSubmitting = false;

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }
}
