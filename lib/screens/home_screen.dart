import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/widgets/auth/sign_in.dart';
import 'package:maison_mate/widgets/home.dart';

class HomeScreen extends StatelessWidget {
  static const storage = FlutterSecureStorage();

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [header(context, storage), const HomeWidget()]),
      bottomNavigationBar: bottomNavigation(),
    );
  }

  Widget bottomNavigation() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payment),
          label: 'Payments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
      ],
      selectedItemColor: const Color(themeColor), // Selected tab color
      unselectedItemColor: Colors.grey, // Unselected tab color
    );
  }

  Widget header(BuildContext context, FlutterSecureStorage storage) {
    return Container(
      color: const Color(themeColor), // Header background color
      padding: const EdgeInsets.only(top: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Maison Mate', // Company name
              style: TextStyle(
                color: Color(secondaryColor), // Text color
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          logout(context, storage),
        ],
      ),
    );
  }

  Widget logout(BuildContext context, FlutterSecureStorage storage) {
    return IconButton(
      icon: const Icon(
        Icons.logout_outlined,
        color: Color(secondaryColor),
      ),
      onPressed: () async {
        bool confirm = await CustomAppBar.showConfirmationDialog(
            context, "Are you sure you want to Logout?");
        if (confirm) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            storage.delete(key: authTokenKey);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignInWidget()));
          });
        }
      },
    );
  }
}
