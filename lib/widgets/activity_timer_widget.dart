import 'package:flutter/material.dart';
import 'package:maison_mate/provider/on_duty_model.dart';

class ActivityTimerWidget extends StatefulWidget {
  final OnDutyModel onDutyModel;

  const ActivityTimerWidget({Key? key, required this.onDutyModel})
      : super(key: key);

  @override
  State<ActivityTimerWidget> createState() => _ActivityTimerWidgetState();
}

class _ActivityTimerWidgetState extends State<ActivityTimerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int activity = 0;
    if (widget.onDutyModel.onDuty) {
      activity = widget.onDutyModel.todayActivity;
    } else {
      activity = widget.onDutyModel.originalActivity;
    }

    return Text(
      formatDuration(activity),
      style: const TextStyle(color: Colors.white),
    );
  }

  String formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final secs = duration.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
