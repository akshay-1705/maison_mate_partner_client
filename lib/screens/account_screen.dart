import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/screens/area_covered_screen.dart';
import 'package:maison_mate/screens/change_password_screen.dart';
import 'package:maison_mate/screens/profile_screen.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/widgets/auth/sign_in.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  static const storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5.0),
            customListTile(
              icon: Icons.person,
              title: 'Profile',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
            ),
            const Divider(),
            customListTile(
              icon: Icons.location_on,
              title: 'Area Covered',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AreaCoveredScreen()));
              },
            ),
            const Divider(),
            customListTile(
              icon: Icons.lock,
              title: 'Change Password',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen()));
              },
            ),
            const Divider(),
            customListTile(
              icon: Icons.headset_mic,
              title: 'Support',
              onTap: () {
                showSupportDialog(context);
              },
            ),
            const Divider(),
            customListTile(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {
                logoutCallback(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void logoutCallback(BuildContext context) {
    Future<bool> confirm = CustomAppBar.showConfirmationDialog(
        context, "Are you sure you want to Logout?");

    confirm.then((value) {
      if (value) {
        storage.delete(key: authTokenKey);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SignInWidget()));
      }
    });
  }

  Widget customListTile(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 16.0),
            Text(title),
          ],
        ),
      ),
    );
  }

  void showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Support'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'If you need assistance, please contact us via email:',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'jatinrawat43@gmail.com',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
