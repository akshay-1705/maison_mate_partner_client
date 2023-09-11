import 'package:flutter/foundation.dart';

class ForgotPasswordModel extends ChangeNotifier {
  bool isLoading = false;
  String errorMessage = '';
  String successMessage = '';

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
}
