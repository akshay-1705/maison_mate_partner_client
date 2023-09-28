import 'package:flutter/material.dart';
import 'package:maison_mate/network/client/post_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/documentation/insurance_model.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => InsuranceModel(),
        child: Scaffold(
          appBar: CustomAppBar.show(
              context, "Insurance", const Icon(Icons.arrow_back)),
          body: WillPopScope(
            onWillPop: () async {
              return Future.value(false);
            },
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(5.0),
                child: Consumer<InsuranceModel>(
                    builder: (context, banking, child) {
                  final InsuranceModel model =
                      Provider.of<InsuranceModel>(context);
                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        MyForm.formFieldHeader(
                            'Do you have the minimum of a £2 million Public Liability insurance?*',
                            model.minimum2MillionInsurancePresentColor),
                        MyForm.buildRadioButtons(['Yes', 'No'],
                            model.minimum2MillionInsurancePresent, (value) {
                          if (value == 'Yes') {
                            // registeredNameController.text = '';
                          }
                          model.setMinimum2MillionInsurancePresent(value);
                        }),
                        if (model.minimum2MillionInsurancePresent == 'No') ...[
                          MyForm.formFieldHeader(
                              'Do you have the minimum of a £1 million Public Liability insurance?*',
                              model.minimum1MillionInsurancePresentColor),
                          MyForm.buildRadioButtons(
                              ['Yes'], model.minimum1MillionInsurancePresent,
                              (value) {
                            model.setMinimum1MillionInsurancePresent(value);
                          }),
                        ],
                        MyForm.formFieldHeader(
                            'When does Public Liability insurance expire?*'),
                        MyForm.datePickerFormField('DD/MM/YYYY',
                            insuranceExpiryDateController, context, model),
                        MyForm.formFieldHeader(
                            'Attach a copy of your public liability insurance. Please make sure the company name, limit of insurance, and expiry date are all visible.*'),
                        MyForm.uploadImageSection(model),
                        const SizedBox(height: 20),
                        (futureData != null)
                            ? PostClient.futureBuilder(
                                model,
                                futureData!,
                                "Submit",
                                () async {
                                  onSubmitCallback(model);
                                },
                                () {},
                              )
                            : MyForm.submitButton("Submit", () async {
                                onSubmitCallback(model);
                              }),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ));
  }

  void onSubmitCallback(InsuranceModel model) {
    if (_formKey.currentState!.validate()) {
      if (model.minimum2MillionInsurancePresent == '') {
        model.setMinimum2MillionInsurancePresentColor(Colors.red);
        ScaffoldMessenger.of(context).showSnackBar(
            MySnackBar(message: 'Insurance is required', error: true)
                .getSnackbar());
      } else if (model.minimum2MillionInsurancePresent == 'No' &&
          model.minimum1MillionInsurancePresent == '') {
        model.setMinimum2MillionInsurancePresentColor(Colors.black);
        model.setMinimum1MillionInsurancePresentColor(Colors.red);
        ScaffoldMessenger.of(context).showSnackBar(
            MySnackBar(message: 'Insurance is required', error: true)
                .getSnackbar());
      } else if (model.selectedFile == null) {
        model.setMinimum2MillionInsurancePresentColor(Colors.black);
        model.setMinimum1MillionInsurancePresentColor(Colors.black);
        ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                message: 'Please upload image before submitting', error: true)
            .getSnackbar());
      } else {
        model.setIsSubmitting(true);
        var formData = {
          'minimum_two_million_insurance':
              model.minimum2MillionInsurancePresent == 'Yes',
          'minimum_one_million_insurance':
              model.minimum1MillionInsurancePresent == 'Yes',
          'expiry_date_in_epoch': model.epochString,
          'file': model.selectedFile,
        };
        // TODO: Update URL
        futureData = PostClient.request('', formData, model, (response) {});
      }
    }
  }
}
