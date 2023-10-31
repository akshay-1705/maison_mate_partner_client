import 'package:flutter/material.dart';
import 'package:maison_mate/network/response/my_jobs_response.dart';

class MyJobsModel extends ChangeNotifier {
  int activeFilter = -1;
  MyJobsResponse myJobsList = MyJobsResponse([]);
  MyJobsResponse filteredMyJobsList = MyJobsResponse([]);

  void setActiveFilter(int value) {
    activeFilter = value;
    notifyListeners();
  }

  void setMyJobsList(MyJobsResponse value) {
    filteredMyJobsList = value;
    myJobsList = value;
    notifyListeners();
  }

  void setFilteredMyJobsList(MyJobsResponse value) {
    filteredMyJobsList = value;
    notifyListeners();
  }
}
