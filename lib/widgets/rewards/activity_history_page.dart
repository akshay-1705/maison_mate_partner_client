import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/widgets/rewards/activity_history.dart';

class ActivityHistoryPage extends StatefulWidget {
  const ActivityHistoryPage({Key? key}) : super(key: key);

  @override
  State<ActivityHistoryPage> createState() => _ActivityHistoryPageState();
}

class _ActivityHistoryPageState extends State<ActivityHistoryPage> {
  late Future<ApiResponse> futureData;
  static String apiUrl = '$baseApiUrl/partners/all_activities';
  List<dynamic>? activityHistory;
  int? totalActivities;

  @override
  void initState() {
    super.initState();
    futureData = GetClient.fetchData(apiUrl);
    futureData.then((value) {
      setState(() {
        activityHistory = value.data['all_activities'];
        totalActivities = value.data['total_activities'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Activity History'),
        ),
        body: ActivityHistory(
          activityHistory: activityHistory ?? [],
        ));
  }
}
