import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/post_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/feedback_model.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key, required this.userId, required this.jobId})
      : super(key: key);

  final int? userId;
  final int? jobId;

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int overallRating = 0;
  int behaviorRating = 0;
  int problemDescriptionRating = 0;
  int timelyPaymentRating = 0;
  TextEditingController commentsController = TextEditingController();
  static String apiUrl = '$baseApiUrl/partners/rate_user';
  Future<ApiResponse>? postFutureData;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<FeedbackModel>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Rate the customer',
          ),
        ),
        body: AbsorbPointer(
          absorbing: model.isSubmitting,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: Column(
              children: [
                buildRatingRow(
                  title: 'Behavior',
                  rating: behaviorRating,
                  onChanged: (int rating) {
                    setState(() {
                      behaviorRating = rating;
                    });
                  },
                ),
                buildRatingRow(
                  title: 'Problem Description',
                  rating: problemDescriptionRating,
                  onChanged: (int rating) {
                    setState(() {
                      problemDescriptionRating = rating;
                    });
                  },
                ),
                buildRatingRow(
                  title: 'Timely Payment',
                  rating: timelyPaymentRating,
                  onChanged: (int rating) {
                    setState(() {
                      timelyPaymentRating = rating;
                    });
                  },
                ),
                buildRatingRow(
                  title: 'Overall Rating',
                  rating: overallRating,
                  onChanged: (int rating) {
                    setState(() {
                      overallRating = rating;
                    });
                  },
                ),
                const SizedBox(height: 20),
                MyForm.multilineRequiredTextField(
                    "Add comments (optional)", commentsController),
                const SizedBox(height: 20),
                (postFutureData != null)
                    ? PostClient.futureBuilder(
                        model,
                        postFutureData!,
                        "Submit",
                        () async {
                          onSubmitCallback(model);
                        },
                        () {
                          Navigator.of(context).pop();
                          // if (!snackbarShown) {
                          ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                                  message: 'Thanks for your feedback!',
                                  error: false)
                              .getSnackbar());
                          //   snackbarShown = true;
                          // }
                        },
                      )
                    : MyForm.submitButton("Submit", () async {
                        onSubmitCallback(model);
                      }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSubmitCallback(FeedbackModel model) {
    if (overallRating == 0 ||
        behaviorRating == 0 ||
        problemDescriptionRating == 0 ||
        timelyPaymentRating == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            MySnackBar(message: 'Please rate all the categories', error: true)
                .getSnackbar());
      });
    } else {
      var formData = {
        'user_id': widget.userId,
        'job_id': widget.jobId,
        'ratings': {
          'behaviour': behaviorRating,
          'timely_payment': timelyPaymentRating,
          'problem_description': problemDescriptionRating,
          'overall_rating': overallRating,
          'comment': commentsController.text,
        }
      };

      postFutureData =
          PostClient.request(apiUrl, formData, model, (response) async {});
    }
  }

  Widget buildRatingRow({
    required String title,
    required int rating,
    required ValueChanged<int> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 7,
            child: Row(
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: index < rating ? Colors.orange : Colors.grey,
                  ),
                  onPressed: () => onChanged(index + 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
