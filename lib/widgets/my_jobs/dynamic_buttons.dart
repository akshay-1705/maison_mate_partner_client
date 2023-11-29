import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/post_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/my_job_details_response.dart';
import 'package:maison_mate/provider/end_job_model.dart';
import 'package:maison_mate/provider/my_job_details_model.dart';
import 'package:maison_mate/provider/send_quote_model.dart';
import 'package:maison_mate/provider/start_job_model.dart';
import 'package:maison_mate/screens/home_screen.dart';
import 'package:maison_mate/screens/send_quote_screen.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:maison_mate/widgets/my_jobs/end_job.dart';
import 'package:maison_mate/widgets/my_jobs/start_job.dart';
import 'package:maison_mate/widgets/receipt_widget.dart';
import 'package:provider/provider.dart';

class DynamicButtons extends StatefulWidget {
  final BuildContext context;
  final MyJobDetailsResponse data;
  final MyJobDetailsModel model;

  const DynamicButtons({
    super.key,
    required this.context,
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
          if (widget.data.statusToSearch == 1) ...[
            const Text(
              'Customer received your quote.',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
            ),
          ],
          const SizedBox(height: 10),
          Column(children: [
            if (widget.data.statusToSearch == 2) ...[
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
              const SizedBox(height: 10)
            ],
            if (widget.data.statusToSearch == 0) ...[
              MyForm.submitButton("Send Quote", () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChangeNotifierProvider(
                    create: (context) => SendQuoteModel(),
                    child: SendQuoteScreen(jobId: widget.data.id),
                  );
                }));
              }),
              const SizedBox(height: 10)
            ],
            if (widget.data.statusToSearch == 3) ...[
              MyForm.submitButton("Start job", () async {
                await showOtpModal(context);
              }),
              const SizedBox(height: 10)
            ],
            if (widget.data.statusToSearch == 4) ...[
              MyForm.submitButton("End job", () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Confirmation"),
                      content: const Text(
                          'Do you want to edit the quote before ending the job? You cannot do this after ending the job.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ChangeNotifierProvider(
                                create: (context) => SendQuoteModel(),
                                child: SendQuoteScreen(jobId: widget.data.id),
                              );
                            }));
                          },
                          child: const Text("Edit"),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop(false);
                            if (widget.data.quoteFinal) {
                              await showOtpModalToEndJob(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                                      message:
                                          "Customer has not accepted the updated quote",
                                      error: true)
                                  .getSnackbar());
                            }
                          },
                          child: const Text("Enter OTP"),
                        )
                      ],
                    );
                  },
                );
              }),
              const SizedBox(height: 10)
            ],
            if (widget.data.statusToSearch == 5) ...[
              GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return const ReceiptWidget();
                      },
                    );
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Text('View Receipt',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade800)))),
              const SizedBox(height: 10)
            ]
          ]),
        ]);
  }

  Future<void> showOtpModalToEndJob(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChangeNotifierProvider(
            create: (context) => EndJobModel(),
            child: EndJob(
                jobId: widget.data.id)); // Use the custom OTP modal widget here
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
                jobId: widget.data.id)); // Use the custom OTP modal widget here
      },
    );
  }

  enRouteOnSubmitCallback(MyJobDetailsModel model) {
    if (!model.isSubmitting) {
      model.setIsSubmitting(true);
      snackbarShown = false;

      const String apiUrl = '$baseApiUrl/partners/job/en_route';
      var formData = {'job_assignment_id': widget.data.id};
      enRouteButtonFutureData =
          PostClient.request(apiUrl, formData, model, (response) async {});
    }
  }
}
