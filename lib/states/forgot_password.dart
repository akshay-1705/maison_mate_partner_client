import 'package:flutter/foundation.dart';

class ForgotPasswordModel extends ChangeNotifier {
  bool isLoading = false;
  String successMessage = '';
  bool isSubmitting = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setSuccessMessage(String message) {
    successMessage = message;
    notifyListeners();
  }

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }

  void clearStates() {
    isLoading = false;
    successMessage = '';
    notifyListeners();
  }
}
