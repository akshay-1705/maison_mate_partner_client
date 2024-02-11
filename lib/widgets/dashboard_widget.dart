import 'package:flutter/material.dart';
import 'package:maison_mate/widgets/my_jobs/my_jobs.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return renderData();
  }

  SingleChildScrollView renderData() {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              earningsSummary(),
              const SizedBox(height: 40),
              Container(
                height: 1,
                color: Colors.black12,
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  SizedBox(width: 15),
                  Icon(
                    Icons.card_giftcard,
                    color: Colors.cyan,
                    size: 35,
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Maximize your earnings with us! We only take a small 20% commission – your success is our priority. Any eligible discount on the commission will be calculated upon job completion.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 1,
                color: Colors.black12,
              ),
              const SizedBox(height: 40),
              jobsSummary()
            ])));
  }

  Widget earningsSummary() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payments',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('View All',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold))
              ]),
          Row(children: [
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade100,
                      border: Border.all(
                        color: Colors.grey.shade100,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Earnings',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 10),
                                Text('200 pounds',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600))
                              ]),
                          const SizedBox(width: 15),
                          Flexible(
                              child: Icon(Icons.currency_pound,
                                  color: Colors.purple.shade300, size: 24)),
                        ]))),
            const SizedBox(width: 15),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade100,
                      border: Border.all(
                        color: Colors.grey.shade100,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Completed',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 10),
                                Text('30',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600))
                              ]),
                          const SizedBox(width: 15),
                          Flexible(
                              child: Icon(Icons.payment,
                                  color: Colors.green.shade300, size: 24)),
                        ]))),
          ]),
          const SizedBox(height: 5),
          Row(children: [
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade100,
                      border: Border.all(
                        color: Colors.grey.shade100,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pending',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 10),
                                Text('10',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600))
                              ]),
                          const SizedBox(width: 15),
                          Flexible(
                              child: Icon(Icons.payment,
                                  color: Colors.orange.shade300, size: 24)),
                        ]))),
            const SizedBox(width: 15),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade100,
                      border: Border.all(
                        color: Colors.grey.shade100,
                        width: 1.0,
                      ),
                    ),
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Failed',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 10),
                                Text('5',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600))
                              ]),
                          SizedBox(width: 15),
                          Flexible(
                              child: Icon(Icons.payment,
                                  color: Color(0xffFFAB9C), size: 24)),
                        ]))),
          ])
        ]);
  }

  Widget jobsSummary() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('My Jobs',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyJobsWidget()));
                    },
                    child: const Text('View All',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold)))
              ]),
          Row(children: [
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade100,
                      border: Border.all(
                        color: Colors.grey.shade100,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 10),
                                Text('50',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600))
                              ]),
                          const SizedBox(width: 15),
                          Flexible(
                              child: Icon(Icons.home_repair_service,
                                  color: Colors.purple.shade300, size: 24)),
                        ]))),
            const SizedBox(width: 15),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade100,
                      border: Border.all(
                        color: Colors.grey.shade100,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Completed',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 10),
                                Text('30',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600))
                              ]),
                          const SizedBox(width: 15),
                          Flexible(
                              child: Icon(Icons.home_repair_service,
                                  color: Colors.green.shade300, size: 24)),
                        ]))),
          ]),
          const SizedBox(height: 5),
          Row(children: [
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade100,
                      border: Border.all(
                        color: Colors.grey.shade100,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pending',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 10),
                                Text('10',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600))
                              ]),
                          const SizedBox(width: 15),
                          Flexible(
                              child: Icon(Icons.home_repair_service,
                                  color: Colors.orange.shade300, size: 24)),
                        ]))),
            const SizedBox(width: 15),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade100,
                      border: Border.all(
                        color: Colors.grey.shade100,
                        width: 1.0,
                      ),
                    ),
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Cancelled',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 10),
                                Text('10',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600))
                              ]),
                          SizedBox(width: 15),
                          Flexible(
                              child: Icon(Icons.home_repair_service,
                                  color: Color(0xffFFAB9C), size: 24)),
                        ]))),
          ])
        ]);
  }
}
