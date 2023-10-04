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
        onPressed: () async {
          bool confirm = await showConfirmationDialog(context, title);
          if (confirm) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
          }
        },
      ),
    );
  }

  static Future<bool> showConfirmationDialog(
      BuildContext context, String label) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: Text(label),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel the pop
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm the pop
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  static Future<bool> warning(BuildContext context, String label) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Warning"),
          content: Text(label),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Okay"),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
