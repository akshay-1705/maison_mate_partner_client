import 'package:flutter/material.dart';

class StartJobModel extends ChangeNotifier {
  bool isLoading = false;
  bool isSubmitting = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }
}
