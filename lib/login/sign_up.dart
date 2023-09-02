import 'package:flutter/material.dart';

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
  bool? cValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: renderModal(context),
    );
  }

  Padding renderModal(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(children: [
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: IconButton(
          //     icon: const Icon(Icons.arrow_back, color: Colors.black),
          //     onPressed: () => Navigator.of(context).pop(),
          //   ),
          // ),
          const SizedBox(height: 80),
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
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Opacity(
                    opacity: 0.3,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: firstNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          labelText: 'First Name',
                        ),
                      ),
                    )),
              ),
              Flexible(
                child: Opacity(
                    opacity: 0.3,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: lastNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          labelText: 'Last Name',
                        ),
                      ),
                    )),
              )
            ],
          ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Opacity(
                    opacity: 0.3,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          labelText: 'Password*',
                        ),
                      ),
                    )),
              ),
              Flexible(
                child: Opacity(
                    opacity: 0.3,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          labelText: 'Confirm Password*',
                        ),
                      ),
                    )),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Checkbox(
                value: cValue,
                onChanged: (bool? value) {
                  setState(() {
                    cValue = value!;
                  });
                },
              ),
              const Text("I accept Terms & Conditions and Privacy Policies",
                  style: TextStyle(fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                  onPressed: () {
                    // print(nameController.text);
                    // print(passwordController.text);
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
                      style: TextStyle(color: Colors.white)))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Already have an account?"),
              TextButton(
                child: Text(
                  'Sign In',
                  style: TextStyle(
                      fontSize: 17, color: Colors.black.withOpacity(0.6)),
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        ]));
  }
}
