import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({
    super.key,
    required this.remainingTime,
  });

  final Duration remainingTime;

  @override
  Widget build(BuildContext context) {
    final hours = remainingTime.inHours;
    final minutes = (remainingTime.inMinutes - (hours * 60));
    final seconds = remainingTime.inSeconds - (hours * 3600) - (minutes * 60);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$hours hours $minutes minutes $seconds seconds',
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(awesomeColor)),
        ),
        const Text(
          'Chat with the customer and send quote before the job is cancelled',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
