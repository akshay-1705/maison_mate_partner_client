import 'package:flutter/material.dart';
import 'package:maison_mate/network/request/post_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/shared/forms.dart';
import 'package:maison_mate/widgets/auth/forgot_password.dart';
import 'package:maison_mate/widgets/auth/sign_up.dart';
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
  Future<ApiResponse>? futureData;
  static const storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SignInModel>(context);

    return Scaffold(
        body: AbsorbPointer(
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
                        child: ListView(
                          children: <Widget>[
                            const SizedBox(height: 100),
                            signInHeader(),
                            const SizedBox(height: 40),
                            formFields(model),
                            const SizedBox(height: 10),
                            forgotPassword(context, model),
                            const SizedBox(height: 10),
                            (futureData != null)
                                ? PostClient.futureBuilder(
                                    model,
                                    futureData!,
                                    "Login",
                                    () async {
                                      onSubmitCallback(model);
                                    },
                                    () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeWidget()),
                                      );
                                    },
                                  )
                                : submitButton("Login", () async {
                                    onSubmitCallback(model);
                                  }),
                            signUp(context, model),
                          ],
                        ))))));
  }

  void onSubmitCallback(SignInModel model) {
    if (!model.isSubmitting && _formKey.currentState!.validate()) {
      model.setIsSubmitting(true);
      const String loginUrl = '$baseApiUrl/partner/login';
      var formData = {
        'email': emailController.text,
        'password': passwordController.text
      };

      futureData =
          PostClient.request(loginUrl, formData, model, (response) async {
        var authToken = response.data.token;
        await storage.write(key: authTokenKey, value: authToken);
      });
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
