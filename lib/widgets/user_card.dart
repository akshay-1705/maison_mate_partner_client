import 'package:flutter/material.dart';
import 'package:maison_mate/network/response/user_response.dart';

class UserCard extends StatelessWidget {
  final UserResponse user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
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
    );
  }
}
