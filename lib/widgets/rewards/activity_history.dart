import 'package:flutter/material.dart';
import 'package:maison_mate/widgets/rewards/history_tile.dart';

class ActivityHistory extends StatelessWidget {
  final List<Map<String, dynamic>> activityHistory;

  const ActivityHistory({
    Key? key,
    required this.activityHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> displayedActivities =
        activityHistory.length > 3
            ? activityHistory.sublist(0, 3)
            : activityHistory;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: displayedActivities.map((activity) {
            return HistoryTile(
              date: activity['date'],
              hours: activity['hours'],
              target: activity['target'],
            );
          }).toList(),
        ),
      ],
    );
  }
}
