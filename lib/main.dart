import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maison_mate/firebase_options.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/area_covered_model.dart';
import 'package:maison_mate/provider/change_password_model.dart';
import 'package:maison_mate/provider/delete_account_model.dart';
import 'package:maison_mate/provider/documentation/banking_model.dart';
import 'package:maison_mate/provider/documentation/contract_model.dart';
import 'package:maison_mate/provider/documentation/employees_model.dart';
import 'package:maison_mate/provider/documentation/health_and_safety_model.dart';
import 'package:maison_mate/provider/documentation/insurance_model.dart';
import 'package:maison_mate/provider/documentation/profile_picture_model.dart';
import 'package:maison_mate/provider/documentation/self_trader_identification_model.dart';
import 'package:maison_mate/provider/documentation_model.dart';
import 'package:maison_mate/provider/email_verification_model.dart';
import 'package:maison_mate/provider/favourites_model.dart';
import 'package:maison_mate/provider/my_jobs_model.dart';
import 'package:maison_mate/provider/nearby_job_details_model.dart';
import 'package:maison_mate/provider/on_duty_model.dart';
import 'package:maison_mate/provider/phone_verification_model.dart';
import 'package:maison_mate/provider/verify_otp_model.dart';
import 'package:maison_mate/screens/home_screen.dart';
import 'package:maison_mate/services/firebase_service.dart';
import 'package:maison_mate/widgets/auth/sign_in.dart';
import 'package:maison_mate/provider/auth/sign_in_model.dart';
import 'package:maison_mate/provider/auth/sign_up_model.dart';
import 'package:maison_mate/provider/auth/forgot_password_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const storage = FlutterSecureStorage();
  final authToken = await storage.read(key: authTokenKey);
  if (authToken != null) {
    FirebaseService.enable();
  }
  await dotenv.load(fileName: ".env/production.env");
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
          ChangeNotifierProvider(create: (_) => ContractModel()),
          ChangeNotifierProvider(create: (_) => DocumentationModel()),
          ChangeNotifierProvider(create: (_) => EmailVerificationModel()),
          ChangeNotifierProvider(create: (_) => FavouritesModel()),
          ChangeNotifierProvider(create: (_) => ChangePasswordModel()),
          ChangeNotifierProvider(create: (_) => AreaCoveredModel()),
          ChangeNotifierProvider(create: (_) => DeleteAccountModel()),
          ChangeNotifierProvider(create: (_) => MyJobsModel()),
          ChangeNotifierProvider(create: (_) => OnDutyModel()),
          ChangeNotifierProvider(create: (_) => NearbyJobDetailsModel()),
          ChangeNotifierProvider(create: (_) => PhoneVerificationModel()),
          ChangeNotifierProvider(create: (_) => VerifyOtpModel()),
          ChangeNotifierProvider(
              create: (_) => SelfTraderIdentificationModel()),
        ],
        child: LifecycleHandler(
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
          ),
        ));
  }
}

class LifecycleHandler extends StatefulWidget {
  final Widget child;
  const LifecycleHandler({Key? key, required this.child}) : super(key: key);

  @override
  State<LifecycleHandler> createState() => _LifecycleHandlerState();
}

class _LifecycleHandlerState extends State<LifecycleHandler>
    with WidgetsBindingObserver {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      late Future<ApiResponse> futureData;
      String onDutyApiUrl = '$baseApiUrl/partners/on_duty';
      futureData = GetClient.fetchData(onDutyApiUrl);
      futureData.then((value) {
        if (mounted) {
          var stateModel = Provider.of<OnDutyModel>(context, listen: false);
          setState(() {
            stateModel.setOnDuty(value.data['on_duty']);
            stateModel.setOffDutyAllowed(value.data['off_duty_allowed']);
            stateModel.originalActivity = value.data['today_activity'];
            stateModel.setTodayActivity(value.data['today_activity']);
            stateModel.setShowOffer(value.data['show_offer']);
          });
        }
      });
    }
  }

  void startTimer() {
    var model = Provider.of<OnDutyModel>(context, listen: false);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        int seconds = model.todayActivity + 1;
        model.setTodayActivity(seconds);
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
