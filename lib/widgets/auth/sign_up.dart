import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maison_mate/widgets/auth/sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:maison_mate/states/sign_up.dart';
import 'package:maison_mate/widgets/auth/terms_and_conditions_page.dart';
import 'package:provider/provider.dart';
import 'package:maison_mate/network/response/api_response.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: renderForm(context),
    );
  }

  renderForm(BuildContext context) {
    final model = Provider.of<SignUpModel>(context);
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
                      const SizedBox(height: 80),
                      header(),
                      const SizedBox(height: 40),
                      if (model.errorMessage.isNotEmpty) errorMessage(model),
                      nameFields(),
                      emailField(),
                      passwordFields(),
                      const SizedBox(height: 10),
                      termsAndConditions(model),
                      const SizedBox(height: 10),
                      signUpButton(model),
                      signInOption(context, model),
                    ])))));
  }

  Center errorMessage(SignUpModel model) {
    return Center(
        child: Text(
      model.errorMessage,
      style: const TextStyle(color: Colors.red),
    ));
  }

  Row signInOption(BuildContext context, SignUpModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("Already have an account?"),
        TextButton(
            child: Text(
              'Sign In',
              style:
                  TextStyle(fontSize: 17, color: Colors.black.withOpacity(0.6)),
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

  Container signUpButton(SignUpModel model) {
    return Container(
        height: 50,
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: model.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                onPressed: () async {
                  if (!model.isLoading && _formKey.currentState!.validate()) {
                    if (model.acceptedTerms) {
                      model.setErrorMessage('');
                      await signUp(model);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please accept the Terms & Conditions and Privacy Policy'),
                        ),
                      );
                    }
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
                child: const Text('Sign Up',
                    style: TextStyle(color: Colors.white))));
  }

  Future<void> signUp(SignUpModel model) async {
    model.setLoading(true);
    const String baseURL = 'http://192.168.1.3:3000/api/v1/partner/signup';
    const String secretHeader = '1e802fb752174d1c3145cc657872b0a1';

    try {
      final response = await http.post(
        Uri.parse(baseURL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Secret-Header': secretHeader
        },
        body: jsonEncode(<String, String>{
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'password_confirmation': confirmPasswordController.text
        }),
      );

      if (response.statusCode == 200) {
        // Successful login logic here
        model.setErrorMessage('');
        // print(ApiResponse.fromJson(jsonDecode(response.body)).data.token);
      } else if (response.statusCode == 418) {
        model.setErrorMessage(
            ApiResponse.fromJson(jsonDecode(response.body)).message);
      } else {
        model.setErrorMessage('Network error');
      }
    } catch (e) {
      model.setErrorMessage('Network error');
    } finally {
      model.setLoading(false);
    }
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
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
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
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
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
                padding: const EdgeInsets.all(10),
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
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is required'; // Return an error message if the field is empty
                    } else if (value != passwordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Passwords do not match'),
                        ),
                      );
                      return '';
                    } else if (value.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Password must be at least 6 characters long'),
                        ),
                      );
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

  Opacity emailField() {
    return Opacity(
        opacity: 0.5,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Email is required'; // Return an error message if the field is empty
              } else if (!RegExp(
                      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                  .hasMatch(value)) {
                return 'Email is invalid';
              }
              return null; // Return null if the field is valid
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              labelText: 'Email*',
            ),
          ),
        ));
  }

  Row nameFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Opacity(
              opacity: 0.5,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: firstNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'First Name is required'; // Return an error message if the field is empty
                    }
                    return null; // Return null if the field is valid
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'First Name*',
                  ),
                ),
              )),
        ),
        Flexible(
          child: Opacity(
              opacity: 0.5,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Last Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Last Name is required'; // Return an error message if the field is empty
                    }
                    return null; // Return null if the field is valid
                  },
                ),
              )),
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
                      color: Color(0xff000000),
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
