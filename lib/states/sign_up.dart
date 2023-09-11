import 'package:flutter/foundation.dart';

class SignUpModel extends ChangeNotifier {
  bool isLoading = false;
  String errorMessage = '';
  bool acceptedTerms = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String message) {
    errorMessage = message;
    notifyListeners();
  }

  void setAcceptedTerms(bool value) {
    acceptedTerms = value;
    notifyListeners();
  }
}
