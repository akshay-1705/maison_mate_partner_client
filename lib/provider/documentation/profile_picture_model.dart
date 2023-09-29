import 'dart:io';

import 'package:flutter/material.dart';

class ProfilePictureModel extends ChangeNotifier {
  File? selectedFile;
  String fileName = '';
  bool isSubmitting = false;

  void setSelectedFile(File value) {
    selectedFile = value;
    fileName = selectedFile!.path.split('/').last;
    notifyListeners();
  }

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }
}
