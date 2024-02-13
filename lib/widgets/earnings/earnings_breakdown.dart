import 'package:flutter/material.dart';
import 'package:maison_mate/network/response/earnings_response.dart';

class EarningsBreakdown extends StatefulWidget {
  const EarningsBreakdown({
    super.key,
    required this.data,
  });

  final EarningsResponse data;
  @override
  State<EarningsBreakdown> createState() => _EarningsBreakdownState();
}

class _EarningsBreakdownState extends State<EarningsBreakdown> {
  @override
  Widget build(BuildContext context) {
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
          InfoRow(
              title: 'Total Earnings',
              value: '\u00A3${widget.data.totalEarnings}'),
          InfoRow(
              title: 'Our Commission',
              value: '-\u00A3${widget.data.totalCommission}'),
          InfoRow(
              title: 'Your Share', value: '\u00A3${widget.data.partnerShare}'),
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
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
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
