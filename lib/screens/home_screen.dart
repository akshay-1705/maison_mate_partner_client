import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/widgets/auth/sign_in.dart';
import 'package:maison_mate/widgets/home.dart';
import 'package:maison_mate/widgets/payments.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentIndex = 0;
  static const storage = FlutterSecureStorage();
  final List<Widget> pages = [
    const HomeWidget(),
    const PaymentsWidget(),
    const HomeWidget(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, storage),
      body: SingleChildScrollView(child: pages[currentIndex]),
      bottomNavigationBar: bottomNavigation(),
    );
  }

  Widget bottomNavigation() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
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

  AppBar header(BuildContext context, FlutterSecureStorage storage) {
    return AppBar(
      backgroundColor: const Color(themeColor), // Header background color
      title: const Text(
        'Maison Mate',
        style: TextStyle(
          color: Color(secondaryColor), // Text color
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [logout(context, storage)],
    );
  }

  Widget logout(BuildContext context, FlutterSecureStorage storage) {
    return IconButton(
      icon: const Icon(
        Icons.logout_outlined,
        color: Color(secondaryColor),
      ),
      onPressed: () {
        Future<bool> confirm = CustomAppBar.showConfirmationDialog(
            context, "Are you sure you want to Logout?");

        confirm.then((value) {
          if (value) {
            storage.delete(key: authTokenKey);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignInWidget()));
          }
        });
      },
    );
  }
}
