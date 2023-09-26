import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/widgets/auth/sign_in.dart';
import 'package:maison_mate/widgets/onboarding/onboarding.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late Future<ApiResponse> futureData;
  static const String apiUrl = '$baseApiUrl/partners/onboarding_status';

  @override
  void initState() {
    super.initState();
    futureData = GetClient.fetchData(apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    return GetRequestFutureBuilder<dynamic>(
      future: futureData,
      builder: (context, data) {
        return Scaffold(
          body: SingleChildScrollView(
              child: Column(
            children: [
              header(),
              completeOnboarding(data.yourDetailsSection),
            ],
          )),
          bottomNavigationBar: bottomNavigation(),
        );
      },
    );
  }

  BottomNavigationBar bottomNavigation() {
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

  Column completeOnboarding(yourDetailsSection) {
    String buttonText = yourDetailsSection ? 'Resume' : 'Proceed';
    return Column(
      children: [
        const SizedBox(height: 240),
        Container(
          alignment: Alignment.bottomLeft,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: const Text(
                'Please complete the onboarding process to open the doors of opportunities.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center, // Align text to center
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OnboardingWidget(yourDetailsSection: yourDetailsSection)),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color(themeColor), // Match the color scheme
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Color(secondaryColor),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 240),
      ],
    );
  }

  Container header() {
    return Container(
      color: const Color(themeColor), // Header background color
      padding: const EdgeInsets.only(top: 50.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
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
          Account(),
        ],
      ),
    );
  }
}

class Account extends StatelessWidget {
  static const storage = FlutterSecureStorage();
  const Account({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.account_circle_outlined,
        color: Color(secondaryColor),
      ),
      onPressed: () async {
        await storage.delete(key: authTokenKey);
        if (!context.mounted) {
          return;
        }
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SignInWidget()));
      },
    );
  }
}
