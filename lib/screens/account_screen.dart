import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/profile_details_response.dart';
import 'package:maison_mate/screens/area_covered_screen.dart';
import 'package:maison_mate/screens/change_password_screen.dart';
import 'package:maison_mate/screens/onboarding_screen.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/widgets/auth/sign_in.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<ApiResponse> futureData;
  static const storage = FlutterSecureStorage();
  static const String apiUrl = '$baseApiUrl/partners/profile_details';

  @override
  void initState() {
    super.initState();
    futureData = GetClient.fetchData(apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Account'),
        ),
        body: GetRequestFutureBuilder<dynamic>(
            future: futureData,
            apiUrl: apiUrl,
            builder: (context, data) {
              return renderData(context, data);
            }));
  }

  Padding renderData(BuildContext context, ProfileDetailsResponse data) {
    var firstName = data.firstName;
    var lastName = data.lastName;
    String fullName = '$firstName $lastName';
    var imageUrl = data.profilePicture.imageUrl;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child:
                    imageUrl != null // Assuming imageUrl is the presigned URL
                        ? ClipOval(
                            child: Image.network(
                            imageUrl,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ))
                        : const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 80,
                          ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        data.email ?? '',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OnboardingScreen(
                                yourDetailsSection: false,
                              )));
                },
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Divider(),
          customListTile(
            icon: Icons.location_on,
            title: 'Area Covered',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AreaCoveredScreen()));
            },
          ),
          const Divider(),
          customListTile(
            icon: Icons.lock,
            title: 'Change Password',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen()));
            },
          ),
          const Divider(),
          customListTile(
            icon: Icons.headset_mic,
            title: 'Support',
            onTap: () {
              showSupportDialog(context);
            },
          ),
          const Divider(),
          customListTile(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              logoutCallback(context);
            },
          ),
        ],
      ),
    );
  }

  void logoutCallback(BuildContext context) {
    Future<bool> confirm = CustomAppBar.showConfirmationDialog(
        context, "Are you sure you want to Logout?");

    confirm.then((value) {
      if (value) {
        storage.delete(key: authTokenKey);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SignInWidget()));
      }
    });
  }

  Widget customListTile(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 16.0),
            Text(title),
          ],
        ),
      ),
    );
  }

  void showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Support'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'If you need assistance, please contact us via email:',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'jatinrawat43@gmail.com',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
