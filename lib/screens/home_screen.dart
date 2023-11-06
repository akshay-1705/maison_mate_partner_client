import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/screens/account_screen.dart';
import 'package:maison_mate/widgets/favourites.dart';
import 'package:maison_mate/widgets/home.dart';
import 'package:maison_mate/widgets/jobs/my_jobs.dart';

class HomeScreen extends StatefulWidget {
  final int? index;
  const HomeScreen({super.key, this.index});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentIndex = 0;
  final List<Widget> pages = [
    const HomeWidget(),
    const MyJobsWidget(),
    const FavouritesWidget(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: header(context),
          body: WillPopScope(
              onWillPop: () async {
                return Future.value(false);
              },
              child: SingleChildScrollView(child: pages[currentIndex])),
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
          icon: Icon(Icons.search),
          label: 'Find Jobs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_repair_service),
          label: 'My Jobs',
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
