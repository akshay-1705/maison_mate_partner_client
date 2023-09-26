import 'package:flutter/material.dart';
import 'package:maison_mate/states/onboarding.dart';
import 'package:maison_mate/widgets/home.dart';
import 'package:maison_mate/widgets/onboarding/documentation.dart';
import 'package:maison_mate/widgets/onboarding/your_details.dart';
import 'package:maison_mate/constants.dart';
import 'package:provider/provider.dart';
import 'package:maison_mate/states/your_details.dart';

class OnboardingWidget extends StatefulWidget {
  final bool yourDetailsSection;
  const OnboardingWidget({Key? key, required this.yourDetailsSection})
      : super(key: key);

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => YourDetails()),
          ChangeNotifierProvider(create: (_) => Onboarding()),
        ],
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
                  style: TextStyle(color: Color(secondaryColor)),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.home_rounded),
                  color: const Color(secondaryColor),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const HomeWidget()),
                    );
                  },
                ),
              ),
              body: buildBody(),
            )));
  }

  Widget buildBody() {
    return Consumer<Onboarding>(builder: (context, cart, child) {
      final Onboarding model = Provider.of<Onboarding>(context);
      if (widget.yourDetailsSection) {
        model.currentIndex = 1;
      }
      return Column(
        children: [
          _buildCustomTabBar(model),
          Expanded(
            child: IndexedStack(
              index: model.currentIndex,
              children: [
                YourDetailsSection(onboardingModel: model),
                const DocumentationSection(),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCustomTabBar(Onboarding model) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(secondaryColor),
        boxShadow: [
          BoxShadow(
            color: Color(themeColor),
            blurRadius: 2,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTabItem(0, Icons.person, 'Your Details', model),
          _buildTabItem(1, Icons.library_books, 'Documentation', model),
        ],
      ),
    );
  }

  Widget _buildTabItem(
      int index, IconData icon, String label, Onboarding model) {
    final isSelected = index == model.currentIndex;
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
