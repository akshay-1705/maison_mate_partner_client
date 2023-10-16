import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';

class PostClient {
  static bool isSnackbarShown = false;

  static Future<ApiResponse<T>> request<T>(
    String apiUrl,
    Map<String, dynamic> bodyData,
    dynamic model,
    Future Function(ApiResponse<T>) apiSpecificTask,
  ) async {
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

      ApiResponse<T> apiResponse = ApiResponse.fromJson(data);

      if (apiResponse.success) {
        await apiSpecificTask(apiResponse);
      }
      model.setIsSubmitting(false);
      return apiResponse;
    } catch (e) {
      model.setIsSubmitting(false);
      throw (somethingWentWrong);
    }
  }

  static FutureBuilder<ApiResponse> futureBuilder(
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
            isSnackbarShown = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                  MySnackBar(message: errorMessage, error: true).getSnackbar());
            });
          }
          return MyForm.submitButton(buttonText, buttonAction);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data!.success &&
            snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onNavigation();
          });
          return MyForm.submitButton(buttonText, buttonAction);
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
