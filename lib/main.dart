import 'package:flutter/material.dart';
import 'package:maison_mate/widgets/auth/sign_in.dart';
import 'package:maison_mate/widgets/home.dart';
import 'package:maison_mate/provider/sign_in.dart';
import 'package:maison_mate/provider/sign_up.dart';
import 'package:maison_mate/provider/forgot_password.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const storage = FlutterSecureStorage();
  final authToken = await storage.read(key: authTokenKey);
  runApp(MyApp(authToken: authToken));
}

class MyApp extends StatelessWidget {
  final String? authToken;
  const MyApp({Key? key, this.authToken}) : super(key: key);

  static const String _title = '';

  @override
  Widget build(BuildContext context) {
    final isUserLoggedIn = authToken != null;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SignInModel()),
          ChangeNotifierProvider(create: (_) => SignUpModel()),
          ChangeNotifierProvider(create: (_) => ForgotPasswordModel())
        ],
        child: MaterialApp(
          title: _title,
          home: isUserLoggedIn ? const HomeWidget() : const SignInWidget(),
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(secondaryColor),
              primary: const Color(themeColor),
            ),
          ),
        ));
  }
}
