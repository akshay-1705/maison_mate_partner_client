import 'package:flutter/material.dart';
import 'package:maison_mate/widgets/login/reset_password.dart';
import 'package:maison_mate/widgets/login/sign_up.dart';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:maison_mate/network/auth_service.dart';

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
  late AuthService authService;

  @override
  void initState() {
    super.initState();
    final dio = Dio(); // Create a Dio instance
    authService = AuthService(dio); // Create ApiService instance
  }

  bool isEmailValid(String email) {
    // Add your email validation logic here
    // For example, you can use a regular expression to check for a valid email format
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    // Add your password validation logic here
    // For example, you can check if it's at least 6 characters long
    return password.length >= 6;
  }

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

                                  final email = emailController.text;
                                  final password = passwordController.text;

                                  if (!isEmailValid(email)) {
                                    setState(() {
                                      errorMessage = 'Enter a valid email';
                                      isLoading = false;
                                    });
                                    return;
                                  } else if (!isPasswordValid(password)) {
                                    setState(() {
                                      errorMessage =
                                          'Password must be at least 6 characters';
                                      isLoading = false;
                                    });
                                    return;
                                  }

                                  try {
                                    final response = await authService.login(
                                      emailController.text,
                                      passwordController.text,
                                    );
                                    print(response);

                                    // If the server did return a 201 CREATED response,
                                    // then parse the JSON.
                                    print('Logged in successfully');
                                  } catch (e) {
                                    setState(() {
                                      errorMessage =
                                          'Invalid email or password.';
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
                                child: const Text('Login',
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
