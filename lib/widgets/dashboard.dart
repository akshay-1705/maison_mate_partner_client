import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/screens/nearby_jobs_list.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  String? address;
  Position? position;
  Future<ApiResponse>? futureData;
  static const String apiUrl = '$baseApiUrl/partners/find_jobs';

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () => refreshData(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  final Uri mapUrl = Uri.parse(
                      'https://www.google.com/maps/search/?api=1&query=${position!.latitude},${position!.longitude}');
                  print(mapUrl);
                  if (await canLaunchUrl(mapUrl)) {
                    await launchUrl(mapUrl);
                  }
                },
                child: showLocation(),
              ),
              const SizedBox(height: 25),
              GetRequestFutureBuilder<dynamic>(
                apiUrl: apiUrl,
                future: futureData,
                builder: (context, data) {
                  return NearbyJobsList(data: data);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ));
  }

  SingleChildScrollView showLocation() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const Icon(Icons.location_on),
          const SizedBox(width: 5),
          Text(
            address ?? '',
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> refreshData() async {
    if (position != null) {
      String url =
          '$apiUrl/?latitude=${position!.latitude}&longitude=${position!.longitude}';
      final response = await GetClient.fetchData(url);
      setState(() {
        futureData = Future.value(response);
      });
    }
  }

  void fetchAndUpdateJobData() {
    if (position != null) {
      String url =
          '$apiUrl/?latitude=${position!.latitude}&longitude=${position!.latitude}';
      setState(() {
        futureData = GetClient.fetchData(url);
      });
    }
  }

  Future<void> getCurrentLocation() async {
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);

    if (placemarks.isNotEmpty) {
      Placemark firstPlacemark = placemarks.first;
      setState(() {
        address =
            '${firstPlacemark.street} ${firstPlacemark.subLocality} ${firstPlacemark.locality} ${firstPlacemark.postalCode}';
      });
    }
  }

  void openSettingsWhenDenied() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Location Permission Required'),
            content: const Text(
                'Please enable location access for this app in your device settings.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Open Settings'),
                onPressed: () {
                  openAppSettings();
                },
              ),
            ],
          );
        },
      );
    });
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      getCurrentLocation().then((value) {
        refreshData();
      });
    } else if (status.isDenied) {
      openSettingsWhenDenied();
    } else if (status.isPermanentlyDenied) {
      openSettingsWhenDenied();
    }
  }
}
