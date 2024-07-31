import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/widgets/rewards/activity_history.dart';
import 'package:maison_mate/widgets/rewards/activity_history_page.dart';
import 'package:maison_mate/widgets/rewards/coupon_section.dart';
import 'package:maison_mate/widgets/rewards/coupons_history_page.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<ApiResponse> futureData;
  static String apiUrl = '$baseApiUrl/partners/latest_activity';
  List<dynamic>? activityHistory;
  List<dynamic>? couponsHistory;
  int? totalActivities;
  int? totalCoupons;

  @override
  void initState() {
    super.initState();
    futureData = GetClient.fetchData(apiUrl);
    futureData.then((value) {
      setState(() {
        activityHistory = value.data['latest_activity'];
        couponsHistory = value.data['coupons'];
        totalActivities = value.data['total_activities'];
        totalCoupons = value.data['total_coupons'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How to Get the Offers',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const OfferCard(
                title: 'Daily Meal Deal',
                description:
                    'Complete 6 hours of work in 24 hours (12am to 11.59pm) to get a meal deal worth £5.00 only on Tesco.',
                icon: Icons.fastfood,
                backgroundColor: Colors.orangeAccent,
              ),
              const SizedBox(height: 16),
              const OfferCard(
                title: 'Weekly Pizza',
                description:
                    'Complete 30 hours of work in a week (Monday-Sunday) to get a pizza worth £10.00 only on Tesco.',
                icon: Icons.local_pizza,
                backgroundColor: Colors.redAccent,
              ),
              const SizedBox(height: 32),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  'Activity History',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                if (totalActivities != null && totalActivities! > 3)
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ActivityHistoryPage(),
                        ),
                      );
                    },
                    child: Text('Show all ($totalActivities)'),
                  ),
              ]),
              const SizedBox(height: 16),
              if (activityHistory == null || activityHistory!.isEmpty)
                const Center(
                  child: Text(
                    'No activity to show',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              else
                ActivityHistory(
                  activityHistory: activityHistory ?? [],
                ),
              const SizedBox(height: 32),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  'Coupons Earned',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                if (totalCoupons != null && totalCoupons! > 3)
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CouponsHistoryPage(),
                        ),
                      );
                    },
                    child: Text('Show all ($totalCoupons)'),
                  ),
              ]),
              const SizedBox(height: 16),
              if (couponsHistory == null || couponsHistory!.isEmpty)
                const Center(
                  child: Text(
                    'No coupons available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              else
                CouponSection(
                  coupons: couponsHistory!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color backgroundColor;

  const OfferCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
