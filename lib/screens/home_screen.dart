import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/widgets/account_widget.dart';
import 'package:maison_mate/widgets/favourites.dart';
import 'package:maison_mate/widgets/home.dart';
import 'package:maison_mate/widgets/my_jobs/my_jobs.dart';

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
    const AccountWidget(),
  ];
  bool val = false;

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
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
      ],
      selectedItemColor: const Color(themeColor),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
    );
  }

  AppBar header(BuildContext context) {
    if (currentIndex == 0) {
      return onOffDuty();
    } else {
      return logo();
    }
  }

  AppBar onOffDuty() {
    return AppBar(
      backgroundColor: const Color(themeColor),
      actions: [
        Expanded(
          child: Center(
            child: Container(
              margin:
                  const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 10.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.beach_access,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8.0),
                  Switch(
                    value: val,
                    onChanged: (value) {
                      setState(() {
                        val = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                  const SizedBox(width: 8.0),
                  const Icon(
                    Icons.work,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  AppBar logo() {
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
    );
  }
}
