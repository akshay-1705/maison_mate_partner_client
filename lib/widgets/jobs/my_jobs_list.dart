import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';

class MyJobsList extends StatelessWidget {
  const MyJobsList(data, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> partnerJobs = [
      {
        'title': 'Plumbing',
        'status': 'Upcoming',
        'date': 'Oct 20, 2023',
        'payment': Colors.green,
      },
      {
        'title': 'Painting',
        'status': 'Pending',
        'date': 'Oct 22, 2023',
        'payment': Colors.red
      },
      {
        'title': 'Plumbing',
        'status': 'Upcoming',
        'date': 'Oct 20, 2023',
        'payment': Colors.red
      },
      {
        'title': 'Painting',
        'status': 'Pending',
        'date': 'Oct 22, 2023',
        'payment': Colors.green
      },
      {
        'title': 'Plumbing',
        'status': 'Upcoming',
        'date': 'Oct 20, 2023',
        'payment': Colors.green,
      },
      {
        'title': 'Painting',
        'status': 'Pending',
        'date': 'Oct 22, 2023',
        'payment': Colors.red
      },
      {
        'title': 'Plumbing',
        'status': 'Upcoming',
        'date': 'Oct 20, 2023',
        'payment': Colors.red
      },
      {
        'title': 'Painting',
        'status': 'Pending',
        'date': 'Oct 22, 2023',
        'payment': Colors.green
      },
    ];

    return Column(
      children: partnerJobs.map((job) {
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
              elevation: 0,
              color: const Color(secondaryColor),
              child: ListTile(
                leading: Icon(
                  Icons.currency_pound,
                  color: job['payment'],
                ),
                title: Text(job['title']),
                subtitle: Text(job['status']),
                trailing: Text('Job date: ${job['date']}'),
              ),
            ));
      }).toList(),
    );
  }
}
