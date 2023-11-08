import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/post_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/end_job_model.dart';
import 'package:maison_mate/screens/home_screen.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:provider/provider.dart';

class EndJob extends StatefulWidget {
  final int? jobId;
  const EndJob({super.key, required this.jobId});

  @override
  State<EndJob> createState() => EndJobState();
}

class EndJobState extends State<EndJob> {
  List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  List<TextEditingController> controllers =
      List.generate(4, (index) => TextEditingController());
  String otp = '';
  Future<ApiResponse>? futureData;

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<EndJobModel>(context);
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: AlertDialog(
          content: AbsorbPointer(
              absorbing: model.isSubmitting,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Take OTP from the customer to end the job.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildOtpDigitTextField(0),
                      const SizedBox(width: 10),
                      buildOtpDigitTextField(1),
                      const SizedBox(width: 10),
                      buildOtpDigitTextField(2),
                      const SizedBox(width: 10),
                      buildOtpDigitTextField(3),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              )),
          actions: <Widget>[
            Align(
                alignment: Alignment.center,
                child: (futureData != null)
                    ? PostClient.futureBuilder(
                        model,
                        futureData!,
                        "End",
                        () async {
                          if (otp.length == 4) {
                            FocusScope.of(context).unfocus();
                            onSubmitCallback(model);
                          }
                        },
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                                  message: "Job completed.", error: false)
                              .getSnackbar());
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const HomeScreen(index: 1)),
                            (route) => false,
                          );
                        },
                      )
                    : MyForm.submitButton("End", () async {
                        if (otp.length == 4) {
                          FocusScope.of(context).unfocus();
                          onSubmitCallback(model);
                        }
                      })),
          ],
        ));
  }

  void onSubmitCallback(EndJobModel model) {
    if (!model.isSubmitting) {
      model.setIsSubmitting(true);

      const String apiUrl = '$baseApiUrl/partners/job/end_job';
      var formData = {'job_assignment_id': widget.jobId, 'otp': int.parse(otp)};
      futureData =
          PostClient.request(apiUrl, formData, model, (response) async {});
      Navigator.of(context).pop();
    }
  }

  Widget buildOtpDigitTextField(int digitPosition) {
    return SizedBox(
      width: 40,
      child: TextField(
        focusNode: focusNodes[digitPosition],
        controller: controllers[digitPosition],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: '',
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            otp += value;
            if (digitPosition < 3) {
              focusNodes[digitPosition + 1].requestFocus();
            }
          }
        },
      ),
    );
  }
}
