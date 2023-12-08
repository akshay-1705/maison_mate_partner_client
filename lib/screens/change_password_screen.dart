import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/put_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/change_password_model.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  Future<ApiResponse>? futureData;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ChangePasswordModel>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: AbsorbPointer(
            absorbing: model.isSubmitting,
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                        key: _formKey,
                        child: ListView(children: <Widget>[
                          const SizedBox(height: 90),
                          header(),
                          const SizedBox(height: 20),
                          MyForm.requiredTextField('Current Password*',
                              currentPasswordController, true),
                          const SizedBox(height: 7),
                          MyForm.requiredTextField(
                              'New Password*', passwordController, true),
                          const SizedBox(height: 7),
                          MyForm.requiredTextField('Confirm Password*',
                              confirmPasswordController, true),
                          const SizedBox(height: 30),
                          (futureData != null)
                              ? PutClient.futureBuilder(
                                  model,
                                  futureData!,
                                  "Change",
                                  () async {
                                    onSubmitCallback(context, model);
                                  },
                                  () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              : MyForm.submitButton("Change", () async {
                                  onSubmitCallback(context, model);
                                }),
                        ]))))));
  }

  void onSubmitCallback(BuildContext context, ChangePasswordModel model) {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
            MySnackBar(message: 'Passwords do not match', error: true)
                .getSnackbar());
      } else if (currentPasswordController.text.length < 6 ||
          passwordController.text.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                message: 'Password must be at least 6 characters long',
                error: true)
            .getSnackbar());
      } else {
        model.setIsSubmitting(true);
        String apiUrl = '$baseApiUrl/partners/password';

        var formData = {
          'current_password': currentPasswordController.text,
          'new_password': confirmPasswordController.text,
        };

        futureData =
            PutClient.request(apiUrl, formData, model, (response) async {});
      }
    }
  }

  Column header() {
    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Change Password',
              style: TextStyle(
                  color: Color(themeColor),
                  fontWeight: FontWeight.w400,
                  fontSize: 30),
            )),
      ],
    );
  }
}
