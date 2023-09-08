import 'package:flutter/material.dart';
import 'package:maison_mate/network/response/sign_in.dart';
import 'package:maison_mate/widgets/login/reset_password.dart';
import 'package:maison_mate/widgets/login/sign_up.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:maison_mate/states/sign_in_model.dart';

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
    final model = Provider.of<SignInModel>(context);

    return Scaffold(
        body: AbsorbPointer(
            absorbing: model.isLoading,
            child: GestureDetector(
                onTap: () {
                  // Dismiss the keyboard when tapped on a non-actionable item
                  FocusScope.of(context).unfocus();
                },
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                      children: <Widget>[
                        const SizedBox(height: 60),
                        signInHeader(),
                        const SizedBox(height: 40),
                        if (model.errorMessage.isNotEmpty) errorMessage(model),
                        // (_futureSignIn == null)
                        //     ? const Center()
                        //     : futureBuilder(),
                        formFields(model),
                        const SizedBox(height: 10),
                        forgotPassword(context),
                        const SizedBox(height: 10),
                        loginContainer(model),
                        signUp(context),
                      ],
                    )))));
  }

  Column signInHeader() {
    return Column(
      children: [
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
      ],
    );
  }

  Center errorMessage(SignInModel model) {
    return Center(
        child: Text(
      model.errorMessage,
      style: const TextStyle(color: Colors.red),
    ));
  }

  Column formFields(SignInModel model) {
    return Column(
      children: [
        Opacity(
            opacity: 0.5,
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
        Opacity(
          opacity: 0.5,
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                labelText: 'Password*',
                labelStyle: TextStyle(color: Color(0xff000000)),
              ),
              style: const TextStyle(color: Color(0xff000000)),
            ),
          ),
        ),
      ],
    );
  }

  TextButton forgotPassword(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ResetPasswordWidget()),
        );
      },
      child:
          const Text('Forgot Password?', style: TextStyle(color: Colors.black)),
    );
  }

  Container loginContainer(SignInModel model) {
    return Container(
      height: 50,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: model.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton(
              onPressed: () async {
                if (!model.isLoading) {
                  model.setErrorMessage('');
                  await login(model);
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
              child:
                  const Text('Login', style: TextStyle(color: Colors.white))),
    );
  }

  Future<void> login(SignInModel model) async {
    model.setLoading(true);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.7:3000/api/v1/partner/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': emailController.text,
          'password': passwordController.text
        }),
      );

      if (response.statusCode == 201) {
        // Successful login logic here
        model.setErrorMessage('');
        print(SignIn.fromJson(jsonDecode(response.body)));
      } else if (response.statusCode == 401) {
        model.setErrorMessage('Invalid credentials');
      } else {
        // Handle login errors here
        model.setErrorMessage('Network error');
      }
    } catch (e) {
      // Handle network errors here
      model.setErrorMessage('Network error');
    } finally {
      model.setLoading(false);
    }
  }

  Row signUp(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("Don't have an account?"),
        TextButton(
          child: Text(
            'Sign Up',
            style:
                TextStyle(fontSize: 17, color: Colors.black.withOpacity(0.6)),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignUpWidget()),
            );
          },
        )
      ],
    );
  }
}
