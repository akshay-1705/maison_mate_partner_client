import 'package:flutter/material.dart';
import 'package:maison_mate/shared/forms.dart';
import 'package:maison_mate/states/forgot_password.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/constants.dart';

class ResetPasswordWidget extends StatefulWidget {
  const ResetPasswordWidget({Key? key}) : super(key: key);

  @override
  State<ResetPasswordWidget> createState() => _ResetPasswordWidgetState();
}

class _ResetPasswordWidgetState extends State<ResetPasswordWidget> {
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ForgotPasswordModel>(context);
    return Scaffold(
      body: renderModal(emailController, model),
    );
  }

  renderModal(
      TextEditingController emailController, ForgotPasswordModel model) {
    return AbsorbPointer(
        absorbing: model.isLoading,
        child: GestureDetector(
            onTap: () {
              // Dismiss the keyboard when tapped on a non-actionable item
              FocusScope.of(context).unfocus();
            },
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                    key: _formKey,
                    child: ListView(children: [
                      const SizedBox(height: 100),
                      header(),
                      const SizedBox(height: 40),
                      if (model.errorMessage.isNotEmpty) errorMessage(model),
                      if (model.successMessage.isNotEmpty)
                        successMessage(model),
                      if (model.successMessage.isEmpty)
                        requiredEmailField('Email*', emailController),
                      const SizedBox(height: 20),
                      if (model.successMessage.isNotEmpty)
                        submitButton('Sign In', () {
                          model.clearStates();
                          Navigator.of(context).pop();
                        }),
                      if (model.successMessage.isEmpty)
                        model.isLoading
                            ? circularLoader()
                            : submitButton('Send Email', () async {
                                if (!model.isLoading &&
                                    _formKey.currentState!.validate()) {
                                  model.setErrorMessage('');
                                  model.setsuccessMessage('');
                                  await forgotPassword(model);
                                }
                              }),
                    ])))));
  }

  Center successMessage(ForgotPasswordModel model) {
    return Center(
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 2000), // Set your desired duration
        height: model.showSuccessMessage ? 50.0 : 0.0, // Adjust the height
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Color(awesomeColor),
            ),
            const SizedBox(width: 10),
            Text(
              model.successMessage,
              style: const TextStyle(color: Color(awesomeColor)),
            ),
          ],
        ),
      ),
    );
  }

  Column header() {
    return Column(
      children: [
        Align(
            alignment: Alignment.center,
            child: Container(
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                      color: Color(themeColor),
                      fontWeight: FontWeight.w400,
                      fontSize: 30),
                ))),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: const Text(
            "Enter the email address you've used to register with us and we'll send you a reset link!",
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Center errorMessage(ForgotPasswordModel model) {
    return Center(
        child: Text(
      model.errorMessage,
      style: const TextStyle(color: Colors.red),
    ));
  }

  Future<void> forgotPassword(ForgotPasswordModel model) async {
    model.setLoading(true);
    const String forgotPasswordUrl = '$baseApiUrl/partner/forgot_password';

    try {
      final response = await http.post(
        Uri.parse(forgotPasswordUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Secret-Header': secretHeader
        },
        body: jsonEncode(<String, String>{
          'email': emailController.text,
        }),
      );

      if (response.statusCode == 200) {
        model.setErrorMessage('');
        model.setsuccessMessage(
            ApiResponse.fromJson(jsonDecode(response.body)).message);
        emailController.text = '';
        model.showSuccessMessage = true;
      } else if (response.statusCode == 404) {
        model.setsuccessMessage('');
        model.setErrorMessage(
            ApiResponse.fromJson(jsonDecode(response.body)).message);
      } else {
        model.setsuccessMessage('');
        model.setErrorMessage(networkError);
      }
    } catch (e) {
      model.setsuccessMessage('');
      model.setErrorMessage(somethingWentWrong);
    } finally {
      model.setLoading(false);
    }
  }
}
