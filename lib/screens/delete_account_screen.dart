import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/post_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/delete_account_model.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:provider/provider.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  Future<ApiResponse>? futureData;
  var snackbarShown = false;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DeleteAccountModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 100),
            const Icon(
              Icons.warning,
              size: 100,
              color: Color(awesomeColor),
            ),
            const SizedBox(height: 20),
            const Text(
              'Warning: Deleting your account is an irreversible action.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(themeColor),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'All your data will be lost, and you won\'t be able to recover it.',
              style: TextStyle(fontSize: 18, color: Color(awesomeColor)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            (futureData != null)
                ? PostClient.futureBuilder(
                    model,
                    futureData!,
                    "Delete",
                    () async {
                      onSubmitCallback(model);
                    },
                    () {
                      if (!snackbarShown) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'Our team will review your request, and your account will be deleted within the next 7 days. You will receive a confirmation email once the process is complete. '),
                          elevation: 2,
                          duration: Duration(milliseconds: 5000),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ));
                        snackbarShown = true;
                      }
                      Navigator.of(context).pop();
                    },
                  )
                : MyForm.submitButton("Delete", () async {
                    onSubmitCallback(model);
                  }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void onSubmitCallback(DeleteAccountModel model) {
    if (!model.isSubmitting) {
      snackbarShown = false;
      model.setIsSubmitting(true);
      const String apiUrl = '$baseApiUrl/partners/delete_account';
      futureData = PostClient.request(apiUrl, {}, model, (response) async {});
    }
  }
}
