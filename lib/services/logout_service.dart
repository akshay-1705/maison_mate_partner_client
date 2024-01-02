import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/services/device_service.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/widgets/auth/sign_in.dart';

class LogoutService {
  static Future<void> logout(BuildContext context) async {
    Future<bool> confirm = CustomAppBar.showConfirmationDialog(
        context, "Are you sure you want to Logout?");

    confirm.then((value) async {
      if (value) {
        await DeviceService.deleteDevice();
        const storage = FlutterSecureStorage();
        await storage.delete(key: authTokenKey);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const SignInWidget()));
        });
      }
    });
  }
}
