import 'package:flutter/material.dart';

class YourDetails with ChangeNotifier {
  String _selectedValue = 'Limited'; // Default value
  Set<String> selectedServices = {};
  List<dynamic> selectedPostcodes = [];
  bool formSubmitted = false;
  bool isSubmitting = false;

  String get selectedValue => _selectedValue;

  set selectedValue(String value) {
    _selectedValue = value;
    notifyListeners();
  }

  void addSelectedServices(String service) {
    selectedServices.add(service);
    notifyListeners();
  }

  void removeSelectedServices(String service) {
    selectedServices.remove(service);
    notifyListeners();
  }

  void setFormSubmitted(bool value) {
    formSubmitted = value;
    notifyListeners();
  }

  void setIsSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }
}
