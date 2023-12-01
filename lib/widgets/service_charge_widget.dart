import 'package:flutter/material.dart';

class ServiceChargeWidget extends StatelessWidget {
  const ServiceChargeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 1,
        color: Colors.black12,
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          const SizedBox(width: 15),
          Icon(
            Icons.card_giftcard,
            color: Colors.purple.shade300,
            size: 35,
          ),
          const SizedBox(width: 10),
          const Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Maximize your earnings with us! We only take a small 20% service fee – your success is our priority.',
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
    ]);
  }
}
