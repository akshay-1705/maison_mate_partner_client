import 'package:flutter/material.dart';
import 'package:maison_mate/network/response/my_job_details_response.dart';
import 'package:url_launcher/url_launcher.dart';

class Description extends StatelessWidget {
  const Description({
    super.key,
    required this.data,
  });

  final MyJobDetailsResponse data;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Row(children: [
                      SizedBox(width: 15),
                      Text('Booking Details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500))
                    ]),
                    const SizedBox(height: 20),
                    Row(children: [
                      const SizedBox(width: 15),
                      const Icon(Icons.label_important_outline, size: 17),
                      const SizedBox(width: 8),
                      Expanded(child: Text('${data.kind} Job'))
                    ]),
                    const SizedBox(height: 15),
                    listSeparator(),
                    const SizedBox(height: 15),
                    Row(children: [
                      const SizedBox(width: 15),
                      const Icon(Icons.description_outlined, size: 17),
                      const SizedBox(width: 8),
                      Expanded(child: Text(data.details ?? ''))
                    ]),
                    const SizedBox(height: 15),
                    listSeparator(),
                    const SizedBox(height: 15),
                    Row(children: [
                      const SizedBox(width: 15),
                      const Icon(Icons.location_on, size: 17),
                      const SizedBox(width: 8),
                      Expanded(child: Text(data.address ?? ''))
                    ]),
                    const SizedBox(height: 25),
                    addressIcon(),
                    const SizedBox(height: 25),
                  ]),
            ]));
  }

  Row addressIcon() {
    return Row(children: [
      const SizedBox(width: 15),
      GestureDetector(
          onTap: () async {
            final Uri mapUrl = Uri.parse(
                'https://www.google.com/maps/search/?api=1&query=${data.latitude},${data.longitude}');
            if (await canLaunchUrl(mapUrl)) {
              await launchUrl(mapUrl);
            }
          },
          child: IntrinsicWidth(
              child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: const Row(children: [
                    Text(
                      'See on map',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.directions,
                      size: 24,
                      color: Colors.green,
                    )
                  ]))))
    ]);
  }

  Padding listSeparator() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Container(
          width: double.infinity,
          height: 1,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black.withOpacity(0.1), // Dotted line color
                width: 1,
              ),
            ),
          )),
    );
  }
}
