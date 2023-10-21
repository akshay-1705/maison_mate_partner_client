import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maison_mate/constants.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            NearbyJobsList(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class NearbyJobsList extends StatelessWidget {
  const NearbyJobsList({super.key});

  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(locale: 'en_GB');
    final List<Map<String, dynamic>> nearbyJobs = [
      {
        'title': 'Plumbing',
        'amount': '25',
        'date': 'Oct 20, 2023',
        'distance': '1km',
      },
      {
        'title': 'Painting',
        'amount': '79',
        'date': 'Oct 22, 2023',
        'distance': '2km',
      },
      {
        'title': 'Plumbing',
        'amount': '50',
        'date': 'Oct 20, 2023',
        'distance': '5km',
      },
      {
        'title': 'Painting',
        'amount': '45',
        'date': 'Oct 22, 2023',
        'distance': '8km',
      },
      {
        'title': 'Plumbing',
        'amount': '25',
        'date': 'Oct 20, 2023',
        'distance': '1km',
      },
      {
        'title': 'Painting',
        'amount': '79',
        'date': 'Oct 22, 2023',
        'distance': '2km',
      },
      {
        'title': 'Plumbing',
        'amount': '50',
        'date': 'Oct 20, 2023',
        'distance': '5km',
      },
      {
        'title': 'Painting',
        'amount': '45',
        'date': 'Oct 22, 2023',
        'distance': '8km',
      },
    ];

    return Column(
      children: nearbyJobs.map((job) {
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: Card(
            color: const Color(secondaryColor),
            elevation: 0,
            child: ListTile(
              leading: Text(job['distance']),
              title: Text(job['title']),
              subtitle:
                  Text('Amount: ${job['amount']}${format.currencySymbol}'),
              trailing: Text('Job date: ${job['date']}'),
            ),
          ),
        );
      }).toList(),
    );
  }
}
