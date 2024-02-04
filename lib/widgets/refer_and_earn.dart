import 'package:flutter/material.dart';

class ReferAndEarn extends StatefulWidget {
  const ReferAndEarn({super.key});

  @override
  State<ReferAndEarn> createState() => _ReferAndEarnState();
}

class _ReferAndEarnState extends State<ReferAndEarn> {
  @override
  Widget build(BuildContext context) {
    return renderData();
  }

  Widget renderData() {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                discountedJobs(),
                summary(),
                howItWorks(),
              ],
            )));
  }

  Widget discountedJobs() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        // color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discounted Jobs',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  // color: Colors.blue,
                ),
              ),
              SizedBox(width: 15),
              Icon(
                Icons.local_offer,
                color: Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: const TextSpan(
              text: 'Left in purse: ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: '3',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Refer more friends to get more discounts on commission. Discounts are automatically calculated upon job completion.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget howItWorks() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // color: Colors.blue.shade100,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How it Works',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 15),
          buildStepText('1. Share referral code with your friends.'),
          buildStepText('2. Your friend signs up using your referral code.'),
          buildStepText(
              '3. Your friend gets up to 100% discount on the commission for one job they do.'),
          buildStepText(
              '4. You get upto 100% discount on the commission for one job.'),
        ],
      ),
    );
  }

  Widget buildStepText(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget summary() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // color: Colors.blue.shade100,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Refer and Get Up to 100% off',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Refer your friends to Maison Mate and get up to 100% discount on commission. Share the referral code.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Icon(
                Icons.wallet_giftcard,
                color: Colors.blue.shade800,
                size: 50,
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Referral Code:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 5),
              Text(
                'HJAURASR',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
