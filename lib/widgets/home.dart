import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/screens/email_verification_screen.dart';
import 'package:maison_mate/screens/onboarding_screen.dart';
import 'package:maison_mate/widgets/dashboard.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late Future<ApiResponse> futureData;
  static String apiUrl = '$baseApiUrl/partners/onboarding/status';

  @override
  void initState() {
    super.initState();
    futureData = GetClient.fetchData(apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return GetRequestFutureBuilder<dynamic>(
      future: futureData,
      apiUrl: apiUrl,
      builder: (context, data) {
        if (!data.emailVerified) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const EmailVerificationScreen()),
            );
          });
          return Container();
        } else if (data.status == 'verified') {
          return const DashboardWidget();
        } else {
          return Column(
            children: [
              if (data.status == 'submitted') ...[
                SizedBox(height: screenHeight * 0.15),
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
                      fontWeight: FontWeight.w200,
                    ),
                    textAlign: TextAlign.center, // Align text to center
                  ),
                ),
              ] else ...[
                SizedBox(height: screenHeight * 0.3),
                completeOnboarding(screenHeight)
              ],
            ],
          );
        }
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

  Column completeOnboarding(double screenHeight) {
    String buttonText = 'Proceed';
    return Column(
      children: [
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
        SizedBox(height: screenHeight * 0.02),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingScreen()),
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
      ],
    );
  }
}
