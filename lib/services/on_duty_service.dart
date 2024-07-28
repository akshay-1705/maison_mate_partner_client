import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:http/http.dart' as http;

class OnDutyService {
  static String serverUrl = '$baseApiUrl/partners';

  static Future<bool> toggle(bool value, int activity) async {
    String apiUrl = '$serverUrl/on_duty';

    try {
      const storage = FlutterSecureStorage();
      var authToken = await storage.read(key: authTokenKey);
      authToken ??= '';

      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Partner-Authorization': authToken
        },
        body: jsonEncode({'on_duty': value, 'activity': activity}),
      );

      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success']) {
        // ignore: avoid_print
        print('Updated Successfully');
        return true;
      } else {
        // ignore: avoid_print
        print('Failed to update. Status code: ${response.statusCode}');
        // ignore: avoid_print
        print('Response body: ${data['message']}');
        return false;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      return false;
    }
  }
}
