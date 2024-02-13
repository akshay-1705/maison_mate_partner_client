import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/earnings_response.dart';
import 'package:maison_mate/network/response/payment_response.dart';
import 'package:maison_mate/provider/my_job_details_model.dart';
import 'package:maison_mate/widgets/my_jobs/my_job_details.dart';
import 'package:provider/provider.dart';

class EarningsWidget extends StatefulWidget {
  const EarningsWidget({Key? key}) : super(key: key);

  @override
  State<EarningsWidget> createState() => _EarningsWidgetState();
}

class _EarningsWidgetState extends State<EarningsWidget> {
  String selectedDateRange = 'This week';
  late Future<ApiResponse> futureData;
  static String apiUrl = '$baseApiUrl/partners/payments';
  int endTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  DateTime startDate = DateTime.now().toUtc().subtract(const Duration(days: 6));
  late int startTime;
  String selectedFilter = 'All';
  List<PaymentResponse> paymentsData = [];
  List<PaymentResponse> filteredPayments = [];

  @override
  void initState() {
    startTime = DateTime.utc(startDate.year, startDate.month, startDate.day)
            .millisecondsSinceEpoch ~/
        1000;
    super.initState();
    var completeApiUrl = '$apiUrl?start_time=$startTime&end_time=$endTime';
    futureData = GetClient.fetchData(completeApiUrl);
    futureData.then((value) {
      if (mounted) {
        var data = value.data as EarningsResponse;
        paymentsData = data.payments;
        filteredPayments = paymentsData;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var completeApiUrl = '$apiUrl?start_time=$startTime&end_time=$endTime';
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: AppBar(
              backgroundColor: Colors.green.shade500,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: const Text(
                'Your Total Earnings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )),
        body: GetRequestFutureBuilder<dynamic>(
            future: futureData,
            apiUrl: completeApiUrl,
            builder: (context, data) {
              return renderData(data);
            }));
  }

  Column renderData(EarningsResponse data) {
    return Column(children: [
      totalEarnings(context, data),
      filters(),
      Expanded(
        child: SingleChildScrollView(
          child: payments(data),
        ),
      ),
    ]);
  }

  Widget filters() {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            filterOption('All', selectedFilter == 'All'),
            const SizedBox(width: 10),
            filterOption('Paid', selectedFilter == 'Paid'),
            const SizedBox(width: 10),
            filterOption('Pending', selectedFilter == 'Pending'),
            const SizedBox(width: 10),
            filterOption('Failed', selectedFilter == 'Failed'),
          ],
        ),
      ),
    );
  }

  Widget filterOption(String label, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
          if (label == 'All') {
            filteredPayments = paymentsData;
          } else {
            filteredPayments = paymentsData
                .where((payment) => payment.paymentStatus == label)
                .toList();
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF357DED) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? const Color(0xFF357DED) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected ? Colors.white : Colors.black,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget payments(EarningsResponse data) {
    return SingleChildScrollView(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: CustomScrollView(slivers: <Widget>[
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return list(data);
              }, childCount: 1))
            ])));
  }

  Widget list(EarningsResponse data) {
    if (2 != 2) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.50,
        alignment: Alignment.center,
        child: const Center(
          child: Text(
            'No payments found',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    } else {
      return Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(children: [
            Column(
                children: filteredPayments.map((payment) {
              return paymentCard(payment);
            }).toList()),
            const SizedBox(height: 300),
          ]));
    }
  }

  GestureDetector paymentCard(PaymentResponse payment) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChangeNotifierProvider(
              create: (context) => MyJobDetailsModel(),
              child: MyJobDetails(jobId: payment.jobAssignmentId),
            );
          }));
        },
        child: Container(
            margin:
                const EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 10),
            padding:
                const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
              // color: Colors.grey.shade100,
            ),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  payment.jobCompletedAt,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
                Text('\u00A3${payment.totalAmount}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold))
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(payment.paymentStatus ?? '',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w400))
              ]),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                    child: Text(payment.serviceName,
                        style: const TextStyle(fontSize: 15))),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F5F2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Commission: ${payment.commission}%',
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ]),
            ])));
  }

  void showDateRangeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('This week'),
                onTap: () {
                  setState(() {
                    selectedDateRange = 'This week';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Last week'),
                onTap: () {
                  setState(() {
                    selectedDateRange = 'Last week';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('This month'),
                onTap: () {
                  setState(() {
                    selectedDateRange = 'This month';
                  });
                  Navigator.pop(context);
                },
              ),
              customDateRangeTile(context),
            ],
          ),
        );
      },
    );
  }

  ListTile customDateRangeTile(BuildContext context) {
    return ListTile(
      title: const Text('Custom date range'),
      onTap: () async {
        final DateTimeRange? pickedRange = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2024),
          lastDate: DateTime.now(),
          initialDateRange: DateTimeRange(
            start: DateTime.now()
                .subtract(const Duration(days: 6)), // Default start date
            end: DateTime.now(), // Default end date
          ),
        );
        setState(() {
          selectedDateRange = pickedRange != null
              ? '${pickedRange.start.day}/${pickedRange.start.month}/${pickedRange.start.year} - ${pickedRange.end.day}/${pickedRange.end.month}/${pickedRange.end.year}'
              : 'This week';
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          });
        });
      },
    );
  }

  Widget totalEarnings(BuildContext context, EarningsResponse data) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.green.shade500,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () {
                showDateRangeSelector(context);
              },
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.calendar_month, color: Colors.white, size: 20),
                const SizedBox(width: 5),
                Text(selectedDateRange,
                    style: const TextStyle(color: Colors.white, fontSize: 16))
              ])),
          const SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              '\u00A3${data.partnerShare}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info),
              color: Colors.white,
              iconSize: 20,
              onPressed: () {
                earningsBreakdown(context, data);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Future<dynamic> earningsBreakdown(
      BuildContext context, EarningsResponse data) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Earnings Breakdown',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue, // Change title color
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInfoRow('Total Earnings', '\u00A3${data.totalEarnings}'),
              buildInfoRow('Our Commission', '-\u00A3${data.totalCommission}'),
              buildInfoRow('Your Share', '\u00A3${data.partnerShare}'),
              const Text(
                  'Payments may take upto 5 business days to reflect in your account.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Colors.blue, // Change close button color
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
