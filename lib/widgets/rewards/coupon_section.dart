import 'package:flutter/material.dart';
import 'package:maison_mate/widgets/rewards/coupon_card.dart';

class CouponSection extends StatelessWidget {
  final List<String> coupons;

  const CouponSection({
    Key? key,
    required this.coupons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> displayedCoupons =
        coupons.length > 3 ? coupons.sublist(0, 3) : coupons;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...displayedCoupons
            .map((coupon) => CouponCard(coupon: coupon))
            .toList(),
      ],
    );
  }
}
