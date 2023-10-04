import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/client/put_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/documentation/insurance_model.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/image_helper.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:maison_mate/widgets/onboarding/onboarding.dart';
import 'package:provider/provider.dart';

class Insurance extends StatefulWidget {
  const Insurance({Key? key}) : super(key: key);

  @override
  State<Insurance> createState() => _InsuranceState();
}

class _InsuranceState extends State<Insurance> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<ApiResponse>? futureData;
  final TextEditingController insuranceExpiryDateController =
      TextEditingController();
  late Future<ApiResponse> getFutureData;
  static const String apiUrl = '$baseApiUrl/partners/onboarding/insurance';

  @override
  void initState() {
    super.initState();
    getFutureData = GetClient.fetchData(apiUrl);
    getFutureData.then((apiResponse) {
      if (mounted) {
        var stateModel = Provider.of<InsuranceModel>(context, listen: false);

        if (apiResponse.data.expiryDate == null) {
          stateModel.epochString =
              DateTime.now().millisecondsSinceEpoch.toString();
        } else {
          stateModel.epochString = apiResponse.data.expiryDate.toString();
          insuranceExpiryDateController.text =
              DateTime.fromMillisecondsSinceEpoch(apiResponse.data.expiryDate)
                  .toString();
        }

        stateModel.minimum2MillionInsurancePresent =
            apiResponse.data.twoMillionInsurance == true ? 'Yes' : 'No';
        stateModel.minimum1MillionInsurancePresent =
            apiResponse.data.oneMillionInsurance == true ? 'Yes' : 'No';
        ImageHelper.initialize(apiResponse.data.image, stateModel, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final InsuranceModel model = Provider.of<InsuranceModel>(context);
    return Scaffold(
        appBar: CustomAppBar.show(
            context, "Insurance", const Icon(Icons.arrow_back)),
        body: GetRequestFutureBuilder<dynamic>(
          future: getFutureData,
          builder: (context, data) {
            return renderForm(context, model);
          },
        ));
  }

  SingleChildScrollView renderForm(BuildContext context, InsuranceModel model) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(5.0),
      child: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
              key: _formKey,
              child: AbsorbPointer(
                absorbing: model.isSubmitting,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    MyForm.formFieldHeader(
                        'Do you have the minimum of a £2 million Public Liability insurance?*',
                        model.minimum2MillionInsurancePresentColor),
                    MyForm.buildRadioButtons(
                        ['Yes', 'No'], model.minimum2MillionInsurancePresent,
                        (value) {
                      model.setMinimum2MillionInsurancePresentColor(
                          Colors.black);
                      model.setMinimum2MillionInsurancePresent(value);
                    }),
                    if (model.minimum2MillionInsurancePresent == 'No') ...[
                      MyForm.formFieldHeader(
                          'Do you have the minimum of a £1 million Public Liability insurance?*',
                          model.minimum1MillionInsurancePresentColor),
                      MyForm.buildRadioButtons(
                          ['Yes'], model.minimum1MillionInsurancePresent,
                          (value) {
                        model.setMinimum1MillionInsurancePresentColor(
                            Colors.black);
                        model.setMinimum1MillionInsurancePresent(value);
                      }),
                    ],
                    MyForm.formFieldHeader(
                        'When does Public Liability insurance expire?*'),
                    MyForm.datePickerFormField(
                        'DD/MM/YYYY',
                        insuranceExpiryDateController,
                        context,
                        model,
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(model.epochString))),
                    MyForm.formFieldHeader(
                        'Attach a copy of your public liability insurance. Please make sure the company name, limit of insurance, and expiry date are all visible.*'),
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
                    const SizedBox(height: 40),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  void onSubmitCallback(InsuranceModel model) {
    if (model.minimum2MillionInsurancePresent == '') {
      model.setMinimum2MillionInsurancePresentColor(Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(
          MySnackBar(message: 'Insurance is required', error: true)
              .getSnackbar());
    } else if (model.minimum2MillionInsurancePresent == 'No' &&
        model.minimum1MillionInsurancePresent == 'No') {
      model.setMinimum1MillionInsurancePresentColor(Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(
          MySnackBar(message: 'Insurance is required', error: true)
              .getSnackbar());
    } else if (_formKey.currentState!.validate()) {
      if (model.selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                message: 'Please upload image before submitting', error: true)
            .getSnackbar());
      } else {
        model.setIsSubmitting(true);
        var formData = {
          'two_million_insurance':
              (model.minimum2MillionInsurancePresent == 'Yes').toString(),
          'one_million_insurance':
              (model.minimum1MillionInsurancePresent == 'Yes').toString(),
          'expiry_date': model.epochString,
        };
        List<File?>? fileList = [model.selectedFile];
        List<String?>? imageFieldName = ['image'];
        futureData = PutClient.request(apiUrl, formData, model, (response) {},
            imageFiles: fileList, imageFieldName: imageFieldName);
      }
    }
  }
}
