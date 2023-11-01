import 'package:flutter/material.dart';

class NearbyJobDetailsModel extends ChangeNotifier {
  bool isSubmitting = false;

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }
}
