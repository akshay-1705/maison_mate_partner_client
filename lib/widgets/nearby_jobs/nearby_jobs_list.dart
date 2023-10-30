import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/response/find_jobs_response.dart';
import 'package:maison_mate/network/response/job_response.dart';
import 'package:maison_mate/widgets/nearby_jobs/nearby_job_details.dart';

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
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                NearbyJobDetails(job: job), // Your terms page
                          ),
                        );
                      },
                      child: Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              const SizedBox(width: 5),
                              SlidableAction(
                                label: 'Accept',
                                onPressed: (context) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirmation'),
                                        content: const Text(
                                            'Are you sure you want to ACCEPT this job?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Yes'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('No'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                icon: Icons.check,
                                borderRadius: BorderRadius.circular(15),
                              )
                            ],
                          ),
                          child: jobCard(job))));
            }, childCount: nearbyJobs.length),
          ),
        ],
      ),
    );
  }

  Container jobCard(JobResponse job) {
    return Container(
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
          trailing: Text(job.kind ?? ''),
        ),
      ),
    );
  }
}
