import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:maison_mate/services/logout_service.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';

class GetClient {
  static Future<ApiResponse<T>> fetchData<T>(String apiUrl) async {
    const storage = FlutterSecureStorage();
    var authToken = await storage.read(key: authTokenKey);
    authToken ??= '';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{'Partner-Authorization': authToken},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ApiResponse.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to load data from the API');
    }
  }
}

// ignore: must_be_immutable
class GetRequestFutureBuilder<T> extends StatefulWidget {
  late Future<ApiResponse<T>>? future;
  final Widget Function(BuildContext context, T data) builder;
  final String apiUrl;

  GetRequestFutureBuilder(
      {Key? key,
      required this.future,
      required this.builder,
      required this.apiUrl})
      : super(key: key);

  @override
  State<GetRequestFutureBuilder<T>> createState() =>
      _GetRequestFutureBuilderState<T>();
}

class _GetRequestFutureBuilderState<T>
    extends State<GetRequestFutureBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiResponse<T>>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MyForm.circularLoader(context);
        } else if (snapshot.hasData) {
          return widget.builder(context, snapshot.data!.data);
        } else if (snapshot.hasError) {
          if (snapshot.error.toString() == 'Exception: Unauthorized') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              LogoutService.logout(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  MySnackBar(message: 'Please login again', error: true)
                      .getSnackbar());
            });
          } else {
            return refreshButton(context);
          }
        }
        return Container();
      },
    );
  }

  Container refreshButton(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        alignment: Alignment.center,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Something went wrong!',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            // Refresh Icon
            IconButton(
                onPressed: () {
                  {
                    setState(() {
                      widget.future = GetClient.fetchData(widget.apiUrl);
                    });
                  }
                },
                icon: const Icon(Icons.refresh))
          ],
        )));
  }
}
