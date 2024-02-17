import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/post_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/phone_verification_model.dart';
import 'package:maison_mate/services/logout_service.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:maison_mate/screens/verify_otp.dart';
import 'package:provider/provider.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  Future<ApiResponse>? postFutureData;
  static String apiUrl = '$baseApiUrl/send_otp';

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

  @override
  Widget build(BuildContext context) {
    final PhoneVerificationModel model =
        Provider.of<PhoneVerificationModel>(context);
    return Scaffold(
      appBar: appBar(context, storage),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: AbsorbPointer(
                    absorbing: model.isSubmitting,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.17),
                        const Icon(
                          Icons.phone,
                          color: Color(themeColor),
                          size: 50, // Responsive sizing
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Phone Verification',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(themeColor),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: const Text(
                                '+44 ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            // const SizedBox(width: 10),
                            Expanded(
                              child: MyForm.requiredTextField(
                                  "Phone Number*",
                                  phoneNumberController,
                                  false,
                                  TextInputType.number),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        (postFutureData != null)
                            ? PostClient.futureBuilder(
                                model,
                                postFutureData!,
                                "Send OTP",
                                () async {
                                  onSubmitCallback(model);
                                },
                                () {
                                  if (model.otpSent) {
                                    model.setOtpSent(false);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => VerifyOtp(
                                              phoneNumber:
                                                  phoneNumberController.text)),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        MySnackBar(
                                                message: 'OTP sent',
                                                error: false)
                                            .getSnackbar());
                                  }
                                },
                              )
                            : MyForm.submitButton("Send OTP", () async {
                                onSubmitCallback(model);
                              }),
                      ],
                    )),
              ))),
    );
  }

  void onSubmitCallback(PhoneVerificationModel model) {
    var phoneNumber = phoneNumberController.text;
    if (phoneNumber.length == 10) {
      model.setIsSubmitting(true);
      var formData = {
        'phone_number': phoneNumberController.text,
      };
      postFutureData =
          PostClient.request(apiUrl, formData, model, (response) async {
        model.setOtpSent(true);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          MySnackBar(message: 'Invalid phone number', error: true)
              .getSnackbar());
    }
  }
}
