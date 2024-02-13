import 'package:flutter/material.dart';
import 'package:maison_mate/network/response/payment_response.dart';
import 'package:maison_mate/provider/my_job_details_model.dart';
import 'package:maison_mate/widgets/my_jobs/my_job_details.dart';
import 'package:provider/provider.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({
    super.key,
    required this.context,
    required this.payment,
  });

  final BuildContext context;
  final PaymentResponse payment;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChangeNotifierProvider(
              create: (context) => MyJobDetailsModel(),
              child: MyJobDetails(jobId: payment.jobAssignmentId),
            );
          }));
        },
        child: Container(
            margin:
                const EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 10),
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  payment.jobCompletedAt,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
                Text('\u00A3${payment.totalAmount}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold))
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(payment.paymentStatus ?? '',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w400))
              ]),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                    child: Text(payment.serviceName,
                        style: const TextStyle(fontSize: 15))),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F5F2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Commission: ${payment.commission}%',
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ]),
            ])));
  }
}
