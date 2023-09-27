import 'package:flutter/material.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/my_form.dart';

class PlatformRulesAcceptance extends StatefulWidget {
  const PlatformRulesAcceptance({Key? key}) : super(key: key);

  @override
  State<PlatformRulesAcceptance> createState() =>
      _PlatformRulesAcceptanceState();
}

class _PlatformRulesAcceptanceState extends State<PlatformRulesAcceptance> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.show(
        context,
        "Platform rules acceptance",
        const Icon(Icons.arrow_back),
      ),
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
                  MyForm.checkbox(
                    'Have the right to work in the UK',
                    false,
                  ),
                  MyForm.checkbox(
                    'Do not have any criminal offences which are currently unspent under the Rehabilitation of Offenders Act 1974',
                    false,
                  ),
                  MyForm.checkbox(
                    'Agree to the Maison Mate, Terms of Use, Commercial Terms and Code of Conduct, and that you will follow the processes set out within them',
                    false,
                  ),
                  const SizedBox(height: 20),
                  MyForm.submitButton("Submit", () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
