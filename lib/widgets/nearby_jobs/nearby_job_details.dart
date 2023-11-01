import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/client/post_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/job_response.dart';
import 'package:maison_mate/network/response/nearby_job_details_response.dart';
import 'package:maison_mate/provider/nearby_job_details_model.dart';
import 'package:maison_mate/screens/home_screen.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyJobDetails extends StatefulWidget {
  final JobResponse job;
  const NearbyJobDetails({Key? key, required this.job}) : super(key: key);

  @override
  State<NearbyJobDetails> createState() => _NearbyJobDetailsState();
}

class _NearbyJobDetailsState extends State<NearbyJobDetails> {
  Future<ApiResponse>? futureData;
  late String apiUrl;
  late String postApiUrl;
  Future<ApiResponse>? postFutureData;
  var snackbarShown = false;

  @override
  void initState() {
    super.initState();
    apiUrl = '$baseApiUrl/partners/nearby_job_details?job_id=${widget.job.id}';
    postApiUrl = '$baseApiUrl/partners/job/accept_job?job_id=${widget.job.id}';
    futureData = GetClient.fetchData(apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: GetRequestFutureBuilder<dynamic>(
          apiUrl: apiUrl,
          future: futureData,
          builder: (context, data) {
            return showDetails(data);
          },
        ));
  }

  SingleChildScrollView showDetails(NearbyJobDetailsResponse data) {
    final NearbyJobDetailsModel model =
        Provider.of<NearbyJobDetailsModel>(context);

    return SingleChildScrollView(
        child: AbsorbPointer(
            absorbing: model.isSubmitting,
            child: Column(children: [
              topCardContents(data),
              const SizedBox(height: 20),
              Container(
                height: 7,
                color: Colors.black12,
              ),
              bottomCardContents(data),
              const SizedBox(height: 20),
              Container(
                height: 1,
                color: Colors.black12,
              ),
              const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "You will have 2 hours to send your quote to the user; otherwise, the job will be marked as 'Archived'. Timer will start immediately after accepting the job.",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(awesomeColor)),
                  )),
              (postFutureData != null)
                  ? PostClient.futureBuilder(
                      model,
                      postFutureData!,
                      "Accept",
                      () async {
                        bool confirm =
                            await CustomAppBar.showConfirmationDialog(context,
                                'Are you sure you want to accept this job?');
                        if (confirm) {
                          onSubmitCallback(model);
                        }
                      },
                      () {
                        if (!snackbarShown) {
                          ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                                  message:
                                      'Job accepted. Go to my jobs to send quote',
                                  error: false)
                              .getSnackbar());
                          snackbarShown = true;
                        }
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    )
                  : MyForm.submitButton("Accept", () async {
                      bool confirm = await CustomAppBar.showConfirmationDialog(
                          context, 'Are you sure you want to accept this job?');
                      if (confirm) {
                        onSubmitCallback(model);
                      }
                    }),
            ])));
  }

  void onSubmitCallback(NearbyJobDetailsModel model) {
    model.setIsSubmitting(true);
    snackbarShown = false;
    postFutureData =
        PostClient.request(postApiUrl, {}, model, (response) async {});
  }

  Padding bottomCardContents(NearbyJobDetailsResponse data) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
            alignment: Alignment.topLeft,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Job Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data.serviceName ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    data.details ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ])));
  }

  Padding topCardContents(NearbyJobDetailsResponse data) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
            alignment: Alignment.topLeft,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${data.kind} Job',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data.userName ?? '',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    data.address ?? '',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                      onTap: () async {
                        final Uri mapUrl = Uri.parse(
                            'https://www.google.com/maps/search/?api=1&query=${data.latitude},${data.longitude}');
                        if (await canLaunchUrl(mapUrl)) {
                          await launchUrl(mapUrl);
                        }
                      },
                      child: IntrinsicWidth(
                          child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              child: const Row(children: [
                                Text(
                                  'See on map',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.directions,
                                  size: 24,
                                  color: Colors.green,
                                )
                              ])))),
                ])));
  }
}
