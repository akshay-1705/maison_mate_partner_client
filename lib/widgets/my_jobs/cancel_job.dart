import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/post_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/cancel_job_model.dart';
import 'package:maison_mate/screens/home_screen.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:provider/provider.dart';

class CancelJob extends StatefulWidget {
  final int? jobId;
  const CancelJob({Key? key, required this.jobId}) : super(key: key);

  @override
  State<CancelJob> createState() => _CancelJobState();
}

class _CancelJobState extends State<CancelJob> {
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController otherReasonController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<ApiResponse>? futureData;
  var snackbarShown = false;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CancelJobModel>(context);
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
            child: SingleChildScrollView(
                child: Form(
                    key: formKey,
                    child: AbsorbPointer(
                        absorbing: model.isSubmitting,
                        child: AlertDialog(
                          title:
                              const Text('Tell us the reason for cancellation'),
                          alignment: Alignment.bottomCenter,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customCheckboxListTile(
                                        'Customer unresponsive',
                                        reasonController),
                                    customCheckboxListTile(
                                        "Booked by mistake", reasonController),
                                    customCheckboxListTile(
                                        'Customer behavior not appropriate',
                                        reasonController),
                                    customCheckboxListTile(
                                        'Other', reasonController),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: reasonController.text.toLowerCase() ==
                                    'other',
                                child: TextFormField(
                                  controller: otherReasonController,
                                  decoration: const InputDecoration(
                                      labelText: 'Comments*'),
                                  validator: (value) {
                                    if (value != null &&
                                        value.trim().length < 20) {
                                      return 'Please provide at least 20 characters';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 16.0),
                                child: Text(
                                  'Cancellation may impact your rating and number of jobs you get',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            Align(
                                alignment: Alignment.center,
                                child: (futureData != null)
                                    ? PostClient.futureBuilder(
                                        model, futureData!, "Confirm",
                                        () async {
                                        onSubmitCallback(model);
                                      }, () {
                                        if (!snackbarShown) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(MySnackBar(
                                                      message: "Job cancelled.",
                                                      error: false)
                                                  .getSnackbar());
                                          snackbarShown = true;
                                        }
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeScreen(index: 1)),
                                          (route) => false,
                                        );
                                      }, afterFailure: () {
                                        Navigator.of(context).pop();
                                      })
                                    : MyForm.submitButton("Confirm", () async {
                                        onSubmitCallback(model);
                                      })),
                          ],
                        ))))));
  }

  void onSubmitCallback(CancelJobModel model) {
    if (!model.isSubmitting && formKey.currentState!.validate()) {
      model.setIsSubmitting(true);
      snackbarShown = false;
      String reason = '';

      reason = reasonController.text == 'Other'
          ? otherReasonController.text
          : reasonController.text;

      const String apiUrl = '$baseApiUrl/partners/job/cancel_job';
      var formData = {'job_assignment_id': widget.jobId, 'reason': reason};
      futureData =
          PostClient.request(apiUrl, formData, model, (response) async {});
    }
  }

  Widget customCheckboxListTile(
      String label, TextEditingController reasonController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Checkbox(
          value: reasonController.text == label,
          onChanged: (bool? value) {
            setState(() {
              reasonController.text = label;
            });
          },
        ),
        Text(label),
      ],
    );
  }
}
