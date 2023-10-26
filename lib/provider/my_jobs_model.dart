import 'package:flutter/material.dart';
import 'package:maison_mate/network/response/api_response.dart';

class MyJobsModel extends ChangeNotifier {
  late Future<ApiResponse> dataFutureData;
  int activeFilter = 0;

  void setDataFutureData(Future<ApiResponse> value) {
    dataFutureData = value;
    notifyListeners();
  }

  void setActiveFilter(int value) {
    activeFilter = value;
    notifyListeners();
  }
}
