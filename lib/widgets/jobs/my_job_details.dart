import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/job_item_response.dart';
import 'package:maison_mate/network/response/my_job_details_response.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:url_launcher/url_launcher.dart';

class MyJobDetails extends StatefulWidget {
  final JobItemResponse job;
  const MyJobDetails({Key? key, required this.job}) : super(key: key);

  @override
  State<MyJobDetails> createState() => _MyJobDetailsState();
}

class _MyJobDetailsState extends State<MyJobDetails> {
  late Future<ApiResponse> futureData;
  late String apiUrl;
  DateTime? acceptedAt;
  bool showInfo = false;
  late Timer timer;
  late Duration remainingTime = const Duration(hours: 2);

  @override
  void initState() {
    super.initState();
    apiUrl =
        '$baseApiUrl/partners/my_job_details?job_assignment_id=${widget.job.id}';
    futureData = GetClient.fetchData(apiUrl);
    futureData.then((value) {
      initializeTimer(value);
    });
  }

  void initializeTimer(ApiResponse<dynamic> value) {
    acceptedAt = DateTime.fromMillisecondsSinceEpoch(value.data.acceptedAt);
    final currentTime = DateTime.now();
    final elapsedTime = currentTime.difference(acceptedAt!);
    if (elapsedTime < remainingTime) {
      remainingTime = remainingTime - elapsedTime;
    } else {
      remainingTime = const Duration();
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        calculateRemainingTime();
      });
    });
  }

  void calculateRemainingTime() {
    final currentTime = DateTime.now();
    final elapsedTime = currentTime.difference(acceptedAt!);
    remainingTime = const Duration(hours: 2);

    if (elapsedTime < remainingTime) {
      remainingTime = remainingTime - elapsedTime;
    } else {
      remainingTime = const Duration();
      timer.cancel();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: GetRequestFutureBuilder<dynamic>(
          apiUrl: apiUrl,
          future: futureData,
          builder: (context, data) {
            return showDetails(data);
          },
        ));
  }

  SingleChildScrollView showDetails(MyJobDetailsResponse data) {
    return SingleChildScrollView(
        child: Column(children: [
      jobDetails(data),
      const SizedBox(height: 20),
      Container(
        height: 4,
        color: Colors.black12,
      ),
      const SizedBox(height: 10),
      description(data),
      const SizedBox(height: 10),
      Container(
        height: 4,
        color: Colors.black12,
      ),
      const SizedBox(height: 10),
      addressDetails(data),
    ]));
  }

  Padding jobDetails(MyJobDetailsResponse data) {
    final hours = remainingTime.inHours;
    final minutes = (remainingTime.inMinutes - (hours * 60));
    final seconds = remainingTime.inSeconds - (hours * 3600) - (minutes * 60);

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${data.kind} Job',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                Text(
                  '$hours hours $minutes minutes $seconds seconds',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(awesomeColor)),
                ),
                const Text(
                  'Time is running out. Chat with the user and send quote before the job expires',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 10),
                Text(
                  'Job Status: ${data.status}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Text(
                  data.userName ?? '',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 10),
                MyForm.submitButton("Chat", () async {}),
              ]),
        ));
  }

  Padding description(MyJobDetailsResponse data) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
            alignment: Alignment.topLeft,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Job Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    data.serviceName ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    data.details ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ])));
  }

  Padding addressDetails(MyJobDetailsResponse data) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
            alignment: Alignment.topLeft,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    data.address ?? '',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                      onTap: () async {
                        final Uri mapUrl = Uri.parse(
                            'https://www.google.com/maps/search/?api=1&query=${data.latitude},${data.longitude}');
                        if (await canLaunchUrl(mapUrl)) {
                          await launchUrl(mapUrl);
                        }
                      },
                      child: IntrinsicWidth(
                          child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              child: const Row(children: [
                                Text(
                                  'See on map',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.directions,
                                  size: 24,
                                  color: Colors.green,
                                )
                              ])))),
                ])));
  }
}
