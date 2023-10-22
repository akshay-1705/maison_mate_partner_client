import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maison_mate/constants.dart';

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
