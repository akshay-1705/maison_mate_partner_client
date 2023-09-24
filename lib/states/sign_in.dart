import 'package:flutter/foundation.dart';

class SignInModel extends ChangeNotifier {
  bool isLoading = false;
  String errorMessage = '';

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String message) {
    errorMessage = message;
    notifyListeners();
  }

  void clearStates() {
    errorMessage = '';
    isLoading = false;
    notifyListeners();
  }
}
