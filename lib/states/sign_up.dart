import 'package:flutter/foundation.dart';

class SignUpModel extends ChangeNotifier {
  bool acceptedTerms = false;
  bool isSubmitting = false;

  void setAcceptedTerms(bool value) {
    acceptedTerms = value;
    notifyListeners();
  }

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }

  void clearStates() {
    acceptedTerms = false;
    isSubmitting = false;
    notifyListeners();
  }
}
