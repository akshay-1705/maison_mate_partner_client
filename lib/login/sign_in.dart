import 'package:flutter/material.dart';
import 'package:maison_mate/login/reset_password.dart';
import 'package:maison_mate/login/sign_up.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                Opacity(
                    opacity: 0.3,
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
                  opacity: 0.3,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        labelText: 'Password*',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ResetPasswordWidget()),
                    );
                  },
                  child: const Text('Forgot Password?',
                      style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 10),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                        onPressed: () {
                          // print(emailController.text);
                          // print(passwordController.text);
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                      color: Color(0xff2cc48a))),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
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
                            fontSize: 17, color: Colors.black.withOpacity(0.6)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpWidget()),
                        );
                      },
                    )
                  ],
                ),
              ],
            )));
  }
}
