import 'package:flutter/material.dart';
import 'package:maison_mate/provider/documentation/banking_model.dart';
import 'package:maison_mate/provider/documentation/employees_model.dart';
import 'package:maison_mate/provider/documentation/health_and_safety_model.dart';
import 'package:maison_mate/provider/documentation/insurance_model.dart';
import 'package:maison_mate/provider/documentation/profile_picture_model.dart';
import 'package:maison_mate/provider/documentation/self_trader_identification_model.dart';
import 'package:maison_mate/provider/documentation_model.dart';
import 'package:maison_mate/provider/email_verification_model.dart';
import 'package:maison_mate/screens/home_screen.dart';
import 'package:maison_mate/widgets/auth/sign_in.dart';
import 'package:maison_mate/provider/auth/sign_in_model.dart';
import 'package:maison_mate/provider/auth/sign_up_model.dart';
import 'package:maison_mate/provider/auth/forgot_password_model.dart';
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
          ChangeNotifierProvider(create: (_) => ForgotPasswordModel()),
          ChangeNotifierProvider(create: (_) => ProfilePictureModel()),
          ChangeNotifierProvider(create: (_) => BankingModel()),
          ChangeNotifierProvider(create: (_) => InsuranceModel()),
          ChangeNotifierProvider(create: (_) => EmployeesModel()),
          ChangeNotifierProvider(create: (_) => HealthAndSafetyModel()),
          ChangeNotifierProvider(create: (_) => DocumentationModel()),
          ChangeNotifierProvider(create: (_) => EmailVerificationModel()),
          ChangeNotifierProvider(
              create: (_) => SelfTraderIdentificationModel()),
        ],
        child: MaterialApp(
          title: _title,
          home: isUserLoggedIn ? const HomeScreen() : const SignInWidget(),
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
