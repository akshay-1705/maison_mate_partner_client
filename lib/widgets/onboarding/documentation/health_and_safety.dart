import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/client/put_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/documentation/health_and_safety_model.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';

class HealthAndSafety extends StatefulWidget {
  const HealthAndSafety({Key? key}) : super(key: key);

  @override
  State<HealthAndSafety> createState() => _HealthAndSafetyState();
}

class _HealthAndSafetyState extends State<HealthAndSafety> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController accidentsInFiveYearsController =
      TextEditingController();
  final TextEditingController noticeInFiveYearsController =
      TextEditingController();
  final TextEditingController injuryInThreeYearsController =
      TextEditingController();
  final TextEditingController damageByCompanyEmployeeController =
      TextEditingController();
  final TextEditingController everBankruptController = TextEditingController();

  Future<ApiResponse>? futureData;
  late Future<ApiResponse> getFutureData;
  static const String apiUrl = '$baseApiUrl/partners/onboarding/health';

  @override
  void initState() {
    super.initState();
    getFutureData = GetClient.fetchData(apiUrl);
    getFutureData.then((apiResponse) {
      if (mounted) {
        var stateModel =
            Provider.of<HealthAndSafetyModel>(context, listen: false);
        stateModel.accidentsInFiveYears =
            apiResponse.data.accidentsInFiveYears == true ? 'Yes' : 'No';
        accidentsInFiveYearsController.text =
            apiResponse.data.accidentsInFiveYearsDetails ?? '';
        stateModel.noticeInFiveYears =
            apiResponse.data.noticeInFiveYears == true ? 'Yes' : 'No';
        noticeInFiveYearsController.text =
            apiResponse.data.noticeInFiveYearsDetails ?? '';
        stateModel.injuryInThreeYears =
            apiResponse.data.injuryInThreeYears == true ? 'Yes' : 'No';
        injuryInThreeYearsController.text =
            apiResponse.data.injuryInThreeYearsDetails ?? '';
        stateModel.damageByCompanyEmployee =
            apiResponse.data.damageByCompanyEmployee == true ? 'Yes' : 'No';
        damageByCompanyEmployeeController.text =
            apiResponse.data.damageByCompanyEmployeeDetails ?? '';
        stateModel.everBankrupt =
            apiResponse.data.everBankrupt == true ? 'Yes' : 'No';
        everBankruptController.text =
            apiResponse.data.everBankruptDetails ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final HealthAndSafetyModel model =
        Provider.of<HealthAndSafetyModel>(context);
    return Scaffold(
        appBar: CustomAppBar.show(
            context, "Health and safety", const Icon(Icons.arrow_back)),
        body: GetRequestFutureBuilder<dynamic>(
          apiUrl: apiUrl,
          future: getFutureData,
          builder: (context, data) {
            return renderForm(context, model);
          },
        ));
  }

  Widget renderForm(BuildContext context, HealthAndSafetyModel model) {
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
                      MyForm.header('Health & Safety'),
                      MyForm.formFieldHeader(
                          'Has your company had any Health & Safety related accidents in the past 5 years?'),
                      MyForm.buildRadioButtons(
                          ['Yes', 'No'], model.accidentsInFiveYears, (value) {
                        model.setAccidentsInFiveYears(value);
                        accidentsInFiveYearsController.text = '';
                      }),
                      if (model.accidentsInFiveYears == 'Yes') ...[
                        MyForm.multilineRequiredTextField(
                            "Please provide details*",
                            accidentsInFiveYearsController),
                      ],
                      MyForm.formFieldHeader(
                          'Has your company had any HSE (Health and Safety Executive) related prosecutions or enforcement notices in the past 5 years?'),
                      MyForm.buildRadioButtons(
                          ['Yes', 'No'], model.noticeInFiveYears, (value) {
                        model.setNoticeInFiveYears(value);
                        noticeInFiveYearsController.text = '';
                      }),
                      if (model.noticeInFiveYears == 'Yes') ...[
                        MyForm.multilineRequiredTextField(
                            "Please provide details*",
                            noticeInFiveYearsController),
                      ],
                      const SizedBox(height: 20),
                      MyForm.header('Accident History in the past 3 years'),
                      MyForm.formFieldHeader(
                          'Has your company had any fatalities, major injuries or +7 day injuries?'),
                      MyForm.buildRadioButtons(
                          ['Yes', 'No'], model.injuryInThreeYears, (value) {
                        model.setInjuryInThreeYears(value);
                        injuryInThreeYearsController.text = '';
                      }),
                      if (model.injuryInThreeYears == 'Yes') ...[
                        MyForm.multilineRequiredTextField(
                            "Please provide details*",
                            injuryInThreeYearsController),
                      ],
                      MyForm.formFieldHeader(
                          'Have you, or any of the company’s employees, ever injured any customers or members of the public?'),
                      MyForm.buildRadioButtons(
                          ['Yes', 'No'], model.damageByCompanyEmployee,
                          (value) {
                        model.setDamageByCompanyEmployee(value);
                        damageByCompanyEmployeeController.text = '';
                      }),
                      if (model.damageByCompanyEmployee == 'Yes') ...[
                        MyForm.multilineRequiredTextField(
                            "Please provide details*",
                            damageByCompanyEmployeeController),
                      ],
                      MyForm.formFieldHeader(
                          'Have you ever been declared bankrupt?'),
                      MyForm.buildRadioButtons(
                          ['Yes', 'No'], model.everBankrupt, (value) {
                        model.setEverBankrupt(value);
                        everBankruptController.text = '';
                      }),
                      if (model.everBankrupt == 'Yes') ...[
                        MyForm.multilineRequiredTextField(
                            "Please provide details*", everBankruptController),
                      ],
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
                                          const OnboardingScreen(
                                              yourDetailsSection: true)),
                                );
                              },
                            )
                          : MyForm.submitButton("Submit", () async {
                              onSubmitCallback(model);
                            }),
                      const SizedBox(height: 40),
                    ],
                  ))),
        ),
      ),
    );
  }

  void onSubmitCallback(HealthAndSafetyModel model) {
    if (_formKey.currentState!.validate()) {
      model.setIsSubmitting(true);
      var formData = {
        'accidents_in_five_years':
            (model.accidentsInFiveYears == 'Yes').toString(),
        'accidents_in_five_years_details': accidentsInFiveYearsController.text,
        'notice_in_five_years': (model.noticeInFiveYears == 'Yes').toString(),
        'notice_in_five_years_details': noticeInFiveYearsController.text,
        'injury_in_three_years': (model.injuryInThreeYears == 'Yes').toString(),
        'injury_in_three_years_details': injuryInThreeYearsController.text,
        'damage_by_company_employee':
            (model.damageByCompanyEmployee == 'Yes').toString(),
        'damage_by_company_employee_details':
            damageByCompanyEmployeeController.text,
        'ever_bankrupt': (model.everBankrupt == 'Yes').toString(),
        'ever_bankrupt_details': everBankruptController.text,
      };
      futureData = PutClient.request(apiUrl, formData, model, (response) {});
    }
  }
}
