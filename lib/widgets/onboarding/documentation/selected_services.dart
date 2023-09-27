import 'package:flutter/material.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/forms.dart';

class SelectedServices extends StatefulWidget {
  const SelectedServices({Key? key}) : super(key: key);

  @override
  State<SelectedServices> createState() => _SelectedServicesState();
}

class _SelectedServicesState extends State<SelectedServices> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController yearsExperienceController =
      TextEditingController();
  final TextEditingController hourlyRateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.show(
          context, "Selected services", const Icon(Icons.arrow_back)),
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
                      'How many years’ experience do you have as a Handyman?'),
                  requiredTextField(
                      "Enter your experience*", yearsExperienceController),
                  formFieldHeader('What is your hourly rate?'),
                  requiredTextField(
                      "Enter your hourly rate*", hourlyRateController),
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
