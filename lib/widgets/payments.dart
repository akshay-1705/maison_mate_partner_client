import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/payments_summary_response.dart';
import 'package:maison_mate/widgets/payment_card.dart';
import 'package:maison_mate/widgets/payment_list_item.dart';
import 'package:intl/intl.dart';

class PaymentsWidget extends StatefulWidget {
  const PaymentsWidget({Key? key}) : super(key: key);

  @override
  State<PaymentsWidget> createState() => _PaymentsWidgetState();
}

class _PaymentsWidgetState extends State<PaymentsWidget> {
  late Future<ApiResponse> futureData;
  static const String apiUrl = '$baseApiUrl/partners/payments_summary';

  @override
  void initState() {
    super.initState();
    futureData = GetClient.fetchData(apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    return GetRequestFutureBuilder<dynamic>(
        future: futureData,
        apiUrl: apiUrl,
        builder: (context, data) {
          return renderData(data);
        });
  }

  Column renderData(PaymentsSummaryResponse data) {
    return Column(children: [
      const SizedBox(height: 10),
      Row(
        children: [
          Flexible(
            flex: 1,
            child: PaymentCard(
              title: 'Total Payments',
              count: data.total.toString(),
              color: Colors.green,
            ),
          ),
          Flexible(
            flex: 1,
            child: PaymentCard(
              title: 'Pending Payments',
              count: data.pending.toString(),
              color: Colors.red,
            ),
          ),
        ],
      ),
      const SizedBox(height: 40),

      Container(
          alignment: Alignment.center,
          child: const Text(
            'All Payments',
            style: TextStyle(
              color: Color(themeColor), // Text color
              fontSize: 25,
            ),
          )),
      const SizedBox(
          height: 20), // Add spacing between the cards and the payment list
      PaymentList(data),
    ]);
  }
}

class PaymentList extends StatelessWidget {
  final PaymentsSummaryResponse data;

  const PaymentList(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(locale: 'en_GB');

    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: data.payments.length,
      itemBuilder: (context, index) {
        final paymentData = data.payments[index];
        return PaymentListItem(
          description: paymentData.serviceName ?? '',
          paymentID: paymentData.uniqueTransactionReference ?? '',
          amount: '${format.currencySymbol}${paymentData.amount ?? ''}',
          status: paymentData.status ?? '',
        );
      },
    );
  }
}
