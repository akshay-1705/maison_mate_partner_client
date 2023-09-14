import 'package:flutter/material.dart';
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
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController servicePostcodesController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final YourDetails model = Provider.of<YourDetails>(context);
    List<MultiSelectItem> pincodes = [];

    return Scaffold(
      body: SingleChildScrollView(
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
                Container(
                    padding:
                        const EdgeInsets.only(left: 6, right: 6, bottom: 6),
                    child: MultiSelectDialogField(
                      items: pincodes,
                      title: const Text("Postcodes"),
                      searchable: true,
                      selectedColor: const Color(themeColor),
                      validator: (value) {
                        if ((value == null || value.isEmpty)) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      buttonIcon: const Icon(
                        Icons.location_city,
                        color: Color(themeColor),
                      ),
                      buttonText: const Text(
                        "Enter postcodes like (EB3 5DJ, E14 OBQ)",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      onConfirm: (results) {},
                    )),
                const SizedBox(height: 12.0),
                formFieldHeader('Which services can you offer?*'),
                const SizedBox(height: 16.0),
                submitButton(model),
                const SizedBox(height: 56.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget submitButton(YourDetails model) {
    return SizedBox(
        width: 125,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final formData = {
                'tradesmenType': model.selectedValue,
                'companyName': companyNameController.text,
                'registeredName': registeredNameController.text,
              };
              print(formData);
            }
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(color: Color(themeColor)),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color(themeColor),
            ),
          ),
          child: const Text('Submit',
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ));
  }
}
