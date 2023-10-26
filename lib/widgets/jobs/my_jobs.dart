import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/widgets/jobs/filter_option.dart';
import 'package:maison_mate/widgets/jobs/my_jobs_list.dart';

class MyJobsWidget extends StatefulWidget {
  const MyJobsWidget({Key? key}) : super(key: key);

  @override
  State<MyJobsWidget> createState() => _MyJobsWidgetState();
}

class _MyJobsWidgetState extends State<MyJobsWidget> {
  late Future<ApiResponse> futureData;
  static const String apiUrl = '$baseApiUrl/partners/payments_summary';

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
          return renderData(data);
        });
  }

  SingleChildScrollView renderData(data) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 5),
                const FilterOptions(),
                const SizedBox(height: 10),
                MyJobsList(data),
              ],
            )));
  }
}
