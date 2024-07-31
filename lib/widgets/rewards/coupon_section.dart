import 'package:flutter/material.dart';
import 'package:maison_mate/widgets/rewards/coupon_card.dart';

class CouponSection extends StatelessWidget {
  final List<dynamic> coupons;

  const CouponSection({
    Key? key,
    required this.coupons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...coupons.map((coupon) => CouponCard(coupon: coupon)).toList(),
      ],
    ));
  }
}
