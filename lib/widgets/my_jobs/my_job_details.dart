import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/job_item_response.dart';
import 'package:maison_mate/network/response/my_job_details_response.dart';
import 'package:maison_mate/provider/my_job_details_model.dart';
import 'package:maison_mate/widgets/my_jobs/dynamic_buttons.dart';
import 'package:maison_mate/widgets/my_jobs/address_details.dart';
import 'package:maison_mate/widgets/my_jobs/description.dart';
import 'package:maison_mate/widgets/my_jobs/timer_widget.dart';
import 'package:provider/provider.dart';

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

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MyJobDetailsModel>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: GetRequestFutureBuilder<dynamic>(
          apiUrl: apiUrl,
          future: futureData,
          builder: (context, data) {
            return showDetails(data, model);
          },
        ));
  }

  AbsorbPointer showDetails(
      MyJobDetailsResponse data, MyJobDetailsModel model) {
    return AbsorbPointer(
        absorbing: model.isSubmitting,
        child: SingleChildScrollView(
            child: Column(children: [
          jobDetails(data, model),
          const SizedBox(height: 20),
          Container(
            height: 4,
            color: Colors.black12,
          ),
          const SizedBox(height: 10),
          Description(data: data),
          const SizedBox(height: 10),
          Container(
            height: 4,
            color: Colors.black12,
          ),
          const SizedBox(height: 10),
          AddressDetails(data: data),
        ])));
  }

  Padding jobDetails(MyJobDetailsResponse data, MyJobDetailsModel model) {
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
                if (widget.job.statusToSearch == 0) ...[
                  TimerWidget(
                      remainingTime: remainingTime, jobId: widget.job.id),
                ],
                DynamicButtons(
                    context: context, job: widget.job, data: data, model: model)
              ]),
        ));
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
}
