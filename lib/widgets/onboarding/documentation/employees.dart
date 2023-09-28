import 'package:flutter/material.dart';
import 'package:maison_mate/network/client/post_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/documentation/employees_model.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => EmployeesModel(),
        child: Scaffold(
          appBar: CustomAppBar.show(
              context, "Employees", const Icon(Icons.arrow_back)),
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
                child: Consumer<EmployeesModel>(
                    builder: (context, banking, child) {
                  final EmployeesModel model =
                      Provider.of<EmployeesModel>(context);
                  return Form(
                    key: _formKey,
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
                          MyForm.datePickerFormField('DD/MM/YYYY',
                              insuranceExpiryDateController, context, model),
                          MyForm.formFieldHeader(
                              'Attach a copy of your public liability insurance. Please make sure the company name, limit of insurance, and expiry date are all visible.*'),
                          MyForm.uploadImageSection(model),
                        ],
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

  void onSubmitCallback(EmployeesModel model) {
    if (model.employeesPresent == '') {
      model.setEmployeesPresentColor(Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(
          MySnackBar(message: 'Employees selection is required', error: true)
              .getSnackbar());
    } else if (model.employeesPresent == 'Yes' &&
        model.minimum5MillionInsurancePresent == '') {
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
          var formData = {
            'employess_present': model.employeesPresent == 'Yes',
            'minimum_five_million_insurance':
                model.minimum5MillionInsurancePresent == 'Yes',
            'expiry_date_in_epoch': model.epochString,
            'file': model.selectedFile,
          };
          // TODO: Update URL
          futureData = PostClient.request('', formData, model, (response) {});
        }
      }
    }
  }
}
