import 'package:flutter/material.dart';
import 'package:maison_mate/provider/onboarding_model.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/widgets/onboarding/documentation.dart';
import 'package:maison_mate/widgets/onboarding/your_details.dart';
import 'package:maison_mate/constants.dart';
import 'package:provider/provider.dart';
import 'package:maison_mate/provider/your_details_model.dart';

class OnboardingWidget extends StatefulWidget {
  final bool yourDetailsSection;
  const OnboardingWidget({Key? key, required this.yourDetailsSection})
      : super(key: key);

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  bool tabClicked = false;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => YourDetailsModel()),
          ChangeNotifierProvider(create: (_) => OnboardingModel()),
        ],
        child: WillPopScope(
            onWillPop: () async {
              return Future.value(false);
            },
            child: GestureDetector(
                onTap: () {
                  // Dismiss the keyboard when tapped outside of any focused input field
                  FocusScope.of(context).unfocus();
                },
                child: Scaffold(
                  appBar: CustomAppBar.show(
                      context, "Onboarding", const Icon(Icons.home_rounded)),
                  body: buildBody(),
                ))));
  }

  Widget buildBody() {
    return Consumer<OnboardingModel>(builder: (context, onboarding, child) {
      final OnboardingModel model = Provider.of<OnboardingModel>(context);

      if (!tabClicked && widget.yourDetailsSection) {
        model.currentIndex = 1;
      }

      return Column(
        children: [
          _buildCustomTabBar(model),
          Expanded(
            child: IndexedStack(
              index: model.currentIndex,
              children: [
                model.currentIndex == 0
                    ? YourDetailsSection(onboardingModel: model)
                    : Container(),
                model.currentIndex == 1
                    ? Documentation(onboardingModel: model)
                    : Container(),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCustomTabBar(OnboardingModel model) {
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
      int index, IconData icon, String label, OnboardingModel model) {
    final isSelected = index == model.currentIndex;
    return GestureDetector(
      onTap: () async {
        bool confirm = await CustomAppBar.showConfirmationDialog(
            context, "Are you sure you want to go to '$label' section?");
        if (confirm) {
          tabClicked = true;
          model.setCurrentIndex(index);
        }
      },
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
            if (widget.yourDetailsSection && label == 'Your Details')
              const Icon(
                Icons.done,
                color: Colors.green,
              ),
          ],
        ),
      ),
    );
  }
}
