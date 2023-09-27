import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maison_mate/network/client/post_client.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:maison_mate/widgets/auth/sign_in.dart';
import 'package:maison_mate/provider/auth/sign_up_model.dart';
import 'package:maison_mate/widgets/auth/terms_and_conditions_page.dart';
import 'package:provider/provider.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/widgets/home.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const storage = FlutterSecureStorage();
  Future<ApiResponse>? futureData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: renderForm(context),
    );
  }

  renderForm(BuildContext context) {
    final model = Provider.of<SignUpModel>(context);
    return AbsorbPointer(
        absorbing: model.isSubmitting,
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
                      const SizedBox(height: 80),
                      header(),
                      const SizedBox(height: 40),
                      nameFields(),
                      MyForm.requiredEmailField('Email*', emailController),
                      passwordFields(),
                      const SizedBox(height: 10),
                      termsAndConditions(model),
                      const SizedBox(height: 10),
                      (futureData != null)
                          ? PostClient.futureBuilder(
                              model,
                              futureData!,
                              "Sign Up",
                              () async {
                                onSubmitCallback(model);
                              },
                              () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const HomeWidget()),
                                );
                              },
                            )
                          : MyForm.submitButton("Sign Up", () async {
                              onSubmitCallback(model);
                            }),
                      signInOption(context, model),
                    ])))));
  }

  void onSubmitCallback(SignUpModel model) {
    if (!model.isSubmitting && _formKey.currentState!.validate()) {
      if (model.acceptedTerms) {
        model.setIsSubmitting(true);
        const String signUpUrl = '$baseApiUrl/partner/signup';

        var formData = {
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'password_confirmation': confirmPasswordController.text
        };
        futureData =
            PostClient.request(signUpUrl, formData, model, (response) async {
          var authToken = response.data.token;
          await storage.write(key: authTokenKey, value: authToken);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                message:
                    'Please accept the Terms & Conditions and Privacy Policy',
                error: true)
            .getSnackbar());
      }
    }
  }

  Row signInOption(BuildContext context, SignUpModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("Already have an account?"),
        TextButton(
            child: Text(
              'Sign In',
              style: TextStyle(
                  fontSize: 17,
                  color: const Color(themeColor).withOpacity(0.6)),
            ),
            onPressed: () {
              model.clearStates();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignInWidget()),
              );
            })
      ],
    );
  }

  Row termsAndConditions(SignUpModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Checkbox(
          value: model.acceptedTerms,
          onChanged: (bool? value) {
            model.setAcceptedTerms(value!);
          },
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: "I accept ",
                  style: TextStyle(fontSize: 13),
                ),
                TextSpan(
                  text: "Terms & Conditions",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(awesomeColor),
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Navigate to the Terms of Service page
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const TermsAndConditionsPage(), // Your terms page
                        ),
                      );
                    },
                ),
                const TextSpan(
                  text: " and ",
                  style: TextStyle(fontSize: 13),
                ),
                TextSpan(
                  text: "Privacy Policy",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(awesomeColor),
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Navigate to the Privacy Policy page
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const PrivacyPolicyPage(), // Your privacy page
                        ),
                      );
                    },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Row passwordFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Opacity(
              opacity: 0.5,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is required'; // Return an error message if the field is empty
                    } else if (value != confirmPasswordController.text) {
                      return '';
                    } else if (value.length < 6) {
                      return '';
                    }
                    return null; // Return null if the field is valid
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Password*',
                  ),
                ),
              )),
        ),
        Flexible(
          child: Opacity(
              opacity: 0.5,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is required'; // Return an error message if the field is empty
                    } else if (value != passwordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                              message: 'Passwords do not match', error: true)
                          .getSnackbar());
                      return '';
                    } else if (value.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                              message:
                                  'Password must be at least 6 characters long',
                              error: true)
                          .getSnackbar());
                      return '';
                    }
                    return null; // Return null if the field is valid
                  },
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(fontSize: 13),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Confirm Password*',
                  ),
                ),
              )),
        )
      ],
    );
  }

  Row nameFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: MyForm.requiredTextField('First Name*', firstNameController),
        ),
        Flexible(
          child: MyForm.requiredTextField('Last Name*', lastNameController),
        )
      ],
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
                  'Sign Up',
                  style: TextStyle(
                      color: Color(themeColor),
                      fontWeight: FontWeight.w400,
                      fontSize: 30),
                ))),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: const Text(
            "To access the portal",
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
