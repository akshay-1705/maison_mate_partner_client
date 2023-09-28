import 'dart:io';

import 'package:flutter/material.dart';

class EmployeesModel extends ChangeNotifier {
  File? selectedFile;
  String fileName = '';
  bool isSubmitting = false;
  String employeesPresent = '';
  String minimum5MillionInsurancePresent = '';
  Color employeesPresentColor = Colors.black;
  Color minimum5MillionInsurancePresentColor = Colors.black;
  String epochString = '';

  void setSelectedFile(File value) {
    selectedFile = value;
    fileName = selectedFile!.path.split('/').last;
    notifyListeners();
  }

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }

  void setEmployeesPresent(String value) {
    employeesPresent = value;
    notifyListeners();
  }

  void setMinimum5MillionInsurancePresent(String value) {
    minimum5MillionInsurancePresent = value;
    notifyListeners();
  }

  void setMinimum5MillionInsurancePresentColor(Color value) {
    minimum5MillionInsurancePresentColor = value;
    notifyListeners();
  }

  void setEmployeesPresentColor(Color value) {
    employeesPresentColor = value;
    notifyListeners();
  }
}
