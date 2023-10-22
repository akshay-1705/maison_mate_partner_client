import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/response/find_jobs_response.dart';

class NearbyJobsList extends StatefulWidget {
  final FindJobsResponse data;
  const NearbyJobsList({Key? key, required this.data}) : super(key: key);

  @override
  State<NearbyJobsList> createState() => _NearbyJobsListState();
}

class _NearbyJobsListState extends State<NearbyJobsList> {
  var format = NumberFormat.simpleCurrency(locale: 'en_GB');

  @override
  Widget build(BuildContext context) {
    final nearbyJobs = widget.data.nearbyJobs;

    if (nearbyJobs.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.50,
        alignment: Alignment.center,
        child: const Center(
          child: Text(
            'No nearby jobs found',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height:
          MediaQuery.of(context).size.height * 0.50, // Specify a fixed height
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final job = nearbyJobs[index];
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
                    leading: Text(job.distance ?? ''),
                    title: Text(job.serviceName ?? ''),
                    subtitle:
                        Text('Amount: ${job.amount}${format.currencySymbol}'),
                    trailing: Text('Job date: ${job.completionDate}'),
                  ),
                ),
              );
            }, childCount: nearbyJobs.length),
          ),
        ],
      ),
    );
  }
}
