import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:maison_mate/widgets/auth/sign_in.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  late Future<ApiResponse> futureData;
  Future<ApiResponse>? resentfutureData;
  static const String apiUrl =
      '$baseApiUrl/partners/onboarding/email_verification';

  @override
  void initState() {
    super.initState();
    futureData = GetClient.fetchData(apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    const storage = FlutterSecureStorage();
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.logout_outlined,
                color: Color(themeColor),
              ),
              onPressed: () {
                Future<bool> confirm = CustomAppBar.showConfirmationDialog(
                    context, "Are you sure you want to Logout?");

                confirm.then((value) {
                  if (value) {
                    storage.delete(key: authTokenKey);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInWidget()));
                  }
                });
              },
            ),
          ],
        ),
        body: GetRequestFutureBuilder<dynamic>(
            future: futureData,
            apiUrl: apiUrl,
            builder: (context, data) {
              return renderData(context);
            }));
  }

  Widget renderData(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(secondaryColor),
              Color(secondaryColor)
            ], // Customize your gradient colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: screenHeight * 0.13,
                    ),
                    CircleAvatar(
                      radius: constraints.maxWidth * 0.1, // Responsive sizing
                      backgroundColor: const Color(themeColor),
                      child: Icon(
                        Icons.email,
                        color: const Color(secondaryColor),
                        size: constraints.maxWidth * 0.1, // Responsive sizing
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Email Verification',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(themeColor),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(secondaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'A verification link has been sent to your email address. Please click the link to verify your email.',
                            style: TextStyle(
                                fontSize: 18, color: Color(themeColor)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          (resentfutureData != null)
                              ? GetRequestFutureBuilder<dynamic>(
                                  future: resentfutureData,
                                  apiUrl: apiUrl,
                                  builder: (context, data) {
                                    return resentButton(context);
                                  })
                              : resentButton(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  ElevatedButton resentButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          resentfutureData = GetClient.fetchData(apiUrl);
        });
        resentfutureData?.then((response) {
          ScaffoldMessenger.of(context).showSnackBar(
              MySnackBar(message: 'Email verification link sent', error: false)
                  .getSnackbar());
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color(themeColor),
        ),
      ),
      child: const Text(
        'Resend Verification Email',
        style: TextStyle(
          fontSize: 18,
          color: Color(secondaryColor),
        ),
      ),
    );
  }
}
