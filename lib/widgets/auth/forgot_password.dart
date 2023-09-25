import 'package:flutter/material.dart';
import 'package:maison_mate/network/request/post_client.dart';
import 'package:maison_mate/shared/forms.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:maison_mate/states/forgot_password.dart';
import 'package:provider/provider.dart';
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
  Future<ApiResponse>? futureData;
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
                      if (model.successMessage.isEmpty)
                        requiredEmailField('Email*', emailController),
                      const SizedBox(height: 20),
                      if (model.successMessage.isNotEmpty)
                        submitButton('Sign In', () {
                          model.clearStates();
                          Navigator.of(context).pop();
                        }),
                      if (model.successMessage.isEmpty)
                        (futureData != null)
                            ? PostClient.futureBuilder(
                                model,
                                futureData!,
                                "Send Email",
                                () async {
                                  onSubmitCallback(model);
                                },
                                () {},
                              )
                            : submitButton("Send Email", () async {
                                onSubmitCallback(model);
                              }),
                    ])))));
  }

  void onSubmitCallback(ForgotPasswordModel model) {
    if (!model.isSubmitting && _formKey.currentState!.validate()) {
      const String forgotPasswordUrl = '$baseApiUrl/partner/forgot_password';
      var formData = {
        'email': emailController.text,
      };
      futureData =
          PostClient.request(forgotPasswordUrl, formData, model, (response) {
        ScaffoldMessenger.of(context).showSnackBar(
            MySnackBar(message: response.message, error: false).getSnackbar());
        model.setSuccessMessage(response.message);
      });
    }
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
}
