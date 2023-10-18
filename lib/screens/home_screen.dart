import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/screens/account_screen.dart';
import 'package:maison_mate/widgets/favourites.dart';
import 'package:maison_mate/widgets/home.dart';
import 'package:maison_mate/widgets/payments.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentIndex = 0;
  final List<Widget> pages = [
    const HomeWidget(),
    const PaymentsWidget(),
    const FavouritesWidget(),
  ];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: header(context),
          body: SingleChildScrollView(child: pages[currentIndex]),
          bottomNavigationBar: bottomNavigation(),
        ));
  }

  Widget bottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Home',
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
      selectedItemColor: const Color(themeColor),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
    );
  }

  AppBar header(BuildContext context) {
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
      actions: [accountButton(context)],
    );
  }

  Widget accountButton(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.account_circle,
        color: Color(secondaryColor),
      ),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AccountScreen()));
      },
    );
  }
}
