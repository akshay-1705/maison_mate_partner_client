import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/widgets/auth/sign_in.dart';
import 'package:maison_mate/widgets/onboarding/onboarding.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late Future<ApiResponse> futureData;
  static const String apiUrl = '$baseApiUrl/partners/onboarding/status';

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
              if (data.documentation == true) ...[
                const SizedBox(height: 110),
                onboardingComplete(),
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: const Text(
                    'Your submitted documents are being analysed by our officials',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center, // Align text to center
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.center,
                  child: const Text(
                    'we will update you once the acceptance process completes',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center, // Align text to center
                  ),
                )
              ] else ...[
                completeOnboarding(data.yourDetailsSection)
              ],
            ],
          )),
          // bottomNavigationBar: bottomNavigation(),
        );
      },
    );
  }

  Widget onboardingComplete() {
    return Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/analysing_documents.jpg',
          width: 250,
          height: 250,
        ));
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
            ).then((value) {
              setState(() {
                futureData = GetClient.fetchData(apiUrl);
              });
            });
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
        Icons.logout_outlined,
        color: Color(secondaryColor),
      ),
      onPressed: () async {
        bool confirm = await CustomAppBar.showConfirmationDialog(
            context, "Are you sure you want to Logout?");
        if (confirm) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            storage.delete(key: authTokenKey);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignInWidget()));
          });
        }
      },
    );
  }
}
