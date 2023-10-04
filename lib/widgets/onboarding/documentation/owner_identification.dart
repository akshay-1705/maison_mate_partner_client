import 'package:flutter/material.dart';
import 'package:maison_mate/provider/documentation/insurance_model.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:provider/provider.dart';

class OwnerIdentification extends StatefulWidget {
  final bool limited;
  const OwnerIdentification({Key? key, required this.limited})
      : super(key: key);

  @override
  State<OwnerIdentification> createState() => _OwnerIdentificationState();
}

class _OwnerIdentificationState extends State<OwnerIdentification> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController insuranceExpiryDateController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final InsuranceModel model = Provider.of<InsuranceModel>(context);
    return Scaffold(
      appBar: CustomAppBar.show(
          context, "Owner identification", const Icon(Icons.arrow_back)),
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
              child: AbsorbPointer(
                  absorbing: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      MyForm.formFieldHeader('Are you VAT registered?*'),
                      MyForm.buildRadioButtons(['Yes', 'No'], '', (value) {}),
                      MyForm.header('Identity Verification'),
                      if (widget.limited) ...[
                        renderCompanyForm(model)
                      ] else ...[
                        renderSoloTraderForm(model)
                      ]
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Widget renderCompanyForm(InsuranceModel model) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      MyForm.formFieldHeader(
          'We need details of one (this may be you) and a maximum of three beneficial owners. Make sure you have their permission to submit their details. A beneficial owner owns 25% or more of the company and/or exercises significant control.'),
      MyForm.formFieldHeader(
          'Are you a beneficial owner with financial authority for this company?'),
      MyForm.buildRadioButtons(['Yes', 'No'], '', (value) {}),
      MyForm.formFieldHeader('Date of birth'),
      MyForm.datePickerFormField('DD/MM/YYYY', insuranceExpiryDateController,
          context, model, DateTime.now()),
      MyForm.formFieldHeader(
          'Attach proof of ID, a photo or scan of your DRIVING LICENCE or PASSPORT (only jpeg and png file types are supported)'),
      MyForm.uploadImageSection(model),
      MyForm.formFieldHeader(
          'Attach proof of address, a photo or scan of your UTILITY BILL or PERSONAL BANK STATEMENT (only jpeg and png file types are supported).'),
      MyForm.uploadImageSection(model),
      const SizedBox(height: 20),
      MyForm.formFieldHeader('Add a second Beneficial Owner?'),
      MyForm.buildRadioButtons(['Yes', 'No'], '', (value) {}),
      const SizedBox(height: 40),
      MyForm.submitButton("Submit", () async {}),
      const SizedBox(height: 40),
    ]);
  }

  Widget renderSoloTraderForm(InsuranceModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MyForm.formFieldHeader(
            'Please provide additional details to enable us to verify your identity.'),
        MyForm.formFieldHeader('Date of birth'),
        MyForm.datePickerFormField('DD/MM/YYYY', insuranceExpiryDateController,
            context, model, DateTime.now()),
        MyForm.formFieldHeader(
            'Attach proof of ID, a photo or scan of your DRIVING LICENCE or PASSPORT (only jpeg and png file types are supported)'),
        MyForm.uploadImageSection(model),
        MyForm.formFieldHeader(
            'Attach proof of address, a photo or scan of your UTILITY BILL or PERSONAL BANK STATEMENT (only jpeg and png file types are supported).'),
        MyForm.uploadImageSection(model),
        const SizedBox(height: 40),
        MyForm.submitButton("Submit", () async {}),
        const SizedBox(height: 40),
      ],
    );
  }
}
