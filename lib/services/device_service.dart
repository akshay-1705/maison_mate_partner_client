import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:maison_mate/constants.dart';

class DeviceService {
  static String serverUrl = '$baseApiUrl/partners';

  static Future<void> registerDevice({
    required String token,
    required String deviceType,
    required String deviceName,
  }) async {
    String apiUrl = '$serverUrl/fcm_devices';

    try {
      const storage = FlutterSecureStorage();
      var authToken = await storage.read(key: authTokenKey);
      authToken ??= '';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Partner-Authorization': authToken
        },
        body: jsonEncode({
          'token': token,
          'device_type': deviceType,
          'device_name': deviceName,
        }),
      );

      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success']) {
        // ignore: avoid_print
        print('Device registered successfully');
      } else {
        // ignore: avoid_print
        print('Failed to register device. Status code: ${response.statusCode}');
        // ignore: avoid_print
        print('Response body: ${data['message']}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error during device registration: $e');
    }
  }

  static Future<void> deleteDevice() async {
    String apiUrl = '$serverUrl/fcm_devices';
    try {
      const storage = FlutterSecureStorage();
      var authToken = await storage.read(key: authTokenKey);
      String? storedFcmToken = await storage.read(key: fcmTokenKey);
      authToken ??= '';

      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Partner-Authorization': authToken
        },
        body: jsonEncode({
          'token': storedFcmToken,
        }),
      );

      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success']) {
        await storage.delete(key: fcmTokenKey);
        // ignore: avoid_print
        print('Device deleted successfully');
      } else {
        // ignore: avoid_print
        print('Failed to delete device. Status code: ${response.statusCode}');
        // ignore: avoid_print
        print('Response body: ${data['message']}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error during device deletion: $e');
    }
  }
}
