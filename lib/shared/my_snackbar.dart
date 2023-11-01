import 'package:flutter/material.dart';

class MySnackBar {
  final bool error;
  final String? message;
  MySnackBar({this.message, this.error = true});

  SnackBar getSnackbar() {
    return SnackBar(
      content: Text(message ?? ""),
      elevation: 2,
      duration: const Duration(milliseconds: 2000),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      backgroundColor: error ? Colors.red : Colors.green,
    );
  }
}
