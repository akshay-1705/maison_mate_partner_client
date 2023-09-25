import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:maison_mate/shared/forms.dart';
import 'package:maison_mate/shared/my_snackbar.dart';

bool isSnackbarShown = false;

Future<ApiResponse<T>> postData<T>(String apiUrl, Map<String, Object> bodyData,
    dynamic model, void Function(ApiResponse<T>) apiSpecificTask) async {
  try {
    isSnackbarShown = false;
    const storage = FlutterSecureStorage();
    var authToken = await storage.read(key: authTokenKey);
    authToken ??= '';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Secret-Header': secretHeader,
        'Partner-Authorization': authToken
      },
      body: jsonEncode(bodyData),
    );
    final Map<String, dynamic> data = json.decode(response.body);

    model.setIsSubmitting(false);
    ApiResponse<T> apiResponse = ApiResponse.fromJson(data);

    if (apiResponse.success) {
      apiSpecificTask(apiResponse);
    }
    return apiResponse;
  } catch (e) {
    model.setIsSubmitting(false);
    throw (somethingWentWrong);
  }
}

FutureBuilder<ApiResponse> postRequestFutureBuilder(
  dynamic model,
  Future<ApiResponse> postFutureData,
  String buttonText,
  VoidCallback buttonAction,
  VoidCallback onNavigation, // Generic navigation function
) {
  return FutureBuilder<ApiResponse>(
    future: postFutureData,
    builder: (context, snapshot) {
      if ((snapshot.hasError || snapshot.data?.success == false) &&
          snapshot.connectionState == ConnectionState.done) {
        var errorMessage = (snapshot.error != null)
            ? 'Error: ${snapshot.error.toString()}'
            : (snapshot.data != null
                ? snapshot.data!.message
                : somethingWentWrong);

        if (!isSnackbarShown) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            isSnackbarShown = true;
            ScaffoldMessenger.of(context).showSnackBar(
                MySnackBar(message: errorMessage, error: true).getSnackbar());
          });
        }
        return submitButton(buttonText, buttonAction);
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return circularLoader();
      } else if (snapshot.data!.success &&
          snapshot.connectionState == ConnectionState.done) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          isSnackbarShown = false;
          onNavigation();
        });
      }

      return circularLoader();
    },
  );
}
