import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/shared/my_form.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final TextEditingController otpController = TextEditingController();

  AppBar appBar(BuildContext context) {
    return AppBar();
  }

  @override
  Widget build(BuildContext context) {
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
                    child: const Text(
                      'We have sent an OTP to +44 740271181. Please enter the OTP to verify your phone number.',
                      style: TextStyle(
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
                MyForm.submitButton("Verify", () async {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
