import 'dart:io';

import 'package:flutter/material.dart';

class InsuranceModel extends ChangeNotifier {
  File? selectedFile;
  String fileName = '';
  bool isSubmitting = false;
  String minimum2MillionInsurancePresent = '';
  String minimum1MillionInsurancePresent = '';
  Color minimum2MillionInsurancePresentColor = Colors.black;
  Color minimum1MillionInsurancePresentColor = Colors.black;

  void setSelectedFile(File value) {
    selectedFile = value;
    fileName = selectedFile!.path.split('/').last;
    notifyListeners();
  }

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }

  void setMinimum2MillionInsurancePresent(String value) {
    minimum2MillionInsurancePresent = value;
    notifyListeners();
  }

  void setMinimum1MillionInsurancePresent(String value) {
    minimum1MillionInsurancePresent = value;
    notifyListeners();
  }

  void setMinimum1MillionInsurancePresentColor(Color value) {
    minimum1MillionInsurancePresentColor = value;
    notifyListeners();
  }

  void setMinimum2MillionInsurancePresentColor(Color value) {
    minimum2MillionInsurancePresentColor = value;
    notifyListeners();
  }
}
