import 'package:flutter/material.dart';
import 'package:maison_mate/widgets/home.dart';
import 'package:maison_mate/widgets/onboarding/documentation.dart';
import 'package:maison_mate/widgets/onboarding/your_details.dart';
import 'package:maison_mate/constants.dart';
import 'package:provider/provider.dart';
import 'package:maison_mate/states/your_details.dart';

class OnboardingWidget extends StatefulWidget {
  const OnboardingWidget({Key? key}) : super(key: key);

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  final int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => YourDetails(),
        child: GestureDetector(
            onTap: () {
              // Dismiss the keyboard when tapped outside of any focused input field
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor:
                    const Color(themeColor), // Match the color scheme
                title: const Text(
                  'Onboarding',
                  style: TextStyle(color: Colors.white),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.home_rounded),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const HomeWidget()),
                    );
                  },
                ),
              ),
              body: headerTabs(),
            )));
  }

  Column headerTabs() {
    return Column(
      children: [
        _buildCustomTabBar(),
        Expanded(
          child: IndexedStack(
            index: _currentIndex,
            children: const [
              YourDetailsSection(),
              DocumentationSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTabItem(0, Icons.person, 'Your Details'),
          _buildTabItem(1, Icons.library_books, 'Documentation'),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label) {
    final isSelected = index == _currentIndex;
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(themeColor) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(themeColor) : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(themeColor) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
