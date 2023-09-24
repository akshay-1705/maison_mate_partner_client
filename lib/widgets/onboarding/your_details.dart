import 'package:flutter/material.dart';
import 'package:maison_mate/network/request/get_request.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/your_details_response.dart';
import 'package:maison_mate/states/your_details.dart';
import 'package:provider/provider.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/shared/forms.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class YourDetailsSection extends StatefulWidget {
  const YourDetailsSection({Key? key}) : super(key: key);

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
  var authToken = "";
  static const String apiUrl = '$baseApiUrl/partners/your_details';
  List<MultiSelectItem> pincodes = [];
  List<String> availableServices = [];

  List<Row> serviceRows = [];
  int servicesPerRow = 2; // Number of services checkboxes per row

  @override
  void initState() {
    super.initState();
    futureData = fetchData(apiUrl);
    initializeFormData();
  }

  void initializeFormData() {
    futureData.then((apiResponse) {
      var stateModel = Provider.of<YourDetails>(context, listen: false);
      final YourDetailsResponse data = apiResponse.data;
      availableServices = data.servicesAvailable!;

      pincodes = data.postcodesAvailable!.map((String postcode) {
        return MultiSelectItem<String>(postcode, postcode);
      }).toList();

      stateModel.selectedValue =
          data.isLimited == true ? 'Limited' : 'Self Trader';

      firstNameController.text = data.firstName;
      lastNameController.text = data.lastName;
      emailController.text = data.email!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final YourDetails model = Provider.of<YourDetails>(context);
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
      BuildContext context, YourDetails model, YourDetailsResponse data) {
    return Center(
        child: SingleChildScrollView(
            child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            formFieldHeader('Select Tradesmen Type*'),
            buildRadioButtons(
              ['Self Trader', 'Limited'],
              model.selectedValue,
              (value) {
                if (value == 'Limited') {
                  registeredNameController.text = '';
                }
                model.selectedValue = value;
              },
            ),
            requiredTextField("Company Name", companyNameController),
            if (model.selectedValue == 'Limited') ...[
              requiredTextField(
                "Company Registered Name (if different)",
                registeredNameController,
              ),
            ],
            const SizedBox(height: 12.0),
            formFieldHeader('Address*'),
            multilineRequiredTextField("Address", addressController),
            inlineRequiredTextFields(
              "Town/City",
              "Country",
              cityController,
              countryController,
            ),
            requiredTextField("Postcode", postcodeController),
            const SizedBox(height: 12.0),
            formFieldHeader('Personal Details*'),
            inlineRequiredTextFields(
              "First Name",
              "Last Name",
              firstNameController,
              lastNameController,
            ),
            inlineRequiredTextFields(
              "Phone Number",
              "Email",
              phoneNumberController,
              emailController,
            ),
            const SizedBox(height: 12.0),
            formFieldHeader('Which postcodes or towns do you cover?*'),
            multiSelectField(pincodes, const Text("Postcodes"),
                "Enter postcodes like (EB3 5DJ, E14 OBQ)", (results) {
              model.selectedPostcodes = results;
            }),
            const SizedBox(height: 12.0),
            formFieldHeader('Which services can you offer?*'),
            if (model.formSubmitted && model.selectedServices.isEmpty) ...[
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
            submitButton(model, () {
              model.setFormSubmitted(true);
              if (_formKey.currentState!.validate()) {
                if (model.selectedServices.isNotEmpty) {
                  final formData = {
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
                    'services_offered': model.selectedServices,
                    'postcodes_covered': model.selectedPostcodes,
                  };
                  print(formData);
                }
              }
            }),
            const SizedBox(height: 56.0),
          ],
        ),
      ),
    )));
  }

  void createServiceCheckboxes(YourDetails model, List<Row> serviceRows) {
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
