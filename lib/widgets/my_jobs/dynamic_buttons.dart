import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/post_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/job_item_response.dart';
import 'package:maison_mate/network/response/my_job_details_response.dart';
import 'package:maison_mate/provider/end_job_model.dart';
import 'package:maison_mate/provider/my_job_details_model.dart';
import 'package:maison_mate/provider/send_quote_model.dart';
import 'package:maison_mate/provider/start_job_model.dart';
import 'package:maison_mate/screens/customer_chat_screen.dart';
import 'package:maison_mate/screens/home_screen.dart';
import 'package:maison_mate/screens/send_quote_screen.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:maison_mate/widgets/my_jobs/end_job.dart';
import 'package:maison_mate/widgets/my_jobs/start_job.dart';
import 'package:provider/provider.dart';

class DynamicButtons extends StatefulWidget {
  final BuildContext context;
  final JobItemResponse job;
  final MyJobDetailsResponse data;
  final MyJobDetailsModel model;

  const DynamicButtons({
    super.key,
    required this.context,
    required this.job,
    required this.data,
    required this.model,
  });

  @override
  State<DynamicButtons> createState() => _DynamicButtonsState();
}

class _DynamicButtonsState extends State<DynamicButtons> {
  Future<ApiResponse>? enRouteButtonFutureData;
  var snackbarShown = false;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (widget.job.statusToSearch == 1) ...[
            const Text(
              'Customer received your quote. The job will be cancelled if the customer does not accept quote timely.',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 15),
          ],
          Text(
            'Customer: ${widget.data.userName}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 10),
          Row(children: [
            if (widget.job.statusToSearch == 2) ...[
              (enRouteButtonFutureData != null)
                  ? PostClient.futureBuilder(
                      widget.model,
                      enRouteButtonFutureData!,
                      "En Route",
                      () async {
                        bool confirm = await CustomAppBar.showConfirmationDialog(
                            context,
                            "Are you sure you want to mark this job as 'En Route'?");
                        if (confirm) {
                          enRouteOnSubmitCallback(widget.model);
                        }
                      },
                      () {
                        if (!snackbarShown) {
                          ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                                  message:
                                      "You are now en route to the customer's place.",
                                  error: false)
                              .getSnackbar());
                          snackbarShown = true;
                        }
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen(index: 1)),
                          (route) => false,
                        );
                      },
                    )
                  : MyForm.submitButton("En Route", () async {
                      bool confirm = await CustomAppBar.showConfirmationDialog(
                          context,
                          "Are you sure you want to mark this job as 'En Route'?");
                      if (confirm) {
                        enRouteOnSubmitCallback(widget.model);
                      }
                    }),
              const SizedBox(width: 10),
            ],
            if (widget.job.statusToSearch == 0) ...[
              MyForm.submitButton("Send Quote", () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChangeNotifierProvider(
                    create: (context) => SendQuoteModel(),
                    child: SendQuoteScreen(jobId: widget.data.id),
                  );
                }));
              }),
              const SizedBox(width: 10),
            ],
            if (widget.job.statusToSearch == 3) ...[
              MyForm.submitButton("Start job", () async {
                await showOtpModal(context);
              }),
              const SizedBox(width: 10),
            ],
            if (widget.job.statusToSearch == 4) ...[
              MyForm.submitButton("End job", () async {
                await showOtpModalToEndJob(context);
              }),
              const SizedBox(width: 10),
            ],
            if (![5, 6].contains(widget.job.statusToSearch)) ...[
              MyForm.submitButton("Chat", () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CustomerChatScreen(data: widget.data)));
              }),
              const SizedBox(width: 10),
            ],
          ])
        ]);
  }

  Future<void> showOtpModalToEndJob(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChangeNotifierProvider(
            create: (context) => EndJobModel(),
            child: EndJob(
                jobId: widget.job.id)); // Use the custom OTP modal widget here
      },
    );
  }

  Future<void> showOtpModal(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChangeNotifierProvider(
            create: (context) => StartJobModel(),
            child: StartJob(
                jobId: widget.job.id)); // Use the custom OTP modal widget here
      },
    );
  }

  enRouteOnSubmitCallback(MyJobDetailsModel model) {
    if (!model.isSubmitting) {
      model.setIsSubmitting(true);
      snackbarShown = false;

      const String apiUrl = '$baseApiUrl/partners/job/en_route';
      var formData = {'job_assignment_id': widget.job.id};
      enRouteButtonFutureData =
          PostClient.request(apiUrl, formData, model, (response) async {});
    }
  }
}
