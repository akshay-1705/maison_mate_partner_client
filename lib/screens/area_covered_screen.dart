import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/client/put_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/area_covered_model.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:provider/provider.dart';

class AreaCoveredScreen extends StatefulWidget {
  const AreaCoveredScreen({Key? key}) : super(key: key);

  @override
  State<AreaCoveredScreen> createState() => _AreaCoveredScreenState();
}

class _AreaCoveredScreenState extends State<AreaCoveredScreen> {
  late Future<ApiResponse> futureData;
  Future<ApiResponse>? postFutureData;
  static const String apiUrl = '$baseApiUrl/partners/service_radius';

  @override
  void initState() {
    super.initState();
    futureData = GetClient.fetchData(apiUrl);
    futureData.then((apiResponse) {
      if (mounted) {
        var stateModel = Provider.of<AreaCoveredModel>(context, listen: false);
        var data = apiResponse.data;
        stateModel.selectedRadius = data['service_radius'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: GetRequestFutureBuilder<dynamic>(
            future: futureData,
            apiUrl: apiUrl,
            builder: (context, data) {
              return renderData(data);
            }));
  }

  Padding renderData(data) {
    final model = Provider.of<AreaCoveredModel>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 200),
          const Text(
            'You will receive jobs within the selected service radius only.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueGrey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Text(
            'Service Radius: ${model.selectedRadius.toStringAsFixed(0)} miles',
            style: const TextStyle(fontSize: 20),
          ),
          Slider(
            value: model.selectedRadius.toDouble(),
            onChanged: (value) {
              if (!model.isSubmitting) {
                model.setSelectedRadius(value.toInt());
              }
            },
            min: 5,
            max: 100,
            divisions: 95,
            label: model.selectedRadius.toStringAsFixed(0),
            activeColor: Colors.green, // Change the slider color
          ),
          const SizedBox(height: 20),
          (postFutureData != null)
              ? PutClient.futureBuilder(
                  model,
                  postFutureData!,
                  "Submit",
                  () async {
                    onSubmitCallback(context, model);
                  },
                  () {
                    Navigator.of(context).pop();
                  },
                )
              : MyForm.submitButton("Submit", () async {
                  onSubmitCallback(context, model);
                }),
        ],
      ),
    );
  }

  void onSubmitCallback(BuildContext context, AreaCoveredModel model) {
    model.setIsSubmitting(true);
    var formData = {
      'service_radius_in_miles': model.selectedRadius.toString(),
    };

    postFutureData =
        PutClient.request(apiUrl, formData, model, (response) async {});
  }
}
