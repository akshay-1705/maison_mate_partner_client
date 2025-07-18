import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/post_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/email_verification_model.dart';
import 'package:maison_mate/screens/home_screen.dart';
import 'package:maison_mate/services/logout_service.dart';
import 'package:maison_mate/services/web_socket_service.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Future<ApiResponse>? futureData;
  FlutterSecureStorage storage = const FlutterSecureStorage();
  static String apiUrl = '$baseApiUrl/partners/onboarding/email_verification';
  var snackbarShown = false;
  WebSocketService webSocketService = WebSocketService();
  IOWebSocketChannel? channel;
  final String channelName = 'EmailVerificationChannel';
  String? token;

  @override
  void initState() {
    super.initState();
    authToken();
    initializeWebSocket();
  }

  Future<void> initializeWebSocket() async {
    channel = await webSocketService.connect();
    webSocketService.subscribe(channel, channelName);
    setState(() {});
  }

  Future<String?> authToken() async {
    token = (await storage.read(key: authTokenKey))!;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (channel == null) {
      return Scaffold(appBar: appBar(context, storage), body: Container());
    } else {
      return Scaffold(
          appBar: appBar(context, storage),
          //  This is very risky. DO NOT CHANGE ANYTHING WITHOUT APPROVAL
          body: StreamBuilder(
              stream: channel?.stream,
              builder: (context, snapshot) {
                pingStatus();
                checkIfVerified(snapshot, context);
                return renderData(context);
              }));
    }
  }

  void pingStatus() {
    if (token != null) {
      webSocketService.sendMessage(channel, channelName, {});
    }
  }

  void checkIfVerified(AsyncSnapshot<dynamic> snapshot, BuildContext context) {
    if (snapshot.data != null) {
      var data = jsonDecode(snapshot.data);
      var decodedMessage = data['message'];

      if (decodedMessage is Map && decodedMessage['email_verified']) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
        });
      }
    }
  }

  Widget renderData(BuildContext context) {
    final EmailVerificationModel model =
        Provider.of<EmailVerificationModel>(context);
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
                            'A verification link will be sent to your email address. Please click the link to verify your email.',
                            style: TextStyle(
                                fontSize: 18, color: Color(themeColor)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          (futureData != null)
                              ? PostClient.futureBuilder(
                                  model,
                                  futureData!,
                                  "Send",
                                  () async {
                                    onSubmitCallback(model);
                                  },
                                  () {
                                    if (!snackbarShown) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(MySnackBar(
                                                  message:
                                                      'Email verification link sent',
                                                  error: false)
                                              .getSnackbar());
                                      snackbarShown = true;
                                    }
                                  },
                                )
                              : MyForm.submitButton("Send", () async {
                                  onSubmitCallback(model);
                                }),
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

  void onSubmitCallback(EmailVerificationModel model) {
    model.setIsSubmitting(true);
    snackbarShown = false;
    futureData = PostClient.request(apiUrl, {}, model, (response) async {});
  }
}

AppBar appBar(BuildContext context, FlutterSecureStorage storage) {
  return AppBar(
    actions: <Widget>[
      IconButton(
        icon: const Icon(
          Icons.logout_outlined,
          color: Color(themeColor),
        ),
        onPressed: () {
          LogoutService.logout(context);
        },
      ),
    ],
  );
}
