import 'package:flutter/material.dart';
import 'package:maison_mate/network/response/user_response.dart';

class FavouritesModel extends ChangeNotifier {
  List<UserResponse> filteredUsers = [];

  void removeItemFromFilteredUsers(UserResponse user) {
    filteredUsers.removeWhere((u) => u == user);
    notifyListeners();
  }

  void setFilteredUsers(List<UserResponse> users) {
    filteredUsers = users;
    notifyListeners();
  }
}
