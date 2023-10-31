import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/response/my_jobs_response.dart';
import 'package:maison_mate/widgets/jobs/my_job_details.dart';

class MyJobsList extends StatelessWidget {
  final MyJobsResponse? data;
  const MyJobsList({Key? key, required this.data}) : super(key: key);

  Icon getIcon(String paymentStatus) {
    switch (paymentStatus) {
      case 'Plumbing':
        return const Icon(Icons.plumbing, color: Colors.green);
      case 'Handyman':
        return const Icon(Icons.handyman, color: Colors.green);
      case 'Locksmith':
        return const Icon(Icons.lock, color: Colors.green);
      case 'Painting':
        return const Icon(Icons.format_paint, color: Colors.green);
      case 'Heating/Cooling repairs':
        return const Icon(Icons.heat_pump, color: Colors.green);
      case 'Home Security System Repair':
        return const Icon(Icons.security, color: Colors.green);
      case 'Pest control':
        return const Icon(Icons.pest_control, color: Colors.green);
      case 'Electrician':
        return const Icon(Icons.electrical_services, color: Colors.green);

      default:
        return const Icon(Icons.home_repair_service, color: Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data!.myJobs.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.50,
        alignment: Alignment.center,
        child: const Center(
          child: Text(
            'No jobs found',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Column(
      children: data!.myJobs.map((job) {
        return Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          MyJobDetails(job: job), // Your terms page
                    ),
                  );
                },
                child: Card(
                  elevation: 0,
                  color: const Color(secondaryColor),
                  child: ListTile(
                    leading: getIcon(job.serviceName ?? ''),
                    title: Text(job.address ?? ''),
                    subtitle: Text(job.statusToShow ?? ''),
                    trailing: Text(job.kind ?? ''),
                  ),
                )));
      }).toList(),
    );
  }
}
