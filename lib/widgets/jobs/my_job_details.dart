import 'package:flutter/material.dart';
import 'package:maison_mate/network/response/job_item_response.dart';
import 'package:maison_mate/shared/my_form.dart';

class MyJobDetails extends StatefulWidget {
  final JobItemResponse job;
  const MyJobDetails({Key? key, required this.job}) : super(key: key);

  @override
  State<MyJobDetails> createState() => _MyJobDetailsState();
}

class _MyJobDetailsState extends State<MyJobDetails> {
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
      addressDetails(),
      const SizedBox(height: 20),
      Container(
        height: 4,
        color: Colors.black12,
      ),
      const SizedBox(height: 10),
      paymentDetails(),
      const SizedBox(height: 10),
      Container(
        height: 4,
        color: Colors.black12,
      ),
      const SizedBox(height: 10),
      jobDetails(),
    ]));
  }

  Padding jobDetails() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(children: [
                  const Text(
                    'Abdul Markram',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(width: 10),
                  IntrinsicWidth(
                      child: Container(
                    padding: const EdgeInsets.only(
                        top: 7, left: 15, right: 15, bottom: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: const Text(
                      'Chat',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.purple),
                    ),
                  )),
                ]),
                const SizedBox(height: 10),
                const Text(
                  'Job Status: Pending',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 16),
                MyForm.submitButton("Start Job", () async {}),
              ]),
        ));
  }

  Padding paymentDetails() {
    return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Align(
            alignment: Alignment.topLeft,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Payment Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bathroom Tap repair',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '10',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Convenience Fee',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '50',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ]),
                  SizedBox(height: 20),
                  Divider(
                    height: 1,
                    thickness: 0.4,
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
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '60',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ]),
                  SizedBox(height: 20),
                  Text(
                    'Status: Pending',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ])));
  }

  Padding addressDetails() {
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  // const SizedBox(height: 5),

                  const SizedBox(height: 5),
                  const Text(
                    '3rd floor Hno 356 Sector 47 Gurugram, 122018',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 15),
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
                                  fontSize: 15, fontWeight: FontWeight.w500),
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
