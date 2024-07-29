import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/on_duty_model.dart';
import 'package:maison_mate/widgets/earnings/earnings_widget.dart';
import 'package:maison_mate/widgets/my_jobs/my_jobs.dart';
import 'package:maison_mate/widgets/rewards/details_screen.dart';
import 'package:maison_mate/widgets/rewards/offer_banner.dart';
import 'package:provider/provider.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  late Future<ApiResponse> futureData;
  static String apiUrl = '$baseApiUrl/partners/dashboard';

  @override
  void initState() {
    super.initState();
    futureData = GetClient.fetchData(apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    var stateModel = Provider.of<OnDutyModel>(context, listen: false);
    return GetRequestFutureBuilder<dynamic>(
      apiUrl: apiUrl,
      future: futureData,
      builder: (context, data) {
        return renderData(data, stateModel);
      },
    );
  }

  SingleChildScrollView renderData(data, OnDutyModel stateModel) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              if (stateModel.showOffer) ...[
                const OfferBanner(),
                const SizedBox(height: 40),
              ],
              earningsSummary(data),
              const SizedBox(height: 40),
              banner(),
              const SizedBox(height: 40),
              jobsSummary(data),
              const SizedBox(height: 40),
              // if (stateModel.showOffer) ...[
              //   rewardsSummary(),
              //   const SizedBox(height: 40),
              // ]
            ])));
  }

  Column banner() {
    return Column(
      children: [
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
      ],
    );
  }

  Widget earningsSummary(data) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Payments',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EarningsWidget()));
                    },
                    child: const Text('View Earnings',
                        style: TextStyle(
                            fontSize: 13,
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
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(height: 10),
                                Text(data['payments']['total'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400))
                              ]),
                          const SizedBox(width: 15),
                          Flexible(
                              child: Icon(Icons.payment,
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
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Paid',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(height: 10),
                                Text(data['payments']['paid'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400))
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
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Pending',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(height: 10),
                                Text(data['payments']['pending'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400))
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
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Failed',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(height: 10),
                                Text(data['payments']['failed'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400))
                              ]),
                          const SizedBox(width: 15),
                          Flexible(
                              child: Icon(Icons.payment,
                                  color: Colors.red.shade300, size: 24)),
                        ]))),
          ])
        ]);
  }

  Widget rewardsSummary() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Rewards',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DetailsScreen()));
                    },
                    child: const Text('View Details',
                        style: TextStyle(
                            fontSize: 13,
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
                          const Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text('Today',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(height: 10),
                                Text('1.2hrs / 6hrs',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400))
                              ])),
                          const SizedBox(width: 15),
                          Icon(Icons.timer,
                              color: Colors.purple.shade300, size: 24),
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
                          const Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text('This week',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(height: 10),
                                Text('10.2hrs / 30hrs',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400))
                              ])),
                          const SizedBox(width: 15),
                          Icon(Icons.timer,
                              color: Colors.green.shade300, size: 24),
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
                          const Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text('Meal deals',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(height: 10),
                                Text('2',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400))
                              ])),
                          const SizedBox(width: 15),
                          Icon(Icons.fastfood,
                              color: Colors.blue.shade300, size: 24),
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
                                Text('Pizza',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(height: 10),
                                Text('2',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400))
                              ]),
                          SizedBox(width: 15),
                          Flexible(
                              child: Icon(Icons.local_pizza,
                                  color: Colors.black54, size: 24)),
                        ]))),
          ])
        ]);
  }

  Widget jobsSummary(data) {
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
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyJobsWidget()));
                    },
                    child: const Text('View All',
                        style: TextStyle(
                            fontSize: 13,
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
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(height: 10),
                                Text(data['jobs']['total'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400))
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
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Completed',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(height: 10),
                                Text(data['jobs']['completed'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400))
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
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Pending',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(height: 10),
                                Text(data['jobs']['pending'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400))
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
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Cancelled',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(height: 10),
                                Text(data['jobs']['cancelled'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400))
                              ]),
                          const SizedBox(width: 15),
                          Flexible(
                              child: Icon(Icons.home_repair_service,
                                  color: Colors.red.shade300, size: 24)),
                        ]))),
          ])
        ]);
  }
}
