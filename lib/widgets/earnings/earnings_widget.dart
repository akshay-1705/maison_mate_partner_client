import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/earnings_response.dart';
import 'package:maison_mate/network/response/payment_response.dart';
import 'package:maison_mate/widgets/earnings/earnings_breakdown.dart';
import 'package:maison_mate/widgets/earnings/payment_card.dart';

class EarningsWidget extends StatefulWidget {
  const EarningsWidget({Key? key}) : super(key: key);

  @override
  State<EarningsWidget> createState() => _EarningsWidgetState();
}

class _EarningsWidgetState extends State<EarningsWidget> {
  String? selectedDateRange;
  Future<ApiResponse>? futureData;
  static String apiUrl = '$baseApiUrl/partners/payments';
  int? endTime;
  int? startTime;
  String? selectedFilter;
  List<PaymentResponse> paymentsData = [];
  List<PaymentResponse> filteredPayments = [];

  @override
  void initState() {
    selectedFilter = 'All';
    selectedDateRange = 'This week';
    DateTime now = DateTime.now().toUtc();
    DateTime startOfThisWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime startOfThisWeekDay = DateTime.utc(
        startOfThisWeek.year, startOfThisWeek.month, startOfThisWeek.day);
    startTime = startOfThisWeekDay.millisecondsSinceEpoch ~/ 1000;
    endTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    super.initState();
    refreshData();
  }

  Future<void> refreshData() async {
    var completeApiUrl = '$apiUrl?start_time=$startTime&end_time=$endTime';
    final response = await GetClient.fetchData(completeApiUrl);
    setState(() {
      if (mounted) {
        futureData = Future.value(response);
        var data = response.data as EarningsResponse;
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
              return PaymentCard(context: context, payment: payment);
            }).toList()),
            const SizedBox(height: 300),
          ]));
    }
  }

  Widget filters() {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Fetch filter from API
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

  void showDateRangeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Fetch dates from API or think of a better approach
              ListTile(
                title: const Text('This week'),
                onTap: () {
                  setState(() {
                    selectedDateRange = 'This week';
                    DateTime now = DateTime.now().toUtc();
                    DateTime startOfThisWeek =
                        now.subtract(Duration(days: now.weekday - 1));
                    DateTime startOfThisWeekDay = DateTime.utc(
                        startOfThisWeek.year,
                        startOfThisWeek.month,
                        startOfThisWeek.day);
                    startTime =
                        startOfThisWeekDay.millisecondsSinceEpoch ~/ 1000;
                    endTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
                    selectedFilter = 'All';
                  });
                  refreshData();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Last week'),
                onTap: () {
                  setState(() {
                    selectedDateRange = 'Last week';
                    DateTime now = DateTime.now().toUtc();
                    DateTime startOfLastWeek =
                        now.subtract(Duration(days: now.weekday + 6));
                    DateTime startOfLastWeekDay = DateTime.utc(
                        startOfLastWeek.year,
                        startOfLastWeek.month,
                        startOfLastWeek.day);
                    startTime =
                        startOfLastWeekDay.millisecondsSinceEpoch ~/ 1000;

                    DateTime endOfLastWeek =
                        startOfLastWeek.add(const Duration(days: 6));
                    DateTime endOfLastWeekDay = DateTime.utc(endOfLastWeek.year,
                        endOfLastWeek.month, endOfLastWeek.day, 23, 59, 59);
                    endTime = endOfLastWeekDay.millisecondsSinceEpoch ~/ 1000;
                    selectedFilter = 'All';
                  });
                  refreshData();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('This month'),
                onTap: () {
                  setState(() {
                    selectedDateRange = 'This month';
                    DateTime now = DateTime.now().toUtc();
                    DateTime startOfThisMonth =
                        DateTime.utc(now.year, now.month, 1);
                    startTime = startOfThisMonth.millisecondsSinceEpoch ~/ 1000;
                    endTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
                    selectedFilter = 'All';
                  });
                  refreshData();
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
            start: DateTime.fromMillisecondsSinceEpoch(startTime! * 1000,
                isUtc: true),
            end: DateTime.fromMillisecondsSinceEpoch(endTime! * 1000,
                isUtc: true),
          ),
        );
        setState(() {
          selectedDateRange = pickedRange != null
              ? '${pickedRange.start.day}/${pickedRange.start.month}/${pickedRange.start.year} - ${pickedRange.end.day}/${pickedRange.end.month}/${pickedRange.end.year}'
              : 'This week';
          if (pickedRange != null) {
            startTime = pickedRange.start.millisecondsSinceEpoch ~/ 1000;
            endTime = pickedRange.end.millisecondsSinceEpoch ~/ 1000;
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          });
          selectedFilter = 'All';
        });
        refreshData();
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
                Text(selectedDateRange ?? '',
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
        return EarningsBreakdown(data: data);
      },
    );
  }
}
