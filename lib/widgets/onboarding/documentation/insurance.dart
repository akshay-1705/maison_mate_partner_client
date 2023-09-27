import 'package:flutter/material.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/forms.dart';

class Insurance extends StatefulWidget {
  const Insurance({Key? key}) : super(key: key);

  @override
  State<Insurance> createState() => _InsuranceState();
}

class _InsuranceState extends State<Insurance> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController insuranceExpiryDateController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar.show(context, "Insurance", const Icon(Icons.arrow_back)),
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  formFieldHeader(
                      'Do you have the minimum of a £2 million Public Liability insurance?'),
                  buildRadioButtons(['Yes', 'No'], 'Yes', (value) {}),
                  formFieldHeader(
                      'When does Public Liability insurance expire?*'),
                  datePickerFormField(
                      'DD/MM/YYYY', insuranceExpiryDateController, context),
                  formFieldHeader(
                      'Attach a copy of your public liability insurance. Please make sure the company name, limit of insurance, and expiry date are all visible.*'),
                  // uploadImageButton(),
                  const SizedBox(height: 20),
                  submitButton("Submit", () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
