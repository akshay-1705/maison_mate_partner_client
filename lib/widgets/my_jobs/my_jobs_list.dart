import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/response/my_jobs_response.dart';
import 'package:maison_mate/provider/my_job_details_model.dart';
import 'package:maison_mate/widgets/my_jobs/my_job_details.dart';
import 'package:provider/provider.dart';

class MyJobsList extends StatelessWidget {
  final MyJobsResponse? data;
  const MyJobsList({Key? key, required this.data}) : super(key: key);

  Icon getServiceIcon(String service) {
    switch (service) {
      case 'Plumbing':
        return const Icon(Icons.plumbing, color: Colors.blue);
      case 'Handyman':
        return const Icon(Icons.handyman, color: Colors.brown);
      case 'Locksmith':
        return const Icon(Icons.lock, color: Colors.grey);
      case 'Painting':
        return const Icon(Icons.format_paint, color: Colors.green);
      case 'Heating/Cooling repairs':
        return const Icon(Icons.heat_pump, color: Colors.yellow);
      case 'Home Security System Repair':
        return const Icon(Icons.security, color: Color(awesomeColor));
      case 'Pest control':
        return const Icon(Icons.pest_control, color: Colors.black);
      case 'Electrician':
        return const Icon(Icons.electrical_services, color: Colors.purple);

      default:
        return const Icon(Icons.home_repair_service, color: Colors.green);
    }
  }

  Icon getStatusIcon(String jobStatus) {
    switch (jobStatus) {
      case 'Pending':
        return const Icon(Icons.access_time, color: Colors.orange);
      case 'Quote sent':
        return const Icon(Icons.send_sharp, color: Color(awesomeColor));
      case 'Quote accepted':
        return const Icon(Icons.send_sharp, color: Colors.green);
      case 'En route':
        return const Icon(Icons.directions_car_outlined, color: Colors.blue);
      case 'In progress':
        return const Icon(Icons.miscellaneous_services, color: Colors.blue);
      case 'Completed':
        return const Icon(Icons.check, color: Colors.green);
      case 'Cancelled':
        return const Icon(Icons.cancel, color: Colors.red);

      default:
        return const Icon(Icons.question_mark, color: Colors.orange);
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

    return Column(children: [
      Column(
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ChangeNotifierProvider(
                        create: (context) => MyJobDetailsModel(),
                        child: MyJobDetails(job: job),
                      );
                    }));
                  },
                  child: Card(
                    elevation: 0,
                    color: const Color(secondaryColor),
                    child: ListTile(
                      leading: getServiceIcon(job.serviceName ?? ''),
                      title: Text(
                        job.address ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                      subtitle: Row(children: [
                        Text(
                          job.statusToShow ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 5),
                        getStatusIcon(job.statusToShow ?? '')
                      ]),
                      trailing: Text(job.kind ?? ''),
                    ),
                  )));
        }).toList(),
      ),
      const SizedBox(
        height: 280,
      )
    ]);
  }
}
