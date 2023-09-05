import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:maison_mate/login/reset_password.dart';
import 'package:maison_mate/login/sign_up.dart';
import 'package:http/http.dart' as http;

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
            onTap: () {
              // Dismiss the keyboard when tapped on a non-actionable item
              FocusScope.of(context).unfocus();
            },
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    const SizedBox(height: 60),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400,
                              fontSize: 30),
                        )),
                    Container(
                      alignment: Alignment.center,
                      child: const Text('To access the portal'),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    Opacity(
                        opacity: 0.5,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              labelText: 'Email*',
                            ),
                          ),
                        )),
                    Opacity(
                      opacity: 0.5,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            labelText: 'Password*',
                            labelStyle: TextStyle(color: Color(0xff000000)),
                          ),
                          style: const TextStyle(color: Color(0xff000000)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ResetPasswordWidget()),
                        );
                      },
                      child: const Text('Forgot Password?',
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(height: 10),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: isLoading
                            ? const SizedBox(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ) // Show loader while loading
                            : ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                    errorMessage = '';
                                  });

                                  try {
                                    final response = await http.post(
                                      Uri.parse(
                                          'http://192.168.1.7:3000/api/v1/partner/login'),
                                      headers: <String, String>{
                                        'Content-Type':
                                            'application/json; charset=UTF-8',
                                      },
                                      body: jsonEncode(<String, String>{
                                        'email': emailController.text,
                                        'password': passwordController.text,
                                      }),
                                    );

                                    if (response.statusCode == 201) {
                                      // If the server did return a 201 CREATED response,
                                      // then parse the JSON.
                                      print('Logged in successfully');
                                    } else {
                                      print(response.statusCode);
                                      // If the server did not return a 201 CREATED response,
                                      // then throw an exception.
                                      throw Exception('Failed to login');
                                    }
                                  } catch (e) {
                                    setState(() {
                                      errorMessage =
                                          'Failed to login. Please check your credentials.';
                                    });
                                  } finally {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: const BorderSide(
                                              color: Color(0xff2cc48a))),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xff2cc48a))),
                                child: const Text('Logiin',
                                    style: TextStyle(color: Colors.white)))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Don't have an account?"),
                        TextButton(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.black.withOpacity(0.6)),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpWidget()),
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ))));
  }
}
