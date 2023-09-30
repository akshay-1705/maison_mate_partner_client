import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class PutClient {
  static bool isSnackbarShown = false;

  static Future<ApiResponse<T>> request<T>(
    String apiUrl,
    Map<String, String> bodyData,
    dynamic model,
    void Function(ApiResponse<T>) apiSpecificTask, {
    List<File?>? imageFiles,
    String imageFieldName = 'image',
  }) async {
    try {
      isSnackbarShown = false;
      const storage = FlutterSecureStorage();
      var authToken = await storage.read(key: authTokenKey);
      authToken ??= '';

      final request = http.MultipartRequest('PUT', Uri.parse(apiUrl));

      request.headers['Secret-Header'] = secretHeader;
      request.headers['Partner-Authorization'] = authToken;
      request.fields.addAll(bodyData);

      if (imageFiles != null && imageFiles.isNotEmpty) {
        for (var i = 0; i < imageFiles.length; i++) {
          final image = imageFiles[i];
          final stream = http.ByteStream(Stream.castFrom(image!.openRead()));
          final length = await image.length();
          final mimeType =
              lookupMimeType(image.path) ?? 'application/octet-stream';

          final multipartFile = http.MultipartFile(
            imageFieldName,
            stream,
            length,
            filename: image.path.split('/').last,
            contentType: MediaType.parse(mimeType),
          );

          request.files.add(multipartFile);
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print(response.body);
      final Map<String, dynamic> data = json.decode(response.body);
      print(data);
      ApiResponse<T> apiResponse = ApiResponse.fromJson(data);
      print('here1');

      if (apiResponse.success) {
        apiSpecificTask(apiResponse);
      }
      model.setIsSubmitting(false);
      return apiResponse;
    } catch (e) {
      print(e);
      model.setIsSubmitting(false);
      throw (somethingWentWrong);
    }
  }

  static FutureBuilder<ApiResponse> futureBuilder(
    dynamic model,
    Future<ApiResponse> putFutureData,
    String buttonText,
    VoidCallback buttonAction,
    VoidCallback onNavigation, // Generic navigation function
  ) {
    return FutureBuilder<ApiResponse>(
      future: putFutureData,
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
          return MyForm.submitButton(buttonText, buttonAction);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return MyForm.circularLoader();
        } else if (snapshot.data!.success &&
            snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onNavigation();
          });
          return MyForm.submitButton(buttonText, buttonAction);
        }

        return MyForm.circularLoader();
      },
    );
  }
}
