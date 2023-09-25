import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse<T>> postData<T>(
    String apiUrl, Map<String, Object> bodyData, dynamic model) async {
  try {
    const storage = FlutterSecureStorage();
    var authToken = (await storage.read(key: authTokenKey))!;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Partner-Authorization': authToken
      },
      body: jsonEncode(bodyData),
    );
    final Map<String, dynamic> data = json.decode(response.body);

    model.setIsSubmitting(false);
    ApiResponse<T> apiResponse = ApiResponse.fromJson(data);

    if (apiResponse.success == false) {
      model.setErrorMessage(apiResponse.message);
    }
    return apiResponse;
  } catch (e) {
    model.setErrorMessage(somethingWentWrong);
    throw (somethingWentWrong);
  }
}
