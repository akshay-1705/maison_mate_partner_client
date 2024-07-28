import 'package:flutter/material.dart';

class HistoryTile extends StatelessWidget {
  final String date;
  final int hours;
  final int target;

  const HistoryTile({
    Key? key,
    required this.date,
    required this.hours,
    required this.target,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(date.substring(0, 1)),
      ),
      title: Text(date),
      subtitle: Text('$hours/$target hours'),
      trailing: Icon(
        hours >= target ? Icons.check_circle : Icons.hourglass_empty,
        color: hours >= target ? Colors.green : Colors.red,
      ),
    );
  }
}
