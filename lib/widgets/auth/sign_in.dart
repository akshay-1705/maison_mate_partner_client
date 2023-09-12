import 'package:flutter/material.dart';
// import 'package:maison_mate/network/response/sign_in.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/widgets/auth/forgot_password.dart';
import 'package:maison_mate/widgets/auth/sign_up.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maison_mate/widgets/home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:maison_mate/states/sign_in.dart';
import 'package:maison_mate/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  static const storage = FlutterSecureStorage();

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
                    child: Form(
                        key: _formKey,
                        child: ListView(
                          children: <Widget>[
                            const SizedBox(height: 60),
                            signInHeader(),
                            const SizedBox(height: 40),
                            if (model.errorMessage.isNotEmpty)
                              errorMessage(model),
                            formFields(model),
                            const SizedBox(height: 10),
                            forgotPassword(context, model),
                            const SizedBox(height: 10),
                            loginContainer(model),
                            signUp(context, model),
                          ],
                        ))))));
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
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  labelText: 'Email*',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  } else if (!RegExp(
                          r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                      .hasMatch(value)) {
                    return 'Email is invalid';
                  }
                  // You can add more specific email format validation here if needed
                  return null;
                },
              ),
            )),
        Opacity(
          opacity: 0.5,
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                labelText: 'Password*',
                labelStyle: TextStyle(color: Color(0xff000000)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                // You can add more complex password validation here if needed
                return null;
              },
              style: const TextStyle(color: Color(0xff000000)),
            ),
          ),
        ),
      ],
    );
  }

  TextButton forgotPassword(BuildContext context, SignInModel model) {
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

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
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
                if (!model.isLoading && _formKey.currentState!.validate()) {
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
    const String loginUrl = '$baseApiUrl/partner/login';

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Secret-Header': secretHeader
        },
        body: jsonEncode(<String, String>{
          'email': emailController.text,
          'password': passwordController.text
        }),
      );

      if (response.statusCode == 200) {
        String authToken = ApiResponse.fromJson(jsonDecode(response.body))
            .data
            .token as String;
        await storage.write(key: authTokenKey, value: authToken);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePageWidget()),
        );
        model.setErrorMessage('');
      } else if (response.statusCode == 401) {
        model.setErrorMessage('Invalid credentials');
      } else {
        model.setErrorMessage(networkError);
      }
    } catch (e) {
      model.setErrorMessage(somethingWentWrong);
    } finally {
      model.setLoading(false);
    }
  }

  Row signUp(BuildContext context, SignInModel model) {
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
            model.clearStates();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignUpWidget()));
          },
        )
      ],
    );
  }
}
