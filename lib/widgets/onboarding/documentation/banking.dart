import 'package:flutter/material.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/forms.dart';

class Banking extends StatefulWidget {
  const Banking({Key? key}) : super(key: key);

  @override
  State<Banking> createState() => _BankingState();
}

class _BankingState extends State<Banking> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController sortCodeController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar.show(context, "Banking", const Icon(Icons.arrow_back)),
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(5.0), // Add padding to the whole content
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .stretch, // Stretch widgets to fill the screen width
                children: [
                  const SizedBox(height: 10),
                  formFieldHeader('Bank Details'),
                  inlineRequiredTextFields(
                    'Bank Name*',
                    'Sort code*',
                    bankNameController,
                    sortCodeController,
                  ),
                  requiredTextField("Account Number*", accountNumberController),
                  const SizedBox(height: 25),
                  formFieldHeader(
                    'Attach a photo of your bank proof. This can include any of the following:',
                  ),
                  const SizedBox(height: 10), // Add some space
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildBulletPoint('Top-half of bank statement'),
                        const SizedBox(height: 10),
                        buildBulletPoint('Paying-in slip'),
                        const SizedBox(height: 10),
                        buildBulletPoint('Screenshot of mobile banking'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  uploadImageButton(),
                  const SizedBox(height: 50),
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
