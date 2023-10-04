import 'package:flutter/material.dart';

class DocumentationModel extends ChangeNotifier {
  bool canWorkInUK = false;
  bool notHaveCriminalOffence = false;
  bool agree = false;
  bool pendingDocuments = false;
  bool isSubmitting = false;

  void setCanWorkInUK(value) {
    canWorkInUK = value;
    notifyListeners();
  }

  void setNotHaveCriminalOffence(value) {
    notHaveCriminalOffence = value;
    notifyListeners();
  }

  void setAgree(value) {
    agree = value;
    notifyListeners();
  }

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }
}
