import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/receipt_response.dart';

class ReceiptWidget extends StatefulWidget {
  final int? jobId;
  const ReceiptWidget({super.key, required this.jobId});

  @override
  State<ReceiptWidget> createState() => _ReceiptWidgetState();
}

class _ReceiptWidgetState extends State<ReceiptWidget> {
  late Future<ApiResponse> futureData;
  static String apiUrl = '$baseApiUrl/partners/receipt';

  @override
  void initState() {
    super.initState();
    var completeApiUrl = '$apiUrl?job_assignment_id=${widget.jobId}';
    futureData = GetClient.fetchData(completeApiUrl);
  }

  @override
  Widget build(BuildContext context) {
    var completeApiUrl = '$apiUrl?job_assignment_id=${widget.jobId}';
    return GetRequestFutureBuilder<dynamic>(
        future: futureData,
        apiUrl: completeApiUrl,
        builder: (context, data) {
          return renderData(context, data);
        });
  }

  SingleChildScrollView renderData(BuildContext context, ReceiptResponse data) {
    return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
            padding: const EdgeInsets.only(top: 28, left: 15, right: 40),
            width: MediaQuery.of(context).size.width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Payment Summary',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 20),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                paymentItems(data),
                const SizedBox(height: 25),
                Container(
                    width: double.infinity,
                    height: 1,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black
                              .withOpacity(0.05), // Dotted line color
                          width: 1,
                        ),
                      ),
                    )),
                const SizedBox(height: 15),
                taxInfo(),
                const SizedBox(height: 15),
                Container(
                    width: double.infinity,
                    height: 1,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black
                              .withOpacity(0.05), // Dotted line color
                          width: 1,
                        ),
                      ),
                    )),
                const SizedBox(height: 20),
                total(data),
                const SizedBox(height: 30),
                Container(
                    width: double.infinity,
                    height: 1,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black
                              .withOpacity(0.1), // Dotted line color
                          width: 1,
                        ),
                      ),
                    )),
                const SizedBox(height: 20),
                paymentStatus(),
                const SizedBox(height: 50)
              ]),
            ])));
  }

  Column paymentStatus() {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Status',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 5),
          Text(
            'Pending',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
          ),
        ]);
  }

  Column total(ReceiptResponse data) {
    double? totalAmount = 0;
    double? partnerShare = 0;
    for (var element in data.receipt) {
      totalAmount = totalAmount! + element.price;
    }
    if (data.discount) {
      partnerShare = (totalAmount! * 0.9);
    } else {
      partnerShare = (totalAmount! * 0.8);
    }

    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text(
          'Total (inclusive of all taxes)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(totalAmount.toStringAsFixed(2),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
      ]),
      if (data.discount) ...[
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text(
            'Maison Mate Share (DISCOUNT APPLIED)',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Text('-10% (${(totalAmount * 0.1).toStringAsFixed(0)})',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
        ]),
      ],
      if (!data.discount) ...[
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text(
            'Maison Mate Share',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Text('-20% (${(totalAmount * 0.2).toStringAsFixed(2)})',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
        ]),
      ],
      const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          'Your Share',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.green.shade500),
        ),
        Text(partnerShare.toStringAsFixed(2),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade500))
      ])
    ]);
  }

  Column taxInfo() {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Taxes and fee',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Text(
            'Taxes levied as per Govt. regulations, subject to change basis final service value.',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
        ]);
  }

  Column paymentItems(ReceiptResponse data) {
    return Column(
        children: data.receipt.map((e) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          e.category,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        Text(e.price.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
      ]);
    }).toList());
  }
}
