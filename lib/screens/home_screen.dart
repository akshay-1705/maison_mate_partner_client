import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/services/device_service.dart';
import 'package:maison_mate/widgets/account_widget.dart';
import 'package:maison_mate/widgets/favourites.dart';
import 'package:maison_mate/widgets/home.dart';
import 'package:maison_mate/widgets/my_jobs/my_jobs.dart';
import 'package:rxdart/subjects.dart';

class HomeScreen extends StatefulWidget {
  final int? index;
  const HomeScreen({super.key, this.index});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentIndex = 0;
  final List<Widget> pages = [
    const HomeWidget(),
    const MyJobsWidget(),
    const FavouritesWidget(),
    const AccountWidget(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index ?? 0;
    enableFirebaseListener();
  }

  Future<void> enableFirebaseListener() async {
    // Request permission
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    saveToken(messaging);

    // Set up foreground message handler
    final messageStreamController = BehaviorSubject<RemoteMessage>();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Handling a foreground message: ${message.messageId}');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
      }

      messageStreamController.sink.add(message);
    });

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    if (kDebugMode) {
      print("Handling a background message: ${message.messageId}");
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }
  }

  Future<void> saveToken(FirebaseMessaging messaging) async {
    String? fcmToken = await messaging.getToken();
    // ignore: avoid_print
    print("FCM Token: $fcmToken");
    const storage = FlutterSecureStorage();
    String? storedFcmToken = await storage.read(key: fcmTokenKey);

    if (storedFcmToken != fcmToken && fcmToken != '' && fcmToken != null) {
      Future stored = storage.write(key: fcmTokenKey, value: fcmToken);
      stored.then((value) {
        sendDeviceDetailsToServer(fcmToken);
      });
    }
  }

  Future<void> sendDeviceDetailsToServer(String? fcmToken) async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String deviceType = 'Unknown';
    String deviceName = 'Unknown';

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      deviceType = 'Android';
      deviceName = androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      deviceType = 'iOS';
      deviceName = iosInfo.utsname.machine;
    }

    await DeviceService.registerDevice(
      token: fcmToken ?? '',
      deviceType: deviceType,
      deviceName: deviceName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: header(context),
          body: WillPopScope(
              onWillPop: () async {
                return Future.value(false);
              },
              child: SingleChildScrollView(child: pages[currentIndex])),
          bottomNavigationBar: bottomNavigation(),
        ));
  }

  Widget bottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Find Jobs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_repair_service),
          label: 'My Jobs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
      ],
      selectedItemColor: const Color(themeColor),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
    );
  }

  AppBar header(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(themeColor), // Header background color
      title: const Text(
        'Maison Mate',
        style: TextStyle(
          color: Color(secondaryColor), // Text color
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
