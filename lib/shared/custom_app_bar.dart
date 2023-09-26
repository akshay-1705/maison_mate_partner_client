import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';

class CustomAppBar {
  static AppBar show(BuildContext context, String title, Icon icon) {
    return AppBar(
      backgroundColor: const Color(themeColor), // Match the color scheme
      title: Text(
        title,
        style: const TextStyle(color: Color(secondaryColor), fontSize: 20),
      ),
      leading: IconButton(
        icon: icon,
        color: const Color(secondaryColor),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
