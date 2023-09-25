import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:maison_mate/shared/forms.dart';
import 'package:maison_mate/widgets/home.dart';

Future<ApiResponse<T>> fetchData<T>(String apiUrl) async {
  try {
    const storage = FlutterSecureStorage();
    var authToken = (await storage.read(key: authTokenKey))!;
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{'Partner-Authorization': authToken},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to load data from the API');
    }
  } catch (e) {
    throw Exception('Failed to load data from the API');
  }
}

class GetRequestFutureBuilder<T> extends StatelessWidget {
  final Future<ApiResponse<T>> future;
  final Widget Function(BuildContext context, T data) builder;

  const GetRequestFutureBuilder({
    Key? key,
    required this.future,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiResponse<T>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return builder(context, snapshot.data!.data);
        } else if (snapshot.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeWidget()),
            );
          });
          return Container();
        }
        return circularLoader();
      },
    );
  }
}
