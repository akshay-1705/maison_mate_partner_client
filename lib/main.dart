import 'package:flutter/material.dart';
import 'package:maison_mate/widgets/auth/sign_in.dart';
import 'package:maison_mate/states/sign_in.dart';
import 'package:maison_mate/states/sign_up.dart';
import 'package:maison_mate/states/forgot_password.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = '';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SignInModel()),
          ChangeNotifierProvider(create: (_) => SignUpModel()),
          ChangeNotifierProvider(create: (_) => ForgotPasswordModel())
        ],
        child: MaterialApp(
          title: _title,
          home: Scaffold(
            appBar: AppBar(title: const Text(_title)),
            body: const SignInWidget(),
          ),
          theme: ThemeData(
            useMaterial3: true,
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xff2cc48a)),
          ),
        ));
  }
}
