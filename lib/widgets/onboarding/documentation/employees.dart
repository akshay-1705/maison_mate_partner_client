import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/client/put_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/documentation/employees_response.dart';
import 'package:maison_mate/provider/documentation/employees_model.dart';
import 'package:maison_mate/services/file_upload_service.dart';
import 'package:maison_mate/services/verification_status_service.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/image_helper.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:provider/provider.dart';

class Employees extends StatefulWidget {
  const Employees({Key? key}) : super(key: key);

  @override
  State<Employees> createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<ApiResponse>? futureData;
  final TextEditingController insuranceExpiryDateController =
      TextEditingController();
  late Future<ApiResponse> getFutureData;
  static String apiUrl = '$baseApiUrl/partners/onboarding/employee';

  @override
  void initState() {
    super.initState();
    getFutureData = GetClient.fetchData(apiUrl);
    getFutureData.then((apiResponse) {
      if (mounted) {
        var stateModel = Provider.of<EmployeesModel>(context, listen: false);

        if (apiResponse.data.insuranceExpiryDate == null) {
          stateModel.epochString =
              DateTime.now().millisecondsSinceEpoch.toString();
        } else {
          stateModel.epochString =
              apiResponse.data.insuranceExpiryDate.toString();
          insuranceExpiryDateController.text =
              DateTime.fromMillisecondsSinceEpoch(
                      apiResponse.data.insuranceExpiryDate)
                  .toString();
        }

        stateModel.employeesPresent =
            apiResponse.data.employeesPresent == true ? 'Yes' : 'No';
        stateModel.minimum5MillionInsurancePresent =
            apiResponse.data.liabilityInsurance == true ? 'Yes' : 'No';
        ImageHelper.initialize(apiResponse.data.image, stateModel, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final EmployeesModel model = Provider.of<EmployeesModel>(context);
    return Scaffold(
        appBar: CustomAppBar.show(
            context, "Employees", const Icon(Icons.arrow_back)),
        body: GetRequestFutureBuilder<dynamic>(
          apiUrl: apiUrl,
          future: getFutureData,
          builder: (context, data) {
            return renderForm(context, model, data);
          },
        ));
  }

  Widget renderForm(
      BuildContext context, EmployeesModel model, EmployeesResponse data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(5.0),
      child: WillPopScope(
        onWillPop: () async {
          bool confirm = await CustomAppBar.showConfirmationDialog(
              context, "Are you sure you want to leave this page?");
          if (confirm) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
          }
          return Future.value(false);
        },
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(children: [
              const SizedBox(height: 10),
              VerificationStatusService.showInfoContainer(data.status ?? '',
                  data.reasonForRejection ?? '', 'Employees Details'),
              Form(
                key: _formKey,
                child: AbsorbPointer(
                    absorbing: model.isSubmitting,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        MyForm.formFieldHeader('Do you have any employees?',
                            model.employeesPresentColor),
                        MyForm.buildRadioButtons(
                            ['Yes', 'No'], model.employeesPresent, (value) {
                          model.setEmployeesPresentColor(Colors.black);
                          model.setEmployeesPresent(value);
                        }),
                        if (model.employeesPresent == 'Yes') ...[
                          MyForm.formFieldHeader(
                              "Do you have a minimum of £5 million employers' liability insurance?*",
                              model.minimum5MillionInsurancePresentColor),
                          MyForm.buildRadioButtons(
                              ['Yes'], model.minimum5MillionInsurancePresent,
                              (value) {
                            model.setMinimum5MillionInsurancePresentColor(
                                Colors.black);
                            model.setMinimum5MillionInsurancePresent(value);
                          }),
                          MyForm.formFieldHeader(
                              "When does your employers' liability insurance expire?*"),
                          MyForm.datePickerFormField(
                              'DD/MM/YYYY',
                              insuranceExpiryDateController,
                              context,
                              model,
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(model.epochString))),
                          MyForm.formFieldHeader(
                              "Attach a copy of your employers' liability insurance. Please make sure the company name, limit of insurance, and expiry date are all visible.*"),
                          FileUploadService.showWidget(
                              context, model.selectedFile, (File file) {
                            model.setSelectedFile(file);
                          }),
                        ],
                        const SizedBox(height: 20),
                        (futureData != null)
                            ? PutClient.futureBuilder(
                                model,
                                futureData!,
                                "Submit",
                                () async {
                                  String message = VerificationStatusService
                                      .getPromptMessage(data.status ?? '',
                                          'Employees Details');
                                  bool confirm =
                                      await CustomAppBar.showConfirmationDialog(
                                          context, message);
                                  if (confirm) {
                                    onSubmitCallback(model);
                                  }
                                },
                                () {
                                  Navigator.of(context).pop();
                                },
                              )
                            : MyForm.submitButton("Submit", () async {
                                String message =
                                    VerificationStatusService.getPromptMessage(
                                        data.status ?? '', 'Employees Details');
                                bool confirm =
                                    await CustomAppBar.showConfirmationDialog(
                                        context, message);
                                if (confirm) {
                                  onSubmitCallback(model);
                                }
                              }),
                        const SizedBox(height: 40),
                      ],
                    )),
              )
            ])),
      ),
    );
  }

  void onSubmitCallback(EmployeesModel model) {
    if (model.employeesPresent == '') {
      model.setEmployeesPresentColor(Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(
          MySnackBar(message: 'Employees selection is required', error: true)
              .getSnackbar());
    } else if (model.employeesPresent == 'Yes' &&
        model.minimum5MillionInsurancePresent == 'No') {
      model.setMinimum5MillionInsurancePresentColor(Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(
          MySnackBar(message: 'Insurance is required', error: true)
              .getSnackbar());
    } else if (_formKey.currentState!.validate()) {
      if (model.employeesPresent == 'Yes' && model.selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                message: 'Please upload image before submitting', error: true)
            .getSnackbar());
      } else {
        if (_formKey.currentState!.validate()) {
          model.setIsSubmitting(true);

          if (model.employeesPresent == 'No') {
            model.minimum5MillionInsurancePresent = 'No';
            model.epochString = '';
          }
          var formData = {
            'employees_present': (model.employeesPresent == 'Yes').toString(),
            'liability_insurance':
                (model.minimum5MillionInsurancePresent == 'Yes').toString(),
            'insurance_expiry_date': model.epochString,
          };
          List<File?>? fileList = [model.selectedFile];
          List<String?>? imageFieldName = ['insurance_proof'];
          futureData = PutClient.request(apiUrl, formData, model, (response) {},
              imageFiles: fileList, imageFieldName: imageFieldName);
        }
      }
    }
  }
}
