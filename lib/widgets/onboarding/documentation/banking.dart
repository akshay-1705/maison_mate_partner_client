import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/client/put_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/documentation/banking_model.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/image_helper.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:maison_mate/widgets/onboarding/onboarding.dart';
import 'package:provider/provider.dart';

class Banking extends StatefulWidget {
  const Banking({Key? key}) : super(key: key);

  @override
  State<Banking> createState() => _BankingState();
}

class _BankingState extends State<Banking> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<ApiResponse>? futureData;
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController sortCodeController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  late Future<ApiResponse> getFutureData;
  static const String apiUrl = '$baseApiUrl/partners/onboarding/banking';

  @override
  void initState() {
    super.initState();
    getFutureData = GetClient.fetchData(apiUrl);
    getFutureData.then((apiResponse) {
      if (mounted) {
        var stateModel = Provider.of<BankingModel>(context, listen: false);
        bankNameController.text = apiResponse.data.bankName;
        sortCodeController.text = (apiResponse.data.sortCode ?? '').toString();
        accountNumberController.text =
            (apiResponse.data.accountNumber ?? '').toString();
        ImageHelper.initialize(apiResponse.data.image, stateModel, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final BankingModel model = Provider.of<BankingModel>(context);
    return Scaffold(
        appBar:
            CustomAppBar.show(context, "Banking", const Icon(Icons.arrow_back)),
        body: GetRequestFutureBuilder<dynamic>(
          future: getFutureData,
          builder: (context, data) {
            return renderForm(context, model);
          },
        ));
  }

  WillPopScope renderForm(BuildContext context, BankingModel model) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(5.0),
            child: Form(
              key: _formKey,
              child: AbsorbPointer(
                  absorbing: model.isSubmitting,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      MyForm.formFieldHeader('Bank Details'),
                      MyForm.inlineRequiredTextFields(
                          'Bank Name*',
                          'Sort code*',
                          bankNameController,
                          sortCodeController,
                          TextInputType.text,
                          TextInputType.number),
                      MyForm.requiredTextField("Account Number*",
                          accountNumberController, false, TextInputType.number),
                      const SizedBox(height: 25),
                      MyForm.formFieldHeader(
                        'Attach a photo of your bank proof. This can include any of the following*:',
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyForm.buildBulletPoint(
                                'Top-half of bank statement'),
                            const SizedBox(height: 10),
                            MyForm.buildBulletPoint('Paying-in slip'),
                            const SizedBox(height: 10),
                            MyForm.buildBulletPoint(
                                'Screenshot of mobile banking'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      MyForm.uploadImageSection(model),
                      const SizedBox(height: 20),
                      (futureData != null)
                          ? PutClient.futureBuilder(
                              model,
                              futureData!,
                              "Submit",
                              () async {
                                onSubmitCallback(model);
                              },
                              () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OnboardingWidget(
                                              yourDetailsSection: true)),
                                );
                              },
                            )
                          : MyForm.submitButton("Submit", () async {
                              onSubmitCallback(model);
                            }),
                    ],
                  )),
            )),
      ),
    );
  }

  void onSubmitCallback(BankingModel model) {
    if (_formKey.currentState!.validate()) {
      if (model.selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                message: 'Please upload image before submitting', error: true)
            .getSnackbar());
      } else {
        model.setIsSubmitting(true);
        var formData = {
          'bank_name': bankNameController.text,
          'sort_code': sortCodeController.text,
          'account_number': accountNumberController.text,
        };
        List<File?>? fileList = [model.selectedFile];
        futureData = PutClient.request(apiUrl, formData, model, (response) {},
            imageFiles: fileList, imageFieldName: 'image');
      }
    }
  }
}
