import 'package:flutter/material.dart';
import 'package:maison_mate/widgets/home.dart';
import 'package:maison_mate/widgets/onboarding/documentation.dart';
import 'package:maison_mate/widgets/onboarding/your_details.dart';
import 'package:maison_mate/constants.dart';

class OnboardingWidget extends StatefulWidget {
  const OnboardingWidget({Key? key}) : super(key: key);

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(themeColor), // Match the color scheme
        title: const Text(
          'Onboarding',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.home_rounded),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeWidget()),
            );
          },
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          YourDetailsSection(),
          DocumentationSection(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Your Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Documentation',
          ),
        ],
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          if (_currentIndex == 0) {
            // Show "Next" button on Your Details section
            return FloatingActionButton(
              backgroundColor:
                  const Color(themeColor), // Match the color scheme
              onPressed: () {
                setState(() {
                  _currentIndex = 1; // Navigate to the Documentation section
                });
              },
              child: const Icon(Icons.arrow_forward),
            );
          } else {
            // Show "Back" button on Documentation section
            return FloatingActionButton(
              backgroundColor:
                  const Color(themeColor), // Match the color scheme
              onPressed: () {
                setState(() {
                  _currentIndex = 0; // Navigate back to Your Details section
                });
              },
              child: const Icon(Icons.arrow_back),
            );
          }
        },
      ),
    );
  }
}
