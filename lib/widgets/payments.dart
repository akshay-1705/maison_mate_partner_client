import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';

class PaymentsWidget extends StatefulWidget {
  const PaymentsWidget({Key? key}) : super(key: key);

  @override
  State<PaymentsWidget> createState() => _PaymentsWidgetState();
}

class _PaymentsWidgetState extends State<PaymentsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 10),
      const Row(
        children: [
          Flexible(
            flex: 1,
            child: PaymentCard(
              title: 'Total Payments',
              count: '5',
              color: Colors.green,
            ),
          ),
          Flexible(
            flex: 1,
            child: PaymentCard(
              title: 'Pending Payments',
              count: '4',
              color: Colors.red,
            ),
          ),
        ],
      ),
      const SizedBox(height: 40),

      Container(
          alignment: Alignment.center,
          child: const Text(
            'All Payments',
            style: TextStyle(
              color: Color(themeColor), // Text color
              fontSize: 25,
            ),
          )),
      const SizedBox(
          height: 20), // Add spacing between the cards and the payment list
      const PaymentList(),
    ]);
  }
}

class PaymentList extends StatelessWidget {
  const PaymentList({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for the payment list
    final List<Map<String, String>> paymentData = [
      {
        'Description': 'Replace door handles',
        'PaymentID': '2023-10-15',
        'Amount': '\$100',
        'Status': 'Paid',
      },
      {
        'Description': 'Replace door handles',
        'PaymentID': '2023-10-16',
        'Amount': '\$50',
        'Status': 'Pending',
      },
      {
        'Description': 'Replace door handles',
        'PaymentID': '2023-10-16',
        'Amount': '\$50',
        'Status': 'Pending',
      },
      {
        'Description': 'Replace door handles',
        'PaymentID': '2023-10-16',
        'Amount': '\$50',
        'Status': 'Pending',
      },
      {
        'Description': 'Replace door handles',
        'PaymentID': '2023-10-16',
        'Amount': '\$50',
        'Status': 'Pending',
      },

      // Add more payment data here
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: paymentData.length,
      itemBuilder: (context, index) {
        final data = paymentData[index];
        return PaymentListItem(
          description: data['Description']!,
          paymentID: data['PaymentID']!,
          amount: data['Amount']!,
          status: data['Status']!,
        );
      },
    );
  }
}

class PaymentListItem extends StatelessWidget {
  final String description;
  final String paymentID;
  final String amount;
  final String status;

  const PaymentListItem({
    super.key,
    required this.description,
    required this.paymentID,
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(secondaryColor),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: const Color(themeColor).withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(themeColor),
                    ),
                  ),
                  Text(
                    paymentID,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Amount: $amount',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Status: $status',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;

  const PaymentCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(secondaryColor),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: const Color(themeColor).withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(themeColor),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                count,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
