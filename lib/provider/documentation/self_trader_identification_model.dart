import 'dart:io';

import 'package:flutter/material.dart';

class SelfTraderIdentificationModel extends ChangeNotifier {
  File? selectedFile1;
  String fileName1 = '';
  File? selectedFile2;
  String fileName2 = '';
  bool isSubmitting = false;
  String vatRegistered = 'No';
  String epochString = DateTime.now().millisecondsSinceEpoch.toString();

  void setSelectedFile1(File value) {
    selectedFile1 = value;
    fileName1 = selectedFile1!.path.split('/').last;
    notifyListeners();
  }

  void setSelectedFile2(File value) {
    selectedFile2 = value;
    fileName2 = selectedFile2!.path.split('/').last;
    notifyListeners();
  }

  void setVatRegistered(String value) {
    vatRegistered = value;
    notifyListeners();
  }

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }
}
