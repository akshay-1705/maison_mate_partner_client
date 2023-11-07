import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/my_jobs_model.dart';
import 'package:maison_mate/widgets/my_jobs/filter_option.dart';
import 'package:maison_mate/widgets/my_jobs/my_jobs_list.dart';
import 'package:provider/provider.dart';

class MyJobsWidget extends StatefulWidget {
  const MyJobsWidget({Key? key}) : super(key: key);

  @override
  State<MyJobsWidget> createState() => _MyJobsWidgetState();
}

class _MyJobsWidgetState extends State<MyJobsWidget> {
  late Future<ApiResponse> dataFutureData;
  late Future<ApiResponse> filtersFutureData;
  static const String filtersApiUrl = '$baseApiUrl/partners/job_filters';
  static const String dataApiUrl = '$baseApiUrl/partners/my_jobs?filter=All';

  @override
  void initState() {
    super.initState();
    var stateModel = Provider.of<MyJobsModel>(context, listen: false);
    dataFutureData = GetClient.fetchData(dataApiUrl);
    filtersFutureData = GetClient.fetchData(filtersApiUrl);
    dataFutureData.then((apiResponse) {
      stateModel.setMyJobsList(apiResponse.data);
    });
    stateModel.activeFilter = -1;
  }

  @override
  Widget build(BuildContext context) {
    return renderData();
  }

  SingleChildScrollView renderData() {
    final MyJobsModel model = Provider.of<MyJobsModel>(context);
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GetRequestFutureBuilder<dynamic>(
                    future: filtersFutureData,
                    apiUrl: filtersApiUrl,
                    builder: (context, data) {
                      Map<String, dynamic> sortedData = sortData(data);
                      return FilterOptions(data: sortedData, model: model);
                    }),
                const SizedBox(height: 10),
                GetRequestFutureBuilder<dynamic>(
                    future: dataFutureData,
                    apiUrl: dataApiUrl,
                    builder: (context, data) {
                      return MyJobsList(data: model.filteredMyJobsList);
                    }),
              ],
            )));
  }

  Map<String, dynamic> sortData(data) {
    data['All'] = -1;
    List<MapEntry<String, dynamic>> dataList = data.entries.toList();
    dataList.sort((a, b) => a.value.compareTo(b.value));
    Map<String, dynamic> sortedData = Map.fromEntries(dataList);
    return sortedData;
  }
}
