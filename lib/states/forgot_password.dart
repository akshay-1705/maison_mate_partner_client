import 'package:flutter/foundation.dart';

class ForgotPasswordModel extends ChangeNotifier {
  bool isLoading = false;
  String errorMessage = '';
  String successMessage = '';
  bool showSuccessMessage = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String message) {
    errorMessage = message;
    notifyListeners();
  }

  void setsuccessMessage(String message) {
    successMessage = message;
    notifyListeners();
  }

  void setShowSuccessMessage(bool value) {
    showSuccessMessage = value;
    notifyListeners();
  }

  void clearStates() {
    isLoading = false;
    errorMessage = '';
    successMessage = '';
    notifyListeners();
  }
}
