import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/response/my_jobs_response.dart';

class MyJobsList extends StatelessWidget {
  final MyJobsResponse data;
  const MyJobsList({Key? key, required this.data}) : super(key: key);

  Icon getIcon(String paymentStatus) {
    switch (paymentStatus) {
      case 'paid':
        return const Icon(Icons.currency_pound, color: Colors.green);
      case 'pending':
        return const Icon(Icons.currency_pound, color: Colors.orange);
      case 'refunded':
        return const Icon(Icons.currency_pound, color: Colors.blue);
      case 'failed':
        return const Icon(Icons.currency_pound, color: Colors.red);
      default:
        return const Icon(Icons.currency_pound, color: Colors.orange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: data.myJobs.map((job) {
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
                leading: getIcon(job.paymentStatus ?? ''),
                title: Text(job.serviceName ?? ''),
                subtitle: Text(job.jobStatus ?? ''),
                trailing: Text('Job date: ${job.completionDate}'),
              ),
            ));
      }).toList(),
    );
  }
}
