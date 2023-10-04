import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/client/put_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/documentation/self_trader_identification_model.dart';
import 'package:maison_mate/shared/image_helper.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:maison_mate/widgets/onboarding/onboarding.dart';
import 'package:provider/provider.dart';

class SelfTraderIdentification extends StatefulWidget {
  const SelfTraderIdentification({Key? key}) : super(key: key);

  @override
  State<SelfTraderIdentification> createState() =>
      _SelfTraderIdentificationState();
}

class _SelfTraderIdentificationState extends State<SelfTraderIdentification> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController vatNumberController = TextEditingController();
  late Future<ApiResponse> getFutureData;
  Future<ApiResponse>? futureData;
  static const String apiUrl = '$baseApiUrl/partners/onboarding/self_trader';

  @override
  void initState() {
    super.initState();
    getFutureData = GetClient.fetchData(apiUrl);

    getFutureData.then((apiResponse) {
      if (mounted) {
        var stateModel =
            Provider.of<SelfTraderIdentificationModel>(context, listen: false);
        stateModel.vatRegistered =
            apiResponse.data.vatNumber == '' ? 'No' : 'Yes';
        vatNumberController.text =
            (apiResponse.data.vatNumber ?? '').toString();

        if (apiResponse.data.dateOfBirth == null) {
          stateModel.epochString =
              DateTime.now().millisecondsSinceEpoch.toString();
        } else {
          stateModel.epochString = apiResponse.data.dateOfBirth.toString();
          dobController.text =
              DateTime.fromMillisecondsSinceEpoch(apiResponse.data.dateOfBirth)
                  .toString();
        }

        ImageHelper.customInitialize(apiResponse.data.proofOfId, context,
            (file) {
          stateModel.setSelectedFile1(file);
        }, () {
          stateModel.selectedFile1 = null;
          stateModel.fileName1 = '';
        });

        ImageHelper.customInitialize(apiResponse.data.proofOfAddress, context,
            (file) {
          stateModel.setSelectedFile2(file);
        }, () {
          stateModel.selectedFile2 = null;
          stateModel.fileName2 = '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final SelfTraderIdentificationModel model =
        Provider.of<SelfTraderIdentificationModel>(context);
    return GetRequestFutureBuilder<dynamic>(
      future: getFutureData,
      builder: (context, data) {
        return renderForm(model, context);
      },
    );
  }

  Widget renderForm(SelfTraderIdentificationModel model, BuildContext context) {
    return Form(
      key: _formKey,
      child: AbsorbPointer(
          absorbing: model.isSubmitting,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              MyForm.formFieldHeader('Are you VAT registered?*'),
              MyForm.buildRadioButtons(['Yes', 'No'], model.vatRegistered,
                  (value) {
                model.setVatRegistered(value);
              }),
              if (model.vatRegistered == 'Yes') ...[
                MyForm.requiredTextField(
                    "What is your VAT number?*", vatNumberController)
              ],
              MyForm.header('Identity Verification'),
              MyForm.formFieldHeader(
                  'Please provide additional details to enable us to verify your identity.'),
              MyForm.formFieldHeader('Date of birth'),
              MyForm.datePickerFormField(
                  'DD/MM/YYYY',
                  dobController,
                  context,
                  model,
                  DateTime.fromMillisecondsSinceEpoch(
                      int.parse(model.epochString))),
              MyForm.formFieldHeader(
                  'Attach proof of ID, a photo or scan of your DRIVING LICENCE or PASSPORT (only jpeg and png file types are supported)'),
              Column(children: [
                MyForm.uploadImageButton(() async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );
                  if (result != null) {
                    model.setSelectedFile1(File(result.files.single.path!));
                  }
                }),
                if (model.selectedFile1 != null)
                  MyForm.showSelectedImage(model.selectedFile1!)
              ]),
              MyForm.formFieldHeader(
                  'Attach proof of address, a photo or scan of your UTILITY BILL or PERSONAL BANK STATEMENT (only jpeg and png file types are supported).'),
              Column(children: [
                MyForm.uploadImageButton(() async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );
                  if (result != null) {
                    model.setSelectedFile2(File(result.files.single.path!));
                  }
                }),
                if (model.selectedFile2 != null)
                  MyForm.showSelectedImage(model.selectedFile2!)
              ]),
              const SizedBox(height: 40),
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
                              builder: (context) => const OnboardingWidget(
                                  yourDetailsSection: true)),
                        );
                      },
                    )
                  : MyForm.submitButton("Submit", () async {
                      onSubmitCallback(model);
                    }),
              const SizedBox(height: 40),
            ],
          )),
    );
  }

  void onSubmitCallback(SelfTraderIdentificationModel model) {
    if (_formKey.currentState!.validate()) {
      if (model.selectedFile1 == null && model.selectedFile2 == null) {
        ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                message: 'Please upload images before submitting', error: true)
            .getSnackbar());
      } else {
        model.setIsSubmitting(true);
        var formData = {
          'vat_number': vatNumberController.text,
          'date_of_birth': model.epochString,
        };
        List<File?>? fileList = [model.selectedFile1, model.selectedFile2];
        List<String?>? imageFieldName = ['proof_of_id', 'proof_of_address'];
        futureData = PutClient.request(apiUrl, formData, model, (response) {},
            imageFiles: fileList, imageFieldName: imageFieldName);
      }
    }
  }
}
