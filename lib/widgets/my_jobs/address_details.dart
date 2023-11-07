import 'package:flutter/material.dart';
import 'package:maison_mate/network/response/my_job_details_response.dart';
import 'package:url_launcher/url_launcher.dart';

class AddressDetails extends StatelessWidget {
  const AddressDetails({
    super.key,
    required this.data,
  });

  final MyJobDetailsResponse data;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
            alignment: Alignment.topLeft,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    data.address ?? '',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 15),
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
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.directions,
                                  size: 24,
                                  color: Colors.green,
                                )
                              ])))),
                ])));
  }
}
