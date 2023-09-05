import 'package:flutter/material.dart';

class ResetPasswordWidget extends StatefulWidget {
  const ResetPasswordWidget({Key? key}) : super(key: key);

  @override
  State<ResetPasswordWidget> createState() => _ResetPasswordWidgetState();
}

class _ResetPasswordWidgetState extends State<ResetPasswordWidget> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    return Scaffold(
      body: renderModal(emailController),
    );
  }

  renderModal(TextEditingController emailController) {
    return GestureDetector(
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
              const SizedBox(height: 40),
              Opacity(
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
                  )),
              const SizedBox(height: 20),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                      onPressed: () {
                        // print(emailController.text);
                        // print(passwordController.text);
                      },
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side:
                                    const BorderSide(color: Color(0xff2cc48a))),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xff2cc48a))),
                      child: const Text('Forgot',
                          style: TextStyle(color: Colors.white)))),
            ])));
  }
}
