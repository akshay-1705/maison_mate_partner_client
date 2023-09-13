import 'package:flutter/material.dart';
import 'package:maison_mate/widgets/home.dart';

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
        backgroundColor: const Color(0xff2cc48a), // Match the color scheme
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
                  const Color(0xff2cc48a), // Match the color scheme
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
                  const Color(0xff2cc48a), // Match the color scheme
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

class YourDetailsSection extends StatelessWidget {
  const YourDetailsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Add your personal details form fields here
          // Example:
          // Add more form fields as needed
        ],
      ),
    );
  }
}

class DocumentationSection extends StatelessWidget {
  const DocumentationSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Add insurance form fields here
        ],
      ),
    );
  }
}
