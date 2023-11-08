import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/screens/home_screen.dart';
import 'package:maison_mate/services/web_socket_service.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:web_socket_channel/io.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({
    super.key,
    required this.remainingTime,
    required this.jobId,
  });

  final Duration remainingTime;
  final int? jobId;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  WebSocketService webSocketService = WebSocketService();
  IOWebSocketChannel? channel;

  @override
  void initState() {
    super.initState();
    initializeWebSocket().then((value) {
      channel?.sink.add(jsonEncode({
        'command': 'subscribe',
        'identifier': jsonEncode({
          'channel': 'JobAssignmentCancelChannel',
          'assignment_id': widget.jobId
        })
      }));
      setState(() {});
    });
  }

  Future<void> initializeWebSocket() async {
    channel = await webSocketService.connect();
  }

  @override
  Widget build(BuildContext context) {
    final hours = widget.remainingTime.inHours;
    final minutes = (widget.remainingTime.inMinutes - (hours * 60));
    final seconds =
        widget.remainingTime.inSeconds - (hours * 3600) - (minutes * 60);
    if (channel == null) {
      return const Column();
    } else {
      return StreamBuilder(
          stream: channel?.stream,
          builder: (context, snapshot) {
            listenToMessage(snapshot);
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
                ]);
          });
    }
  }

  void listenToMessage(AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.data != null) {
      var data = jsonDecode(snapshot.data);
      var decodedMessage = data['message'];

      if (decodedMessage is Map && decodedMessage['status'] == 'cancelled') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
              MySnackBar(message: "Job cancelled.", error: false)
                  .getSnackbar());
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen(index: 1)),
            (route) => false,
          );
        });
      }
    }
  }
}
