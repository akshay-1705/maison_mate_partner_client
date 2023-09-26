import 'package:flutter/material.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';

class Insurance extends StatefulWidget {
  const Insurance({Key? key}) : super(key: key);

  @override
  State<Insurance> createState() => _InsuranceState();
}

class _InsuranceState extends State<Insurance> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar.show(
            context, "Insurance", const Icon(Icons.arrow_back)),
        body: WillPopScope(
            onWillPop: () async {
              return Future.value(false);
            },
            child: SingleChildScrollView(
                child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Form(
                        key: _formKey,
                        child: const AbsorbPointer(
                            absorbing: false,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [])))))));
  }
}
