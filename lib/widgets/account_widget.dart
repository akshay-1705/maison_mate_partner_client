import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/profile_details_response.dart';
import 'package:maison_mate/screens/area_covered_screen.dart';
import 'package:maison_mate/screens/change_password_screen.dart';
import 'package:maison_mate/screens/delete_account_screen.dart';
import 'package:maison_mate/screens/onboarding_screen.dart';
import 'package:maison_mate/services/logout_service.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget({super.key});

  @override
  State<AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  late Future<ApiResponse> futureData;
  static String apiUrl = '$baseApiUrl/partners/profile_details';

  @override
  void initState() {
    super.initState();
    futureData = GetClient.fetchData(apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    return GetRequestFutureBuilder<dynamic>(
        future: futureData,
        apiUrl: apiUrl,
        builder: (context, data) {
          return renderData(context, data);
        });
  }

  SingleChildScrollView renderData(
      BuildContext context, ProfileDetailsResponse data) {
    var firstName = data.firstName;
    var lastName = data.lastName;
    String fullName = '$firstName $lastName';

    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
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
              if (data.onboardingStatus != 'submitted') ...[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OnboardingScreen()));
                  },
                ),
              ]
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
            icon: Icons.delete,
            title: 'Delete account',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DeleteAccountScreen()));
            },
          ),
          const Divider(),
          customListTile(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              LogoutService.logout(context);
            },
          ),
        ],
      ),
    ));
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
                  'business@maisonmate.co.uk',
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
