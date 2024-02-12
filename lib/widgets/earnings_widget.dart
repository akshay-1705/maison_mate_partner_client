import 'package:flutter/material.dart';

class EarningsWidget extends StatefulWidget {
  const EarningsWidget({Key? key}) : super(key: key);

  @override
  State<EarningsWidget> createState() => _EarningsWidgetState();
}

class _EarningsWidgetState extends State<EarningsWidget> {
  String selectedDateRange = 'This week';

  @override
  Widget build(BuildContext context) {
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
        body: renderData());
  }

  Column renderData() {
    return Column(children: [
      totalEarnings(context),
      filters(),
      Expanded(
        child: SingleChildScrollView(
          child: payments(),
        ),
      ),
    ]);
  }

  Widget payments() {
    return SingleChildScrollView(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: CustomScrollView(slivers: <Widget>[
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return list();
              }, childCount: 1))
            ])));
  }

  Widget list() {
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
            paymentCard(),
            paymentCard(),
            paymentCard(),
            paymentCard(),
            paymentCard(),
            paymentCard(),
            paymentCard(),
            paymentCard(),
            paymentCard(),
            const SizedBox(height: 300),
          ]));
    }
  }

  Container paymentCard() {
    return Container(
        margin: const EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 10),
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
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '23/02/23',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
                Text('\u00A315',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
              ]),
          const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text('Paid',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400))
          ]),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Expanded(
                child: Text('Plumbing', style: TextStyle(fontSize: 15))),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE9F5F2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'Commission: 20%',
                style: TextStyle(
                  fontSize: 13,
                  // color: Colors.white,
                ),
              ),
            ),
          ]),
        ]));
  }

  Widget filters() {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            filterOption('All', true),
            const SizedBox(width: 10),
            filterOption('Paid', false),
            const SizedBox(width: 10),
            filterOption('Pending', false),
            const SizedBox(width: 10),
            filterOption('Failed', false),
          ],
        ),
      ),
    );
  }

  Widget filterOption(String label, bool selected) {
    return GestureDetector(
      onTap: () {},
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
              ListTile(
                title: const Text('Custom date range'),
                onTap: () async {
                  final DateTimeRange? pickedRange = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2024),
                    lastDate: DateTime.now(),
                    initialDateRange: DateTimeRange(
                      start: DateTime.now().subtract(
                          const Duration(days: 6)), // Default start date
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
              ),
            ],
          ),
        );
      },
    );
  }

  Widget totalEarnings(BuildContext context) {
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
                const Icon(Icons.calendar_month,
                    color: Colors.white70, size: 20),
                const SizedBox(width: 5),
                Text(selectedDateRange,
                    style: const TextStyle(color: Colors.white70, fontSize: 16))
              ])),
          const SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              '\u00A3230',
              style: TextStyle(
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
                showDialog(
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
                          buildInfoRow('Total Earnings', '\u00A3300'),
                          buildInfoRow('Our Commission', '-\u00A370'),
                          buildInfoRow('Your Share', '\u00A3230'),
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
              },
            ),
          ]),
        ],
      ),
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
