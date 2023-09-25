import 'package:flutter/material.dart';
// import 'package:maison_mate/network/response/sign_in.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/shared/forms.dart';
import 'package:maison_mate/widgets/auth/forgot_password.dart';
import 'package:maison_mate/widgets/auth/sign_up.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maison_mate/widgets/home.dart';
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
  Future<ApiResponse>? futureData;

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
                            const SizedBox(height: 100),
                            signInHeader(),
                            const SizedBox(height: 40),
                            if (model.errorMessage.isNotEmpty)
                              errorMessage(model),
                            formFields(model),
                            const SizedBox(height: 10),
                            forgotPassword(context, model),
                            const SizedBox(height: 10),
                            (futureData != null)
                                ? futureBuilder(model)
                                : submitButton('Login', () async {
                                    if (!model.isLoading &&
                                        _formKey.currentState!.validate()) {
                                      model.setErrorMessage('');
                                      futureData = login(model);
                                    }
                                  }),
                            signUp(context, model),
                          ],
                        ))))));
  }

  FutureBuilder<ApiResponse> futureBuilder(SignInModel model) {
    return FutureBuilder<ApiResponse>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator while the future is waiting
          return circularLoader();
        } else if (snapshot.hasError || snapshot.data?.success == false) {
          // Handle the case where there's an error or login is unsuccessful
          return submitButton('Login', () async {
            if (!model.isLoading && _formKey.currentState!.validate()) {
              model.setErrorMessage('');
              futureData = login(model);
            }
          });
        } else if (snapshot.hasData && snapshot.data!.success) {
          // Handle the case where login is successful
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeWidget()),
            );
          });
        }

        // Return a default empty container as a fallback
        return Container(
          alignment: Alignment.center,
          child: circularLoader(),
        );
      },
    );
  }

  Future<ApiResponse> login<T>(SignInModel model) async {
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
        var authToken =
            ApiResponse.fromJson(jsonDecode(response.body)).data.token;
        await storage.write(key: authTokenKey, value: authToken);
        model.setErrorMessage('');
      } else if (response.statusCode == 401) {
        model.setErrorMessage('Invalid credentials');
      } else {
        model.setErrorMessage(networkError);
      }
      model.setLoading(false);
      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      model.setLoading(false);
      model.setErrorMessage(somethingWentWrong);
      throw (somethingWentWrong);
    }
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
                  color: Color(themeColor),
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
        requiredEmailField('Email*', emailController),
        requiredTextField('Password*', passwordController, true),
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
      child: const Text('Forgot Password?',
          style: TextStyle(color: Color(themeColor))),
    );
  }

  Row signUp(BuildContext context, SignInModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("Don't have an account?"),
        TextButton(
          child: Text(
            'Sign Up',
            style: TextStyle(
                fontSize: 17, color: const Color(themeColor).withOpacity(0.6)),
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
