import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:share_plus/share_plus.dart';

class ReferAndEarn extends StatefulWidget {
  const ReferAndEarn({super.key});

  @override
  State<ReferAndEarn> createState() => _ReferAndEarnState();
}

class _ReferAndEarnState extends State<ReferAndEarn> {
  late Future<ApiResponse> futureData;
  static String apiUrl = '$baseApiUrl/partners/discount';

  @override
  void initState() {
    super.initState();
    futureData = GetClient.fetchData(apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    return GetRequestFutureBuilder<dynamic>(
      apiUrl: apiUrl,
      future: futureData,
      builder: (context, data) {
        return renderData(data);
      },
    );
  }

  Widget renderData(data) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                discountedJobs(data),
                summary(data),
                howItWorks(),
              ],
            )));
  }

  Widget discountedJobs(data) {
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
            text: TextSpan(
              text: 'Left in purse: ',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: data['count'].toString(),
                  style: const TextStyle(
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
            'Refer more friends to get FLAT 50% discount on commission. Discount is automatically applied upon job completion.',
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
          buildStepText('1. Share referral link with your friends.'),
          buildStepText('2. Your friend signs up using your referral code.'),
          buildStepText(
              '3. Your friend gets ONE discounted job credited in their purse.'),
          buildStepText(
              '4. You get ONE discounted job credited in your purse once your friend completes a job.'),
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

  Widget summary(data) {
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
            'Refer and get FLAT 50% off',
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
                  'Refer your friends to Maison Mate and get FLAT 50% discount on commission. Share the referral link.',
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Referral Code:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 5),
              Text(
                data['referral_code'] ?? '',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 5),
          GestureDetector(
              onTap: () {
                String text =
                    "Join Maison Mate and get an additional discount of FLAT 50%: https://maisonmate.page.link/ZCg5. To redeem the voucher, please install the app using the link. Use the referral code: ${data['referral_code']} while sign up to get the discount.";
                Share.share(text);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Share link',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.ios_share,
                    color: Colors.blue,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
