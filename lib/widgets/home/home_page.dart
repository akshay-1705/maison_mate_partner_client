import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/widgets/auth/sign_in.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  static const storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Padding(
      padding: EdgeInsets.all(100),
      child: LogoutButton(storage: storage),
    ));
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
    required this.storage,
  });

  final FlutterSecureStorage storage;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          await storage.delete(key: authTokenKey);
          if (!context.mounted) {
            return;
          }
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const SignInWidget()));
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Color(0xff2cc48a))),
            ),
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xff2cc48a))),
        child: const Text('Logout', style: TextStyle(color: Colors.white)));
  }
}
