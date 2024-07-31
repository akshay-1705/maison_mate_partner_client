import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/widgets/rewards/coupon_section.dart';

class CouponsHistoryPage extends StatefulWidget {
  const CouponsHistoryPage({Key? key}) : super(key: key);

  @override
  State<CouponsHistoryPage> createState() => _CouponsHistoryPageState();
}

class _CouponsHistoryPageState extends State<CouponsHistoryPage> {
  late Future<ApiResponse> futureData;
  static String apiUrl = '$baseApiUrl/partners/all_coupons';
  List<dynamic>? couponsHistory;
  int? totalCoupons;

  @override
  void initState() {
    super.initState();
    futureData = GetClient.fetchData(apiUrl);
    futureData.then((value) {
      setState(() {
        couponsHistory = value.data['all_coupons'];
        totalCoupons = value.data['total_coupons'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupons Earned'),
      ),
      body: CouponSection(
        coupons: couponsHistory ?? [],
      ),
    );
  }
}
