import 'package:flutter/material.dart';
import 'package:maison_mate/states/forgot_password.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maison_mate/network/response/api_response.dart';

class ResetPasswordWidget extends StatefulWidget {
  const ResetPasswordWidget({Key? key}) : super(key: key);

  @override
  State<ResetPasswordWidget> createState() => _ResetPasswordWidgetState();
}

class _ResetPasswordWidgetState extends State<ResetPasswordWidget> {
  TextEditingController emailController = TextEditingController();
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
                child: ListView(children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(height: 65),
                  header(),
                  const SizedBox(height: 40),
                  if (model.errorMessage.isNotEmpty) errorMessage(model),
                  if (model.successMessage.isNotEmpty) successMessage(model),
                  emailField(emailController),
                  const SizedBox(height: 20),
                  forgotPasswordButton(model),
                ]))));
  }

  Container forgotPasswordButton(ForgotPasswordModel model) {
    return Container(
        height: 50,
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: model.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                onPressed: () async {
                  if (!model.isLoading) {
                    model.setErrorMessage('');
                    model.setsuccessMessage('');
                    await forgotPassword(model);
                  }
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Color(0xff2cc48a))),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xff2cc48a))),
                child: const Text('Forgot',
                    style: TextStyle(color: Colors.white))));
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
                      color: Color(0xff000000),
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

  Opacity emailField(TextEditingController emailController) {
    return Opacity(
        opacity: 0.3,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              labelText: 'Email*',
            ),
          ),
        ));
  }

  Center errorMessage(ForgotPasswordModel model) {
    return Center(
        child: Text(
      model.errorMessage,
      style: const TextStyle(color: Colors.red),
    ));
  }

  Center successMessage(ForgotPasswordModel model) {
    return Center(
        child: Text(
      model.successMessage,
      style: const TextStyle(color: Colors.green),
    ));
  }

  Future<void> forgotPassword(ForgotPasswordModel model) async {
    model.setLoading(true);
    const String baseURL =
        'http://192.168.1.3:3000/api/v1/partner/forgot_password';
    const String secretHeader = '1e802fb752174d1c3145cc657872b0a1';

    try {
      final response = await http.post(
        Uri.parse(baseURL),
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
      } else if (response.statusCode == 404) {
        model.setsuccessMessage('');
        model.setErrorMessage(
            ApiResponse.fromJson(jsonDecode(response.body)).message);
      } else {
        model.setsuccessMessage('');
        model.setErrorMessage('Network error');
      }
    } catch (e) {
      model.setsuccessMessage('');
      model.setErrorMessage('Network error');
    } finally {
      model.setLoading(false);
    }
  }
}
