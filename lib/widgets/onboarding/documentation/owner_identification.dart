import 'package:flutter/material.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';

class OwnerIdentification extends StatefulWidget {
  const OwnerIdentification({Key? key}) : super(key: key);

  @override
  State<OwnerIdentification> createState() => _OwnerIdentificationState();
}

class _OwnerIdentificationState extends State<OwnerIdentification> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
