import 'package:flutter/material.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/client/post_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/your_details_response.dart';
import 'package:maison_mate/provider/onboarding_model.dart';
import 'package:maison_mate/provider/your_details_model.dart';
import 'package:provider/provider.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class YourDetailsSection extends StatefulWidget {
  final OnboardingModel onboardingModel;
  const YourDetailsSection({Key? key, required this.onboardingModel})
      : super(key: key);

  @override
  State<YourDetailsSection> createState() => _YourDetailsSectionState();
}

class _YourDetailsSectionState extends State<YourDetailsSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController registeredNameController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController servicePostcodesController =
      TextEditingController();
  late Future<ApiResponse<YourDetailsResponse>> futureData;
  Future<ApiResponse>? postFutureData;
  var authToken = "";
  static const String apiUrl = '$baseApiUrl/partners/your_details';
  List<MultiSelectItem> postcodes = [];
  List<String> availableServices = [];
  List<String> formSelectedPostcodes = [];

  List<Row> serviceRows = [];
  int servicesPerRow = 2; // Number of services checkboxes per row

  @override
  void initState() {
    super.initState();
    futureData = GetClient.fetchData(apiUrl);
    initializeFormData();
  }

  void initializeFormData() {
    futureData.then((apiResponse) {
      var stateModel = Provider.of<YourDetailsModel>(context, listen: false);
      final YourDetailsResponse data = apiResponse.data;
      availableServices = data.servicesAvailable!;
      stateModel.selectedServices = data.servicesOffered!.toSet();

      postcodes = data.postcodesAvailable!.map((String postcode) {
        return MultiSelectItem<String>(postcode, postcode);
      }).toList();

      stateModel.selectedPostcodes = data.postcodesCovered!.cast<String>();
      formSelectedPostcodes = data.postcodesCovered!;

      stateModel.selectedValue =
          data.isLimited == true ? 'Limited' : 'Self Trader';

      firstNameController.text = data.firstName;
      lastNameController.text = data.lastName;
      emailController.text = data.email!;
      companyNameController.text = data.companyTradingName!;
      registeredNameController.text = data.companyRegisteredName!;
      addressController.text = data.addressDetails!;
      cityController.text = data.city!;
      countryController.text = data.country!;
      postcodeController.text = data.postcode!;
      phoneNumberController.text = data.phoneNumber!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final YourDetailsModel model = Provider.of<YourDetailsModel>(context);
    serviceRows = [];
    createServiceCheckboxes(model, serviceRows);

    return Scaffold(
        body: GetRequestFutureBuilder<dynamic>(
      future: futureData,
      builder: (context, data) {
        return renderData(context, model, data);
      },
    ));
  }

  Widget renderData(
      BuildContext context, YourDetailsModel model, YourDetailsResponse data) {
    return Center(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(5.0),
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
                        MyForm.formFieldHeader('Select Tradesmen Type*'),
                        MyForm.buildRadioButtons(
                          ['Self Trader', 'Limited'],
                          model.selectedValue,
                          (value) {
                            if (value == 'Limited') {
                              registeredNameController.text = '';
                            }
                            model.selectedValue = value;
                          },
                        ),
                        MyForm.requiredTextField(
                            "Company Name", companyNameController),
                        if (model.selectedValue == 'Limited') ...[
                          MyForm.requiredTextField(
                            "Company Registered Name (if different)",
                            registeredNameController,
                          ),
                        ],
                        const SizedBox(height: 12.0),
                        MyForm.formFieldHeader('Address*'),
                        MyForm.multilineRequiredTextField(
                            "Address", addressController),
                        MyForm.inlineRequiredDisabledTextFields(
                          "Town/City",
                          "Country",
                          cityController,
                          countryController,
                        ),
                        MyForm.requiredTextField(
                            "Postcode", postcodeController),
                        const SizedBox(height: 12.0),
                        MyForm.formFieldHeader('Personal Details*'),
                        MyForm.inlineRequiredTextFields(
                          "First Name",
                          "Last Name",
                          firstNameController,
                          lastNameController,
                        ),
                        MyForm.inlineRequiredTextFields(
                          "Phone Number",
                          "Email",
                          phoneNumberController,
                          emailController,
                        ),
                        const SizedBox(height: 12.0),
                        MyForm.formFieldHeader(
                            'Which postcodes or towns do you cover?*'),
                        MyForm.multiSelectField(
                            postcodes,
                            const Text("Postcodes"),
                            "Enter postcodes like (EB3 5DJ, E14 OBQ)",
                            (results) {
                          model.selectedPostcodes = results;
                        }, Icons.location_city, formSelectedPostcodes),
                        const SizedBox(height: 12.0),
                        MyForm.formFieldHeader(
                            'Which services can you offer?*'),
                        if (model.formSubmitted &&
                            model.selectedServices.isEmpty) ...[
                          const Text(
                            'Select at least one service', // Validation message
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                        Column(
                          children: serviceRows,
                        ),
                        const SizedBox(height: 16.0),
                        (postFutureData != null)
                            ? PostClient.futureBuilder(
                                model,
                                postFutureData!,
                                "Submit",
                                () async {
                                  onSubmitCallback(model);
                                },
                                () {
                                  widget.onboardingModel.setCurrentIndex(1);
                                },
                              )
                            : MyForm.submitButton("Submit", () async {
                                onSubmitCallback(model);
                              }),
                        const SizedBox(height: 30.0)
                      ]),
                ),
              ),
            )));
  }

  void onSubmitCallback(YourDetailsModel model) {
    model.setFormSubmitted(true);
    if (_formKey.currentState!.validate()) {
      if (model.selectedServices.isNotEmpty) {
        model.setIsSubmitting(true);
        var formData = {
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'email': emailController.text,
          'phone_number': phoneNumberController.text,
          'company_trading_name': companyNameController.text,
          'company_registered_name': registeredNameController.text,
          'is_limited': model.selectedValue == 'Limited',
          'address_details': addressController.text,
          'postcode': postcodeController.text,
          'city': cityController.text,
          'country': countryController.text,
          'services_offered': model.selectedServices.toList(),
          'postcodes_covered': model.selectedPostcodes.toList(),
        };
        postFutureData =
            PostClient.request(apiUrl, formData, model, (response) {});
      }
    }
  }

  void createServiceCheckboxes(YourDetailsModel model, List<Row> serviceRows) {
    for (int i = 0; i < availableServices.length; i += servicesPerRow) {
      List<Widget> rowChildren = [];
      for (int j = i;
          j < i + servicesPerRow && j < availableServices.length;
          j++) {
        final service = availableServices[j];
        rowChildren.add(
          Expanded(
            child: CheckboxListTile(
              dense: true, // Reduce vertical spacing
              controlAffinity: ListTileControlAffinity
                  .leading, // Position checkbox to the start
              title: Text(service),
              value: model.selectedServices.contains(service),
              onChanged: (value) {
                if (value != null && value == true) {
                  model.addSelectedServices(service);
                } else {
                  model.removeSelectedServices(service);
                }
              },
            ),
          ),
        );
      }

      serviceRows.add(Row(
        children: rowChildren,
      ));
    }
  }
}
