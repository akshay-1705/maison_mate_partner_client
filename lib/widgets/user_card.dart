import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/response/user_response.dart';

class UserCard extends StatelessWidget {
  final UserResponse user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        child: Card(
          elevation: 0,
          color: const Color(secondaryColor),
          child: ListTile(
            title: Text(
              user.name ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black54, // Add a touch of blue color
              ),
            ),
            subtitle: Text(
              'Open Jobs: ${user.openJobs}',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.blueGrey, // Add a touch of green color
              ),
            ),
          ),
        ));
  }
}
