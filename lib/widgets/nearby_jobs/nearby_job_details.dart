import 'package:flutter/material.dart';
import 'package:maison_mate/network/response/job_response.dart';
import 'package:maison_mate/shared/my_form.dart';

class NearbyJobDetails extends StatefulWidget {
  final JobResponse job;
  const NearbyJobDetails({Key? key, required this.job}) : super(key: key);

  @override
  State<NearbyJobDetails> createState() => _NearbyJobDetailsState();
}

class _NearbyJobDetailsState extends State<NearbyJobDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: showDetails());
  }

  SingleChildScrollView showDetails() {
    return SingleChildScrollView(
        child: Column(children: [
      topCardContents(),
      const SizedBox(height: 20),
      Container(
        height: 10,
        color: Colors.black12,
      ),
      bottomCardContents(),
      const SizedBox(height: 50),
      MyForm.submitButton("Accept", () async {}),
    ]));
  }

  Padding bottomCardContents() {
    return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Align(
            alignment: Alignment.topLeft,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Job Details',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bathroom Tap repair',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '10',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Convenience Fee',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '50',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ]),
                  SizedBox(height: 20),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.black26,
                    endIndent: 0,
                    indent: 0,
                    // dash: 5, // Set the length of the dashes
                  ),
                  SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '60',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ]),
                ])));
  }

  Padding topCardContents() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
            alignment: Alignment.topLeft,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Nov 1, 2023 at 4:00pm',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Abdul Markram',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  const Text(
                    '3rd floor Hno 356 Sector 47 Gurugram, 122018',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 20),
                  IntrinsicWidth(
                      child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: const Row(children: [
                            Text(
                              'See on map',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.directions,
                              size: 24,
                              color: Colors.green,
                            )
                          ]))),
                ])));
  }
}
