import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/post_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/verify_otp_model.dart';
import 'package:maison_mate/screens/home_screen.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:provider/provider.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final TextEditingController otpController = TextEditingController();
  Future<ApiResponse>? postFutureData;
  static String apiUrl = '$baseApiUrl/partners/register_number';
  var snackbarShown = false;

  AppBar appBar(BuildContext context) {
    return AppBar();
  }

  @override
  Widget build(BuildContext context) {
    final VerifyOtpModel model = Provider.of<VerifyOtpModel>(context);
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.17,
                ),
                const Icon(
                  Icons.verified_user,
                  color: Color(themeColor),
                  size: 50, // Responsive sizing
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(themeColor),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      'We have sent an OTP to +44 ${widget.phoneNumber}. Please enter the OTP to verify your phone number.',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                        color: Color(themeColor),
                      ),
                    )),
                MyForm.requiredTextField(
                  "OTP*",
                  otpController,
                  false,
                  TextInputType.number,
                ),
                const SizedBox(height: 20),
                (postFutureData != null)
                    ? PostClient.futureBuilder(
                        model,
                        postFutureData!,
                        "Verify",
                        () async {
                          onSubmitCallback(model);
                        },
                        () {
                          if (!snackbarShown) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ));
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                MySnackBar(message: 'Verified', error: false)
                                    .getSnackbar());
                            snackbarShown = true;
                          }
                        },
                      )
                    : MyForm.submitButton("Verify", () async {
                        onSubmitCallback(model);
                      }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSubmitCallback(VerifyOtpModel model) {
    var otp = otpController.text;
    snackbarShown = false;
    var formData = {'otp': otp, 'phone_number': widget.phoneNumber};
    postFutureData =
        PostClient.request(apiUrl, formData, model, (response) async {});
  }
}
