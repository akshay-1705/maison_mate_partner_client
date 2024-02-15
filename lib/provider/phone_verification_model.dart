import 'package:flutter/material.dart';

class PhoneVerificationModel extends ChangeNotifier {
  bool isSubmitting = false;
  bool otpSent = false;

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }

  void setOtpSent(bool value) {
    otpSent = value;
    notifyListeners();
  }
}
