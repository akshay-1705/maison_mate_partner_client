import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/services/device_service.dart';
import 'package:rxdart/subjects.dart';

class FirebaseService {
  static Future<void> enable() async {
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

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (kDebugMode) {
      print("Handling a background message: ${message.messageId}");
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }
  }

  static Future<void> saveToken(FirebaseMessaging messaging) async {
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

  static Future<void> sendDeviceDetailsToServer(String? fcmToken) async {
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
}
