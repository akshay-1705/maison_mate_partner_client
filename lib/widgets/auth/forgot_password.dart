import 'package:flutter/material.dart';
import 'package:maison_mate/network/client/post_client.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:maison_mate/provider/auth/forgot_password_model.dart';
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
  var snackbarShown = false;
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
        absorbing: model.isSubmitting,
        child: GestureDetector(
            onTap: () {
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
                        MyForm.requiredEmailField('Email*', emailController),
                      const SizedBox(height: 20),
                      if (model.successMessage.isNotEmpty)
                        MyForm.submitButton('Sign In', () {
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
                                () {
                                  if (!snackbarShown) {
                                    model.setSuccessMessage(
                                        'Password reset instructions sent to your email');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        MySnackBar(
                                                message:
                                                    'Password reset instructions sent to your email',
                                                error: false)
                                            .getSnackbar());
                                    snackbarShown = true;
                                  }
                                },
                              )
                            : MyForm.submitButton("Send Email", () async {
                                onSubmitCallback(model);
                              }),
                    ])))));
  }

  void onSubmitCallback(ForgotPasswordModel model) {
    if (!model.isSubmitting && _formKey.currentState!.validate()) {
      snackbarShown = false;
      model.setIsSubmitting(true);
      const String forgotPasswordUrl = '$baseApiUrl/partner/forgot_password';
      var formData = {
        'email': emailController.text,
      };
      futureData = PostClient.request(
          forgotPasswordUrl, formData, model, (response) async {});
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
